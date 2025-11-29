// ignore_for_file: avoid_print

import 'dart:io';

import 'package:iso_base_media/iso_base_media.dart';
import 'package:random_access_source/random_access_source.dart';

Future<void> main() async {
  // This is an example to remove the mdat box from an HEIC file.
  final srcPath = './test/test_files/a.heic';
  final src = await FileRASource.openPath(srcPath);
  final fileBox = ISOBox.createRootBox();
  final destPath = srcPath.replaceFirst('.heic', '_no_mdat.heic');
  final children =
      await fileBox.getDirectChildrenByAsyncFilter(src, (box) async {
    if (box.type == 'mdat') {
      print('remove mdat: start: ${box.headerOffset}, size: ${box.boxSize}');
      return false;
    }
    return true;
  });
  final destBytes = await isoBoxesToBytes(src, children);
  await File(destPath).writeAsBytes(destBytes);
}
