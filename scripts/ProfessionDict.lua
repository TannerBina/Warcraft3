function soldier_apply(adv_unit, level)
end

-- Dictionary of professions. Each profession
-- maps from the profession name to an apply function that takes
-- in a unit and the level that unit has reached
ProfessionDict = {
    soldier = require("scripts/professions/Soldier"),
}

return ProfessionDict