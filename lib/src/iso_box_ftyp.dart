import 'dart:typed_data';

import '../iso_base_media.dart';

class ISOBoxFtypData {
  final String majorBrand;
  final int minorVersion;
  final List<String> compatibleBrands;

  ISOBoxFtypData({
    required this.majorBrand,
    required this.minorVersion,
    required this.compatibleBrands,
  });

  @override
  String toString() {
    return 'ISOBoxFtypData(majorBrand: $majorBrand, minorVersion: $minorVersion, compatibleBrands: $compatibleBrands)';
  }
}

extension ISOBoxFtypExtension on ISOBox {
  Future<ISOBoxFtypData?> parseFtyp() async {
    if (type != 'ftyp') {
      return null;
    }
    final data = await extractData();
    if (data.isEmpty) {
      return null;
    }
    final majorBrand = String.fromCharCodes(data.sublist(0, 4));
    final minorVersion = ByteData.sublistView(data, 4, 8).getUint32(0);
    final compatibleBrands = <String>[];
    if (data.length > 8) {
      for (int i = 8; i < data.length; i += 4) {
        if (i + 4 <= data.length) {
          final brand = String.fromCharCodes(data.sublist(i, i + 4));
          // Ignore \x00\x00\x00\x00
          if (brand == '\x00\x00\x00\x00') {
            continue;
          }
          compatibleBrands.add(brand);
        }
      }
    }
    return ISOBoxFtypData(
      majorBrand: majorBrand,
      minorVersion: minorVersion,
      compatibleBrands: compatibleBrands,
    );
  }
}
