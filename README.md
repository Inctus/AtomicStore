# AtomicStore
Lightweight wrapper allowing easy creation of custom DataStores ready for a pseudo-atomic DataBase on ROBLOX.

## Use-Case
If you want to create a transaction-based pseudo-atomic database and have full control over features such as session-locking and transaction-handling, then this wrapper will give you access to do just that. By using the wrapped stores provided you can create your own algorithms to handle transactions and sessions without dealing with unnecessary overhead provided by other solutions. Also, the low level of abstraction means that you can interface with this module in much the same way as you would a normal DataStore directly!

## Warning
This wrapper is low-level. This means things such as caching are not implemented, leaving you to do that yourself. Instead, these classes and the module provide an easy way for you to interface with the DataStores directly, without removing any level of control you would usually have.

## Classes

- `TrackedStore` A DataStore that has a version history.

- `GeneralStore` A DataStore that has no version history, but has only one key.

- `MultiStore` A DataStore that has no version history and is accessed via multiple keys.
