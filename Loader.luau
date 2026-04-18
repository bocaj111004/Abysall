local GameList = {
  [2440500124] = "Doors"
}

local BaseUrl = "https://raw.githubusercontent.com/bocaj111004/Abysall/refs/heads/main/"
getgenv().Abysall = {
    Environment = loadstring(game:HttpGet(BaseUrl .. "Components/Environment.luau"))(),
    AdonisBypass = loadstring(game:HttpGet(BaseUrl .. "Components/AdonisBypass.luau"))(),
    Interface = loadstring(game:HttpGet(BaseUrl .. "Components/Interface.luau"))(),
}

local Dependancies = {
    "writefile",
    "readfile",
    "isfile",
    "appendfile",
    "delfile",
    "listfiles",
    "makefolder",
    "delfolder"
}

for Index, Value in pairs(Dependancies) do
    if not Abysall.Environment[Value] then
          game:GetService("Players").LocalPlayer:Kick("Your executor is not supported.\nWe would recommend looking at https://whatexpsare.online to find a supported executor.")
        return
    end
end

local Success, Result = pcall(function()
    local Game = GameList[game.GameId]
    if Game then
        loadstring(game:HttpGet(BaseUrl .. "Games/" .. Game .. "/Main.luau"))()
    end
end)
