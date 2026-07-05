--[[

    For anyone wondering, this just sends a discord message when someone executed the script.
    We only log basic data such as roblox username, executor used and the game you are in.
    Sensetive data such as IP adresses or HWIDs are NOT logged and never will be.
    If you want proof of this, feel free to dm me on discord: bocaj111004.

]]--

local function CloneReference(Object)
    if Abysall.Environment.cloneref then
        return Abysall.Environment.cloneref(Object)
    else
        return Object
    end
end

local Services = setmetatable({}, {
    __index = function(self, Name)
        return CloneReference(game:GetService(Name))
    end
})

if Abysall.Environment.identifyexecutor and Abysall.Environment.request then
    local Player = Services.Players.LocalPlayer
    local Data = {
        Account = Player.Name,
        Executor = Abysall.Environment.identifyexecutor(),
        Executions = tonumber(Abysall.TotalExecutions),
        GameName = Services.MarketplaceService:GetProductInfo(game.PlaceId).Name,
        PlaceId = tostring(game.PlaceId)
    }

    task.spawn(function()
        pcall(function()
            Abysall.Environment.request({
                Url = "http://93.115.101.180:10577/send",
                Method = "POST",
                Headers = {
                    ["content-type"] = "application/json"
                },
                Body = Services.HttpService:JSONEncode(Data)
            })
        end)
    end)
end
