require("AdvPlayer")

local function Initialize()
    local players = GetPlayersAll()
    ForForce(players, function()
        local player = GetEnumPlayer()
        local unit = CreateUnit(player, FourCC('e000'), -9617, 9537, 0)
        local adv_player = AdvPlayer:New(player)
    end)
end