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
local TrackedMultiStore = {}
TrackedMultiStore.__index = TrackedMultiStore

--<< FUNCTIONS >>
function TrackedMultiStore.new(name, scope, data_store_names)
	local self = setmetatable({}, TrackedMultiStore)

	assert(name, "MultiTrackedStore expected arg <name>")
	scope = scope or GLOBAL_SCOPE
	assert(data_store_names, "MultiTrackedStore expected arg <data_store_names>")
	assert(typeof(name)=="string", string.format("MultiTrackedStore received arg <name> of type %s. Expected string.", typeof(string)))
	assert(typeof(scope)=="string", string.format("MultiTrackedStore received arg <scope> of type %s. Expected string.", typeof(string)))
	assert(typeof(data_store_names)=="table", string.format("MultiTrackedStore received arg <data_store_names> of type %s. Expected table.", typeof(data_store_names)))

	self.OrderedDataStore = DataStoreService:GetOrderedDataStore(VERSION_HISTORY_NAME, SCOPE_PREFIX..scope)
	self.DataStores = {}
	for _, data_name in pairs(data_store_names) do
		self.DataStores[data_name] = DataStoreService:GetDataStore(MAIN_DATA_NAME..data_name, SCOPE_PREFIX..scope)
	end
	
	self.Name = name
	
	return self
end

function TrackedMultiStore:GetSaveKeys(depth)
	local version_history = TrackedMultiStore.Utility.Safe.GetOrderedAsync(self.OrderedDataStore, depth)
	if not version_history then
		warn("VersionHistory couldn't be loaded for TrackedMultiStore:"..self.Name)
		return false
	end
	return version_history:GetCurrentPage()
end

function TrackedMultiStore:GetSaveKey(depth)
	local page = self:GetSaveKeys(depth)
	return page and (page[depth] and page[depth].key)
end

function TrackedMultiStore:PullData(depth)
	depth = depth or 1
	
	local save_key = self:GetSaveKey(depth)
	
	local extracted = {}
	for name, data_store in  pairs(self.DataStores) do
		extracted[name] = TrackedMultiStore.Utility.Safe.GetAsync(data_store, save_key)
	end
	
	return extracted, save_key
end

function TrackedMultiStore:PushData(data)
	local guid = HttpService:GenerateGUID()
	local time_stamp = CURRENT_TIME()
	
	for name, data_store in pairs(self.DataStores) do
		local data_success = TrackedMultiStore.Utility.Safe.SetAsync(data_store, guid, data)
		if not data_success then
			warn("Couldn't update DataStore:"..name.." for MultiTrackedStore:"..self.Name)
		end
	end
	
	local version_history_success = TrackedMultiStore.Utility.Safe.SetOrderedAsync(self.OrderedDataStore, guid, time_stamp)
	if not version_history_success then
		warn("Couldn't update VersionHistory for MultiTrackedStore"..self.Name)
		return false
	end
	
	return true
end

--<< RETURNEE >>
return TrackedMultiStore
