--<< SERVICES >>
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")

--<< CONSTANTS >>
local VERSION_HISTORY_NAME = "VersionHistory"
local VERSION_HISTORY_LENGTH = 5
local MAIN_DATA_NAME = "MainData"
local CURRENT_TIME = os.time
local SCOPE_PREFIX = script.Name -- to avoid data overlaps
local GLOBAL_SCOPE = "global"	

--<< MODULE >>
local TrackedStore = {}
TrackedStore.__index = TrackedStore

--<< FUNCTIONS >>
function TrackedStore.new(name, scope)
	local self = setmetatable({}, TrackedStore)

	assert(name, "TrackedStore expected arg <name>")
	scope = scope or GLOBAL_SCOPE
	assert(typeof(name)=="string", string.format("TrackedStore received arg <name> of type %s. Expected string.", typeof(string)))
	assert(typeof(scope)=="string", string.format("TrackedStore received arg <scope> of type %s. Expected string.", typeof(string)))

	self.OrderedDataStore = DataStoreService:GetOrderedDataStore(VERSION_HISTORY_NAME, SCOPE_PREFIX..scope)
	self.MainDataStore = DataStoreService:GetDataStore(MAIN_DATA_NAME, SCOPE_PREFIX..scope)
	self.Name = name
	
	return self
end

function TrackedStore:GetSaveKeys(depth)
	local version_history = TrackedStore.Utility.Safe.GetOrderedAsync(self.OrderedDataStore, depth)
	if not version_history then
		warn("VersionHistory couldn't be loaded for TrackedStore:"..self.Name)
		return false
	end
	return version_history:GetCurrentPage()
end

function TrackedStore:GetSaveKey(depth)
	local page = self:GetSaveKeys(depth)
	return page and (page[depth] and page[depth].key)
end

function TrackedStore:PullData(depth)
	depth = depth or 1
	
	local save_key = self:GetSaveKey(depth)
	
	return TrackedStore.Utility.Safe.GetAsync(self.MainDataStore, save_key), save_key
end

function TrackedStore:PushData(data)
	local guid = HttpService:GenerateGUID()
	local time_stamp = CURRENT_TIME()
	
	local main_data_success = TrackedStore.Utility.Safe.SetAsync(self.MainDataStore, guid, data)
	if not main_data_success then
		warn("Couldn't update MainDataStore for TrackedStore:"..self.Name)
		return false
	end
	
	local version_history_success = TrackedStore.Utility.Safe.SetOrderedAsync(self.OrderedDataStore, guid, time_stamp)
	if not version_history_success then
		warn("Couldn't update VersionHistory for TrackedStore"..self.Name)
		return false
	end
	
	return true
end

--<< RETURNEE >>
return TrackedStore
