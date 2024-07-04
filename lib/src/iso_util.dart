import '../iso_base_media.dart';

extension ISOBoxExt on ISOBoxBase {
  /// Returns a child box by a given type.
  Future<ISOBox?> getChildByType(String type) async {
    ISOBox? child;
    do {
      child = await nextChild();
      if (child?.type == type) {
        return child;
      }
    } while (child != null);
    return null;
  }

  /// Returns a list of children by a given type.
  Future<List<ISOBox>> getChildrenByType(String type) async {
    final List<ISOBox> children = [];
    ISOBox? child;
    do {
      child = await nextChild();
      if (child?.type == type) {
        children.add(child!);
      }
    } while (child != null);
    return children;
  }

  /// Returns a child box by a given type path.
  Future<ISOBox?> getChildByTypePath(List<String> path) async {
    ISOBoxBase? box = this;
    for (final type in path) {
      if (box == null) {
        return null;
      }
      box = await box.getChildByType(type);
    }
    return box == null ? null : box as ISOBox;
  }
}
