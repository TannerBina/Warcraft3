-- Meta class
AdvInventory = {}
AdvInventory.__index = AdvInventory

-- Create a new Inventory
function AdvInventory:New()
    local new = {
        -- Set all item references to nil
        helmet = nil,
        armor = nil,
        main_hand = nil,
        off_hand = nil,
        accessory_1 = nil,
        accessory_2 = nil
    }
    setmetatable(new, self)
    
    return new
end

-- Returns true if the inventory can equip the
-- specific item
function AdvInventory:CanEquip(adv_item)
    return self[adv_item.item_def.slot] == nil
end

-- Returns true if the item can be unequiped,
-- Note: Only checks if the type is the same
function AdvInventory:CanUnequip(adv_item)
    return self[adv_item.item_def.slot] ~= nil 
end

-- Equips a specified item
function AdvInventory:Equip(adv_item)
    self[adv_item.item_def.slot] = adv_item
end

-- Unequips a specified item
function AdvInventory:Unequip(adv_item)
    self[adv_item.item_def.slot] = nil
end