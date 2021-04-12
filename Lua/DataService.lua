--<< DEPENDENCIES >>
local Dependencies = script.Parent:WaitForChild("Dependencies")
local Classes = Dependencies:WaitForChild("Classes")
local Modules = Dependencies:WaitForChild("Modules")

--<< MODULE >>
local DataService = {}

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
function DataService:RetrieveTrackedStore(...)
	return Classes.TrackedStore.new(...)
end

function DataService:RetrieveGeneralStore(...)
	return Classes.GeneralStore.new(...)
end

function DataService:RetrieveTrackedMultiStore(...)
	return Classes.TrackedMuiltiStore.new(...)
end

function DataService:RetrieveMultiStore(...)
	return Classes.MultiStore.new(...)
end

--<< INITILISATION >>
Initialise()

--<< RETURNEE >>
return DataService
