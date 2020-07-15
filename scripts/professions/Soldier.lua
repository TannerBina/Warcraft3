function soldier_apply(adv_unit, level)
    adv_unit:ModifyStat("health", 15)
end

Soldier = {
    apply = soldier_apply
}

return Soldier