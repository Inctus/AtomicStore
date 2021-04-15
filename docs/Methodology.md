# Methodology

## Safe Lookups

DataStore lookups are asynchronous calls, that can error easily. By using a lightweight `pcall` wrapper function **and** waiting for the DataStore budget for the request type in question to be available, I minimise the risk of a surplus amount of invocations happening, while keeping the method lightweight.

## Version Tracking & Retrieval

`TrackedStores`, be it of either the Multi or Single variety, rely on the same methodology, which I first encountered on the DevForum referenced as Berezza's Method. This involves using an `OrderedDataStore` to keep track of save keys, by ordering them according to their timestamps, which means a simple descending lookup can find the recentmost save keys. Then, a separate call has to be made to extract the data from that save key from a regular `DataStore`. By managing save keys, you can create a solid system using Session-Locking, and maintain atomicity of data in the database.

!!! warning "TrackedStores UpdateData method is in place"
	It doesn't create a new index in the VersionHistory since this would break mean that too many API calls would happen simultaneously, removing the advantages that UpdateAsync offers.

## Relational Database Emulation

Although full normalisation would be expensive to implement on ROBLOX, since each entity would require its own `DataStore`, or key, and therefore its own set of `GetAsync` and `SetAsync`/`UpdateAsync` calls, a semi-normalised database can be achieved if you give entities that need rapid, multi-server updates their own `MultiStore`. If the primary key for these entities, a unique ID, for example a GUID, were used as a save key within a `MultiStore`, you could then use `UpdateData` queries to safely handle updating these items. 

For example, an item would be stored in a store like the following:

```
MultiStore (Items; key=ItemId)
```

And an item could have a structure:

```
Item : {
	Owners = <array UserId>
	Trades = <array TradeId>
}
```

You could then implement another `MultiStore`, for trades, with the primary key being TradeId, and then by keeping track of both Items and Trades, be able to safely implement a transactional database on ROBLOX.

!!! caution "This is not a fully normalised relational database"
	As previously explained this would be impractical to implement on ROBLOX.

## Data Rollbacks

If for whatever reason, a user needed to have their data rolled back to a previous state, you could use a `TrackedMultiStore` or a `TrackedStore` to do just this. By storing a list of transactions within the data system, you could then roll back these transactions by finding the relevant TransactionId in a transaction `MultiStore` and then essentially rewind time and pull back all of the items that the player had, into their inventory, without creating duplicate items ever. It would require you to have a `MultiStore` for both Items and Transactions, and to track SessionTransactions for a user.

## Session Locking

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