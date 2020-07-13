require("scripts/StatHolder")
require("scripts/GlobalIndex")
require("scripts/Globals")

-- Meta class
AdvUnit = {}
AdvUnit.__index = AdvUnit

-- Create a new AdvUnit
function AdvUnit:New(base_unit)
    local new = {
      -- maps back to the basic unit
      base_unit = base_unit,
      -- holds the hero's stats
      stats = StatHolder:New(),
      -- A map of all buffs applied to this unit,
      -- keyed by the buff id
      buff_map = {},
    }
    setmetatable(new, self)

    GlobalIndex.units:Put(base_unit, new)
    return new
end

-- Adds the buff to this unit. Returns a coroutine that removes
-- the specified buff from this unit.
-- Note: The buff duration may extend past what the current
-- duration is due to stackable buffs
function AdvUnit:AddBuff(adv_buff)
    if (self.buff_map[adv_buff.id] ~= nil) then
        local existing_buff = self.buff_map[adv_buff.id]
        -- Run the existing buffs coroutine so that it will be completed
        coroutine.resume(existing_buff.coroutine)
        -- Add the higher level buff to the unit with a duration that is
        -- the max of the two buffs duration
        local max_buff = existing_buff
        if (existing_buff.level < adv_buff.level) then 
            max_buff = adv_buff
        end
        if (existing_buff.remaining_duration > adv_buff.remaining_duration) then 
            max_buff.remaining_duration = existing_buff.remaining_duration
        else
            max_buff.remaining_duration = adv_buff.remainging_duration
        end
        -- Return the coroutine to add the merged buffs if they stack
        return self:AddBuff(max_buff)
    end

    -- Add the buff with a coroutine that when continued removes the buff
    local co = coroutine.create( function()
        -- At this point assume the buff is new
        -- Add the buff to the buff map
        self.buff_map[adv_buff.id] = adv_buff
        -- Add the stats of the buff, saving the coroutines
        for stat, value in pairs(adv_buff.stats) do 
            local co = self.stats:ModifyStat(stat, value)
            table.insert(adv_buff.stat_coroutines, co)
        end
        coroutine.yield()
        -- Remove it from the buff map
        self.buff_map[adv_buff.id] = nil
        -- Run the stat coroutines to remove them
        for i, co in ipairs(adv_buff.stat_coroutines) do 
            coroutine.resume(co)
        end
    end)
    -- Set the courtine in the newly added buff to fix merging
    adv_buff.coroutine = co
    coroutine.resume( co )
    return co
end

-- Applies all buffs on the unit that are keyed by the
-- input trigger event time. The buffs are applied to the input
-- damage event, altering it
function AdvUnit:ApplyBuffs(trigger_event, damage_event)
    for id, buff in pairs(self.buff_map) do 
        for event, trigger in buff.triggers do
            if (event == trigger_event) then
                trigger(damage_event)
            end
        end
    end
end

-- Returns a str representation of the unit.
function AdvUnit:GetString()
    -- Set the str to the units name.
    local str = ""
    if (Globals.TESTING) then
        str = self.base_unit .. "\n"
    else
        str = GetUnitName(self.base_unit) .. "\n"
    end

    str = str .. "Unit Stats" .. "\n"
    -- Add all of the stats to the str
    for stat, value in pairs(self.stats) do 
        str = str .. stat .. ":" .. value .. "\n"
    end

    return str
end

return AdvUnit