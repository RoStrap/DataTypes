# Utility
A collection of Libraries which do complex operations on various data types

## Table
### API
#### Table.Move
```lua
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
```
```lua
-- Example Code
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Resources = require(ReplicatedStorage:WaitForChild("Resources"))
local Table = Resources:LoadLibrary("Table")
local Debug = Resources:LoadLibrary("Debug")

print(Debug.TableToString(Table.Move({1, 2, 3}, 1, 3, 2)))
-- {1, 1, 2, 3}

-- Explanation:
-- Inserts {1, 2, 3} @ 2
```
#### Table.Lock
Converts a table into a read-only userdata.

## SortedArray
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Resources = require(ReplicatedStorage:WaitForChild("Resources"))
local SortedArray = Resources:LoadLibrary("SortedArray")

local Array = SortedArray.new()

-- Alternatively
local Sorted = SortedArray.new{2, 1, 5, 3} -- Will get `table.sort`ed
```

### API
#### SortedArray:Insert()
Inserts an element in the proper place which would preserve the array's orderedness.
```lua
local Sorted = SortedArray.new{1, 2, 3, 5}
Sorted:Insert(4)
print("{" .. Sorted:Concat(", ") .. "}")
-- {1, 2, 3, 4, 5}
```

#### SortedArray:Remove()
If the parameter passed to `Remove` is an array, it will remove all values within the array from the `SortedArray`
```lua
local Sorted = SortedArray.new{1, 2, 3, 5}
Sorted:Remove{1, 2, 3}
print("{" .. Sorted:Concat(", ") .. "}")
-- {5}
```

If the parameter is not of `type(table)` then it will fall back on table.remove

#### SortedArray:Transform(a2 [, f1, f2])
Does the operations necessary to transform SortedArray into the `a2`, a second array. `f1` is an optional callback which fires for each addition operation necessary and `f2` for each removal. `f1` and `f2` will be called with `(number IndexWhereOperationTakesPlace, ValueWhichIsBeingRemovedOrAdded)`
```lua
local Array = SortedArray.new{"Chromenium", "GigsD4X", "Validark"}

local function f1(i, v)
	print("f1(" .. i .. ", " .. v .. ")")
end

local function f2(i, v)
	print("f2(" .. i .. ", " .. v .. ")")
end

Array:Transform(SortedArray.new{"Chromenium", "Evaera", "Validark"}, f1, f2)

-- The first parameter MUST be sorted, but it doesn't need to have the `SortedArray` metatable
-- This also works:
-- Array:Transform({"Chromenium", "Evaera", "Validark"}, f1, f2)

--[[
Output:
	f1(2, Evaera)
	f2(3, GigsD4X)
	
f1 indicates that "Evaera" must be inserted at index 2: table.insert(Array, 2, "Evaera")
f2 indicates that the 3rd element of Array ("GigsD4X") must be removed (AFTER the previous operation shifted the array forward): table.remove(Array, 3)
--]]
```
#### SortedArray:Copy()
Shallow copy. Pretty straightforward.

### Other SortedArray methods
You can directly index functions from its index table, like `Concat`, `Next`, and `ForEach`. [View the full list in the source.](https://github.com/RoStrap/Utility/blob/master/SortedArray.lua#L9)

Simply for convenience. It's also faster to do an `__index` lookup than a global lookup, so there's that too. 

```lua
SortedArray.new{"Chromenium", "GigsD4X", "Validark"}:ForEach(print)

--[[
	1 Chromenium
	2 GigsD4X
	3 Validark
--]]
```
## HTMLParser
Demo:
```lua
local HttpService = game:GetService("HttpService")
local HTML = HTMLParser.new(HttpService:GetAsync("https://github.com/"))

while HTML:Next().Tag do
	print(HTML.Tag, HTML.Data)
end
-- Once an HTMLParser reaches its end, `Tag` and `Data` become nil


-- The object can be used again for round 2!
while HTML:Next().Tag do
	print(HTML.Tag, HTML.Data)
end
```
### API
Instantiation:
```lua
local HTML = HTMLParser.new(HTML_DOCUMENT_STRING)
```
Advancement:
```lua
HTML:Next()
HTML:Next():Next():Next()
```
Accessing data at the current state:
```lua
print(HTML.Tag) -- /html (no <>)
print(HTML.Data) -- This value is anything that occurs after HTML.Tag but before the next Tag
```

New HTMLParsers do not have `Tag` or `Data` immediately after instantiation, and must have `Next()` called on them first.
