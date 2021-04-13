--<< SERVICES >>
local DataStoreService = game:GetService("DataStoreService")

--<< CONSTANTS >>
local GENERAL_DATA_KEY	= "DataKey"
local SCOPE_PREFIX = script.Name -- to avoid data overlaps

--<< MODULE >>
local GeneralStore = {}
GeneralStore.__index = GeneralStore

--<< FUNCTIONS >>
function GeneralStore.new(name, scope)
	local self = setmetatable({}, GeneralStore)

	assert(name, "GeneralStore expected arg <name>")
	if scope == nil then scope = GLOBAL_SCOPE end

	assert(typeof(name)=="string", string.format("GeneralStore received arg <name> of type %s. Expected string.", typeof(string)))
	assert(typeof(scope)=="string", string.format("GeneralStore received arg <scope> of type %s. Expected string.", typeof(string)))
	
	
	self.MainDataStore = DataStoreService:GetDataStore(name, SCOPE_PREFIX..scope)
	self.Name = name
	
	return self
end

function GeneralStore:PullData()
	return GeneralStore.Utility.Safe.GetAsync(self.MainDataStore, GENERAL_DATA_KEY)
end

function GeneralStore:PushData(data)
	return GeneralStore.Utility.Safe.SetAsync(self.MainDataStore, GENERAL_DATA_KEY, data)
end

function GeneralStore:UpdateData(update_function)
	return GeneralStore.Utility.Safe.UpdateAsync(self.MainDataStore, GENERAL_DATA_KEY, update_function)
end

--<< RETURNEE >>
return GeneralStore
