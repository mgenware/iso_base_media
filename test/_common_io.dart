import 'dart:io';
import 'dart:isolate';

import 'package:random_access_source/random_access_source.dart';

Future<RandomAccessSource> loadFileSrc(String name) async {
  final path = name.startsWith('/') ? name : './test/test_files/$name';
  final src = await FileRASource.openPath(path);
  return src;
}

Future<RandomAccessSource> loadBytesSrc(String name) async {
  final path = name.startsWith('/') ? name : './test/test_files/$name';
  final bytes = await File(path).readAsBytes();
  return BytesRASource(bytes);
}

bool canSend(Object? o) {
  final rp = ReceivePort();
  rp.sendPort.send(o);
  rp.close();
  return true;
}
