import 'dart:js_interop';

import 'package:random_access_source/random_access_source.dart';
import 'package:web/web.dart' as web;

Future<RandomAccessSource> loadFileSrc(String name) async {
  final path = name.startsWith('/') ? name : 'test_files/$name';
  final src = await FileRASource.openPath(path);
  return src;
}

@JS('fetch')
external JSPromise<web.Response> _fetch(JSAny uri);

Future<RandomAccessSource> loadBytesSrc(String name) async {
  final path = name.startsWith('/') ? name : 'test_files/$name';
  final res = await _fetch(path.toJS).toDart;
  final bytes = (await res.bytes().toDart).toDart;
  return BytesRASource(bytes);
}

bool canSend(Object? value) => true;
