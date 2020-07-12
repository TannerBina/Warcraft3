-- Meta class
StatHolder = {}
StatHolder.__index = StatHolder

-- Class methods
function StatHolder:New()
    local new = {
      strength = 0,
      dexterity = 0,
      intelligence = 0,
      constitution = 0,
      wisdom = 0,
      charisma = 0,
    }

    setmetatable(new, self)
    return new
end

-- Modifies the named stat. Returns a coroutine that when continued
-- reverts the stat value to the prior value
function StatHolder:ModifyStat(stat_name, mod)
    local co = coroutine.create( function()
        self[stat_name] = self[stat_name] + mod
        coroutine.yield()
        self[stat_name] = self[stat_name] - mod
    end)
    coroutine.resume(co)
    return co
end

return StatHolder