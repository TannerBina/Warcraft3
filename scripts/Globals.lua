Globals = {
    TESTING=false,
    GLOBAL_ID = 0,
}

function Globals:GetGlobalId()
    GLOBAL_ID = GLOBAL_ID+1
    return GLOBAL_ID
end

return Globals