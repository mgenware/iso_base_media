import 'dart:io';
import 'dart:typed_data';

import 'package:iso_base_media/iso_base_media.dart';
import 'package:random_access_source/random_access_source.dart';

Future<ISOBox> openFileBox(String name) async {
  final path = name.startsWith('/') ? name : './test/test_files/$name';
  final src = await FileRASource.open(path);
  return ISOBox.fileBox(src);
}

Future<Uint8List> loadBytes(String name) {
  final path = name.startsWith('/') ? name : './test/test_files/$name';
  return File(path).readAsBytes();
}
