# AtomicStore
Lightweight wrapper allowing easy creation of custom DataStores ready for a pseudo-atomic DataBase on ROBLOX.

## Use-Case
If you want to create a transaction-based database and have full control over features such as session-locking and transaction-handling, then this wrapper will give you access to do just that.

## Classes

- `TrackedStore` A DataStore that has a version history.

- `GeneralStore` A DataStore that has no version history, but has only one key.

- `MultiStore` A DataStore that has no version history and is accessed via multiple keys.
