-- Meta class
AdvItemType = {}
AdvItemType.__index = AdvItemType

-- Create a new AdvItemType
function AdvItemType:New(item_id, item_slot, item_stats)
    local new = {
        -- Type of the item. Should be a string
        -- matching a slot in AdvInventory
        slot = item_slot,
        -- Maps stats in StatHolder to the
        -- increase in their values
        stats = item_stats,
    }
    setmetatable(new, self)

    GlobalIndex.item_types:PutId(item_id, new)
    return new
end