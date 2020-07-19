require("scripts/StatHolder")
require("scripts/GlobalIndex")
require("scripts/Globals")
require("scripts/AdvTimer")

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

local function SetStats(adv_unit)
    if (Globals.TESTING == true) then
        return 
    end

    local life_percent = GetUnitLifePercent(adv_unit.base_unit)
    SetUnitLifeBJ(adv_unit.base_unit, adv_unit:GetStat("health"))
    SetUnitLifePercentBJ(adv_unit.base_unit, life_percent)

    local stam_percent = GetUnitManaPercent(adv_unit.base_unit)
    SetUnitManaBJ(adv_unit.base_unit, adv_unit:GetStat("stamina"))
    SetUnitManaPercentBJ(adv_unit.base_unit, stam_percent)
end

function AdvUnit:ResetStats()
    self.stats = StatHolder:New()
    SetStats(self)
end

function AdvUnit:SetBaseUnit(base_unit) 
    self.base_unit = base_unit
    SetStats(self)
end

-- Gets the stat of the unit (with modifiers) and returns the stat
function AdvUnit:GetStat(stat)
    if (stat == "deflection") then 
        return stats[stat] + (Globals.MAIN_STAT_MULT * stats["luck"])
    elseif (stat == "reflex") then
        return stats[stat] + (Globals.MAIN_STAT_MULT * stats["dexterity"])
    elseif (stat == "fortitude") then
        return stats[stat] + (Globals.MAIN_STAT_MULT * stats["strength"])
    elseif (stat == "will") then
        return stats[stat] + (Globals.MAIN_STAT_MULT * stats["intelligence"])
    elseif (stat == "physical_defense") then
        return stats[stat] + (Globals.MAIN_STAT_MULT * stats["constitution"])
    elseif (stat == "eldritch_defense") then
        return stats[stat] + (Globals.MAIN_STAT_MULT * stats["wisdom"])
    elseif (stat == "stamina") then
        return stats[stat] + (Globals.MAIN_STAT_MULT * stats["dexterity"])
    elseif (stat == "health") then
        return stats[stat] + (4 * stats["constitution"])
    elseif (stat == "spell_slots") then
        return stats[stat] + stats["wisdom"]
    elseif (stat == "accuracy") then
        return stats[stat] + stats["luck"]
    elseif (stat == "physical_damage") then
        return stats[stat] + stats["strength"]
    elseif (stat == "eldritch_damage") then
        return stats[stat] + stats["intelligence"]
    end
    return stats[stat];
end

-- Modifys a stat of the unit. After calls SetStats for the units
-- to verify the stats are set correctly for the unit
function AdvUnit:ModifyStat(stat, value)
    local co = self.stats:ModifyStat(stat, value)
    SetStats(self)
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

-- Local function to remove a buff at an expired timer
local function RemoveBuff(adv_timer) 
    local co = adv_timer.buff_coroutine;
    coroutine.resume(co)
end

-- Applys a buff to this unit for the specified time.
-- Note: The time must be a multiple of the input interval
function AdvUnit:AddTimedBuff(adv_buff, time, interval)
    adv_buff.permanent = false
    local co = self:AddBuff(adv_buff)
    local adv_timer = AdvTimer:New(RemoveBuff)
    adv_timer.buff_coroutine = co
    adv_timer:For(time/interval, interval)
end

-- Applys a permanent buff to this unit.
-- Note: The id of this buff should be unique this may be removed
-- from the coroutine of the next buff.
function AdvUnit:AddPermanentBuff(adv_buff)
    adv_buff.permanent = true 
    self:AddBuff(adv_buff)
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