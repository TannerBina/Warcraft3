require("scripts/GlobalIndex")

-- Meta class
AdvPlayer = {}
AdvPlayer.__index = AdvPlayer

-- Creates a new adv player based on the input player number.
function AdvPlayer:New(player)
    local new = {
      -- contains a reference to the Player.
      player = player,
      -- contains a reference to the AdvHero of the player
      player_hero = nil,
      -- contains an array of six stat rolls for the player
      stat_rolls = nil,
      -- contains the current index of the stat rolls to assign
      stat_roll_index = 0,
    }
    setmetatable(new, self)

    GlobalIndex.players:Put(new.player, new)
    return new
end

-- Sets the player hero for the player.
function AdvPlayer:SetHero(hero)
    self.player_hero = hero

    -- Add a trigger that whenever the player types -TestHero the players info will print
    -- NOTE: TESTING ONLY
    local trigger = CreateTrigger()
    TriggerRegisterPlayerChatEvent(trigger, self.player, "-TestHero", true)
    TriggerAddAction(trigger, function() 
        local player = GetTriggerPlayer()
        local adv_player = GlobalIndex.players:Get(player)
        BJDebugMsg("---Printing Player Hero---")
        BJDebugMsg(adv_player.player_hero:GetString())
    end)
end

return AdvPlayer