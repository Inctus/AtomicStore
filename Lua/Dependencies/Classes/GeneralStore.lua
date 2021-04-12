--<< SERVICES >>
local DataStoreService = game:GetService("DataStoreService")

--<< CONSTANTS >>
local GENERAL_DATA_KEY	= "DataKey"

--<< MODULE >>
local GeneralStore = {}
GeneralStore.__index = GeneralStore

--<< FUNCTIONS >>
function GeneralStore.new(name, scope)
	local self = setmetatable({}, GeneralStore)
	
	self.MainDataStore = DataStoreService:GetDataStore(name, scope)
	
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
