--<< SERVICES >>
local HttpService = game:GetService("HttpService")
local InsertService = game:GetService("InsertService")
local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local ServerStorage = game:GetService("ServerStorage")

--<< CONSTANTS >>
local ASSET_ID = 6697379606
local ACTION_NAME = "AtomicStore Installation"
local STRUCTURE = "https://raw.githubusercontent.com/Inctus/AtomicStore/main/default.project.json"
local HTTP_ENABLED = HttpService.HttpEnabled
local CHILD_IGNORE = {["$className"]=true, ["$path"]=true}

--<< FUNCTIONS >>
function FindPath(tree)
	for name, value in pairs(tree) do
		if not CHILD_IGNORE[name] then
			return value["$className"]
		end
	end
end

--<< INITIALISATION >>
ChangeHistoryService:SetWaypoint(ACTION_NAME)

if not HTTP_ENABLED then
	HttpService.HttpEnabled = true
end

local success, structure = pcall(function()
	return HttpService:JSONDecode(HttpService:GetAsync(
		STRUCTURE,
		true
	))
end)

local path;
if not success then
	path = ServerStorage
else 
	local tree = structure.tree
	local path_name = FindPath(tree)
	path = game:FindFirstChildOfClass(path_name)
end

local success, object = pcall(function()
	return InsertService:LoadAsset(ASSET_ID)
end)

if success then
	object.Parent = path
	Selection:Set({object})
	print("Successfully inserted AtomicStore into "..path.Name)
else 
	warn("Couldn't insert AtomicStore from AssetId:"..tostring(ASSET_ID).." due to Error:"..object)
end

if not HTTP_ENABLED then
	HttpService.HttpEnabled = false
end

--<< RETURNEE >>
return {}