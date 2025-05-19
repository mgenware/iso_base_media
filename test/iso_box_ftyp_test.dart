import 'package:iso_base_media/iso_base_media.dart';
import 'package:test/test.dart';

import 'common.dart';

Future<(ISOBox, ISOBoxFtypData?)> _ftypBox(String file) async {
  final root = await openFileBox(file);
  final ftyp = await root.getDirectChildByTypes({'ftyp'});
  return (root, await ftyp?.parseFtyp());
}

void main() {
  test('ftyp (a.heic)', () async {
    final (root, ftyp) = await _ftypBox('a.heic');
    expect(ftyp.toString(),
        'ISOBoxFtypData(majorBrand: mif1, minorVersion: 0, compatibleBrands: [mif1, heic])');
    await root.close();
  });
  test('ftyp (a.jxl)', () async {
    final (root, ftyp) = await _ftypBox('a.jxl');
    expect(ftyp.toString(),
        'ISOBoxFtypData(majorBrand: jxl , minorVersion: 0, compatibleBrands: [jxl ])');
    await root.close();
  });
  test('ftyp (hdr.avif)', () async {
    final (root, ftyp) = await _ftypBox('hdr.avif');
    expect(ftyp.toString(),
        'ISOBoxFtypData(majorBrand: avif, minorVersion: 0, compatibleBrands: [avif, mif1, miaf, MA1A, tmap])');
    await root.close();
  });
  test('ftyp (a.mp4)', () async {
    final (root, ftyp) = await _ftypBox('a.mp4');
    expect(ftyp.toString(),
        'ISOBoxFtypData(majorBrand: mp42, minorVersion: 0, compatibleBrands: [avc1, isom, mp42, avc1])');
    await root.close();
  });
  test('Empty compat ftypes', () async {
    final (root, ftyp) = await _ftypBox('xmp.mov');
    expect(ftyp.toString(),
        'ISOBoxFtypData(majorBrand: qt  , minorVersion: 537199360, compatibleBrands: [qt  ])');
    await root.close();
  });
}
