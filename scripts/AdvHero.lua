require("scripts/AdvUnit")
require("scripts/AdvInventory")
require("scripts/ProfessionDict")

-- Meta class
-- Inherits from AdvUnit
AdvHero = {}
AdvHero.__index = AdvHero
setmetatable(AdvHero, AdvUnit)

-- Create a new AdvHero
function AdvHero:New(base_unit)
    local new = {
        -- maps back to the basic unit
        base_unit = base_unit,
        -- holds the hero's stats
        stats = StatHolder:New(),
         -- A map of all buffs applied to this unit,
        -- keyed by the buff id
        buff_map = {},
        -- Holds the inventory and equipment of the
        -- hero
        inventory = AdvInventory:New(),
        -- Maps class names to the level of the
        -- class for the hero
        profession_levels = {},
    }
    setmetatable(new, self)

    GlobalIndex.units:Put(base_unit, new)
    return new
end

function AdvHero:GetProfessionLevel(prof)
    if (self.profession_levels[prof] == nil) then
        return 0
    end
    return self.profession_levels[prof]
end

function AdvHero:GetString()
    local str = AdvUnit.GetString(self)

    str = str .. "Hero Professions" .. "\n"
    for prof, value in pairs(self.profession_levels) do 
        str = str .. prof .. ":" .. value .. "\n"
    end

    return str
end

-- Increases the input professions level (in string)
-- form
function AdvHero:IncreaseProfessionLevel(prof)
    if (self.profession_levels[prof] == nil) then 
        self.profession_levels[prof] = 0
    end
    self.profession_levels[prof] = self.profession_levels[prof] + 1
    ProfessionDict[prof].apply(self, self.profession_levels[prof])
end

-- Attempts to equip an input adv_item, returns
-- true if successful, else false
function AdvHero:Equip(adv_item)
    if (self.inventory:CanEquip(adv_item)) then
        self.inventory:Equip(adv_item)
        for stat, value in pairs(adv_item.item_def.stats) do
            -- Modify the stats of the adv_unit with the
            -- corresponding values, then save the coroutine
            local co = self.stats:ModifyStat(stat, value)
            table.insert(adv_item.stat_coroutines, co)
        end
        return true 
    end
    return false 
end

-- Attempts to unequip an input adv_item
function AdvHero:Unequip(adv_item)
    if (self.inventory:CanUnequip(adv_item)) then 
        self.inventory:Unequip(adv_item)
        for i, co in ipairs(adv_item.stat_coroutines) do
            -- Resume each coroutine to take the stats away from the
            -- corresponding unit again
            coroutine.resume(co)
        end
        adv_item.stat_coroutines = {}
    end
end

return AdvHero