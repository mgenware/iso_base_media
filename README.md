# iso_base_media

[![pub package](https://img.shields.io/pub/v/iso_base_media.svg)](https://pub.dev/packages/iso_base_media)
[![Build Status](https://github.com/mgenware/iso_base_media/workflows/Dart/badge.svg)](https://github.com/mgenware/iso_base_media/actions)

A dart package to parse ISO Base Media File Format.

## Usage

### Extract `hvcC` boxes from an HEIC file

```dart
Future<void> main() async {
  final src = await FileRASource.openPath('./test/test_files/a.heic');
  final fileBox = ISOBox.createRootBox();
  final ipcoBox = await fileBox.getChildByTypePath(src, ['meta', 'iprp', 'ipco']);
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
  /**
    * Output:
    hvcC: start: 253, size: 108
    hvcC: start: 381, size: 107
   */
}

```
