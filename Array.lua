-- Utility Array functions
-- This Library is not for a bunch of for-loop wrapper functions.
-- Either write your own for-loops or learn python instead
-- @author Validark

local Resources = require(game:GetService("ReplicatedStorage"):WaitForChild("Resources"))
local Table = Resources:LoadLibrary("Table")

local Array = {}

function Array.Flatten(a1)
	-- Takes in an array, which may have arrays inside of it
	-- Unpacks all arrays in their proper place into a1
	-- e.g. a1 = {{1, 2}, 3, 4, {5, {6, {{7, 8}, 9}, 10}, 11}, 12}
	-- becomes: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}

	local i = 1
	local tlen = #a1
	
	while i <= tlen do
		if type(a1[i]) == "table" then
			local a2 = a1[i]
			local origin = #a2
			for x = tlen, i + 1, -1 do
				a1[x + origin] = a1[x]
			end
			for x = 0, origin - 1 do
				a1[i + x] = a2[x + 1]
			end
			tlen = tlen + origin
		else
			i = i + 1
		end
	end
	
	return a1
	-- Rewritten by movsb.
end

function Array.Contains(a1, v)
	-- Returns the index at which v exists within array a1 if applicable

	for i = 1, #a1 do
		if a1[i] == v then
			return i
		end
	end
end

return Table.Lock(Array)
