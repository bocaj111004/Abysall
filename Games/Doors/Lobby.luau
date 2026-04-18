local LoadStart = tick() + 0.5
Abysall.SavePath = "Doors/Lobby"

local Library = Abysall.Interface.Library
local SaveManager = Abysall.Interface.SaveManager
local ThemeManager = Abysall.Interface.ThemeManager

local Toggles = Library.Toggles
local Options = Library.Options

local function CloneReference(Object)
    if Abysall and Abysall.Environment.cloneref then
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

local Window = Library:CreateWindow({
    Title = "Abysall Hub",
    Footer = "Abysall Hub - Beta | Doors (Lobby)",
    NotifySide = "Right",
    ShowCustomCursor = false,
    AutoShow = true,
    Center = true,
	TabPadding = 3,
	MenuFadeTime = 0,
    CornerRadius = 2,
})

local Tabs = {
    General = Window:AddTab("General", "house"),
}

local Groupboxes = {}
local Globals = {}
local Connections = {}
local Functions = {}

local LocalPlayer = Services.Players.LocalPlayer
local RemotesFolder = Services.ReplicatedStorage:WaitForChild("RemotesFolder")

Functions.CheckCompatability = function(Array)
    local Valid = true
    for Index, Name in pairs(Array) do
        if not Abysall.Environment[Name] then
            Valid = false
        end
    end
    return Valid
end

local function GetHiddenContainer()
	if Functions.CheckCompatability({"gethui"}) then
		return Abysall.Environment.gethui()
	else
		return Services.CoreGui
	end
end

local NotificationLibrary = {
	LiveNotifications = 0,
    Notifications = 1
}

local Container = Instance.new("ScreenGui")
Container.Name = Abysall.ESPLibrary:GenerateRandomString()
Container.Parent = GetHiddenContainer()
Container.DisplayOrder = 32767
Container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

function NotificationLibrary:Notify(TitleText, Desc, Delay)
	task.spawn(function()
		local Notification = Instance.new("Frame")
		local Line = Instance.new("Frame")
		local Warning = Instance.new("ImageLabel")
		local UICorner = Instance.new("UICorner")
        local UICorner2 = Instance.new("UICorner")
		local Title = Instance.new("TextLabel")
		local Description = Instance.new("TextLabel")

		Notification.Name = "Notification"
		Notification.Parent = Container
		Notification.BackgroundColor3 = Library.Scheme.BackgroundColor
		Notification.BackgroundTransparency = 0.4
		Notification.BorderSizePixel = 0
		Notification.Position = UDim2.new(1, 5, 0, 60 + (60 * NotificationLibrary.LiveNotifications))
		Notification.Size = UDim2.new(0, 420, 0, 50)
        Notification:SetAttribute("ID", NotificationLibrary.Notifications)
        Notification:SetAttribute("CurrentPosition", Notification.Position)

		Line.Name = "Line"
		Line.Parent = Notification
		Line.BackgroundColor3 = Library.Scheme.AccentColor
		Line.BorderSizePixel = 0
		Line.Position = UDim2.new(0, 0, 1, -3)
		Line.Size = UDim2.new(0, 0, 0, 3)

		Warning.Name = "Warning"
		Warning.Parent = Notification
		Warning.BackgroundTransparency = 1
		Warning.Position = UDim2.new(0, 10, 0, 5)
		Warning.Size = UDim2.new(0, 40, 0, 40)
		Warning.Image = "rbxassetid://3944668821"
		Warning.ImageColor3 = Library.Scheme.AccentColor
		Warning.ScaleType = Enum.ScaleType.Fit

		UICorner.CornerRadius = UDim.new(0, 20)
		UICorner.Parent = Warning

        UICorner2.CornerRadius = UDim.new(0, 4)
        UICorner2.Parent = Notification

		Title.Name = "Title"
		Title.Parent = Notification
		Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Title.BackgroundTransparency = 1.000
		Title.Position = UDim2.new(0, 60, 0.155, 0)
		Title.Size = UDim2.new(0, 205, 0, 15)
		Title.Text = TitleText or "..."
		Title.TextColor3 = Library.Scheme.FontColor
		Title.TextSize = 10
		Title.TextStrokeTransparency = 0.75
		Title.TextXAlignment = Enum.TextXAlignment.Left

		Description.Name = "Description"
		Description.Parent = Notification
		Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Description.BackgroundTransparency = 1.000
		Description.Position = UDim2.new(0, 60, 0.483, 0)
		Description.Size = UDim2.new(0, 205, 0, 18)
		Description.Text = Desc or "..."
		Description.TextColor3 = Library.Scheme.FontColor
        Description.TextTransparency = 0.1
		Description.TextSize = 10
		Description.TextStrokeTransparency = 0.75
		Description.TextXAlignment = Enum.TextXAlignment.Left
		
		NotificationLibrary.LiveNotifications = NotificationLibrary.LiveNotifications + 1
        NotificationLibrary.Notifications = NotificationLibrary.Notifications + 1
		Services.TweenService:Create(Notification, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Position = UDim2.new(1, -370, 0, Notification.Position.Y.Offset)}):Play()

		task.wait(0.25)
		Services.TweenService:Create(Line, TweenInfo.new(Delay - 0.25, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 400, 0, 3)}):Play()
		task.wait(Delay - 0.25)

        Notification:SetAttribute("Destroying", true)
		Services.TweenService:Create(Notification, TweenInfo.new(0.75, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Position = UDim2.new(1, 5, 0, Notification.Position.Y.Offset)}):Play()
		NotificationLibrary.LiveNotifications = NotificationLibrary.LiveNotifications - 1
        
        for Index, Object in pairs(Container:GetChildren()) do
            if Object.Name == "Notification" and Object:GetAttribute("ID") and Object:GetAttribute("ID") > Notification:GetAttribute("ID") and Object:GetAttribute("Destroying") ~= true and Object.Position.Y.Offset ~= 60 then
                Object:SetAttribute("CurrentPosition", UDim2.new(1, -450, 0, Object:GetAttribute("CurrentPosition").Y.Offset - 60))
                Services.TweenService:Create(Object, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {Position = UDim2.new(1, -370, 0, Object:GetAttribute("CurrentPosition").Y.Offset)}):Play()
            end
        end
        task.wait(0.75)
		Notification:Destroy()
	end)
end

Functions.Notify = function(Settings)
    local Container
    if Functions.CheckCompatability({"gethui"}) then
        Container = Abysall.Environment.gethui()
    else
        Container = Services.CoreGui
    end

    local Sound = Instance.new("Sound", Container)
    Sound.SoundId = "rbxassetid://8784885431"
    Sound.Volume = 3
    Sound.PlayOnRemove = true
    Sound:Destroy()

    NotificationLibrary:Notify(Settings.Title, Settings.Body, Settings.Time or 5)
end

Library.Notify = function(Data, Body, Time)
    Functions.Notify({Title = Body, Time = Time or 5})
end

Functions.CheckElevators = function()
    local TargetFound = false
	if not Toggles.AutoJoinElevator.Value then
		return
	end
	local TargetCharacter = Options.AutoJoinElevatorTarget.Value and Options.AutoJoinElevatorTarget.Value.Character or Options.AutoJoinElevatorTarget.Value and Services.Players:FindFirstChild(Options.AutoJoinElevatorTarget.Value) and Services.Players:FindFirstChild(Options.AutoJoinElevatorTarget.Value).Character
	for Index, Elevator in pairs(Services.Workspace.Lobby.LobbyElevators:GetChildren()) do
		if TargetCharacter and Elevator and TargetCharacter:GetAttribute("InGameElevator") and Elevator:GetAttribute("ID") and Elevator:GetAttribute("ID") == TargetCharacter:GetAttribute("InGameElevator") then
			TargetFound = true
			RemotesFolder.ElevatorJoin:FireServer(Elevator)
        end
    end
	if TargetFound == false then
		RemotesFolder.ElevatorExit:FireServer()
	end
end

Globals.RedeemingCodes = false
Globals.CodesList = {
    "67",
	"54",
	"41",
	"CHEDDAR BALLS",
	"XQC",
	"PENGUINZ0",
	"KREEKCRAFT",
	"ISHOWSPEED",
	"DANTDM",
	"KUBZ SCOUTS",
	"FIND THE TROLLFACES",
	"THINKNOODLES",
	"W",
	"RAGDOLL UNIVERSE",
	"RAGDOLL MAYHEM",
	"BIJUU MIKE",
	"8BITRYAN",
	"SCREECHSUCKS",
	"LORE",
	"ABCDEFGHIJKLMNOPQRSTUVWXYZ",
	"FIND THE TROLLFACES",
	"3rd",
	"LAZYDEVS",
	"RAGDOLL COMBAT",
	"VOCAB HAVOC",
	"PATHSWAP",
	"JUMP OVER THE BRICK"
}
Globals.UnlockedBadges = {}

Groupboxes.General_Self = Tabs.General:AddLeftGroupbox("Self")

Groupboxes.General_Self:AddToggle("AutoJoinElevator", {
    Text = "Auto Join Elevator",
    Default = false,
    Tooltip = "Automatically joins the selected player's elevator."
})

Groupboxes.General_Self:AddDropdown("AutoJoinElevatorTarget", {
    Text = "Target",
    SpecialType = "Player",
    ExcludeLocalPlayer = true,
    Searchable = true
})

Groupboxes.General_Automation = Tabs.General:AddRightGroupbox("Automation")

Groupboxes.General_Automation:AddToggle("CycleAchievements", {
    Text = "Cycle Achievements",
    Default = false,
    Tooltip = "Rapidly equips a random badge."
})

Groupboxes.General_Automation:AddSlider("CycleAchievementsDelay", {
    Text = "Cycle Delay",
    Min = 0,
    Max = 1,
    Default = 0.1,
    Rounding = 2,
    Compact = true
})

Groupboxes.General_Automation:AddDivider()

Groupboxes.General_Automation:AddButton("Redeem All Codes", function()
    if Globals.RedeemingCodes then
        return
    end

    Functions.Notify({Title = "Redeeming " .. #Globals.CodesList .. " codes.", Body = "Please wait."})
    Globals.RedeemingCodes = true
    for Index, Code in pairs(Globals.CodesList) do
        RemotesFolder.ShopCode:FireServer(Code)
        task.wait(5.1)
    end
end)

for Index, Frame in pairs(LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List:GetChildren()) do
	if Frame:IsA("ImageButton") and Frame.ImageTransparency == 0 then
		table.insert(Globals.UnlockedBadges, Frame.Name)
	end
end

Connections.BadgeAddedConnection = LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List.ChildAdded:Connect(function(Frame)
	Services.RunService.Heartbeat:Wait()
	if Frame:IsA("ImageButton") and Frame.ImageTransparency == 0 then
		table.insert(Globals.UnlockedBadges, Frame.Name)
	end
end)

Globals.LastBadgeChange = tick()
Connections.MainConnection = Services.RunService.Heartbeat:Connect(function()
    Functions.CheckElevators()

    if Toggles.CycleAchievements.Value and tick() - Globals.LastBadgeChange > Options.CycleAchievementsDelay.Value then
        local Badge = Globals.UnlockedBadges[math.random(1, #Globals.UnlockedBadges)]
        if Badge == PreviousBadge then
            while task.wait() do
				local NewBadge = Globals.UnlockedBadges[math.random(1, #Globals.UnlockedBadges)]
				if NewBadge ~= PreviousBadge then
					Badge = NewBadge
					break
				end
			end
		end
		for Index, Frame in pairs(LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List:GetChildren()) do
			if Frame:IsA("ImageButton") and Frame.ImageTransparency == 0 then
				LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List:FindFirstChild(Frame.Name).Icons.Star.Visible = false
			end
		end
		RemotesFolder:WaitForChild("FlexAchievement"):FireServer(Badge)
		PreviousBadge = Badge
		LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List:FindFirstChild(Badge).Icons.Star.Visible = true

        Globals.LastBadgeChange = tick()
	end
end)

Abysall.Interface.ApplySettingsTab(Window)
Library:OnUnload(function()
    Connections.MainConnection:Disconnect()
end)

task.wait(0.5)
Functions.Notify({Title = "Successfully loaded in " .. math.floor((tick() - LoadStart) * 1000) / 1000 .. " seconds."})
