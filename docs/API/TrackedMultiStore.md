# TrackedMultiStore - `Multi Tracked`
-----------
## Constructors

### `.new()`

```lua
local TrackedMultiStore = TrackedMultiStore.new(
	<string name>, 
	<string scope>,
	<array <string data_store_name> data_store_names>
) 
```
Returns `<instance TrackedMultiStore>`

!!! Note "This is not accessed directly by the user"
	Instead, you access it via `AtomicStore:RetrieveTrackedMultiStore(...)`

!!! Info "DataStoreNames act as actual sub-datastores"
	Instead of using one DataStore like a TrackedStore does, TrackedMultiStores use multiple DataStores.

----------------

## Methods

### `:PullData()`

```lua
local data, save_key = TrackedMultiStore:PullData(
	<integer depth>
)
```
Returns `<dict <variant data> extracted_data>, <string save_key>`

!!! Note "Depth refers to depth in VersionHistory"
	If you wanted to pull the 3rd most recent save, then you'd use `depth 3`

!!! Info "The indices of the dict `extracted_data`"
	Come from the names you provided in the constructor.

### `:PullDataFromKey()`

```lua
local data, save_key = TrackedMultiStore:PullDataFromKey(
	<string save_key>
)
```
Returns `<dict <variant data> extracted_data>, <string save_key>`

!!! Caution "The save_key here must be obtained from one of the GetKey methods"
	These are `:GetSaveKeys()` and `:GetSaveKey()` and expose the internal OrderedDatastore allowing for more complex VersionHistory manipulation.

!!! Info "The indices of the dict `extracted_data`"
	Come from the names you provided in the constructor.

### `:GetSaveKey()`

```lua
local save_key = TrackedMultiStore:GetSaveKey(
	<integer depth>
)
```
Returns `<string save_key>`

### `:GetSaveKeys()`
```lua
local save_keys = TrackedMultiStore:GetSaveKeys(
	<integer depth>
) 
```
Returns `<array <string save_key> save_keys>`

!!! Info "This returns the recentmost save keys up to depth"
	It uses one poll of the OrderedDataStore so is useful if you want to access multiple saves simultaneously.

### `:PushData()`

```lua
local success, save_key = TrackedMultiStore:PushData(
	<dict <variant data> data_dict>
)
```
Returns `<bool success>, <string save_key>`

!!! Info "This function creates a new key"
	This is not an in-place update, but instead creates a new save key and updates the version history. You can "rewind" this action.

!!! Warning "The dict `data_dict` indices must match the constructor"
	As a good practice, operate on the extracted info without mutating the keys and you will be fine to then send it back here.

### `:UpdateData()`

```lua
local new_data, save_key = TrackedMultiStore:UpdateData(
	<integer depth>, 
	<func update_function>
)
```
Returns `<dict <variant new_data> extracted_data>, <string save_key>`

!!! Warning "This function is in-place"
	It operates on the save provided at the specified depth. This is useful if you want to create session locking since it exposes the UpdateAsync method. It shouldn't be used for saving if you want to retain a VersionHistory. It can be used to retrieve data from the store.

!!! Info "This function is applied to all sub-stores individually"
	It should take parameters data_store_name and old_data:

	```lua
	function update_function(data_name, old_data)
		-- do magic
		return magic
	end
	```
!!! Info "The extracted_data dictionary's keys match the DataStore names provided"

### `:UpdateDataFromKey()`

```lua
local new_data, save_key = TrackedMultiStore:UpdateData(
	<string save_key>,
	<func update_function>
)
```
Returns `<dict <variant new_data> extracted_data>, <string save_key>`

------------