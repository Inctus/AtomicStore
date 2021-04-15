# Methodology

------------

## Universal Methods

### Safe Lookups

DataStore lookups are asynchronous calls, that can error for a variety of reasons. By using a lightweight `pcall` wrapper function **and** waiting for the DataStore budget for the request type in question to be available, I minimise the risk of a surplus amount of invocations happening, while keeping the method lightweight.

---------

## Tracking Methods

### Mutliple Stores

`TrackedMultiStore`s use multiple `DataStores` with a single `OrderedDataStore` for the version history. Each `DataStore` within the main `TrackedStore` acts independently so you should use `PullData` sparingly.

### Version History

`TrackedStores`, be it of either the Multi or Single variety, rely on the same methodology, which I first encountered on the DevForum referenced as Berezza's Method. This involves using an `OrderedDataStore` to keep track of save keys, by ordering them according to their timestamps, which means a simple descending lookup can find the recentmost save keys. Then, a separate call has to be made to extract the data from that save key from a regular `DataStore`. By managing save keys, you can create a solid system using Session-Locking, and maintain atomicity of data in the database.

!!! warning "TrackedStores UpdateData method is in place"
	It doesn't create a new index in the VersionHistory since this would mean that too many API calls would happen simultaneously, removing the advantages that UpdateAsync offers.