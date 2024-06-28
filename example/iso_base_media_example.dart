// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:iso_base_media/iso_base_media.dart';

Future<void> inspect() async {
  final fileBox = await ISOFileBox.open('./test/test_files/a.heic');
  final s = await inspectISOBox(fileBox);
  await fileBox.close();
  print(s);
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
  await fileBox.close();
  print(s);
}

String uint8ListToHex(Uint8List bytes) {
  final StringBuffer buffer = StringBuffer();
  buffer.write('bytes(${bytes.length}): ');
  for (final byte in bytes) {
    buffer.write(byte.toRadixString(16).padLeft(2, '0'));
    buffer.write(' ');
  }
  return buffer.toString();
}

void main() async {
  await inspect();
  print('-----------------------');
  await extract();
}
