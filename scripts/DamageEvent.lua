-- Meta class
DamageEvent = {}
DamageEvent.__index = DamangeEvent

-- Create a new DamageEvent
function DamageEvent:New()
    local new = {
        
    }
    setmetatable(new, self)
    return new
end

return DamageEvent