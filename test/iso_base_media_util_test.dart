import 'package:iso_base_media/iso_base_media.dart';
import 'package:test/test.dart';

import 'common.dart';

void main() {
  test('getDirectChildByTypes', () async {
    final root = await openFileBox('a.heic');
    final firstMatch = await root.getDirectChildByTypes({'ftyp', 'meta'});
    expect(firstMatch!.toDict(), {
      'boxSize': 24,
      'dataSize': 16,
      'type': 'ftyp',
      'headerOffset': 0,
      'dataOffset': 8,
      'index': 0
    });
    await root.close();
  });

  test('getDirectChildByTypes (empty)', () async {
    final root = await openFileBox('a.heic');
    final firstMatch = await root.getDirectChildByTypes({'ftyp__', 'meta__'});
    expect(firstMatch, null);
    await root.close();
  });

  test('getDirectChildrenByTypes', () async {
    final root = await openFileBox('a.heic');
    final matches = await root.getDirectChildrenByTypes({'ftyp', 'meta'});
    expect(matches.map((e) => e.toDict()).toList(), [
      {
        'boxSize': 24,
        'dataSize': 16,
        'type': 'ftyp',
        'headerOffset': 0,
        'dataOffset': 8,
        'index': 0
      },
      {
        'boxSize': 510,
        'dataSize': 498,
        'type': 'meta',
        'headerOffset': 24,
        'dataOffset': 36,
        'fullBoxInt32': 0,
        'index': 1
      }
    ]);
    await root.close();
  });

  test('getDirectChildrenByAsyncFilter', () async {
    final root = await openFileBox('a.heic');
    final matches = await root.getDirectChildrenByAsyncFilter((box) async {
      return box.type == 'ftyp' || box.type == 'meta';
    });
    expect(matches.map((e) => e.toDict()).toList(), [
      {
        'boxSize': 24,
        'dataSize': 16,
        'type': 'ftyp',
        'headerOffset': 0,
        'dataOffset': 8,
        'index': 0
      },
      {
        'boxSize': 510,
        'dataSize': 498,
        'type': 'meta',
        'headerOffset': 24,
        'dataOffset': 36,
        'fullBoxInt32': 0,
        'index': 1
      }
    ]);
    await root.close();
  });

  test('getDirectChildrenByTypes (empty)', () async {
    final root = await openFileBox('a.heic');
    final matches = await root.getDirectChildrenByTypes({'ftyp__', 'meta__'});
    expect(matches, <ISOBox>[]);
    await root.close();
  });

  test('getChildByTypePath', () async {
    final root = await openFileBox('a.heic');
    final match = await root.getChildByTypePath(['meta', 'iinf']);
    expect(match!.toDict(), {
      'boxSize': 76,
      'dataSize': 64,
      'type': 'iinf',
      'headerOffset': 135,
      'dataOffset': 147,
      'fullBoxInt32': 0,
      'index': 3
    });
    await root.close();
  });

  test('getChildByTypePath (empty)', () async {
    final root = await openFileBox('a.heic');
    final match = await root.getChildByTypePath(['meta__', 'iinf__']);
    expect(match, null);
    await root.close();
  });

  test('rootBox.seekInData', () async {
    final root = await openFileBox('a.heic');
    await root.getDirectChildByTypes({'ftyp', 'meta'});
    await root.seekInData(0);
    final firstMatch = await root.getDirectChildByTypes({'ftyp', 'meta'});
    expect(firstMatch!.toDict(), {
      'boxSize': 24,
      'dataSize': 16,
      'type': 'ftyp',
      'headerOffset': 0,
      'dataOffset': 8,
      'index': 0
    });
    await root.close();
  });

  test('childBox.seekInData', () async {
    final root = await openFileBox('a.heic');
    final meta = await root.getDirectChildByTypes({'meta'});
    final match1 = await meta!.getDirectChildByTypes({'iinf'});
    final dict1 = match1!.toDict();

    await meta.seekInData(0);
    final match2 = await meta.getDirectChildByTypes({'iinf'});
    final dict2 = match2!.toDict();

    expect(dict1, dict2);
    await root.close();
  });

  test('boxesToBytes', () async {
    final root = await openFileBox('a.heic');
    final matches =
        await root.getDirectChildren(filter: (box) => box.type != 'mdat');
    final bytes = await isoBoxesToBytes(matches);

    final newBox = ISOBox.fileBoxFromBytes(bytes);
    expect(await inspectISOBox(newBox), {
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
              'fullBoxInt32': 0
            },
            {
              'boxSize': 14,
              'dataSize': 2,
              'type': 'pitm',
              'headerOffset': 69,
              'dataOffset': 81,
              'fullBoxInt32': 0
            },
            {
              'boxSize': 52,
              'dataSize': 40,
              'type': 'iloc',
              'headerOffset': 83,
              'dataOffset': 95,
              'fullBoxInt32': 0
            },
            {
              'boxSize': 76,
              'dataSize': 64,
              'type': 'iinf',
              'headerOffset': 135,
              'dataOffset': 147,
              'fullBoxInt32': 0
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
                  'dataOffset': 231
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
                      'dataOffset': 261
                    },
                    {
                      'boxSize': 20,
                      'dataSize': 8,
                      'type': 'ispe',
                      'headerOffset': 361,
                      'dataOffset': 373,
                      'fullBoxInt32': 0
                    },
                    {
                      'boxSize': 107,
                      'dataSize': 99,
                      'type': 'hvcC',
                      'headerOffset': 381,
                      'dataOffset': 389
                    },
                    {
                      'boxSize': 20,
                      'dataSize': 8,
                      'type': 'ispe',
                      'headerOffset': 488,
                      'dataOffset': 500,
                      'fullBoxInt32': 0
                    }
                  ]
                },
                {
                  'boxSize': 26,
                  'dataSize': 14,
                  'type': 'ipma',
                  'headerOffset': 508,
                  'dataOffset': 520,
                  'fullBoxInt32': 0
                }
              ]
            }
          ]
        }
      ]
    });
    await root.close();
  });
}
