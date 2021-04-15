# AtomicStore `Top-Level Singleton`

--------

## Initialisation

### `require()`

```lua
local AtomicStore = require(Path/To/AtomicStore)
```

--------------

## Retrieval Functions

!!! Info "Retrieval functions expose the constructors"
	Each class can be accessed via a retrieval function with its name.

### `:RetrieveGeneralStore()`

```lua
local GeneralStore = AtomicStore:RetrieveGeneralStore(
	<string name>, 
	<string scope>
)
```

Returns `GeneralStore` instance. See [GeneralStore](https://inctus.github.io/AtomicStore/API/GeneralStore/).

### `:RetrieveMultiStore()`

```lua
local MultiStore = AtomicStore:RetrieveMultiStore(
	<string name>, 
	<string scope>
)
```

Returns `MultiStore` instance. See [MultiStore](https://inctus.github.io/AtomicStore/API/MultiStore/).

### `:RetrieveTrackedStore()`

```lua
local TrackedStore = AtomicStore:RetrieveTrackedStore(
	<string name>, 
	<string scope>
)
```

Returns `TrackedStore` instance. See [TrackedStore](https://inctus.github.io/AtomicStore/API/TrackedStore/).

### `:RetrieveTrackedMultiStore()`

```lua
local TrackedMultiStore = AtomicStore:RetrieveTrackedMultiStore(
	<string name>, 
	<string scope> ,
	<array <string data_name> data_store_names>
)
```

Returns `TrackedMultiStore` instance. See [TrackedMultiStore](https://inctus.github.io/AtomicStore/API/TrackedMultiStore/).

---------------------

## Store Management

### `:GetStores()`

```lua
local DataStores = AtomicStore:GetStores()
```

Returns `<array <variant datastore> datastores>`

### `:FindFirstStoreByName()`

```lua
local DataStore = AtomicStore:FindFirstStoreByName(
	<string name>
)
```

Returns `<variant datastore>`

!!! Info "Names are declared via initialisation of the DataStore"
	They are obtained throught the name parameter of the constructor.