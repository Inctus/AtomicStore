# LibraryStore - `Library Untracked`
-----------
## Constructors

### `.new()`

```lua
local LibraryStore = LibraryStore.new(
	<string name>, 
	<string scope>
) 
```
Returns `<instance LibraryStore>`

!!! Note "This is not accessed directly by the user"
	Instead, you access it via `AtomicStore:RetrieveLibraryStore(...)`

----------------

## Methods 

### `:PullData()`

```lua
local data = LibraryStore:PullData()
```
Returns `<variant data>`

!!! Info "This function returns a set of aggregated decoded data"
	It uses multiple `GetAsync()` calls and will consume your budget if the data requested is extremely large.

### `:PullSaveMetaData()`

```lua
local metadata = LibraryStore:PullSaveMetaData()
```
Returns `<dictionary metadata>`

!!! Warning "This is an internal function"
	It returns metadata in the format:
	```lua
	{
		start= <integer start_index>,
		length= <integer length>
	}
	```

### `:PullDataFromKey()`

```lua
local slice = LibraryStore:PullDataFromKey(
	<string save_key>
)
```
Returns `<string slice>`

!!! Info "This returns a JSON slice of the saved data"
	It will need to be aggregated to be decoded, or you can parse it as you want to create a random lookup.

### `:PushData()`


```lua
local success = LibraryStore:PushData(
	<variant data>
end)
```
Returns `<bool success>`

!!! Warning "This polls for recentmost metadata"
	It uses no caching. If it fails, it will not break or overwrite data. It will eat `SetAsync` requests.