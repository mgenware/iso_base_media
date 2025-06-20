import 'dart:typed_data';

import '../iso_base_media.dart';

extension ISOBoxExtension on ISOBox {
  /// Return a list of direct children boxes.
  /// [isContainerCallback] is a callback to determine if a box is a container.
  /// [isFullBoxCallback] is a callback to determine if a box is a full box.
  /// [filter] is a callback to filter boxes.
  Future<List<ISOBox>> getDirectChildren({
    bool Function(String type)? isContainerCallback,
    bool Function(String type)? isFullBoxCallback,
    bool Function(ISOBox box)? filter,
  }) async {
    final List<ISOBox> children = [];
    ISOBox? child;
    var i = 0;
    do {
      child = await nextChild(
        isContainerCallback: isContainerCallback,
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
  /// [isContainerCallback] is a callback to determine if a box is a container.
  /// [isFullBoxCallback] is a callback to determine if a box is a full box.
  Future<List<ISOBox>> getDirectChildrenByAsyncFilter(
    Future<bool> Function(ISOBox box) filter, {
    bool Function(String type)? isContainerCallback,
    bool Function(String type)? isFullBoxCallback,
  }) async {
    final List<ISOBox> children = [];
    ISOBox? child;
    var i = 0;
    do {
      child = await nextChild(
        isContainerCallback: isContainerCallback,
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
  /// [isContainerCallback] is a callback to determine if a box is a container.
  /// [isFullBoxCallback] is a callback to determine if a box is a full box.
  Future<ISOBox?> getDirectChildByTypes(
    Set<String> types, {
    bool Function(String type)? isContainerCallback,
    bool Function(String type)? isFullBoxCallback,
  }) async {
    ISOBox? child;
    final matchAll = types.isEmpty;
    var i = 0;
    do {
      child = await nextChild(
        isContainerCallback: isContainerCallback,
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
  /// [isContainerCallback] is a callback to determine if a box is a container.
  /// [isFullBoxCallback] is a callback to determine if a box is a full box.
  Future<List<ISOBox>> getDirectChildrenByTypes(
    Set<String> types, {
    bool Function(String type)? isContainerCallback,
    bool Function(String type)? isFullBoxCallback,
  }) async {
    return getDirectChildren(
        isContainerCallback: isContainerCallback,
        isFullBoxCallback: isFullBoxCallback,
        filter: (box) => types.isEmpty || types.contains(box.type));
  }

  /// Returns a child box by a given type path.
  /// [isContainerCallback] is a callback to determine if a box is a container.
  /// [isFullBoxCallback] is a callback to determine if a box is a full box.
  Future<ISOBox?> getChildByTypePath(
    List<String> path, {
    bool Function(String type)? isContainerCallback,
    bool Function(String type)? isFullBoxCallback,
  }) async {
    ISOBox? box = this;
    for (final type in path) {
      if (box == null) {
        return null;
      }
      box = await box.getDirectChildByTypes(<String>{type},
          isContainerCallback: isContainerCallback,
          isFullBoxCallback: isFullBoxCallback);
    }
    return box;
  }
}

/// Write a list of boxes to bytes.
Future<Uint8List> isoBoxesToBytes(List<ISOBox> boxes) async {
  final bb = BytesBuilder();
  for (final box in boxes) {
    bb.add(await box.toBytes());
  }
  return bb.toBytes();
}
