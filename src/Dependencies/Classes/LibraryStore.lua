--<< SERVICES >>
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")

--<< CONSTANTS >>
local MAX_PER_KEY = 3999950 -- Up from 256kB, to 4MB! Leave suitable buffer.
local SCOPE_PREFIX = script.Name
local KEY_LIST_KEY = "DataIndex"
local COLLISION_RETRY_TIME = 1/60

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

function LibraryStore:PullDataFromKey(key)
	return LibraryStore.Utility.Safe.GetAsync(self.DataStore, key)
end

function LibraryStore:PullKeys()
	return self:PullDataFromKey(KEY_LIST_KEY) or {} -- Give empty key array
end

function LibraryStore:PullDataFromKeys(key_list)
	local extracted = {}

	for _, key in ipairs(key_list) do 
		table.insert(extracted,  self:PullDataFromKey(key))
	end

	return extracted, key_list
end

function LibraryStore:PullData()
	return self:PullDataFromKeys(self:PullKeys())
end

function LibraryStore:PushData(data, key_list)
	if key_list==nil then
		key_list = self:PullKeys()
	end

	local encoded = HttpService:JSONEncode(data)
	local heuristic_length = string.len(encoded)

	if heuristic_length < MAX_PER_KEY then
		warn("LibraryStore:"..self.Name.." detects inefficient usage; consider switching to a GeneralStore")
	end

	local heuristic_n_keys, progress = math.ceil(heuristic_length/MAX_PER_KEY)
	for i = 1, heuristic_n_keys do
		local slice = string.sub(encoded, (i-1)*MAX_PER_KEY, i*MAX_PER_KEY)
		if i <= #key_list then
			if not LibraryStore.Utility.Safe.SetAsync(self.DataStore, key_list[i], slice) then
				break
			end
		else
			local guid
			repeat
				guid = HttpService:GenerateGUID()
				if not table.find(key_list, guid) then
					break
				end
			until not LibraryStore.Utility.Wait(COLLISION_RETRY_TIME)
			table.insert(key_list, guid)
			if not LibraryStore.Utility.Safe.SetAsync(self.DataStore, guid, slice) then
				break
			end
		end
		progress = i
	end

	if progress ~= heuristic_n_keys then
		return false, progress
	else 
		return true, key_list
	end
end

--<< RETURNEE >>
return LibraryStore