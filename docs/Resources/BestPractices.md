# Best Practices

------------

## Store Usage

### [GeneralStore](https://inctus.github.io/AtomicStore/API/GeneralStore/)

`GeneralStore`s provide an interface with a small amount of data, through a single key, with no history. This means that they are not ideal for saving whole sets of player data, but are instead suited more to saving single entities.

### [MultiStore](https://inctus.github.io/AtomicStore/API/MultiStore/)

`MultiStore`s provide an interface with a small amount of data, through many keys, with no history. This means that they are ideal for tracking multi-key entities such as Items, with each UID having their own keys. 

!!! Warning "If Atomicity is important, use `UpdateData` in preference to `PullData`/`PushData`"
	This is due to UpdateData exposing the inbuilt UpdateAsync method, which A) doesn't cache, B) doesn't have the same 6 second key limit, C) retries until it performs its intended purpose, D) is cancellable, by returning `nil`.

### [TrackedStore](https://inctus.github.io/AtomicStore/API/TrackedStore/)

`TrackedStore`s provide an interface with a large amount of data, through a single key, with a version history. This means it is suited to storing a regular amount of player data, in a regular game scenario, and since it has a 1:1 `PullData`-`GetAsync` call ratio, it will not consume your data budgets unnecessarily.

!!! Note "You're advised to use this as a main data store, and not an entity store"
	Access it using `PullData` and `PushData` and apply session locking with `UpdateData` since pulling and pushing isn't guaranteed to be atomic.

### [TrackedMultiStore](https://inctus.github.io/AtomicStore/API/TrackedMultiStore/)

`TrackedMultiStore`s provide an interface with an even larger amount of data, through multiple keys, with a shared version history. It is suited to a large amount of player data, such as storing house arrangements, since it has a 1:many `PullData`-`GetAsync` call ratio, it is advised to use TrackedStores wherever possible. 

!!! Note "You're advised to use this as a main data store, and not an entity store"
	Access it using `PullData` and `PushData` and apply session locking with `UpdateData` since pulling and pushing isn't guaranteed to be atomic.

### [LibraryStore](https://inctus.github.io/AtomicStore/API/LibraryStore.md)

`LibraryStore`s provide an interface with a huge amount of data, through a single "key", without a version history. It is suited to an extremely amount of data, for example a map layout, or contents of several player-maintained encyclopaedias. It uses multiple `GetAsync` calls per `PullData` call, and the same applies to the `SetAsync` calls with `PushData`. It has no exposed `UpdateData` method since it would defeat the benefits of using `UpdateAsync` since there is no way to implement an all or nothing atomic call to poll all keys used by the store.

------------


## Data Management

### Session Locking

Session locking avoids data loss or duplication by detecting when a server on ROBLOX either crashed or the save failed. It is a rather simple thing to implement. Firstly, you'd have a section of your data within a `TrackedStore`, multi or single, dedicated to session locking:

```
SessionData : {
	Session : JobId
	JoinKey : SaveKey
	SessionTransactions : <array TransactionId>
}
```

If a Session still exists in the data within the SessionData, then the data didn't save properly. In an atomic database, this is a big issue, as it could lead to item duplication or loss, or just unwanted data interactions in general. Therefore, by tracking `SessionTransactions`, you can find the transactions performed in this session, and roll them back. Then, you can roll back the rest of the player data, back to the JoinKey, using the `PullDataFromKey` and `PushData` functions of a `TrackedStore`. For even more control, you can use the function `GetSaveKeys` to extract keys from a specified depth in the `VersionHistory`. 

!!! important "If you need more information, this article sums up Session Locking pretty well:"
	[https://devforum.roblox.com/t/session-locking-explained-datastore/846799](https://devforum.roblox.com/t/session-locking-explained-datastore/846799)

### Data Rollbacks

If for whatever reason, a user needed to have their data rolled back to a previous state, you could use a `TrackedMultiStore` or a `TrackedStore` to do just this. By storing a list of transactions within the data system, you could then roll back these transactions by finding the relevant TransactionId in a transaction `MultiStore` and then essentially rewind time and pull back all of the items that the player had, into their inventory, without creating duplicate items ever. It would require you to have a `MultiStore` for both Items and Transactions, and to track SessionTransactions for a user.

-----------