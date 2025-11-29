import 'dart:async';
import 'dart:typed_data';

import 'package:random_access_source/random_access_source.dart';

import 'uint8list_extension.dart';

bool _checkIsContainerBox(
    String type, bool Function(String type)? isContainerCallback) {
  return isContainerCallback != null
      ? isContainerCallback(type)
      : _containerBoxes.contains(type);
}

final bool _isJS = 1.0 is int;

Future<ISOBox?> readISOBox(
  RandomAccessSource src, {
  bool Function(String type)? isContainerCallback,
  bool Function(String type)? isFullBoxCallback,
}) async {
  return _readChildBox(src, isContainerCallback, isFullBoxCallback);
}

Future<ISOBox?> _readChildBox(
  RandomAccessSource src,
  bool Function(String type)? isContainerCallback,
  bool Function(String type)? isFullBoxCallback,
) async {
  final headerOffset = await src.position();
  final sizeBuffer = await src.read(4);
  // Check EOF on first read.
  if (sizeBuffer.isEmpty) {
    return null;
  }

  if (sizeBuffer.length < 4) {
    throw Exception('Expected 4 bytes for box size, got ${sizeBuffer.length}');
  }
  var boxSize = sizeBuffer.asByteData().getUint32(0);
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
    final largeSizeBuffer = await src.mustRead(8);
    // NOTE: JavaScript only supports doubles. JavaScript integers are actually
    // doubles in the range of -2^53 to 2^53. 64-bit integers are not supported
    // in JavaScript.
    if (_isJS) {
      throw Exception('Large size buffers are not supported in JavaScript.');
    }
    boxSize = largeSizeBuffer.asByteData().getUint64(0);
  } else if (boxSize == 0) {
    boxSize =
        await src.length() - await src.position() + 4 /* Size bytes size */;
  }

  final typeBuffer = await src.mustRead(4);
  final type = String.fromCharCodes(typeBuffer);

  final fullBox = isFullBoxCallback != null
      ? isFullBoxCallback(type)
      : _fullBoxes.contains(type);
  final isContainer = _checkIsContainerBox(type, isContainerCallback);

  int? fullBoxInt32;
  if (fullBox) {
    final fullBoxInt32Buffer = await src.mustRead(4);
    fullBoxInt32 = fullBoxInt32Buffer.asByteData().getUint32(0);
  }

  final dataOffset = await src.position();
  final box = ISOBox(false, boxSize, type, isContainer, headerOffset,
      dataOffset, fullBoxInt32);

  await src.seek(dataOffset + box.dataSize);
  return box;
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
class ISOBox {
  /// Whether the box is the root file box.
  final bool isRootFileBox;

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

  /// Whether the box is a container.
  final bool isContainer;

  /// The full box data.
  final int? fullBoxInt32;

  int get version => fullBoxInt32 != null ? (fullBoxInt32! >> 24) & 0xff : 0;
  int get flags => fullBoxInt32 != null ? fullBoxInt32! & 0xffffff : 0;

  /// The offset of the header in the file.
  final int headerOffset;

  /// The offset of the data in the file.
  final int dataOffset;

  /// Gets the current offset of the box within the source.
  int get currentOffset => _currentOffset;

  /// Current parsing offset.
  late int _currentOffset;

  int _index = -1;

  /// An optional index of the box when calling [nextChild].
  int get index => _index;

  ISOBox(
    this.isRootFileBox,
    this.boxSize,
    this.type,
    this.isContainer,
    this.headerOffset,
    this.dataOffset,
    this.fullBoxInt32,
  ) {
    _currentOffset = dataOffset;
  }

  /// Creates a file box from [RandomAccessBinaryReader].
  static ISOBox createRootBox() {
    return ISOBox(true, 0, '', true, 0, 0, null);
  }

  /// Returns the next child box. If the box is not a container, returns null.
  /// If [isContainerCallback] is provided, it will be used to determine if the box is a container.
  /// If [isFullBoxCallback] is provided, it will be used to determine if the box is a full box.
  Future<ISOBox?> nextChild(
    RandomAccessSource src, {
    bool Function(String type)? isContainerCallback,
    bool Function(String type)? isFullBoxCallback,
    int? index,
  }) async {
    if (!isContainer) {
      return null;
    }
    // Return null if the box is fully read.
    if (!isRootFileBox && _currentOffset - dataOffset >= dataSize) {
      return null;
    }
    await src.seek(_currentOffset);
    final box =
        await _readChildBox(src, isContainerCallback, isFullBoxCallback);
    _currentOffset = await src.position();
    if (box != null && index != null) {
      box._index = index;
    }
    return box;
  }

  /// Sets the internal file position to the specified offset within the data of the box.
  Future<void> seekInData(RandomAccessSource src, int offset) async {
    offset = dataOffset + offset;
    await src.seek(offset);
    _currentOffset = offset;
  }

  /// This calls [seekInData] with an offset of 0, effectively resetting the position to the start of the box data.
  Future<void> resetPosition(
    RandomAccessSource src,
  ) async {
    await seekInData(src, 0);
  }

  /// Returns the box as bytes. This includes the header and the data.
  Future<Uint8List> toBytes(
    RandomAccessSource src,
  ) async {
    final poz = await src.position();
    await src.seek(headerOffset);
    final boxBytes = await src.read(boxSize);
    await src.seek(poz);
    return boxBytes;
  }

  @override
  String toString() {
    return toDict().toString();
  }

  /// Converts the box to a dictionary.
  Map<String, dynamic> toDict() {
    if (isRootFileBox) {
      return <String, dynamic>{
        'root': true,
      };
    }
    final res = <String, dynamic>{
      'boxSize': boxSize,
      'dataSize': dataSize,
      'type': type,
      'headerOffset': headerOffset,
      'dataOffset': dataOffset,
    };
    if (fullBoxInt32 != null) {
      res['fullBoxInt32'] = fullBoxInt32;
    }
    if (_index >= 0) {
      res['index'] = _index;
    }
    return res;
  }

  /// Extracts the data from the box.
  Future<Uint8List> extractData(
    RandomAccessSource src,
  ) async {
    await src.seek(dataOffset);
    return await src.read(dataSize);
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
  'grpl',
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
  'infe',
  'ispe',
  'ipma',
};
