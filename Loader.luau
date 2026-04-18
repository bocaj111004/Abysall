if Abysall then
    return 
end

local GameList = {
  [2440500124] = "Doors"
}

local BaseUrl = "https://raw.githubusercontent.com/bocaj111004/Abysall/refs/heads/main/"
getgenv().Abysall = {
    Environment = loadstring(game:HttpGet(BaseUrl .. "Components/Environment.luau"))(),
    ESPLibrary = loadstring(game:HttpGet(BaseUrl .. "Components/ESP.luau"))(),
    Interface = loadstring(game:HttpGet(BaseUrl .. "Components/Interface.luau"))(),
}

local Success, Result = pcall(function()
    local Game = GameList[game.GameId]
    if Game then
        loadstring(game:HttpGet(BaseUrl .. "Games/" .. Game .. "/Loader.luau"))()
    end
end)
