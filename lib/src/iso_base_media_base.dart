import 'dart:io';

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
  'iprp'
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
};

Future<ISOBox?> _readChildBox(RandomAccessFile file) async {
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

  int? fullBoxData;
  if (fullBox) {
    final fullBoxDataBuffer = await file.read(4);
    if (fullBoxDataBuffer.length < 4) {
      return null;
    }
    fullBoxData = fullBoxDataBuffer.buffer.asByteData().getUint32(0);
  }

  final dataPoz = await file.position();
  final box = ISOBox(boxSize, type, isContainer, file, dataPoz, fullBoxData);

  await file.setPosition(dataPoz + box.dataSize);
  return box;
}

/// Base class for ISO boxes.
abstract class ISOBoxBase {
  /// Returns the next child box.
  Future<ISOBox?> nextChild();
}

/// Represents an ISO box.
class ISOBox implements ISOBoxBase {
  /// The size of the box.
  final int boxSize;

  /// The size of the data in the box.
  int get dataSize =>
      boxSize -
      // 8 bytes for header size.
      8 -
      // 4 bytes for full box data.
      (fullBoxData != null ? 4 : 0);

  /// The type of the box.
  final String type;

  /// The file where the box is located.
  final RandomAccessFile _file;

  /// Whether the box is a container.
  final bool isContainer;

  /// The full box data.
  final int? fullBoxData;

  final int _initialOffset;
  late int _currentOffset;

  ISOBox(this.boxSize, this.type, this.isContainer, this._file,
      this._initialOffset, this.fullBoxData) {
    _currentOffset = _initialOffset;
  }

  @override
  Future<ISOBox?> nextChild() async {
    if (!_containerBoxes.contains(type)) {
      return null;
    }
    if (_currentOffset - _initialOffset >= dataSize) {
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

  Map<String, dynamic> toDict() {
    final res = <String, dynamic>{
      'boxSize': boxSize,
      'dataSize': dataSize,
      'type': type,
    };
    if (fullBoxData != null) {
      res['fullBoxData'] = fullBoxData;
    }
    return res;
  }
}

/// Can be used to read ISO boxes from a file.
class ISOFileBox implements ISOBoxBase {
  final String filePath;
  final RandomAccessFile _file;

  int _offset = 0;

  ISOFileBox._(this.filePath, this._file);

  /// Opens a file and returns an instance of [ISOFileBox].
  static Future<ISOFileBox> open(String filePath) async {
    RandomAccessFile raf = await File(filePath).open();
    return ISOFileBox._(filePath, raf);
  }

  /// Closes the file.
  Future<void> close() async {
    await _file.close();
  }

  @override
  Future<ISOBox?> nextChild() async {
    await _file.setPosition(_offset);
    final box = await _readChildBox(_file);
    _offset = await _file.position();
    return box;
  }
}

Future<List<Object>> _inspectISOBox(ISOBoxBase box, int depth) async {
  final res = <Object>[];
  if (box is ISOBox) {
    res.add(box.toDict());
    if (!box.isContainer) {
      return res;
    }
  }
  ISOBox? child;
  do {
    child = await box.nextChild();
    if (child != null) {
      res.add(await _inspectISOBox(child, depth + 1));
    }
  } while (child != null);
  return res;
}

/// Inspects an ISO box.
Future<List<Object>> inspectISOBox(ISOBoxBase box) async {
  return _inspectISOBox(box, 0);
}
