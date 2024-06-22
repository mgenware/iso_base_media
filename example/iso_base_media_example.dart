// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:iso_base_media/iso_base_media.dart';

Future<void> inspect() async {
  final fileBox = await ISOFileBox.open('./test/test_files/a.heic');
  await inspectISOBox(fileBox);
  await fileBox.close();
}

Future<void> extract() async {
  final fileBox = await ISOFileBox.open('./test/test_files/a.heic');
  var s = '';
  await inspectISOBox(fileBox, callback: (box, depth) async {
    if (box.type == 'ispe') {
      final data = await box.extractData();
      s += '${uint8ListToHex(data)}\n';
    }
  });
  print(s);
  await fileBox.close();
}

String uint8ListToHex(Uint8List bytes) {
  final StringBuffer buffer = StringBuffer();
  buffer.write('bytes(${bytes.length}): ');
  for (int byte in bytes) {
    buffer.write(byte.toRadixString(16).padLeft(2, '0'));
    buffer.write(' ');
  }
  return buffer.toString();
}

void main() async {
  await inspect();
  await extract();
}
