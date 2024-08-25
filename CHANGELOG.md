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
