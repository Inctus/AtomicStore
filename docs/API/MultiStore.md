# MultiStore - `Multi Untracked`
-----------
## Constructors

### `.new()`

```lua
local MultiStore = MultiStore.new(
	<string name>, 
	<string scope>
) 
```
Returns `<instance MultiStore>`

!!! Note "This is not accessed directly by the user"
	Instead, you access it via `AtomicStore:RetrieveMultiStore(...)`

----------------

## Methods

### `:PullData()`

```lua
local data = MultiStore:PullData(
	<string save_key>
)
```
Returns `<variant data>`

### `:PushData()`

```lua
local success = MultiStore:PushData(
	<string save_key>, 
	<variant data>
)
```
Returns `<bool success>`

### `:UpdateData()`

```lua
local new_data = GeneralStore:UpdateData(
	<string save_key>, 
	<func update_function>
)
```
Returns `<variant new_data>`

------------