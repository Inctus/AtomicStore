# GeneralStore - `Single Untracked`
-----------
## Constructors

### `.new()`

```lua
local GeneralStore = GeneralStore.new(
	<string name>, 
	<string scope>
) 
```
Returns `<instance GeneralStore>`

!!! Note "This is not accessed directly by the user"
	Instead, you access it via `AtomicStore:RetrieveGeneralStore(...)`

----------------

## Methods

### `:PullData()`

```lua
local data = GeneralStore:PullData()
```
Returns `<variant data>`

!!! Warning "Since `GeneralStore` is a single key store"
	This method accepts no `save_key` parameter

### `:PushData()`

```lua
local success = GeneralStore:PushData(
	<variant data>
)
```
Returns `<bool success>`

### `:UpdateData()`

```lua
local new_data = GeneralStore:UpdateData(
	<func update_function>
)
```
Returns `<variant new_data>`

------------