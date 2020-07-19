require("scripts/GlobalIndex")

-- Meta class
AdvTimer = {}
AdvTimer.__index = AdvTimer

-- Creates a new timer that will call the input function
-- after one of the below Expire methods.  
-- Note: Each timer should only be used once.
function AdvTimer:New(f)
    local new = {
        base_timer = CreateTimer(),
        func = f,
    }
    setmetatable(new, self)

    GlobalIndex.timers:Put(new.base_timer, new)
    return new
end

local function Execute()
    local timer = GetExpiredTimer()
    local adv_timer = GlobalIndex.timers:Get(timer)
    adv_timer.func(adv_timer)
end

local function Expire()
    Execute()
    local timer = GetExpiredTimer()
    PauseTimer(timer)
    DestroyTimer(timer)
    GlobalIndex.timers:Remove(timer)
end

-- Calls the input func once after the specified timeout,
-- the func takes this adv timer object
function AdvTimer:Single(timeout)
    TimerStart(self.base_timer, timeout, false, Expire)
end

local function ExpireFor()
    local timer = GetExpiredTimer()
    local adv_timer = GlobalIndex.timers:Get(timer)
    adv_timer.current_count = adv_timer.current_count + 1
    if (adv_timer.current_count >= adv_timer.max_count) then 
        Expire()
    else
        Execute()
    end
end

-- Calls the input func the specified number of times,
-- waiting the specified time between calls
function AdvTimer:For(times, timeout)
    self.current_count = 0
    self.max_count = times
    TimeStart(self.base_timer, timeout, true, ExpireFor)
end

local function ExpireWhile()
    local timer = GetExpiredTimer()
    local adv_timer = GlobalIndex.timers:Get(timer)
    if (adv_timer.bool_func(adv_timer)) then 
        Execute()
    else
        Expire()
    end
end

-- Calls the input func until the input function returns
-- false
function AdvTimer:While(bool_func, timeout)
    self.bool_func = bool_func
    TimeStart(self.base_timer, timeout, true, ExpireWhile)
end

return AdvTimer