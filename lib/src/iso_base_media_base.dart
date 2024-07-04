import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

const _containerBoxes = {
  'moov',
  'trak',
  'mdia',
  'minf',
  'stbl',
  'dinf',
  'edts',
  'udta',
  'mvex',
  'meta',
  'iref',
  'iprp',
  'ipco',
};

const _fullBoxes = {
  'pdin',
  'mvhd',
  'tkhd',
  'trgr',
  'mdhd',
  'nmhd',
  'stsd',
  'stts',
  'cslg',
  'stss',
  'stsh',
  'sdtp',
  'elst',
  'dref',
  'stsz',
  'stz2',
  'stsc',
  'stco',
  'co64',
  'padb',
  'subs',
  'saiz',
  'saio',
  'mehd',
  'tfhd',
  'trun',
  'tfra',
  'mfro',
  'tfdt',
  'leva',
  'trep',
  'assp',
  'sbgp',
  'sgpd',
  'cprt',
  'tsel',
  'kind',
  'meta',
  'xml ',
  'bxml',
  'iloc',
  'pitm',
  'ipro',
  'iinf',
  'mere',
  'iref',
  'schm',
  'fiin',
  'fpar',
  'fecr',
  'gitn',
  'fire',
  'stri',
  'stsg',
  'stvi',
  'trex',
  'hdlr',
  'sidx',
  'ssix',
  'prft',
  'auxC',
};

Future<ISOBox?> _readChildBox(RandomAccessFile file) async {
  final headerOffset = await file.position();
  final sizeBuffer = await file.read(4);
  if (sizeBuffer.length < 4) {
    return null;
  }
  var boxSize = sizeBuffer.buffer.asByteData().getUint32(0);

  final typeBuffer = await file.read(4);
  if (typeBuffer.length < 4) {
    return null;
  }
  final type = String.fromCharCodes(typeBuffer);

  /**
    Note: if any box grows in excess of 2^32 bytes (> 4.2 GB), the box size can be extended
    in increments of 64 bits (18.4 EB).
    By setting the box size to 1 and appending a new 64 bit box size.
    This is why empty 'wide' boxes may be found on either side of this box header for
    future expansion of the sample data.
    By setting the box size to 0, the media data box is open ended and extends to the end
    of the file.
  */
  if (boxSize == 1) {
    final largeSizeBuffer = await file.read(8);
    if (largeSizeBuffer.length < 8) {
      return null;
    }
    boxSize = largeSizeBuffer.buffer.asByteData().getUint64(0);
  } else if (boxSize == 0) {
    boxSize =
        await file.length() - await file.position() + 4 /* Size bytes size */;
  }

  final fullBox = _fullBoxes.contains(type);
  final isContainer = _containerBoxes.contains(type);

  int? fullBoxInt32;
  if (fullBox) {
    final fullBoxInt32Buffer = await file.read(4);
    if (fullBoxInt32Buffer.length < 4) {
      return null;
    }
    fullBoxInt32 = fullBoxInt32Buffer.buffer.asByteData().getUint32(0);
  }

  final dataOffset = await file.position();
  final box = ISOBox(
      boxSize, type, isContainer, file, headerOffset, dataOffset, fullBoxInt32);

  await file.setPosition(dataOffset + box.dataSize);
  return box;
}

/// Base class for ISO boxes.
abstract class ISOBoxBase {
  /// Returns the next child box.
  Future<ISOBox?> nextChild();
}

/// Represents the full box info.
class ISOFullBoxInfo {
  /// The version data in this full box.
  final int version;

  /// The flags data in this full box.
  final int flags;

  ISOFullBoxInfo(this.version, this.flags);

  @override
  String toString() {
    return 'ISOFullBoxInfo{version: $version, flags: $flags}';
  }
}

/// Represents an ISO box.
class ISOBox implements ISOBoxBase {
  /// The size of the box.
  final int boxSize;

  int get headerSize =>
      // 8 bytes for header size.
      8 +
      // 4 bytes for full box data.
      (fullBoxInt32 != null ? 4 : 0);

  /// The size of the data in the box.
  int get dataSize => boxSize - headerSize;

  /// The type of the box.
  final String type;

  /// The file where the box is located.
  final RandomAccessFile _file;

  /// Whether the box is a container.
  final bool isContainer;

  /// The full box data.
  final int? fullBoxInt32;

  /// The offset of the header in the file.
  final int headerOffset;

  /// The offset of the data in the file.
  final int dataOffset;

  /// Current parsing offset.
  late int _currentOffset;

  ISOBox(
    this.boxSize,
    this.type,
    this.isContainer,
    this._file,
    this.headerOffset,
    this.dataOffset,
    this.fullBoxInt32,
  ) {
    _currentOffset = dataOffset;
  }

  @override
  Future<ISOBox?> nextChild() async {
    if (!_containerBoxes.contains(type)) {
      return null;
    }
    if (_currentOffset - dataOffset >= dataSize) {
      return null;
    }
    await _file.setPosition(_currentOffset);
    final box = await _readChildBox(_file);
    _currentOffset = await _file.position();
    return box;
  }

  @override
  String toString() {
    return toDict().toString();
  }

  /// Converts the box to a dictionary.
  Map<String, dynamic> toDict({bool showOffset = false}) {
    final res = <String, dynamic>{
      'boxSize': boxSize,
      'dataSize': dataSize,
      'type': type,
    };
    if (fullBoxInt32 != null) {
      res['fullBoxInt32'] = fullBoxInt32;
    }
    if (showOffset) {
      res['headerOffset'] = headerOffset;
      res['dataOffset'] = dataOffset;
    }
    return res;
  }

  /// Extracts the data from the box.
  Future<Uint8List> extractData() async {
    await _file.setPosition(dataOffset);
    return await _file.read(dataSize);
  }

  /// Returns the full box info.
  ISOFullBoxInfo? getFullBoxInfo() {
    if (fullBoxInt32 == null) {
      return null;
    }
    final version = (fullBoxInt32! >> 24) & 0xff;
    final flags = fullBoxInt32! & 0xffffff;
    return ISOFullBoxInfo(version, flags);
  }
}

/// Can be used to read ISO boxes from a file.
class ISOFileBox implements ISOBoxBase {
  /// Whether the internal random access file can be closed.
  /// If false, the user is responsible for closing the internal file.
  /// This is true when file box is created using [open] method.
  /// And false when created using [openRandomAccessFile] method.
  final bool canClose;

  final RandomAccessFile _file;
  int _offset = 0;

  ISOFileBox._(this._file, this._offset, this.canClose);

  /// Opens a file and returns an instance of [ISOFileBox].
  static Future<ISOFileBox> open(String filePath) async {
    final raf = await File(filePath).open();
    return ISOFileBox._(raf, 0, true);
  }

  static Future<ISOFileBox> openRandomAccessFile(RandomAccessFile raf) async {
    return ISOFileBox._(raf, await raf.position(), false);
  }

  /// Closes the file.
  Future<void> close() async {
    if (canClose) {
      await _file.close();
    }
  }

  @override
  Future<ISOBox?> nextChild() async {
    await _file.setPosition(_offset);
    final box = await _readChildBox(_file);
    _offset = await _file.position();
    return box;
  }
}

Future<List<Object>> _inspectISOBox(
  ISOBoxBase box,
  int depth, {
  FutureOr<void> Function(ISOBox box, int depth)? callback,
  bool? showOffset,
}) async {
  final res = <Object>[];
  if (box is ISOBox) {
    if (callback != null) {
      await callback(box, depth);
    } else {
      res.add(box.toDict(showOffset: showOffset ?? false));
    }
    if (!box.isContainer) {
      return res;
    }
  }
  ISOBox? child;
  do {
    child = await box.nextChild();
    if (child != null) {
      final childInspection = await _inspectISOBox(child, depth + 1,
          callback: callback, showOffset: showOffset);
      if (callback == null) {
        res.add(childInspection);
      }
    }
  } while (child != null);
  return res;
}

/// Inspects an ISO box.
/// Returns all child boxes in a tree structure. If [callback] is not null,
/// it will return an empty list.
Future<List<Object>> inspectISOBox(
  ISOBoxBase box, {
  FutureOr<void> Function(ISOBox box, int depth)? callback,
  bool? showOffset,
}) async {
  return _inspectISOBox(box, 0, callback: callback, showOffset: showOffset);
}
