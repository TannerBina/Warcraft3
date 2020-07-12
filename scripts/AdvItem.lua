require("GlobalIndex")

-- Meta class
AdvItem = {}
AdvItem.__index = AdvItem

function AdvItem:New(item, item_def)
    local new = {
        -- The base item associated with this adv item
        base_item = item,
        -- A table mapping stats (as defined in the StatHolder) to
        -- values for the stats
        item_def = item_def,
        -- Set of coroutines that were applied to increase stats via this
        -- item. Empty if the item is not equiped yet
        stat_coroutines = {}
    }

    setmetatable(new, self)
    GlobalIndex.items:Put(item, new)
    return new
end

function AdvItem:EquipTo(adv_unit)
    for stat, value in pairs(self.item_def) do
        -- Modify the stats of the adv_unit with the
        -- corresponding values, then save the coroutine
        local co = adv_unit.stats:ModifyStat(stat, value)
        table.insert( self.stat_coroutines, co)
    end
end

function AdvItem:UnequipTo(adv_unit)
    for i, co in ipairs(self.stat_coroutines) do
        -- Resume each coroutine to take the stats away from the
        -- corresponding unit again
        coroutine.resume(co)
    end
    self.stat_coroutines = {}
end

return AdvItem