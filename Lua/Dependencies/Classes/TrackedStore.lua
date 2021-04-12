--<< SERVICES >>
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")

--<< CONSTANTS >>
local VERSION_HISTORY_NAME 	= "VersionHistory"
local VERSION_HISTORY_LENGTH 	= 5
local MAIN_DATA_NAME			= "MainData"
local CURRENT_TIME 				= os.time

--<< MODULE >>
local TrackedStore = {}
TrackedStore.__index = TrackedStore

--<< FUNCTIONS >>
function TrackedStore.new(scope)
	local self = setmetatable({}, TrackedStore)

	self.OrderedDataStore = DataStoreService:GetOrderedDataStore(VERSION_HISTORY_NAME, scope)
	self.MainDataStore = DataStoreService:GetDataStore(MAIN_DATA_NAME, scope)
	self.Name = ""
	
	return self
end

function TrackedStore:PullData(depth)
	if not depth then
		depth = 1
	end
	
	local version_history = TrackedStore.Utility.Safe.GetOrderedAsync(self.OrderedDataStore, depth)
	if not version_history then
		warn("VersionHistory couldn't be loaded for TrackedStore:"..self.Name)
		return nil
	end
	
	local page = version_history:GetCurrentPage()
	local version_history_data = page[depth]
	local save_key = version_history_data.key -- timestamp would be data.value
	
	return TrackedStore.Utility.Safe.GetAsync(self.MainDataStore, save_key)
end

function TrackedStore:PushData(data)
	local guid = HttpService:GenerateGUID()
	local time_stamp = CURRENT_TIME()
	
	local main_data_success = TrackedStore.Utility.Safe.SetAsync(self.MainDataStore, guid, data)
	if not main_data_success then
		warn("Couldn't update MainDataStore for TrackedStore:"..self.Name)
		return nil
	end
	
	local version_history_success = TrackedStore.Utility.Safe.SetOrderedAsync(self.OrderedDataStore, guid, time_stamp)
	if not version_history_success then
		warn("Couldn't update VersionHistory for TrackedStore"..self.Name)
		return nil
	end
	
	return true
end

--<< RETURNEE >>
return TrackedStore
