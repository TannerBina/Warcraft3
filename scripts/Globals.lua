Globals = {
    TESTING=false,
    GLOBAL_ID = 0,
    MAIN_STAT_MULT = 2,
    BASE_STAT_VALUE = 74,
}

function Globals:GetGlobalId()
    GLOBAL_ID = GLOBAL_ID+1
    return GLOBAL_ID
end

return Globals