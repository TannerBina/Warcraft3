require("GlobalIndex")
require("AdvHero")

local function PickStonefist()
    local player = GetOwningPlayer(GetTriggerUnit())
    local adv_player = GlobalIndex.players:Get(player)
    local unit = CreateUnit(player, FourCC('H00G'), GetRectCenterX(udg_StonefistSelect), GetRectCenterY(udg_StonefistSelect), 0)
    local adv_hero = AdvHero:New(unit)

    if (adv_player.player_hero == nil) then
        adv_player:SetHero(adv_hero)
    else
        adv_player.player_hero = adv_hero
    end

    GlobalIndex.units:Remove(GetTriggerUnit())
    RemoveUnit(GetTriggerUnit())
end