--<< DEPENDENCIES >>
local Dependencies = script.Parent:WaitForChild("Dependencies")
local Classes = Dependencies:WaitForChild("Classes")
local Modules = Dependencies:WaitForChild("Modules")

--<< MODULE >>
local AtomicStore= {}

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

--<< CONSTRUCTORS >>
function AtomicStore:RetrieveTrackedStore(...)
	return Classes.TrackedStore.new(...)
end

function AtomicStore:RetrieveGeneralStore(...)
	return Classes.GeneralStore.new(...)
end

function AtomicStore:RetrieveTrackedMultiStore(...)
	return Classes.TrackedMuiltiStore.new(...)
end

function AtomicStore:RetrieveMultiStore(...)
	return Classes.MultiStore.new(...)
end

--<< INITILISATION >>
Initialise()

--<< RETURNEE >>
return AtomicStore
