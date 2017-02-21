local ffi = require("ffi")
local math = require("math")
local rnd = math.random
local C = ffi.C
local SpaceSaving = require("spacesaving")

local function get_time()
    return tonumber(C.get_time_ns())
end

local t1 = SpaceSaving:new(256, 5)
local cumulative = 0
local iterations = 1000000
for i = 1, iterations, 1 do
    local t1 = get_time()
    t1:touch(i, math.random(100))
    cumulative = cumulative + (get_time() - t1)
end

print("NS Per Operation: " .. cumulative / iterations)


