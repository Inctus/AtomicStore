--<< SERVICES >>
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

--<< CONSTANTS >>
local RETRY_TIME = 0.1
local MAX_RETRIES = 30

--<< UTILITY >>
local Utility = {}

function Utility.Wait(t)
	local end_time = os.clock() + t 

	while os.clock() < t do
		RunService.Heartbeat:Wait()
	end

	return os.clock() - end_time + t
end

function Utility.Ternary(condition, a, b)
	if condition then 
		return a 
	else
		return b
	end
end

function Utility.RetryRequest(datastore_request_type, retry_function, returns)
	local data, retries, success = nil, 0, false

	repeat
		retries = retries + 1
		while not DataStoreService:GetRequestBudgetForRequestType(datastore_request_type) do
			Utility.Wait(RETRY_TIME)
		end
		success, data = pcall(retry_function)
	until success or (retries > MAX_RETRIES)

	return Utility.Ternary(returns, Utility.Ternary(success, data, success), success) 
end

--<< SAFE >>
Utility.Safe = {}

function Utility.Safe.GetAsync(datastore, save_key)
	return Utility.RetryRequest(
		Enum.DataStoreRequestType.GetAsync,
		function()
			return datastore:GetAsync(
				save_key
			)
		end,
		true
	)
end

function Utility.Safe.GetOrderedAsync(ordered_datastore, page_size)
	return Utility.RetryRequest(
		Enum.DataStoreRequestType.GetSortedAsync,
		function()
			return ordered_datastore:GetSortedAsync(
				false,
				page_size
			)
		end,
		true
	)
end

function Utility.Safe.UpdateAsync(datastore, save_key, update_function)
	return Utility.RetryRequest(
		Enum.DataStoreRequestType.UpdateAsync,
		function()
			return datastore:UpdateAsync(
				save_key,
				update_function
			)
		end,
		true
	)
end

function Utility.Safe.SetAsync(datastore, save_key, data)
	return Utility.RetryRequest(
		Enum.DataStoreRequestType.SetIncrementAsync,
		function()
			datastore:SetAsync(
				save_key,
				data
			)
		end,
		false
	)
end

function Utility.Safe.SetOrderedAsync(ordered_datastore, save_key, data)
	return Utility.RetryRequest(
		Enum.DataStoreRequestType.SetIncrementSortedAsync,
		function()
			ordered_datastore:SetAsync(
				save_key,
				data
			)
		end,
		false
	)
end

--<< RETURNEE >>
return Utility