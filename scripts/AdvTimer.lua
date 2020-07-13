require("GlobalIndex")

-- Meta class
AdvTimer = {}
AdvTimer.__index = AdvTimer

function AdvTimer:New()
    local new = {
        base_timer = CreateTimer(),
        func = nil,
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
function AdvTimer:Single(timeout, func)
    self.func = func
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
function AdvTimer:For(times, timeout, func)
    self.func = func
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
function AdvTimer:While(bool_func, timeout, func)
    self.func = func
    self.bool_func = bool_func
    TimeStart(self.base_timer, timeout, true, ExpireWhile)
end