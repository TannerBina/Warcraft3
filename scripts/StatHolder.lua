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
      luck = 0,

      deflection = 0,
      reflex = 0,
      fortitude = 0,
      will = 0,
      physical_defense = 0,
      eldritch_defense = 0,

      accuracy = 0,
      physical_damage = 0,
      eldritch_damage = 0,

      health = 0,
      stamina = 0,
      spell_slots = 0,
    }

    setmetatable(new, self)
    return new
end

-- Modifies the named stat. Returns a coroutine that when continued
-- reverts the stat value to the prior value
function StatHolder:ModifyStat(stat_name, mod)
    local co = coroutine.create( function()
        print(stat_name)
        self[stat_name] = self[stat_name] + mod
        coroutine.yield()
        self[stat_name] = self[stat_name] - mod
    end)
    coroutine.resume(co)
    return co
end

return StatHolder