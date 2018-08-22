-- Class that memoizes sorting by inserting values in order. Optimized for very large arrays.
-- @author Validark

local Resources = require(game:GetService("ReplicatedStorage"):WaitForChild("Resources"))
local Table = Resources:LoadLibrary("Table")

local sort = table.sort
local insert = table.insert

local SortedArray = {}
local Comparisons = setmetatable({}, {__mode = "k"})

SortedArray.__index = {
	Unpack = unpack;
	Concat = table.concat;
	RemoveIndex = table.remove;
}

function SortedArray.new(self, Comparison)
	if self then
		sort(self, Comparison)
	else
		self = {}
	end

	Comparisons[self] = Comparison
	return setmetatable(self, SortedArray)
end

local function FindClosest(self, Value, Low, High, Eq, Lt)
	local Middle do
		local Sum = Low + High
		Middle = (Sum - Sum % 2) / 2
	end

	if Middle == 0 then
		return nil
	end

	local Compare = Lt or Comparisons[self]
	local Value2 = self[Middle]

	while Middle ~= High do
		if Eq then
			if Eq(Value, Value2) then
				return Middle
			end
		elseif Value == Value2 then
			return Middle
		end

		local Bool

		if Compare then
			Bool = Compare(Value, Value2)
		else
			Bool = Value < Value2
		end

		if Bool then
			High = Middle - 1
		else
			Low = Middle + 1
		end

		local Sum = Low + High
		Middle = (Sum - Sum % 2) / 2
		Value2 = self[Middle]
	end

	return Middle
end

function SortedArray.__index:Insert(Value)
	-- Inserts a Value into the SortedArray while maintaining its sortedness

	local Position = FindClosest(self, Value, 1, #self)
	local Value2 = self[Position]

	if Value2 then
		local Compare = Comparisons[self]
		local Bool

		if Compare then
			Bool = Compare(Value, Value2)
		else
			Bool = Value < Value2
		end

		Position = Bool and Position or Position + 1
	else
		Position = 1
	end

	insert(self, Position, Value)

	return Position
end

function SortedArray.__index:Find(Value, Eq, Lt)
	-- Finds a Value in a SortedArray and returns its position (or nil if non-existant)

	local Position = FindClosest(self, Value, 1, #self, Eq, Lt)

	local Bool

	if Position then
		if Eq then
			Bool = Eq(Value, self[Position])
		else
			Bool = Value == self[Position]
		end
	end

	return Bool and Position or nil
end

function SortedArray.__index:Copy()
	local New = {}

	for i = 1, #self do
		New[i] = self[i]
	end

	return New
end

function SortedArray.__index:Clone()
	local New = {}

	for i = 1, #self do
		New[i] = self[i]
	end

	Comparisons[New] = Comparisons[self]
	return setmetatable(New, SortedArray)
end

function SortedArray.__index:RemoveElement(Signature, Eq, Lt)
	local Position = self:Find(Signature, Eq, Lt)

	if Position then
		return self:RemoveIndex(Position)
	end
end

function SortedArray.__index:Sort()
	sort(self, Comparisons[self])
end

function SortedArray.__index:SortIndex(Index)
	-- Sorts a single element at number Index
	-- Useful for when a single element is somehow altered such that it should get a new position in the array

	return self:Insert(self:RemoveIndex(Index))
end

function SortedArray.__index:SortElement(Signature, Eq, Lt)
	-- Sorts a single element if it exists
	-- Useful for when a single element is somehow altered such that it should get a new position in the array

	return self:Insert(self:RemoveElement(Signature, Eq, Lt))
end

--[[
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
			self:RemoveIndex(j)
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
--]]

return Table.Lock(SortedArray)
