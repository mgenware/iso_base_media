import 'dart:io';
import 'dart:typed_data';

import 'package:iso_base_media/iso_base_media.dart';
import 'package:test/test.dart';

Future<void> testFile(String fileName, Map<String, dynamic> expected,
    {RandomAccessFile? raf}) async {
  ISOFileBox fileBox;
  if (raf != null) {
    fileBox = await ISOFileBox.openRandomAccessFile(raf);
    expect(fileBox.canClose, isFalse);
  } else {
    fileBox = await ISOFileBox.open('./test/test_files/$fileName');
    expect(fileBox.canClose, isTrue);
  }
  final actual = await inspectISOBox(fileBox);
  expect(actual, expected);
  await fileBox.close();
}

String uint8ListToHex(Uint8List bytes) {
  final StringBuffer buffer = StringBuffer();
  buffer.write('bytes(${bytes.length}): ');
  for (final byte in bytes) {
    buffer.write(byte.toRadixString(16).padLeft(2, '0'));
    buffer.write(' ');
  }
  return buffer.toString();
}

void main() {
  test('MP4', () async {
    await testFile('a.mp4', {
      'root': true,
      'children': [
        {
          'boxSize': 32,
          'dataSize': 24,
          'type': 'ftyp',
          'headerOffset': 0,
          'dataOffset': 8
        },
        {
          'boxSize': 8,
          'dataSize': 0,
          'type': 'free',
          'headerOffset': 32,
          'dataOffset': 40
        },
        {
          'boxSize': 235752,
          'dataSize': 235744,
          'type': 'mdat',
          'headerOffset': 40,
          'dataOffset': 48
        },
        {
          'boxSize': 9718,
          'dataSize': 9710,
          'type': 'moov',
          'headerOffset': 235792,
          'dataOffset': 235800,
          'children': [
            {
              'boxSize': 108,
              'dataSize': 96,
              'type': 'mvhd',
              'headerOffset': 235800,
              'dataOffset': 235812,
              'fullBoxInt32': 0,
              'parent': 'moov'
            },
            {
              'boxSize': 6083,
              'dataSize': 6075,
              'type': 'trak',
              'headerOffset': 235908,
              'dataOffset': 235916,
              'parent': 'moov',
              'children': [
                {
                  'boxSize': 92,
                  'dataSize': 80,
                  'type': 'tkhd',
                  'headerOffset': 235916,
                  'dataOffset': 235928,
                  'fullBoxInt32': 7,
                  'parent': 'trak'
                },
                {
                  'boxSize': 5983,
                  'dataSize': 5975,
                  'type': 'mdia',
                  'headerOffset': 236008,
                  'dataOffset': 236016,
                  'parent': 'trak',
                  'children': [
                    {
                      'boxSize': 32,
                      'dataSize': 20,
                      'type': 'mdhd',
                      'headerOffset': 236016,
                      'dataOffset': 236028,
                      'fullBoxInt32': 0,
                      'parent': 'mdia'
                    },
                    {
                      'boxSize': 36,
                      'dataSize': 24,
                      'type': 'hdlr',
                      'headerOffset': 236048,
                      'dataOffset': 236060,
                      'fullBoxInt32': 0,
                      'parent': 'mdia'
                    },
                    {
                      'boxSize': 5907,
                      'dataSize': 5899,
                      'type': 'minf',
                      'headerOffset': 236084,
                      'dataOffset': 236092,
                      'parent': 'mdia',
                      'children': [
                        {
                          'boxSize': 16,
                          'dataSize': 8,
                          'type': 'smhd',
                          'headerOffset': 236092,
                          'dataOffset': 236100,
                          'parent': 'minf'
                        },
                        {
                          'boxSize': 36,
                          'dataSize': 28,
                          'type': 'dinf',
                          'headerOffset': 236108,
                          'dataOffset': 236116,
                          'parent': 'minf',
                          'children': [
                            {
                              'boxSize': 28,
                              'dataSize': 16,
                              'type': 'dref',
                              'headerOffset': 236116,
                              'dataOffset': 236128,
                              'fullBoxInt32': 0,
                              'parent': 'dinf'
                            }
                          ]
                        },
                        {
                          'boxSize': 5847,
                          'dataSize': 5839,
                          'type': 'stbl',
                          'headerOffset': 236144,
                          'dataOffset': 236152,
                          'parent': 'minf',
                          'children': [
                            {
                              'boxSize': 91,
                              'dataSize': 79,
                              'type': 'stsd',
                              'headerOffset': 236152,
                              'dataOffset': 236164,
                              'fullBoxInt32': 0,
                              'parent': 'stbl'
                            },
                            {
                              'boxSize': 24,
                              'dataSize': 12,
                              'type': 'stts',
                              'headerOffset': 236243,
                              'dataOffset': 236255,
                              'fullBoxInt32': 0,
                              'parent': 'stbl'
                            },
                            {
                              'boxSize': 24,
                              'dataSize': 16,
                              'type': 'ctts',
                              'headerOffset': 236267,
                              'dataOffset': 236275,
                              'parent': 'stbl'
                            },
                            {
                              'boxSize': 2284,
                              'dataSize': 2272,
                              'type': 'stsc',
                              'headerOffset': 236291,
                              'dataOffset': 236303,
                              'fullBoxInt32': 0,
                              'parent': 'stbl'
                            },
                            {
                              'boxSize': 1900,
                              'dataSize': 1888,
                              'type': 'stsz',
                              'headerOffset': 238575,
                              'dataOffset': 238587,
                              'fullBoxInt32': 0,
                              'parent': 'stbl'
                            },
                            {
                              'boxSize': 1516,
                              'dataSize': 1504,
                              'type': 'stco',
                              'headerOffset': 240475,
                              'dataOffset': 240487,
                              'fullBoxInt32': 0,
                              'parent': 'stbl'
                            }
                          ]
                        }
                      ]
                    }
                  ]
                }
              ]
            },
            {
              'boxSize': 3519,
              'dataSize': 3511,
              'type': 'trak',
              'headerOffset': 241991,
              'dataOffset': 241999,
              'parent': 'moov',
              'children': [
                {
                  'boxSize': 92,
                  'dataSize': 80,
                  'type': 'tkhd',
                  'headerOffset': 241999,
                  'dataOffset': 242011,
                  'fullBoxInt32': 7,
                  'parent': 'trak'
                },
                {
                  'boxSize': 3419,
                  'dataSize': 3411,
                  'type': 'mdia',
                  'headerOffset': 242091,
                  'dataOffset': 242099,
                  'parent': 'trak',
                  'children': [
                    {
                      'boxSize': 32,
                      'dataSize': 20,
                      'type': 'mdhd',
                      'headerOffset': 242099,
                      'dataOffset': 242111,
                      'fullBoxInt32': 0,
                      'parent': 'mdia'
                    },
                    {
                      'boxSize': 36,
                      'dataSize': 24,
                      'type': 'hdlr',
                      'headerOffset': 242131,
                      'dataOffset': 242143,
                      'fullBoxInt32': 0,
                      'parent': 'mdia'
                    },
                    {
                      'boxSize': 3343,
                      'dataSize': 3335,
                      'type': 'minf',
                      'headerOffset': 242167,
                      'dataOffset': 242175,
                      'parent': 'mdia',
                      'children': [
                        {
                          'boxSize': 20,
                          'dataSize': 12,
                          'type': 'vmhd',
                          'headerOffset': 242175,
                          'dataOffset': 242183,
                          'parent': 'minf'
                        },
                        {
                          'boxSize': 36,
                          'dataSize': 28,
                          'type': 'dinf',
                          'headerOffset': 242195,
                          'dataOffset': 242203,
                          'parent': 'minf',
                          'children': [
                            {
                              'boxSize': 28,
                              'dataSize': 16,
                              'type': 'dref',
                              'headerOffset': 242203,
                              'dataOffset': 242215,
                              'fullBoxInt32': 0,
                              'parent': 'dinf'
                            }
                          ]
                        },
                        {
                          'boxSize': 3279,
                          'dataSize': 3271,
                          'type': 'stbl',
                          'headerOffset': 242231,
                          'dataOffset': 242239,
                          'parent': 'minf',
                          'children': [
                            {
                              'boxSize': 127,
                              'dataSize': 115,
                              'type': 'stsd',
                              'headerOffset': 242239,
                              'dataOffset': 242251,
                              'fullBoxInt32': 0,
                              'parent': 'stbl'
                            },
                            {
                              'boxSize': 24,
                              'dataSize': 12,
                              'type': 'stts',
                              'headerOffset': 242366,
                              'dataOffset': 242378,
                              'fullBoxInt32': 0,
                              'parent': 'stbl'
                            },
                            {
                              'boxSize': 32,
                              'dataSize': 20,
                              'type': 'stss',
                              'headerOffset': 242390,
                              'dataOffset': 242402,
                              'fullBoxInt32': 0,
                              'parent': 'stbl'
                            },
                            {
                              'boxSize': 24,
                              'dataSize': 16,
                              'type': 'ctts',
                              'headerOffset': 242422,
                              'dataOffset': 242430,
                              'parent': 'stbl'
                            },
                            {
                              'boxSize': 28,
                              'dataSize': 16,
                              'type': 'stsc',
                              'headerOffset': 242446,
                              'dataOffset': 242458,
                              'fullBoxInt32': 0,
                              'parent': 'stbl'
                            },
                            {
                              'boxSize': 1520,
                              'dataSize': 1508,
                              'type': 'stsz',
                              'headerOffset': 242474,
                              'dataOffset': 242486,
                              'fullBoxInt32': 0,
                              'parent': 'stbl'
                            },
                            {
                              'boxSize': 1516,
                              'dataSize': 1504,
                              'type': 'stco',
                              'headerOffset': 243994,
                              'dataOffset': 244006,
                              'fullBoxInt32': 0,
                              'parent': 'stbl'
                            }
                          ]
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          ]
        },
        {
          'boxSize': 237,
          'dataSize': 229,
          'type': 'free',
          'headerOffset': 245510,
          'dataOffset': 245518
        }
      ]
    });
  });

  test('HEIC', () async {
    await testFile('a.heic', {
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
    });
  });

  test('Callback', () async {
    final list = <Object>[];
    final fileBox = await ISOFileBox.open('./test/test_files/a.heic');
    await inspectISOBox(fileBox, callback: (box, depth) {
      final dict = box.toDict();
      dict['depth'] = depth;
      list.add(dict);
    });
    expect(list, [
      {'boxSize': 24, 'dataSize': 16, 'type': 'ftyp', 'depth': 1},
      {
        'boxSize': 510,
        'dataSize': 498,
        'type': 'meta',
        'fullBoxInt32': 0,
        'depth': 1
      },
      {
        'boxSize': 33,
        'dataSize': 21,
        'type': 'hdlr',
        'fullBoxInt32': 0,
        'depth': 2
      },
      {
        'boxSize': 14,
        'dataSize': 2,
        'type': 'pitm',
        'fullBoxInt32': 0,
        'depth': 2
      },
      {
        'boxSize': 52,
        'dataSize': 40,
        'type': 'iloc',
        'fullBoxInt32': 0,
        'depth': 2
      },
      {
        'boxSize': 76,
        'dataSize': 64,
        'type': 'iinf',
        'fullBoxInt32': 0,
        'depth': 2
      },
      {
        'boxSize': 26,
        'dataSize': 14,
        'type': 'iref',
        'fullBoxInt32': 0,
        'depth': 2
      },
      {'boxSize': 14, 'dataSize': 6, 'type': 'thmb', 'depth': 3},
      {'boxSize': 297, 'dataSize': 289, 'type': 'iprp', 'depth': 2},
      {'boxSize': 263, 'dataSize': 255, 'type': 'ipco', 'depth': 3},
      {'boxSize': 108, 'dataSize': 100, 'type': 'hvcC', 'depth': 4},
      {'boxSize': 20, 'dataSize': 12, 'type': 'ispe', 'depth': 4},
      {'boxSize': 107, 'dataSize': 99, 'type': 'hvcC', 'depth': 4},
      {'boxSize': 20, 'dataSize': 12, 'type': 'ispe', 'depth': 4},
      {'boxSize': 26, 'dataSize': 18, 'type': 'ipma', 'depth': 3},
      {'boxSize': 293074, 'dataSize': 293066, 'type': 'mdat', 'depth': 1}
    ]);
    await fileBox.close();
  });

  test('Extract data', () async {
    final fileBox = await ISOFileBox.open('./test/test_files/a.heic');
    var s = '';
    await inspectISOBox(fileBox, callback: (box, depth) async {
      if (box.type == 'ispe') {
        final data = await box.extractData();
        s += '${uint8ListToHex(data)}|';
      }
    });
    await fileBox.close();
    expect(s,
        'bytes(12): 00 00 00 00 00 00 05 a0 00 00 03 c0 |bytes(12): 00 00 00 00 00 00 00 f0 00 00 00 a0 |');
  });
}
