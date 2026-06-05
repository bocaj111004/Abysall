local Services = setmetatable({}, {
    __index = function(self, Name)
        if Abysall.Environment.cloneref then
            return Abysall.Environment.cloneref(game:GetService(Name))
        else
            return game:GetService(Name)
        end
    end
})

local Bindable = Instance.new("BindableFunction")
Bindable.OnInvoke = function(Response)
    local Success, Result = pcall(function()
        toclipboard("https://discord.gg/5jwbZcqjVF")
    end)
    if not Success then
        Services.LocalPlayer:Kick("Failed to copy invite.\nhttps://discord.gg/5jwbZcqjVF")
    end
end

Services.StarterGui:SetCore("SendNotification", {
    Title = "Abysall Hub",
    Text = "Only DOORS is supported right now, sorry :)",
    Duration = 10,
    Button1 = "Copy Discord Invite",
    Callback = Bindable,
})
