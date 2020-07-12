require("AdvPlayer")
require("AdvUnit")

function InitTesting()
    BJDebugMsg("---Creating Test Unit---")
    local unit = CreateUnit(Player(0), FourCC('H002'), -600, -430, 0)
    local adv_unit = AdvUnit:New(unit)
    BJDebugMsg("---Created Test Unit---")
    BJDebugMsg("---Setting Test Player Hero---")
    local adv_player = AdvPlayer:New(0)
    adv_player:SetHero(adv_unit)
    BJDebugMsg("---Set Test Player Hero---")
end