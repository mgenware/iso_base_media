import 'dart:io';
import 'dart:typed_data';

import 'package:iso_base_media/iso_base_media.dart';
import 'package:test/test.dart';

Future<void> testFile(String fileName, List<Object> expected,
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
    await testFile('a.mp4', [
      [
        {'boxSize': 32, 'dataSize': 24, 'type': 'ftyp'}
      ],
      [
        {'boxSize': 8, 'dataSize': 0, 'type': 'free'}
      ],
      [
        {'boxSize': 235752, 'dataSize': 235744, 'type': 'mdat'}
      ],
      [
        {'boxSize': 9718, 'dataSize': 9710, 'type': 'moov'},
        [
          {'boxSize': 108, 'dataSize': 96, 'type': 'mvhd', 'fullBoxInt32': 0}
        ],
        [
          {'boxSize': 6083, 'dataSize': 6075, 'type': 'trak'},
          [
            {'boxSize': 92, 'dataSize': 80, 'type': 'tkhd', 'fullBoxInt32': 7}
          ],
          [
            {'boxSize': 5983, 'dataSize': 5975, 'type': 'mdia'},
            [
              {'boxSize': 32, 'dataSize': 20, 'type': 'mdhd', 'fullBoxInt32': 0}
            ],
            [
              {'boxSize': 36, 'dataSize': 24, 'type': 'hdlr', 'fullBoxInt32': 0}
            ],
            [
              {'boxSize': 5907, 'dataSize': 5899, 'type': 'minf'},
              [
                {'boxSize': 16, 'dataSize': 8, 'type': 'smhd'}
              ],
              [
                {'boxSize': 36, 'dataSize': 28, 'type': 'dinf'},
                [
                  {
                    'boxSize': 28,
                    'dataSize': 16,
                    'type': 'dref',
                    'fullBoxInt32': 0
                  }
                ]
              ],
              [
                {'boxSize': 5847, 'dataSize': 5839, 'type': 'stbl'},
                [
                  {
                    'boxSize': 91,
                    'dataSize': 79,
                    'type': 'stsd',
                    'fullBoxInt32': 0
                  }
                ],
                [
                  {
                    'boxSize': 24,
                    'dataSize': 12,
                    'type': 'stts',
                    'fullBoxInt32': 0
                  }
                ],
                [
                  {'boxSize': 24, 'dataSize': 16, 'type': 'ctts'}
                ],
                [
                  {
                    'boxSize': 2284,
                    'dataSize': 2272,
                    'type': 'stsc',
                    'fullBoxInt32': 0
                  }
                ],
                [
                  {
                    'boxSize': 1900,
                    'dataSize': 1888,
                    'type': 'stsz',
                    'fullBoxInt32': 0
                  }
                ],
                [
                  {
                    'boxSize': 1516,
                    'dataSize': 1504,
                    'type': 'stco',
                    'fullBoxInt32': 0
                  }
                ]
              ]
            ]
          ]
        ],
        [
          {'boxSize': 3519, 'dataSize': 3511, 'type': 'trak'},
          [
            {'boxSize': 92, 'dataSize': 80, 'type': 'tkhd', 'fullBoxInt32': 7}
          ],
          [
            {'boxSize': 3419, 'dataSize': 3411, 'type': 'mdia'},
            [
              {'boxSize': 32, 'dataSize': 20, 'type': 'mdhd', 'fullBoxInt32': 0}
            ],
            [
              {'boxSize': 36, 'dataSize': 24, 'type': 'hdlr', 'fullBoxInt32': 0}
            ],
            [
              {'boxSize': 3343, 'dataSize': 3335, 'type': 'minf'},
              [
                {'boxSize': 20, 'dataSize': 12, 'type': 'vmhd'}
              ],
              [
                {'boxSize': 36, 'dataSize': 28, 'type': 'dinf'},
                [
                  {
                    'boxSize': 28,
                    'dataSize': 16,
                    'type': 'dref',
                    'fullBoxInt32': 0
                  }
                ]
              ],
              [
                {'boxSize': 3279, 'dataSize': 3271, 'type': 'stbl'},
                [
                  {
                    'boxSize': 127,
                    'dataSize': 115,
                    'type': 'stsd',
                    'fullBoxInt32': 0
                  }
                ],
                [
                  {
                    'boxSize': 24,
                    'dataSize': 12,
                    'type': 'stts',
                    'fullBoxInt32': 0
                  }
                ],
                [
                  {
                    'boxSize': 32,
                    'dataSize': 20,
                    'type': 'stss',
                    'fullBoxInt32': 0
                  }
                ],
                [
                  {'boxSize': 24, 'dataSize': 16, 'type': 'ctts'}
                ],
                [
                  {
                    'boxSize': 28,
                    'dataSize': 16,
                    'type': 'stsc',
                    'fullBoxInt32': 0
                  }
                ],
                [
                  {
                    'boxSize': 1520,
                    'dataSize': 1508,
                    'type': 'stsz',
                    'fullBoxInt32': 0
                  }
                ],
                [
                  {
                    'boxSize': 1516,
                    'dataSize': 1504,
                    'type': 'stco',
                    'fullBoxInt32': 0
                  }
                ]
              ]
            ]
          ]
        ]
      ],
      [
        {'boxSize': 237, 'dataSize': 229, 'type': 'free'}
      ]
    ]);
  });

  test('HEIC', () async {
    await testFile('a.heic', [
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
            {'boxSize': 263, 'dataSize': 255, 'type': 'ipco'},
            [
              {'boxSize': 108, 'dataSize': 100, 'type': 'hvcC'}
            ],
            [
              {'boxSize': 20, 'dataSize': 12, 'type': 'ispe'}
            ],
            [
              {'boxSize': 107, 'dataSize': 99, 'type': 'hvcC'}
            ],
            [
              {'boxSize': 20, 'dataSize': 12, 'type': 'ispe'}
            ]
          ],
          [
            {'boxSize': 26, 'dataSize': 18, 'type': 'ipma'}
          ]
        ]
      ],
      [
        {'boxSize': 293074, 'dataSize': 293066, 'type': 'mdat'}
      ]
    ]);
  });

  test('RAF', () async {
    final raf = await File('./test/test_files/a.jxl').open();
    // Skip the first 12 bytes.
    await raf.setPosition(12);
    await testFile(
        '',
        [
          [
            {'boxSize': 20, 'dataSize': 12, 'type': 'ftyp'}
          ],
          [
            {'boxSize': 20, 'dataSize': 12, 'type': 'jxlp'}
          ],
          [
            {'boxSize': 185, 'dataSize': 177, 'type': 'jbrd'}
          ],
          [
            {'boxSize': 675824, 'dataSize': 675816, 'type': 'jxlp'}
          ],
          [
            {'boxSize': 124, 'dataSize': 116, 'type': 'Exif'}
          ],
          [
            {
              'boxSize': 2895,
              'dataSize': 2883,
              'type': 'xml ',
              'fullBoxInt32': 1010792560
            }
          ]
        ],
        raf: raf);
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
