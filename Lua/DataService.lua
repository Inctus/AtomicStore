--<< DEPENDENCIES >>
local Dependencies = script.Parent:WaitForChild("Dependencies")

local TrackedStore = require(Dependencies.Classes.TrackedStore)
local GeneralStore = require(Dependencies.Classes.GeneralStore)
local Utility = require(Dependencies.Modules.Utility)

--<< MODULE >>
local DataService = {}

--<< CONSTRUCTORS >>
function DataService:RetrieveTrackedStore(...)
	return TrackedStore.new(...)
end

function DataService:RetrieveGeneralStore(...)
	return GeneralStore.new(...)
end

--<< INITILISATION >>
TrackedStore.Utility = Utility
GeneralStore.Utility = Utility

--<< RETURNEE >>
return DataService
