--<< DEPENDENCIES >>
local Dependencies = script:WaitForChild("Dependencies")
local Classes = Dependencies:WaitForChild("Classes")
local Shared = Dependencies:WaitForChild("Shared")

--<< MODULE >>
local AtomicStore = {}
AtomicStore._InstantiatedStores = {}

--<< FUNCTIONS >>
local function Initialise()
	local _classes = {}
	local _shared = {}
	
	for _, class in pairs(Classes:GetChildren()) do
		_classes[class.Name] = require(class)
	end
	
	for _, shared_module in pairs(Shared:GetChildren()) do
		local _required = require(shared_module)
		_shared[shared_module.Name] = _required
		for _, class in pairs(_classes) do
			class[shared_module.Name] = _required
		end
	end
	
	Classes = _classes
	Shared = _shared
end

local function InternalRetrieve(store_type, ...)
	local new_store = Classes[store_type].new(...)
	AtomicStore._InstantiatedStores[new_store.Name] = new_store
	return new_store
end

--<< RETRIEVAL FUNCTIONS >>
function AtomicStore:RetrieveTrackedStore(...)
	return InternalRetrieve("TrackedStore", ...)
end

function AtomicStore:RetrieveGeneralStore(...)
	return InternalRetrieve("GeneralStore", ...)
end

function AtomicStore:RetrieveTrackedMultiStore(...)
	return InternalRetrieve("TrackedMultiStore", ...)
end

function AtomicStore:RetrieveMultiStore(...)
	return InternalRetrieve("MultiStore", ...)
end

--<< STORE MANAGEMENT >>
function AtomicStore:GetStores()
	local _list = {}
	for name, store in pairs(AtomicStore._InstantiatedStores) do
		table.insert(_list, store)
	end
	return _list
end

function AtomicStore:FindFirstStoreByName(name)
	return AtomicStore._InstantiatedStores[name]
end

--<< INITILISATION >>
Initialise()

--<< RETURNEE >>
return AtomicStore
