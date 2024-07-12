import 'package:iso_base_media/iso_base_media.dart';
import 'package:test/test.dart';

Future<ISOFileBox> _openFile(String name) async {
  return await ISOFileBox.open('./test/test_files/$name');
}

void main() {
  test('getDirectChildByTypes', () async {
    final root = await _openFile('a.heic');
    final firstMatch = await root
        .getDirectChildByTypes({'ftyp', 'meta'}, isContainerCallback: null);
    expect(firstMatch!.toDict(), {
      'boxSize': 24,
      'dataSize': 16,
      'type': 'ftyp',
      'headerOffset': 0,
      'dataOffset': 8
    });
  });

  test('getDirectChildByTypes (empty)', () async {
    final root = await _openFile('a.heic');
    final firstMatch = await root
        .getDirectChildByTypes({'ftyp__', 'meta__'}, isContainerCallback: null);
    expect(firstMatch, null);
  });

  test('getDirectChildrenByTypes', () async {
    final root = await _openFile('a.heic');
    final matches = await root
        .getDirectChildrenByTypes({'ftyp', 'meta'}, isContainerCallback: null);
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
  });

  test('getDirectChildrenByTypes (empty)', () async {
    final root = await _openFile('a.heic');
    final matches = await root.getDirectChildrenByTypes({'ftyp__', 'meta__'},
        isContainerCallback: null);
    expect(matches, <ISOBox>[]);
  });

  test('getChildByTypePath', () async {
    final root = await _openFile('a.heic');
    final match = await root
        .getChildByTypePath(['meta', 'iinf'], isContainerCallback: null);
    expect(match!.toDict(), {
      'boxSize': 76,
      'dataSize': 64,
      'type': 'iinf',
      'headerOffset': 135,
      'dataOffset': 147,
      'fullBoxInt32': 0,
      'parent': 'meta'
    });
  });

  test('getChildByTypePath (empty)', () async {
    final root = await _openFile('a.heic');
    final match = await root
        .getChildByTypePath(['meta__', 'iinf__'], isContainerCallback: null);
    expect(match, null);
  });

  test('rootBox.seek', () async {
    final root = await _openFile('a.heic');
    await root
        .getDirectChildByTypes({'ftyp', 'meta'}, isContainerCallback: null);
    await root.seek(0);
    final firstMatch = await root
        .getDirectChildByTypes({'ftyp', 'meta'}, isContainerCallback: null);
    expect(firstMatch!.toDict(), {
      'boxSize': 24,
      'dataSize': 16,
      'type': 'ftyp',
      'headerOffset': 0,
      'dataOffset': 8
    });
  });

  test('childBox.seek', () async {
    final root = await _openFile('a.heic');
    final meta =
        await root.getDirectChildByTypes({'meta'}, isContainerCallback: null);
    final match1 =
        await meta!.getDirectChildByTypes({'iinf'}, isContainerCallback: null);
    final dict1 = match1!.toDict();

    await meta.seek(0);
    final match2 =
        await meta.getDirectChildByTypes({'iinf'}, isContainerCallback: null);
    final dict2 = match2!.toDict();

    expect(dict1, dict2);
  });
}
