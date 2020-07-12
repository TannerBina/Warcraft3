require("scripts/StatHolder")
require("scripts/GlobalIndex")
require("scripts/Globals")

-- Meta class
AdvUnit = {}
AdvUnit.__index = AdvUnit

-- Create a new AdvUnit
function AdvUnit:New(base_unit)
    local new = {
      base_unit = base_unit,
      stats = StatHolder:New(),
    }
    setmetatable(new, self)

    GlobalIndex.units:Put(base_unit, new)
    return new
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

    -- Add all of the stats to the str
    for stat, value in pairs(self.stats) do 
        str = str .. stat .. ":" .. value .. "\n"
    end

    return str
end

return AdvUnit