// ignore_for_file: avoid_print

import 'package:iso_base_media/iso_base_media.dart';

Future<void> main() async {
  final fileBox = await ISOBox.openFileBoxFromPath('./test/test_files/a.heic');
  final ipcoBox = await fileBox.getChildByTypePath(['meta', 'iprp', 'ipco']);
  if (ipcoBox == null) {
    print('ipco box not found');
    return;
  }
  final hvcCBoxList = await ipcoBox.getDirectChildrenByTypes({'hvcC'});
  if (hvcCBoxList.isEmpty) {
    print('hvcC box not found');
    return;
  }
  for (final hvcCBox in hvcCBoxList) {
    print('hvcC: start: ${hvcCBox.headerOffset}, size: ${hvcCBox.boxSize}');
  }
}
