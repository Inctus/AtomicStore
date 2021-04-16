--<< SERVICES >>
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")

--<< CONSTANTS >>
local MAX_PER_KEY = 3999950 -- Up from 256kB, to 4MB! Leave suitable buffer.
local SCOPE_PREFIX = script.Name
local SAVE_META_DATA_KEY = "SaveKey"
local START_INDEX = 1

--<< MODULE >>
local LibraryStore = {}
LibraryStore.__index = LibraryStore

--<< FUNCTIONS >>
function LibraryStore.new(name, scope)
	local self = setmetatable({}, LibraryStore)

	assert(name, "LibraryStore expected arg <name>")
	scope = scope or GLOBAL_SCOPE
	assert(typeof(name)=="string", string.format("LibraryStore received arg <name> of type %s. Expected string.", typeof(name)))
	assert(typeof(scope)=="string", string.format("LibraryStore received arg <scope> of type %s. Expected string.", typeof(scope)))

	self.DataStore = DataStoreService:GetDataStore(name, SCOPE_PREFIX..scope)
	self.Name = name

	return self
end

function LibraryStore:PullDataFromKey(save_key)
	return LibraryStore.Utility.Safe.GetAsync(self.DataStore, save_key)
end

function LibraryStore:PullSaveMetaData()
	return self:PullDataFromKey(SAVE_META_DATA_KEY)
end

function LibraryStore:PullData()
	local meta_data = self:PullSaveMetaData()
	if meta_data==false then
		return false, "Couldn't load MetaData"
	elseif meta_data==nil then
		meta_data = {start=START_INDEX, length=-1}
	end

	local extracted, progress = "", 0
	for i = meta_data.start, meta_data.start+save_meta_data.length-1 do 
		local data = self:PullDataFromKey(tostring(i))
		if data==false then
			break
		elseif data==nil then
			data=""
		end
		extracted = extracted .. data
		progress = progress + 1
	end

	if progress < save_meta_data.length then
		return false, "Couldn't load the "..tostring(progress).."th slice of data"
	end

	return HttpService:JSONDecode(extracted)
end

function LibraryStore:PushData(data)
	local meta_data = self:PullSaveMetaData()
	if meta_data==false then
		return false, "Couldn't load MetaData"
	elseif meta_data==nil then
		meta_data = {start=START_INDEX, length=-1}
	end
	local next_available = meta_data.start + meta_data.length

	local json_data = HttpService:JSONEncode(data)
	local length = string.len(json_data)
	local heuristic_slices = math.ceil(length / MAX_PER_KEY)

	if heuristic_slices == 1 then
		warn("Improper usage detected for LibraryStore:"..self.Name..". Consider switching to GeneralStore.")
	end

	local progress = 0
	for i = next_available, next_available+heuristic_slices-1 do
		local current_slice = string.sub(json_data, (i-1)*MAX_PER_KEY + 1, i*MAX_PER_KEY)
		if not LibraryStore.Utility.Safe.SetAsync(self.DataStore, tostring(i), current_slice) then
			break
		end
		progress = i
	end
	if progress < heuristic_slices then
		return false, "Couldn't save the "..tostring(#extracted+1).." slice of data for LibraryStore:"..self.Name
	end

	meta_data.start = next_available
	meta_data.length = heuristic_slices
	local meta_success = LibraryStore.Utility.Safe.SetAsync(self.DataStore, SAVE_META_DATA_KEY, meta_data)
	if meta_success then
		return true
	else 
		return false, "Couldn't save MetaData for LibraryStore:"..self.Name
	end
end

--<< RETURNEE >>
return LibraryStore