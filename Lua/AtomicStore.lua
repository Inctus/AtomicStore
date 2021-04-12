--<< DEPENDENCIES >>
local Dependencies = script.Parent:WaitForChild("Dependencies")
local Classes = Dependencies:WaitForChild("Classes")
local Modules = Dependencies:WaitForChild("Modules")

--<< MODULE >>
local AtomicStore = {}
AtomicStore._InstanciatedStores = {}

--<< FUNCTIONS >>
local function Initialise()
	local _classes = {}
	local _modules = {}
	
	for _, class in pairs(Classes:GetChildren()) do
		_classes[class.Name] = require(class)
	end
	
	for _, module in pairs(Modules:GetChildren()) do
		local _required = require(module)
		_modules[module.Name] = _required
		for _, class in pairs(_classes) do
			class[module.Name] = _required
		end
	end
	
	Classes = _classes
	Modules = _modules
end

local function InternalRetrieve(store_type, ...)
	local new_store = Classes[store_type].new(...)
	table.insert(AtomicStore._InstanciatedStores, new_store)
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
	for name, store in pairs(AtomicStore._InstanciatedStores) do
		table.insert(_list, store)
	end
	return _list
end

function AtomicStore:FindFirstStoreByName(name)
	return AtomicStore._InstanciatedStores[name]
end

--<< INITILISATION >>
Initialise()

--<< RETURNEE >>
return AtomicStore
