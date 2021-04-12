--<< SERVICES >>
local DataStoreService = game:GetService("DataStoreService")

--<< CONSTANTS >>
local RETRY_TIME 				= 0.1
local MAX_RETRIES 				= 30

--<< UTILITY >>
local Utility = {}

--<< SAFE >>
Utility.Safe = {}

function Utility.Safe.GetAsync(datastore, save_key)
	local data, retries, success = nil, 0, false

	repeat 
		retries = retries + 1
		while not DataStoreService:GetRequestBudgetForRequestType(Enum.DataStoreRequestType.GetAsync) do
			wait(RETRY_TIME)
		end
		success = pcall(function()
			data = datastore:GetAsync(
				save_key
			)
		end)
	until success or (retries>MAX_RETRIES)

	return success and data or nil
end

function Utility.Safe.SetAsync(datastore, save_key, data)
	local retries, success = 0, false

	repeat
		retries = retries + 1
		while not DataStoreService:GetRequestBudgetForRequestType(Enum.DataStoreRequestType.SetIncrementAsync) do
			wait(RETRY_TIME)
		end
		success = pcall(function()
			datastore:SetAsync(
				save_key,
				data
			)
		end)
	until success or (retries>MAX_RETRIES)

	return success or nil
end

function Utility.Safe.UpdateAsync(datastore, save_key, update_function)
	local retries, success = 0, false

	repeat
		retries = retries + 1
		while not DataStoreService:GetRequestBudgetForRequestType(Enum.DataStoreRequestType.UpdateAsync) do
			wait(RETRY_TIME)
		end
		success = pcall(function()
			datastore:UpdateAsync(
				save_key,
				update_function
			)
		end)
	until success or (retries>MAX_RETRIES)

	return success or nil
end

function Utility.Safe.GetOrderedAsync(ordered_datastore, page_size)
	local book, retries, success = nil, 0, false

	repeat 
		retries = retries + 1
		while not DataStoreService:GetRequestBudgetForRequestType(Enum.DataStoreRequestType.GetSortedAsync) > 0 do
			wait(RETRY_TIME)
		end
		success = pcall(function()
			book = ordered_datastore:GetSortedAsync(
				false,
				page_size
			)
		end)
	until success or (retries>MAX_RETRIES) 

	return success and book or nil
end

function Utility.Safe.SetOrderedAsync(ordered_datastore, save_key, data)
	local retries, success = 0, false

	repeat 
		retries = retries + 1
		while not DataStoreService:GetRequestBudgetForRequestType(Enum.DataStoreRequestType.SetIncrementSortedAsync) > 0 do
			wait(RETRY_TIME)
		end
		success = pcall(function()
			ordered_datastore:SetAsync(
				save_key,
				data
			)
		end)
	until success or (retries > MAX_RETRIES)

	return success or nil
end

--<< RETURNEE >>
return Utility
