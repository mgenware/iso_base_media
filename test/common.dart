import 'dart:async';
import 'dart:io';

import 'package:iso_base_media/iso_base_media.dart';
import 'package:random_access_source/random_access_source.dart';

Future<ISOBox> openFileBox(String name) async {
  final file = File(name.startsWith('/') ? name : 'test/test_files/$name');
  final src = await FileRASource.load(file);
  return ISOBox.fileBox(src);
}

Future<Map<String, dynamic>?> _inspectISOBox(
  ISOBox box,
  int depth, {
  required bool Function(String type)? isContainerCallback,
  required bool Function(String type)? isFullBoxCallback,
  required FutureOr<bool> Function(ISOBox box, int depth)? callback,
}) async {
  Map<String, dynamic>? dict;
  if (callback == null) {
    dict = !box.isRootFileBox ? box.toDict() : <String, dynamic>{'root': true};
  }
  bool shouldContinue = true;
  if (!box.isRootFileBox) {
    if (callback != null) {
      shouldContinue = await callback(box, depth);
    }
    if (!box.isContainer) {
      return dict;
    }
  }
  if (!shouldContinue) {
    return null;
  }
  ISOBox? child;
  final childDicts = <Map<String, dynamic>>[];
  do {
    child = await box.nextChild(
        isContainerCallback: isContainerCallback,
        isFullBoxCallback: isFullBoxCallback);
    if (child != null) {
      final childInspection = await _inspectISOBox(child, depth + 1,
          callback: callback,
          isContainerCallback: isContainerCallback,
          isFullBoxCallback: isFullBoxCallback);
      if (callback == null && childInspection != null) {
        childDicts.add(childInspection);
      }
    }
  } while (child != null);
  if (childDicts.isNotEmpty && dict != null) {
    dict['children'] = childDicts;
  }
  return dict;
}

/// Inspects an ISO box.
/// Returns all child boxes in a tree structure. If [callback] is provided,
/// it returns null.
/// If [callback] returns false, the child boxes of the current box will not be
/// inspected.
Future<Map<String, dynamic>?> inspectISOBox(
  ISOBox box, {
  bool Function(String type)? isContainerCallback,
  bool Function(String type)? isFullBoxCallback,
  FutureOr<bool> Function(ISOBox box, int depth)? callback,
}) async {
  return _inspectISOBox(
    box,
    0,
    isContainerCallback: isContainerCallback,
    isFullBoxCallback: isFullBoxCallback,
    callback: callback,
  );
}
