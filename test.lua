local ffi = require("ffi")
C = ffi.load("rt", true)


ffi.cdef[[
    typedef long time_t;
    typedef int clockid_t;

    typedef struct timespec {
            time_t   tv_sec;        /* seconds */
            long     tv_nsec;       /* nanoseconds */
    } nanotime;

    int clock_gettime(clockid_t clk_id, struct timespec *tp);
]]

local function get_time()
    local pnano = assert(ffi.new("nanotime[?]", 1))

    -- CLOCK_REALTIME -> 0
    ffi.C.clock_gettime(0, pnano)
    return tonumber(pnano[0].tv_sec) * 1e9 + tonumber(pnano[0].tv_nsec)
end

local math = require("math")
local rnd = math.random
local SpaceSaving = require("spacesaving")

local function benchmark(num, iterations, hitrate)
    local cumulative = 0
    local ss = SpaceSaving:new(num, 1)

    -- Warmup
    for i = 1, num, 1 do
        ss:touch(tostring(i), get_time())
    end
 
    local topRange = math.floor(num * 1 / hitrate)

    for i = 1, iterations, 1 do
        local key = tostring(rnd(topRange))
        local t1 = get_time()
        ss:touch(key, get_time())
        cumulative = cumulative + (get_time() - t1)
    end
    print(num .. " Buckets / " .. iterations .. " Iterations / " .. hitrate .. " Hit Rate -- NS Per Operation: " .. cumulative / iterations)
end

local iters = 5000000
benchmark(16384, 1e6, 0.1)
benchmark(37268, 1e6, 0.1)
benchmark(16384, 1e6, 0.5)
benchmark(37268, 1e6, 0.5)
benchmark(16384, 2e6, 0.9)
benchmark(37268, 2e6, 0.9)
benchmark(1024, 5e6, 1)
benchmark(2048, 3e6, 1)
benchmark(4096, 3e6, 1)
benchmark(8192, 3e6, 1)
benchmark(16384, 3e6, 1)
benchmark(32768, 3e6, 1)
