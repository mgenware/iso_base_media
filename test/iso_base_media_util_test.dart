import 'dart:io';

import 'package:iso_base_media/iso_base_media.dart';
import 'package:test/test.dart';

Future<ISOSourceBox> _openFile(String name) async {
  final raf =
      await File(name.startsWith('/') ? name : 'test/test_files/$name').open();
  return ISOSourceBox.fromRandomAccessFile(raf);
}

void main() {
  test('getDirectChildByTypes', () async {
    final root = await _openFile('a.heic');
    final firstMatch = await root.getDirectChildByTypes({'ftyp', 'meta'});
    expect(firstMatch!.toDict(), {
      'boxSize': 24,
      'dataSize': 16,
      'type': 'ftyp',
      'headerOffset': 0,
      'dataOffset': 8
    });
    await root.close();
  });

  test('getDirectChildByTypes (empty)', () async {
    final root = await _openFile('a.heic');
    final firstMatch = await root.getDirectChildByTypes({'ftyp__', 'meta__'});
    expect(firstMatch, null);
    await root.close();
  });

  test('getDirectChildrenByTypes', () async {
    final root = await _openFile('a.heic');
    final matches = await root.getDirectChildrenByTypes({'ftyp', 'meta'});
    expect(matches.map((e) => e.toDict()).toList(), [
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
        'fullBoxInt32': 0
      }
    ]);
    await root.close();
  });

  test('getDirectChildrenByAsyncFilter', () async {
    final root = await _openFile('a.heic');
    final matches = await root.getDirectChildrenByAsyncFilter((box) async {
      return box.type == 'ftyp' || box.type == 'meta';
    });
    expect(matches.map((e) => e.toDict()).toList(), [
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
        'fullBoxInt32': 0
      }
    ]);
    await root.close();
  });

  test('getDirectChildrenByTypes (empty)', () async {
    final root = await _openFile('a.heic');
    final matches = await root.getDirectChildrenByTypes({'ftyp__', 'meta__'});
    expect(matches, <ISOBox>[]);
    await root.close();
  });

  test('getChildByTypePath', () async {
    final root = await _openFile('a.heic');
    final match = await root.getChildByTypePath(['meta', 'iinf']);
    expect(match!.toDict(), {
      'boxSize': 76,
      'dataSize': 64,
      'type': 'iinf',
      'headerOffset': 135,
      'dataOffset': 147,
      'fullBoxInt32': 0,
      'parent': 'meta'
    });
    await root.close();
  });

  test('getChildByTypePath (empty)', () async {
    final root = await _openFile('a.heic');
    final match = await root.getChildByTypePath(['meta__', 'iinf__']);
    expect(match, null);
    await root.close();
  });

  test('rootBox.seek', () async {
    final root = await _openFile('a.heic');
    await root.getDirectChildByTypes({'ftyp', 'meta'});
    await root.seek(0);
    final firstMatch = await root.getDirectChildByTypes({'ftyp', 'meta'});
    expect(firstMatch!.toDict(), {
      'boxSize': 24,
      'dataSize': 16,
      'type': 'ftyp',
      'headerOffset': 0,
      'dataOffset': 8
    });
    await root.close();
  });

  test('childBox.seek', () async {
    final root = await _openFile('a.heic');
    final meta = await root.getDirectChildByTypes({'meta'});
    final match1 = await meta!.getDirectChildByTypes({'iinf'});
    final dict1 = match1!.toDict();

    await meta.seek(0);
    final match2 = await meta.getDirectChildByTypes({'iinf'});
    final dict2 = match2!.toDict();

    expect(dict1, dict2);
    await root.close();
  });

  test('boxesToBytes', () async {
    final root = await _openFile('a.heic');
    final matches =
        await root.getDirectChildren(filter: (box) => box.type != 'mdat');
    final bytes = await root.boxesToBytes(matches);

    final newSource = ISOSourceBox.fromBytes(bytes);
    expect(await inspectISOBox(newSource), {
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
        }
      ]
    });
    await root.close();
  });
}
