require("scripts/AdvUnit")
require("scripts/AdvInventory")

-- Meta class
-- Inherits from AdvUnit
AdvHero = {}
AdvHero.__index = AdvHero
setmetatable(AdvHero, AdvUnit)

-- Create a new AdvHero
function AdvHero:New(base_unit)
    local new = {
        base_unit = base_unit,
        stats = StatHolder:New(),
        inventory = AdvInventory:New(),
    }
    setmetatable(new, self)

    GlobalIndex.units:Put(base_unit, new)
    return new
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