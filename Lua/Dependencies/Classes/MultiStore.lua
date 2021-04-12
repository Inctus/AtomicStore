--<< SERVICES >>
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")

--<< MODULE >>
local MultiStore = {}
MultiStore.__index = MultiStore

--<< FUNCTIONS >>
function MultiStore.new(name, scope)
	local self = setmetatable({}, MultiStore)
	
	self.MainDataStore = DataStoreService:GetDataStore(name, scope)
	self.Name = ""
	
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
