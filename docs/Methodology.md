# Methodology

## Universal Methods

### Safe Lookups

DataStore lookups are asynchronous calls, that can error for a variety of reasons. By using a lightweight `pcall` wrapper function **and** waiting for the DataStore budget for the request type in question to be available, I minimise the risk of a surplus amount of invocations happening, while keeping the method lightweight.

### Relational Database Emulation

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

---------

## Store Methods

### TrackedMultiStores

`TrackedMultiStore`s use multiple `DataStores` with a single `OrderedDataStore` for the version history. Each `DataStore` within the main `TrackedStore` acts independently so you should use `PullData` sparingly.

### Version Tracking

`TrackedStores`, be it of either the Multi or Single variety, rely on the same methodology, which I first encountered on the DevForum referenced as Berezza's Method. This involves using an `OrderedDataStore` to keep track of save keys, by ordering them according to their timestamps, which means a simple descending lookup can find the recentmost save keys. Then, a separate call has to be made to extract the data from that save key from a regular `DataStore`. By managing save keys, you can create a solid system using Session-Locking, and maintain atomicity of data in the database.

!!! warning "TrackedStores UpdateData method is in place"
	It doesn't create a new index in the VersionHistory since this would break mean that too many API calls would happen simultaneously, removing the advantages that UpdateAsync offers.