import 'package:iso_base_media/iso_base_media.dart';
import 'package:random_access_source/random_access_source.dart';
import 'package:test/test.dart';

import 'common.dart';

Future<(RandomAccessSource, ISOBox, ISOBoxFtypData?)> _ftypBox(
    String file) async {
  final src = await loadFileSrc(file);
  final root = ISOBox.createRootBox();
  final ftyp = await root.getDirectChildByTypes(src, {'ftyp'});
  return (src, root, await ftyp?.parseFtyp(src));
}

void main() {
  test('ftyp (a.heic)', () async {
    final (src, root, ftyp) = await _ftypBox('a.heic');
    expect(ftyp.toString(),
        'ISOBoxFtypData(majorBrand: mif1, minorVersion: 0, compatibleBrands: [mif1, heic])');
    await src.close();
  });
  test('ftyp (a.jxl)', () async {
    final (src, root, ftyp) = await _ftypBox('a.jxl');
    expect(ftyp.toString(),
        'ISOBoxFtypData(majorBrand: jxl , minorVersion: 0, compatibleBrands: [jxl ])');
    await src.close();
  });
  test('ftyp (hdr.avif)', () async {
    final (src, root, ftyp) = await _ftypBox('hdr.avif');
    expect(ftyp.toString(),
        'ISOBoxFtypData(majorBrand: avif, minorVersion: 0, compatibleBrands: [avif, mif1, miaf, MA1A, tmap])');
    await src.close();
  });
  test('ftyp (a.mp4)', () async {
    final (src, root, ftyp) = await _ftypBox('a.mp4');
    expect(ftyp.toString(),
        'ISOBoxFtypData(majorBrand: mp42, minorVersion: 0, compatibleBrands: [avc1, isom, mp42, avc1])');
    await src.close();
  });
  test('Empty compat ftypes', () async {
    final (src, root, ftyp) = await _ftypBox('xmp.mov');
    expect(ftyp.toString(),
        'ISOBoxFtypData(majorBrand: qt  , minorVersion: 537199360, compatibleBrands: [qt  ])');
    await src.close();
  });
}
