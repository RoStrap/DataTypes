-- Utility Table functions
-- This Library is not for a bunch of for-loop wrapper functions.
-- Either write your own for-loops or learn python instead

local Table = {}

function Table.Move(a1, f, e, t, a2)
	-- Moves elements [f, e] from array a1 into a2 starting at index t
	-- Equivalent to Lua 5.3's table.move
	-- @param table a1 from which to draw elements from range
	-- @param number f starting index for range
	-- @param number e ending index for range
	-- @param number t starting index to move elements from a1 within [f, e]
	-- @param table a2 the second table to move these elements to
	--	@default a2 = a1
	-- @returns a2

	a2 = a2 or a1
	t = t + e

	for i = e, f, -1 do
		t = t - 1
		a2[t] = a1[i]
	end

	return a2
end

function Table.CallOnDifferences(a1, a2, f1, f2)
	-- Between sorted arrays a1 into a2, calls f1 for each addition to a1 and f2 for each removal from a1
	-- 	Functions are called with values being added or removed
	-- @param table a1 The first sorted array
	-- @param table a2 The second sorted array
	-- @param function f1 the first function
	-- @param function f2 the second function
	-- @returns nil
	-- @example	a1 = {1, 2, 3, 4}
	--			a2 = {0, 2, 3, 5}
	--		calls f1(0), f2(1), f2(4), f1(5)

	local a = 1
	local b = 1

	local a_max = #a1 + 1
	local b_max = #a2 + 1

	while a < a_max do
		while b < b_max and a1[a] > a2[b] do
			f1(a2[b])
			b = b + 1
		end

		while a < a_max and a1[a] == a2[b] do
			a = a + 1
			b = b + 1
		end

		while a < a_max and (b == b_max or a2[b] > a1[a]) do
			f2(a1[a])
			a = a + 1
		end
	end

	for i = b, b_max - 1 do
		f1(a2[i])
	end
end

do
	-- Create read-only table which cannot be written to or modified

	local function ReadOnlyNewIndex(_, Index, _)
		error("[Table] Cannot write to index \"" .. tostring(Index) .. "\" of read-only table", 2)
	end

	local ReadOnlyMetatable = "[Table] Requested metatable of read-only table is locked"

	function Table.Lock(t)
		return setmetatable({}, {
			__index = function(_, Index)
				return t[Index] or error("[Table] \"" .. tostring(Index) .. "\" does not exist in read-only table", 2)
			end;

			__newindex = ReadOnlyNewIndex;
			__metatable = ReadOnlyMetatable;
		})
	end
end

return Table
