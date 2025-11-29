// ignore_for_file: avoid_print

import 'package:iso_base_media/iso_base_media.dart';
import 'package:random_access_source/random_access_source.dart';

Future<void> main() async {
  final src = await FileRASource.openPath('./test/test_files/a.heic');
  final rootBox = ISOBox.createRootBox();
  final ipcoBox =
      await rootBox.getChildByTypePath(src, ['meta', 'iprp', 'ipco']);
  if (ipcoBox == null) {
    print('ipco box not found');
    return;
  }
  final hvcCBoxList = await ipcoBox.getDirectChildrenByTypes(src, {'hvcC'});
  if (hvcCBoxList.isEmpty) {
    print('hvcC box not found');
    return;
  }
  for (final hvcCBox in hvcCBoxList) {
    print('hvcC: start: ${hvcCBox.headerOffset}, size: ${hvcCBox.boxSize}');
  }
}
