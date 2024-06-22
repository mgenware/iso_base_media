import 'package:iso_base_media/iso_base_media.dart';
import 'package:test/test.dart';

Future<void> testFile(String fileName, List<Object> expected) async {
  final fileBox = await ISOFileBox.open('./test/test_files/$fileName');
  final actual = await inspectISOBox(fileBox);
  expect(actual, expected);
  await fileBox.close();
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
          {'boxSize': 108, 'dataSize': 96, 'type': 'mvhd', 'fullBoxData': 0}
        ],
        [
          {'boxSize': 6083, 'dataSize': 6075, 'type': 'trak'},
          [
            {'boxSize': 92, 'dataSize': 80, 'type': 'tkhd', 'fullBoxData': 7}
          ],
          [
            {'boxSize': 5983, 'dataSize': 5975, 'type': 'mdia'},
            [
              {'boxSize': 32, 'dataSize': 20, 'type': 'mdhd', 'fullBoxData': 0}
            ],
            [
              {'boxSize': 36, 'dataSize': 24, 'type': 'hdlr', 'fullBoxData': 0}
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
                    'fullBoxData': 0
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
                    'fullBoxData': 0
                  }
                ],
                [
                  {
                    'boxSize': 24,
                    'dataSize': 12,
                    'type': 'stts',
                    'fullBoxData': 0
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
                    'fullBoxData': 0
                  }
                ],
                [
                  {
                    'boxSize': 1900,
                    'dataSize': 1888,
                    'type': 'stsz',
                    'fullBoxData': 0
                  }
                ],
                [
                  {
                    'boxSize': 1516,
                    'dataSize': 1504,
                    'type': 'stco',
                    'fullBoxData': 0
                  }
                ]
              ]
            ]
          ]
        ],
        [
          {'boxSize': 3519, 'dataSize': 3511, 'type': 'trak'},
          [
            {'boxSize': 92, 'dataSize': 80, 'type': 'tkhd', 'fullBoxData': 7}
          ],
          [
            {'boxSize': 3419, 'dataSize': 3411, 'type': 'mdia'},
            [
              {'boxSize': 32, 'dataSize': 20, 'type': 'mdhd', 'fullBoxData': 0}
            ],
            [
              {'boxSize': 36, 'dataSize': 24, 'type': 'hdlr', 'fullBoxData': 0}
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
                    'fullBoxData': 0
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
                    'fullBoxData': 0
                  }
                ],
                [
                  {
                    'boxSize': 24,
                    'dataSize': 12,
                    'type': 'stts',
                    'fullBoxData': 0
                  }
                ],
                [
                  {
                    'boxSize': 32,
                    'dataSize': 20,
                    'type': 'stss',
                    'fullBoxData': 0
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
                    'fullBoxData': 0
                  }
                ],
                [
                  {
                    'boxSize': 1520,
                    'dataSize': 1508,
                    'type': 'stsz',
                    'fullBoxData': 0
                  }
                ],
                [
                  {
                    'boxSize': 1516,
                    'dataSize': 1504,
                    'type': 'stco',
                    'fullBoxData': 0
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
        {'boxSize': 510, 'dataSize': 498, 'type': 'meta', 'fullBoxData': 0},
        [
          {'boxSize': 33, 'dataSize': 21, 'type': 'hdlr', 'fullBoxData': 0}
        ],
        [
          {'boxSize': 14, 'dataSize': 2, 'type': 'pitm', 'fullBoxData': 0}
        ],
        [
          {'boxSize': 52, 'dataSize': 40, 'type': 'iloc', 'fullBoxData': 0}
        ],
        [
          {'boxSize': 76, 'dataSize': 64, 'type': 'iinf', 'fullBoxData': 0}
        ],
        [
          {'boxSize': 26, 'dataSize': 14, 'type': 'iref', 'fullBoxData': 0},
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
    ]);
  });
}
