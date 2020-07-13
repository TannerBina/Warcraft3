function soldier_apply(adv_unit, level)
end

-- Dictionary of professions. Each profession
-- maps from 
ProfessionDict = {
    soldier = {
        apply = soldier_apply
    },
}

return ProfessionDict