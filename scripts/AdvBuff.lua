-- Meta class
AdvBuff = {}
AdvBuff.__index = AdvBuff

function AdvBuff:New(buff_id)
    local new = {
        id = buff_id,
        -- If true, this buff is a negative buff
        debuff = false,
        -- If true, this buff cannot be removed
        permanent = false,
        -- An arbitrary level for the buff. For non-stackable
        -- buffs, the higher level buff applies
        level = 0,
        -- Maps from trigger times to the
        -- function that is triggered, See the options
        -- for trigger times in AdvUnit
        triggers = {},
        -- Maps from stat names (see StatHolder) to the
        -- value to increase them by
        stats = {},
        -- A list of coroutines to remove the stats added by this buff
        stat_coroutines = {},
        -- The coroutine to remove this buff
        coroutine = nil,
        -- The remaining duration of this buff
        remaining_duration = 0,
    }
    setmetatable(new, self)

    return new
end

-- Adds a trigger to the buff
-- Note: Only a single trigger can be added at one time
function AdvBuff:AddTrigger(trigger_time, trigger_func)
    self.triggers[trigger_time] = trigger_func
end