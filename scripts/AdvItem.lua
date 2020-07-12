require("scripts/GlobalIndex")

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

return AdvItem