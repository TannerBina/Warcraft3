require("scripts/Globals")

function DisplayText(text, player)
    if (Globals.TESTING) then 
        print(text)
    else
        local force = CreateForce()
        ForceAddPlayer(force, player)
        DisplayTextToForce(force, text)
        DestroyForce(force)
    end
end