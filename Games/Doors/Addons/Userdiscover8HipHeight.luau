local UserDisTab = Window:AddTab("userdisover addon", "star")

local DisoverGroupbox = UserDisTab:AddLeftGroupbox("Features")

DisoverGroupbox:AddToggle("Hip", {
    Text = "Enable Hipheight",
    Default = false,
    Tooltip = "Toggle Hip."
})

DisoverGroupbox:AddSlider("HipSlide", {
    Text = "Hipheight controll",
    Min = 0,
    Max = 50,
    Default = 0,
    Rounding = 0,
    Compact = true
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function waitForCharacter()
    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end
    return LocalPlayer.Character
end

local function getHumanoid()
    local character = LocalPlayer.Character
    if not character then return nil end
    if not character.Parent then return nil end
    return character:FindFirstChildOfClass("Humanoid")
end

local function isReady()
    local character = LocalPlayer.Character
    if not character or not character.Parent then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    if not character:FindFirstChild("HumanoidRootPart") then return false end
    if humanoid.Health <= 0 then return false end
    return true, humanoid
end

local function applyHipHeight()
    if not Library.Options.Hip.Value then return end
    local ready, humanoid = isReady()
    if not ready then return end

    if _G.OriginalHipHeight == nil then
        _G.OriginalHipHeight = humanoid.HipHeight
    end

    humanoid.HipHeight = Library.Options.HipSlide.Value
end

Library.Options.HipSlide:OnChanged(function(Value)
    applyHipHeight()
end)

Library.Options.Hip:OnChanged(function(Value)
    local ready, humanoid = isReady()
    if not ready then return end

    if Value then
        _G.OriginalHipHeight = humanoid.HipHeight
        humanoid.HipHeight = Library.Options.HipSlide.Value
    else
        if _G.OriginalHipHeight ~= nil then
            humanoid.HipHeight = _G.OriginalHipHeight
            _G.OriginalHipHeight = nil
        end
    end
end)

task.spawn(function()
    waitForCharacter()
    repeat task.wait(0.1) until isReady()
    applyHipHeight()
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    character:WaitForChild("HumanoidRootPart")
    repeat task.wait(0.1) until character:FindFirstChildOfClass("Humanoid").Health > 0
    _G.OriginalHipHeight = nil
    applyHipHeight()
end)
