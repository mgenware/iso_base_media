# iso_base_media

[![pub package](https://img.shields.io/pub/v/iso_base_media.svg)](https://pub.dev/packages/iso_base_media)
[![Build Status](https://github.com/mgenware/iso_base_media/workflows/Dart/badge.svg)](https://github.com/mgenware/iso_base_media/actions)

A dart package to parse ISO Base Media File Format (e.g. MP4, HEIC, AVIF, JXL files).

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

### Determine which boxes are containers or full boxes

This package comes with a default set of rules to determine if a box is a container or a full box. You can provide your own rules via `isContainerCallback` and `isFullBoxCallback`.

```dart
await fileBox.getChildByTypePath(src, ['meta', 'iprp', 'ipco'], isContainerCallback: (type) {
  // Only `meta` box is considered a container.
  if (type == 'meta') {
    return true;
  }
  return false;
}, isFullBoxCallback: (type) {
  // Only `mvhd` box is considered a full box.
  if (type == 'mvhd') {
    return true;
  }
  return false;
});
```
