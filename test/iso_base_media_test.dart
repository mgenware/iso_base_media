import 'dart:io';
import 'dart:typed_data';

import 'package:iso_base_media/iso_base_media.dart';
import 'package:iso_base_media/src/uint8list_extension.dart';
import 'package:random_access_source/random_access_source.dart';
import 'package:test/test.dart';

import 'common.dart';

Future<void> testFile(String fileName, Map<String, dynamic> expected,
    {bool? readBytes, Uint8List? bytes}) async {
  ISOBox srcBox;
  final path = './test/test_files/$fileName';
  RandomAccessFile? raf;
  if (bytes != null) {
    srcBox = ISOBox.fileBox(BytesRASource(bytes));
  } else if (readBytes == true) {
    srcBox = ISOBox.fileBox(BytesRASource(await File(path).readAsBytes()));
  } else {
    raf = await File(path).open();
    srcBox = ISOBox.fileBox(RandomAccessFileRASource(raf));
  }
  final actual = await inspectISOBox(srcBox);
  expect(actual, expected);
  await raf?.close();
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
            },
            {
              'boxSize': 6083,
              'dataSize': 6075,
              'type': 'trak',
              'headerOffset': 235908,
              'dataOffset': 235916,
              'children': [
                {
                  'boxSize': 92,
                  'dataSize': 80,
                  'type': 'tkhd',
                  'headerOffset': 235916,
                  'dataOffset': 235928,
                  'fullBoxInt32': 7,
                },
                {
                  'boxSize': 5983,
                  'dataSize': 5975,
                  'type': 'mdia',
                  'headerOffset': 236008,
                  'dataOffset': 236016,
                  'children': [
                    {
                      'boxSize': 32,
                      'dataSize': 20,
                      'type': 'mdhd',
                      'headerOffset': 236016,
                      'dataOffset': 236028,
                      'fullBoxInt32': 0,
                    },
                    {
                      'boxSize': 36,
                      'dataSize': 24,
                      'type': 'hdlr',
                      'headerOffset': 236048,
                      'dataOffset': 236060,
                      'fullBoxInt32': 0,
                    },
                    {
                      'boxSize': 5907,
                      'dataSize': 5899,
                      'type': 'minf',
                      'headerOffset': 236084,
                      'dataOffset': 236092,
                      'children': [
                        {
                          'boxSize': 16,
                          'dataSize': 8,
                          'type': 'smhd',
                          'headerOffset': 236092,
                          'dataOffset': 236100,
                        },
                        {
                          'boxSize': 36,
                          'dataSize': 28,
                          'type': 'dinf',
                          'headerOffset': 236108,
                          'dataOffset': 236116,
                          'children': [
                            {
                              'boxSize': 28,
                              'dataSize': 16,
                              'type': 'dref',
                              'headerOffset': 236116,
                              'dataOffset': 236128,
                              'fullBoxInt32': 0,
                            }
                          ]
                        },
                        {
                          'boxSize': 5847,
                          'dataSize': 5839,
                          'type': 'stbl',
                          'headerOffset': 236144,
                          'dataOffset': 236152,
                          'children': [
                            {
                              'boxSize': 91,
                              'dataSize': 79,
                              'type': 'stsd',
                              'headerOffset': 236152,
                              'dataOffset': 236164,
                              'fullBoxInt32': 0,
                            },
                            {
                              'boxSize': 24,
                              'dataSize': 12,
                              'type': 'stts',
                              'headerOffset': 236243,
                              'dataOffset': 236255,
                              'fullBoxInt32': 0,
                            },
                            {
                              'boxSize': 24,
                              'dataSize': 16,
                              'type': 'ctts',
                              'headerOffset': 236267,
                              'dataOffset': 236275,
                            },
                            {
                              'boxSize': 2284,
                              'dataSize': 2272,
                              'type': 'stsc',
                              'headerOffset': 236291,
                              'dataOffset': 236303,
                              'fullBoxInt32': 0,
                            },
                            {
                              'boxSize': 1900,
                              'dataSize': 1888,
                              'type': 'stsz',
                              'headerOffset': 238575,
                              'dataOffset': 238587,
                              'fullBoxInt32': 0,
                            },
                            {
                              'boxSize': 1516,
                              'dataSize': 1504,
                              'type': 'stco',
                              'headerOffset': 240475,
                              'dataOffset': 240487,
                              'fullBoxInt32': 0,
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
              'children': [
                {
                  'boxSize': 92,
                  'dataSize': 80,
                  'type': 'tkhd',
                  'headerOffset': 241999,
                  'dataOffset': 242011,
                  'fullBoxInt32': 7,
                },
                {
                  'boxSize': 3419,
                  'dataSize': 3411,
                  'type': 'mdia',
                  'headerOffset': 242091,
                  'dataOffset': 242099,
                  'children': [
                    {
                      'boxSize': 32,
                      'dataSize': 20,
                      'type': 'mdhd',
                      'headerOffset': 242099,
                      'dataOffset': 242111,
                      'fullBoxInt32': 0,
                    },
                    {
                      'boxSize': 36,
                      'dataSize': 24,
                      'type': 'hdlr',
                      'headerOffset': 242131,
                      'dataOffset': 242143,
                      'fullBoxInt32': 0,
                    },
                    {
                      'boxSize': 3343,
                      'dataSize': 3335,
                      'type': 'minf',
                      'headerOffset': 242167,
                      'dataOffset': 242175,
                      'children': [
                        {
                          'boxSize': 20,
                          'dataSize': 12,
                          'type': 'vmhd',
                          'headerOffset': 242175,
                          'dataOffset': 242183,
                        },
                        {
                          'boxSize': 36,
                          'dataSize': 28,
                          'type': 'dinf',
                          'headerOffset': 242195,
                          'dataOffset': 242203,
                          'children': [
                            {
                              'boxSize': 28,
                              'dataSize': 16,
                              'type': 'dref',
                              'headerOffset': 242203,
                              'dataOffset': 242215,
                              'fullBoxInt32': 0,
                            }
                          ]
                        },
                        {
                          'boxSize': 3279,
                          'dataSize': 3271,
                          'type': 'stbl',
                          'headerOffset': 242231,
                          'dataOffset': 242239,
                          'children': [
                            {
                              'boxSize': 127,
                              'dataSize': 115,
                              'type': 'stsd',
                              'headerOffset': 242239,
                              'dataOffset': 242251,
                              'fullBoxInt32': 0,
                            },
                            {
                              'boxSize': 24,
                              'dataSize': 12,
                              'type': 'stts',
                              'headerOffset': 242366,
                              'dataOffset': 242378,
                              'fullBoxInt32': 0,
                            },
                            {
                              'boxSize': 32,
                              'dataSize': 20,
                              'type': 'stss',
                              'headerOffset': 242390,
                              'dataOffset': 242402,
                              'fullBoxInt32': 0,
                            },
                            {
                              'boxSize': 24,
                              'dataSize': 16,
                              'type': 'ctts',
                              'headerOffset': 242422,
                              'dataOffset': 242430,
                            },
                            {
                              'boxSize': 28,
                              'dataSize': 16,
                              'type': 'stsc',
                              'headerOffset': 242446,
                              'dataOffset': 242458,
                              'fullBoxInt32': 0,
                            },
                            {
                              'boxSize': 1520,
                              'dataSize': 1508,
                              'type': 'stsz',
                              'headerOffset': 242474,
                              'dataOffset': 242486,
                              'fullBoxInt32': 0,
                            },
                            {
                              'boxSize': 1516,
                              'dataSize': 1504,
                              'type': 'stco',
                              'headerOffset': 243994,
                              'dataOffset': 244006,
                              'fullBoxInt32': 0,
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
            },
            {
              'boxSize': 14,
              'dataSize': 2,
              'type': 'pitm',
              'headerOffset': 69,
              'dataOffset': 81,
              'fullBoxInt32': 0,
            },
            {
              'boxSize': 52,
              'dataSize': 40,
              'type': 'iloc',
              'headerOffset': 83,
              'dataOffset': 95,
              'fullBoxInt32': 0,
            },
            {
              'boxSize': 76,
              'dataSize': 64,
              'type': 'iinf',
              'headerOffset': 135,
              'dataOffset': 147,
              'fullBoxInt32': 0,
            },
            {
              'boxSize': 26,
              'dataSize': 14,
              'type': 'iref',
              'headerOffset': 211,
              'dataOffset': 223,
              'fullBoxInt32': 0,
              'children': [
                {
                  'boxSize': 14,
                  'dataSize': 6,
                  'type': 'thmb',
                  'headerOffset': 223,
                  'dataOffset': 231,
                }
              ]
            },
            {
              'boxSize': 297,
              'dataSize': 289,
              'type': 'iprp',
              'headerOffset': 237,
              'dataOffset': 245,
              'children': [
                {
                  'boxSize': 263,
                  'dataSize': 255,
                  'type': 'ipco',
                  'headerOffset': 245,
                  'dataOffset': 253,
                  'children': [
                    {
                      'boxSize': 108,
                      'dataSize': 100,
                      'type': 'hvcC',
                      'headerOffset': 253,
                      'dataOffset': 261,
                    },
                    {
                      'boxSize': 20,
                      'dataSize': 12,
                      'type': 'ispe',
                      'headerOffset': 361,
                      'dataOffset': 369,
                    },
                    {
                      'boxSize': 107,
                      'dataSize': 99,
                      'type': 'hvcC',
                      'headerOffset': 381,
                      'dataOffset': 389,
                    },
                    {
                      'boxSize': 20,
                      'dataSize': 12,
                      'type': 'ispe',
                      'headerOffset': 488,
                      'dataOffset': 496,
                    }
                  ]
                },
                {
                  'boxSize': 26,
                  'dataSize': 18,
                  'type': 'ipma',
                  'headerOffset': 508,
                  'dataOffset': 516,
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

  test('Uint8List sub view', () async {
    final imgBytes = await File('./test/test_files/a.heic').readAsBytes();
    final bb = BytesBuilder();
    bb.add([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    bb.add(imgBytes);
    bb.add([11, 12, 13, 14, 15, 16, 17, 18, 19, 20]);
    final subView = bb.toBytes().subView(10, 10 + imgBytes.length);
    await testFile(
        '',
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
                },
                {
                  'boxSize': 14,
                  'dataSize': 2,
                  'type': 'pitm',
                  'headerOffset': 69,
                  'dataOffset': 81,
                  'fullBoxInt32': 0,
                },
                {
                  'boxSize': 52,
                  'dataSize': 40,
                  'type': 'iloc',
                  'headerOffset': 83,
                  'dataOffset': 95,
                  'fullBoxInt32': 0,
                },
                {
                  'boxSize': 76,
                  'dataSize': 64,
                  'type': 'iinf',
                  'headerOffset': 135,
                  'dataOffset': 147,
                  'fullBoxInt32': 0,
                },
                {
                  'boxSize': 26,
                  'dataSize': 14,
                  'type': 'iref',
                  'headerOffset': 211,
                  'dataOffset': 223,
                  'fullBoxInt32': 0,
                  'children': [
                    {
                      'boxSize': 14,
                      'dataSize': 6,
                      'type': 'thmb',
                      'headerOffset': 223,
                      'dataOffset': 231,
                    }
                  ]
                },
                {
                  'boxSize': 297,
                  'dataSize': 289,
                  'type': 'iprp',
                  'headerOffset': 237,
                  'dataOffset': 245,
                  'children': [
                    {
                      'boxSize': 263,
                      'dataSize': 255,
                      'type': 'ipco',
                      'headerOffset': 245,
                      'dataOffset': 253,
                      'children': [
                        {
                          'boxSize': 108,
                          'dataSize': 100,
                          'type': 'hvcC',
                          'headerOffset': 253,
                          'dataOffset': 261,
                        },
                        {
                          'boxSize': 20,
                          'dataSize': 12,
                          'type': 'ispe',
                          'headerOffset': 361,
                          'dataOffset': 369,
                        },
                        {
                          'boxSize': 107,
                          'dataSize': 99,
                          'type': 'hvcC',
                          'headerOffset': 381,
                          'dataOffset': 389,
                        },
                        {
                          'boxSize': 20,
                          'dataSize': 12,
                          'type': 'ispe',
                          'headerOffset': 488,
                          'dataOffset': 496,
                        }
                      ]
                    },
                    {
                      'boxSize': 26,
                      'dataSize': 18,
                      'type': 'ipma',
                      'headerOffset': 508,
                      'dataOffset': 516,
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
        },
        bytes: subView);
  });

  test('Byte source', () async {
    await testFile(
        'a.heic',
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
                },
                {
                  'boxSize': 14,
                  'dataSize': 2,
                  'type': 'pitm',
                  'headerOffset': 69,
                  'dataOffset': 81,
                  'fullBoxInt32': 0,
                },
                {
                  'boxSize': 52,
                  'dataSize': 40,
                  'type': 'iloc',
                  'headerOffset': 83,
                  'dataOffset': 95,
                  'fullBoxInt32': 0,
                },
                {
                  'boxSize': 76,
                  'dataSize': 64,
                  'type': 'iinf',
                  'headerOffset': 135,
                  'dataOffset': 147,
                  'fullBoxInt32': 0,
                },
                {
                  'boxSize': 26,
                  'dataSize': 14,
                  'type': 'iref',
                  'headerOffset': 211,
                  'dataOffset': 223,
                  'fullBoxInt32': 0,
                  'children': [
                    {
                      'boxSize': 14,
                      'dataSize': 6,
                      'type': 'thmb',
                      'headerOffset': 223,
                      'dataOffset': 231,
                    }
                  ]
                },
                {
                  'boxSize': 297,
                  'dataSize': 289,
                  'type': 'iprp',
                  'headerOffset': 237,
                  'dataOffset': 245,
                  'children': [
                    {
                      'boxSize': 263,
                      'dataSize': 255,
                      'type': 'ipco',
                      'headerOffset': 245,
                      'dataOffset': 253,
                      'children': [
                        {
                          'boxSize': 108,
                          'dataSize': 100,
                          'type': 'hvcC',
                          'headerOffset': 253,
                          'dataOffset': 261,
                        },
                        {
                          'boxSize': 20,
                          'dataSize': 12,
                          'type': 'ispe',
                          'headerOffset': 361,
                          'dataOffset': 369,
                        },
                        {
                          'boxSize': 107,
                          'dataSize': 99,
                          'type': 'hvcC',
                          'headerOffset': 381,
                          'dataOffset': 389,
                        },
                        {
                          'boxSize': 20,
                          'dataSize': 12,
                          'type': 'ispe',
                          'headerOffset': 488,
                          'dataOffset': 496,
                        }
                      ]
                    },
                    {
                      'boxSize': 26,
                      'dataSize': 18,
                      'type': 'ipma',
                      'headerOffset': 508,
                      'dataOffset': 516,
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
        },
        readBytes: true);
  });

  test('Callback', () async {
    final list = <Object>[];
    final raf = await File('./test/test_files/a.heic').open();
    final fileBox = ISOBox.fileBoxFromRandomAccessFile(raf);
    await inspectISOBox(fileBox, callback: (box, depth) {
      final dict = box.toDict();
      dict['depth'] = depth;
      list.add(dict);
      return true;
    });
    expect(list, [
      {
        'boxSize': 24,
        'dataSize': 16,
        'type': 'ftyp',
        'headerOffset': 0,
        'dataOffset': 8,
        'depth': 1
      },
      {
        'boxSize': 510,
        'dataSize': 498,
        'type': 'meta',
        'headerOffset': 24,
        'dataOffset': 36,
        'fullBoxInt32': 0,
        'depth': 1
      },
      {
        'boxSize': 33,
        'dataSize': 21,
        'type': 'hdlr',
        'headerOffset': 36,
        'dataOffset': 48,
        'fullBoxInt32': 0,
        'depth': 2
      },
      {
        'boxSize': 14,
        'dataSize': 2,
        'type': 'pitm',
        'headerOffset': 69,
        'dataOffset': 81,
        'fullBoxInt32': 0,
        'depth': 2
      },
      {
        'boxSize': 52,
        'dataSize': 40,
        'type': 'iloc',
        'headerOffset': 83,
        'dataOffset': 95,
        'fullBoxInt32': 0,
        'depth': 2
      },
      {
        'boxSize': 76,
        'dataSize': 64,
        'type': 'iinf',
        'headerOffset': 135,
        'dataOffset': 147,
        'fullBoxInt32': 0,
        'depth': 2
      },
      {
        'boxSize': 26,
        'dataSize': 14,
        'type': 'iref',
        'headerOffset': 211,
        'dataOffset': 223,
        'fullBoxInt32': 0,
        'depth': 2
      },
      {
        'boxSize': 14,
        'dataSize': 6,
        'type': 'thmb',
        'headerOffset': 223,
        'dataOffset': 231,
        'depth': 3
      },
      {
        'boxSize': 297,
        'dataSize': 289,
        'type': 'iprp',
        'headerOffset': 237,
        'dataOffset': 245,
        'depth': 2
      },
      {
        'boxSize': 263,
        'dataSize': 255,
        'type': 'ipco',
        'headerOffset': 245,
        'dataOffset': 253,
        'depth': 3
      },
      {
        'boxSize': 108,
        'dataSize': 100,
        'type': 'hvcC',
        'headerOffset': 253,
        'dataOffset': 261,
        'depth': 4
      },
      {
        'boxSize': 20,
        'dataSize': 12,
        'type': 'ispe',
        'headerOffset': 361,
        'dataOffset': 369,
        'depth': 4
      },
      {
        'boxSize': 107,
        'dataSize': 99,
        'type': 'hvcC',
        'headerOffset': 381,
        'dataOffset': 389,
        'depth': 4
      },
      {
        'boxSize': 20,
        'dataSize': 12,
        'type': 'ispe',
        'headerOffset': 488,
        'dataOffset': 496,
        'depth': 4
      },
      {
        'boxSize': 26,
        'dataSize': 18,
        'type': 'ipma',
        'headerOffset': 508,
        'dataOffset': 516,
        'depth': 3
      },
      {
        'boxSize': 293074,
        'dataSize': 293066,
        'type': 'mdat',
        'headerOffset': 534,
        'dataOffset': 542,
        'depth': 1
      }
    ]);
    await raf.close();
  });

  test('Callback (early exit)', () async {
    final list = <Object>[];
    final raf = await File('./test/test_files/a.heic').open();
    final fileBox = ISOBox.fileBoxFromRandomAccessFile(raf);
    await inspectISOBox(fileBox, callback: (box, depth) {
      final dict = box.toDict();
      dict['depth'] = depth;
      list.add(dict);
      if (box.type == 'meta') {
        return false;
      }
      return true;
    });
    expect(list, [
      {
        'boxSize': 24,
        'dataSize': 16,
        'type': 'ftyp',
        'headerOffset': 0,
        'dataOffset': 8,
        'depth': 1
      },
      {
        'boxSize': 510,
        'dataSize': 498,
        'type': 'meta',
        'headerOffset': 24,
        'dataOffset': 36,
        'fullBoxInt32': 0,
        'depth': 1
      },
      {
        'boxSize': 293074,
        'dataSize': 293066,
        'type': 'mdat',
        'headerOffset': 534,
        'dataOffset': 542,
        'depth': 1
      }
    ]);
    await raf.close();
  });

  test('Callback (isContainerCallback)', () async {
    final list = <Object>[];
    final raf = await File('./test/test_files/a.heic').open();
    final fileBox = ISOBox.fileBoxFromRandomAccessFile(raf);
    await inspectISOBox(fileBox, isContainerCallback: (type) {
      if (type == 'meta') {
        return true;
      }
      return false;
    }, callback: (box, depth) {
      final dict = box.toDict();
      dict['depth'] = depth;
      list.add(dict);
      return true;
    });
    expect(list, [
      {
        'boxSize': 24,
        'dataSize': 16,
        'type': 'ftyp',
        'headerOffset': 0,
        'dataOffset': 8,
        'depth': 1
      },
      {
        'boxSize': 510,
        'dataSize': 498,
        'type': 'meta',
        'headerOffset': 24,
        'dataOffset': 36,
        'fullBoxInt32': 0,
        'depth': 1
      },
      {
        'boxSize': 33,
        'dataSize': 21,
        'type': 'hdlr',
        'headerOffset': 36,
        'dataOffset': 48,
        'fullBoxInt32': 0,
        'depth': 2
      },
      {
        'boxSize': 14,
        'dataSize': 2,
        'type': 'pitm',
        'headerOffset': 69,
        'dataOffset': 81,
        'fullBoxInt32': 0,
        'depth': 2
      },
      {
        'boxSize': 52,
        'dataSize': 40,
        'type': 'iloc',
        'headerOffset': 83,
        'dataOffset': 95,
        'fullBoxInt32': 0,
        'depth': 2
      },
      {
        'boxSize': 76,
        'dataSize': 64,
        'type': 'iinf',
        'headerOffset': 135,
        'dataOffset': 147,
        'fullBoxInt32': 0,
        'depth': 2
      },
      {
        'boxSize': 26,
        'dataSize': 14,
        'type': 'iref',
        'headerOffset': 211,
        'dataOffset': 223,
        'fullBoxInt32': 0,
        'depth': 2
      },
      {
        'boxSize': 297,
        'dataSize': 289,
        'type': 'iprp',
        'headerOffset': 237,
        'dataOffset': 245,
        'depth': 2
      },
      {
        'boxSize': 293074,
        'dataSize': 293066,
        'type': 'mdat',
        'headerOffset': 534,
        'dataOffset': 542,
        'depth': 1
      }
    ]);
    await raf.close();
  });

  test('isFullBoxCallback', () async {
    final raf = await File('./test/test_files/a.mp4').open();
    final fileBox = ISOBox.fileBoxFromRandomAccessFile(raf);
    final moov = await fileBox.getDirectChildByTypes({'moov'});
    final mvhd =
        await moov!.getDirectChildByTypes({'mvhd'}, isFullBoxCallback: (type) {
      return type == 'mvhd';
    });
    expect(mvhd!.toDict(), {
      'boxSize': 108,
      'dataSize': 96,
      'type': 'mvhd',
      'headerOffset': 235800,
      'dataOffset': 235812,
      'fullBoxInt32': 0,
      'index': 0
    });
    await raf.close();
  });

  test('Extract data', () async {
    final raf = await File('./test/test_files/a.heic').open();
    final fileBox = ISOBox.fileBoxFromRandomAccessFile(raf);
    var s = '';
    await inspectISOBox(fileBox, callback: (box, depth) async {
      if (box.type == 'ispe') {
        final data = await box.extractData();
        s += '${data.toHex()}|';
      }
      return true;
    });
    expect(s, '00000000000005a0000003c0|00000000000000f0000000a0|');
    await raf.close();
  });

  test('toBytes', () async {
    final raf = await File('./test/test_files/a.heic').open();
    final fileBox = ISOBox.fileBoxFromRandomAccessFile(raf);
    // Get all direct children.
    final children = await fileBox.getDirectChildren();
    final bb = BytesBuilder();
    for (final child in children) {
      bb.add(await child.toBytes());
    }

    expect(bb.toBytes(), await File('./test/test_files/a.heic').readAsBytes());
    await raf.close();
  });
}
