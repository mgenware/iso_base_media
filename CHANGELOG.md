## 6.1.0

- Support special box sizes.

## 6.0.0

- Move `RandomAccessSource` out of `ISOBox`.
- `ISOBox` now can be sent to Dart isolates.
- All `ISOBox` methods (including extension methods) have a explicit `RandomAccessSource` parameter.

## 5.2.0

- Add support for Web platforms.

## 5.1.1

- Update to `random_access_source` 3.1.0.

## 5.0.0

- Add `resetPosition` to `ISOBox`.
- **Breaking**: Rename `seek` to `seekInData`.

## 4.6.0

- Remove `RandomAccessBinaryReader` layer.

## 4.4.0

- Prefer `RandomAccessBinaryReader`.

## 4.3.1

- Fix wrong box size when box size is 0.

## 4.3.0

- Add `ispe` and `ipma` to full boxes.

## 4.2.0

- Update `random_access_source`.

## 4.1.0

- Add an optional index param to `nextChild`.

## 4.0.2

- Fix issues with uint8list sublist views.

## 4.0.1

- Add `close` to `ISOBox`.

## 4.0.0

- Remove `ISOSourceBox` in favor of `ISOBox` static methods.
- Remove inspector methods, use `ISOBox` extension methods instead.

## 3.2.1

- Add `getDirectChildrenByAsyncFilter` util.
- Add `boxesToBytes` util.

## 3.1.0

- Add `getDirectChildren` util.
- Add `toBytes` method to `ISOBox`.

## 3.0.0

- [Breaking] Remove `ISORootBox` in favor of `ISOSourceBox`.
- Add `isFullBoxCallback`.

## 2.2.0

- Add `seek` method to all box types.

## 2.1.1

- Update extension methods.

## 2.0.0

- Allow customizing container boxes via ``isContainerCallback`.
- Allow early exit in `inspectISOBox.callback`.
- Return a map in `inspectISOBox` instead of a list.
- Add `grpl` to container boxes.

## 1.5.0

- Add some helper functions to work with boxes.

## 1.4.0

- Expose data offset and header offset in `ISOBox`.

## 1.3.0

- Ability to start parsing from a random access file.

## 1.2.0

- Add `ISOFullBoxInfo`
- Rename `fullBoxData` to `fullBoxInt32`

## 1.1.0

- Allow extracting data from a box.

## 1.0.0

- Initial version.
