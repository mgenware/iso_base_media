import 'dart:io';

import 'package:iso_base_media/iso_base_media.dart';
import 'package:test/test.dart';

Future<ISOSourceBox> _openFile(String name) async {
  final raf = await File('test/test_files/$name').open();
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
}
