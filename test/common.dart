import 'dart:async';

import 'package:iso_base_media/iso_base_media.dart';
import 'package:random_access_source/random_access_source.dart';

import '_common_io.dart' if (dart.library.js_interop) '_common_web.dart'
    as impl;

Future<RandomAccessSource> loadFileSrc(String name) => impl.loadFileSrc(name);

Future<RandomAccessSource> loadBytesSrc(String name) => impl.loadBytesSrc(name);

bool canSend(Object? o) => impl.canSend(o);

Future<Map<String, dynamic>?> _inspectISOBox(
  RandomAccessSource src,
  ISOBox box,
  int depth, {
  required bool Function(String type)? isContainerCallback,
  required bool Function(String type)? isFullBoxCallback,
  required FutureOr<bool> Function(ISOBox box, int depth)? callback,
}) async {
  bool checkIsContainer(ISOBox box) {
    return isContainerCallback != null
        ? isContainerCallback(box.type)
        : _containerBoxes.contains(box.type);
  }

  Map<String, dynamic>? dict;
  if (callback == null) {
    dict = !box.isRootFileBox ? box.toDict() : <String, dynamic>{'root': true};
  }
  bool shouldContinue = true;
  if (!box.isRootFileBox) {
    if (callback != null) {
      shouldContinue = await callback(box, depth);
    }
    if (!checkIsContainer(box)) {
      return dict;
    }
  }
  if (!shouldContinue) {
    return null;
  }
  ISOBox? child;
  final childDicts = <Map<String, dynamic>>[];
  do {
    child = await box.nextChild(src, isFullBoxCallback: isFullBoxCallback);
    if (child != null) {
      final childInspection = await _inspectISOBox(src, child, depth + 1,
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
  RandomAccessSource src,
  ISOBox box, {
  bool Function(String type)? isContainerCallback,
  bool Function(String type)? isFullBoxCallback,
  FutureOr<bool> Function(ISOBox box, int depth)? callback,
}) async {
  return _inspectISOBox(
    src,
    box,
    0,
    isContainerCallback: isContainerCallback,
    isFullBoxCallback: isFullBoxCallback,
    callback: callback,
  );
}

const _containerBoxes = {
  'moov',
  'trak',
  'mdia',
  'minf',
  'stbl',
  'dinf',
  'edts',
  'udta',
  'mvex',
  'meta',
  'iref',
  'iprp',
  'ipco',
  'grpl',
};
