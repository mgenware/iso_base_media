import '../iso_base_media.dart';

extension ISOBoxExt on ISOBoxBase {
  /// Returns a direct child box by given types.
  Future<ISOBox?> getDirectChildByTypes(
    Set<String> types, {
    required bool Function(String type, ISOBox? parent)? isContainerCallback,
    bool Function(String type, ISOBox? parent)? isFullBoxCallback,
  }) async {
    ISOBox? child;
    do {
      child = await nextChild(
          isContainerCallback: isContainerCallback,
          isFullBoxCallback: isFullBoxCallback);
      if (child != null && types.contains(child.type)) {
        return child;
      }
    } while (child != null);
    return null;
  }

  /// Returns a list of direct children by given types.
  Future<List<ISOBox>> getDirectChildrenByTypes(
    Set<String> types, {
    required bool Function(String type, ISOBox? parent)? isContainerCallback,
    bool Function(String type, ISOBox? parent)? isFullBoxCallback,
  }) async {
    final List<ISOBox> children = [];
    ISOBox? child;
    do {
      child = await nextChild(
          isContainerCallback: isContainerCallback,
          isFullBoxCallback: isFullBoxCallback);
      if (child != null && types.contains(child.type)) {
        children.add(child);
      }
    } while (child != null);
    return children;
  }

  /// Returns a child box by a given type path.
  Future<ISOBox?> getChildByTypePath(
    List<String> path, {
    required bool Function(String type, ISOBox? parent)? isContainerCallback,
    bool Function(String type, ISOBox? parent)? isFullBoxCallback,
  }) async {
    ISOBoxBase? box = this;
    for (final type in path) {
      if (box == null) {
        return null;
      }
      box = await box.getDirectChildByTypes(<String>{type},
          isContainerCallback: isContainerCallback,
          isFullBoxCallback: isFullBoxCallback);
    }
    return box is ISOBox ? box : null;
  }
}
