# iso_base_media

[![pub package](https://img.shields.io/pub/v/iso_base_media.svg)](https://pub.dev/packages/iso_base_media)
[![Build Status](https://github.com/mgenware/iso_base_media/workflows/Dart/badge.svg)](https://github.com/mgenware/iso_base_media/actions)

A dart package to parse ISO Base Media File Format (e.g. MP4, HEIC, AVIF, JXL files).

## Usage

### Extract `hvcC` boxes from an HEIC file

```dart
Future<void> main() async {
  final fileBox = await ISOBox.openFileBoxFromPath('./test/test_files/a.heic');
  final ipcoBox = await fileBox.getChildByTypePath(['meta', 'iprp', 'ipco']);
  if (ipcoBox == null) {
    print('ipco box not found');
    return;
  }
  final hvcCBoxList = await ipcoBox.getDirectChildrenByTypes({'hvcC'});
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
await fileBox.getChildByTypePath(['meta', 'iprp', 'ipco'], isContainerCallback: (type) {
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

### Extension methods

The base box class has some builtin extension methods:

```dart
extension ISOBoxExtension on ISOBoxBase {
  /// Return a list of direct children boxes.
  /// [isContainerCallback] is a callback to determine if a box is a container.
  /// [isFullBoxCallback] is a callback to determine if a box is a full box.
  /// [filter] is a callback to filter boxes.
  Future<List<ISOBox>> getDirectChildren({
    bool Function(String type)? isContainerCallback,
    bool Function(String type)? isFullBoxCallback,
    bool Function(ISOBox box)? filter,
  });

  /// Return a list of direct children boxes by a given async filter.
  /// [isContainerCallback] is a callback to determine if a box is a container.
  /// [isFullBoxCallback] is a callback to determine if a box is a full box.
  Future<List<ISOBox>> getDirectChildrenByAsyncFilter(
    Future<bool> Function(ISOBox box) filter, {
    bool Function(String type)? isContainerCallback,
    bool Function(String type)? isFullBoxCallback,
  });

  /// Returns a direct child box by given types.
  /// An empty [types] set will return the first child box.
  /// [isContainerCallback] is a callback to determine if a box is a container.
  /// [isFullBoxCallback] is a callback to determine if a box is a full box.
  Future<ISOBox?> getDirectChildByTypes(
    Set<String> types, {
    bool Function(String type)? isContainerCallback,
    bool Function(String type)? isFullBoxCallback,
  });

  /// Returns a list of direct children by given types.
  /// An empty [types] set will return all child boxes.
  /// [isContainerCallback] is a callback to determine if a box is a container.
  /// [isFullBoxCallback] is a callback to determine if a box is a full box.
  Future<List<ISOBox>> getDirectChildrenByTypes(
    Set<String> types, {
    bool Function(String type)? isContainerCallback,
    bool Function(String type)? isFullBoxCallback,
  });

  /// Returns a child box by a given type path.
  /// [isContainerCallback] is a callback to determine if a box is a container.
  /// [isFullBoxCallback] is a callback to determine if a box is a full box.
  Future<ISOBox?> getChildByTypePath(
    List<String> path, {
    bool Function(String type)? isContainerCallback,
    bool Function(String type)? isFullBoxCallback,
  });
}

/// Write a list of boxes to bytes.
Future<Uint8List> isoBoxesToBytes(List<ISOBox> boxes);
```
