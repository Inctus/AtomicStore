--<< SERVICES >>
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")

--<< CONSTANTS >>
local VERSION_HISTORY_NAME 	= "VersionHistory"
local VERSION_HISTORY_LENGTH 	= 5
local MAIN_DATA_NAME			= "MainData"
local CURRENT_TIME 				= os.time

--<< MODULE >>
local MultiTrackedStore = {}
MultiTrackedStore.__index = MultiTrackedStore

--<< FUNCTIONS >>
function MultiTrackedStore.new(scope, data_store_names)
	local self = setmetatable({}, MultiTrackedStore)

	self.OrderedDataStore = DataStoreService:GetOrderedDataStore(VERSION_HISTORY_NAME, scope)
	self.DataStores = {}
	for _, data_name in pairs(data_store_names) do
		self.DataStores[data_name] = DataStoreService:GetDataStore(MAIN_DATA_NAME..data_name, scope)
	end
	
	self.Name = ""
	
	return self
end

function MultiTrackedStore:PullData(depth)
	if not depth then
		depth = 1
	end
	
	local version_history = MultiTrackedStore.Utility.Safe.GetOrderedAsync(self.OrderedDataStore, depth)
	if not version_history then
		warn("VersionHistory couldn't be loaded for MultiTrackedStore:"..self.Name)
		return nil
	end
	
	local page = version_history:GetCurrentPage()
	local version_history_data = page[depth]
	local save_key = version_history_data.key -- timestamp would be data.value
	
	local extracted = {}
	for name, data_store in  pairs(self.DataStores) do
		extracted[name] = MultiTrackedStore.Utility.Safe.GetAsync(data_store, save_key)
	end
	
	return extracted
end

function MultiTrackedStore:PushData(data)
	local guid = HttpService:GenerateGUID()
	local time_stamp = CURRENT_TIME()
	
	for name, data_store in pairs(self.DataStores) do
		local data_success = MultiTrackedStore.Utility.Safe.SetAsync(self.MainDataStore, guid, data)
		if not data_success then
			warn("Couldn't update DataStore:"..name.." for MultiTrackedStore:"..self.Name)
		end
	end
	
	local version_history_success = MultiTrackedStore.Utility.Safe.SetOrderedAsync(self.OrderedDataStore, guid, time_stamp)
	if not version_history_success then
		warn("Couldn't update VersionHistory for MultiTrackedStore"..self.Name)
		return nil
	end
	
	return true
end

--<< RETURNEE >>
return MultiTrackedStore
