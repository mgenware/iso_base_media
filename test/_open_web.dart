import 'dart:js_interop';
import 'dart:typed_data';

import 'package:iso_base_media/iso_base_media.dart';
import 'package:random_access_source/random_access_source.dart';
import 'package:web/web.dart' as web;

Future<ISOBox> openFileBox(String name) async {
  final path = name.startsWith('/') ? name : 'test_files/$name';
  final src = await FileRASource.open(path);
  return ISOBox.fileBox(src);
}

@JS('fetch')
external JSPromise<web.Response> _fetch(JSAny uri);

Future<Uint8List> loadBytes(String name) async {
  final path = name.startsWith('/') ? name : 'test_files/$name';
  final res = await _fetch(path.toJS).toDart;
  return (await res.bytes().toDart).toDart;
}
