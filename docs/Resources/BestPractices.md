# Best Practices

## Store Usage


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