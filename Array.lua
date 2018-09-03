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
	
	for Index = 1, #a1 do
		local Value = a1[Index]
		if type(Value) == "table" then
			MyFlatten(Value)
			for NewIndex = 1, #Value do
				table.insert(a1, Index + NewIndex, Value[NewIndex])
			end
			table.remove(a1, Index)
		end
	end
	return a1
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
