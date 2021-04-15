# TrackedStore - `Single Tracked`
-----------
## Constructors

### `.new()`

```lua
local TrackedStore = TrackedStore.new(
	<string name>, 
	<string scope>
) 
```
Returns `<instance TrackedStore>`

!!! Note "This is not accessed directly by the user"
	Instead, you access it via `AtomicStore:RetrieveTrackedStore(...)`

----------------

## Methods

### `:PullData()`

```lua
local data, save_key = TrackedStore:PullData(
	<integer depth>
)
```
Returns `<variant data>, <string save_key>`

!!! Note "Depth refers to depth in VersionHistory"
	If you wanted to pull the 3rd most recent save, then you'd use `depth 3`

### `:PullDataFromKey()`

```lua
local data, save_key = TrackedStore:PullDataFromKey(
	<string save_key>
)
```
Returns `<variant data>, <string save_key>`

!!! Caution "The save_key here must be obtained from one of the GetKey methods"
	These are `:GetSaveKeys()` and `:GetSaveKey()` and expose the internal OrderedDatastore allowing for more complex VersionHistory manipulation.

### `:GetSaveKey()`

```lua
local save_key = TrackedStore:GetSaveKey(
	<integer depth>
)
```
Returns `<string save_key>`

### `:GetSaveKeys()`
```lua
local save_keys = TrackedStore:GetSaveKeys(
	<integer depth>
) 
```
Returns `<array <string save_key> save_keys>`

!!! Info "This returns the recentmost save keys up to depth"
	It uses one poll of the OrderedDataStore so is useful if you want to access multiple saves simultaneously.

### `:PushData()`

```lua
local success, save_key = TrackedStore:PushData(
	<variant data>
)
```
Returns `<bool success>, <string save_key>`

!!! Info "This function creates a new key"
	This is not an in-place update, but instead creates a new save key and updates the version history. You can "rewind" this action.

### `:UpdateData()`

```lua
local new_data, save_key = TrackedStore:UpdateData(
	<integer depth>, 
	<func update_function>
)
```
Returns `<variant new_data>, <string save_key>`

!!! Warning "This function is in-place"
	It operates on the save provided at the specified depth. This is useful if you want to create session locking since it exposes the UpdateAsync method. It shouldn't be used for saving if you want to retain a VersionHistory. It can be used to retrieve data from the store.

### `:UpdateDataFromKey()`
```lua
local new_data, save_key = TrackedStore:UpdateDataFromKey(
	<string save_key>, 
	<func update_function>
)
```
Returns `<variant new_data>, <string save_key>`


------------