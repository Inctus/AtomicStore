--<< SERVICES >>
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")

--<< CONSTANTS >>
local SCOPE_PREFIX = script.Name
local GLOBAL_SCOPE = "global"	

--<< MODULE >>
local MultiStore = {}
MultiStore.__index = MultiStore

--<< FUNCTIONS >>
function MultiStore.new(name, scope)
	local self = setmetatable({}, MultiStore)

	assert(name, "MultiStore expected arg <name>")
	scope = scope or GLOBAL_SCOPE
	assert(typeof(name)=="string", string.format("MultiStore received arg <name> of type %s. Expected string.", typeof(name)))
	assert(typeof(scope)=="string", string.format("MultiStore received arg <scope> of type %s. Expected string.", typeof(scope)))
	
	self.MainDataStore = DataStoreService:GetDataStore(name, SCOPE_PREFIX..scope)
	self.Name = name
	
	return self
end

function MultiStore:PullData(save_key)
	return MultiStore.Utility.Safe.GetAsync(self.MainDataStore, save_key)
end

function MultiStore:PushData(save_key, data)
	return MultiStore.Utility.Safe.SetAsync(self.MainDataStore, save_key, data)
end

function MultiStore:UpdateData(save_key, update_function)
	return MultiStore.Utility.Safe.UpdateAsync(self.MainDataStore, save_key, update_function)
end

--<< RETURNEE >>
return MultiStore