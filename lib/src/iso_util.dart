import 'dart:typed_data';

import 'package:random_access_source/random_access_source.dart';

import '../iso_base_media.dart';

extension ISOBoxExtension on ISOBox {
  /// Return a list of direct children boxes.
  /// [isFullBoxCallback] is a callback to determine if a box is a full box.
  /// [filter] is a callback to filter boxes.
  Future<List<ISOBox>> getDirectChildren(
    RandomAccessSource src, {
    bool Function(String type)? isFullBoxCallback,
    bool Function(ISOBox box)? filter,
  }) async {
    final List<ISOBox> children = [];
    ISOBox? child;
    var i = 0;
    do {
      child = await nextChild(
        src,
        isFullBoxCallback: isFullBoxCallback,
        index: i++,
      );
      if (child != null && (filter == null || filter(child))) {
        children.add(child);
      }
    } while (child != null);
    return children;
  }

  /// Return a list of direct children boxes by a given async filter.
  /// [isFullBoxCallback] is a callback to determine if a box is a full box.
  Future<List<ISOBox>> getDirectChildrenByAsyncFilter(
    RandomAccessSource src,
    Future<bool> Function(ISOBox box) filter, {
    bool Function(String type)? isFullBoxCallback,
  }) async {
    final List<ISOBox> children = [];
    ISOBox? child;
    var i = 0;
    do {
      child = await nextChild(
        src,
        isFullBoxCallback: isFullBoxCallback,
        index: i++,
      );
      if (child != null && (await filter(child))) {
        children.add(child);
      }
    } while (child != null);
    return children;
  }

  /// Returns a direct child box by given types.
  /// An empty [types] set will return the first child box.
  /// [isFullBoxCallback] is a callback to determine if a box is a full box.
  Future<ISOBox?> getDirectChildByTypes(
    RandomAccessSource src,
    Set<String> types, {
    bool Function(String type)? isFullBoxCallback,
  }) async {
    ISOBox? child;
    final matchAll = types.isEmpty;
    var i = 0;
    do {
      child = await nextChild(
        src,
        isFullBoxCallback: isFullBoxCallback,
        index: i++,
      );
      if (child != null && (matchAll || types.contains(child.type))) {
        return child;
      }
    } while (child != null);
    return null;
  }

  /// Returns a list of direct children by given types.
  /// An empty [types] set will return all child boxes.
  /// [isFullBoxCallback] is a callback to determine if a box is a full box.
  Future<List<ISOBox>> getDirectChildrenByTypes(
    RandomAccessSource src,
    Set<String> types, {
    bool Function(String type)? isFullBoxCallback,
  }) async {
    return getDirectChildren(src,
        isFullBoxCallback: isFullBoxCallback,
        filter: (box) => types.isEmpty || types.contains(box.type));
  }

  /// Returns a child box by a given type path.
  /// [isFullBoxCallback] is a callback to determine if a box is a full box.
  Future<ISOBox?> getChildByTypePath(
    RandomAccessSource src,
    List<String> path, {
    bool Function(String type)? isFullBoxCallback,
  }) async {
    ISOBox? box = this;
    for (final type in path) {
      if (box == null) {
        return null;
      }
      box = await box.getDirectChildByTypes(src, <String>{type},
          isFullBoxCallback: isFullBoxCallback);
    }
    return box;
  }
}

/// Write a list of boxes to bytes.
Future<Uint8List> isoBoxesToBytes(
    RandomAccessSource src, List<ISOBox> boxes) async {
  final bb = BytesBuilder();
  for (final box in boxes) {
    bb.add(await box.toBytes(src));
  }
  return bb.toBytes();
}
