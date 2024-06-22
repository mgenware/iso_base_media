import 'package:iso_base_media/iso_base_media.dart';

void main() async {
  final fileBox = await ISOFileBox.open('./test/test_files/a.heic');
  final description = await inspectISOBox(fileBox);
  await fileBox.close();
  print(description);

  /*
    [
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
    ]
  */
}
