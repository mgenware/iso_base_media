import '../iso_base_media.dart';

extension ISOBoxExt on ISOBoxBase {
  /// Returns a child box by a given type.
  Future<ISOBox?> getChildByType(String type,
      {required bool Function(String type, ISOBox? parent)?
          isContainerCallback}) async {
    ISOBox? child;
    do {
      child = await nextChild(isContainerCallback: isContainerCallback);
      if (child?.type == type) {
        return child;
      }
    } while (child != null);
    return null;
  }

  /// Returns a list of children by a given type.
  Future<List<ISOBox>> getChildrenByType(String type,
      {required bool Function(String type, ISOBox? parent)?
          isContainerCallback}) async {
    final List<ISOBox> children = [];
    ISOBox? child;
    do {
      child = await nextChild(isContainerCallback: isContainerCallback);
      if (child?.type == type) {
        children.add(child!);
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
      box = await box.getChildByType(type,
          isContainerCallback: isContainerCallback);
    }
    return box == null ? null : box as ISOBox;
  }
}
