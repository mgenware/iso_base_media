# iso_base_media

[![pub package](https://img.shields.io/pub/v/iso_base_media.svg)](https://pub.dev/packages/iso_base_media)
[![Build Status](https://github.com/mgenware/iso_base_media/workflows/Build/badge.svg)](https://github.com/mgenware/iso_base_media/actions)

A dart package to parse ISO Base Media File Format and MP4 files.

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
{
      'root': true,
      'children': [
        {
          'boxSize': 24,
          'dataSize': 16,
          'type': 'ftyp',
          'headerOffset': 0,
          'dataOffset': 8
        },
        {
          'boxSize': 510,
          'dataSize': 498,
          'type': 'meta',
          'headerOffset': 24,
          'dataOffset': 36,
          'fullBoxInt32': 0,
          'children': [
            {
              'boxSize': 33,
              'dataSize': 21,
              'type': 'hdlr',
              'headerOffset': 36,
              'dataOffset': 48,
              'fullBoxInt32': 0,
              'parent': 'meta'
            },
            {
              'boxSize': 14,
              'dataSize': 2,
              'type': 'pitm',
              'headerOffset': 69,
              'dataOffset': 81,
              'fullBoxInt32': 0,
              'parent': 'meta'
            },
            {
              'boxSize': 52,
              'dataSize': 40,
              'type': 'iloc',
              'headerOffset': 83,
              'dataOffset': 95,
              'fullBoxInt32': 0,
              'parent': 'meta'
            },
            {
              'boxSize': 76,
              'dataSize': 64,
              'type': 'iinf',
              'headerOffset': 135,
              'dataOffset': 147,
              'fullBoxInt32': 0,
              'parent': 'meta'
            },
            {
              'boxSize': 26,
              'dataSize': 14,
              'type': 'iref',
              'headerOffset': 211,
              'dataOffset': 223,
              'fullBoxInt32': 0,
              'parent': 'meta',
              'children': [
                {
                  'boxSize': 14,
                  'dataSize': 6,
                  'type': 'thmb',
                  'headerOffset': 223,
                  'dataOffset': 231,
                  'parent': 'iref'
                }
              ]
            },
            {
              'boxSize': 297,
              'dataSize': 289,
              'type': 'iprp',
              'headerOffset': 237,
              'dataOffset': 245,
              'parent': 'meta',
              'children': [
                {
                  'boxSize': 263,
                  'dataSize': 255,
                  'type': 'ipco',
                  'headerOffset': 245,
                  'dataOffset': 253,
                  'parent': 'iprp',
                  'children': [
                    {
                      'boxSize': 108,
                      'dataSize': 100,
                      'type': 'hvcC',
                      'headerOffset': 253,
                      'dataOffset': 261,
                      'parent': 'ipco'
                    },
                    {
                      'boxSize': 20,
                      'dataSize': 12,
                      'type': 'ispe',
                      'headerOffset': 361,
                      'dataOffset': 369,
                      'parent': 'ipco'
                    },
                    {
                      'boxSize': 107,
                      'dataSize': 99,
                      'type': 'hvcC',
                      'headerOffset': 381,
                      'dataOffset': 389,
                      'parent': 'ipco'
                    },
                    {
                      'boxSize': 20,
                      'dataSize': 12,
                      'type': 'ispe',
                      'headerOffset': 488,
                      'dataOffset': 496,
                      'parent': 'ipco'
                    }
                  ]
                },
                {
                  'boxSize': 26,
                  'dataSize': 18,
                  'type': 'ipma',
                  'headerOffset': 508,
                  'dataOffset': 516,
                  'parent': 'iprp'
                }
              ]
            }
          ]
        },
        {
          'boxSize': 293074,
          'dataSize': 293066,
          'type': 'mdat',
          'headerOffset': 534,
          'dataOffset': 542
        }
      ]
    }
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
