require("scripts/Globals")
require("scripts/GlobalIndex")
require("scripts/util/DisplayText")

-- Rolls stats and returns an array of the six stats rolled.
function RollStats()
    local stats = {}
    local current = Globals.BASE_STAT_VALUE
    local adv_player
    if (Globals.TESTING) then
        adv_player = GlobalIndex.players:Get("mock_player")
    else
        adv_player = GlobalIndex.players:Get(GetOwningPlayer(GetTriggerUnit()))
    end

    if (adv_player.player_hero == nil) then
        DisplayText("You must pick a starting soul before rolling stats.", adv_player.player)
        return
    else
        adv_player.player_hero:ResetStats()
    end

    local roll_string = ""
    for i = 6, 2, -1 do
        local roll = math.random(12) - 6
        local base = math.floor(current/i)
        stats[i] = roll + base
        current = current - (roll+base)
        roll_string = stats[i] .. ", " .. roll_string
    end
    stats[1] = current
    roll_string = stats[1] .. ", " .. roll_string

    adv_player.stat_rolls = stats
    adv_player.stat_roll_index = 1

    DisplayText("Your rolls are: " .. roll_string, adv_player.player)
end