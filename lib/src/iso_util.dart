import '../iso_base_media.dart';

extension ISOBoxExt on ISOBoxBase {
  /// Returns a direct child box by given types.
  Future<ISOBox?> getDirectChildByTypes(Set<String> types,
      {required bool Function(String type, ISOBox? parent)?
          isContainerCallback}) async {
    ISOBox? child;
    do {
      child = await nextChild(isContainerCallback: isContainerCallback);
      if (child != null && types.contains(child.type)) {
        return child;
      }
    } while (child != null);
    return null;
  }

  /// Returns a list of direct children by given types.
  Future<List<ISOBox>> getDirectChildrenByTypes(Set<String> types,
      {required bool Function(String type, ISOBox? parent)?
          isContainerCallback}) async {
    final List<ISOBox> children = [];
    ISOBox? child;
    do {
      child = await nextChild(isContainerCallback: isContainerCallback);
      if (child != null && types.contains(child.type)) {
        children.add(child);
      }
    } while (child != null);
    return children;
  }

  /// Returns a child box by a given type path.
  Future<ISOBox?> getChildByTypePath(List<String> path,
      {required bool Function(String type, ISOBox? parent)?
          isContainerCallback}) async {
    ISOBoxBase? box = this;
    for (final type in path) {
      if (box == null) {
        return null;
      }
      box = await box.getDirectChildByTypes(<String>{type},
          isContainerCallback: isContainerCallback);
    }
    return box == null ? null : box as ISOBox;
  }
}
