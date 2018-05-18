-- Class that memoizes sorting by inserting values in order
-- Elements must be able to evaluate comparisons to one another
-- @author Validark

local Resources = require(game:GetService("ReplicatedStorage"):WaitForChild("Resources"))
local Table = Resources:LoadLibrary("Table")

local SortedArray = {}

SortedArray.__index = setmetatable({
	Next = next;
	Unpack = unpack;
	Set = rawset;
	Get = rawget;
	ForEach = table.foreach;
	Concat = table.concat;
}, {__index = table})

function SortedArray.new(Array)
	if Array then
		table.sort(Array)
	end

	return setmetatable(Array or {}, SortedArray)
end

local remove = table.remove
local insert = table.insert

function SortedArray.__index:Insert(Value)
	-- Inserts a Value into the SortedArray while maintaining its sortedness

	local TableLength = #self

	for j = 1, TableLength do
		if Value < self[j] then -- Determine whether `Value` precedes `self[j]` alphabetically/numerically
			insert(self, j, Value)
			return
		end
	end

	self[TableLength + 1] = Value
end

function SortedArray.__index:Copy()
	local New = SortedArray.new()

	for i = 1, #self do
		New[i] = self[i]
	end

	return New
end

function SortedArray.__index:Remove(a2)
	-- Remove all elements within a2 from self if a2 is a table
	-- Falls back on table.remove otherwise

	if type(a2) == "table" then
		local j = #a2
		local n = a2[j]

		for i = #self, 1, -1 do
			local x = self[i]

			while j > 0 and x <= n do
				if x == n then
					remove(self, i)
				end
				j = j - 1
				n = a2[j]
			end
		end

		return self
	else
		return remove(self, a2)
	end
end

local function Empty() end

function SortedArray.__index:Transform(a2, f1, f2)
	-- Does the steps necessary to transform self into a2
	-- Calls f1 for each addition to self and f2 for each removal from self
	-- Functions are called with (index, value)
	-- @param table self The first sorted array
	-- @param table a2 The second sorted array
	-- @param function f1 the first function
	-- @param function f2 the second function
	-- @returns nil
	-- @example	self = {1, 2, 3, 4}
	--			a2 = {0, 2, 3, 5}
	--		calls f1(1, 0), f2(2, 1), f2(4, 4), f1(4, 5)
	-- note the index accounts for how the array shifts as the operations are applied

	f1 = f1 or Empty
	f2 = f2 or Empty

	local j, jceil = 1, #self + 1
	local v = self[j]
	local Count

	for i = 1, #a2 do
		local x = a2[i]

		while jceil > j and x > v do
			f2(j, v)
			remove(self, j)
			v = self[j]
			jceil = jceil - 1
		end

		if jceil > j then
			if x == v then
				j = j + 1
				v = self[j]
			elseif x < v then
				f1(i, x)
				insert(self, i, x)
				j = j + 1
				jceil = jceil + 1
			end
		else
			Count = Count and Count + 1 or jceil
			f1(Count, x)
			self[Count] = x
		end
	end

	for i = j, jceil - 1 do
		f2(i, self[i])
		self[i] = nil
	end
end

return Table.Lock(SortedArray)
