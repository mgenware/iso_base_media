// ignore_for_file: avoid_print

import 'dart:io';

import 'package:iso_base_media/iso_base_media.dart';

Future<void> main() async {
  // This is an example to remove the mdat box from an HEIC file.
  final src = './test/IMG_0068.heic';
  final fileBox = await ISOBox.openFileBoxFromPath(src);
  final dest = src.replaceFirst('.heic', '_no_mdat.heic');
  final children = await fileBox.getDirectChildrenByAsyncFilter((box) async {
    if (box.type == 'mdat') {
      print('remove mdat: start: ${box.headerOffset}, size: ${box.boxSize}');
      return false;
    }
    return true;
  });
  final destBytes = await isoBoxesToBytes(children);
  await File(dest).writeAsBytes(destBytes);
}
