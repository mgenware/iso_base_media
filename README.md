# iso_base_media

[![pub package](https://img.shields.io/pub/v/iso_base_media.svg)](https://pub.dev/packages/iso_base_media)
[![Build Status](https://github.com/mgenware/iso_base_media/workflows/Build/badge.svg)](https://github.com/mgenware/iso_base_media/actions)

## Usage

### Inspect all boxes (atoms) in an ISO base media format file

```dart
Future<void> inspect() async {
  final fileBox = await ISOFileBox.open('./test/test_files/a.heic');
  final s = await inspectISOBox(fileBox);
  await fileBox.close();
  print(s);
}
/*
  [
    [
      {'boxSize': 24, 'dataSize': 16, 'type': 'ftyp'}
    ],
    [
      {'boxSize': 510, 'dataSize': 498, 'type': 'meta', 'fullBoxInt32': 0},
      [
        {'boxSize': 33, 'dataSize': 21, 'type': 'hdlr', 'fullBoxInt32': 0}
      ],
      [
        {'boxSize': 14, 'dataSize': 2, 'type': 'pitm', 'fullBoxInt32': 0}
      ],
      [
        {'boxSize': 52, 'dataSize': 40, 'type': 'iloc', 'fullBoxInt32': 0}
      ],
      [
        {'boxSize': 76, 'dataSize': 64, 'type': 'iinf', 'fullBoxInt32': 0}
      ],
      [
        {'boxSize': 26, 'dataSize': 14, 'type': 'iref', 'fullBoxInt32': 0},
        [
          {'boxSize': 14, 'dataSize': 6, 'type': 'thmb'}
        ]
      ],
      [
        {'boxSize': 297, 'dataSize': 289, 'type': 'iprp'},
        [
          {'boxSize': 263, 'dataSize': 255, 'type': 'ipco'}
        ],
        [
          {'boxSize': 26, 'dataSize': 18, 'type': 'ipma'}
        ]
      ]
    ],
    [
      {'boxSize': 293074, 'dataSize': 293066, 'type': 'mdat'}
    ]
  ]
*/
```

### Extract data from specific boxes

```dart
Future<void> extract() async {
  final fileBox = await ISOFileBox.open('./test/test_files/a.heic');
  var s = '';
  await inspectISOBox(fileBox, callback: (box, depth) async {
    if (box.type == 'ispe') {
      final data = await box.extractData();
      s += '${uint8ListToHex(data)}\n';
    }
  });
  await fileBox.close();
  print(s);
}

String uint8ListToHex(Uint8List bytes) {
  final StringBuffer buffer = StringBuffer();
  buffer.write('bytes(${bytes.length}): ');
  for (int byte in bytes) {
    buffer.write(byte.toRadixString(16).padLeft(2, '0'));
    buffer.write(' ');
  }
  return buffer.toString();
}

/*
bytes(12): 00 00 00 00 00 00 05 a0 00 00 03 c0
bytes(12): 00 00 00 00 00 00 00 f0 00 00 00 a0
*/
```

### Start parsing from a `RandomAccessFile`

```dart
final fileBox = await ISOFileBox.openRandomAccessFile(someRandomAccessFile);
// It's now user's responsibility to close the random access file.
```
