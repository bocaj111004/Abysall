local LoadStart = tick()
Abysall.SavePath = "Doors/Game"

local Library = Abysall.Interface.Library
local SaveManager = Abysall.Interface.SaveManager
local ThemeManager = Abysall.Interface.ThemeManager

local Toggles = Library.Toggles
local Options = Library.Options

local function CloneReference(Object)
	if Abysall and Abysall.Environment.cloneref then
		return Abysall.Environment.cloneref(Object)
	end
	return Object
end

local Services = setmetatable({}, {
	__index = function(Self, Name)
		return CloneReference(game:GetService(Name))
	end
})

local Globals = {}
local Connections = {}
local ESPConnections = {}
local Groupboxes = {}
local FakePrompts = {}
local Functions = {}
local PartProperties = {}

local Objects = {
	Prompts = {},
	Objectives = {},
	Doors = {},
	HidingSpots = {},
	Entities = {},
	SeekObstructions = {},
	Items = {},
	Chests = {},
	Currency = {},
	Ladders = {},
	Obstructions = {},
	EventTriggers = {},
	JumpscareModules = {},
	SeekHighlights = {},
	EyestalkHighlights = {},
	SeekNodes = {},
	SeekDuckBoards = {},
	SeekBridges = {}
}

Globals.IncompatibleMessage = "Your executor doesn't support this feature."

Functions.CheckCompatability = function(Array)
	for _, Name in Array do
		if not Abysall.Environment[Name] then
			return false
		end
	end
	return true
end

local Entities = {
	["RushMoving"] = {
		Alias = "Rush",
		NotifyMessage = { Title = "Entity 'Rush' has spawned.", Body = "Find a hiding spot." }
	},
	["AmbushMoving"] = {
		Alias = "Ambush",
		NotifyMessage = { Title = "Entity 'Ambush' has spawned.", Body = "Find a hiding spot." }
	},
	["Eyes"] = {
		Alias = "Eyes",
		NotifyMessage = { Title = "Entity 'Eyes' has spawned.", Body = "Avoid looking at it." }
	},
	["Lookman"] = {
		Alias = "Eyes",
		NotifyMessage = { Title = "Entity 'Eyes' has spawned.", Body = "Avoid looking at it." }
	},
	["BackdoorRush"] = {
		Alias = "Blitz",
		NotifyMessage = { Title = "Entity 'Blitz' has spawned.", Body = "Find a hiding spot." }
	},
	["BackdoorLookman"] = {
		Alias = "Lookman",
		NotifyMessage = { Title = "Entity 'Lookman' has spawned.", Body = "Avoid looking at its eyes." }
	},
	["Groundskeeper"] = {
		Alias = "Groundskeeper",
		NotifyMessage = { Title = "Entity 'Groundskeeper' has spawned.", Body = "Avoid stepping on the grass." }
	},
	["A60"] = {
		Alias = "A-60",
		NotifyMessage = { Title = "Entity 'A-60' has spawned.", Body = "Find a hiding spot." }
	},
	["A120"] = {
		Alias = "A-120",
		NotifyMessage = { Title = "Entity 'A-120' has spawned.", Body = "Find a hiding spot." }
	},
	["GloombatSwarm"] = {
		Alias = "Gloombat Swarm",
		NotifyMessage = { Title = "Entity 'Gloombat Swarm' has spawned.", Body = "Keep all light sources turned off." }
	},
	["GlitchRush"] = {
		Alias = "RNIUSHCG==",
		NotifyMessage = { Title = "Entity 'RNIUSHCG==' has spawned.", Body = "Find a hiding spot." }
	},
	["GlitchAmbush"] = {
		Alias = "AR0xMBUSH",
		NotifyMessage = { Title = "Entity 'AR0xMBUSH' has spawned.", Body = "Find a hiding spot." }
	},
	["MonumentEntity"] = {
		Alias = "Monument",
		NotifyMessage = { Title = "Entity 'Monument' has spawned.", Body = "It cannot move while you are looking at it." }
	},
	["JeffTheKiller"] = {
		Alias = "Jeff the Killer",
		NotifyMessage = { Title = "Entity 'Jeff the Killer' has spawned.", Body = "Avoid touching him." }
	},
	["CustomEntity"] = {
		Alias = "Custom Entity",
		NotifyMessage = { Title = "Entity 'Custom Entity' has spawned.", Body = "Find a hiding spot." }
	},
	["FrozenAmbush"] = {
		Alias = "Frozen Ambush",
		NotifyMessage = { Title = "Entity 'Frozen Ambush' has spawned.", Body = "Find a hiding spot." }
	},
	["SallyMoving"] = {
		Alias = "Sally",
		NotifyMessage = { Title = "Entity 'Sally' has spawned.", Body = "Drop an item for her." }
	}
}

local EntityIcons = {
	["RushMoving"]      = "rbxassetid://10716032262",
	["AmbushMoving"]    = "rbxassetid://10110576663",
	["A60"]             = "rbxassetid://12571092295",
	["A120"]            = "rbxassetid://12711591665",
	["BackdoorRush"]    = "rbxassetid://16602023490",
	["Eyes"]            = "rbxassetid://10183704772",
	["Lookman"]         = "rbxassetid://10183704772",
	["BackdoorLookman"] = "rbxassetid://16764872677",
	["GloombatSwarm"]   = "rbxassetid://79221203116470",
	["Halt"]            = "rbxassetid://11331795398",
	["JeffTheKiller"]   = "rbxassetid://94479432156278",
	["GlitchRush"]      = "rbxassetid://73859273102919",
	["GlitchAmbush"]    = "rbxassetid://88369678433359",
	["SallyMoving"]     = "rbxassetid://10840888070",
	["MonumentEntity"]  = "rbxassetid://88933556873017",
	["Groundskeeper"]   = "rbxassetid://114991380115557"
}

local ItemNames = {
	["Lighter"]           = "Lighter",
	["Flashlight"]        = "Flashlight",
	["Lockpick"]          = "Lockpicks",
	["Vitamins"]          = "Vitamins",
	["Bandage"]           = "Bandage",
	["StarVial"]          = "Starlight Vial",
	["StarBottle"]        = "Starlight Bottle",
	["StarJug"]           = "Starlight Barrel",
	["Shakelight"]        = "Gummy Flashlight",
	["Straplight"]        = "Straplight",
	["Bulklight"]         = "Spotlight",
	["Battery"]           = "Battery",
	["Candle"]            = "Candle",
	["Crucifix"]          = "Crucifix",
	["CrucifixWall"]      = "Crucifix",
	["Glowsticks"]        = "Glowstick",
	["SkeletonKey"]       = "Skeleton Key",
	["Candy"]             = "Candy",
	["ShieldMini"]        = "Mini Shield Potion",
	["ShieldBig"]         = "Big Shield Potion",
	["BandagePack"]       = "Bandage Pack",
	["BatteryPack"]       = "Battery Pack",
	["RiftCandle"]        = "Moonlight Candle",
	["LaserPointer"]      = "Laser Pointer",
	["HolyGrenade"]       = "Holy Hand Grenade",
	["Shears"]            = "Shears",
	["Smoothie"]          = "Smoohie",
	["Cheese"]            = "Cheese",
	["Bread"]             = "Bread",
	["AlarmClock"]        = "Alarm Clock",
	["RiftSmoothie"]      = "Moonlight Smoothie",
	["GweenSoda"]         = "Gween Soda",
	["GlitchCube"]        = "Glitch Fragment",
	["Scanner"]           = "Tablet",
	["Bomb"]              = "Bomb",
	["Knockbomb"]         = "Knockbomb",
	["Nanner"]            = "Nanner",
	["BigBomb"]           = "Big Bomb",
	["SnakeBox"]          = "Hiding Box",
	["GoldGun"]           = "Golden Gun",
	["StopSign"]          = "Stop Sign",
	["TipJar"]            = "Tip Jar",
	["Lantern"]           = "Lantern",
	["IronKey"]           = "Iron Key",
	["LotusPetal"]        = "Lotus Petal",
	["Compass"]           = "Compass",
	["LotusPetalPickup"]  = "Lotus Petal",
	["LanternLitItem"]    = "Lantern",
	["KeyIron"]           = "Iron Key",
	["IronKeyForCrypt"]   = "Iron Key",
	["LotusHolder"]       = "Lotus Petal",
	["Multitool"]         = "Multitool",
	["RiftJar"]           = "Rift Jar",
	["AloeVera"]          = "Aloe Vera",
	["Donut"]             = "Donut",
	["Lotus"]             = "Lotus",
	["BoxingGloves"]      = "Boxing Gloves"
}

local Character
local Humanoid
local RootPart

local Collision
local CollisionClone
local CollisionPart
local CollisionPartClone

local Camera
local LocalPlayer = Services.Players.LocalPlayer

local RemotesFolder   = Services.ReplicatedStorage:FindFirstChild("RemotesFolder")
local LiveModifiers   = Services.ReplicatedStorage:FindFirstChild("LiveModifiers")
local FloorReplicated = Services.ReplicatedStorage:FindFirstChild("FloorReplicated")
local CurrentRooms    = Services.Workspace:FindFirstChild("CurrentRooms")
local Drops           = Services.Workspace:FindFirstChild("Drops")
local GameData        = Services.ReplicatedStorage:WaitForChild("GameData")
local Floor           = GameData:WaitForChild("Floor").Value
local LatestRoom      = GameData:WaitForChild("LatestRoom")

local function GetHiddenContainer()
	if Functions.CheckCompatability({"gethui"}) then
		return Abysall.Environment.gethui()
	end
	return Services.CoreGui
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

if not Library.Scheme then
	Library.Scheme = setmetatable({}, {
		__index = function(Self, Name)
			return Library[Name]
		end
	})
end

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
		Title.BackgroundTransparency = 1
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
		Description.BackgroundTransparency = 1
		Description.Position = UDim2.new(0, 60, 0.483, 0)
		Description.Size = UDim2.new(0, 205, 0, 18)
		Description.Text = Desc or "..."
		Description.TextColor3 = Library.Scheme.FontColor
		Description.TextTransparency = 0.1
		Description.TextSize = 10
		Description.TextStrokeTransparency = 0.75
		Description.TextXAlignment = Enum.TextXAlignment.Left

		NotificationLibrary.LiveNotifications += 1
		NotificationLibrary.Notifications += 1

		Services.TweenService:Create(
			Notification,
			TweenInfo.new(1, Enum.EasingStyle.Exponential),
			{ Position = UDim2.new(1, -370, 0, Notification.Position.Y.Offset) }
		):Play()

		task.wait(0.25)
		if typeof(Delay) == "Instance" then
			Delay.Destroying:Wait()
		else
			Services.TweenService:Create(
				Line,
				TweenInfo.new(Delay - 0.25, Enum.EasingStyle.Linear),
				{ Size = UDim2.new(0, 400, 0, 3) }
			):Play()
			task.wait(Delay - 0.25)
		end

		Notification:SetAttribute("Destroying", true)

		Services.TweenService:Create(
			Notification,
			TweenInfo.new(0.75, Enum.EasingStyle.Exponential, Enum.EasingDirection.In),
			{ Position = UDim2.new(1, 5, 0, Notification.Position.Y.Offset) }
		):Play()

		NotificationLibrary.LiveNotifications -= 1

		local NotifId = Notification:GetAttribute("ID")
		local NotifY = Notification:GetAttribute("CurrentPosition").Y.Offset

		for _, Object in Container:GetChildren() do
			if Object.Name == "Notification"
				and Object:GetAttribute("ID")
				and Object:GetAttribute("ID") > NotifId
				and Object:GetAttribute("Destroying") ~= true
				and Object.Position.Y.Offset ~= 60
			then
				local NewY = Object:GetAttribute("CurrentPosition").Y.Offset - 60
				Object:SetAttribute("CurrentPosition", UDim2.new(1, -450, 0, NewY))
				Services.TweenService:Create(
					Object,
					TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut),
					{ Position = UDim2.new(1, -370, 0, NewY) }
				):Play()
			end
		end

		task.wait(0.75)
		Notification:Destroy()
	end)
end

Globals.DoorsNotify = function(NotifyOptions)
	local function PlaySound(Parent, SoundId, Volume)
		local Sound = Instance.new("Sound")
		Sound.SoundId = SoundId
		Sound.Volume = Volume or 1
		Sound.Parent = Parent
		task.spawn(function()
			task.wait(0.1)
			Sound:Play()
			Sound.Ended:Wait()
			Sound:Destroy()
		end)
	end

	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
	local UIContainer = PlayerGui:FindFirstChild("GlobalUI") or PlayerGui:FindFirstChild("MainUI")
	if not UIContainer then return end

	local AchievementsHolder = UIContainer:FindFirstChild("AchievementsHolder")
	if not AchievementsHolder then return end

	local Achievement = AchievementsHolder.Achievement:Clone()
	Achievement.Size = UDim2.new(0, 0, 0, 0)
	Achievement.Frame.Position = UDim2.new(1.1, 0, 0, 0)
	Achievement.Name = "LiveAchievement"
	Achievement.Visible = true

	Achievement.Frame.TextLabel.Text = NotifyOptions.Style or "NOTIFICATION"
	Achievement.Frame.Details.Title.Text = NotifyOptions.Title or "Sem Título"
	Achievement.Frame.Details.Desc.Text = NotifyOptions.Description or "Sem Descrição"
	Achievement.Frame.Details.Reason.Text = NotifyOptions.Reason or ""
	Achievement.Frame.ImageLabel.Image = (NotifyOptions.Image ~= "" and NotifyOptions.Image) or "rbxassetid://6023426923"

	local Color = NotifyOptions.Color or Color3.new(1, 1, 1)
	Achievement.Frame.TextLabel.TextColor3 = Color
	Achievement.Frame.UIStroke.Color = Color
	Achievement.Frame.Glow.ImageColor3 = Color
	Achievement.Parent = AchievementsHolder

	PlaySound(AchievementsHolder, "rbxassetid://10469938989", 1)

	task.spawn(function()
		Achievement:TweenSize(UDim2.new(1, 0, 0.2, 0), "In", "Quad", 0.8, true)
		task.wait(0.8)
		Achievement.Frame:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.5, true)
		Services.TweenService:Create(
			Achievement.Frame.Glow,
			TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{ ImageTransparency = 1 }
		):Play()

		if typeof(NotifyOptions.Time) == "Instance" then
			NotifyOptions.Time.Destroying:Wait()
		else
			task.wait(NotifyOptions.Time or 5)
		end

		Achievement.Frame:TweenPosition(UDim2.new(1.1, 0, 0, 0), "In", "Quad", 0.5, true)
		task.wait(0.5)
		Achievement:TweenSize(UDim2.new(1, 0, -0.1, 0), "InOut", "Quad", 0.5, true)
		task.wait(0.5)
		Achievement:Destroy()
	end)
end

Functions.Notify = function(Settings)
	local HiddenContainer = GetHiddenContainer()

	if not Settings.Body then
		Settings.Body = "..."
	end

	if not Options.NotifyStyle or Options.NotifyStyle.Value == "Abysall" then
		local Sound = Instance.new("Sound", HiddenContainer)
		Sound.SoundId = "rbxassetid://8784885431"
		Sound.Volume = (Toggles.NotifyPlaySound and Toggles.NotifyPlaySound.Value and Options.NotifySoundVolume.Value) or (Toggles.NotifyPlaySound and 0 or 3)
		Sound.PlayOnRemove = true
		Sound:Destroy()
		NotificationLibrary:Notify(Settings.Title, Settings.Body, Settings.Time or 5)
	elseif Options.NotifyStyle.Value == "Doors" then
		local IsEntity = false
		local EntityName = ""
		for Index, Object in pairs(Entities) do
			if Object.NotifyMessage.Title == Settings.Title or Object.NotifyMessage.Body == Settings.Body then
				IsEntity = true
				EntityName = Index
			end
		end
		Globals.DoorsNotify({
			Title = "Abysall Hub",
			Description = Settings.Title,
			Reason = Settings.Body,
			Style = IsEntity and "WARNING" or "NOTIFICATION",
			Color = IsEntity and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 222, 189),
			Image = Settings.Image,
			Time = Settings.Time
		})
	else
		local Sound = Instance.new("Sound", HiddenContainer)
		Sound.SoundId = "rbxassetid://4590662766"
		Sound.Volume = (Toggles.NotifyPlaySound and Toggles.NotifyPlaySound.Value and Options.NotifySoundVolume.Value) or (Toggles.NotifyPlaySound and 0 or 3)
		Sound.PlayOnRemove = true
		Sound:Destroy()
		Library:OldNotify({ Title = Settings.Title, Description = Settings.Body, Time = Settings.Time })
	end
end

Functions.Caption = function(Text, PlaySound)
	if typeof(PlaySound) ~= "boolean" then
		PlaySound = true
	end
	local CaptionValue = Instance.new("NumberValue")
	local Caption = Globals.MainUI:WaitForChild("MainFrame"):WaitForChild("Caption"):Clone()
	local CaptionSound = Globals.MainUI:WaitForChild("Initiator"):WaitForChild("Main_Game"):WaitForChild("Reminder"):WaitForChild("Caption")
	local CaptionSoundClone = CaptionSound:Clone()
	CaptionSoundClone.Parent = CaptionSound.Parent
	CaptionSoundClone.Volume = 0.1

	Caption.Destroying:Connect(function()
		CaptionValue:Destroy()
	end)

	for _, Child in Globals.MainUI:GetChildren() do
		if Child.Name == "LiveCaption" then
			Child:Destroy()
		end
	end

	Caption.Parent = Globals.MainUI
	Caption.Visible = true
	Caption.Name = "LiveCaption"
	Caption.Text = Text

	if PlaySound then
		CaptionSoundClone:Play()
	end

	Services.Debris:AddItem(CaptionSoundClone, 5)

	local HolderTween = Services.TweenService:Create(CaptionValue, TweenInfo.new(3), { Value = 100 })
	HolderTween:Play()
	HolderTween.Completed:Connect(function()
		CaptionValue:Destroy()
		Services.TweenService:Create(Caption, TweenInfo.new(4, Enum.EasingStyle.Linear), { TextTransparency = 1 }):Play()
		Services.TweenService:Create(Caption, TweenInfo.new(4, Enum.EasingStyle.Linear), { TextStrokeTransparency = 1 }):Play()
	end)
end

Functions.GetHasteTime = function()
	local TimeRemaining = FloorReplicated.DigitalTimer.Value
	local Minutes = math.floor(TimeRemaining / 60)
	local Seconds = TimeRemaining - (Minutes * 60)
	local MinutesText = Minutes < 10 and ("0" .. tostring(Minutes)) or tostring(Minutes)
	local SecondsText = Seconds < 10 and ("0" .. tostring(Seconds)) or tostring(Seconds)
	return MinutesText .. ":" .. SecondsText
end

Library.OldNotify = Library.Notify
Library.Notify = function(Data, Body, Time)
	Functions.Notify({ Title = Body, Time = Time or 5 })
end

if not LocalPlayer.Character or not CurrentRooms:FindFirstChildOfClass("Model") then
	Functions.Notify({ Title = "Waiting for the game to load..." })
	while not LocalPlayer.Character or not CurrentRooms:FindFirstChildOfClass("Model") do
		task.wait()
	end
	task.wait(4)
end

if not RemotesFolder then
	if Services.ReplicatedStorage:FindFirstChild("EntityInfo") then
		RemotesFolder = Services.ReplicatedStorage:FindFirstChild("EntityInfo")
	elseif Services.ReplicatedStorage:FindFirstChild("Bricks") then
		RemotesFolder = Services.ReplicatedStorage:FindFirstChild("Bricks")
	end
end

if Floor == "Hotel" and RemotesFolder.Name == "Bricks" then
	Floor = "OldHotel"
end

if not LiveModifiers then
	LiveModifiers = Instance.new("Folder")
end

if not FloorReplicated then
	FloorReplicated = Instance.new("Folder")
end

local FakeEvents = {
	Screech = Instance.new("RemoteEvent"),
	Shade   = Instance.new("RemoteEvent"),
	A90     = Instance.new("RemoteEvent"),
	Surge   = Instance.new("RemoteEvent"),
}

FakeEvents.Screech.Name  = "Screech"
FakeEvents.Shade.Name    = "ShadeResult"
FakeEvents.A90.Name      = "A90"
FakeEvents.Surge.Name    = "SurgeRemote"

FakeEvents.Screech_Real = RemotesFolder:WaitForChild("Screech")
FakeEvents.Shade_Real   = RemotesFolder:WaitForChild("ShadeResult")
FakeEvents.A90_Real     = RemotesFolder:FindFirstChild("A90")
FakeEvents.Surge_Real   = RemotesFolder:FindFirstChild("SurgeRemote")

Globals.FogInstances = {}
Globals.OldFog = Services.Lighting.FogEnd

for _, Object in Services.Lighting:GetChildren() do
	if Object:IsA("Atmosphere") then
		Object:SetAttribute("Density_Old", Object.Density)

		local AtmoConnection = Object:GetPropertyChangedSignal("Density"):Connect(function()
			if Object.Density ~= 0 then
				Object:SetAttribute("Density_Old", Object.Density)
			end
			if Toggles.RemoveCameraFog.Value then
				Object.Density = 0
			end
		end)

		Object.Destroying:Once(function()
			AtmoConnection:Disconnect()
		end)

		table.insert(Connections, AtmoConnection)
		table.insert(Globals.FogInstances, Object)
	end
end

Globals.SeekNodesFolder = Instance.new("Folder", Services.Workspace)
Globals.SeekNodesFolder.Name = Abysall.ESPLibrary:GenerateRandomString()

Globals.RoomsNodesFolder = Instance.new("Folder", Services.Workspace)
Globals.RoomsNodesFolder.Name = Abysall.ESPLibrary:GenerateRandomString()

Functions.SendChat = function(Message)
	local Folder = Services.ReplicatedStorage:FindFirstChild("DefaultChatSystemEvents") or Instance.new("Folder")
	local Event = Folder:FindFirstChild("SayMessageRequest") or Instance.new("RemoteEvent")
	Event:FireServer(Message, "All")
	local Channel = (Services.TextChatService:FindFirstChild("TextChannels") and Services.TextChatService.TextChannels:FindFirstChild("RBXGeneral")) or Instance.new("TextChannel")
	Channel:SendAsync(Message)
end

Functions.IsCrouching = function()
	if Floor == "Fools" or Floor == "OldHotel" then
		return Character:GetAttribute("Crouching")
	end
	return CollisionPart.CollisionGroup == "PlayerCrouching"
end

Functions.GetInjuriesSpeed = function()
	return 0.075 * (Humanoid.MaxHealth - Humanoid.Health)
end

Functions.GetCurrentSpeed = function()
	local Speed = 15
	Speed += Character:GetAttribute("SpeedBoost") or 0
	Speed += Character:GetAttribute("SpeedBoostBehind") or 0
	Speed += Character:GetAttribute("SpeedBoostExtra") or 0
	Speed += (Floor == "Party" and 10 or 0)
	Speed += (LiveModifiers:FindFirstChild("PlayerFast") and 3 or 0)
	Speed += (LiveModifiers:FindFirstChild("PlayerFaster") and 6 or 0)
	Speed += (LiveModifiers:FindFirstChild("PlayerFastest") and 20 or 0)
	Speed -= (LiveModifiers:FindFirstChild("PlayerSlow") and 3 or 0)
	Speed -= (LiveModifiers:FindFirstChild("PlayerSlowHealth") and Functions.GetInjuriesSpeed() or 0)
	if Functions.IsCrouching() then
		if LiveModifiers:FindFirstChild("PlayerCrouchSlow") then
			Speed -= 8
		elseif LiveModifiers:FindFirstChild("PlayerSlow") then
			Speed -= 8
		else
			Speed -= 5
		end
	end
	return Speed
end

Functions.GetMousePosition = function()
	if Library.IsMobile then
		return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	end
	local MouseLocation = Services.UserInputService:GetMouseLocation()
	return Vector2.new(MouseLocation.X, MouseLocation.Y)
end

Functions.FormatOxygen = function(Oxygen)
	return "Oxygen: " .. (math.floor(Oxygen * 10) / 10) .. "%"
end

Functions.IsHidePersistent = function()
	return Floor == "Mines"
		or Floor == "Ripple"
		or Floor == "Party"
		or LiveModifiers:FindFirstChild("HideLevel2") ~= nil
end

Functions.GetPlayerFromMouse = function(TargetPart, MaxDistance)
	local Closest
	local ClosestDistance = math.huge

	for _, Player in Services.Players:GetPlayers() do
		local Char = Player.Character
		if Char then
			local Target = Char:FindFirstChild(TargetPart)
			if Target then
				local Result = Camera:WorldToViewportPoint(Target.Position)
				local ScreenPos = Vector2.new(Result.X, Result.Y)
				local Distance = (Functions.GetMousePosition() - ScreenPos).Magnitude
				if Player.Name ~= LocalPlayer.Name and Distance < ClosestDistance and Distance < MaxDistance then
					Closest = Target
					ClosestDistance = Distance
				end
			end
		end
	end
	return Closest
end

local EntityDistances = {
	["RushMoving"]    = 85,
	["AmbushMoving"]  = 150,
	["A60"]           = 125,
	["A120"]          = 85,
	["GlitchRush"]    = 90,
	["GlitchAmbush"]  = 175,
	["BackdoorRush"]  = 85,
	["CustomEntity"]  = 85,
}

Functions.GetNearestEntity = function(CheckDisabled, List, UseRaycasting)
	local Nearest = { Distance = math.huge, Object = nil }

	for _, Entity in Services.Workspace:GetChildren() do
		if Entity and EntityDistances[Entity.Name] and Entity.PrimaryPart then
			local EntityData = Entities[Entity.Name]
			if not (List and List[EntityData.Alias]) then
				local Distance = LocalPlayer:DistanceFromCharacter(Entity.PrimaryPart.Position)
				if Distance < EntityDistances[Entity.Name] and Distance < Nearest.Distance then
					if not CheckDisabled or Entity:GetAttribute("Inactive") ~= true then
						Nearest.Distance = Distance
						Nearest.Object = Entity
					end
				end
			end
		end
	end
	return Nearest.Object
end

Functions.GetNearestFigure = function()
	local Nearest = { Distance = math.huge, Object = nil }
	local FigureNames = { FigureRig = true, FigureRagdoll = true, Figure = true }

	for _, Object in Objects.Entities do
		if Object.PrimaryPart and FigureNames[Object.Name] then
			local Distance = LocalPlayer:DistanceFromCharacter(Object.PrimaryPart.Position)
			if Distance < Nearest.Distance and Distance < 25 then
				Nearest.Distance = Distance
				Nearest.Object = Object
			end
		end
	end
	return Nearest.Object
end

Functions.GetNearestHidingSpot = function()
	local Nearest = { Distance = math.huge, Object = nil }
	local LastHideSpot = Character:FindFirstChild("LastHideSpot")

	for _, Object in Objects.HidingSpots do
		if Object.PrimaryPart and Object:FindFirstChild("HidePrompt") then
			local Distance = LocalPlayer:DistanceFromCharacter(Object.PrimaryPart.Position)
			if Distance < Object.HidePrompt.MaxActivationDistance and Distance < Nearest.Distance then
				local Persistent = Functions.IsHidePersistent()
				if not Persistent or (LastHideSpot and LastHideSpot.Value ~= Object) or not LastHideSpot then
					Nearest.Distance = Distance
					Nearest.Object = Object
				end
			end
		end
	end
	return Nearest.Object
end

Functions.GetNearestTurnNode = function()
	local Nearest = { Distance = math.huge, Object = nil }

	for _, Node in Objects.SeekNodes do
		local Distance = LocalPlayer:DistanceFromCharacter(Node.Position)
		if Distance < Options.AutoSteerMinecartTurnDistance.Value and Distance < Nearest.Distance then
			Nearest.Distance = Distance
			Nearest.Object = Node
		end
	end
	return Nearest.Object
end

Functions.GetNearestDuckBoard = function()
	local Nearest = { Distance = math.huge, Object = nil }

	for _, Board in Objects.SeekDuckBoards do
		if Board.PrimaryPart then
			local Distance = LocalPlayer:DistanceFromCharacter(Board.PrimaryPart.Position)
			if Distance < Options.AutoSteerMinecartDuckDistance.Value and Distance < Nearest.Distance then
				Nearest.Distance = Distance
				Nearest.Object = Board
			end
		end
	end
	return Nearest.Object
end

Functions.GetCurrentAnchor = function()
	local AnchorCode = Globals.MainUI.AnchorHintFrame.AnchorCode.Text
	for _, Anchor in Objects.Objectives do
		if Anchor.Name == "MinesAnchor" and Anchor:FindFirstChild("Sign") then
			if Anchor.Sign.TextLabel.Text == AnchorCode then
				return Anchor
			end
		end
	end
end

Functions.GetMinecart = function()
	return Camera:FindFirstChild("MinecartRig") ~= nil
end

Functions.HasItem = function(Name, OnlyCharacter)
	if not OnlyCharacter and LocalPlayer.Backpack:FindFirstChild(Name) then
		return LocalPlayer.Backpack:FindFirstChild(Name)
	elseif Character:FindFirstChild(Name) then
		return Character:FindFirstChild(Name)
	end
end

Functions.GetFlyVelocity = function()
	if Humanoid.MoveDirection == Vector3.zero then
		return Humanoid.MoveDirection
	end
	local LookFlat = Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z)
	local FlatFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + LookFlat)
	local Velocity = (Camera.CFrame * CFrame.new(FlatFrame:VectorToObjectSpace(Humanoid.MoveDirection))).Position - Camera.CFrame.Position
	if Velocity == Vector3.zero then
		return Velocity
	end
	return Velocity.Unit
end

Globals.PromptContainer = Instance.new("Folder")
Globals.PromptContainer.Name = "PromptContainer"
Globals.PromptContainer.Parent = GetHiddenContainer()

local ESPBlacklist = {}

Functions.AddESP = function(ESPOptions, RoomBased)
	local Object = ESPOptions.Object

	if table.find(ESPBlacklist, Object) then
		return
	end

	if RoomBased then
		local CurrentRoom = tonumber(LocalPlayer:GetAttribute("CurrentRoom"))
		local ObjectRoom = tonumber(Object:GetAttribute("ParentRoom"))

		if ObjectRoom == CurrentRoom or (table.find(Objects.Doors, Object) and ObjectRoom == CurrentRoom + 1) then
			Abysall.ESPLibrary:AddESP(ESPOptions)
		end

		local RoomConnection = LocalPlayer:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
			if Abysall.ESPLibrary.ColorTable[Object] then
				ESPOptions.Color = Abysall.ESPLibrary.ColorTable[Object]
			end

			local NewCurrentRoom = tonumber(LocalPlayer:GetAttribute("CurrentRoom"))
			local ObjRoom = tonumber(Object:GetAttribute("ParentRoom"))

			if ObjRoom == NewCurrentRoom or (table.find(Objects.Doors, Object) and ObjRoom == NewCurrentRoom + 1) then
				Abysall.ESPLibrary:AddESP(ESPOptions)
			else
				Abysall.ESPLibrary:RemoveESP(Object)
			end
		end)

		table.insert(Connections, RoomConnection)
		ESPConnections[Object] = RoomConnection

		Object.Destroying:Once(function()
			RoomConnection:Disconnect()
			if Abysall then
				Abysall.ESPLibrary:RemoveESP(Object)
			end
			local Pos = table.find(Connections, RoomConnection)
			if Pos then table.remove(Connections, Pos) end
		end)
	else
		Abysall.ESPLibrary:AddESP(ESPOptions)
	end
end

Functions.RemoveESP = function(Object)
	local Conn = ESPConnections[Object]
	if Conn then
		Conn:Disconnect()
		ESPConnections[Object] = nil
		local Pos = table.find(Connections, Conn)
		if Pos then table.remove(Connections, Pos) end
	end
	Abysall.ESPLibrary:RemoveESP(Object)
end

Functions.BlacklistESP = function(Object)
	table.insert(ESPBlacklist, Object)
end

Functions.GetLibraryCode = function()
	local Paper = Character:FindFirstChild("LibraryHintPaper")
		or Character:FindFirstChild("LibraryHintPaperHard")
		or LocalPlayer.Backpack:FindFirstChild("LibraryHintPaper")
		or LocalPlayer.Backpack:FindFirstChild("LibraryHintPaperHard")

	if Paper and Paper:FindFirstChild("UI") then
		local Code = {}
		local CodeLength = Floor == "Fools" and 10 or 5
		for I = 1, CodeLength do Code[I] = "_" end

		local HintChildren = LocalPlayer.PlayerGui.PermUI.Hints:GetChildren()
		local UIChildren = Paper.UI:GetChildren()

		for _, Hint in HintChildren do
			for _, UIChild in UIChildren do
				if Hint:IsA("ImageLabel") and UIChild:IsA("ImageLabel")
					and Hint.ImageRectOffset == UIChild.ImageRectOffset
					and Code[tonumber(UIChild.Name)]
				then
					Code[tonumber(UIChild.Name)] = Hint.TextLabel.Text
				end
			end
		end
		return table.concat(Code)
	end
	return Floor == "Fools" and "__________" or "_____"
end

Globals.UsedRandomCodes = {}
Functions.GetRandomCode = function()
	local Code = Functions.GetLibraryCode()
	if Code then
		return (Code:gsub("_", function()
			return tostring(math.random(1, 10) - 1)
		end))
	end
end

local Window = Library:CreateWindow({
	Title = (Abysall.UILibrary == "Linoria" and "Abysall Hub - discord.gg/5jwbZcqjVF" or "Abysall Hub"),
	Footer = "Abysall Hub - discord.gg/5jwbZcqjVF",
	NotifySide = "Right",
	ShowCustomCursor = false,
	AutoShow = true,
	Center = true,
	TabPadding = 3,
	MenuFadeTime = 0,
	CornerRadius = 2,
})

Abysall.Interface.ApplyInfoTab(Window)

local Tabs = {
	General  = Window:AddTab("General", "house"),
	Exploits = Window:AddTab("Exploits", "shield"),
	Visuals  = Window:AddTab("Visuals", "eye"),
	Floors   = Window:AddTab("Floors", "earth"),
}

Groupboxes.General_Character = Tabs.General:AddLeftGroupbox("Character")
Groupboxes.General_Character:AddSlider("SpeedBoostSlider", {
	Text = "Speed Boost", Min = 0, Max = 85, Default = 0, Rounding = 0, Compact = true
})
Groupboxes.General_Character:AddToggle("SpeedBoostToggle", {
	Text = "Enable Speed Boost", Default = false, Tooltip = "Increases your walkspeed by the specified amount."
})
Groupboxes.General_Character:AddToggle("FlyToggle", {
	Text = "Fly", Default = false, Tooltip = "Allows you to freely fly around the map."
})
Toggles.FlyToggle:AddKeyPicker("FlyKeybind", {
	Text = "Fly", Default = "F", Mode = "Toggle", SyncToggleState = true
})
Groupboxes.General_Character:AddSlider("FlySpeed", {
	Text = "Fly Speed", Min = 0, Max = 100, Default = 20, Rounding = 0, Compact = true
})
Groupboxes.General_Character:AddDivider()
Groupboxes.General_Character:AddToggle("NoclipToggle", {
	Text = "Noclip", Default = false, Tooltip = "Allows your character to pass through solid objects."
})
Groupboxes.General_Character:AddToggle("RemoveClosetDelay", {
	Text = "Remove Closet Delay", Default = false,
	Tooltip = "Removed the short window where you can't exit out of a closet after the animation finishes."
})
Groupboxes.General_Character:AddToggle("RemoveAcceleration", {
	Text = "Remove Acceleration", Default = false, Tooltip = "Prevents your character from sliding while moving."
})

local CustomPhysics

Toggles.NoclipToggle:AddKeyPicker("NoclipKeybind", {
	Text = "Noclip", Default = "N", Mode = "Toggle", SyncToggleState = true
})
Toggles.RemoveAcceleration:OnChanged(function(Value)
	for Index, Old in PartProperties do
		Index.CustomPhysicalProperties = Value and CustomPhysics or Old
	end
end)

Groupboxes.General_Character:AddDivider()
Groupboxes.General_Character:AddToggle("EnableCharacterJump", {
	Text = "Enable Jumping", Default = false, Tooltip = "Allows your character to jump."
})
Groupboxes.General_Character:AddToggle("EnableCharacterSlide", {
	Text = "Enable Sliding", Default = false, Tooltip = "Allows your character to slide."
})
Groupboxes.General_Character:AddToggle("InfiniteJumps", {
	Text = "Infinite Jumps", Default = false, Tooltip = "Allows you to jump while in the air."
})

local OldJump = false
local OldSlide = false

Toggles.SpeedBoostToggle:OnChanged(function(Value)
	if Humanoid then
		Humanoid.WalkSpeed = Functions.GetCurrentSpeed() + (Value and Options.SpeedBoostSlider.Value or 0)
	end
end)
Toggles.EnableCharacterJump:OnChanged(function(Value)
	if Character then
		Character:SetAttribute("CanJump", Value and true or OldJump)
	end
end)
Toggles.EnableCharacterSlide:OnChanged(function(Value)
	if Character then
		Character:SetAttribute("CanSlide", Value and true or OldSlide)
	end
end)

Groupboxes.General_Self = Tabs.General:AddLeftGroupbox("Self")
Groupboxes.General_Self:AddToggle("DoorReachToggle", {
	Text = "Door Reach", Default = false, Tooltip = "Allows you to open doors from further away."
})
Groupboxes.General_Self:AddToggle("DisableIdleKick", {
	Text = "Disable Idle Kick", Default = false, Tooltip = "Prevents the kick from being idle for 20 minutes."
})
Toggles.DisableIdleKick:OnChanged(function(Value)
	if Functions.CheckCompatability({"getconnections"}) then
		for _, Conn in Abysall.Environment.getconnections(LocalPlayer.Idled) do
			if Value then Conn:Disable() else Conn:Enable() end
		end
	end
end)
LocalPlayer.Idled:Connect(function()
	if Toggles.DisableIdleKick.Value then
		Services.VirtualUser:CaptureController()
		Services.VirtualUser:ClickButton2(Vector2.new())
	end
end)

Groupboxes.General_Self:AddDivider()
Groupboxes.General_Self:AddSlider("PromptReachSlider", {
	Text = "Prompt Reach Multiplier", Min = 1, Max = 2, Default = 1, Rounding = 1, Compact = true
})
Groupboxes.General_Self:AddToggle("InstantPrompts", {
	Text = "Instant Prompts", Default = false, Tooltip = "Allows you to trigger all prompts instantly."
})
Groupboxes.General_Self:AddToggle("PromptClip", {
	Text = "Prompt Clip", Default = false, Tooltip = "Allows you to interact with prompts through walls."
})

Options.PromptReachSlider:OnChanged(function(Value)
	for _, Prompt in Objects.Prompts do
		Prompt.MaxActivationDistance = Prompt:GetAttribute("MaxActivationDistance_Old") * Value
	end
end)
Toggles.InstantPrompts:OnChanged(function(Value)
	for _, Prompt in Objects.Prompts do
		Prompt.HoldDuration = Value and 0 or Prompt:GetAttribute("HoldDuration_Old")
	end
end)
Toggles.PromptClip:OnChanged(function(Value)
	for _, Prompt in Objects.Prompts do
		Prompt.RequiresLineOfSight = Value and false or Prompt:GetAttribute("RequiresLineOfSight_Old")
	end
end)

Groupboxes.Self_Automation = Tabs.General:AddRightGroupbox("Automation")
Groupboxes.Self_Automation:AddToggle("AutoBreakerBox", {
	Text = "Auto Breaker Box", Default = false, Tooltip = "Automatically solves the breaker box."
})
Groupboxes.Self_Automation:AddToggle("AutoSolveAnchors", {
	Text = "Auto Solve Anchors", Default = false,
	Tooltip = "Automatically enters the correct code into anchors when you are near them."
})
Toggles.AutoBreakerBox:OnChanged(function(Value)
	if Value and CurrentRooms:FindFirstChild("ElevatorBreaker", true) then
		if not Globals.BreakerBoxInteracted then
			if not Globals.BreakerBoxNotified then
				Functions.Notify({ Title = "Interact with the breaker box.", Body = "It will be automatically solved." })
				Globals.BreakerBoxInteracted = true
			end
		else
			RemotesFolder.EBF:FireServer()
		end
	end
end)

Groupboxes.Self_Automation:AddDivider()
Groupboxes.Self_Automation:AddToggle("AutoUnlockPadlockToggle", {
	Text = "Auto Unlock Padlock", Default = false, Tooltip = "Automatically enters the code into the library padlock."
})
Groupboxes.Self_Automation:AddSlider("AutoUnlockPadlockSlider", {
	Text = "Unlock Distance", Min = 1, Max = 50, Default = 10, Rounding = 0, Compact = true
})
Groupboxes.Self_Automation:AddToggle("AutoLibraryGuessCode", {
	Text = "Guess Library Code", Default = false,
	Tooltip = "Attempts to guess the library code, but collecting some books is also necessary."
})
Groupboxes.Self_Automation:AddDivider()
Groupboxes.Self_Automation:AddToggle("AutoInteractToggle", {
	Text = "Auto Interact", Default = false, Tooltip = "Automatically triggers nearby prompts."
})
Toggles.AutoInteractToggle:AddKeyPicker("AutoInteractKeybind", {
	Text = "Auto Interact", Default = "R",
	Mode = Library.IsMobile and "Toggle" or "Hold", SyncToggleState = true
})
Groupboxes.Self_Automation:AddDropdown("AutoInteractIgnoreList", {
	Text = "Ignore List",
	Values = { "Glitch Fragments", "Jeff Items", "Dropped Items", "Currency", "Minecarts", "Locks" },
	Default = { "Glitch Fragments", "Jeff Items", "Dropped Items" },
	Multi = true, AllowNull = true
})
Groupboxes.Self_Automation:AddDivider()
Groupboxes.Self_Automation:AddToggle("AutoClosetToggle", {
	Text = "Auto Closet", Default = false,
	Tooltip = "Automatically hides in a nearby closet when an entity is near."
})
Toggles.AutoClosetToggle:AddKeyPicker("AutoClosetKeybind", {
	Text = "Auto Closet", Default = "Q", Mode = "Toggle", SyncToggleState = true
})
Groupboxes.Self_Automation:AddDropdown("AutoClosetEntityList", {
	Text = "Ignore List",
	Values = { "Rush", "Ambush", "Blitz", "A-60", "A-120", "AR0xMBUSH", "RNIUSHCG==" },
	Multi = true, AllowNull = true
})

Groupboxes.Self_Misc = Tabs.General:AddRightGroupbox("Miscellaneous")
Groupboxes.Self_Misc:AddButton({
	Text = "Play Again", Tooltip = "Makes you join a new run, click again to cancel.", DoubleClick = true,
	Func = function() RemotesFolder.PlayAgain:FireServer() end
})
Groupboxes.Self_Misc:AddButton({
	Text = "Return to Lobby", Tooltip = "Makes you teleport back to the lobby.", DoubleClick = true,
	Func = function() RemotesFolder.Lobby:FireServer() end
})
Groupboxes.Self_Misc:AddButton({
	Text = "Revive",
	Tooltip = "Makes you revive, if you have a revive and haven't already revived in this run.",
	DoubleClick = true,
	Func = function() RemotesFolder.Revive:FireServer() end
})
Groupboxes.Self_Misc:AddButton({
	Text = "Reset Character",
	Tooltip = "Kills your character on the server. (takes around 20 seconds if replicatesignal isn't supported)",
	DoubleClick = true,
	Func = function()
		Globals.SelfKilled = true
		if Functions.CheckCompatability({"replicatesignal"}) then
			Abysall.Environment.replicatesignal(LocalPlayer.Kill)
		else
			if RemotesFolder:FindFirstChild("Underwater") then
				RemotesFolder.Underwater:FireServer(true)
			else
				Humanoid.Health = 0
			end
		end
	end
})

Groupboxes.Exploits_Bypass = Tabs.Exploits:AddLeftGroupbox("Bypass")
Groupboxes.Exploits_Bypass:AddToggle("BypassGiggle",         { Text = "Bypass Giggle",           Default = false, Tooltip = "Prevents 'Giggle' from attacking you." })
Groupboxes.Exploits_Bypass:AddToggle("BypassDupe",           { Text = "Bypass Dupe",             Default = false, Tooltip = "Prevents you from open 'Dupe' fake doors." })
Groupboxes.Exploits_Bypass:AddToggle("BypassEyes",           { Text = "Bypass Eyes",             Default = false, Tooltip = "Prevents 'Eyes' from hurting you." })
Groupboxes.Exploits_Bypass:AddToggle("BypassLookman",        { Text = "Bypass Lookman",          Default = false, Tooltip = "Prevents 'Lookman' from hurting you." })
Groupboxes.Exploits_Bypass:AddToggle("BypassGloombatEggs",   { Text = "Bypass Gloombat Eggs",    Default = false, Tooltip = "Prevents taking damage from stepping on 'Gloombat' eggs." })
Groupboxes.Exploits_Bypass:AddToggle("BypassSeekObstructions", { Text = "Bypass Seek Obstructions", Default = false, Tooltip = "Prevents obstacles in the 'Seek' chase from harming you." })
Groupboxes.Exploits_Bypass:AddToggle("BypassVacuum",         { Text = "Bypass Vacuum",           Default = false, Tooltip = "Prevents you from falling into 'Vacuum' fake doors." })
Groupboxes.Exploits_Bypass:AddToggle("BypassKillbricks",     { Text = "Bypass Killbricks",       Default = false, Tooltip = "Prevents 'Lava' from hurting you." })
Groupboxes.Exploits_Bypass:AddToggle("BypassSeekingWall",    { Text = "Bypass Seeking Wall",     Default = false, Tooltip = "Prevents 'ScaryWall' from hurting you." })
Groupboxes.Exploits_Bypass:AddToggle("BypassSnare",          { Text = "Bypass Snare",            Default = false, Tooltip = "Prevents 'Snare' from trapping you." })
Groupboxes.Exploits_Bypass:AddToggle("BypassBanana",         { Text = "Bypass Banana",           Default = false, Tooltip = "Prevents 'Banana Peel' from slipping you up (sometimes doesn't work)." })
Groupboxes.Exploits_Bypass:AddToggle("BypassJeff",           { Text = "Bypass Jeff",             Default = false, Tooltip = "Prevents 'Jeff the Killer' from stabbing you (sometimes doesn't work)." })

Toggles.BypassGiggle:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Object.Name == "GiggleCeiling" then
			Object:WaitForChild("Hitbox").CanTouch = not Value
		end
	end
end)
Toggles.BypassDupe:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Object.Name == "DoorFake" or Object.Name == "FakeDoor" then
			Object:WaitForChild("Hidden").CanTouch = not Value
			if Object:FindFirstChild("Lock") then
				Object.Lock.UnlockPrompt.Enabled = not Value
			end
		end
	end
end)
Toggles.BypassEyes:OnChanged(function(Value)
	if Value and Globals.IsEyes then
		if Floor == "Fools" or Floor == "OldHotel" then
			RemotesFolder.MotorReplication:FireServer(0, -75, 0, false)
		else
			RemotesFolder.MotorReplication:FireServer(-650)
		end
	end
end)
Toggles.BypassLookman:OnChanged(function(Value)
	if Value and Globals.IsLookman then
		if Floor == "Fools" or Floor == "OldHotel" then
			RemotesFolder.MotorReplication:FireServer(0, -75, 0, false)
		else
			RemotesFolder.MotorReplication:FireServer(-650)
		end
	end
end)
Toggles.BypassGloombatEggs:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		for _, Part in Object:GetDescendants() do
			if Part:IsA("BasePart") then
				Part.CanTouch = not Value
			end
		end
	end
end)
Toggles.BypassSeekObstructions:OnChanged(function(Value)
	for _, Object in Objects.SeekObstructions do
		Object.CanTouch = not Value
		if Object.Name == "SeekFloodline" then
			Object.CanCollide = Value
		end
	end
	for _, Object in Objects.SeekBridges do
		Object.CanCollide = Value
		Object.Transparency = Value and 0 or 1
	end
end)
Toggles.BypassVacuum:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Object.Name == "SideroomSpace" then
			Object:WaitForChild("Collision").CanCollide = Value
			Object:WaitForChild("Collision").CanTouch = not Value
		end
	end
end)
Toggles.BypassKillbricks:OnChanged(function(Value)
	for _, Object in Objects.Obstructions do
		if Object.Name == "Lava" then Object.CanTouch = not Value end
	end
end)
Toggles.BypassSeekingWall:OnChanged(function(Value)
	for _, Object in Objects.Obstructions do
		if Object.Name == "ScaryWall" then
			for _, Part in Object:GetDescendants() do
				if Part:IsA("BasePart") then
					Part.CanTouch = not Value
					Part.CanCollide = not Value
				end
			end
		end
	end
end)
Toggles.BypassSnare:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Object.Name == "Snare" and Object:FindFirstChild("Hitbox") then
			Object.Hitbox.CanTouch = not Value
		end
	end
end)
Toggles.BypassBanana:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Object.Name == "BananaPeel" then Object.CanTouch = not Value end
	end
end)
Toggles.BypassJeff:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Object.Name == "JeffTheKiller" then
			for _, Part in Object:GetDescendants() do
				if Part:IsA("BasePart") then
					Part.CanCollide = not Value
					Part.CanTouch = not Value
				end
			end
			Object:WaitForChild("Humanoid").Health = 0
		end
	end
end)

Groupboxes.Exploits_BypassRight = Tabs.Exploits:AddRightGroupbox("Bypass")
Groupboxes.Exploits_BypassRight:AddToggle("DisableAnticheat", {
	Text = "Disable Anticheat", Default = false,
	Tooltip = "Completely disables the anticheat, after interacting with a ladder."
})
Groupboxes.Exploits_BypassRight:AddToggle("VelocityManipulationToggle", {
	Text = "Velocity Manipulation", Default = false,
	Tooltip = "Moves your character forward slowly, mitigating the game's anti-noclip."
})
Toggles.DisableAnticheat:OnChanged(function(Value)
	if Globals.AnticheatDisabled == true and not Value then
		RemotesFolder.ClimbLadder:FireServer()
		Globals.AnticheatDisabled = false
	end
end)
Toggles.VelocityManipulationToggle:AddKeyPicker("VelocityManipulationKeybind", {
	Text = "Velocity Manipulation", Default = "V",
	Mode = Library.IsMobile and "Toggle" or "Hold", SyncToggleState = true
})

Groupboxes.Exploits_BypassRight:AddDivider()
Groupboxes.Exploits_BypassRight:AddToggle("InfiniteItemsToggle", {
	Text = "Infinite Items", Default = false,
	Tooltip = "Allows certain items to be used without draining their uses.",
	Disabled = not Functions.CheckCompatability({"fireproximityprompt"}),
	DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Exploits_BypassRight:AddDropdown("InfiniteItemsList", {
	Text = "Item List",
	Values = { "Lockpicks", "Skeleton Key", "Shears", "Multitool" },
	Multi = true, AllowNull = true,
	Disabled = not Functions.CheckCompatability({"fireproximityprompt"}),
	DisabledTooltip = Globals.IncompatibleMessage
})

Groupboxes.Exploits_BypassRight:AddDivider()
Groupboxes.Exploits_BypassRight:AddToggle("PositionSpoof", {
	Text = "Position Spoof", Default = false,
	Tooltip = "Makes your character appear underground on the server, protecting you from rush-like entities."
})
Groupboxes.Exploits_BypassRight:AddToggle("CrouchSpoof", {
	Text = "Crouch Spoof", Default = false, Tooltip = "Makes the game think you are always crouching."
})
Toggles.PositionSpoof:OnChanged(function(Value)
	if Floor ~= "Fools" and Floor ~= "OldHotel" then
		if Value then
			RootPart.CFrame = RootPart.CFrame * CFrame.new(0, -2.146, 0)
			Humanoid.HipHeight = 0.25
			RemotesFolder.Crouch:FireServer(true)
		else
			RootPart.CFrame = RootPart.CFrame * CFrame.new(0, 2.146, 0)
			Humanoid.HipHeight = 2.396
		end
	end
end)
Toggles.PositionSpoof:AddKeyPicker("PositionSpoof", {
	Text = "Position Spoof", Default = "B", Mode = "Toggle", SyncToggleState = true
})
Toggles.CrouchSpoof:OnChanged(function(Value)
	if RemotesFolder:FindFirstChild("Crouch") then
		RemotesFolder.Crouch:FireServer(Value and true or Functions.IsCrouching())
	end
end)

Groupboxes.Exploits_Remove = Tabs.Exploits:AddRightGroupbox("Remove")
Groupboxes.Exploits_Remove:AddToggle("RemoveScreech", { Text = "Remove Screech",  Default = false, Tooltip = "Prevents 'Screech' from spawning." })
Groupboxes.Exploits_Remove:AddToggle("RemoveHalt",    { Text = "Remove Halt",     Default = false, Tooltip = "Prevents 'Halt' from spawning." })
Groupboxes.Exploits_Remove:AddToggle("RemoveA90",     { Text = "Remove A-90",     Default = false, Tooltip = "Prevents 'A-90' from spawning." })
Groupboxes.Exploits_Remove:AddToggle("RemoveDread",   { Text = "Remove Dread",    Default = false, Tooltip = "Prevents 'Dread' from spawning." })
Groupboxes.Exploits_Remove:AddDivider()
Groupboxes.Exploits_Remove:AddToggle("NoScreechDamage", { Text = "No Screech Damage", Default = false, Tooltip = "Prevents 'Screech' from hurting you." })
Groupboxes.Exploits_Remove:AddToggle("NoHaltDamage",    { Text = "No Halt Damage",    Default = false, Tooltip = "Prevents 'Halt' from hurting you." })
Groupboxes.Exploits_Remove:AddToggle("NoA90Damage",     { Text = "No A-90 Damage",    Default = false, Tooltip = "Prevents 'A-90' from hurting you." })
Groupboxes.Exploits_Remove:AddToggle("NoSurgeDamage",   { Text = "No Surge Damage",   Default = false, Tooltip = "Prevents 'Surge' from hurting you." })

Toggles.NoScreechDamage:OnChanged(function(Value)
	if Value then
		FakeEvents.Screech.Parent = RemotesFolder
		FakeEvents.Screech_Real.Parent = nil
	else
		FakeEvents.Screech_Real.Parent = RemotesFolder
		FakeEvents.Screech.Parent = nil
	end
end)
Toggles.NoHaltDamage:OnChanged(function(Value)
	if Value then
		FakeEvents.Shade.Parent = RemotesFolder
		FakeEvents.Shade_Real.Parent = nil
	else
		FakeEvents.Shade_Real.Parent = RemotesFolder
		FakeEvents.Shade.Parent = nil
	end
end)
Toggles.NoA90Damage:OnChanged(function(Value)
	if RemotesFolder:FindFirstChild("A90") then
		if Value then
			FakeEvents.A90.Parent = RemotesFolder
			FakeEvents.A90_Real.Parent = nil
		else
			FakeEvents.A90_Real.Parent = RemotesFolder
			FakeEvents.A90.Parent = nil
		end
	end
end)
Toggles.NoSurgeDamage:OnChanged(function(Value)
	if RemotesFolder:FindFirstChild("SurgeRemote") then
		if Value then
			FakeEvents.Surge.Parent = RemotesFolder
			FakeEvents.Surge_Real.Parent = nil
		else
			FakeEvents.Surge_Real.Parent = RemotesFolder
			FakeEvents.Surge.Parent = nil
		end
	end
end)

local Modules = {}

Toggles.RemoveScreech:OnChanged(function(Value)
	Modules.Screech.Name = Value and "Screech_Disabled" or "Screech"
	if Modules.GlitchScreech then
		Modules.GlitchScreech.Name = Value and "GlitchScreech_Disabled" or "GlitchScreech"
	end
end)
Toggles.RemoveHalt:OnChanged(function(Value)
	Modules.Shade.Name = Value and "Shade_Disabled" or "Shade"
end)
Toggles.RemoveA90:OnChanged(function(Value)
	if Modules.A90 then
		Modules.A90.Name = Value and "A90_Disabled" or "A90"
	end
end)
Toggles.RemoveDread:OnChanged(function(Value)
	if Modules.Dread then
		Modules.Dread.Name = Value and "Dread_Disabled" or "Dread"
	end
end)

Groupboxes.Exploits_Audio = Tabs.Exploits:AddLeftGroupbox("Audio")
Globals.JamMuffle = Services.SoundService:WaitForChild("Main"):FindFirstChild("Jamming") or Instance.new("EqualizerSoundEffect")

Groupboxes.Exploits_Audio:AddToggle("RemoveFootstepSounds",    { Text = "Remove Footstep Sounds",    Default = false, Tooltip = "Removes the sounds when walking." })
Groupboxes.Exploits_Audio:AddToggle("RemoveJamminMusic",       { Text = "Remove Jammin Music",       Default = false, Tooltip = "Removes the music and muffle effect from the 'Jammin' modifier." })
Groupboxes.Exploits_Audio:AddToggle("RemoveInteractingSounds", { Text = "Remove Interacting Sounds", Default = false, Tooltip = "Removes the sounds when interacting with proximity prompts." })

Toggles.RemoveJamminMusic:OnChanged(function(Value)
	local Jam = Globals.MainUI.Initiator.Main_Game.Health:FindFirstChild("Jam")
	if Jam then
		Jam.Volume = Value and 0 or 0.45
		Globals.JamMuffle.Enabled = LiveModifiers:FindFirstChild("Jammin") and not Value or false
	end
end)
Toggles.RemoveInteractingSounds:OnChanged(function(Value)
	local PS = Globals.MainUI.Initiator.Main_Game.PromptService
	PS.Triggered.Volume   = Value and 0 or 0.04
	PS.Holding.Volume     = Value and 0 or 0.1
	PS.Notification.Volume = Value and 0 or 0.03
	Globals.MainUI.Initiator.Main_Game.Reminder.Caption.Volume = Value and 0 or 0.1
end)

Groupboxes.Visuals_LeftTab = Tabs.Visuals:AddLeftTabbox("Camera / Effects")
Groupboxes.Visuals_Camera = Groupboxes.Visuals_LeftTab:AddTab("Camera")
Groupboxes.Visuals_Camera:AddToggle("AmbientToggle", { Text = "Ambient", Default = false, Tooltip = "Changes the lighting color to the specified value." })
Groupboxes.Visuals_Camera:AddSlider("FieldOfView", { Text = "Field of View", Min = 1, Max = 120, Default = 70, Rounding = 0 })
Groupboxes.Visuals_Camera:AddDivider()
Groupboxes.Visuals_Camera:AddToggle("RemoveCameraShake", {
	Text = "Remove Camera Shake", Default = false, Tooltip = "Prevents the camera from shaking.",
	Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Visuals_Camera:AddToggle("RemoveCameraBobbing", {
	Text = "Remove Camera Bobbing", Default = false, Tooltip = "Prevents the camera from bobbing when moving.",
	Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Visuals_Camera:AddToggle("RemoveCameraFog", { Text = "Remove Camera Fog", Default = false, Tooltip = "Removes all fog effects from the camera." })
Groupboxes.Visuals_Camera:AddDivider()
Groupboxes.Visuals_Camera:AddToggle("ThirdPersonToggle", { Text = "Third Person", Default = false, Tooltip = "Zooms out your camera, allowing you to see your character from behind." })
Toggles.ThirdPersonToggle:AddKeyPicker("ThirdPersonKeybind", { Text = "Third Person", Default = "T", Mode = "Toggle", SyncToggleState = true })
Groupboxes.Visuals_Camera:AddSlider("ThirdPersonOffsetX", { Text = "X Offset", Min = -10, Max = 10, Default = 1.5, Rounding = 1, Compact = true })
Groupboxes.Visuals_Camera:AddSlider("ThirdPersonOffsetY", { Text = "Y Offset", Min = -10, Max = 10, Default = 1,   Rounding = 1, Compact = true })
Groupboxes.Visuals_Camera:AddSlider("ThirdPersonOffsetZ", { Text = "Z Offset", Min = -10, Max = 10, Default = 5,   Rounding = 1, Compact = true })
Groupboxes.Visuals_Camera:AddToggle("ThirdPersonWallCheck", { Text = "Wall Check", Default = false, Tooltip = "Prevents third person from going through walls." })
Groupboxes.Visuals_Camera:AddDivider()
Groupboxes.Visuals_Camera:AddToggle("ViewmodelOffsetToggle", {
	Text = "Viewmodel Offset", Default = false, Tooltip = "Changes the offset of your viewmodel while holding an item.",
	Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Visuals_Camera:AddSlider("ViewmodelOffsetX", { Text = "X Offset", Min = -10, Max = 10, Default = 0, Rounding = 1, Compact = true, Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage })
Groupboxes.Visuals_Camera:AddSlider("ViewmodelOffsetY", { Text = "Y Offset", Min = -10, Max = 10, Default = 0, Rounding = 1, Compact = true, Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage })
Groupboxes.Visuals_Camera:AddSlider("ViewmodelOffsetZ", { Text = "Z Offset", Min = -10, Max = 10, Default = 0, Rounding = 1, Compact = true, Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage })

Toggles.AmbientToggle:AddColorPicker("AmbientColor", { Text = "Ambient", Default = Color3.fromRGB(255, 255, 255), Transparency = 0 })
Toggles.AmbientToggle:OnChanged(function(Value)
	local OldAmbient = CurrentRooms:FindFirstChild(tostring(LocalPlayer:GetAttribute("CurrentRoom"))):GetAttribute("Ambient")
	Services.TweenService:Create(Services.Lighting, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
		Ambient = Value and Options.AmbientColor.Value or OldAmbient
	}):Play()
end)

local Main_Game
local ClientModules

Toggles.RemoveCameraBobbing:OnChanged(function(Value)
	if Main_Game then Main_Game.spring.Speed = Value and 9e9 or 8 end
end)
Toggles.RemoveCameraFog:OnChanged(function(Value)
	Services.Lighting.FogEnd = Value and 10000000 or Globals.OldFog
	for _, Object in Globals.FogInstances do
		Object.Density = Value and 0 or Object:GetAttribute("Density_Old")
	end
end)

Groupboxes.Visuals_Effects = Groupboxes.Visuals_LeftTab:AddTab("Effects")
Groupboxes.Visuals_Effects:AddToggle("TransparentHidingSpotsToggle", { Text = "Transparent Hiding Spots", Default = false, Tooltip = "Makes a hiding spot transparent when you enter it." })
Groupboxes.Visuals_Effects:AddSlider("TransparentHidingSpotsSlider", { Text = "Transparency", Min = 0, Max = 1, Default = 0.5, Rounding = 2, Compact = true })

local function ApplyHidingTransparency(Value, SliderValue)
	for _, Object in Objects.HidingSpots do
		local IsHiding = false
		for _, Child in Object:GetDescendants() do
			if Child.Name == "HiddenPlayer" and Child.Value == Character then
				IsHiding = true
				break
			end
		end
		for _, Part in Object:GetDescendants() do
			if Part:IsA("BasePart") and Part:GetAttribute("Transparency_Old") then
				Services.TweenService:Create(Part, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
					Transparency = (Value and IsHiding) and SliderValue or Part:GetAttribute("Transparency_Old")
				}):Play()
			end
		end
	end
end

Toggles.TransparentHidingSpotsToggle:OnChanged(function(Value)
	ApplyHidingTransparency(Value, Options.TransparentHidingSpotsSlider.Value)
end)
Options.TransparentHidingSpotsSlider:OnChanged(function(Value)
	ApplyHidingTransparency(Toggles.TransparentHidingSpotsToggle.Value, Value)
end)

Groupboxes.Visuals_Effects:AddDivider()
Groupboxes.Visuals_Effects:AddToggle("DisableGlitchJumpscare",   { Text = "Disable Glitch Jumpscare",   Default = false, Tooltip = "Disables the jumpscare from 'Glitch'" })
Groupboxes.Visuals_Effects:AddToggle("DisableTimothyJumpscare",  { Text = "Disable Timothy Jumpscare",  Default = false, Tooltip = "Disables the jumpscare from 'Timothy'" })
Groupboxes.Visuals_Effects:AddToggle("DisableVoidJumpscare",     { Text = "Disable Void Jumpscare",     Default = false, Tooltip = "Disables the jumpscare from 'Void'", Risky = Floor == "OldHotel" })
Groupboxes.Visuals_Effects:AddDivider()
Groupboxes.Visuals_Effects:AddToggle("DisableHideVignette",      { Text = "Disable Hide Vignette",      Default = false, Tooltip = "Disables the hiding screen effect." })
Groupboxes.Visuals_Effects:AddToggle("DisableFiredampEffect",    { Text = "Disable Firedamp Effect",    Default = false, Tooltip = "Disabled the firedamp screen effect." })
Groupboxes.Visuals_Effects:AddToggle("DisableEntityJumpscares",  { Text = "Disable Entity Jumpscares",  Default = false, Tooltip = "Disables jumpscares from entities like Rush and Ambush." })

Toggles.DisableGlitchJumpscare:OnChanged(function(Value)
	Modules.Glitch.Name = Value and "Glitch_Disabled" or "Glitch"
end)
Toggles.DisableTimothyJumpscare:OnChanged(function(Value)
	Modules.SpiderJumpscare.Name = Value and "SpiderJumpscare_Disabled" or "SpiderJumpscare"
end)
Toggles.DisableVoidJumpscare:OnChanged(function(Value)
	if Modules.Void then Modules.Void.Name = Value and "Void_Disabled" or "Void" end
end)
Toggles.DisableHideVignette:OnChanged(function(Value)
	local Vignette = Globals.MainUI:FindFirstChild("HideVignette") or Globals.MainUI.MainFrame:FindFirstChild("HideVignette")
	if Vignette then Vignette.Image = Value and "Disabled" or "rbxassetid://6100076320" end
end)
Toggles.DisableFiredampEffect:OnChanged(function(Value)
	for _, Object in CurrentRooms:GetChildren() do
		if Value then
			Object:SetAttribute("Firedamp", false)
			for _, FiredampObj in Camera:GetChildren() do
				if FiredampObj.Name == "LiveFiredamp" then FiredampObj:Destroy() end
			end
		else
			Object:SetAttribute("Firedamp", Object:GetAttribute("Firedamp_Old"))
		end
	end
	local Old = LocalPlayer:GetAttribute("CurrentRoom")
	LocalPlayer:SetAttribute("CurrentRoom", 0)
	task.wait()
	LocalPlayer:SetAttribute("CurrentRoom", Old)
end)
Toggles.DisableEntityJumpscares:OnChanged(function(Value)
	local Jumpscares = Globals.MainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Jumpscares")
		or Globals.MainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Jumpscares_Disabled")
	if Jumpscares then
		Jumpscares.Name = Value and "Jumpscares_Disabled" or "Jumpscares"
		for _, Object in Objects.JumpscareModules do
			Object.Name = Value and (Object:GetAttribute("OriginalName") .. "_Disabled") or Object:GetAttribute("OriginalName")
		end
	end
end)

Groupboxes.Visuals_RightTab     = Tabs.Visuals:AddRightTabbox("Entities / Settings")
Groupboxes.Visuals_Entities     = Groupboxes.Visuals_RightTab:AddTab("Entities")
Groupboxes.Visuals_EntitySettings = Groupboxes.Visuals_RightTab:AddTab("Settings")

Groupboxes.Visuals_Entities:AddDropdown("EntityList", {
	Text = "Entity List",
	Values = { "Rush","Ambush","Eyes","Halt","Blitz","Lookman","Gloombat Swarm","A-60","A-120","Sally","Jeff the Killer","Groundskeeper","Monument","AR0xMBUSH","RNIUSHCG==" },
	Multi = true, AllowNull = true
})
Groupboxes.Visuals_Entities:AddToggle("NotifyEntities",    { Text = "Notify Entities",    Default = false, Tooltip = "Sends a notification when an entity spawns." })
Groupboxes.Visuals_Entities:AddDivider()
Groupboxes.Visuals_Entities:AddToggle("NotifyLibraryCode", { Text = "Notify Library Code", Default = false, Tooltip = "Automatically solves the code for the library padlock." })
Groupboxes.Visuals_Entities:AddToggle("NotifyOxygen",      { Text = "Notify Oxygen Level", Default = false, Tooltip = "Shows how much oxygen you have remaining." })
Groupboxes.Visuals_Entities:AddToggle("NotifyHasteTime",   { Text = "Notify Haste Time",   Default = false, Tooltip = "Shows how much time you have remaining before 'Haste' spawns." })

Globals.LibraryCodeFound = false
Toggles.NotifyLibraryCode:OnChanged(function(Value)
	if Value then
		local Code = Functions.GetLibraryCode()
		if Code and not Code:find("_") and not Globals.LibraryCodeFound and CurrentRooms:FindFirstChild("50") then
			local Lock = Services.Workspace:FindFirstChild("Padlock", true)
			Functions.Notify({ Title = "Padlock code found!", Body = "The code is: '" .. Code .. "'", Time = Toggles.NotifyKeepNotifications.Value and Lock or 15 })
			Globals.LibraryCodeFound = true
		end
	end
end)

Groupboxes.Visuals_EntitySettings:AddToggle("EntityChatToggle", { Text = "Chat Message", Default = false, Tooltip = "Sends a message in the chat when an entity spawns." })
Groupboxes.Visuals_EntitySettings:AddInput("EntityChatMessage", { Text = "Message", Default = "spawned!", Numeric = false, Placeholder = "Message" })
Groupboxes.Visuals_EntitySettings:AddDivider()
Groupboxes.Visuals_EntitySettings:AddDropdown("NotifyStyle", { Text = "Notify Style", Values = { "Abysall", "Doors", "Library" }, Default = 1 })
Groupboxes.Visuals_EntitySettings:AddSlider("NotifySoundVolume", { Text = "Sound Volume", Min = 0, Max = 10, Default = 3, Rounding = 1 })
Groupboxes.Visuals_EntitySettings:AddToggle("NotifyPlaySound", { Text = "Play Sound", Default = true, Tooltip = "Makes notifications play an alert sound." })
Groupboxes.Visuals_EntitySettings:AddToggle("NotifyKeepNotifications", { Text = "Keep Notifications", Default = false, Tooltip = "Certain notifications will stay on screen until they are no longer needed." })

Groupboxes.Visuals_ESP          = Tabs.Visuals:AddRightTabbox("ESP/Settings")
Groupboxes.Visuals_ESP_Toggles  = Groupboxes.Visuals_ESP:AddTab("ESP")
Groupboxes.Visuals_ESP_Settings = Groupboxes.Visuals_ESP:AddTab("Settings")

local function MakeESPToggle(ToggleKey, ColorKey, Text, Tooltip, ObjectsTable, LabelFunc, RoomBased)
	Groupboxes.Visuals_ESP_Toggles:AddToggle(ToggleKey, { Text = Text, Default = false, Tooltip = Tooltip })
	Toggles[ToggleKey]:AddColorPicker(ColorKey, { Text = Text, Default = Options[ColorKey] and Options[ColorKey].Value or Color3.new(1,1,1), Transparency = 0 })
	Toggles[ToggleKey]:OnChanged(function(Value)
		for _, Object in ObjectsTable do
			if Value then
				local Label, UseRoom = LabelFunc(Object)
				if Label then
					Functions.AddESP({ Object = Object, Text = Label, Color = Options[ColorKey].Value }, UseRoom ~= nil and UseRoom or RoomBased)
				end
			else
				Functions.RemoveESP(Object)
			end
		end
	end)
	Options[ColorKey]:OnChanged(function(Value)
		for _, Object in ObjectsTable do
			Abysall.ESPLibrary:UpdateObjectColor(Object, Value)
		end
	end)
end

Groupboxes.Visuals_ESP_Toggles:AddToggle("ObjectiveESPToggle", { Text = "Objectives", Default = false, Tooltip = "Highlights all objects required to progress." })
Toggles.ObjectiveESPToggle:AddColorPicker("ObjectiveESPColor", { Text = "Objectives", Default = Color3.fromRGB(0, 255, 0), Transparency = 0 })

local ObjectiveLabels = {
	["KeyObtain"]              = "Door Key",
	["ElectricalKeyObtain"]    = "Electrical Key",
	["MinesGenerator"]         = "Generator",
	["FuseObtain"]             = "Generator Fuse",
	["LiveHintBook"]           = "Hint Book",
	["LiveBreakerPolePickup"]  = "Fuse Breaker",
	["LibraryHintPaper"]       = "Hint Paper",
	["PickupItem"]             = "Hint Paper",
	["CringlePresent"]         = "Present",
	["LeverForGate"]           = "Gate Lever",
	["MinesGateButton"]        = "Gate Button",
	["GardenGateButton"]       = "Gate Button",
}

Toggles.ObjectiveESPToggle:OnChanged(function(Value)
	for _, Object in Objects.Objectives do
		if Value then
			local Label = ObjectiveLabels[Object.Name]
			if Object.Name == "TimerLever" then
				Label = "Time Lever [+" .. Object:GetAttribute("AddTime") .. "s]"
			elseif Object.Name == "MinesAnchor" then
				Label = "Anchor [" .. Object:WaitForChild("Sign").TextLabel.Text .. "]"
			elseif Object.Name == "WaterPump" then
				Functions.AddESP({ Object = Object.Wheel, Text = "Water Pump", Color = Options.ObjectiveESPColor.Value }, true)
			elseif Object.Name == "VineGuillotine" then
				Functions.AddESP({ Object = Object.Lever, Text = "Vine Lever", Color = Options.ObjectiveESPColor.Value }, true)
			end
			if Label then
				Functions.AddESP({ Object = Object, Text = Label, Color = Options.ObjectiveESPColor.Value }, true)
			end
		else
			Functions.RemoveESP(Object)
		end
	end
end)
Options.ObjectiveESPColor:OnChanged(function(Value)
	for _, Object in Objects.Objectives do
		Abysall.ESPLibrary:UpdateObjectColor(Object, Value)
	end
end)

Groupboxes.Visuals_ESP_Toggles:AddToggle("DoorESPToggle",       { Text = "Doors",        Default = false, Tooltip = "Highlights the next door." })
Groupboxes.Visuals_ESP_Toggles:AddToggle("HidingSpotESPToggle", { Text = "Hiding Spots", Default = false, Tooltip = "Highlights places where you can hide from entities" })
Groupboxes.Visuals_ESP_Toggles:AddToggle("PlayerESPToggle",     { Text = "Players",      Default = false, Tooltip = "Highlights other players." })
Groupboxes.Visuals_ESP_Toggles:AddToggle("ChestESPToggle",      { Text = "Chests",       Default = false, Tooltip = "Highlights objects that can contain loot." })
Groupboxes.Visuals_ESP_Toggles:AddToggle("ItemESPToggle",       { Text = "Items",        Default = false, Tooltip = "Highlights all collectable items/consumables." })
Groupboxes.Visuals_ESP_Toggles:AddToggle("CurrencyESPToggle",   { Text = "Currency",     Default = false, Tooltip = "Highlights all currency that spawns." })
Groupboxes.Visuals_ESP_Toggles:AddToggle("EntityESPToggle",     { Text = "Entities",     Default = false, Tooltip = "Highlights all entities that spawn." })
Groupboxes.Visuals_ESP_Toggles:AddToggle("LadderESPToggle",     { Text = "Ladders",      Default = false, Tooltip = "Highlights ladders that can be used to disable the anticheat." })

Toggles.DoorESPToggle:AddColorPicker("DoorESPColor",           { Text = "Doors",        Default = Color3.fromRGB(0, 200, 255),  Transparency = 0 })
Toggles.HidingSpotESPToggle:AddColorPicker("HidingSpotESPColor", { Text = "Hiding Spots", Default = Color3.fromRGB(255, 170, 0),  Transparency = 0 })
Toggles.PlayerESPToggle:AddColorPicker("PlayerESPColor",       { Text = "Players",      Default = Color3.fromRGB(255, 255, 255), Transparency = 0 })
Toggles.ChestESPToggle:AddColorPicker("ChestESPColor",         { Text = "Chests",       Default = Color3.fromRGB(255, 255, 0),   Transparency = 0 })
Toggles.ItemESPToggle:AddColorPicker("ItemESPColor",           { Text = "Items",        Default = Color3.fromRGB(170, 0, 255),   Transparency = 0 })
Toggles.CurrencyESPToggle:AddColorPicker("CurrencyESPColor",   { Text = "Currency",     Default = Color3.fromRGB(255, 255, 0),   Transparency = 0 })
Toggles.EntityESPToggle:AddColorPicker("EntityESPColor",       { Text = "Entities",     Default = Color3.fromRGB(255, 0, 0),     Transparency = 0 })
Toggles.LadderESPToggle:AddColorPicker("LadderESPColor",       { Text = "Ladders",      Default = Color3.fromRGB(255, 255, 255), Transparency = 0 })

local HidingSpotLabels = {
	Wardrobe = "Closet", ["Backdoor_Wardrobe"] = "Closet", Toolshed = "Closet",
	RetroWardrobe = "Closet", ["Wardrobe-FOOLS26"] = "Closet",
	Locker_Large = "Locker", Rooms_Locker = "Locker", Rooms_Locker_Fridge = "Locker",
	Bed = "Bed", Double_Bed = "Double Bed", CircularVent = "Vent", Dumpster = "Dumpster"
}
local ChestLabels = {
	ChestBox = true, ChestBoxLocked = true, Toolbox = true, Toolbox_Locked = true,
	Chest_Vine = "Vine Chest", Toolshed_Small = "Toolshed", Locker_Small_Locked = "Locked Item Locker", MouseHole = "Mouse"
}
local EntityESPLabels = {
	KeyObtainFake = "Fake Key", JeffTheKiller = "Jeff the Killer", GiggleCeiling = "Giggle",
	GloomPile = "Gloombat Eggs", Snare = "Snare", GrumbleRig = "Grumble",
	Drakobloxxer = "Drakobloxxer", Hole = "Mandrake Hole", Groundskeeper = "Groundskeeper",
	LiveEntityBramble = "Bramble", Figure = "Figure", FigureRig = "Figure", FigureRagdoll = "Figure"
}

Toggles.DoorESPToggle:OnChanged(function(Value)
	for _, Object in Objects.Doors do
		if Value then Functions.AddESP({ Object = Object, Text = "Door", Color = Options.DoorESPColor.Value }, true)
		else Functions.RemoveESP(Object) end
	end
end)
Options.DoorESPColor:OnChanged(function(Value)
	for _, Object in Objects.Doors do Abysall.ESPLibrary:UpdateObjectColor(Object, Value) end
end)

Toggles.HidingSpotESPToggle:OnChanged(function(Value)
	for _, Object in Objects.HidingSpots do
		local Label = HidingSpotLabels[Object.Name]
		if Value and Label then Functions.AddESP({ Object = Object, Text = Label, Color = Options.HidingSpotESPColor.Value }, true)
		elseif not Value then Functions.RemoveESP(Object) end
	end
end)
Options.HidingSpotESPColor:OnChanged(function(Value)
	for _, Object in Objects.HidingSpots do Abysall.ESPLibrary:UpdateObjectColor(Object, Value) end
end)

Toggles.PlayerESPToggle:OnChanged(function(Value)
	task.wait()
	for _, Player in Services.Players:GetPlayers() do
		if Player.Character and Player ~= LocalPlayer then
			if Value and Player:GetAttribute("Alive") == true then
				Functions.AddESP({ Object = Player.Character, Text = Player.Name, Color = Options.PlayerESPColor.Value })
			else
				Functions.RemoveESP(Player.Character)
			end
		end
	end
end)
Options.PlayerESPColor:OnChanged(function(Value)
	for _, Player in Services.Players:GetPlayers() do
		if Player.Character and Player ~= LocalPlayer then
			Abysall.ESPLibrary:UpdateObjectColor(Player.Character, Value)
		end
	end
end)

Toggles.ChestESPToggle:OnChanged(function(Value)
	for _, Object in Objects.Chests do
		if Value then
			local Label
			if Object.Name == "ChestBox" or Object.Name == "ChestBoxLocked" then
				Label = Object:GetAttribute("Locked") and "Locked Chest" or "Chest"
			elseif Object.Name == "Toolbox" or Object.Name == "Toolbox_Locked" then
				Label = Object:GetAttribute("Locked") and "Locked Toolbox" or "Toolbox"
			elseif ChestLabels[Object.Name] and ChestLabels[Object.Name] ~= true then
				Label = ChestLabels[Object.Name]
			end
			if Label then Functions.AddESP({ Object = Object, Text = Label, Color = Options.ChestESPColor.Value }, true) end
		else
			Functions.RemoveESP(Object)
		end
	end
end)
Options.ChestESPColor:OnChanged(function(Value)
	for _, Object in Objects.Chests do Abysall.ESPLibrary:UpdateObjectColor(Object, Value) end
end)

Toggles.ItemESPToggle:OnChanged(function(Value)
	for _, Object in Objects.Items do
		if Value then
			local Label = ItemNames[Object.Name] or (Object.Name == "Green_Herb" and "Green Herb")
			if Label then
				Functions.AddESP({ Object = Object, Text = Label, Color = Options.ItemESPColor.Value }, Object:GetAttribute("ParentRoom") ~= nil)
			end
		else
			Functions.RemoveESP(Object)
		end
	end
end)
Options.ItemESPColor:OnChanged(function(Value)
	for _, Object in Objects.Items do Abysall.ESPLibrary:UpdateObjectColor(Object, Value) end
end)

Toggles.CurrencyESPToggle:OnChanged(function(Value)
	for _, Object in Objects.Currency do
		if Value then
			local Label
			if Object.Name == "GoldPile" and Object:GetAttribute("GoldValue") then
				Label = "Gold Pile [" .. Object:GetAttribute("GoldValue") .. "]"
			elseif Object.Name == "StardustPickup" then
				Label = "Stardust Pile"
			end
			if Label then Functions.AddESP({ Object = Object, Text = Label, Color = Options.CurrencyESPColor.Value }, true) end
		else
			Functions.RemoveESP(Object)
		end
	end
end)
Options.CurrencyESPColor:OnChanged(function(Value)
	for _, Object in Objects.Currency do Abysall.ESPLibrary:UpdateObjectColor(Object, Value) end
end)

Toggles.EntityESPToggle:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Value then
			local Label = EntityESPLabels[Object.Name]
			if not Label and Entities[Object.Name] then Label = Entities[Object.Name].Alias end
			if Label then
				Functions.AddESP({ Object = Object, Text = Label, Color = Options.EntityESPColor.Value }, true)
			end
		else
			Functions.RemoveESP(Object)
		end
	end
end)
Options.EntityESPColor:OnChanged(function(Value)
	for _, Object in Objects.Entities do Abysall.ESPLibrary:UpdateObjectColor(Object, Value) end
end)

Toggles.LadderESPToggle:OnChanged(function(Value)
	for _, Object in Objects.Ladders do
		if Value then Functions.AddESP({ Object = Object, Text = "Ladder", Color = Options.LadderESPColor.Value }, true)
		else Functions.RemoveESP(Object) end
	end
end)
Options.LadderESPColor:OnChanged(function(Value)
	for _, Object in Objects.Ladders do Abysall.ESPLibrary:UpdateObjectColor(Object, Value) end
end)

Groupboxes.Visuals_ESP_Settings:AddToggle("ESPRainbow",     { Text = "Rainbow Effect", Default = false, Tooltip = "Makes the esp objects change colour like a rainbow." })
Groupboxes.Visuals_ESP_Settings:AddToggle("ESPShowDistance",{ Text = "Show Distance",  Default = true,  Tooltip = "Shows how far away your character is from the object." })
Groupboxes.Visuals_ESP_Settings:AddDivider()
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPFillTransparency",        { Text = "Fill Transparency",         Min = 0, Max = 1, Default = 0.75, Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPOutlineTransparency",     { Text = "Outline Transparency",      Min = 0, Max = 1, Default = 0,    Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTextTransparency",        { Text = "Text Transparency",         Min = 0, Max = 1, Default = 0,    Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTextOutlineTransparency", { Text = "Text Outline Transparency", Min = 0, Max = 1, Default = 0,    Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPFadeTime",                { Text = "Fade Time",                 Min = 0, Max = 1, Default = 0.25, Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPRenderLimit",             { Text = "Render Limit",              Min = 30, Max = 240, Default = 240, Rounding = 0, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTextSize",                { Text = "Text Size",                 Min = 12, Max = 24, Default = 18, Rounding = 0, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddDropdown("ESPTextFont", {
	Text = "Text Font",
	Values = { "Legacy","Arial","ArialBold","SourceSans","SourceSansBold","SourceSansLight","SourceSansItalic","Bodoni","Garamond","Cartoon","Code","Highway","SciFi","Arcade","Fantasy","Antique","SourceSansSemibold","Gotham","GothamMedium","GothamBold","GothamBlack","AmaticSC","Bangers","Creepster","DenkOne","Fondamento","FredokaOne","GrenzeGotisch","IndieFlower","JosefinSans","Jura","Kalam","LuckiestGuy","Merriweather","Michroma","Nunito","Oswald","PatrickHand","PermanentMarker","Roboto","RobotoCondensed","RobotoMono","Sarpanch","SpecialElite","TitilliumWeb","Ubuntu","BuilderSans","BuilderSansMedium","BuilderSansBold","BuilderSansExtraBold","Arimo","ArimoBold" },
	Default = 41
})
Groupboxes.Visuals_ESP_Settings:AddDivider()
Groupboxes.Visuals_ESP_Settings:AddDropdown("ESPTracersOrigin",  { Text = "Tracer Origin", Values = { "Bottom","Center","Top","Mouse" }, Default = 1 })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTracerThickness",  { Text = "Tracer Thickness", Min = 0.5, Max = 2, Default = 0.75, Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddToggle("ESPTracersToggle",    { Text = "Enable Tracers", Default = false, Tooltip = "Draws a line to highlighted objects." })
Groupboxes.Visuals_ESP_Settings:AddDivider()
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPArrowsRadius",     { Text = "Arrow Radius", Min = 100, Max = 500, Default = 250, Rounding = 0, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddToggle("ESPArrowsToggle",     { Text = "Enable Arrows", Default = false, Tooltip = "Shows arrow that point to off-screen objects." })

Abysall.ESPLibrary:SetRainbow(false)
Abysall.ESPLibrary:SetShowDistance(true)
Abysall.ESPLibrary:SetFillTransparency(0.75)
Abysall.ESPLibrary:SetOutlineTransparency(0)
Abysall.ESPLibrary:SetTextTransparency(0)
Abysall.ESPLibrary:SetTextOutlineTransparency(0)
Abysall.ESPLibrary:SetRenderLimit(240)
Abysall.ESPLibrary:SetFadeTime(0.25)
Abysall.ESPLibrary:SetTextSize(18)
Abysall.ESPLibrary:SetFont(Enum.Font.RobotoCondensed)
Abysall.ESPLibrary:SetTracers(false)
Abysall.ESPLibrary:SetTracerSize(0.75)
Abysall.ESPLibrary:SetTracerOrigin("Bottom")
Abysall.ESPLibrary:SetArrows(false)
Abysall.ESPLibrary:SetArrowRadius(250)
Abysall.ESPLibrary:SetDistanceSizeRatio(0.8)

Toggles.ESPRainbow:OnChanged(function(V)        Abysall.ESPLibrary:SetRainbow(V) end)
Toggles.ESPShowDistance:OnChanged(function(V)   Abysall.ESPLibrary:SetShowDistance(V) end)
Options.ESPFillTransparency:OnChanged(function(V)        Abysall.ESPLibrary:SetFillTransparency(V) end)
Options.ESPOutlineTransparency:OnChanged(function(V)     Abysall.ESPLibrary:SetOutlineTransparency(V) end)
Options.ESPTextTransparency:OnChanged(function(V)        Abysall.ESPLibrary:SetTextTransparency(V) end)
Options.ESPTextOutlineTransparency:OnChanged(function(V) Abysall.ESPLibrary:SetTextOutlineTransparency(V) end)
Options.ESPFadeTime:OnChanged(function(V)        Abysall.ESPLibrary:SetFadeTime(V) end)
Options.ESPRenderLimit:OnChanged(function(V)     Abysall.ESPLibrary:SetRenderLimit(V) end)
Options.ESPTextSize:OnChanged(function(V)        Abysall.ESPLibrary:SetTextSize(V) end)
Options.ESPTextFont:OnChanged(function(V)        Abysall.ESPLibrary:SetFont(Enum.Font[V]) end)
Toggles.ESPTracersToggle:OnChanged(function(V)   Abysall.ESPLibrary:SetTracers(V) end)
Options.ESPTracersOrigin:OnChanged(function(V)   Abysall.ESPLibrary:SetTracerOrigin(V) end)
Options.ESPTracerThickness:OnChanged(function(V) Abysall.ESPLibrary:SetTracerSize(V) end)
Toggles.ESPArrowsToggle:OnChanged(function(V)    Abysall.ESPLibrary:SetArrows(V) end)
Options.ESPArrowsRadius:OnChanged(function(V)    Abysall.ESPLibrary:SetArrowRadius(V) end)

Tabs.Floors:UpdateWarningBox({
	Visible = true,
	Title = "Compatability Warning",
	Text = "Features highlighted in red do not work in the current floor.",
})

Groupboxes.Floors_Automation = Tabs.Floors:AddRightGroupbox("Automation")
Groupboxes.Floors_Automation:AddToggle("AutoSteerMinecart", {
	Text = "Auto Steer Minecart", Default = false, Tooltip = "Automatically completes the minecart chase.",
	Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Floors_Automation:AddSlider("AutoSteerMinecartTurnDistance", {
	Text = "Turn Distance", Min = 20, Max = 50, Default = 35, Rounding = 0,
	Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Floors_Automation:AddSlider("AutoSteerMinecartDuckDistance", {
	Text = "Crouch Distance", Min = 20, Max = 50, Default = 35, Rounding = 0,
	Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Floors_Automation:AddDivider()
Groupboxes.Floors_Automation:AddToggle("RoomsAutoWalk",             { Text = "Auto Rooms",       Default = false, Tooltip = "Automatically moves and hides from entities in The Rooms." })
Groupboxes.Floors_Automation:AddSlider("RoomsAutoWalkPathfindTimeout", { Text = "Pathfind Timeout", Min = 0.5, Max = 3, Default = 1, Rounding = 1 })
Groupboxes.Floors_Automation:AddToggle("RoomsAutoWalkIgnoreA60",    { Text = "Ignore A-60",      Default = false, Tooltip = "Continues to walk if entity 'A-60' is present, enables position spoof automatically." })
Groupboxes.Floors_Automation:AddToggle("RoomsAutoWalkShowPathToggle", { Text = "Show Path",       Default = false, Tooltip = "Shows the current path of rooms auto-walk." })

Toggles.RoomsAutoWalk:OnChanged(function()
	for _, Object in Globals.RoomsNodesFolder:GetChildren() do
		if Object.Name == "PathNode" then Object:Destroy() end
	end
end)
Toggles.RoomsAutoWalkShowPathToggle:AddColorPicker("RoomsAutoWalkShowPathColor", { Text = "Path", Default = Color3.fromRGB(0, 255, 0), Transparency = 0 })
Toggles.RoomsAutoWalkShowPathToggle:OnChanged(function(Value)
	for _, Object in Globals.RoomsNodesFolder:GetChildren() do
		if Object.Name == "PathNode" then Object.Transparency = Value and 0.5 or 1 end
	end
end)
Options.RoomsAutoWalkShowPathColor:OnChanged(function(Value)
	for _, Object in Globals.RoomsNodesFolder:GetChildren() do
		if Object.Name == "PathNode" then Object.Color = Value end
	end
end)

Functions.RoomsAutoWalk = {}
Functions.RoomsAutoWalk.GetNearestHidingSpot = function()
	local Nearest = { Distance = math.huge, Object = nil }
	for _, Object in Objects.HidingSpots do
		if Object.PrimaryPart and Object:FindFirstChild("HidePrompt") then
			local Distance = LocalPlayer:DistanceFromCharacter(Object.PrimaryPart.Position)
			if Distance < Nearest.Distance and Object.PrimaryPart.Position.Y > -10 then
				local HiddenPlayer = Object:FindFirstChild("HiddenPlayer", true)
				if HiddenPlayer and not HiddenPlayer.Value then
					Nearest.Distance = Distance
					Nearest.Object = Object
				end
			end
		end
	end
	return Nearest.Object
end

local RoomsEntityList = { "RushMoving","AmbushMoving","BackdoorRush","A60","A120","CustomEntity","GlitchRush","GlitchAmbush" }
Functions.RoomsAutoWalk.GetPathfindTarget = function()
	for _, Object in Services.Workspace:GetChildren() do
		if table.find(RoomsEntityList, Object.Name) and Object.PrimaryPart then
			local Y = Object.PrimaryPart.Position.Y
			if Y > -10 and Y < 150 then
				if Object.Name == "A60" and not Toggles.RoomsAutoWalkIgnoreA60.Value or Object.Name ~= "A60" then
					return Functions.RoomsAutoWalk.GetNearestHidingSpot() or CurrentRooms[tostring(LatestRoom.Value)]:FindFirstChild("RoomExit")
				end
			end
		end
	end
	return CurrentRooms[tostring(LatestRoom.Value)]:FindFirstChild("RoomExit")
end

Connections.RoomsAutoWalkHandler = Services.RunService.Heartbeat:Connect(function()
	if Floor ~= "Rooms" or not Toggles.RoomsAutoWalk.Value or Globals.RoomsAutoWalkActive or not CollisionPart then return end
	Globals.RoomsAutoWalkActive = true

	local Path = Services.PathfindingService:CreatePath({
		AgentCanJump = true, AgentCanClimb = false, WaypointSpacing = 4,
		AgentRadius = 1.5, AgentHeight = 1.5, Costs = { StuckPart = 8 }
	})

	if Toggles.RoomsAutoWalkIgnoreA60.Value and not Toggles.PositionSpoof.Value then
		Toggles.PositionSpoof:SetValue(true)
	end

	local TargetPart = Functions.RoomsAutoWalk.GetPathfindTarget()
	if not TargetPart then
		Globals.RoomsAutoWalkActive = false
		return
	end

	local TargetPosition
	if TargetPart.Name == "RoomExit" then
		TargetPosition = TargetPart.Position
	elseif TargetPart:FindFirstChild("HidePrompt") then
		for _, Part in TargetPart:GetDescendants() do
			if Part:IsA("BasePart") then Part.CanCollide = false end
		end
		TargetPosition = TargetPart.PrimaryPart.Position
	end

	if CollisionPart.Anchored and not TargetPart:FindFirstChild("HidePrompt") then
		Character:SetAttribute("Hiding", true)
		RemotesFolder.CamLock:FireServer()
		Character:SetAttribute("Hiding", false)
	end

	local CurrentRoom = CurrentRooms[tostring(LatestRoom.Value)]
	if CurrentRoom:FindFirstChild("Door") then
		CurrentRoom.Door.Door.CanCollide = false
	end

	if not TargetPosition or LocalPlayer:DistanceFromCharacter(TargetPosition) >= 750 then
		Globals.RoomsAutoWalkActive = false
		return
	end

	Path:ComputeAsync(CollisionPart.Position, TargetPosition)
	local Waypoints = Path:GetWaypoints()

	if #Waypoints == 0 then
		local RoomExit = CurrentRoom:FindFirstChild("RoomExit")
		if RoomExit then Humanoid:MoveTo(RoomExit.Position) end
		Globals.RoomsAutoWalkActive = false
		return
	end

	for _, Node in Globals.RoomsNodesFolder:GetChildren() do
		if Node.Name == "PathNode" then Node:Destroy() end
	end

	for _, Waypoint in Waypoints do
		local Block = Instance.new("Part", Globals.RoomsNodesFolder)
		Block.Transparency = Toggles.RoomsAutoWalkShowPathToggle.Value and 0.5 or 1
		Block.Size = Vector3.one
		Block.Position = Waypoint.Position
		Block.Shape = Enum.PartType.Ball
		Block.CanCollide = false
		Block.Anchored = true
		Block.Name = "PathNode"
		Block.Color = Options.RoomsAutoWalkShowPathColor.Value
		Block.Material = Enum.Material.Neon
	end

	local Stuck = false
	for _, Waypoint in Waypoints do
		if Stuck or not Toggles.RoomsAutoWalk.Value then break end

		local Finished = false
		local Start = tick()

		local StepConnection = Services.RunService.RenderStepped:Connect(function()
			if Stuck or not Toggles.RoomsAutoWalk.Value then Finished = true return end

			local NewTarget = Functions.RoomsAutoWalk.GetPathfindTarget()
			if NewTarget and NewTarget:FindFirstChild("HidePrompt") and not TargetPart:FindFirstChild("HidePrompt") then
				Finished = true return
			end
			if TargetPart:FindFirstChild("HidePrompt") then
				local HidePrompt = TargetPart:FindFirstChild("HidePrompt")
				if LocalPlayer:DistanceFromCharacter(TargetPosition) < HidePrompt.MaxActivationDistance
					and Character:GetAttribute("Hiding") ~= true
				then
					Functions.ForceFirePrompt(HidePrompt)
				end
			end
			local FlatPos = Vector3.new(Waypoint.Position.X, RootPart.Position.Y, Waypoint.Position.Z)
			if LocalPlayer:DistanceFromCharacter(FlatPos) < 5 then Finished = true end
			Humanoid:MoveTo(Waypoint.Position)
		end)

		while not Finished do
			if tick() - Start > Options.RoomsAutoWalkPathfindTimeout.Value then
				local StuckBlock = Instance.new("Part", Globals.RoomsNodesFolder)
				StuckBlock.Transparency = 1
				StuckBlock.Size = Vector3.one
				StuckBlock.CFrame = Collision.CFrame
				StuckBlock.Shape = Enum.PartType.Ball
				StuckBlock.CanCollide = false
				StuckBlock.Anchored = true
				StuckBlock.Name = "StuckPart"
				local Modifier = Instance.new("PathfindingModifier", StuckBlock)
				Modifier.Label = "StuckPart"
				Stuck = true
				break
			end
			task.wait()
		end
		StepConnection:Disconnect()
		Humanoid:MoveTo(RootPart.Position)
	end

	Globals.RoomsAutoWalkActive = false
end)

local PreviousNode = nil
Connections.RoomsHandler = CurrentRooms.ChildAdded:Connect(function(Room)
	for _, Object in Globals.RoomsNodesFolder:GetChildren() do
		if Object.Name == "StuckPart" then Object:Destroy() end
	end

	if Room:GetAttribute("RawName") and string.find(Room:GetAttribute("RawName"), "Eyestalk") then
		local function CreateEyestalkNode(WaypointPos)
			local NewNode = Instance.new("Part")
			NewNode.Size = Vector3.one
			NewNode.Transparency = 1
			NewNode.Parent = Globals.SeekNodesFolder
			NewNode.Anchored = true
			NewNode.Position = WaypointPos
			NewNode.CanCollide = false
			NewNode.Name = "SeekLightNode"

			local PrevNode = PreviousNode or NewNode
			PreviousNode = NewNode

			local NewBeam = Instance.new("Beam")
			NewBeam.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Options.ShowEyestalkPathColor.Value), ColorSequenceKeypoint.new(1, Options.ShowEyestalkPathColor.Value) })
			NewBeam.FaceCamera = true
			NewBeam.Width0 = 0.2
			NewBeam.Width1 = 0.2
			NewBeam.Brightness = 10
			NewBeam.LightInfluence = 0
			NewBeam.LightEmission = 0
			NewBeam.Enabled = true

			local Vis = Toggles.ShowEyestalkPathToggle.Value and 0 or 1
			NewBeam.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, Vis), NumberSequenceKeypoint.new(1, Vis) })
			NewBeam.Parent = Globals.SeekNodesFolder

			local A0 = Instance.new("Attachment", NewNode)
			local A1 = Instance.new("Attachment", PrevNode)
			NewBeam.Attachment0 = A0
			NewBeam.Attachment1 = A1

			table.insert(Objects.EyestalkHighlights, NewBeam)
		end

		Room:WaitForChild("RoomEntrance", 9e9)
		Room:WaitForChild("RoomExit", 9e9)

		while not Room:GetAttribute("PathFound") do
			if Toggles.ShowEyestalkPathToggle.Value then
				local EyePath = game:GetService("PathfindingService"):CreatePath({
					AgentCanJump = false, AgentCanClimb = false, WaypointSpacing = 2, AgentRadius = 1, AgentHeight = 1
				})
				EyePath:ComputeAsync(RootPart.Position, Room.RoomExit.Position)
				if EyePath.Status == Enum.PathStatus.Success then
					Room:SetAttribute("PathFound", true)
					for _, Waypoint in EyePath:GetWaypoints() do
						CreateEyestalkNode(Waypoint.Position)
						task.wait()
					end
				end
			end
			task.wait(0.25)
		end
	end
end)

Groupboxes.Floors_Visuals = Tabs.Floors:AddLeftGroupbox("Visuals")
Groupboxes.Floors_Visuals:AddToggle("ShowSeekPathToggle", {
	Text = "Show Seek Path", Default = false, Tooltip = "Shows you the correct path in seek chases.",
	Risky = Floor ~= "Mines"
})
Toggles.ShowSeekPathToggle:AddColorPicker("ShowSeekPathColor", { Text = "Seek Path", Default = Color3.fromRGB(0, 255, 0), Transparency = 0 })

local function UpdateBeamVisibility(BeamTable, ColorKey, Visible)
	local Vis = Visible and 0 or 1
	local Seq = NumberSequence.new({ NumberSequenceKeypoint.new(0, Vis), NumberSequenceKeypoint.new(1, Vis) })
	for _, Beam in BeamTable do Beam.Transparency = Seq end
end
local function UpdateBeamColor(BeamTable, Value)
	local Seq = ColorSequence.new({ ColorSequenceKeypoint.new(0, Value), ColorSequenceKeypoint.new(1, Value) })
	for _, Beam in BeamTable do Beam.Color = Seq end
end

Toggles.ShowSeekPathToggle:OnChanged(function(V)  UpdateBeamVisibility(Objects.SeekHighlights, "ShowSeekPathColor", V) end)
Options.ShowSeekPathColor:OnChanged(function(V)   UpdateBeamColor(Objects.SeekHighlights, V) end)

Groupboxes.Floors_Visuals:AddToggle("ShowEyestalkPathToggle", {
	Text = "Show Eyestalk Path", Default = false, Tooltip = "Shows you the correct path in the eyestalk chase.",
	Risky = Floor ~= "Garden"
})
Toggles.ShowEyestalkPathToggle:AddColorPicker("ShowEyestalkPathColor", { Text = "Eyestalk Path", Default = Color3.fromRGB(0, 255, 0), Transparency = 0 })
Toggles.ShowEyestalkPathToggle:OnChanged(function(V) UpdateBeamVisibility(Objects.EyestalkHighlights, "ShowEyestalkPathColor", V) end)
Options.ShowEyestalkPathColor:OnChanged(function(V)  UpdateBeamColor(Objects.EyestalkHighlights, V) end)

Groupboxes.Floors_Bypass = Tabs.Floors:AddLeftGroupbox("Bypass")
Groupboxes.Floors_Bypass:AddToggle("RemoveSeekTrigger", {
	Text = "Delete Seek Trigger", Default = false, Tooltip = "Diables the 'Seek' chase trigger.",
	Risky = not (Floor == "Fools" or Floor == "OldHotel"),
	Disabled = not Functions.CheckCompatability({"firetouchinterest"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Floors_Bypass:AddToggle("RemoveFigure", {
	Text = "Delete Figure", Default = false, Tooltip = "Completely removes the entity 'Figure' (doesn't always work).",
	Risky = not (Floor == "Fools" or Floor == "OldHotel" or Floor == "Mines"),
	Disabled = not Functions.CheckCompatability({"isnetworkowner"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Floors_Bypass:AddToggle("AutoRevive", {
	Text = "Infinite Revives", Default = false, Tooltip = "Automatically revives after dying, with unlimited respawns.",
	Risky = not (Floor == "Fools" or Floor == "OldHotel")
})
Groupboxes.Floors_Bypass:AddDivider()
Groupboxes.Floors_Bypass:AddToggle("RemoveBasementGate",  { Text = "Remove Basement Gate",   Default = false, Tooltip = "Removes the gate from basement rooms.",            Risky = not (Floor == "Fools" or Floor == "OldHotel") })
Groupboxes.Floors_Bypass:AddToggle("RemovePaintingsDoor", { Text = "Remove Paintings Door",  Default = false, Tooltip = "Removes the fireplace doors from painting rooms.", Risky = not (Floor == "Fools" or Floor == "OldHotel") })
Groupboxes.Floors_Bypass:AddToggle("RemoveSkeletonDoor",  { Text = "Remove Skeleton Door",   Default = false, Tooltip = "Removes the skeleton door from the infirmary.",    Risky = Floor ~= "Fools" })

local ObstructionNames = { ThingToOpen = "RemoveBasementGate", MovingDoor = "RemovePaintingsDoor", Wax_Door = "RemoveSkeletonDoor" }
for ObjName, ToggleName in ObstructionNames do
	Toggles[ToggleName]:OnChanged(function(Value)
		for _, Object in Objects.Obstructions do
			if Object.Name == ObjName then
				Object:PivotTo(Value and CFrame.new(-10000, -10000, -10000) or Object:GetAttribute("OriginalPosition"))
			end
		end
	end)
end

local MainHook
if Functions.CheckCompatability({"hookmetamethod", "newcclosure", "getnamecallmethod"}) then
	MainHook = Abysall.Environment.hookmetamethod(game, "__namecall", Abysall.Environment.newcclosure(function(Self, ...)
		local Args = { ... }
		if Abysall and Abysall.Environment then
			local Method = Abysall.Environment.getnamecallmethod()

			if Self.Name == "Crouch" and Method == "FireServer" and (Toggles.CrouchSpoof.Value or Toggles.PositionSpoof.Value) then
				Args[1] = true
			end

			if Self.Name == "MotorReplication" and Method == "FireServer" then
				local DoBypass = (Toggles.BypassEyes.Value and Globals.IsEyes) or (Toggles.BypassLookman.Value and Globals.IsLookman)
				if DoBypass then
					if Floor == "Fools" or Floor == "OldHotel" then
						Args[1] = 0 Args[2] = -65 Args[3] = 0 Args[4] = false
					else
						Args[1] = -650
					end
				end
			end
		end
		return MainHook(Self, table.unpack(Args))
	end))
end

if Services.ReplicatedStorage:FindFirstChild("ModulesClient") then
	ClientModules = Services.ReplicatedStorage.ModulesClient
else
	ClientModules = Services.ReplicatedStorage.ClientModules
end

Modules = {
	Glitch         = ClientModules.EntityModules.Glitch,
	Shade          = ClientModules.EntityModules.Shade,
	Void           = ClientModules.EntityModules:FindFirstChild("Void"),
	SpiderJumpscare = nil,
	A90            = nil,
	Screech        = nil,
	Dread          = nil,
	GlitchScreech  = nil,
}

local CharacterOldConnectionKeys = {
	"MainHandler", "JumpHandler", "SlideHandler", "LibraryCodeHandler1", "LibraryCodeHandler2",
	"OxygenConnection", "AnimationHandler", "AutoHideConnection", "LagbackFixer", "AutoReviveHandler",
	"SHMFixer", "AnticheatDisabler", "AnticheatEnableDetector1", "AnticheatEnableDetector2",
	"AutoSteerMinecartDuckHandler", "AutoSolveAnchorsConnection", "InfiniteJumpsConnection1", "InfiniteJumpsConnection2",
	"FootstepHandler"
}

Functions.HandleCharacter = function(NewCharacter)
	for _, Key in CharacterOldConnectionKeys do
		if Connections[Key] then
			Connections[Key]:Disconnect()
			Connections[Key] = nil
		end
	end

	while LocalPlayer:DistanceFromCharacter(Services.Workspace.CurrentCamera.CFrame.Position) > 5 do
		task.wait()
	end
	task.wait()

	Character = NewCharacter
	Humanoid = NewCharacter:WaitForChild("Humanoid", 9e9)
	RootPart = NewCharacter:FindFirstChild("HumanoidRootPart")
	Camera   = Services.Workspace.CurrentCamera

	Globals.OldCamera = Camera
	Globals.MainUI = LocalPlayer.PlayerGui.MainUI

	Collision = NewCharacter:WaitForChild("Collision")
	CollisionPart  = NewCharacter:FindFirstChild("CollisionPart") or NewCharacter:FindFirstChild("Collision")
	CollisionClone = Collision:Clone()
	CollisionClone.Parent = NewCharacter
	CollisionClone.Name = "CollisionClone"
	CollisionClone.Massless = true

	CollisionPartClone = CollisionPart:Clone()
	CollisionPartClone.Parent = NewCharacter
	CollisionPartClone.Name = "CollisionPartClone"
	CollisionPartClone.CanCollide = false
	CollisionPartClone.Massless = true

	if CollisionPartClone:FindFirstChild("CollisionCrouch") then
		CollisionPartClone.CollisionCrouch:Destroy()
	end

	Character:SetAttribute("SpeedBoost", 0)
	Character:SetAttribute("SpeedBoostBehind", 0)
	Character:SetAttribute("SpeedBoostExtra", 0)

	OldJump  = NewCharacter:GetAttribute("CanJump")
	OldSlide = NewCharacter:GetAttribute("CanSlide")

	if Toggles.EnableCharacterJump.Value  then Character:SetAttribute("CanJump",  true) end
	if Toggles.EnableCharacterSlide.Value then Character:SetAttribute("CanSlide", true) end

	if Functions.CheckCompatability({"require"}) then
		Main_Game = Abysall.Environment.require(Globals.MainUI.Initiator.Main_Game)
	end

	if Main_Game and Toggles.RemoveCameraBobbing.Value then
		Main_Game.spring.Speed = 9e9
	end

	if Main_Game and Functions.CheckCompatability({"require"}) then
		local Controls = require(LocalPlayer.PlayerScripts.PlayerModule):GetControls()
		local OriginalGetMoveVector = Controls.GetMoveVector
		Controls.GetMoveVector = function(...)
			if Toggles.AutoSteerMinecart.Value and Floor == "Mines" then
				local Node = Functions.GetNearestTurnNode()
				if Node then
					local Turn = Node:GetAttribute("Turn")
					return Turn == "Left" and Vector3.new(-1, 0, 0) or Turn == "Right" and Vector3.new(1, 0, 0) or Vector3.zero
				end
			end
			return OriginalGetMoveVector(...)
		end
	end

	Globals.AutoMinecartDucked = false
	Connections.AutoSteerMinecartDuckHandler = Services.RunService.Heartbeat:Connect(function()
		if not Toggles.AutoSteerMinecart.Value or not Functions.GetMinecart() then return end
		if not Globals.AutoMinecartDucked and Functions.GetNearestDuckBoard() then
			Main_Game.crouch(true)
			Globals.AutoMinecartDucked = true
		elseif not Functions.GetNearestDuckBoard() and Globals.AutoMinecartDucked then
			Main_Game.crouch(false)
			Globals.AutoMinecartDucked = false
		end
		if Main_Game then
			Main_Game.fovtarget = Options.FieldOfView.Value
		else
			Camera.FieldOfView = Options.FieldOfView.Value
		end
	end)

	Globals.AnticheatDisabled = false

	local UIModules = Globals.MainUI.Initiator.Main_Game.RemoteListener.Modules
	Modules.A90             = UIModules:FindFirstChild("A90")
	Modules.Screech         = UIModules.Screech
	Modules.Dread           = UIModules:FindFirstChild("Dread")
	Modules.SpiderJumpscare = UIModules.SpiderJumpscare

	if Toggles.RemoveScreech.Value    then Modules.Screech.Name = "Screech_Disabled" end
	if Toggles.RemoveA90.Value and Modules.A90   then Modules.A90.Name = "A90_Disabled" end
	if Toggles.RemoveDread.Value and Modules.Dread then Modules.Dread.Name = "Dread_Disabled" end
	if Toggles.DisableTimothyJumpscare.Value then Modules.SpiderJumpscare.Name = "SpiderJumpscare_Disabled" end

	if Toggles.DisableHideVignette.Value then
		local Vignette = Globals.MainUI:FindFirstChild("HideVignette") or Globals.MainUI.MainFrame:FindFirstChild("HideVignette")
		if Vignette then Vignette.Image = "Disabled" end
	end
	if Toggles.RemoveInteractingSounds.Value then
		local PS = Globals.MainUI.Initiator.Main_Game.PromptService
		PS.Triggered.Volume = 0
		PS.Holding.Volume   = 0
		PS.Notification.Volume = 0
		Globals.MainUI.Initiator.Main_Game.Reminder.Caption.Volume = 0
	end
	if Toggles.DisableEntityJumpscares.Value then
		local JS = Globals.MainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Jumpscares")
		if JS then JS.Name = "Jumpscares_Disabled" end
	end

	CustomPhysics = PhysicalProperties.new(
		100,
		RootPart.CustomPhysicalProperties.Friction,
		RootPart.CustomPhysicalProperties.Elasticity,
		RootPart.CustomPhysicalProperties.FrictionWeight,
		RootPart.CustomPhysicalProperties.ElasticityWeight
	)
	for _, Part in NewCharacter:GetDescendants() do
		if Part:IsA("BasePart") then
			PartProperties[Part] = Part.CustomPhysicalProperties
			if Toggles.RemoveAcceleration.Value then
				Part.CustomPhysicalProperties = CustomPhysics
			end
		end
	end

	Connections.LibraryCodeHandler1 = LocalPlayer.PlayerGui.PermUI.Hints.ChildAdded:Connect(function()
		if Toggles.NotifyLibraryCode.Value then
			local Code = Functions.GetLibraryCode()
			if Code and not Code:find("_") and not Globals.LibraryCodeFound then
				local Lock = Services.Workspace:FindFirstChild("Padlock", true)
				Functions.Notify({ Title = "Padlock code found!", Body = "The code is: '" .. Code .. "'", Time = Toggles.NotifyKeepNotifications.Value and Lock or 15 })
				Globals.LibraryCodeFound = true
			end
		end
	end)

	Connections.LibraryCodeHandler2 = Character.ChildAdded:Connect(function(Child)
		if (Child.Name == "LibraryHintPaper" or Child.Name == "LibraryHintPaperHard") and Toggles.NotifyLibraryCode.Value then
			local Code = Functions.GetLibraryCode()
			if Code and not Code:find("_") and not Globals.LibraryCodeFound then
				local Lock = Services.Workspace:FindFirstChild("Padlock", true)
				Functions.Notify({ Title = "Padlock code found!", Body = "The code is: '" .. Code .. "'", Time = Toggles.NotifyKeepNotifications.Value and Lock or 15 })
				Globals.LibraryCodeFound = true
			end
		end
	end)

	Connections.FootstepHandler = Character.ChildAdded:Connect(function(Object)
		if Object:IsA("Sound") and Object.Name == "Sound" and Toggles.RemoveFootstepSounds.Value then
			Object.Volume = 0
		end
	end)

	Globals.OldOxygen = Character:GetAttribute("Oxygen")
	Connections.OxygenConnection = Character:GetAttributeChangedSignal("Oxygen"):Connect(function()
		local NewOxy = Character:GetAttribute("Oxygen")
		if NewOxy < Globals.OldOxygen and Toggles.NotifyOxygen.Value then
			Functions.Caption(Functions.FormatOxygen(NewOxy), true)
		end
		Globals.OldOxygen = NewOxy
	end)

	Connections.AutoReviveHandler = LocalPlayer:GetAttributeChangedSignal("Alive"):Connect(function()
		if LocalPlayer:GetAttribute("Alive") == false and Toggles.AutoRevive.Value then
			if Floor == "Fools" or Floor == "OldHotel" then
				while LocalPlayer:GetAttribute("Alive") ~= true do
					RemotesFolder.Revive:FireServer()
					task.wait(0.5)
				end
			end
		end
	end)

	Connections.SHMFixer = RootPart:GetPropertyChangedSignal("Anchored"):Connect(function()
		task.wait()
		if Floor == "Fools" and RootPart.Anchored and Character:GetAttribute("Hiding") ~= true then
			RootPart.Anchored = false
		end
	end)

	Connections.AnticheatDisabler = Character:GetAttributeChangedSignal("Climbing"):Connect(function()
		if Character:GetAttribute("Climbing") == true and Toggles.DisableAnticheat.Value and not Globals.AnticheatDisabled then
			task.wait(0.25)
			Character:SetAttribute("Climbing", false)
			Functions.Notify({ Title = "Successfully disabled the anticheat.", Body = "It will be re-enabled after a cutscene or halt room." })
			Globals.AnticheatDisabled = true
		end
	end)

	Connections.AnticheatEnableDetector1 = RemotesFolder:WaitForChild("Cutscene").OnClientEvent:Connect(function(CutsceneName)
		if Globals.AnticheatDisabled and not CutsceneName:find("SewerSeek") then
			Globals.AnticheatDisabled = false
			Functions.Notify({ Title = "The anticheat has been re-enabled.", Body = "Interact with a ladder to disable it again." })
		end
	end)

	Connections.AnticheatEnableDetector2 = RemotesFolder:WaitForChild("UseEnemyModule").OnClientEvent:Connect(function(ModuleName)
		if ModuleName == "Void" or ModuleName == "Glitch" then
			if Globals.AnticheatDisabled then
				Globals.AnticheatDisabled = false
				Functions.Notify({ Title = "The anticheat has been re-enabled.", Body = "Interact with a ladder to disable it again." })
			end
			LocalPlayer:SetAttribute("CurrentRoom", LatestRoom.Value)
		end
	end)

	Connections.AnimationHandler = Character.ChildAdded:Connect(function()
		local ToolNames = { "Lockpick","Shears","SkeletonKey","Key","KeyElectrical","KeyBackdoor","KeyIron" }
		local Tool
		for _, Name in ToolNames do
			Tool = Character:FindFirstChild(Name)
			if Tool then break end
		end
		if not Tool then return end

		local UseAnim = Tool:FindFirstChild("use", true) or Tool:FindFirstChild("promptanim", true)
		if UseAnim then
			UseAnim = Humanoid:LoadAnimation(UseAnim)
			UseAnim.Priority = Enum.AnimationPriority.Action4
			Globals.UseAnimation = UseAnim
		end
		local UseAnimBreak = Tool:FindFirstChild("usefinish", true) or Tool:FindFirstChild("promptanimend", true) or Tool:FindFirstChild("lockpickuse", true)
		if UseAnimBreak then
			UseAnimBreak = Humanoid:LoadAnimation(UseAnimBreak)
			UseAnimBreak.Priority = Enum.AnimationPriority.Action4
			Globals.UseAnimationBreak = UseAnimBreak
		end
	end)

	Connections.JumpHandler = Character:GetAttributeChangedSignal("CanJump"):Connect(function()
		local Val = Character:GetAttribute("CanJump")
		if Toggles.EnableCharacterJump.Value and Val ~= true or not Toggles.EnableCharacterJump.Value then
			OldJump = Val
		end
		if Toggles.EnableCharacterJump.Value then Character:SetAttribute("CanJump", true) end
	end)

	Connections.SlideHandler = Character:GetAttributeChangedSignal("CanSlide"):Connect(function()
		local Val = Character:GetAttribute("CanSlide")
		if Toggles.EnableCharacterSlide.Value and Val ~= true or not Toggles.EnableCharacterSlide.Value then
			OldSlide = Val
		end
		if Toggles.EnableCharacterSlide.Value then Character:SetAttribute("CanSlide", true) end
	end)

	Connections.InfiniteJumpsConnection1 = Services.UserInputService.InputBegan:Connect(function(Input)
		if Input.KeyCode == Enum.KeyCode.Space and Toggles.InfiniteJumps.Value then
			Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end)

	local JumpButton = Globals.MainUI.MainFrame.MobileButtons:FindFirstChild("JumpButton")
	if JumpButton then
		Connections.InfiniteJumpsConnection2 = JumpButton.MouseButton1Down:Connect(function()
			if Toggles.InfiniteJumps.Value then
				Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	end

	Globals.LastAutoHide = tick()
	Connections.AutoHideConnection = Services.RunService.Heartbeat:Connect(function()
		if not Toggles.AutoClosetToggle.Value or tick() - Globals.LastAutoHide <= 0.05 then
			Globals.AutoClosetActive = false
			return
		end
		local Entity = Functions.GetNearestEntity(true, Options.AutoClosetEntityList.Value)
		if Entity then
			local Closet = Functions.GetNearestHidingSpot()
			if Character:GetAttribute("Hiding") ~= true and Closet then
				Globals.AutoClosetActive = true
				Functions.ForceFirePrompt(Closet.HidePrompt)
			end
		elseif Character:GetAttribute("Hiding") == true then
			Globals.AutoClosetActive = false
			RemotesFolder.CamLock:FireServer()
		end
		Globals.LastAutoHide = tick()
	end)

	Connections.LagbackFixer = CollisionPart:GetPropertyChangedSignal("Anchored"):Connect(function()
		if CollisionPartClone and CollisionPart.Anchored and not Character:GetAttribute("Hiding") then
			Globals.Lagging = true
			CollisionPartClone.Massless = true
			task.wait(1)
			Globals.Lagging = false
		end
	end)

	Globals.LastAutoAnchor = tick()
	Connections.AutoSolveAnchorsConnection = Services.RunService.Heartbeat:Connect(function()
		if not Toggles.AutoSolveAnchors.Value then return end
		if not Globals.MainUI:FindFirstChild("AnchorHintFrame") then return end
		if tick() - Globals.LastAutoAnchor <= 0.1 then return end
		local Anchor = Functions.GetCurrentAnchor()
		if Anchor and LocalPlayer:DistanceFromCharacter(Anchor.PrimaryPart.Position) < Anchor.ActivateEventPrompt.MaxActivationDistance and not Anchor:GetAttribute("Activated") then
			Anchor:WaitForChild("AnchorRemote"):InvokeServer(Globals.MainUI.AnchorHintFrame.Code.Text)
		end
		Globals.LastAutoAnchor = tick()
	end)

	Globals.ManipulateBody = Instance.new("BodyVelocity")
	Globals.ManipulateBody.MaxForce = Vector3.new(9e9, 9e9, 9e9)

	Globals.FlyBody = Instance.new("BodyVelocity")
	Globals.FlyBody.MaxForce = Vector3.new(9e9, 9e9, 9e9)

	Globals.SelfKilled = false
	Globals.ThirdPersonParts = {}
	for _, Object in Character:GetDescendants() do
		if Object:IsA("Accessory") and Object:FindFirstChild("Handle") then
			table.insert(Globals.ThirdPersonParts, Object.Handle)
		end
	end
	table.insert(Globals.ThirdPersonParts, Character:WaitForChild("Head"))

	Globals.LastAnimationCheck = tick()
	Globals.OriginalC1 = Character.LowerTorso.Root.C1

	local RayParams = RaycastParams.new()
	RayParams.FilterType = Enum.RaycastFilterType.Exclude

	Connections.MainHandler = Services.RunService.RenderStepped:Connect(function()
		if Toggles.SpeedBoostToggle.Value then
			Humanoid.WalkSpeed = Functions.GetCurrentSpeed() + Options.SpeedBoostSlider.Value
		end

		if Globals.Lagging or (Options.SpeedBoostSlider.Value <= 6 and Options.FlySpeed.Value <= 21) then
			CollisionPartClone.Massless = true
		end

		Globals.IsEyes    = Services.Workspace:FindFirstChild("Eyes") ~= nil or Services.Workspace:FindFirstChild("Lookman") ~= nil
		Globals.IsLookman = Services.Workspace:FindFirstChild("BackdoorLookman") ~= nil

		if Toggles.AmbientToggle.Value then
			Services.TweenService:Create(Services.Lighting, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), { Ambient = Options.AmbientColor.Value }):Play()
		end

		if Main_Game then
			if Toggles.RemoveCameraShake.Value     then Main_Game.csgo = CFrame.new() end
			if Toggles.ViewmodelOffsetToggle.Value then
				Main_Game.tooloffset = Vector3.new(Options.ViewmodelOffsetX.Value, Options.ViewmodelOffsetY.Value, Options.ViewmodelOffsetZ.Value)
			else
				Main_Game.tooloffset = Vector3.zero
			end
		end

		if Globals.SelfKilled and Globals.MainUI:FindFirstChild("Statistics") then
			Globals.MainUI.Statistics.Death.Text = "Died to Abysall Hub"
		end

		local MainFrame = Globals.MainUI:FindFirstChild("MainFrame")
		if MainFrame then
			local Effects = MainFrame.Healthbar:FindFirstChild("Effects")
			if Effects and Effects:FindFirstChild("Crouching") then
				Effects.Crouching.Visible = Functions.IsCrouching()
			end
		end

		if not MainHook then
			if (Toggles.CrouchSpoof.Value or Toggles.PositionSpoof.Value) and RemotesFolder:FindFirstChild("Crouch") then
				RemotesFolder.Crouch:FireServer(true)
			end
		end

		if Floor ~= "Fools" and Floor ~= "OldHotel" and not Camera:FindFirstChild("MinecartRig") then
			RootPart.CanCollide = false
		end

		for _, Part in Character:GetChildren() do
			if Part:IsA("BasePart") then Part.CanCollide = false end
		end

		if LocalPlayer:GetAttribute("Alive") == true then
			Services.SoundService:WaitForChild("Main").Volume = 1
		end

		if Floor == "OldHotel" or Floor == "Fools" then
			local SpoofOffset = Toggles.PositionSpoof.Value and Functions.GetNearestEntity() and (Floor == "OldHotel" and 200 or -5) or 0
			Collision.Position = RootPart.Position + Vector3.new(0, SpoofOffset, 0)
			Collision.CanCollide = false
			if Floor == "Fools" then
				Collision.CollisionCrouch.CanCollide = false
				CollisionClone.CollisionCrouch.CanCollide = false
			end
			RootPart.CanCollide = not (Toggles.NoclipToggle.Value or Toggles.VelocityManipulationToggle.Value)
		else
			Collision.CanCollide = false
			if Collision:FindFirstChild("CollisionCrouch") then Collision.CollisionCrouch.CanCollide = false end

			if CollisionClone:FindFirstChild("CollisionCrouch") then
				local IsCrouch = Functions.IsCrouching()
				CollisionClone.CanCollide = not (Toggles.NoclipToggle.Value or Toggles.VelocityManipulationToggle.Value or IsCrouch)
				CollisionClone.CollisionCrouch.CanCollide = not (Toggles.NoclipToggle.Value or Toggles.VelocityManipulationToggle.Value or not IsCrouch)
			else
				RootPart.CanCollide = not (Toggles.NoclipToggle.Value or Toggles.VelocityManipulationToggle.Value)
			end

			if Character:FindFirstChild("LowerTorso") and Character.LowerTorso:FindFirstChild("Root") then
				Character.LowerTorso.Root.C1 = Globals.OriginalC1 * CFrame.new(0, Toggles.PositionSpoof.Value and -2.146 or 0, 0)
			end

			local SpoofY = Toggles.PositionSpoof.Value and 2.128 or 0.18
			Collision.Position     = RootPart.Position + Vector3.new(0, SpoofY, 0)
			CollisionPart.Position = RootPart.Position + Vector3.new(0, SpoofY, 0)

			if Collision:FindFirstChild("CollisionCrouch") and CollisionClone:FindFirstChild("CollisionCrouch") then
				local CrouchY = Toggles.PositionSpoof.Value and 1.128 or -0.982
				Collision.CollisionCrouch.Position = RootPart.Position + Vector3.new(0, CrouchY, 0)
				CollisionClone.CollisionCrouch.CollisionGroup = Collision.CollisionCrouch.CollisionGroup
			end
			if CollisionClone:FindFirstChild("CollisionCrouch") then
				CollisionClone.CollisionCrouch.Position = RootPart.Position + Vector3.new(0, Toggles.PositionSpoof.Value and 0.55 or -0.982, 0)
			end
		end

		CollisionClone.CollisionGroup = Collision.CollisionGroup
		CollisionClone.Position = RootPart.Position + Vector3.new(0, Toggles.PositionSpoof.Value and 1.55 or 0.18, 0)

		if Toggles.VelocityManipulationToggle.Value then
			Globals.ManipulateBody.Parent = RootPart
			Globals.ManipulateBody.Velocity = RootPart.CFrame.LookVector * 2.25
		else
			Globals.ManipulateBody.Parent = nil
		end

		if Toggles.FlyToggle.Value then
			Globals.FlyBody.Parent = RootPart
			Globals.FlyBody.Velocity = Functions.GetFlyVelocity() * Options.FlySpeed.Value
		else
			Globals.FlyBody.Parent = nil
		end

		if not MainHook then
			local DoEyesBypass = (Toggles.BypassEyes.Value and Globals.IsEyes) or (Toggles.BypassLookman.Value and Globals.IsLookman)
			if DoEyesBypass then
				if Floor == "Fools" or Floor == "OldHotel" then
					RemotesFolder.MotorReplication:FireServer(0, -65, 0, false)
				else
					RemotesFolder.MotorReplication:FireServer(-650)
				end
			end
		end

		if RemotesFolder:FindFirstChild("Crouch") then
			local NeedsCrouchFire = (Toggles.SpeedBoostToggle.Value and Options.SpeedBoostSlider.Value > 6 and Floor ~= "Fools" and Floor ~= "OldHotel")
				or (Toggles.FlyToggle.Value and Options.FlySpeed.Value > 21 and Floor ~= "Fools" and Floor ~= "OldHotel")
			if NeedsCrouchFire then
				local IsCrouch = Functions.IsCrouching()
				if Toggles.CrouchSpoof.Value or Toggles.PositionSpoof.Value then IsCrouch = true end
				RemotesFolder.Crouch:FireServer(IsCrouch, true)
			end
		end

		if tick() - Globals.LastAnimationCheck > 0.1 then
			local Sliding = false
			for _, Anim in Humanoid:GetPlayingAnimationTracks() do
				if Anim.Name == "Slide" then Sliding = true break end
			end
			Globals.Sliding = Sliding
			Globals.LastAnimationCheck = tick()
		end

		Character:SetAttribute("Sliding", Globals.Sliding)
		if Character:GetAttribute("Crouching") ~= Functions.IsCrouching() then
			Character:SetAttribute("Crouching", Functions.IsCrouching())
		end

		RayParams.FilterDescendantsInstances = { Character }
		local TPOffset = CFrame.new(Options.ThirdPersonOffsetX.Value, Options.ThirdPersonOffsetY.Value, Options.ThirdPersonOffsetZ.Value)
		local Direction = (Camera.CFrame * TPOffset).Position - Camera.CFrame.Position
		local WallResult = Services.Workspace:Spherecast(Camera.CFrame.Position, 0.2, Direction, RayParams)

		if Toggles.ThirdPersonToggle.Value then
			if Toggles.ThirdPersonWallCheck.Value and WallResult and WallResult.Instance.CanCollide then
				local NewPos = Camera.CFrame.Position + Direction.Unit * WallResult.Distance
				Camera.CFrame = CFrame.new(NewPos, NewPos + Camera.CFrame.LookVector)
			else
				Camera.CFrame = Camera.CFrame * TPOffset
			end
		end

		for _, Part in Globals.ThirdPersonParts do
			Part.Transparency = Toggles.ThirdPersonToggle.Value and 0 or 1
			Part.LocalTransparencyModifier = Toggles.ThirdPersonToggle.Value and 0 or 1
		end

		if Main_Game then
			Main_Game.fovtarget = Options.FieldOfView.Value
		else
			Camera.FieldOfView = Options.FieldOfView.Value
		end

		if Toggles.RemoveClosetDelay.Value
			and Humanoid.MoveDirection ~= Vector3.zero
			and (CollisionPart.Anchored or RootPart.Anchored)
			and Character:GetAttribute("AnimatingClient") ~= true
			and Character:GetAttribute("Hiding") == true
		then
			RemotesFolder.CamLock:FireServer()
		end

		local ClosestPlayer = { Distance = math.huge, Object = nil }
		for _, Player in Services.Players:GetPlayers() do
			if Player.Character and Player ~= LocalPlayer then
				local Root = Player.Character:FindFirstChild("HumanoidRootPart")
				if Root then
					local D = (Camera.CFrame.Position - Root.Position).Magnitude
					if D < ClosestPlayer.Distance then
						ClosestPlayer.Distance = D
						ClosestPlayer.Object = Player
					end
				end
			end
		end
		if ClosestPlayer.Object and LocalPlayer:GetAttribute("Alive") ~= true then
			LocalPlayer:SetAttribute("CurrentRoom", ClosestPlayer.Object:GetAttribute("CurrentRoom"))
		end
	end)

	task.wait(1)
	if Toggles.PositionSpoof.Value and Floor ~= "Fools" and Floor ~= "OldHotel" then
		RootPart.CFrame = RootPart.CFrame * CFrame.new(0, -2.146, 0)
		Humanoid.HipHeight = 0.25
		RemotesFolder.Crouch:FireServer(true)
	end

	local Jam = Globals.MainUI.Initiator.Main_Game.Health:FindFirstChild("Jam")
	if Jam and Toggles.RemoveJamminMusic.Value then
		Jam.Volume = 0
		Globals.JamMuffle.Enabled = false
	end
end

Functions.HandleHidingTransparency = function(Model)
	local Parts = {}
	for _, Part in Model:GetDescendants() do
		if Part:IsA("BasePart") then
			Part:SetAttribute("Transparency_Old", Part.Transparency)
			table.insert(Parts, Part)
		end
		if Part.Name == "HiddenPlayer" then
			local HideConn = Part:GetPropertyChangedSignal("Value"):Connect(function()
				for _, P in Parts do
					if P:GetAttribute("Transparency_Old") then
						Services.TweenService:Create(P, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
							Transparency = (Part.Value == Character and Toggles.TransparentHidingSpotsToggle.Value)
								and Options.TransparentHidingSpotsSlider.Value
								or P:GetAttribute("Transparency_Old")
						}):Play()
					end
				end
			end)
			table.insert(Connections, HideConn)
			Model.Destroying:Once(function()
				HideConn:Disconnect()
				local Pos = table.find(Connections, HideConn)
				if Pos then table.remove(Connections, Pos) end
			end)
		end
	end
end

local AllowedInstances = {
	Lava=true, GoldPile=true, KeyObtain=true, KeyObtainFake=true, Drakobloxxer=true, FuseObtain=true,
	MinesGenerator=true, JeffTheKiller=true, Snare=true, FakeDoor=true, DoorFake=true, SideroomSpace=true,
	ChestBox=true, ChestBoxLocked=true, Chest_Vine=true, Locker_Small_Locked=true, Toolbox=true,
	Toolbox_Locked=true, Wardrobe=true, ["Wardrobe-FOOLS26"]=true, Toolshed=true, Toolshed_Small=true,
	Bed=true, MinesAnchor=true, Double_Bed=true, RetroWardrobe=true, Backdoor_Wardrobe=true,
	Rooms_Locker=true, Rooms_Locker_Fridge=true, Locker_Large=true, FigureRig=true, FigureRagdoll=true,
	TimerLever=true, Lever=true, Seek_Arm=true, ChandelierObstruction=true, ScaryWall=true, Ladder=true,
	CircularVent=true, Dumpster=true, SquareGrate=true, TriggerEventCollision=true, GrumbleRig=true,
	GiggleCeiling=true, MinesGateButton=true, ElectricalKeyObtain=true, LibraryHintPaper=true,
	WaterPump=true, CringlePresent=true, Wheel=true, PickupItem=true, LiveHintBook=true,
	LiveBreakerPolePickup=true, LeverForGate=true, GloomPile=true, SeekFloodline=true, Door=true,
	Green_Herb=true, Bridge=true, MouseHole=true, BananaPeel=true, NannerPeel=true, PowerupPad=true,
	IndustrialGate=true, CollisionFloor=true, ElevatorCar=true, Wax_Door=true, ThingToOpen=true,
	MovingDoor=true, StardustPickup=true, Hole=true, Groundskeeper=true, MandrakeLive=true,
	GardenGateButton=true, LotusPetalPickup=true, VineGuillotine=true, LiveEntityBramble=true,
	RiftSpawn=true, ElevatorBreaker=true, RunnerNodes=true, PathLights=true, DuckBoard=true,
	Padlock=true, EyestalkEndCutscene=true
}

Functions.HandleObject = function(Object)
	if not AllowedInstances[Object.Name] and Object.ClassName ~= "ProximityPrompt" and Object.Parent ~= CurrentRooms and not ItemNames[Object.Name] then
		return
	end

	if Object.Name ~= "TriggerEventCollision" then
		task.wait(Object.ClassName == "ProximityPrompt" and (math.random(15, 20) / 100) or (math.random(20, 40) / 100))
	end

	for _, Room in CurrentRooms:GetChildren() do
		if Object:IsDescendantOf(Room) then
			Object:SetAttribute("ParentRoom", tonumber(Room.Name))
			break
		end
	end

	if Object.Parent == CurrentRooms then
		local FiredampVal = Object:GetAttribute("Firedamp")
		Object:SetAttribute("Firedamp_Old", FiredampVal ~= nil and FiredampVal or false)
		if Toggles.DisableFiredampEffect.Value then
			Object:SetAttribute("Firedamp", false)
		end
	end

	local Name = Object.Name

	if Name == "KeyObtain" then
		task.wait(0.5)
		if Object.Parent then
			if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Door Key", Color = Options.ObjectiveESPColor.Value }, true) end
			table.insert(Objects.Objectives, Object)
		end
	elseif Name == "ElectricalKeyObtain" then
		task.wait(0.5)
		if Object.Parent then
			if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Electrical Key", Color = Options.ObjectiveESPColor.Value }, true) end
			table.insert(Objects.Objectives, Object)
		end
	elseif Name == "KeyObtainFake" then
		task.wait(0.5)
		if Object.Parent then
			if Toggles.EntityESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Fake Key", Color = Options.EntityESPColor.Value }, true) end
			table.insert(Objects.Entities, Object)
		end
	elseif Name == "TimerLever" then
		task.wait(0.5)
		if Object.Parent then
			Object:SetAttribute("AddTime", Object.TakeTimer.TextLabel.Text == "01:00" and 60 or 30)
			if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Time Lever [+" .. Object:GetAttribute("AddTime") .. "s]", Color = Options.ObjectiveESPColor.Value }, true) end
			Object:WaitForChild("Main").SoundToPlay.Played:Once(function()
				Functions.RemoveESP(Object)
				Functions.BlacklistESP(Object)
			end)
			table.insert(Objects.Objectives, Object)
		end
	elseif Name == "LiveHintBook" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Hint Book", Color = Options.ObjectiveESPColor.Value }, true) end
		table.insert(Objects.Objectives, Object)
	elseif Name == "LiveBreakerPolePickup" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Fuse Breaker", Color = Options.ObjectiveESPColor.Value }, true) end
		for _, Child in Object:GetChildren() do
			if Child.Name == "ActivateEventPrompt" and (Child.MaxActivationDistance == 5 or Child:GetAttribute("MaxActivationDistance_Old") == 5) then
				Child:Destroy()
			end
		end
		table.insert(Objects.Objectives, Object)
	elseif Name == "LibraryHintPaper" or Name == "PickupItem" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Hint Paper", Color = Options.ObjectiveESPColor.Value }, true) end
		table.insert(Objects.Objectives, Object)
	elseif Name == "MinesAnchor" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Anchor [" .. Object:WaitForChild("Sign").TextLabel.Text .. "]", Color = Options.ObjectiveESPColor.Value }, true) end
		Object:GetAttributeChangedSignal("Activated"):Once(function()
			Functions.RemoveESP(Object)
			Functions.BlacklistESP(Object)
		end)
		table.insert(Objects.Objectives, Object)
	elseif Name == "WaterPump" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object:WaitForChild("Wheel"), Text = "Water Pump", Color = Options.ObjectiveESPColor.Value }, true) end
		Object:WaitForChild("Wheel").Sound.Played:Once(function()
			Functions.RemoveESP(Object.Wheel)
			Functions.BlacklistESP(Object.Wheel)
		end)
		table.insert(Objects.Objectives, Object)
	elseif Name == "CringlePresent" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Present", Color = Options.ObjectiveESPColor.Value }, true) end
		Object:WaitForChild("ToolProp").Highlight:Destroy()
		table.insert(Objects.Objectives, Object)
	elseif Name == "LeverForGate" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Gate Lever", Color = Options.ObjectiveESPColor.Value }, true) end
		Object:WaitForChild("Main").SoundToPlay.Played:Once(function()
			Functions.RemoveESP(Object)
			Functions.BlacklistESP(Object)
		end)
		table.insert(Objects.Objectives, Object)
	elseif Name == "VineGuillotine" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object.Lever, Text = "Vine Lever", Color = Options.ObjectiveESPColor.Value }, true) end
		Object.Lever:WaitForChild("ActivateEventPrompt"):GetAttributeChangedSignal("Interactions"):Once(function()
			Functions.RemoveESP(Object)
			Functions.BlacklistESP(Object)
		end)
		table.insert(Objects.Objectives, Object)
	elseif Name == "MandrakeLive" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object.Hole, Text = "Mandrake Hole", Color = Options.EntityESPColor.Value }, true) end
		table.insert(Objects.Entities, Object.Hole)
	elseif Name == "MinesGenerator" then
		task.wait(0.75)
		if Object.Parent then
			if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Generator", Color = Options.ObjectiveESPColor.Value }, true) end
			Object:WaitForChild("Lever").Sound.Played:Once(function()
				Functions.RemoveESP(Object)
				Functions.BlacklistESP(Object)
			end)
			table.insert(Objects.Objectives, Object)
		end
	elseif Name == "FuseObtain" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Generator Fuse", Color = Options.ObjectiveESPColor.Value }, true) end
		Object:WaitForChild("Hitbox").FuseModel:GetPropertyChangedSignal("LocalTransparencyModifier"):Once(function()
			Functions.RemoveESP(Object)
			Functions.BlacklistESP(Object)
		end)
		table.insert(Objects.Objectives, Object)
	elseif Name == "MinesGateButton" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Gate Button", Color = Options.ObjectiveESPColor.Value }, true) end
		Object.Parent:WaitForChild("MinesGate").Main.SoundOpen.Played:Once(function()
			Functions.RemoveESP(Object)
			Functions.BlacklistESP(Object)
		end)
		table.insert(Objects.Objectives, Object)
	elseif Name == "GardenGateButton" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Gate Button", Color = Options.ObjectiveESPColor.Value }, true) end
		Object.Parent:WaitForChild("GardenGate").Collision.Sound.Played:Once(function()
			Functions.RemoveESP(Object)
			Functions.BlacklistESP(Object)
		end)
		table.insert(Objects.Objectives, Object)
	elseif Name == "Ladder" then
		if Toggles.LadderESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Ladder", Color = Options.LadderESPColor.Value }, true) end
		table.insert(Objects.Ladders, Object)
	elseif Name == "Door" and Object.Parent and tonumber(Object.Parent.Name) then
		local DoorParts = {}
		for _, Child in Object:GetChildren() do
			if Child.Name == "Door" and Child:IsA("BasePart") then
				table.insert(DoorParts, Child)
			end
		end

		if #DoorParts == 2 then
			local HighlightModel = Instance.new("Model", Object)
			HighlightModel.Name = "HighlightModel"
			Instance.new("Humanoid", HighlightModel).Name = "HighlightHumanoid"
			HighlightModel:SetAttribute("ParentRoom", tonumber(Object.Parent.Name))

			for _, DoorPart in DoorParts do
				local HP = Instance.new("Part", HighlightModel)
				HP.Transparency = 0.99
				HP.Size = DoorPart.Size
				HP.CanCollide = false
				HP.CFrame = DoorPart.CFrame
				HP.Name = "HighlightPart"
				HP:SetAttribute("ParentRoom", tonumber(Object.Parent.Name))
				local W = Instance.new("WeldConstraint", HP)
				W.Part0 = HP W.Part1 = DoorPart W.Enabled = true
			end
			table.insert(Objects.Doors, HighlightModel)
			if Toggles.DoorESPToggle.Value then Functions.AddESP({ Object = HighlightModel, Text = "Door", Color = Options.DoorESPColor.Value }, true) end
		else
			local Root = Object:WaitForChild("Door", 9e9)
			local HP = Instance.new("Part", Object)
			HP.Transparency = 0.99
			HP.Size = Root.Size
			HP.CanCollide = false
			HP.CFrame = Root.CFrame
			HP.Name = "HighlightPart"
			HP:SetAttribute("ParentRoom", tonumber(Object.Parent.Name))
			local W = Instance.new("WeldConstraint", HP)
			W.Part0 = HP W.Part1 = Root W.Enabled = true
			Instance.new("Humanoid", Object).Name = "HighlightHumanoid"
			table.insert(Objects.Doors, HP)
			if Toggles.DoorESPToggle.Value then Functions.AddESP({ Object = HP, Text = "Door", Color = Options.DoorESPColor.Value }, true) end
		end

		local LastDoorFire = tick()
		local DoorConn = Services.RunService.Heartbeat:Connect(function()
			if Object:FindFirstChild("Door") and Object:FindFirstChild("ClientOpen") then
				if LocalPlayer:DistanceFromCharacter(Object.Door.Position) < 150
					and tick() - LastDoorFire > 0.05
					and Toggles.DoorReachToggle.Value
				then
					Object.ClientOpen:FireServer()
					LastDoorFire = tick()
				end
			end
		end)
		Object:WaitForChild("Door").Open.Played:Once(function()
			DoorConn:Disconnect()
		end)
		table.insert(Connections, DoorConn)

	elseif Name == "PathLights" then
		local ObjectsToHighlight = {}
		local PLConn = Object.ChildAdded:Connect(function(Child)
			table.insert(ObjectsToHighlight, Child)
		end)
		for _, Child in Object:GetChildren() do
			table.insert(ObjectsToHighlight, Child)
		end

		local function CreateSeekNode(Light)
			if Light.Name ~= "SeekGuidingLight" or Light:GetAttribute("Highlighted") then return end
			Light:SetAttribute("Highlighted", true)

			local NewNode = Instance.new("Part")
			NewNode.Size = Vector3.one
			NewNode.Transparency = 1
			NewNode.Parent = Globals.SeekNodesFolder
			NewNode.Anchored = true
			NewNode.CFrame = Light.CFrame
			NewNode.CanCollide = false
			NewNode.Name = "SeekLightNode"

			local PrevNode2 = PreviousNode or NewNode
			PreviousNode = NewNode

			local Beam = Instance.new("Beam")
			Beam.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Options.ShowSeekPathColor.Value), ColorSequenceKeypoint.new(1, Options.ShowSeekPathColor.Value) })
			Beam.FaceCamera = true
			Beam.Width0 = 0.2
			Beam.Width1 = 0.2
			Beam.Brightness = 10
			Beam.LightInfluence = 0
			Beam.LightEmission = 0
			Beam.Enabled = true
			local Vis = Toggles.ShowSeekPathToggle.Value and 0 or 1
			Beam.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, Vis), NumberSequenceKeypoint.new(1, Vis) })
			Beam.Parent = Globals.SeekNodesFolder
			local A0 = Instance.new("Attachment", NewNode)
			local A1 = Instance.new("Attachment", PrevNode2)
			Beam.Attachment0 = A0
			Beam.Attachment1 = A1
			table.insert(Objects.SeekHighlights, Beam)
		end

		task.spawn(function()
			while task.wait() do
				local Light = table.remove(ObjectsToHighlight, 1)
				if Light then CreateSeekNode(Light) end
			end
		end)

		table.insert(Connections, PLConn)
		Object.Destroying:Once(function() PLConn:Disconnect() end)

	elseif Name == "Bridge" then
		for _, Child in Object:GetChildren() do
			if Child.Name == "PlayerBarrier" and Child.Size.Y == 2.75 and (Child.Rotation.X == 0 or Child.Rotation.X == 180) then
				local NewBridge = Child:Clone()
				NewBridge.CFrame = NewBridge.CFrame * CFrame.new(0, 0, -5)
				NewBridge.Name = Abysall.ESPLibrary:GenerateRandomString()
				NewBridge.Size = Vector3.new(NewBridge.Size.X, NewBridge.Size.Y, 11)
				NewBridge.Parent = Object
				NewBridge.CanCollide = Toggles.BypassSeekObstructions.Value
				NewBridge.Color = Color3.fromRGB(0, 255, 255)
				NewBridge.Transparency = Toggles.BypassSeekObstructions.Value and 0 or 1
				NewBridge.Material = Enum.Material.ForceField
				table.insert(Objects.SeekBridges, NewBridge)
			end
			task.wait()
		end

	elseif Name == "RunnerNodes" then
		local function IsBehind(Part1, Part2)
			local P1 = (Part1.CFrame + Part1.CFrame.LookVector).Position
			local P2 = (Part1.CFrame + Part1.CFrame.LookVector * -1).Position
			return (P1 - Part2.Position).Magnitude > (P2 - Part2.Position).Magnitude
		end
		local function GetDirection(Part1, Part2)
			local RightDist = Part1.CFrame.RightVector:Dot(Part1.Position - Part2.Position)
			if RightDist > 0.5    then return IsBehind(Part1, Part2) and "Right" or "Left" end
			if RightDist < -0.5   then return IsBehind(Part1, Part2) and "Left" or "Right" end
			return "Straight"
		end
		local function GetClosestNode(Node)
			local Best, BestDist = nil, math.huge
			local NodeID2 = tonumber(Node.Name:split("MinecartNode")[2])
			for _, OtherNode in Object:GetChildren() do
				local OtherID = tonumber(OtherNode.Name:split("MinecartNode")[2])
				if OtherNode ~= Node and OtherID and NodeID2 and OtherID > NodeID2 then
					local D = (Node.Position - OtherNode.Position).Magnitude
					if D < BestDist and OtherNode:GetAttribute("DistanceBlacklist") ~= true then
						BestDist = D Best = OtherNode
					end
				end
			end
			return Best
		end

		for _, Node in Object:GetChildren() do
			local NodeID = tonumber(Node.Name:split("MinecartNode")[2])
			if Node:GetAttribute("DeathType") then Node:SetAttribute("DistanceBlacklist", true) end
			for I = 1, 20 do
				local NextNode = NodeID and Object:FindFirstChild("MinecartNode" .. NodeID + I)
				if NextNode and NextNode:GetAttribute("DeathType") ~= nil then
					Node:SetAttribute("DistanceBlacklist", true)
				end
			end
			local PrevNode3 = NodeID and Object:FindFirstChild("MinecartNode" .. NodeID - 1)
			if PrevNode3 and PrevNode3:GetAttribute("ForceConnect") then
				Node:SetAttribute("DistanceBlacklist", nil)
			end
			task.wait()
		end

		for _, Node in Object:GetChildren() do
			if Node:GetAttribute("ForceConnect") then
				local NextNode = GetClosestNode(Node)
				if NextNode then
					Node:SetAttribute("Turn", GetDirection(Node, NextNode))
					table.insert(Objects.SeekNodes, Node)
				end
			end
			task.wait()
		end

	elseif Name == "EyestalkEndCutscene" then
		Object.Name = "_EyestalkEndCutscene"
	elseif Name == "DuckBoard" then
		table.insert(Objects.SeekDuckBoards, Object)
	elseif HidingSpotLabels[Name] then
		if Toggles.HidingSpotESPToggle.Value then Functions.AddESP({ Object = Object, Text = HidingSpotLabels[Name], Color = Options.HidingSpotESPColor.Value }, true) end
		Functions.HandleHidingTransparency(Object)
		table.insert(Objects.HidingSpots, Object)
	elseif Name == "Lava" then
		if Toggles.BypassKillbricks.Value then Object.CanTouch = false end
		table.insert(Objects.Obstructions, Object)
	elseif Name == "ScaryWall" then
		for _, Part in Object:GetDescendants() do
			if Part:IsA("BasePart") then
				Part.CanTouch = not Toggles.BypassSeekingWall.Value
				Part.CanCollide = not Toggles.BypassSeekingWall.Value
			end
		end
		table.insert(Objects.Obstructions, Object)
	elseif Name == "ChestBox" or Name == "ChestBoxLocked" then
		if Toggles.ChestESPToggle.Value then Functions.AddESP({ Object = Object, Text = Object:GetAttribute("Locked") and "Locked Chest" or "Chest", Color = Options.ChestESPColor.Value }, true) end
		table.insert(Objects.Chests, Object)
	elseif Name == "Toolbox" or Name == "Toolbox_Locked" then
		if Toggles.ChestESPToggle.Value then Functions.AddESP({ Object = Object, Text = Object:GetAttribute("Locked") and "Locked Toolbox" or "Toolbox", Color = Options.ChestESPColor.Value }, true) end
		table.insert(Objects.Chests, Object)
	elseif Name == "Chest_Vine" then
		if Toggles.ChestESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Vine Chest", Color = Options.ChestESPColor.Value }, true) end
		table.insert(Objects.Chests, Object)
	elseif Name == "Toolshed_Small" then
		if Toggles.ChestESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Toolshed", Color = Options.ChestESPColor.Value }, true) end
		table.insert(Objects.Chests, Object)
	elseif Name == "Locker_Small_Locked" then
		if Toggles.ChestESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Locked Item Locker", Color = Options.ChestESPColor.Value }, true) end
		table.insert(Objects.Chests, Object)
	elseif Name == "MouseHole" then
		if Toggles.ChestESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Mouse", Color = Options.ChestESPColor.Value }, true) end
		table.insert(Objects.Chests, Object)
	elseif ItemNames[Name] and Object:FindFirstChild("ModulePrompt") then
		if Toggles.ItemESPToggle.Value then Functions.AddESP({ Object = Object, Text = ItemNames[Name], Color = Options.ItemESPColor.Value }, Object:GetAttribute("ParentRoom") ~= nil) end
		if Name == "LotusHolder" or Name == "LotusPetalPickup" then
			Object.Handle:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
				Abysall.ESPLibrary:RemoveESP(Object)
				Abysall.ESPLibrary:BlacklistESP(Object)
			end)
		end
		table.insert(Objects.Items, Object)
	elseif Name == "Green_Herb" then
		if Toggles.ItemESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Green Herb", Color = Options.ItemESPColor.Value }, true) end
		table.insert(Objects.Items, Object)
	elseif Name == "GoldPile" and Object:GetAttribute("GoldValue") then
		if Toggles.CurrencyESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Gold Pile [" .. Object:GetAttribute("GoldValue") .. "]", Color = Options.CurrencyESPColor.Value }, true) end
		table.insert(Objects.Currency, Object)
	elseif Name == "StardustPickup" then
		if Toggles.CurrencyESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Stardust Pile", Color = Options.CurrencyESPColor.Value }, true) end
		table.insert(Objects.Currency, Object)
	elseif Name == "GiggleCeiling" then
		if Toggles.EntityESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Giggle", Color = Options.EntityESPColor.Value }, true) end
		if Toggles.BypassGiggle.Value then Object:WaitForChild("Hitbox").CanTouch = false end
		table.insert(Objects.Entities, Object)
	elseif Name == "GloomPile" then
		if Toggles.BypassGloombatEggs.Value then
			for _, Part in Object:GetDescendants() do
				if Part:IsA("BasePart") then Part.CanTouch = false end
			end
		end
		if Toggles.EntityESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Gloombat Eggs", Color = Options.EntityESPColor.Value }, true) end
		table.insert(Objects.Entities, Object)
	elseif Name == "TriggerEventCollision" and Functions.CheckCompatability({"firetouchinterest"}) then
		if (Floor == "Fools" or Floor == "OldHotel") and Toggles.RemoveSeekTrigger.Value then
			task.spawn(function()
				while Object:IsDescendantOf(game) do
					for _, Part in Object:GetChildren() do
						if Part:IsA("BasePart") then
							Abysall.Environment.firetouchinterest(RootPart, Part, 0)
							task.wait()
							Abysall.Environment.firetouchinterest(RootPart, Part, 1)
						end
					end
					task.wait()
				end
			end)
		end
		table.insert(Objects.EventTriggers, Object)
	elseif Name == "DoorFake" or Name == "FakeDoor" then
		if Object.Parent and Object:FindFirstChild("Hidden") then
			if Toggles.BypassDupe.Value then
				Object:WaitForChild("Hidden").CanTouch = false
				local Lock = Object:FindFirstChild("Lock")
				if Lock and Lock:FindFirstChild("UnlockPrompt") then Lock.UnlockPrompt.Enabled = false end
			end
			table.insert(Objects.Entities, Object)
		end
	elseif Name == "SideroomSpace" then
		if Toggles.BypassVacuum.Value then
			Object:WaitForChild("Collision").CanCollide = true
			Object:WaitForChild("Collision").CanTouch = false
		end
		table.insert(Objects.Entities, Object)
	elseif Name == "Snare" then
		if Object:FindFirstChild("Snare") then
			Object.Snare.Roots.Transparency = 1
			Object.Snare.SnareBase.Transparency = 1
		end
		if Object:FindFirstChild("Void") then
			Object.Void.Transparency = 0
			Object.Void.Color = Color3.fromRGB(76, 67, 55)
		end
		if Toggles.EntityESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Snare", Color = Options.EntityESPColor.Value }, true) end
		if Toggles.BypassSnare.Value and Object:FindFirstChild("Hitbox") then Object.Hitbox.CanTouch = false end
		table.insert(Objects.Entities, Object)
	elseif Name == "Seek_Arm" or Name == "ChandelierObstruction" then
		for _, Part in Object:GetDescendants() do
			if Part:IsA("BasePart") then
				Part.CanTouch = not Toggles.BypassSeekObstructions.Value
				table.insert(Objects.SeekObstructions, Part)
			end
		end
	elseif Name == "SeekFloodline" then
		Object.CanCollide = Toggles.BypassSeekObstructions.Value
		local FloodConn = Object:GetPropertyChangedSignal("CanCollide"):Connect(function()
			if Object.CanCollide ~= Toggles.BypassSeekObstructions.Value then
				Object.CanCollide = Toggles.BypassSeekObstructions.Value
			end
		end)
		Object.Destroying:Once(function() FloodConn:Disconnect() end)
		table.insert(Objects.SeekObstructions, Object)
	elseif Object:GetAttribute("RawName") and Object:GetAttribute("RawName"):find("Halt") or Object:GetAttribute("Shade") == true then
		if Toggles.NotifyEntities.Value and Options.EntityList.Value["Halt"] then
			Functions.Notify({ Title = "Entity 'Halt' will spawn in the next room.", Image = EntityIcons["Halt"] })
			if Toggles.EntityChatToggle.Value then Functions.SendChat("Halt next room!") end
		end
		local HaltLogConn
		HaltLogConn = Services.LogService.MessageOut:Connect(function(Message)
			if Message == "client teleporting" then
				if Globals.AnticheatDisabled then
					Globals.AnticheatDisabled = false
					Functions.Notify({ Title = "The anticheat has been re-enabled.", Body = "Interact with a ladder to disable it again." })
				end
				HaltLogConn:Disconnect()
			end
		end)
	elseif Name == "BananaPeel" then
		if Toggles.BypassBanana.Value then Object.CanTouch = false end
		table.insert(Objects.Entities, Object)
	elseif Name == "JeffTheKiller" then
		if Toggles.BypassJeff.Value then
			task.wait(1)
			for _, Part in Object:GetDescendants() do
				if Part:IsA("BasePart") then Part.CanCollide = false Part.CanTouch = false end
			end
			Object:WaitForChild("Humanoid").Health = 0
		end
	elseif Name == "GrumbleRig" then
		if Toggles.EntityESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Grumble", Color = Options.EntityESPColor.Value }, true) end
		table.insert(Objects.Entities, Object)
	elseif Name == "Drakobloxxer" then
		if Toggles.EntityESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Drakobloxxer", Color = Options.EntityESPColor.Value }, true) end
		table.insert(Objects.Entities, Object)
	elseif Name == "LiveEntityBramble" then
		if Toggles.EntityESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Bramble", Color = Options.EntityESPColor.Value }, true) end
		table.insert(Objects.Entities, Object)
	elseif Name == "Groundskeeper" then
		if Toggles.EntityESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Groundskeeper", Color = Options.EntityESPColor.Value }, true) end
		if Toggles.NotifyEntities.Value and Options.EntityList.Value["Groundskeeper"] then
			local ED = Entities["Groundskeeper"]
			Functions.Notify({ Title = ED.NotifyMessage.Title, Body = ED.NotifyMessage.Body, Image = EntityIcons["Groundskeeper"] })
		end
		table.insert(Objects.Entities, Object)
	elseif Name == "Figure" or Name == "FigureRig" or Name == "FigureRagdoll" then
		if Toggles.EntityESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Figure", Color = Options.EntityESPColor.Value }, true) end
		table.insert(Objects.Entities, Object)
		if Toggles.RemoveFigure.Value and Functions.CheckCompatability({"isnetworkowner"}) then
			if Floor == "Mines" then
				for _, Part in Object:GetDescendants() do
					if Part:IsA("BasePart") then
						task.spawn(function()
							if Abysall.Environment.isnetworkowner(Part) then
								Part.Position = Vector3.new(-49999, -49999, -49999)
							end
						end)
					end
				end
			elseif Floor == "OldHotel" or Floor == "Fools" then
				CurrentRooms.ChildAdded:Wait()
				task.wait(2.5)
				for _, Part in Object:GetDescendants() do
					if Part:IsA("BasePart") then
						task.spawn(function()
							while Abysall.Environment.isnetworkowner(Part) do
								Part.Position = Vector3.new(math.random(-29999,29999), math.random(-29999,29999), math.random(-29999,29999))
								task.wait()
							end
						end)
					end
				end
			end
		end
	elseif (Name == "ThingToOpen" or Name == "MovingDoor") and (Floor == "Fools" or Floor == "OldHotel")
		or Name == "Wax_Door" and Floor == "Fools"
	then
		Object:SetAttribute("OriginalPosition", Object:GetPivot())
		local ToggleMap = { ThingToOpen = "RemoveBasementGate", MovingDoor = "RemovePaintingsDoor", Wax_Door = "RemoveSkeletonDoor" }
		if ToggleMap[Name] and Toggles[ToggleMap[Name]].Value then
			Object:PivotTo(CFrame.new(-10000, -10000, -10000))
		end
		table.insert(Objects.Obstructions, Object)
	elseif Name == "ElevatorBreaker" then
		if Toggles.AutoBreakerBox.Value and not Globals.BreakerBoxNotified then
			Functions.Notify({ Title = "Interact with the breaker box.", Body = "It will be automatically solved." })
			Globals.BreakerBoxNotified = true
		end
		Connections.BreakerConnection = Object:WaitForChild("SurfaceGui").Frame.Code:GetPropertyChangedSignal("Text"):Connect(function()
			if Toggles.AutoBreakerBox.Value then
				if not Globals.BreakerBoxStartNotified and (Floor == "Fools" or Floor == "OldHotel") then
					Functions.Notify({ Title = "Attempting to solve the breaker box.", Body = "Please wait." })
					Globals.BreakerBoxStartNotified = true
				end
				RemotesFolder.EBF:FireServer()
			end
			Globals.BreakerBoxInteracted = true
		end)
	elseif Name == "ElevatorCar" then
		local ElevConn = Object.DescendantAdded:Connect(function(Desc)
			if Toggles.AutoBreakerBox.Value and Desc.Name == "TouchInterest" and not Globals.BreakerBoxFinishedNotified then
				Functions.Notify({ Title = "Successfully solved the breaker box.", Body = "Try going to the elevator!" })
				Globals.BreakerBoxFinishedNotified = true
			end
		end)
		Object.Destroying:Once(function() ElevConn:Disconnect() end)
	elseif Object.ClassName == "ProximityPrompt" and not Object:GetAttribute("FakePrompt") then
		if Object:HasTag("DisableWhenEnabledOnClient") then Object:RemoveTag("DisableWhenEnabledOnClient") end

		Object:SetAttribute("HoldDuration_Old", Object.HoldDuration)
		Object:SetAttribute("RequiresLineOfSight_Old", Object.RequiresLineOfSight)
		Object:SetAttribute("MaxActivationDistance_Old", Object.MaxActivationDistance)

		local LockPromptNames = { UnlockPrompt=true, SkullPrompt=true, LockPrompt=true, ThingToEnable=true, FusesPrompt=true }

		if Functions.CheckCompatability({"fireproximityprompt"}) and Floor ~= "OldHotel" and Floor ~= "Fools" then
			local IsLockPrompt = LockPromptNames[Object.Name]
				or (Object.Parent and Object.Parent:GetAttribute("Locked") == true)
				or (Object.Parent and Object.Parent.Parent and Object.Parent.Parent.Name == "Locker_Small_Locked" and Object.Name == "ActivateEventPrompt")

			if IsLockPrompt then
				local FakePrompt = Object:Clone()
				FakePrompt:SetAttribute("FakePrompt", true)
				task.wait()
				FakePrompt.Parent = Object.Parent

				FakePrompt:SetAttribute("HoldDuration_Old", Object:GetAttribute("HoldDuration_Old"))
				FakePrompt:SetAttribute("RequiresLineOfSight_Old", Object:GetAttribute("RequiresLineOfSight_Old"))
				FakePrompt:SetAttribute("MaxActivationDistance_Old", Object:GetAttribute("MaxActivationDistance_Old"))

				FakePrompt.HoldDuration = Object.HoldDuration
				FakePrompt.RequiresLineOfSight = Object.RequiresLineOfSight
				FakePrompt.MaxActivationDistance = Object.MaxActivationDistance

				if Toggles.InstantPrompts.Value    then FakePrompt.HoldDuration = 0 end
				if Toggles.PromptClip.Value        then FakePrompt.RequiresLineOfSight = false end
				FakePrompt.MaxActivationDistance = FakePrompt:GetAttribute("MaxActivationDistance_Old") * Options.PromptReachSlider.Value

				FakePrompts[FakePrompt] = Object
				pcall(function() Object.Parent = Globals.PromptContainer end)

				local FPEnabledConn = Object:GetPropertyChangedSignal("Enabled"):Connect(function()
					FakePrompt.Enabled = Object.Enabled
				end)
				Object:GetPropertyChangedSignal("ActionText"):Once(function()
					Object.Parent = FakePrompt.Parent
					FakePrompt:Destroy()
					FPEnabledConn:Disconnect()
				end)
				Object.Destroying:Once(function()
					FakePrompt:Destroy()
					FPEnabledConn:Disconnect()
				end)
				table.insert(Connections, FPEnabledConn)
				table.insert(Objects.Prompts, FakePrompt)

				FakePrompt.Enabled = false
				task.wait()
				FakePrompt.Enabled = Object.Enabled
			end
		end

		table.insert(Objects.Prompts, Object)
		if Toggles.InstantPrompts.Value    then Object.HoldDuration = 0 end
		if Toggles.PromptClip.Value        then Object.RequiresLineOfSight = false end
		Object.MaxActivationDistance = Object:GetAttribute("MaxActivationDistance_Old") * Options.PromptReachSlider.Value

	elseif Name == "Padlock" then
		Connections.PadlockConnection = Services.RunService.Heartbeat:Connect(function()
			if Object.PrimaryPart then
				local Distance = LocalPlayer:DistanceFromCharacter(Object.PrimaryPart.Position)
				if Toggles.AutoUnlockPadlockToggle.Value then
					local Code = Functions.GetLibraryCode()
					if Code and tonumber(Code) and Distance < Options.AutoUnlockPadlockSlider.Value then
						RemotesFolder.PL:FireServer(Code)
					end
				end
				if Toggles.AutoLibraryGuessCode.Value and LatestRoom.Value == 50 then
					local Code = Functions.GetRandomCode()
					if Code then RemotesFolder.PL:FireServer(Code) end
				end
			end
		end)
		Object.Destroying:Once(function()
			if Connections.PadlockConnection then
				Connections.PadlockConnection:Disconnect()
				Connections.PadlockConnection = nil
			end
		end)
	end
end

Connections.PromptAnimationFixer1 = Services.ProximityPromptService.PromptButtonHoldBegan:Connect(function(Object)
	if not Object:GetAttribute("FakePrompt") then return end
	local ToolNames = { "Lockpick","Shears","SkeletonKey","Key","KeyElectrical","KeyBackdoor","KeyIron" }
	local Tool
	for _, N in ToolNames do Tool = Character:FindFirstChild(N) if Tool then break end end
	if Tool and Globals.UseAnimation then
		Globals.UseAnimationBreak:Stop()
		Globals.UseAnimation:Stop()
		Globals.UseAnimation:Play()
		if Tool.Name == "Shears" then Tool:WaitForChild("Handle"):WaitForChild("sound_prompt"):Play() end
	end
end)

for _, Object in Services.Workspace:GetDescendants() do
	task.spawn(function() Functions.HandleObject(Object) end)
end

Connections.InstanceHandler = Services.Workspace.DescendantAdded:Connect(function(Object)
	Functions.HandleObject(Object)
end)

for _, Player in Services.Players:GetPlayers() do
	if Player ~= LocalPlayer then
		if Player.Character and Toggles.PlayerESPToggle.Value then
			Functions.AddESP({ Object = Player.Character, Text = Player.Name, Color = Options.PlayerESPColor.Value })
		end
		local CharConn = Player.CharacterAdded:Connect(function(NewCharacter)
			if Toggles.PlayerESPToggle.Value then
				Functions.AddESP({ Object = NewCharacter, Text = Player.Name, Color = Options.PlayerESPColor.Value })
			end
		end)
		local DeadConn = Player:GetAttributeChangedSignal("Alive"):Connect(function()
			if Player:GetAttribute("Alive") ~= true and Player.Character then
				Functions.RemoveESP(Player.Character)
			end
		end)
		table.insert(Connections, CharConn)
		table.insert(Connections, DeadConn)
		Player.Destroying:Once(function()
			CharConn:Disconnect()
			DeadConn:Disconnect()
		end)
	end
end

Connections.PlayerHandler = Services.Players.PlayerAdded:Connect(function(Player)
	if Player == LocalPlayer then return end
	if Player.Character and Toggles.PlayerESPToggle.Value then
		Functions.AddESP({ Object = Player.Character, Text = Player.Name, Color = Options.PlayerESPColor.Value })
	end
	local CharConn = Player.CharacterAdded:Connect(function(NewCharacter)
		if Toggles.PlayerESPToggle.Value then
			Functions.AddESP({ Object = NewCharacter, Text = Player.Name, Color = Options.PlayerESPColor.Value })
		end
	end)
	local DeadConn = Player:GetAttributeChangedSignal("Alive"):Connect(function()
		if Player:GetAttribute("Alive") ~= true and Player.Character then
			Functions.RemoveESP(Player.Character)
		end
	end)
	table.insert(Connections, CharConn)
	table.insert(Connections, DeadConn)
	Player.Destroying:Once(function()
		CharConn:Disconnect()
		DeadConn:Disconnect()
	end)
end)

local PromptsToFire = {}
local PromptCooldown = {}

Functions.FirePrompt      = Abysall.Environment.fireproximityprompt
Functions.ForceFirePrompt = Abysall.Environment.fireproximityprompt

if not Functions.FirePrompt then
	Functions.FirePrompt = function(Prompt)
		if not Prompt:IsA("ProximityPrompt") or PromptCooldown[Prompt] or table.find(PromptsToFire, Prompt) or not Camera then return end
		table.insert(PromptsToFire, Prompt)
	end
	Functions.ForceFirePrompt = Functions.FirePrompt

	task.spawn(function()
		while task.wait() do
			local Prompt = table.remove(PromptsToFire, 1)
			if not Prompt then continue end
			PromptCooldown[Prompt] = true

			local OldDist   = Prompt.MaxActivationDistance
			local OldEnable = Prompt.Enabled
			local OldParent = Prompt.Parent
			local OldHold   = Prompt.HoldDuration
			local OldLOS    = Prompt.RequiresLineOfSight

			Prompt.MaxActivationDistance = 99999
			Prompt.Enabled = true
			Prompt.HoldDuration = 0
			Prompt.RequiresLineOfSight = false

			local TempPart = Instance.new("Part")
			TempPart.Parent = Services.Workspace
			TempPart.CanCollide = false TempPart.CanQuery = false TempPart.CanTouch = false
			TempPart.Anchored = true TempPart.Transparency = 1
			TempPart.Size = Vector3.new(0.001, 0.001, 0.001)
			TempPart.Position = Camera.CFrame:ToWorldSpace(CFrame.new(0, 0, -0.1)).Position

			if not Prompt or not OldParent then
				TempPart:Destroy()
				PromptCooldown[Prompt] = nil
				continue
			end

			pcall(function() Prompt.Parent = TempPart end)

			local Shown, Fired = false, false

			local ShownConn = Services.ProximityPromptService.PromptShown:Connect(function(P)
				if P == Prompt then Shown = true end
			end)
			local FiredConn = Prompt.Triggered:Connect(function() Fired = true end)

			local T1 = 0
			while not Shown and T1 < 5 do T1 += 1 task.wait() end

			local T2 = 0
			while not Fired and T2 < 5 do
				Prompt:InputHoldBegin()
				Prompt:InputHoldEnd()
				T2 += 1 task.wait()
			end

			Prompt.MaxActivationDistance = OldDist
			Prompt.Enabled = OldEnable
			Prompt.HoldDuration = OldHold
			Prompt.RequiresLineOfSight = OldLOS
			pcall(function() Prompt.Parent = OldParent end)
			task.wait()
			PromptCooldown[Prompt] = nil
			TempPart:Destroy()
			ShownConn:Disconnect()
			FiredConn:Disconnect()
		end
	end)
end

local AutoInteractBlacklist = {
	HidePrompt=true, RiftPrompt=true, StarRiftPrompt=true, InteractPrompt=true, ClimbPrompt=true,
	DonatePrompt=true, DialoguePrompt=true, RevivePrompt=true, EnterPrompt=true, AnimatePrompt=true,
	ToolEventPrompt=true, Prompt=true, PropPrompt=true
}

local TriggerDebounce = false

Functions.TriggerPrompt = function(Prompt)
	if AutoInteractBlacklist[Prompt.Name] then return end
	if not Prompt or not Prompt.Parent then return end
	if TriggerDebounce then return end

	local ParentItem = Functions.HasItem(Prompt.Parent.Name)
	if ParentItem and ParentItem:GetAttribute("Durability") and ParentItem:GetAttribute("DurabilityMax")
		and ParentItem:GetAttribute("Durability") >= ParentItem:GetAttribute("DurabilityMax")
	then return end

	local IsLockPrompt = Prompt.Name == "UnlockPrompt" or Prompt.Name == "SkullPrompt"
		or (Prompt.Parent:GetAttribute("Locked") == true and Prompt.Name == "ActivateEventPrompt")
		or (Prompt.Parent.Parent and Prompt.Parent.Parent:GetAttribute("Locked") == true and Prompt.Name == "ActivateEventPrompt")
		or Prompt.Parent.Name == "Lock1" or Prompt.Parent.Name == "Lock2"

	if IsLockPrompt then
		if Options.AutoInteractIgnoreList.Value["Locks"] then return end
		local KeyItems = { "Key","KeyBackdoor","KeyElectrical","KeyIron","Lockpick","SkeletonKey","Shears","Multitool" }
		local HasKey = false
		for _, K in KeyItems do if Functions.HasItem(K, true) then HasKey = true break end end
		if not HasKey then return end
	end

	if Prompt.Parent.Name == "GlitchCube" and Options.AutoInteractIgnoreList.Value["Glitch Fragments"] then return end

	if (Prompt.Parent.Name == "KeyObtain" and (Functions.HasItem("Key") or Functions.HasItem("KeyBackdoor")))
		or (Prompt.Parent.Name == "ElectricalKeyObtain" and Functions.HasItem("KeyElectrical"))
	then return end

	if Prompt:IsDescendantOf(Drops) and Options.AutoInteractIgnoreList.Value["Dropped Items"] then return end
	if Prompt.Parent.Name == "TrackLever" then return end
	if Prompt.Name == "ActivateEventPrompt" and (Prompt.ActionText == "Close"
		or Prompt.Parent.Name == "ElevatorBreaker"
		or (Prompt.Parent.Parent and Prompt.Parent.Parent.Name == "IndustrialGate"))
	then return end
	if Prompt.Name == "ActivateEventPrompt" and (Prompt.Parent.Name == "Padlock" or Prompt.Parent.Name == "MinesAnchor") then return end
	if Prompt.Parent.Name == "LeverForGate" and Prompt:GetAttribute("Interactions") then return end
	if Prompt.Parent.Parent and (Prompt.Parent.Parent.Name == "DoorFake" or Prompt.Parent.Parent.Name == "FakeDoor") then return end
	if Prompt.Parent:GetAttribute("JeffShop") and Options.AutoInteractIgnoreList.Value["Jeff Items"] then return end
	if Prompt:GetAttribute("AutoInteractIgnore") then return end
	if Prompt.Name == "PushPrompt" and Options.AutoInteractIgnoreList.Value["Minecarts"] then return end
	if (Prompt.Parent.Name == "GoldPile" or Prompt.Parent.Name == "StardustPickup") and Options.AutoInteractIgnoreList.Value["Currency"] then return end

	if Prompt.Parent.Name == "Bandage" then
		if Humanoid.Health >= Humanoid.MaxHealth then return end
		local BPack = Functions.HasItem("BandagePack")
		if BPack and BPack:GetAttribute("Durability") >= BPack:GetAttribute("DurabilityMax") then return end
	end

	if Prompt.Parent.Name == "Battery" then
		local Tool = Character:FindFirstChildOfClass("Tool")
		if not Tool then return end
		local BPack = Functions.HasItem("BatteryPack")
		if BPack and BPack:GetAttribute("Durability") >= BPack:GetAttribute("DurabilityMax") then return end
		if Tool:GetAttribute("LightSource") then
			if Tool:GetAttribute("Durability") and Tool:GetAttribute("DurabilityMax")
				and Tool:GetAttribute("Durability") > Tool:GetAttribute("DurabilityMax")
			then return end
		else
			return
		end
	end

	if Prompt.Name == "HerbPrompt" then
		local Effects = Globals.MainUI.MainFrame.Healthbar:FindFirstChild("Effects")
		if Effects and Effects.HerbGreenEffect.Visible then return end
	end

	if (Prompt.Parent.Name == "LibraryHintPaper" or Prompt.Parent.Name == "PickupItem") and (Functions.HasItem("LibraryHintPaper") or Functions.HasItem("LibraryHintPaperHard")) then return end
	if Prompt.Parent.Name == "AlarmClock" and Functions.HasItem("AlarmClock") then return end
	if Prompt.Parent.Name == "KeyObtainFake" then return end

	Functions.FirePrompt(Prompt)
	TriggerDebounce = true
	if Floor == "OldHotel" then task.wait() end
	TriggerDebounce = false
end

local LastAutoInteractFire = tick()
Connections.AutoInteract = Services.RunService.Heartbeat:Connect(function()
	local Active = Toggles.AutoInteractToggle.Value or Options.AutoInteractKeybind:GetState()
	if not Active or tick() - LastAutoInteractFire <= 0.035 then return end

	for _, Prompt in Objects.Prompts do
		if Prompt.Parent and (Prompt.Parent:IsA("BasePart") or Prompt.Parent:IsA("Model")) then
			local Distance
			if Prompt.Parent:IsA("BasePart") then
				Distance = LocalPlayer:DistanceFromCharacter(Prompt.Parent.Position)
			else
				Distance = LocalPlayer:DistanceFromCharacter(Prompt.Parent:GetPivot().Position)
			end
			if Distance <= Prompt.MaxActivationDistance and Prompt.Enabled then
				task.spawn(Functions.TriggerPrompt, Prompt)
			end
		end
	end
	LastAutoInteractFire = tick()
end)

Connections.InfiniteItemsHandler = Services.ProximityPromptService.PromptTriggered:Connect(function(Object)
	if not Object:GetAttribute("FakePrompt") then return end

	local ToolNames = { "Lockpick","Shears","SkeletonKey","Key","KeyElectrical","KeyBackdoor","KeyIron" }
	local Tool
	for _, N in ToolNames do Tool = Character:FindFirstChild(N) if Tool then break end end

	if Tool and Globals.UseAnimation and Globals.UseAnimationBreak then
		Globals.UseAnimation:Stop()
		Globals.UseAnimationBreak:Stop()
		Globals.UseAnimationBreak:Play()
		if Tool.Name == "Shears" then Tool:WaitForChild("Handle"):WaitForChild("sound_prompt"):Play() end
	end

	local AnyTool = Character:FindFirstChildOfClass("Tool")
	local ToolData = AnyTool and ItemNames[AnyTool.Name]
	if AnyTool and ToolData and Toggles.InfiniteItemsToggle.Value and Options.InfiniteItemsList.Value[ToolData] then
		Drops.ChildAdded:Once(function(NewTool)
			local Prompt = NewTool:FindFirstChild("ModulePrompt")
			local RealPrompt = FakePrompts[Object]
			Functions.FirePrompt(Prompt)
			Functions.FirePrompt(RealPrompt)
		end)
		Character.ChildAdded:Once(function(NewTool)
			if NewTool.Name == "Shears" then NewTool:WaitForChild("Handle"):WaitForChild("sound_promptend"):Play() end
		end)
		RemotesFolder.DropItem:FireServer(AnyTool)
	else
		local RealPrompt = FakePrompts[Object]
		Functions.FirePrompt(RealPrompt)
	end
end)

Connections.FloorReplicatedHandler = FloorReplicated.DescendantAdded:Connect(function(Object)
	if Object.Name == "GlitchScreech" then
		Modules.GlitchScreech = Object
		if Toggles.RemoveScreech.Value then Object.Name = "GlitchScreech_Disabled" end
	end
	if Object.Name:find("Jumpscare") and Object:IsA("ModuleScript")
		and not Object.Name:find("Eyestalk") and not Object.Name:find("Groundskeeper") and not Object.Name:find("Monument")
	then
		Object:SetAttribute("OriginalName", Object.Name)
		if Toggles.DisableEntityJumpscares.Value then Object.Name = Object.Name .. "_Disabled" end
		table.insert(Objects.JumpscareModules, Object)
	end
end)

if FloorReplicated:FindFirstChild("DigitalTimer") then
	Connections.HasteTimerConnection = FloorReplicated.DigitalTimer:GetPropertyChangedSignal("Value"):Connect(function()
		if Toggles.NotifyHasteTime.Value then Functions.Caption(Functions.GetHasteTime(), true) end
	end)
end

Connections.FogHandler = Services.Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
	if Services.Lighting.FogEnd ~= 10000000 then
		Globals.OldFog = Services.Lighting.FogEnd
	end
	if Toggles.RemoveCameraFog.Value then
		Services.Lighting.FogEnd = 10000000
	end
end)

Connections.FogHandler2 = Services.Lighting.DescendantAdded:Connect(function(Object)
	if not Object:IsA("Atmosphere") then return end
	Object:SetAttribute("Density_Old", Object.Density)
	if Toggles.RemoveCameraFog.Value then Object.Density = 0 end

	local AtmoConn2 = Object:GetPropertyChangedSignal("Density"):Connect(function()
		if Object.Density ~= 0 then Object:SetAttribute("Density_Old", Object.Density) end
		if Toggles.RemoveCameraFog.Value then Object.Density = 0 end
	end)
	Object.Destroying:Once(function() AtmoConn2:Disconnect() end)
	table.insert(Connections, AtmoConn2)
	table.insert(Globals.FogInstances, Object)
end)

local RusherAliases = { Rush=true, Ambush=true, Eyes=true, Lookman=true, Blitz=true, ["A-60"]=true, ["A-120"]=true, AR0xMBUSH=true, ["RNIUSHCG=="]=true, ["Custom Entity"]=true }

Connections.EntityHandler = Services.Workspace.ChildAdded:Connect(function(Entity)
	local EntityData = Entities[Entity.Name]
	if not EntityData then return end

	while not Entity.PrimaryPart do
		for _, Child in Entity:GetChildren() do
			if Child:IsA("BasePart") then Entity.PrimaryPart = Child end
		end
		task.wait()
	end
	task.wait(0.1)

	if LocalPlayer:DistanceFromCharacter(Entity.PrimaryPart.Position) >= 10000 then return end

	local Alias = EntityData.Alias
	if Options.EntityList.Value[Alias] and Toggles.NotifyEntities.Value then
		local NotifyTitle = EntityData.NotifyMessage.Title
		local NotifyBody  = EntityData.NotifyMessage.Body
		local NotifyImage = EntityIcons[Entity.Name]

		if Entity.Name == "RushMoving" and Entity.PrimaryPart.Name ~= "RushNew" then
			NotifyTitle = NotifyTitle:gsub("Rush", Entity.PrimaryPart.Name)
			NotifyImage = Entity.PrimaryPart:WaitForChild("Attachment").ParticleEmitter.Texture
			Alias = Entity.PrimaryPart.Name
		end

		Functions.Notify({ Title = NotifyTitle, Body = NotifyBody, Image = NotifyImage, Time = Toggles.NotifyKeepNotifications.Value and Entity or nil })

		if Toggles.EntityChatToggle.Value then
			Functions.SendChat(Alias .. " " .. Options.EntityChatMessage.Value)
		end
	end

	if Entity.Name ~= "GloombatSwarm" then
		if Toggles.EntityESPToggle.Value then
			Functions.AddESP({ Object = Entity, Text = Alias, Color = Options.EntityESPColor.Value })
		end
		table.insert(Objects.Entities, Entity)
	end

	if RusherAliases[EntityData.Alias] then
		Instance.new("Humanoid", Entity).Name = "HighlightHumanoid"
		local Root = Entity.PrimaryPart
		if Root then Root.Transparency = 0.99 end
	end

	if Entity.Name == "Lookman" then
		CurrentRooms.ChildAdded:Wait()
		task.wait(3)
		Entity:Destroy()
	end
end)

local LastClean = tick()
Connections.Cleaner = Services.RunService.Heartbeat:Connect(function()
	if tick() - LastClean <= 0.5 then return end
	LastClean = tick()

	for ArrayName, Array in Objects do
		local I = #Array
		while I >= 1 do
			local Object = Array[I]
			if Object == nil or not Object:IsDescendantOf(Services.Workspace) then
				table.remove(Array, I)
				local Conn = ESPConnections[Object]
				if Conn then
					Conn:Disconnect()
					ESPConnections[Object] = nil
					local Pos = table.find(Connections, Conn)
					if Pos then table.remove(Connections, Pos) end
				end
			end
			I -= 1
		end
	end
end)

local LastPromptFix = tick()
Connections.PromptFixer = Services.RunService.Heartbeat:Connect(function()
	if tick() - LastPromptFix <= 0.5 then return end
	LastPromptFix = tick()
	for _, Prompt in Objects.Prompts do
		if Prompt:HasTag("DisableWhenEnabledOnClient") then
			Prompt:RemoveTag("DisableWhenEnabledOnClient")
		end
	end
end)

if LocalPlayer.Character then
	task.spawn(function() Functions.HandleCharacter(LocalPlayer.Character) end)
end

LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
	if Connections.MainHandler then
		Connections.MainHandler:Disconnect()
		Connections.MainHandler = nil
	end
	task.wait(0.5)
	Functions.HandleCharacter(NewCharacter)
end)

Library:OnUnload(function()
	for Key, Connection in Connections do
		if type(Key) == "string" then
			pcall(function() Connection:Disconnect() end)
		else
			pcall(function() Key:Disconnect() end)
			pcall(function() Connection:Disconnect() end)
		end
	end

	for _, Object in Objects.Entities do
		if Object.Name == "Snare" or Object.Name == "GiggleCeiling" then
			local Hitbox = Object:FindFirstChild("Hitbox")
			if Hitbox then Hitbox.CanTouch = true end
		end
		if Object.Name == "GloomPile" then
			for _, Part in Object:GetDescendants() do
				if Part:IsA("BasePart") then Part.CanTouch = true end
			end
		end
		if Object.Name == "FakeDoor" or Object.Name == "DoorFake" then
			local Hidden = Object:FindFirstChild("Hidden")
			if Hidden then Hidden.CanTouch = true end
			local Lock = Object:FindFirstChild("Lock")
			if Lock and Lock:FindFirstChild("UnlockPrompt") then Lock.UnlockPrompt.Enabled = true end
		end
		if Object.Name == "SideroomSpace" then
			local Coll = Object:FindFirstChild("Collision")
			if Coll then Coll.CanCollide = false Coll.CanTouch = true end
		end
	end

	for _, Object in Objects.SeekBridges do Object:Destroy() end

	for _, Fog in Globals.FogInstances do
		Fog.Density = Fog:GetAttribute("Density_Old")
	end
	Services.Lighting.FogEnd = Globals.OldFog

	local Vignette = Globals.MainUI:FindFirstChild("HideVignette") or Globals.MainUI.MainFrame:FindFirstChild("HideVignette")
	if Vignette then Vignette.Image = "rbxassetid://6100076320" end

	local ModuleRestores = {
		Screech = "Screech", Glitch = "Glitch", Shade = "Shade",
		SpiderJumpscare = "SpiderJumpscare", A90 = "A90", Dread = "Dread", Void = "Void"
	}
	for Key, OriginalName in ModuleRestores do
		if Modules[Key] then Modules[Key].Name = OriginalName end
	end

	FakeEvents.Screech:Destroy()
	FakeEvents.Screech_Real.Parent = RemotesFolder
	FakeEvents.Shade:Destroy()
	FakeEvents.Shade_Real.Parent = RemotesFolder

	if FakeEvents.A90_Real then
		FakeEvents.A90:Destroy()
		FakeEvents.A90_Real.Parent = RemotesFolder
	end
	if FakeEvents.Surge_Real then
		FakeEvents.Surge:Destroy()
		FakeEvents.Surge_Real.Parent = RemotesFolder
	end

	Globals.SeekNodesFolder:Destroy()
	Globals.RoomsNodesFolder:Destroy()
	Globals.ManipulateBody:Destroy()

	local OldAmbient = CurrentRooms:FindFirstChild(tostring(LocalPlayer:GetAttribute("CurrentRoom"))):GetAttribute("Ambient")
	Services.TweenService:Create(Services.Lighting, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), { Ambient = OldAmbient }):Play()

	for _, Prompt in Objects.Prompts do
		if FakePrompts[Prompt] then
			FakePrompts[Prompt].Parent = Prompt.Parent
			Prompt:Destroy()
		end
		if Prompt.Parent then
			Prompt.HoldDuration = Prompt:GetAttribute("HoldDuration_Old") or Prompt.HoldDuration
			Prompt.RequiresLineOfSight = Prompt:GetAttribute("RequiresLineOfSight_Old") or Prompt.RequiresLineOfSight
			Prompt.MaxActivationDistance = Prompt:GetAttribute("MaxActivationDistance_Old") or Prompt.MaxActivationDistance
		end
	end

	Character:SetAttribute("CanJump",  OldJump)
	Character:SetAttribute("CanSlide", OldSlide)

	for _, Object in Services.Workspace:GetDescendants() do
		task.spawn(function() Functions.RemoveESP(Object) end)
	end

	Humanoid.WalkSpeed  = Functions.GetCurrentSpeed()
	Humanoid.JumpPower  = 5
	Humanoid.HipHeight  = 2.367

	local BaseY = 0.18
	Collision.Position          = RootPart.Position + Vector3.new(0, BaseY, 0)
	CollisionPart.Position      = RootPart.Position + Vector3.new(0, BaseY, 0)
	CollisionPartClone.Position = RootPart.Position + Vector3.new(0, BaseY, 0)

	if Character:FindFirstChild("LowerTorso") and Character.LowerTorso:FindFirstChild("Root") then
		Character.LowerTorso.Root.C1 = Globals.OriginalC1
	end
	if Collision:FindFirstChild("CollisionCrouch") then
		Collision.CollisionCrouch.Position = RootPart.Position + Vector3.new(0, -0.982, 0)
	end

	CollisionClone:Destroy()
	CollisionPartClone:Destroy()
	Abysall.ESPLibrary:Unload()

	if Main_Game then
		Main_Game.fovtarget   = 70
		Main_Game.spring.Speed = 8
		Main_Game.tooloffset   = Vector3.zero
	end

	getgenv().Abysall = nil
end)

while not Globals.MainUI do task.wait() end
Abysall.Interface.ApplySettingsTab(Window)
Functions.Notify({ Title = "Successfully loaded in " .. math.floor((tick() - LoadStart) * 1000) / 1000 .. " seconds." })
