require("scripts/Globals")

-- Meta class.
TypeIndex = {}
TypeIndex.__index = TypeIndex

-- Create a new TypeIndex.
function TypeIndex:New()
    local new = {}

    setmetatable(new, self)
    return new
end

-- Puts a value in the type index at the handles id.
-- The input handle should be able to be input to GetHandleId()
function TypeIndex:Put(handle, value)
    if (Globals.TESTING) then
        self[handle] = value
    else
        self[GetHandleId(handle)] = value
    end
end

-- Puts an id in the type index table.
function TypeIndex:PutId(id, value)
    self[id] = value
end

-- Returns the value at the input handle's id. 
-- Returns nil if the handle is not initialized.
function TypeIndex:Get(handle)
    if (Globals.TESTING) then 
        return self[handle]
    else
        return self[GetHandleId(handle)]
    end
end

-- Retruns the value at the specified id
function TypeIndex:GetId(id)
    return self[id]
end

-- Initialize the GlobalIndex table.
GlobalIndex = {
    units = TypeIndex:New(),
    players = TypeIndex:New(),
    items = TypeIndex:New(),
    item_types = TypeIndex:New(),
}

return GlobalIndex