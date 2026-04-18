local LoadStart = tick() + 0.5
if not Abysall then
local BaseUrl = "https://raw.githubusercontent.com/bocaj111004/Abysall/refs/heads/main/"
getgenv().Abysall = {
    Environment = loadstring(game:HttpGet(BaseUrl .. "Components/Environment.luau"))(),
    Interface = loadstring(game:HttpGet(BaseUrl .. "Components/Interface.luau"))(),
    ESPLibrary = loadstring(game:HttpGet(BaseUrl .. "Components/ESP.luau"))(),
}
end
Abysall.SavePath = "Doors"

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

local Entities = {
    ["RushMoving"] = {
        Alias = "Rush",
        NotifyMessage = {
            Title = "Entity 'Rush' has spawned.",
            Body = "Find a hiding spot."
        }
    },
    ["AmbushMoving"] = {
        Alias = "Ambush",
        NotifyMessage = {
            Title = "Entity 'Ambush' has spawned.",
            Body = "Find a hiding spot."
        }
    },
    ["Eyes"] = {
        Alias = "Eyes",
        NotifyMessage = {
            Title = "Entity 'Eyes' has spawned.",
            Body = "Avoid looking at it."
        }
    },
    ["Lookman"] = {
        Alias = "Eyes",
        NotifyMessage = {
            Title = "Entity 'Eyes' has spawned.",
            Body = "Avoid looking at it."
        }
    },
    ["BackdoorRush"] = {
        Alias = "Blitz",
        NotifyMessage = {
            Title = "Entity 'Blitz' has spawned.",
            Body = "Find a hiding spot."
        }
    },
    ["BackdoorLookman"] = {
        Alias = "Lookman",
        NotifyMessage = {
            Title = "Entity 'Lookman' has spawned.",
            Body = "Avoid looking at its eyes."
        }
    },
    ["Groundskeeper"] = {
        Alias = "Groundskeeper",
        NotifyMessage = {
            Title = "Entity 'Groundskeeper' has spawned.",
            Body = "Avoid stepping on the grass."
        }
    },
    ["A60"] = {
        Alias = "A-60",
        NotifyMessage = {
            Title = "Entity 'A-60' has spawned.",
            Body = "Find a hiding spot."
        }
    },
    ["A120"] = {
        Alias = "A-120",
        NotifyMessage = {
            Title = "Entity 'A-120' has spawned.",
            Body = "Find a hiding spot."
        }
    },
    ["GloombatSwarm"] = {
        Alias = "Gloombat Swarm",
        NotifyMessage = {
            Title = "Entity 'Gloombat Swarm' has spawned.",
            Body = "Keep all light sources turned off."
        }
    },
    ["GlitchRush"] = {
        Alias = "RNIUSHCG==",
       NotifyMessage = {
            Title = "Entity 'RNIUSHCG==' has spawned.",
            Body = "Find a hiding spot."
        }
    },
    ["GlitchAmbush"] = {
        Alias = "AR0xMBUSH",
        NotifyMessage = {
            Title = "Entity 'AR0xMBUSH' has spawned.",
            Body = "Find a hiding spot."
        }
    },
    ["MonumentEntity"] = {
        Alias = "Monument",
         NotifyMessage = {
            Title = "Entity 'Monument' has spawned.",
            Body = "It cannot move while you are looking at it."
        }
    },
    ["JeffTheKiller"] = {
        Alias = "Jeff the Killer",
        NotifyMessage = {
            Title = "Entity 'Jeff the Killer' has spawned.",
            Body = "Avoid touching him."
        }
    },
    ["CustomEntity"] = {
        Alias = "Custom Entity",
        NotifyMessage = {
            Title = "Entity 'Custom Entity' has spawned.",
            Body = "Find a hiding spot."
        }
    },
    ["FrozenAmbush"] = {
        Alias = "Frozen Ambush",
        NotifyMessage = {
            Title = "Entity 'Frozen Ambush' has spawned.",
            Body = "Find a hiding spot."
        }
    },
    ["SallyMoving"] = {
        Alias = "Sally",
        NotifyMessage = {
            Title = "Entity 'Sally' has spawned.",
            Body = "Drop an item for her."
        }
    }
}

local ItemNames = {                                  
	["Lighter"] = "Lighter",
	["Flashlight"] = "Flashlight",
	["Lockpick"] = "Lockpicks",
	["Vitamins"] = "Vitamins",
	["Bandage"] = "Bandage",
	["StarVial"] = "Starlight Vial",
	["StarBottle"] = "Starlight Bottle",
	["StarJug"] = "Starlight Barrel",
	["Shakelight"] = "Gummy Flashlight",
	["Straplight"] = "Straplight",
	["Bulklight"] = "Spotlight",
	["Battery"] = "Battery",
	["Candle"] = "Candle",
	["Crucifix"] = "Crucifix",
	["CrucifixWall"] = "Crucifix",
	["Glowsticks"] = "Glowstick",
	["SkeletonKey"] = "Skeleton Key",
	["Candy"] = "Candy",
	["ShieldMini"] = "Mini Shield Potion",
	["ShieldBig"] = "Big Shield Potion",
	["BandagePack"] = "Bandage Pack",
	["BatteryPack"] = "Battery Pack",
	["RiftCandle"] = "Moonlight Candle",
	["LaserPointer"] = "Laser Pointer",
	["HolyGrenade"] = "Holy Hand Grenade",
	["Shears"] = "Shears",
	["Smoothie"] = "Smoohie",
	["Cheese"] = "Cheese",
	["Bread"] = "Bread",
	["AlarmClock"] = "Alarm Clock",
	["RiftSmoothie"] = "Moonlight Smoothie",
	["GweenSoda"] = "Gween Soda",
	["GlitchCube"] = "Glitch Fragment",
	["Scanner"] = "Tablet",
	["Bomb"] = "Bomb",
	["Knockbomb"] = "Knockbomb",
	["Nanner"] = "Nanner",
	["BigBomb"] = "Big Bomb",
	["SnakeBox"] = "Hiding Box",
	["GoldGun"] = "Golden Gun",
	["StopSign"] = "Stop Sign",
	["TipJar"] = "Tip Jar",
	["Lantern"] = "Lantern",
	["IronKey"] = "Iron Key",
	["LotusPetal"] = "Lotus Petal",
	["Compass"] = "Compass",
	["LotusPetalPickup"] = "Lotus Petal",
	["LanternLitItem"] = "Lantern",
	["KeyIron"] = "Iron Key",
	["IronKeyForCrypt"] = "Iron Key",
	["LotusHolder"] = "Lotus Petal",
	["Multitool"] = "Multitool",
	["RiftJar"] = "Rift Jar",
	["AloeVera"] = "Aloe Vera",
	["Donut"] = "Donut",
	["Lotus"] = "Lotus",
	["BoxingGloves"] = "Boxing Gloves"
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
local RemotesFolder = Services.ReplicatedStorage:FindFirstChild("RemotesFolder")
local LiveModifiers = Services.ReplicatedStorage:FindFirstChild("LiveModifiers")
local FloorReplicated = Services.ReplicatedStorage:FindFirstChild("FloorReplicated")
local CurrentRooms = Services.Workspace:FindFirstChild("CurrentRooms")
local Drops = Services.Workspace:FindFirstChild("Drops")
local GameData = Services.ReplicatedStorage:WaitForChild("GameData")
local Floor = GameData:WaitForChild("Floor").Value
local LatestRoom = GameData:WaitForChild("LatestRoom")

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
    Shade = Instance.new("RemoteEvent"),
    A90 = Instance.new("RemoteEvent"),
    Surge = Instance.new("RemoteEvent"),
}
local Modules = {}
local OldModules = {}
local Main_Game
local ClientModules

if Services.ReplicatedStorage:FindFirstChild("ModulesClient") then
    ClientModules = Services.ReplicatedStorage.ModulesClient
else
    ClientModules = Services.ReplicatedStorage.ClientModules
end

FakeEvents.Screech.Name = "Screech"
FakeEvents.Shade.Name = "ShadeResult"
FakeEvents.A90.Name = "A90"
FakeEvents.Surge.Name = "SurgeRemote"

FakeEvents.Screech_Real = RemotesFolder:WaitForChild("Screech")
FakeEvents.Shade_Real = RemotesFolder:WaitForChild("ShadeResult")
FakeEvents.A90_Real = RemotesFolder:FindFirstChild("A90")
FakeEvents.Surge_Real = RemotesFolder:FindFirstChild("SurgeRemote")

Globals.FogInstances = {}
Globals.OldFog = Services.Lighting.FogEnd
for Index, Object in pairs(Services.Lighting:GetChildren()) do
    if Object:IsA("Atmosphere") then
        Object:SetAttribute("Density_Old", Object.Density)
        table.insert(Globals.FogInstances, Object)
    end
end

Globals.SeekNodesFolder = Instance.new("Folder", Services.Workspace)
Globals.SeekNodesFolder.Name = Abysall.ESPLibrary:GenerateRandomString()

Globals.RoomsNodesFolder = Instance.new("Folder", Services.Workspace)
Globals.RoomsNodesFolder.Name = Abysall.ESPLibrary:GenerateRandomString()

Globals.FogContainer = Instance.new("Folder")
Globals.FogContainer.Name = Abysall.ESPLibrary:GenerateRandomString()

Globals.OxygenUI = Instance.new("ScreenGui", Services.CoreGui)
Globals.OxygenUI.Name = Abysall.ESPLibrary:GenerateRandomString()
Globals.OxygenUI.Enabled = false
Globals.OxygenUI.IgnoreGuiInset = true

Globals.OxygenUI_Text = Instance.new("TextLabel", Globals.OxygenUI)
Globals.OxygenUI_Text.Position = UDim2.new(0, 0, 0, 64)
Globals.OxygenUI_Text.Size = UDim2.new(1, 0, 0, 36)

Globals.OxygenUI_Text.TextSize = 36
Globals.OxygenUI_Text.TextColor3 = Color3.fromRGB(255, 255, 255)
Globals.OxygenUI_Text.BackgroundTransparency = 1
Globals.OxygenUI_Text.TextStrokeTransparency = 0
Globals.OxygenUI_Text.TextTransparency = 0
Globals.OxygenUI_Text.Font = Enum.Font.Oswald

Functions.CheckCompatability = function(Array)
    local Valid = true
    for Index, Name in pairs(Array) do
        if not Abysall.Environment[Name] then
            Valid = false
        end
    end
    return Valid
end

Functions.SendChat = function(Message)
	local Folder = ReplicatedStorage:FindFirstChild("DefaultChatSystemEvents") or Instance.new("Folder")
	local Event = Folder:FindFirstChild("SayMessageRequest") or Instance.new("RemoteEvent")
	Event:FireServer(Message ,"All")
	local Channel = (game:GetService("TextChatService"):FindFirstChild("TextChannels") and game:GetService("TextChatService"):FindFirstChild("TextChannels"):FindFirstChild("RBXGeneral") or Instance.new("TextChannel"))
	Channel:SendAsync(Message)
end

Functions.IsCrouching = function()
    if Floor == "Fools" or Floor == "OldHotel" then
        return Character:GetAttribute("Crouching")
    else
        return CollisionPart.CollisionGroup == "PlayerCrouching" and true or false
    end
end

Functions.GetCurrentSpeed = function()
    local Speed = 15

    Speed = Speed + Character:GetAttribute("SpeedBoost")
    Speed = Speed + Character:GetAttribute("SpeedBoostBehind")
    Speed = Speed + Character:GetAttribute("SpeedBoostExtra")
    Speed = Speed + (Floor == "Party" and 10 or 0)

    Speed = Speed + (LiveModifiers:FindFirstChild("PlayerFast") and 3 or 0)
    Speed = Speed + (LiveModifiers:FindFirstChild("PlayerFaster") and 6 or 0)
    Speed = Speed + (LiveModifiers:FindFirstChild("PlayerFastest") and 20 or 0)

    Speed = Speed - (LiveModifiers:FindFirstChild("PlayerSlow") and 3 or 0)
    Speed = Speed - (Functions.IsCrouching() and (LiveModifiers:FindFirstChild("PlayerCrouchSlow") and 8 or LiveModifiers:FindFirstChild("PlayerSlow") and 8 or 5) or 0)

    return Speed
end

Functions.GetMousePosition = function()
    if Library.IsMobile then
        return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    else
        return Vector2.new(Services.UserInputService:GetMouseLocation().X, Services.UserInputService:GetMouseLocation().Y)
    end
end

Functions.FormatOxygen = function(Oxygen)
    local Number = (math.floor(Oxygen * 10) / 10)
    return "Oxygen: " .. Number .. "%"
end

Functions.IsHidePersistent = function()
    return Floor == "Mines" and true or Floor == "Ripple" and true or Floor == "Party" and true or LiveModifiers:FindFirstChild("HideLevel2") and true or false
end

Functions.GetPlayerFromMouse = function(TargetPart, MaxDistance)
    local Closest
    local ClosestDistance = math.huge

    for Index, Player in pairs(Services.Players:GetPlayers()) do
        local Character = Player.Character

            local Target = Character and Character:FindFirstChild(TargetPart)
            if Target then
            local Result = Camera:WorldToViewportPoint(Target.Position)
            local Position = Vector2.new(Result.X, Result.Y)

            local MousePosition = Functions.GetMousePosition()
            local Distance = (MousePosition - Position).Magnitude

            if Player.Name ~= LocalPlayer.Name then
                if Distance < ClosestDistance and Distance < MaxDistance then
                    Closest = Target
                    ClosestDistance = Distance
                end
            end
        end
    end
    return Closest
end

Functions.GetNearestEntity = function(CheckDisabled, List, UseRaycasting)
    local Nearest = {
        Distance = math.huge,
        Object = nil
    }

    local EntityDistances = {
		["RushMoving"] = 85,
		["AmbushMoving"] = 150,
		["A60"] = 125,
		["A120"] = 85,
		["GlitchRush"] = 90,
		["GlitchAmbush"] = 175,
		["BackdoorRush"] = 85,
		["CustomEntity"] = 85,
	}

    for Index, Entity in pairs(Services.Workspace:GetChildren()) do
        if Entity and EntityDistances[Entity.Name] and Entity.PrimaryPart then
            local EntityData = Entities[Entity.Name]
            if List and not List[EntityData.Alias] or not List then
                local Distance = LocalPlayer:DistanceFromCharacter(Entity.PrimaryPart.Position)
                if Distance < EntityDistances[Entity.Name] and Distance < Nearest.Distance then
                    if CheckDisabled and Entity:GetAttribute("Inactive") ~= true or not CheckDisabled then
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
    local Nearest = {
        Distance = math.huge,
        Object = nil
    }

    for Index, Object in pairs(Objects.Entities) do
        if Object.PrimaryPart then
            local Distance = LocalPlayer:DistanceFromCharacter(Object.PrimaryPart.Position)
            if Object.Name == "FigureRig" and Distance < Nearest.Distance or Object.Name == "FigureRagdoll" and Distance < Nearest.Distance or Object.Name == "Figure" and Distance < Nearest.Distance then
                if Distance < 25 then
                    Nearest.Distance = Distance
                    Nearest.Object = Object
                end
            end
        end
    end
    return Nearest.Object
end

Functions.GetNearestHidingSpot = function()
    local Nearest = {
        Distance = math.huge,
        Object = nil
    }

    for Index, Object in pairs(Objects.HidingSpots) do
        if Object.PrimaryPart and Object:FindFirstChild("HidePrompt") then
            local Distance = LocalPlayer:DistanceFromCharacter(Object.PrimaryPart.Position)
            if Distance < Object.HidePrompt.MaxActivationDistance and Distance < Nearest.Distance then
                if Character:FindFirstChild("LastHideSpot") and Character.LastHideSpot.Value ~= Object and Functions.IsHidePersistent() or not Character:FindFirstChild("LastHideSpot") then
                    Nearest.Distance = Distance
                    Nearest.Object = Object
                end
            end
        end
    end
    return Nearest.Object
end

Functions.GetNearestTurnNode = function()
    local Nearest = {
        Distance = math.huge,
        Object = nil
    }

    for Index, Node in pairs(Objects.SeekNodes) do
        local Distance = LocalPlayer:DistanceFromCharacter(Node.Position)
        if Distance < Options.AutoSteerMinecartTurnDistance.Value and Distance < Nearest.Distance then
            Nearest.Distance = Distance
            Nearest.Object = Node
        end
    end
    return Nearest.Object
end

Functions.GetNearestDuckBoard = function()
    local Nearest = {
        Distance = math.huge,
        Object = nil
    }

    for Index, Board in pairs(Objects.SeekDuckBoards) do
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
    for Index, Anchor in pairs(Objects.Objectives) do
        if Anchor.Name == "MinesAnchor" and Anchor:FindFirstChild("Sign") then
            if Anchor.Sign.TextLabel.Text == Globals.MainUI.AnchorHintFrame.AnchorCode.Text then
                return Anchor
            end
        end
    end
end

Functions.GetMinecart = function()
    return (Camera:FindFirstChild("MinecartRig") and true or false)
end

Functions.HasItem = function(Name, OnlyCharacter)
    if LocalPlayer.Backpack:FindFirstChild(Name) and not OnlyCharacter then
        return LocalPlayer.Backpack:FindFirstChild(Name)
    elseif Character:FindFirstChild(Name) then
        return Character:FindFirstChild(Name)
    end
end

Functions.GetFlyVelocity = function()
    if Humanoid.MoveDirection == Vector3.new(0, 0, 0) then
	    local NewVelocity = Humanoid.MoveDirection
	    return Humanoid.MoveDirection
    end
	local Velocity = (Camera.CFrame * CFrame.new((CFrame.new(Camera.CFrame.p, Camera.CFrame.p + Vector3.new(Camera.CFrame.lookVector.x, 0, Camera.CFrame.lookVector.z)):VectorToObjectSpace(Humanoid.MoveDirection)))).p - Camera.CFrame.p;
	if Velocity == Vector3.new() then
		return Velocity
	end
	return Velocity.unit
end

Globals.PromptContainer = Instance.new("Folder")
Globals.PromptContainer.Name = "PromptContainer"

if Functions.CheckCompatability({"gethui"}) then
    Globals.PromptContainer.Parent = Abysall.Environment.gethui()
    Globals.OxygenUI.Parent = Abysall.Environment.gethui()
else
    Globals.PromptContainer.Parent = Services.CoreGui
    Globals.OxygenUI.Parent = Services.CoreGui
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
    Sound.Volume = (Toggles.NotifyPlaySound.Value and Options.NotifySoundVolume.Value or 0)
    Sound.PlayOnRemove = true
    Sound:Destroy()

    NotificationLibrary:Notify(Settings.Title, Settings.Body, Settings.Time or 5)
end

Library.Notify = function(Data, Body, Time)
    Functions.Notify({Title = Body, Time = Time or 5})
end

local ESPBlacklist = {}
Functions.AddESP = function(Options, RoomBased)
    local Object = Options.Object

    if table.find(ESPBlacklist, Object) then
        return
    end

    if RoomBased then
        if tonumber(Object:GetAttribute("ParentRoom")) == tonumber(LocalPlayer:GetAttribute("CurrentRoom")) or table.find(Objects.Doors, Object) and tonumber(Object:GetAttribute("ParentRoom")) == tonumber(LocalPlayer:GetAttribute("CurrentRoom")) + 1 then
            Abysall.ESPLibrary:AddESP(Options)
        end
        local Connection = LocalPlayer:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
            if tonumber(Object:GetAttribute("ParentRoom")) == tonumber(LocalPlayer:GetAttribute("CurrentRoom")) or table.find(Objects.Doors, Object) and tonumber(Object:GetAttribute("ParentRoom")) == tonumber(LocalPlayer:GetAttribute("CurrentRoom")) + 1 then
                Abysall.ESPLibrary:AddESP(Options)
            else
                Abysall.ESPLibrary:RemoveESP(Object)
            end
        end)
        table.insert(Connections, Connection)
        ESPConnections[Object] = Connection

        Object.Destroying:Once(function()
            Connection:Disconnect()
            if Abysall then
                Abysall.ESPLibrary:RemoveESP(Object)
            end

            local Position = table.find(Connections, Connection)
            table.remove(Connections, Position)
        end)
    else
        Abysall.ESPLibrary:AddESP(Options)
    end
end

Functions.RemoveESP = function(Object)
    if ESPConnections[Object] then
        ESPConnections[Object]:Disconnect()

        local Position = table.find(Connections, ESPConnections[Object])
        table.remove(Connections, Position)
    end
    Abysall.ESPLibrary:RemoveESP(Object)
end

Functions.BlacklistESP = function(Object)
    table.insert(ESPBlacklist, Object)
end

Functions.GetLibraryCode = function()
    local Paper = Character:FindFirstChild("LibraryHintPaper") or Character:FindFirstChild("LibraryHintPaperHard") or LocalPlayer.Backpack:FindFirstChild("LibraryHintPaper") or LocalPlayer.Backpack:FindFirstChild("LibraryHintPaperHard")
    if Paper and Paper:FindFirstChild("UI") then
        local Code = {"_", "_", "_", "_", "_"}
        if Floor == "Fools" then
            Code = {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}
        end
        for Index, Object in pairs(LocalPlayer.PlayerGui.PermUI.Hints:GetChildren()) do
            for Index2, Object2 in pairs(Paper.UI:GetChildren()) do
                if Object:IsA("ImageLabel") and Object2:IsA("ImageLabel") and Object.ImageRectOffset == Object2.ImageRectOffset and Code[tonumber(Object2.Name)] then
                    Code[tonumber(Object2.Name)] = Object.TextLabel.Text
                end
            end 
        end
        return table.concat(Code)
    end
end

local Window = Library:CreateWindow({
    Title = "Abysall Hub",
    Footer = "Abysall - Testing | Doors",
    NotifySide = "Right",
    ShowCustomCursor = false,
    AutoShow = true,
    Center = true,
	TabPadding = 3,
	MenuFadeTime = 0,
})

local Tabs = {
    General = Window:AddTab("General", "house"),
    Exploits = Window:AddTab("Exploits", "shield"),
    Visuals = Window:AddTab("Visuals", "eye"),
    Floors = Window:AddTab("Floors", "earth"),
}

Groupboxes.General_LeftTab = Tabs.General:AddLeftTabbox("Character / Self")

Groupboxes.General_Character = Groupboxes.General_LeftTab:AddTab("Character")
Groupboxes.General_Character:AddSlider("SpeedBoostSlider", {
    Text = "Speed Boost",
    Min = 0,
    Max = 60,
    Default = 0,
    Rounding = 0,
    Compact = true,
})
Groupboxes.General_Character:AddToggle("SpeedBoostToggle", {
    Text = "Enable Speed Boost",
    Default = false,
    Tooltip = "Increases your walkspeed by the specified amount.",
})
Groupboxes.General_Character:AddSlider("JumpBoostSlider", {
    Text = "Jump Boost",
    Min = 0,
    Max = 50,
    Default = 0,
    Rounding = 0,
    Compact = true
})
Groupboxes.General_Character:AddToggle("JumpBoostToggle", {
    Text = "Enable Jump Boost",
    Default = false,
    Tooltip = "Increases your jump power by the specified amount."
})

Groupboxes.General_Character:AddToggle("FlyToggle", {
    Text = "Fly",
    Default = false,
    Tooltip = "Allows you to freely fly around the map."
})

Toggles.FlyToggle:AddKeyPicker("FlyKeybind", {
    Text = "Fly",
    Default = "F",
    Mode = "Toggle",
    SyncToggleState = true
})

Groupboxes.General_Character:AddSlider("FlySpeed", {
    Text = "Fly Speed",
    Min = 0,
    Max = 75,
    Default = 20,
    Rounding = 0,
    Compact = true
})

Groupboxes.General_Character:AddDivider()

Groupboxes.General_Character:AddToggle("NoclipToggle", {
    Text = "Noclip",
    Default = false,
    Tooltip = "Allows your character to pass through solid objects."
})

Groupboxes.General_Character:AddToggle("RemoveClosetDelay", {
    Text = "Remove Closet Delay",
    Default = false,
    Tooltip = "Removed the short window where you can't exit out of a closet after the animation finishes."
})

Groupboxes.General_Character:AddToggle("RemoveAcceleration", {
    Text = "Remove Acceleration",
    Default = false,
    Tooltip = "Prevents your character from sliding while moving."
})

local CustomPhysics

Toggles.NoclipToggle:AddKeyPicker("NoclipKeybind", {
    Text = "Noclip",
    Default = "N",
    Mode = "Toggle",
    SyncToggleState = true
})

Toggles.RemoveAcceleration:OnChanged(function(Value)
    for Index, Old in pairs(PartProperties) do
        Index.CustomPhysicalProperties = (Value and CustomPhysics or Old)
    end
end)

Groupboxes.General_Character:AddDivider()

Groupboxes.General_Character:AddToggle("EnableCharacterJump", {
    Text = "Enable Jumping",
    Default = false,
    Tooltip = "Allows your character to jump."
})

Groupboxes.General_Character:AddToggle("EnableCharacterSlide", {
    Text = "Enable Sliding",
    Default = false,
    Tooltip = "Allows your character to slide."
})

Groupboxes.General_Character:AddToggle("InfiniteJumps", {
    Text = "Infinite Jumps",
    Default = false,
    Tooltip = "Allows you to jump while in the air."
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
        Character:SetAttribute("CanJump", (Value and true or OldJump))
    end
end)

Toggles.EnableCharacterSlide:OnChanged(function(Value)
    if Character then
        Character:SetAttribute("CanSlide", (Value and true or OldSlide))
    end
end)

Groupboxes.General_Self = Groupboxes.General_LeftTab:AddTab("Self")

Groupboxes.General_Self:AddToggle("DoorReachToggle", {
    Text = "Door Reach",
    Default = false,
    Tooltip = "Allows you to open doors from further away."
})

Groupboxes.General_Self:AddToggle("DisableIdleKick", {
    Text = "Disable Idle Kick",
    Default = false,
    Tooltip = "Prevents the kick from being idle for 20 minutes."
})

Toggles.DisableIdleKick:OnChanged(function(Value)
    if Functions.CheckCompatability({"getconnections"}) then
        for Index, Connection in pairs(Abysall.Environment.getconnections(LocalPlayer.Idled)) do
            if Value then
                Connection:Disable()
            else
                Connection:Enable()
            end
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

Groupboxes.General_Self:AddToggle("PromptReachToggle", {
    Text = "Prompt Reach",
    Default = false,
    Tooltip = "Allows you to interact with prompt from further away."
})

Groupboxes.General_Self:AddSlider("PromptReachSlider", {
    Text = "Prompt Reach Multiplier",
    Min = 1,
    Max = 2,
    Default = 1,
    Rounding = 1,
    Compact = true
})

Groupboxes.General_Self:AddToggle("InstantPrompts", {
    Text = "Instant Prompts",
    Default = false,
    Tooltip = "Allows you to trigger all prompts instantly."
})

Groupboxes.General_Self:AddToggle("PromptClip", {
    Text = "Prompt Clip",
    Default = false,
    Tooltip = "Allows you to interact with prompts through walls."
})

Toggles.PromptReachToggle:OnChanged(function(Value)
    for Index, Prompt in pairs(Objects.Prompts) do
        Prompt.MaxActivationDistance = Prompt:GetAttribute("MaxActivationDistance_Old") * (Value and Options.PromptReachSlider.Value or 1)
    end
end)

Options.PromptReachSlider:OnChanged(function(Value)
    for Index, Prompt in pairs(Objects.Prompts) do
        Prompt.MaxActivationDistance = Prompt:GetAttribute("MaxActivationDistance_Old") * (Toggles.PromptReachToggle.Value and Options.PromptReachSlider.Value or 1)
    end
end)

Toggles.InstantPrompts:OnChanged(function(Value)
    for Index, Prompt in pairs(Objects.Prompts) do
        Prompt.HoldDuration = (Value and 0 or Prompt:GetAttribute("HoldDuration_Old"))
    end
end)

Toggles.PromptClip:OnChanged(function(Value)
    for Index, Prompt in pairs(Objects.Prompts) do
        Prompt.RequiresLineOfSight = (Value and false or Prompt:GetAttribute("RequiresLineOfSight_Old"))
    end
end)

Groupboxes.Self_Automation = Tabs.General:AddRightGroupbox("Automation")

Groupboxes.Self_Automation:AddToggle("AutoBreakerBox", {
    Text = "Auto Breaker Box",
    Default = false,
    Tooltip = "Automatically solves the breaker box."
})

Groupboxes.Self_Automation:AddToggle("AutoSolveAnchors", {
    Text = "Auto Solve Anchors",
    Default = false,
    Tooltip = "Automatically enters the correct code into anchors when you are near them."
})

Toggles.AutoBreakerBox:OnChanged(function(Value)
    if Value and CurrentRooms:FindFirstChild("ElevatorBreaker", true) then
        if not Globals.BreakerBoxInteracted then
            if not Globals.BreakerBoxNotified then
                Functions.Notify({Title = "Interact with the breaker box.", Body = "It will be automatically solved."})
                Globals.BreakerBoxInteracted = true
            end
        else   
            RemotesFolder.EBF:FireServer()
        end
    end
end)

Groupboxes.Self_Automation:AddDivider()

Groupboxes.Self_Automation:AddToggle("AutoUnlockPadlockToggle", {
    Text = "Auto Unlock Padlock",
    Default = false,
    Tooltip = "Automatically enters the code into the library padlock."
})

Groupboxes.Self_Automation:AddSlider("AutoUnlockPadlockSlider", {
    Text = "Unlock Distance",
    Min = 1,
    Max = 50,
    Default = 10,
    Rounding = 0,
    Compact = true
})

Groupboxes.Self_Automation:AddDivider()

Groupboxes.Self_Automation:AddToggle("AutoInteractToggle", {
    Text = "Auto Interact",
    Default = false,
    Tooltip = "Automatically triggers nearby prompts."
})

Toggles.AutoInteractToggle:AddKeyPicker("AutoInteractKeybind", {
    Text = "Auto Interact",
    Default = "R",

    Mode = Library.IsMobile and "Toggle" or "Hold",
    SyncToggleState = true
})

Groupboxes.Self_Automation:AddDropdown("AutoInteractIgnoreList", {
    Text = "Ignore List",
    Values = {
        "Glitch Fragments",
        "Jeff Items",
        "Dropped Items",
        "Currency",
        "Minecarts",
        "Paintings",
        "Locks"
    },
    Multi = true,
    AllowNull = true
})

Groupboxes.Self_Automation:AddDivider()

Groupboxes.Self_Automation:AddToggle("AutoClosetToggle", {
    Text = "Auto Closet",
    Default = false,
    Tooltip = "Automatically hides in a nearby closet when an entity is near."
})

Toggles.AutoClosetToggle:AddKeyPicker("AutoClosetKeybind", {
    Text = "Auto Closet",
    Default = "Q",
    Mode = "Toggle",
    SyncToggleState = true
})

Groupboxes.Self_Automation:AddDropdown("AutoClosetEntityList", {
    Text = "Ignore List",
    Values = {
        "Rush",
        "Ambush",
        "Blitz",
        "A-60",
        "A-120",
        "AR0xMBUSH",
        "RNIUSHCG=="
    },
    Multi = true,
    AllowNull = true
})

Groupboxes.Self_Misc = Tabs.General:AddRightGroupbox("Miscellaneous")

Groupboxes.Self_Misc:AddButton({
    Text = "Play Again",
    Tooltip = "Makes you join a new run, click again to cancel.",
    DoubleClick = true,
    Func = function()
        RemotesFolder.PlayAgain:FireServer()
    end
})

Groupboxes.Self_Misc:AddButton({
    Text = "Return to Lobby",
    Tooltip = "Makes you teleport back to the lobby.",
    DoubleClick = true,
    Func = function()
        RemotesFolder.Lobby:FireServer()
    end
})

Groupboxes.Self_Misc:AddButton({
    Text = "Revive",
    Tooltip = "Makes you revive, if you have a revive and haven't already revived in this run.",
    DoubleClick = true,
    Func = function()
        RemotesFolder.Revive:FireServer()
    end
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

Groupboxes.Exploits_Bypass:AddToggle("BypassGiggle", {
    Text = "Bypass Giggle",
    Default = false,
    Tooltip = "Prevents 'Giggle' from attacking you."
})

Groupboxes.Exploits_Bypass:AddToggle("BypassDupe", {
    Text = "Bypass Dupe",
    Default = false,
    Tooltip = "Prevents you from open 'Dupe' fake doors."
})

Groupboxes.Exploits_Bypass:AddToggle("BypassEyes", {
    Text = "Bypass Eyes",
    Default = false,
    Tooltip = "Prevents 'Eyes' from hurting you."
})

Groupboxes.Exploits_Bypass:AddToggle("BypassLookman", {
    Text = "Bypass Lookman",
    Default = false,
    Tooltip = "Prevents 'Lookman' from hurting you."
})

Groupboxes.Exploits_Bypass:AddToggle("BypassGloombatEggs", {
    Text = "Bypass Gloombat Eggs",
    Default = false,
    Tooltip = "Prevents taking damage from stepping on 'Gloombat' eggs."
})

Groupboxes.Exploits_Bypass:AddToggle("BypassSeekObstructions", {
    Text = "Bypass Seek Obstructions",
    Default = false,
    Tooltip = "Prevents obstacles in the 'Seek' chase from harming you."
})

Groupboxes.Exploits_Bypass:AddToggle("BypassVacuum", {
    Text = "Bypass Vacuum",
    Default = false,
    Tooltip = "Prevents you from falling into 'Vacuum' fake doors."
})

Groupboxes.Exploits_Bypass:AddToggle("BypassKillbricks", {
    Text = "Bypass Killbricks",
    Default = false,
    Tooltip = "Prevents 'Lava' from hurting you."
})

Groupboxes.Exploits_Bypass:AddToggle("BypassSeekingWall", {
    Text = "Bypass Seeking Wall",
    Default = false,
    Tooltip = "Prevents 'ScaryWall' from hurting you."
})

Groupboxes.Exploits_Bypass:AddToggle("BypassSnare", {
    Text = "Bypass Snare",
    Default = false,
    Tooltip = "Prevents 'Snare' from trapping you."
})

Groupboxes.Exploits_Bypass:AddToggle("BypassBanana", {
    Text = "Bypass Banana",
    Default = false,
    Tooltip = "Prevents 'Banana Peel' from slipping you up (sometimes doesn't work)."
})

Groupboxes.Exploits_Bypass:AddToggle("BypassJeff", {
    Text = "Bypass Jeff",
    Default = false,
    Tooltip = "Prevents 'Jeff the Killer' from stabbing you (sometimes doesn't work)."
})

Toggles.BypassGiggle:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Entities) do
        if Object.Name == "GiggleCeiling" then
            Object:WaitForChild("Hitbox").CanTouch = not Value
        end
    end
end)

Toggles.BypassDupe:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Entities) do
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
    for Index, Object in pairs(Objects.Entities) do
        for Index2, Object2 in pairs(Object:GetDescendants()) do
            if Object2:IsA("BasePart") then
                Object2.CanTouch = not Value
            end
        end
    end
end)

Toggles.BypassSeekObstructions:OnChanged(function(Value)
    for Index, Object in pairs(Objects.SeekObstructions) do
        Object.CanTouch = not Value
        if Object.Name == "SeekFloodline" then
            Object.CanCollide = Value
        end
    end
    for Index, Object in pairs(Objects.SeekBridges) do
        Object.CanCollide = Value
        Object.Transparency = (Value and 0 or 1)
    end
end)

Toggles.BypassVacuum:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Entities) do
        if Object.Name == "SideroomSpace" then
            Object:WaitForChild("Collision").CanCollide = Value
            Object:WaitForChild("Collision").CanTouch = not Value
        end
    end
end)

Toggles.BypassKillbricks:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Obstructions) do
        if Object.Name == "Lava" then
            Object.CanTouch = not Value
        end
    end
end)

Toggles.BypassSeekingWall:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Obstructions) do
        if Object.Name == "ScaryWall" then
            for Index2, Object2 in pairs(Object:GetDescendants()) do
                if Object2:IsA("BasePart") then
                    Object2.CanTouch = not Value
                    Object2.CanCollide = not Value
                end
            end
        end
    end
end)

Toggles.BypassSnare:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Entities) do
        if Object.Name == "Snare" and Object:FindFirstChild("Hitbox") then
            Object.Hitbox.CanTouch = not Value
        end
    end
end)

Toggles.BypassBanana:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Entities) do
        if Object.Name == "BananaPeel" then
            Object.CanTouch = not Value
        end
    end
end)

Toggles.BypassJeff:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Entities) do
        if Object.Name == "JeffTheKiller" then
            for Index2, Object2 in pairs(Object:GetDescendants()) do
                if Object2:IsA("BasePart") then
                    Object2.CanCollide = not Value
                    Object2.CanTouch = not Value
                end
            end
            Object:WaitForChild("Humanoid").Health = 0
        end
    end
end)

Groupboxes.Exploits_Bypass = Tabs.Exploits:AddRightGroupbox("Bypass")

Groupboxes.Exploits_Bypass:AddToggle("DisableAnticheat", {
    Text = "Disable Anticheat",
    Default = false,
    Tooltip = "Completely disables the anticheat, after interacting with a ladder."
})

Groupboxes.Exploits_Bypass:AddToggle("VelocityManipulationToggle", {
    Text = "Velocity Manipulation",
    Default = false,
    Tooltip = "Moves your character forward slowly, mitigating the game's anti-noclip."
})

Toggles.DisableAnticheat:OnChanged(function(Value)
    if Globals.AnticheatDisabled == true and not Value then
        RemotesFolder.ClimbLadder:FireServer()
        Globals.AnticheatDisabled = false
    end
end)

Toggles.VelocityManipulationToggle:AddKeyPicker("VelocityManipulationKeybind", {
    Text = "Velocity Manipulation",
    Default = "V",

    Mode = Library.IsMobile and "Toggle" or "Hold",
    SyncToggleState = true
})

Groupboxes.Exploits_Bypass:AddDivider()

Groupboxes.Exploits_Bypass:AddToggle("InfiniteItemsToggle", {
    Text = "Infinite Items",
    Default = false,
    Tooltip = "Allows certain items to be used without draining their uses.",

    Disabled = not (Functions.CheckCompatability({"fireproximityprompt"})),
    DisabledTooltip = Globals.IncompatibleMessage
})

Groupboxes.Exploits_Bypass:AddDropdown("InfiniteItemsList", {
    Text = "Item List",
    Values = {
        "Lockpicks",
        "Skeleton Key",
        "Shears",
        "Multitool"
    },
    Multi = true,
    AllowNull = true,

    Disabled = not (Functions.CheckCompatability({"fireproximityprompt"})),
    DisabledTooltip = Globals.IncompatibleMessage
})

Groupboxes.Exploits_Bypass:AddDivider()

Groupboxes.Exploits_Bypass:AddToggle("PositionSpoof", {
    Text = "Position Spoof",
    Default = false,
    Tooltip = "Makes your character appear underground on the server, protecting you from rush-like entities."
})

Groupboxes.Exploits_Bypass:AddToggle("CrouchSpoof", {
    Text = "Crouch Spoof",
    Default = false,
    Tooltip = "Makes the game think you are always crouching."
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
    Text = "Position Spoof",
    Default = "B",
    Mode = "Toggle",
    SyncToggleState = true
})

Toggles.CrouchSpoof:OnChanged(function(Value)
    if RemotesFolder:FindFirstChild("Crouch") then
        RemotesFolder.Crouch:FireServer(Value and true or Functions.IsCrouching())
    end
end)

Groupboxes.Exploits_Remove = Tabs.Exploits:AddRightGroupbox("Remove")

Groupboxes.Exploits_Remove:AddToggle("RemoveScreech", {
    Text = "Remove Screech",
    Default = false,
    Tooltip = "Prevents 'Screech' from spawning."
})

Groupboxes.Exploits_Remove:AddToggle("RemoveHalt", {
    Text = "Remove Halt",
    Default = false,
    Tooltip = "Prevents 'Halt' from spawning."
})

Groupboxes.Exploits_Remove:AddToggle("RemoveA90", {
    Text = "Remove A-90",
    Default = false,
    Tooltip = "Prevents 'A-90' from spawning."
})

Groupboxes.Exploits_Remove:AddToggle("RemoveDread", {
    Text = "Remove Dread",
    Default = false,
    Tooltip = "Prevents 'Dread' from spawning."
})

Groupboxes.Exploits_Remove:AddDivider()

Groupboxes.Exploits_Remove:AddToggle("NoScreechDamage", {
    Text = "No Screech Damage",
    Default = false,
    Tooltip = "Prevents 'Screech' from hurting you."
})

Groupboxes.Exploits_Remove:AddToggle("NoHaltDamage", {
    Text = "No Halt Damage",
    Default = false,
    Tooltip = "Prevents 'Halt' from hurting you."
})

Groupboxes.Exploits_Remove:AddToggle("NoA90Damage", {
    Text = "No A-90 Damage",
    Default = false,
    Tooltip = "Prevents 'A-90' from hurting you."
})

Groupboxes.Exploits_Remove:AddToggle("NoSurgeDamage", {
    Text = "No Surge Damage",
    Default = false,
    Tooltip = "Prevents 'Surge' from hurting you."
})

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

Toggles.RemoveScreech:OnChanged(function(Value)
    if not Functions.CheckCompatability({"hookfunction"}) then
        Modules.Screech.Name = (Value and "Screech_Disabled" or "Screech")
        Moudles.GlitchScreech.Name = (Value and "GlitchScreech_Disabled" or "GlitchScreech")
    end
end)

Toggles.RemoveScreech:OnChanged(function(Value)
    if not Functions.CheckCompatability({"hookfunction"}) then
        Modules.Shade.Name = (Value and "Shade_Disabled" or "Shade")
    end
end)

Toggles.RemoveA90:OnChanged(function(Value)
    if not Functions.CheckCompatability({"hookfunction"}) then
        Modules.Screech.Name = (Value and "A90_Disabled" or "A90")
    end
end)

Toggles.RemoveDread:OnChanged(function(Value)
    if not Functions.CheckCompatability({"hookfunction"}) then
        Modules.Screech.Name = (Value and "Dread_Disabled" or "Dread")
    end
end)

Groupboxes.Exploits_Audio = Tabs.Exploits:AddLeftGroupbox("Audio")

Globals.JamMuffle = Services.SoundService:WaitForChild("Main"):FindFirstChild("Jamming") or Instance.new("EqualizerSoundEffect")
Groupboxes.Exploits_Audio:AddToggle("RemoveJamminMusic", {
    Text = "Remove Jammin Music",
    Default = false,
    Tooltip = "Removes the music and muffle effect from the 'Jammin' modifier."
})

Groupboxes.Exploits_Audio:AddToggle("RemoveInteractingSounds", {
    Text = "Remove Interacting Sounds",
    Default = false,
    Tooltip = "Removes the sounds when interacting with proximity prompts."
})

Toggles.RemoveJamminMusic:OnChanged(function(Value)
    local Jam = Globals.MainUI.Initiator.Main_Game.Health:FindFirstChild("Jam")
    if Jam then
        Jam.Volume = (Value and 0 or 0.45)
        Globals.JamMuffle.Enabled = not (Value and true or false)
    end
end)

Toggles.RemoveInteractingSounds:OnChanged(function(Value)
    Globals.MainUI.Initiator.Main_Game.PromptService.Triggered.Volume = (Value and 0 or 0.04)
	Globals.MainUI.Initiator.Main_Game.PromptService.Holding.Volume = (Value and 0 or 0.1)
    Globals.MainUI.Initiator.Main_Game.PromptService.Notification.Volume = (Value and 0 or 0.03)
	Globals.MainUI.Initiator.Main_Game.Reminder.Caption.Volume = (Value and 0 or 0.1)
end)

Groupboxes.Visuals_LeftTab = Tabs.Visuals:AddLeftTabbox("Camera / Effects")

Groupboxes.Visuals_Camera = Groupboxes.Visuals_LeftTab:AddTab("Camera")

Groupboxes.Visuals_Camera:AddToggle("AmbientToggle", {
    Text = "Ambient",
    Default = false,
    Tooltip = "Changes the lighting color to the specified value."
})

Groupboxes.Visuals_Camera:AddSlider("FieldOfView", {
    Text = "Field of View",
    Min = 1,
    Max = 120,
    Default = 70,
    Rounding = 0
})

Groupboxes.Visuals_Camera:AddDivider()

Groupboxes.Visuals_Camera:AddToggle("RemoveCameraShake", {
    Text = "Remove Camera Shake",
    Default = false,
    Tooltip = "Prevents the camera from shaking.",

    Disabled = not Functions.CheckCompatability({"require"}),
    DisabledTooltip = Globals.IncompatibleMessage
})

Groupboxes.Visuals_Camera:AddToggle("RemoveCameraBobbing", {
    Text = "Remove Camera Bobbing",
    Default = false,
    Tooltip = "Prevents the camera from bobbing when moving.",

    Disabled = not Functions.CheckCompatability({"require"}),
    DisabledTooltip = Globals.IncompatibleMessage
})

Groupboxes.Visuals_Camera:AddToggle("RemoveCameraFog", {
    Text = "Remove Camera Fog",
    Default = false,
    Tooltip = "Removes all fog effects from the camera."
})

Groupboxes.Visuals_Camera:AddDivider()

Groupboxes.Visuals_Camera:AddToggle("ThirdPersonToggle", {
    Text = "Third Person",
    Default = false,
    Tooltip = "Zooms out your camera, allowing you to see your character from behind."
})

Toggles.ThirdPersonToggle:AddKeyPicker("ThirdPersonKeybind", {
    Text = "Third Person",
    Default = "T",
    Mode = "Toggle",
    SyncToggleState = true
})

Groupboxes.Visuals_Camera:AddSlider("ThirdPersonOffsetX", {
    Text = "X Offset",
    Min = -10,
    Max = 10,
    Default = 1.5,
    Rounding = 1,
    Compact = true
})

Groupboxes.Visuals_Camera:AddSlider("ThirdPersonOffsetY", {
    Text = "Y Offset",
    Min = -10,
    Max = 10,
    Default = 1,
    Rounding = 1,
    Compact = true
})

Groupboxes.Visuals_Camera:AddSlider("ThirdPersonOffsetZ", {
    Text = "Z Offset",
    Min = -10,
    Max = 10,
    Default = 5,
    Rounding = 1,
    Compact = true
})

Toggles.AmbientToggle:AddColorPicker("AmbientColor", {
    Text = "Ambient",
    Default = Color3.fromRGB(255, 255, 255),
    Transparency = 0
})

Toggles.AmbientToggle:OnChanged(function(Value)
    local OldAmbient = CurrentRooms:FindFirstChild(tostring(LocalPlayer:GetAttribute("CurrentRoom"))):GetAttribute("Ambient")
    Services.TweenService:Create(Services.Lighting, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {Ambient = (Value and Options.AmbientColor.Value or OldAmbient)}):Play()
end)

Toggles.RemoveCameraBobbing:OnChanged(function(Value)
    Main_Game.spring.Speed = (Value and 9e9 or 8)
end)

Toggles.RemoveCameraFog:OnChanged(function(Value)
    Services.Lighting.FogEnd = (Value and 10000000 or Globals.OldFog)
    for Index, Object in pairs(Globals.FogInstances) do
        Object.Density = (Value and 0 or Object:GetAttribute("Density_Old"))
    end
end)

Groupboxes.Visuals_Effects = Groupboxes.Visuals_LeftTab:AddTab("Effects")

Groupboxes.Visuals_Effects:AddToggle("TransparentHidingSpotsToggle", {
    Text = "Transparent Hiding Spots",
    Default = false,
    Tooltip = "Makes a hiding spot transparent when you enter it."
})

Groupboxes.Visuals_Effects:AddSlider("TransparentHidingSpotsSlider", {
    Text = "Transparency",
    Min = 0,
    Max = 1,
    Default = 0.5,
    Rounding = 2,
    Compact = true
})

Toggles.TransparentHidingSpotsToggle:OnChanged(function(Value)
    for Index, Object in pairs(Objects.HidingSpots) do
        local IsHiding = false
        for Index2, Object2 in pairs(Object:GetDescendants()) do
            if Object2.Name == "HiddenPlayer" and Object2.Value == Character then
                IsHiding = true
            end
        end
        for Index3, Object3 in pairs(Object:GetDescendants()) do
            if Object3:IsA("BasePart") and Object3:GetAttribute("Transparency_Old") then
                Services.TweenService:Create(Object3, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {Transparency = (Value and IsHiding and Options.TransparentHidingSpotsSlider.Value or Object3:GetAttribute("Transparency_Old"))}):Play()
            end
        end
    end
end)

Options.TransparentHidingSpotsSlider:OnChanged(function(Value)
    for Index, Object in pairs(Objects.HidingSpots) do
        local IsHiding = false
        for Index2, Object2 in pairs(Object:GetDescendants()) do
            if Object2.Name == "HiddenPlayer" and Object2.Value == Character then
                IsHiding = true
            end
        end
        for Index3, Object3 in pairs(Object:GetDescendants()) do
            if Object3:IsA("BasePart") and Object3:GetAttribute("Transparency_Old") then
                Services.TweenService:Create(Object3, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {Transparency = (Toggles.TransparentHidingSpotsToggle.Value and IsHiding and Value or Object3:GetAttribute("Transparency_Old"))}):Play()
            end
        end
    end
end)

Groupboxes.Visuals_Effects:AddDivider()

Groupboxes.Visuals_Effects:AddToggle("DisableGlitchJumpscare", {
    Text = "Disable Glitch Jumpscare",
    Default = false,
    Tooltip = "Disables the jumpscare from 'Glitch'"
})

Groupboxes.Visuals_Effects:AddToggle("DisableTimothyJumpscare", {
    Text = "Disable Timothy Jumpscare",
    Default = false,
    Tooltip = "Disables the jumpscare from 'Timothy'"
})

Groupboxes.Visuals_Effects:AddToggle("DisableVoidJumpscare", {
    Text = "Disable Void Jumpscare",
    Default = false,
    Tooltip = "Disables the jumpscare from 'Void'",

    Risky = (Floor == "OldHotel" and true or false)
})

Groupboxes.Visuals_Effects:AddDivider()

Groupboxes.Visuals_Effects:AddToggle("DisableHideVignette", {
    Text = "Disable Hide Vignette",
    Default = false,
    Tooltip = "Disables the hiding screen effect."
})

Groupboxes.Visuals_Effects:AddToggle("DisableFiredampEffect", {
    Text = "Disable Firedamp Effect",
    Default = false,
    Tooltip = "Disabled the firedamp screen effect."
})

Groupboxes.Visuals_Effects:AddToggle("DisableEntityJumpscares", {
    Text = "Disable Entity Jumpscares",
    Default = false,
    Tooltip = "Disables jumpscares from entities like Rush and Ambush."
})

Toggles.DisableGlitchJumpscare:OnChanged(function(Value)
    if not Functions.CheckCompatability({"hookfunction"}) then
        Modules.Glitch.Name = (Value and "Glitch_Disabled" or "Glitch")
    end
end)

Toggles.DisableTimothyJumpscare:OnChanged(function(Value)
    if not Functions.CheckCompatability({"hookfunction"}) then
        Modules.SpiderJumpscare.Name = (Value and "SpiderJumpscare_Disabled" or "SpiderJumpscare")
    end
end)

Toggles.DisableVoidJumpscare:OnChanged(function(Value)
    if Modules.Void and not Functions.CheckCompatability({"hookfunction"}) then
        Modules.Void.Name = (Value and "Void_Disabled" or "Void")
    end
end)

Toggles.DisableHideVignette:OnChanged(function(Value)
    local Vignette = Globals.MainUI:FindFirstChild("HideVignette") or Globals.MainUI.MainFrame:FindFirstChild("HideVignette")
    if Vignette then
        Vignette.Image = (Value and "Disabled" or "rbxassetid://6100076320")
    end
end)

Toggles.DisableFiredampEffect:OnChanged(function(Value)
    for Index, Object in pairs(CurrentRooms:GetChildren()) do
        if Value then
            Object:SetAttribute("Firedamp", false)
            for Index, Object in pairs(Camera:GetChildren()) do
                if Object.Name == "LiveFiredamp" then
                    Object:Destroy()
                end
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
    if not Functions.CheckCompatability({"hookfunction"}) then
        Globals.MainUI.Initiator.Main_Game.RemoteListener.Jumpscares.Name = (Value and "Jumpscares_Disabled" or "Jumpscares")
        for Index, Object in pairs(Objects.JumpscareModules) do
            Object.Name = (Value and Object:GetAttribute("OriginalName") .. "_Disabled" or Object:GetAttribute("OriginalName"))
        end
    end
end)

if Functions.CheckCompatability({"hookfunction"}) then
    local Original;
    Original = Abysall.Environment.hookfunction(require, function(...)
        if not Abysall then
            return Original(...)
        end

        local Args = {...}
        local Module = Args[1]

        if Module == Modules.Screech then
            local Real = Original(...)
            return function(...)
                if Toggles.RemoveScreech.Value then
                    return
                end
                return Real(...)
            end
        end

        if Module == Modules.GlitchScreech then
            local Real = Original(...)
            return function(...)
                if Toggles.RemoveScreech.Value then
                    return
                end
                return Real(...)
            end
        end

        if Module == Modules.A90 then
            local Real = Original(...)
            return function(...)
                if Toggles.RemoveA90.Value then
                    return
                end
                return Real(...)
            end
        end

        if Module == Modules.Dread then
            local Real = Original(...)
            return function(...)
                if Toggles.RemoveDread.Value then
                    return
                end
                return Real(...)
            end
        end

        if Module == Modules.SpiderJumpscare then
            local Real = Original(...)
            return function(...)
                if Toggles.DisableTimothyJumpscare.Value then
                    return
                end
                return Real(...)
            end
        end

        if Module == Modules.Glitch then
            local Real = Original(...).stuff
            return {
                stuff = function(...)
                    if Toggles.DisableGlitchJumpscare.Value then
                        return
                    end
                    return Real(...)
                end
            }
        end

        if Module.Parent.Name == "Jumpscares" or string.find(Module.Name, "Jumpscare") then
            local Real = Original(...)
            return {
                stuff = function(...)
                    if Toggles.DisableEntityJumpscares.Value then
                        return
                    end
                    return Real(...)
                end
            }
        end

        if Module == Modules.Shade then
            local Real = Original(...).stuff
            return {
                stuff = function(...)
                    if Toggles.RemoveHalt.Value then
                        return
                    end
                    return Real(...)
                end
            }
        end

        if Module == Modules.Void then
            local Real = Original(...).stuff
            return {
                stuff = function(...)
                    if Toggles.DisableVoidJumpscare.Value then
                        return
                    end
                    return Real(...)
                end
            }
        end

        return Original(...)
    end)
end

Groupboxes.Visuals_RightTab = Tabs.Visuals:AddRightTabbox("Entities / Settings")
Groupboxes.Visuals_Entities = Groupboxes.Visuals_RightTab:AddTab("Entities")

Groupboxes.Visuals_Entities:AddDropdown("EntityList", {
    Text = "Entity List",
    Values = {
        "Rush",
        "Ambush",
        "Eyes",
        "Halt",
        "Blitz",
        "Lookman",
        "Gloombat Swarm",
        "A-60",
        "A-120",
        "Sally",
        "Jeff the Killer",
        "Groundskeeper",
        "Monument",
        "AR0xMBUSH",
        "RNIUSHCG=="
    },
    Multi = true,
    AllowNull = true
})

Groupboxes.Visuals_Entities:AddToggle("NotifyEntities", {
    Text = "Notify Entities",
    Default = false,
    Tooltip = "Sends a notification when an entity spawns."
})

Groupboxes.Visuals_Entities:AddDivider()

Groupboxes.Visuals_Entities:AddToggle("NotifyLibraryCode", {
    Text = "Notify Library Code",
    Default = false,
    Tooltip = "Automatically solves the code for the library padlock."
})

Groupboxes.Visuals_Entities:AddToggle("NotifyOxygen", {
    Text = "Notify Oxygen",
    Default = false,
    Tooltip = "Shows how much oxygen you have remaining."
})

Globals.LibraryCodeFound = false

Toggles.NotifyLibraryCode:OnChanged(function(Value)
    if Value then
        local Code = Functions.GetLibraryCode()
        if Code and not string.find(Code, "_") and Globals.LibraryCodeFound ~= true and CurrentRooms:FindFirstChild("50") then
            local Lock = workspace:FindFirstChild("Padlock", true)
            Functions.Notify({Title = "Padlock code found!", Body = "The code is: '" .. Code .. "'", Time = 15})
            Globals.LibraryCodeFound = true
        end
    end
end)

Toggles.NotifyOxygen:OnChanged(function(Value)
    Globals.OxygenUI_Text.Text = Functions.FormatOxygen(Character:GetAttribute("Oxygen"))
    Globals.OxygenUI.Enabled = (Value and Character:GetAttribute("Oxygen") < 100 and true or false)
end)

Groupboxes.Visuals_EntitySettings = Groupboxes.Visuals_RightTab:AddTab("Settings")

Groupboxes.Visuals_EntitySettings:AddToggle("EntityChatToggle", {
    Text = "Chat Message",
    Default = false,
    Tooltip = "Sends a message in the chat when an entity spawns."
})

Groupboxes.Visuals_EntitySettings:AddInput("EntityChatMessage", {
    Text = "Message",
    Default = "spawned!",
    Numeric = false,
    Placeholder = "Message"
})

Groupboxes.Visuals_EntitySettings:AddDivider()

Groupboxes.Visuals_EntitySettings:AddSlider("NotifySoundVolume", {
    Text = "Sound Volume",
    Min = 0,
    Max = 10,
    Default = 3,
    Rounding = 1
})

Groupboxes.Visuals_EntitySettings:AddToggle("NotifyPlaySound", {
    Text = "Play Sound",
    Default = true,
    Tooltip = "Makes notifications play an alert sound."
})

Groupboxes.Visuals_ESP = Tabs.Visuals:AddRightTabbox("ESP/Settings")

Groupboxes.Visuals_ESP_Toggles = Groupboxes.Visuals_ESP:AddTab("ESP")
Groupboxes.Visuals_ESP_Settings = Groupboxes.Visuals_ESP:AddTab("Settings")

Groupboxes.Visuals_ESP_Toggles:AddToggle("ObjectiveESPToggle", {
    Text = "Objectives",
    Default = false,
    Tooltip = "Highlights all objects required to progress."
})

Toggles.ObjectiveESPToggle:AddColorPicker("ObjectiveESPColor", {
    Text = "Objectives",
    Default = Color3.fromRGB(0, 255, 0),
    Transparency = 0
})

Toggles.ObjectiveESPToggle:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Objectives) do
        if Value then
            if Object.Name == "KeyObtain" then
                Functions.AddESP({
                Object = Object,
                Text = "Door Key",
                Color = Options.ObjectiveESPColor.Value
            }, true)
            elseif Object.Name == "ElectricalKeyObtain" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Electrical Key",
                    Color = Options.ObjectiveESPColor.Value
                }, true)
            elseif Object.Name == "TimerLever" then
                Functions.AddESP({
                Object = Object,
                Text = "Time Lever [+" .. Object:GetAttribute("AddTime") .. "s]",
                Color = Options.ObjectiveESPColor.Value
            }, true)
            elseif Object.Name == "MinesAnchor" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Anchor [" .. Object:WaitForChild("Sign").TextLabel.Text .. "]",
                    Color = Options.ObjectiveESPColor.Value
                }, true)
            elseif Object.Name == "WaterPump" then
                Functions.AddESP({
                    Object = Object.Wheel,
                    Text = "Water Pump",
                    Color = Options.ObjectiveESPColor.Value
                }, true)
            elseif Object.Name == "LiveHintBook" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Hint Book",
                    Color = Options.ObjectiveESPColor.Value
                }, true)
            elseif Object.Name == "LiveBreakerPolePickup" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Fuse Breaker",
                    Color = Options.ObjectiveESPColor.Value
                }, true)
            elseif Object.Name == "LibraryHintPaper" or Object.Name == "PickupItem" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Hint Paper",
                    Color = Options.ObjectiveESPColor.Value
                }, true)
            elseif Object.Name == "LeverForGate" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Gate Lever",
                    Color = Options.ObjectiveESPColor.Value
                }, true)
            elseif Object.Name == "VineGuillotine" then
                Functions.AddESP({
                    Object = Object.Lever,
                    Text = "Vine Lever",
                    Color = Options.ObjectiveESPColor.Value
                }, true)
            elseif Object.Name == "MinesGenerator" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Generator",
                    Color = Options.ObjectiveESPColor.Value
                }, true)
            elseif Object.Name == "FuseObtain" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Generator Fuse",
                    Color = Options.ObjectiveESPColor.Value
                }, true)
            elseif Object.Name == "MinesGateButton" or Object.Name == "GardenGateButton" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Gate Button",
                    Color = Options.ObjectiveESPColor.Value
                }, true)
            end
        else
            Functions.RemoveESP(Object)
        end
    end
end)

Options.ObjectiveESPColor:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Objectives) do
        Abysall.ESPLibrary:UpdateObjectColor(Object, Value)
    end
end)

Groupboxes.Visuals_ESP_Toggles:AddToggle("DoorESPToggle", {
    Text = "Doors",
    Default = false,
    Tooltip = "Highlights the next door."
})

Toggles.DoorESPToggle:AddColorPicker("DoorESPColor", {
    Text = "Doors",
    Default = Color3.fromRGB(0, 200, 255),
    Transparency = 0
})

Toggles.DoorESPToggle:OnChanged(function(Value)
     for Index, Object in pairs(Objects.Doors) do
        if Value then
            Functions.AddESP({
                Object = Object,
                Text = "Door",
                Color = Options.DoorESPColor.Value
            }, true)
        else
            Functions.RemoveESP(Object)
        end
    end
end)

Options.DoorESPColor:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Doors) do
        Abysall.ESPLibrary:UpdateObjectColor(Object, Value)
    end
end)

Groupboxes.Visuals_ESP_Toggles:AddToggle("HidingSpotESPToggle", {
    Text = "Hiding Spots",
    Default = false,
    Tooltip = "Highlights places where you can hide from entities"
})

Toggles.HidingSpotESPToggle:AddColorPicker("HidingSpotESPColor", {
    Text = "Hiding Spots",
    Default = Color3.fromRGB(255, 170, 0),
    Transparency = 0
})

Toggles.HidingSpotESPToggle:OnChanged(function(Value)
    for Index, Object in pairs(Objects.HidingSpots) do
        if Value then
            if Object.Name == "Wardrobe" or Object.Name == "Backdoor_Wardrobe" or Object.Name == "Toolshed" or Object.Name == "RetroWardrobe" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Closet",
                    Color = Options.HidingSpotESPColor.Value
                }, true)
            elseif Object.Name == "Locker_Large" or Object.Name == "Rooms_Locker" or Object.Name == "Rooms_Locker_Fridge" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Locker",
                    Color = Options.HidingSpotESPColor.Value
                }, true)
            elseif Object.Name == "Bed" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Bed",
                    Color = Options.HidingSpotESPColor.Value
                }, true)
            elseif Object.Name == "Double_Bed" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Double Bed",
                    Color = Options.HidingSpotESPColor.Value
                }, true)
            elseif Object.Name == "CircularVent" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Vent",
                    Color = Options.HidingSpotESPColor.Value
                }, true)
            elseif Object.Name == "Dumpster" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Dumpster",
                    Color = Options.HidingSpotESPColor.Value
                })
            end
        else
            Functions.RemoveESP(Object)
        end
    end
end)

Options.HidingSpotESPColor:OnChanged(function(Value)
    for Index, Object in pairs(Objects.HidingSpots) do
        Abysall.ESPLibrary:UpdateObjectColor(Object, Value)
    end
end)

Groupboxes.Visuals_ESP_Toggles:AddToggle("PlayerESPToggle", {
    Text = "Players",
    Default = false,
    Tooltip = "Highlights other players."
})

Toggles.PlayerESPToggle:AddColorPicker("PlayerESPColor", {
    Text = "Players",
    Default = Color3.fromRGB(255, 255, 255),
    Transparency = 0
})

Toggles.PlayerESPToggle:OnChanged(function(Value)
    task.wait()
    for Index, Object in pairs(Services.Players:GetPlayers()) do
        if Object.Character and Object ~= LocalPlayer then
            if Value then
                Functions.AddESP({
                    Object = Object.Character,
                    Text = Object.Name,
                    Color = Options.PlayerESPColor.Value
                })
            else
                Functions.RemoveESP(Object.Character)
            end
        end
    end
end)

Options.PlayerESPColor:OnChanged(function(Value)
    for Index, Object in pairs(Services.Players:GetPlayers()) do
        if Object.Character and Object ~= LocalPlayer then
            Abysall.ESPLibrary:UpdateObjectText(Object.Character, Value)
        end
    end
end)

Groupboxes.Visuals_ESP_Toggles:AddToggle("ChestESPToggle", {
    Text = "Chests",
    Default = false,
    Tooltip = "Highlights objects that can contain loot."
})

Toggles.ChestESPToggle:AddColorPicker("ChestESPColor", {
    Text = "Chests",
    Default = Color3.fromRGB(255, 255, 0),
    Transparency = 0
})

Toggles.ChestESPToggle:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Chests) do
        if Value then
            if Object.Name == "ChestBox" or Object.Name == "ChestBoxLocked" then
                Functions.AddESP({
                    Object = Object,
                    Text = (Object:GetAttribute("Locked") and "Locked Chest" or "Chest"),
                    Color = Options.ChestESPColor.Value
                }, true)
            elseif Object.Name == "Toolbox" or Object.Name == "Toolbox_Locked" then
                Functions.AddESP({
                    Object = Object,
                    Text = (Object:GetAttribute("Locked") and "Locked Toolbox" or "Toolbox"),
                    Color = Options.ChestESPColor.Value
                }, true)
            elseif Object.Name == "Chest_Vine" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Vine Chest",
                    Color = Options.ChestESPColor.Value
                }, true)
            elseif Object.Name == "Toolshed_Small" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Toolshed",
                    Color = Options.ChestESPColor.Value
                }, true)
            elseif Object.Name == "Locker_Small_Locked" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Locked Item Locker",
                    Color = Options.ChestESPColor.Value
                }, true)
            elseif Object.Name == "MouseHole" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Mouse",
                    Color = Options.ChestESPColor.Value
                }, true)
            end
        else
            Functions.RemoveESP(Object)
        end
    end
end)

Options.ChestESPColor:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Chests) do
        Abysall.ESPLibrary:UpdateObjectColor(Object, Value)
    end
end)

Groupboxes.Visuals_ESP_Toggles:AddToggle("ItemESPToggle", {
    Text = "Items",
    Default = false,
    Tooltip = "Highlights all collectable items/consumables."
})

Toggles.ItemESPToggle:AddColorPicker("ItemESPColor", {
    Text = "Items",
    Default = Color3.fromRGB(170, 0, 255),
    Transparency = 0
})

Toggles.ItemESPToggle:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Items) do
        if Value then
            if ItemNames[Object.Name] then
                Functions.AddESP({
                    Object = Object,
                    Text = ItemNames[Object.Name],
                    Color = Options.ItemESPColor.Value
                }, (Object:GetAttribute("ParentRoom") and true or false))
            elseif Object.Name == "Green_Herb" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Green Herb",
                    Color = Options.ItemESPColor.Value
                }, true)
            end
        else
            Functions.RemoveESP(Object)
        end
    end
end)

Options.ItemESPColor:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Items) do
        Abysall.ESPLibrary:UpdateObjectColor(Object, Value)
    end
end)

Groupboxes.Visuals_ESP_Toggles:AddToggle("CurrencyESPToggle", {
    Text = "Currency",
    Default = false,
    Tooltip = "Highlights all currency that spawns."
})

Toggles.CurrencyESPToggle:AddColorPicker("CurrencyESPColor", {
    Text = "Currency",
    Default = Color3.fromRGB(255, 255, 0),
    Transparency = 0
})

Toggles.CurrencyESPToggle:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Currency) do
        if Value then
            if Object.Name == "GoldPile" and Object:GetAttribute("GoldValue") then
                Functions.AddESP({
                    Object = Object,
                    Text = "Gold Pile [" .. Object:GetAttribute("GoldValue") .. "]",
                    Color = Options.CurrencyESPColor.Value
                }, true)
            elseif Object.Name == "StardustPickup" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Stardust Pile",
                    Color = Options.CurrencyESPColor.Value
                }, true)
            end
        else
            Functions.RemoveESP(Object)
        end
    end
end)

Options.CurrencyESPColor:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Currency) do
        Abysall.ESPLibrary:UpdateObjectColor(Object, Value)
    end
end)

Groupboxes.Visuals_ESP_Toggles:AddToggle("EntityESPToggle", {
    Text = "Entities",
    Default = false,
    Tooltip = "Highlights all entities that spawn."
})

Toggles.EntityESPToggle:AddColorPicker("EntityESPColor", {
    Text = "Entities",
    Default = Color3.fromRGB(255, 0, 0),
    Transparency = 0
})

Toggles.EntityESPToggle:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Entities) do
        if Value then
            if Entities[Object.Name] then
                local EntityData = Entities[Object.Name]
                Functions.AddESP({
                    Object = Object,
                    Text = EntityData.Alias,
                    Color = Options.EntityESPColor.Value
                })
            elseif Object.Name == "KeyObtainFake" then
                Functions.AddESP({
                Object = Object,
                Text = "Fake Key",
                Color = Options.EntityESPColor.Value
                }, true)
            elseif Object.Name == "JeffTheKiller" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Jeff the Killer",
                    Color = Options.EntityESPColor.Value
                }, true)
            elseif Object.Name == "GiggleCeiling" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Giggle",
                    Color = Options.EntityESPColor.Value
                }, true)
            elseif Object.Name == "GloomPile" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Gloombat Eggs",
                    Color = Options.EntityESPColor.Value
                }, true)
            elseif Object.Name == "Snare" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Snare",
                    Color = Options.EntityESPColor.Value
                }, true)
            elseif Object.Name == "GrumbleRig" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Grumble",
                    Color = Options.EntityESPColor.Value
                }, true)
            elseif Object.Name == "Drakobloxxer" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Drakobloxxer",
                    Color = Options.EntityESPColor.Value
                }, true)
            elseif Object.Name == "Hole" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Mandrake Hole",
                    Color = Options.EntityESPColor.Value
                }, true)
            elseif Object.Name == "Groundskeeper" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Groundskeeper",
                    Color = Options.EntityESPColor.Value
                }, true)
            elseif Object.Name == "LiveEntityBramble" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Bramble",
                    Color = Options.EntityESPColor.Value
                }, true)
            elseif Object.Name == "Figure" or Object.Name == "FigureRig" or Object.Name == "FigureRagdoll" then
                Functions.AddESP({
                    Object = Object,
                    Text = "Figure",
                    Color = Options.EntityESPColor.Value
                }, true)
            end
        else
            Functions.RemoveESP(Object)
        end
    end
end)

Options.EntityESPColor:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Entities) do
        Abysall.ESPLibrary:UpdateObjectColor(Object, Value)
    end
end)

Groupboxes.Visuals_ESP_Toggles:AddToggle("LadderESPToggle", {
    Text = "Ladders",
    Default = false,
    Tooltip = "Highlights ladders that can be used to disable the anticheat."
})

Toggles.LadderESPToggle:AddColorPicker("LadderESPColor", {
    Text = "Ladders",
    Default = Color3.fromRGB(255, 255, 255),
    Transparency = 0
})

Toggles.LadderESPToggle:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Ladders) do
        if Value then
            Functions.AddESP({
                Object = Object,
                Text = "Ladder",
                Color = Options.LadderESPColor.Value
            }, true)
        else
            Functions.RemoveESP(Object)
        end
    end
end)

Options.LadderESPColor:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Ladders) do
        Abysall.ESPLibrary:UpdateObjectColor(Object, Value)
    end
end)

Groupboxes.Visuals_ESP_Settings:AddToggle("ESPRainbow", {
    Text = "Rainbow Effect",
    Default = false,
    Tooltip = "Makes the esp objects change colour like a rainbow."
})

Groupboxes.Visuals_ESP_Settings:AddToggle("ESPShowDistance", {
    Text = "Show Distance",
    Default = false,
    Tooltip = "Shows how far away your character is from the object."
})

Groupboxes.Visuals_ESP_Settings:AddDivider()

Groupboxes.Visuals_ESP_Settings:AddSlider("ESPFillTransparency", {
    Text = "Fill Transparency",
    Min = 0,
    Max = 1,
    Default = 0.75,
    Rounding = 2,
    Compact = true
})

Groupboxes.Visuals_ESP_Settings:AddSlider("ESPOutlineTransparency", {
    Text = "Outline Transparency",
    Min = 0,
    Max = 1,
    Default = 0,
    Rounding = 2,
    Compact = true
})

Groupboxes.Visuals_ESP_Settings:AddSlider("ESPFadeTime", {
    Text = "Fade Time",
    Min = 0,
    Max = 1,
    Default = 0.25,
    Rounding = 2,
    Compact = true
})

Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTextSize", {
    Text = "Text Size",
    Min = 12,
    Max = 24,
    Default = 18,
    Rounding = 0,
    Compact = true
})

Groupboxes.Visuals_ESP_Settings:AddDropdown("ESPTextFont", {
    Text = "Text Font",
    Values = {
        "Legacy",
        "Arial",
        "ArialBold",
        "SourceSans",
        "SourceSansBold",
        "SourceSansLight",
        "SourceSansItalic",
        "Bodoni",
        "Garamond",
        "Cartoon",
        "Code",
        "Highway",
        "SciFi",
        "Arcade",
        "Fantasy",
        "Antique",
        "SourceSansSemibold",
        "Gotham",
        "GothamMedium",
        "GothamBold",
        "GothamBlack",
        "AmaticSC",
        "Bangers",
        "Creepster",
        "DenkOne",
        "Fondamento",
        "FredokaOne",
        "GrenzeGotisch",
        "IndieFlower",
        "JosefinSans",
        "Jura",
        "Kalam",
        "LuckiestGuy",
        "Merriweather",
        "Michroma",
        "Nunito",
        "Oswald",
        "PatrickHand",
        "PermanentMarker",
        "Roboto",
        "RobotoCondensed",
        "RobotoMono",
        "Sarpanch",
        "SpecialElite",
        "TitilliumWeb",
        "Ubuntu",
        "BuilderSans",
        "BuilderSansMedium",
        "BuilderSansBold",
        "BuilderSansExtraBold",
        "Arimo",
        "ArimoBold",
        },
    Default = 41
})

Groupboxes.Visuals_ESP_Settings:AddDivider()

Groupboxes.Visuals_ESP_Settings:AddDropdown("ESPTracersOrigin", {
    Text = "Tracer Origin",
    Values = {
        "Bottom",
        "Center",
        "Top",
        "Mouse"
    },
    Default = 1,
})

Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTracerThickness", {
    Text = "Tracer Thickness",
    Min = 0.5,
    Max = 2,
    Default = 0.75,
    Rounding = 2,
    Compact = true
})

Groupboxes.Visuals_ESP_Settings:AddToggle("ESPTracersToggle", {
    Text = "Enable Tracers",
    Default = false,
    Tooltip = "Draws a line to highlighted objects."
})

Groupboxes.Visuals_ESP_Settings:AddDivider()

Groupboxes.Visuals_ESP_Settings:AddSlider("ESPArrowsRadius", {
    Text = "Arrow Radius",
    Min = 100,
    Max = 500,
    Default = 250,
    Rounding = 0,
    Compact = true
})

Groupboxes.Visuals_ESP_Settings:AddToggle("ESPArrowsToggle", {
    Text = "Enable Arrows",
    Default = false,
    Tooltip = "Shows arrow that point to off-screen objects."
})

Abysall.ESPLibrary:SetRainbow(false)
Abysall.ESPLibrary:SetShowDistance(false)
Abysall.ESPLibrary:SetFillTransparency(0.75)
Abysall.ESPLibrary:SetOutlineTransparency(0)
Abysall.ESPLibrary:SetFadeTime(0.25)
Abysall.ESPLibrary:SetTextSize(18)
Abysall.ESPLibrary:SetFont(Enum.Font.RobotoCondensed)
Abysall.ESPLibrary:SetTracers(false)
Abysall.ESPLibrary:SetTracerSize(0.75)
Abysall.ESPLibrary:SetTracerOrigin("Bottom")
Abysall.ESPLibrary:SetArrows(false)
Abysall.ESPLibrary:SetArrowRadius(250)
Abysall.ESPLibrary:SetDistanceSizeRatio(0.8)

Toggles.ESPRainbow:OnChanged(function(Value)
    Abysall.ESPLibrary:SetRainbow(Value)
end)

Toggles.ESPShowDistance:OnChanged(function(Value)
    Abysall.ESPLibrary:SetShowDistance(Value)
end)

Options.ESPFillTransparency:OnChanged(function(Value)
    Abysall.ESPLibrary:SetFillTransparency(Value)
end)

Options.ESPOutlineTransparency:OnChanged(function(Value)
    Abysall.ESPLibrary:SetOutlineTransparency(Value)
end)

Options.ESPFadeTime:OnChanged(function(Value)
    Abysall.ESPLibrary:SetFadeTime(Value)
end)

Options.ESPTextSize:OnChanged(function(Value)
    Abysall.ESPLibrary:SetTextSize(Value)
end)

Options.ESPTextFont:OnChanged(function(Value)
    Abysall.ESPLibrary:SetFont(Enum.Font[Value])
end)

Toggles.ESPTracersToggle:OnChanged(function(Value)
    Abysall.ESPLibrary:SetTracers(Value)
end)

Options.ESPTracersOrigin:OnChanged(function(Value)
    Abysall.ESPLibrary:SetTracerOrigin(Value)
end)

Options.ESPTracerThickness:OnChanged(function(Value)
    Abysall.ESPLibrary:SetTracerSize(Value)
end)

Toggles.ESPArrowsToggle:OnChanged(function(Value)
    Abysall.ESPLibrary:SetArrows(Value)
end)

Options.ESPArrowsRadius:OnChanged(function(Value)
    Abysall.ESPLibrary:SetArrowRadius(Value)
end)

Groupboxes.Floors_Automation = Tabs.Floors:AddRightGroupbox("Automation")

Groupboxes.Floors_Automation:AddToggle("AutoSteerMinecart", {
    Text = "Auto Steer Minecart",
    Default = false,
    Tooltip = "Automatically completes the minecart chase.",

    Disabled = not Functions.CheckCompatability({"require"}),
    DisabledTooltip = Globals.IncompatibleMessage
})

Groupboxes.Floors_Automation:AddSlider("AutoSteerMinecartTurnDistance", {
    Text = "Turn Distance",
    Min = 20,
    Max = 50,
    Default = 35,
    Rounding = 0,

    Disabled = not Functions.CheckCompatability({"require"}),
    DisabledTooltip = Globals.IncompatibleMessage
})

Groupboxes.Floors_Automation:AddSlider("AutoSteerMinecartDuckDistance", {
    Text = "Crouch Distance",
    Min = 20,
    Max = 50,
    Default = 35,
    Rounding = 0,

    Disabled = not Functions.CheckCompatability({"require"}),
    DisabledTooltip = Globals.IncompatibleMessage
})

Groupboxes.Floors_Automation:AddDivider()

Groupboxes.Floors_Automation:AddToggle("RoomsAutoWalk", {
    Text = "Rooms Auto-Walk",
    Default = false,
    Tooltip = "Automatically moves and hides from entities in The Rooms."
})

Groupboxes.Floors_Automation:AddSlider("RoomsAutoWalkPathfindTimeout", {
    Text = "Pathfind Timeout",
    Min = 0.5,
    Max = 3,
    Default = 1,
    Rounding = 1
})

Groupboxes.Floors_Automation:AddToggle("RoomsAutoWalkShowPathToggle", {
    Text = "Show Path",
    Default = false,
    Tooltip = "Shows the current path of rooms auto-walk."
})

Toggles.RoomsAutoWalk:OnChanged(function(Value)
    for Index, Object in pairs(Globals.RoomsNodesFolder:GetChildren()) do
        if Object.Name == "PathNode" then
            Object:Destroy()
        end
    end
end)

Toggles.RoomsAutoWalkShowPathToggle:AddColorPicker("RoomsAutoWalkShowPathColor", {
    Text = "Path",
    Default = Color3.fromRGB(0, 255, 0),
    Transparency = 0
})

Toggles.RoomsAutoWalkShowPathToggle:OnChanged(function(Value)
    for Index, Object in pairs(Globals.RoomsNodesFolder:GetChildren()) do
        if Object.Name == "PathNode" then
            Object.Transparency = (Value and 0.5 or 1)
        end
    end
end)

Options.RoomsAutoWalkShowPathColor:OnChanged(function(Value)
    for Index, Object in pairs(Globals.RoomsNodesFolder:GetChildren()) do
        if Object.Name == "PathNode" then
            Object.Color = Value
        end
    end
end)

Functions.RoomsAutoWalk = {}

Functions.RoomsAutoWalk.GetNearestHidingSpot = function()
    local Nearest = {
        Distance = math.huge,
        Object = nil
    }

    for Index, Object in pairs(Objects.HidingSpots) do
        if Object.PrimaryPart and Object:FindFirstChild("HidePrompt") then
            local Distance = LocalPlayer:DistanceFromCharacter(Object.PrimaryPart.Position)
            if Distance < Nearest.Distance then
                Nearest.Distance = Distance
                Nearest.Object = Object
            end
        end
    end
    return Nearest.Object
end

Functions.RoomsAutoWalk.GetPathfindTarget = function()
    local EntityList = {
        "RushMoving",
        "AmbushMoving",
        "BackdoorRush",
        "A60",
        "A120",
        "CustomEntity",
        "GlitchRush",
        "GlitchAmbush"
    }

    for Index, Object in pairs(Services.Workspace:GetChildren()) do
        if table.find(EntityList, Object.Name) and Object.PrimaryPart and Object.PrimaryPart.Position.Y > -10 and Object.PrimaryPart.Position.Y < 150 then
            return Functions.RoomsAutoWalk.GetNearestHidingSpot() or CurrentRooms[tostring(LatestRoom.Value)]:FindFirstChild("RoomExit")
        end
    end
    return CurrentRooms[tostring(LatestRoom.Value)]:FindFirstChild("RoomExit")
end

local ActivePaths = 0
Connections.RoomsAutoWalkHandler = Services.RunService.RenderStepped:Connect(function()
    if Floor == "Rooms" and Toggles.RoomsAutoWalk.Value and not Globals.RoomsAutoWalkActive then
        local Path = Services.PathfindingService:CreatePath({
            AgentCanJump = true,
            AgentCanClimb = false,
            WaypointSpacing = 3,
            AgentRadius = 1.5,
            AgentHeight = 1.5,
            Costs = {
                StuckPart = 8
            }
        })

        local TargetPart = Functions.RoomsAutoWalk.GetPathfindTarget()
        local TargetPosition
        if TargetPart then
            if TargetPart.Name == "RoomExit" then
                TargetPosition = TargetPart.Position
            elseif TargetPart:FindFirstChild("HidePrompt") then
                for Index, Object in pairs(TargetPart:GetDescendants()) do
                    if Object:IsA("BasePart") then
                        Object.CanCollide = false
                    end
                end
                TargetPosition = TargetPart.PrimaryPart.Position
            end

            if TargetPosition and LocalPlayer:DistanceFromCharacter(TargetPosition) < 750 then
                Path:ComputeAsync(CollisionPart.Position, TargetPosition)
                if #Path:GetWaypoints() == 0 then
                    Humanoid:MoveTo(CurrentRooms[tostring(LatestRoom.Value)]:FindFirstChild("RoomExit").Position)
                else
                    Globals.RoomsAutoWalkActive = true
                    local Stuck = false

                    for Index, Object in pairs(Globals.RoomsNodesFolder:GetChildren()) do
                        if Object.Name == "PathNode" then
                            Object:Destroy()
                        end
                    end

                    for Index, Waypoint in pairs(Path:GetWaypoints()) do
                        local Block = Instance.new("Part", Globals.RoomsNodesFolder)
                        Block.Transparency = (Toggles.RoomsAutoWalkShowPathToggle.Value and 0.5 or 1)
                        Block.Size = Vector3.new(1, 1, 1)
                        Block.Position = Waypoint.Position
                        Block.Shape = Enum.PartType.Ball
                        Block.CanCollide = false
                        Block.Anchored = true
                        Block.Name = "PathNode"
                        Block.Color = Options.RoomsAutoWalkShowPathColor.Value
                        Block.Material = Enum.Material.Neon
                    end

                    for Index, Waypoint in pairs(Path:GetWaypoints()) do
                        if Stuck then
                            break
                        end

                        local Connection
                        local Finished = false
                        local Start = tick()
                        Connection = Services.RunService.RenderStepped:Connect(function()
                            if Stuck then
                                Finished = true
                            end
                            if not Toggles.RoomsAutoWalk.Value then
                                Finished = true
                            end
                            if Functions.RoomsAutoWalk.GetPathfindTarget():FindFirstChild("HidePrompt") and not TargetPart:FindFirstChild("HidePrompt") then
                                Finished = true
                            end
                            if TargetPart:FindFirstChild("HidePrompt") and LocalPlayer:DistanceFromCharacter(TargetPosition) < TargetPart:FindFirstChild("HidePrompt").MaxActivationDistance and Character:GetAttribute("Hiding") ~= true then
                                Functions.ForceFirePrompt(TargetPart:FindFirstChild("HidePrompt"))
                            elseif Character:GetAttribute("Hiding") == true and not TargetPart:FindFirstChild("HidePrompt") then
                                RemotesFolder.CamLock:FireServer()
                            end
                            local NewPosition = Vector3.new(Waypoint.Position.X, RootPart.Position.Y, Waypoint.Position.Z)
                            if LocalPlayer:DistanceFromCharacter(NewPosition) < 4 then
                                Finished = true
                            end
                            Humanoid:MoveTo(Waypoint.Position)
                        end)
                        while not Finished do
                            if tick() - Start > Options.RoomsAutoWalkPathfindTimeout.Value then
                                local Block = Instance.new("Part", Globals.RoomsNodesFolder)
                                Block.Transparency = 1
                                Block.Size = Vector3.new(1, 1, 1)
                                Block.CFrame = Collision.CFrame
                                Block.Shape = Enum.PartType.Ball
                                Block.CanCollide = false
                                Block.Anchored = true
                                Block.Name = "StuckPart"

                                local Modifier = Instance.new("PathfindingModifier", Block)
                                Modifier.Label = "StuckPart"
                                Stuck = true
                                break
                            end
                            task.wait()
                        end
                        Connection:Disconnect()
                        Humanoid:MoveTo(RootPart.Position)
                    end
                    Globals.RoomsAutoWalkActive = false
                end
            end
        end
    end
end)

Connections.RoomsHandler = CurrentRooms.ChildAdded:Connect(function(Room)
    for Index, Object in pairs(Globals.RoomsNodesFolder:GetChildren()) do
        if Object.Name == "StuckPart" then
            Object:Destroy()
        end
    end
    if Room:GetAttribute("RawName") and string.find(Room:GetAttribute("RawName"), "Eyestalk") then
        local function CreateNode(Object2)
            local NewNode = Instance.new("Part")
            NewNode.Size = Vector3.new(1,1,1)
            NewNode.Transparency = 1
            NewNode.Parent = Globals.SeekNodesFolder
            NewNode.Anchored = true
            NewNode.Position = Object2.Position
            NewNode.CanCollide = false
            NewNode.Name = "SeekLightNode"

            if PreviousNode == nil then
                PreviousNode = NewNode
            end

            local NewBeam = Instance.new("Beam")
            NewBeam.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Options.ShowEyestalkPathColor.Value),
                ColorSequenceKeypoint.new(1, Options.ShowEyestalkPathColor.Value)
            })

            NewBeam.FaceCamera = true
            NewBeam.Width0 = 0.2
            NewBeam.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, (Toggles.ShowEyestalkPathToggle.Value and 0 or 1)),
                NumberSequenceKeypoint.new(1, (Toggles.ShowEyestalkPathToggle.Value and 0 or 1)),
            })

            NewBeam.Width1 = 0.2
            NewBeam.Brightness = 10
            NewBeam.LightInfluence = 0
            NewBeam.LightEmission = 0
            NewBeam.Enabled = true
            NewBeam.Parent = Globals.SeekNodesFolder

            local Attachment0 = Instance.new("Attachment")
            Attachment0.Parent = NewNode

            local Attachment1 = Instance.new("Attachment")
            Attachment1.Parent = PreviousNode

            NewBeam.Attachment0 = Attachment0
            NewBeam.Attachment1 = Attachment1

            PreviousNode = NewNode
            table.insert(Objects.EyestalkHighlights, NewBeam)
        end

        Room:WaitForChild("RoomEntrance", 9e9)
        Room:WaitForChild("RoomExit", 9e9)

        while not Room:GetAttribute("PathFound") do
            if Toggles.ShowEyestalkPathToggle.Value then
                local Path = game:GetService("PathfindingService"):CreatePath({
                    AgentCanJump = false,
                    AgentCanClimb = false,
                    WaypointSpacing = 2,
                    AgentRadius = 1,
                    AgentHeight = 1
                })

                Path:ComputeAsync(RootPart.Position, Room.RoomExit.Position)
                if Path.Status == Enum.PathStatus.Success then
                    for Index, Object in pairs(Path:GetWaypoints()) do
                        CreateNode(Object)
                    end
                    Room:SetAttribute("PathFound", true)
                end
            end
            task.wait(0.1)
        end
    end
end)

Groupboxes.Floors_Visuals = Tabs.Floors:AddLeftGroupbox("Visuals")

Groupboxes.Floors_Visuals:AddToggle("ShowSeekPathToggle", {
    Text = "Show Seek Path",
    Default = false,
    Tooltip = "Shows you the correct path in seek chases.",

    Risky = not (Floor == "Mines")
})

Toggles.ShowSeekPathToggle:AddColorPicker("ShowSeekPathColor", {
    Text = "Seek Path",
    Default = Color3.fromRGB(0, 255, 0),
    Transparency = 0
})

Toggles.ShowSeekPathToggle:OnChanged(function(Value)
    for Index, Object in pairs(Objects.SeekHighlights) do
        Object.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, (Value and 0 or 1)),
			NumberSequenceKeypoint.new(1, (Value and 0 or 1)),
		})
    end
end)

Options.ShowSeekPathColor:OnChanged(function(Value)
    for Index, Object in pairs(Objects.SeekHighlights) do
        Object.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Value),
			ColorSequenceKeypoint.new(1, Value)
		})
    end
end)

Groupboxes.Floors_Visuals:AddToggle("ShowEyestalkPathToggle", {
    Text = "Show Eyestalk Path",
    Default = false,
    Tooltip = "Shows you the correct path in the eyestalk chase.",

    Risky = not (Floor == "Garden")
})

Toggles.ShowEyestalkPathToggle:AddColorPicker("ShowEyestalkPathColor", {
    Text = "Eyestalk Path",
    Default = Color3.fromRGB(0, 255, 0),
    Transparency = 0
})

Toggles.ShowEyestalkPathToggle:OnChanged(function(Value)
    for Index, Object in pairs(Objects.EyestalkHighlights) do
        Object.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, (Value and 0 or 1)),
			NumberSequenceKeypoint.new(1, (Value and 0 or 1)),
		})
    end
end)

Options.ShowEyestalkPathColor:OnChanged(function(Value)
    for Index, Object in pairs(Objects.EyestalkHighlights) do
        Object.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Value),
			ColorSequenceKeypoint.new(1, Value)
		})
    end
end)

Groupboxes.Floors_Bypass = Tabs.Floors:AddLeftGroupbox("Bypass")

Groupboxes.Floors_Bypass:AddToggle("RemoveSeekTrigger", {
    Text = "Delete Seek Trigger",
    Default = false,
    Tooltip = "Diables the 'Seek' chase trigger.",

    Risky = not (Floor == "Fools" and true or Floor == "OldHotel" and true or false),
    Disabled = not Functions.CheckCompatability({"firetouchinterest"}),
    DisabledTooltip = Globals.IncompatibleMessage
})

Groupboxes.Floors_Bypass:AddToggle("RemoveFigure", {
    Text = "Delete Figure",
    Default = false,
    Tooltip = "Completely removes the entity 'Figure' (doesn't work in some places).",

    Risky = not (Floor == "Fools" and true or Floor == "OldHotel" and true or Floor == "Mines" and true or false),
    Disabled = not Functions.CheckCompatability({"isnetworkowner", "firetouchinterest"}),
    DisabledTooltip = Globals.IncompatibleMessage
})

Groupboxes.Floors_Bypass:AddToggle("AutoRevive", {
    Text = "Infinite Revives",
    Default = false,
    Tooltip = "Automatically revives after dying, with unlimited respawns.",

    Risky = not (Floor == "Fools" and true or Floor == "OldHotel" and true or false)
})

Groupboxes.Floors_Bypass:AddDivider()

Groupboxes.Floors_Bypass:AddToggle("RemoveBasementGate", {
    Text = "Remove Basement Gate",
    Default = false,
    Tooltip = "Removes the gate from basement rooms.",

    Risky = not (Floor == "Fools" and true or Floor == "OldHotel" and true or false)
})

Groupboxes.Floors_Bypass:AddToggle("RemovePaintingsDoor", {
    Text = "Remove Paintings Door",
    Default = false,
    Tooltip = "Removes the fireplace doors from painting rooms.",

    Risky = not (Floor == "Fools" and true or Floor == "OldHotel" and true or false)
})

Groupboxes.Floors_Bypass:AddToggle("RemoveSkeletonDoor", {
    Text = "Remove Skeleton Door",
    Default = false,
    Tooltip = "Removes the skeleton door from the infirmary.",

    Risky = not (Floor == "Fools" and true or false)
})

Toggles.RemoveSeekTrigger:OnChanged(function(Value)
    if Floor == "Fools" or Floor == "OldHotel" then
        for Index, Object in pairs(Objects.EventTriggers) do
            if tonumber(Object:GetAttribute("ParentRoom")) ~= tonumber(LocalPlayer:GetAttribute("CurrentRoom")) then
                task.spawn(function()
                    local Tries = 0
                    while Object:FindFirstChild("Collision") and Tries < 150 do
                        for Index2, Object2 in pairs(Object:GetChildren()) do
                            if Object2:IsA("BasePart") then
                                Abysall.Environment.firetouchinterest(RootPart, Object2, 1)
                                task.wait()
                                Abysall.Environment.firetouchinterest(RootPart, Object2, 0)
                            end
                        end
                        Tries = Tries + 1
                        task.wait()
                    end
                end)
            end
        end
    end
end)

Toggles.RemoveBasementGate:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Obstructions) do
        if Object.Name == "ThingToOpen" then
            Object:PivotTo(Value and CFrame.new(-10000,-10000,-10000) or Object:GetAttribute("OriginalPosition"))
        end
    end
end)

Toggles.RemovePaintingsDoor:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Obstructions) do
        if Object.Name == "MovingDoor" then
            Object:PivotTo(Value and CFrame.new(-10000,-10000,-10000) or Object:GetAttribute("OriginalPosition"))
        end
    end
end)

Toggles.RemoveSkeletonDoor:OnChanged(function(Value)
    for Index, Object in pairs(Objects.Obstructions) do
        if Object.Name == "Wax_Door" then
            Object:PivotTo(Value and CFrame.new(-10000,-10000,-10000) or Object:GetAttribute("OriginalPosition"))
        end
    end
end)

local MainHook
if Functions.CheckCompatability({"hookmetamethod", "newcclosure", "getnamecallmethod"}) then
    MainHook = Abysall.Environment.hookmetamethod(game, "__namecall", Abysall.Environment.newcclosure(function(self, ...)
        local Args = {...}
        if Abysall then
            local Method = Abysall.Environment.getnamecallmethod()

            if self.Name == "Crouch" and Method == "FireServer" and Toggles.CrouchSpoof.Value or self.Name == "Crouch" and Method == "FireServer" and Toggles.PositionSpoof.Value then
                Args[1] = true
            end

            if self.Name == "MotorReplication" and Method == "FireServer" and Toggles.BypassEyes.Value and Globals.IsEyes or self.Name == "MotorReplication" and Method == "FireServer" and Toggles.BypassLookman.Value and Globals.IsLookman then
                if Floor == "Fools" or Floor == "OldHotel" then
                    Args[1] = 0
                    Args[2] = -65
                    Args[3] = 0
                    Args[4] = false
                else 
                    Args[1] = -650
                end
            end
        end

        return MainHook(self, table.unpack(Args))
    end))
end

Modules = {
    Glitch = ClientModules.EntityModules.Glitch,
    Shade = ClientModules.EntityModules.Shade,
    Void = ClientModules.EntityModules:FindFirstChild("Void")
}

Functions.HandleCharacter = function(NewCharacter)
    local OldConnections = {
        "MainHandler",
        "JumpHandler",
        "SlideHandler",
        "CrouchHandler1",
        "CrouchHandler2",
        "LibraryCodeHandler1",
        "LibraryCodeHandler2",
        "OxygenConnection",
        "AnimationHandler",
        "AutoHideConnection",
        "LagbackFixer",
        "AutoReviveHandler",
        "SHMFixer",
        "AnticheatDisabler",
        "AnticheatEnableDetector1",
        "AnticheatEnableDetector2",
        "AutoSteerMinecartDuckHandler",
        "AutoSolveAnchorsConnection",
        "InfiniteJumpsConnection1",
        "InfiniteJumpsConnection2"
    }

    for Index, Name in pairs(OldConnections) do
        if table.find(OldConnections, Name) and Connections[Name] then
            Connections[Name]:Disconnect()
        end
    end

    while Services.Workspace.CurrentCamera == Globals.OldCamera do
        task.wait()
    end

    Character = NewCharacter
    Humanoid = NewCharacter:WaitForChild("Humanoid")
    RootPart = NewCharacter:FindFirstChild("HumanoidRootPart")
    Camera = Services.Workspace.CurrentCamera

    Globals.OldCamera = Camera
    Globals.MainUI = LocalPlayer.PlayerGui.MainUI

    Collision = NewCharacter:WaitForChild("Collision")
    if NewCharacter:FindFirstChild("CollisionPart") then
        CollisionPart = NewCharacter:FindFirstChild("CollisionPart")
    else
        CollisionPart = NewCharacter:FindFirstChild("Collision")
    end

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

    OldJump = NewCharacter:GetAttribute("CanJump")
    OldSlide = NewCharacter:GetAttribute("CanSlide")

    if Toggles.EnableCharacterJump.Value then
        Character:SetAttribute("CanJump", true)
    end
    if Toggles.EnableCharacterSlide.Value then
        Character:SetAttribute("CanSlide", true)
    end

    if Functions.CheckCompatability({"require"}) then
        Main_Game = Abysall.Environment.require(Globals.MainUI.Initiator.Main_Game)
    end

    if Main_Game and Toggles.RemoveCameraBobbing.Value then
        Main_Game.spring.Speed = 9e9
    end

    if Main_Game and Functions.CheckCompatability({"require"}) then
        local Original = require(LocalPlayer.PlayerScripts.PlayerModule):GetControls().GetMoveVector
        require(LocalPlayer.PlayerScripts.PlayerModule):GetControls().GetMoveVector = function(...)
            if Toggles.AutoSteerMinecart.Value and Functions.GetNearestTurnNode() then
                local Node = Functions.GetNearestTurnNode()
                return (Node:GetAttribute("Turn") == "Left" and Vector3.new(-1, 0, 0) or Node:GetAttribute("Turn") == "Right" and Vector3.new(1, 0, 0) or Vector3.new(0, 0, 0))
            end
            return Original(...)
        end
    end

    Globals.AutoMinecartDucked = false
    Connections.AutoSteerMinecartDuckHandler = Services.RunService.Heartbeat:Connect(function()
        if Toggles.AutoSteerMinecart.Value and Functions.GetMinecart() then
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
                Camera.FieldOfView = Options.FieldOfView
            end
        end
    end)

    local UIModules = Globals.MainUI.Initiator.Main_Game.RemoteListener.Modules
    Modules.A90 = UIModules:FindFirstChild("A90")
    Modules.Screech = UIModules.Screech
    Modules.Dread = UIModules:FindFirstChild("Dread")
    Modules.SpiderJumpscare = UIModules.SpiderJumpscare

    if not Functions.CheckCompatability({"hookfunction"}) and Toggles.RemoveScreech.Value then
        Modules.Screech.Name = "Screech_Disabled"
    end

    if not Functions.CheckCompatability({"hookfunction"}) and Toggles.RemoveA90.Value and Modules.A90 then
        Modules.A90.Name = "A90_Disabled"
    end

    if not Functions.CheckCompatability({"hookfunction"}) and Toggles.RemoveDread.Value and Modules.Dread then
        Modules.Dread.Name = "Dread_Disabled"
    end

    if not Functions.CheckCompatability({"hookfunction"}) and Toggles.DisableTimothyJumpscare.Value then
        Modules.SpiderJumpscare.Name = "SpiderJumpscare_Disabled"
    end

    if Toggles.DisableHideVignette.Value then
        local Vignette = Globals.MainUI:FindFirstChild("HideVignette") or Globals.MainUI.MainFrame:FindFirstChild("HideVignette")
        if Vignette then
            Vignette.Image = "Disabled"
        end
    end

    if Toggles.RemoveInteractingSounds.Value then
        Globals.MainUI.Initiator.Main_Game.PromptService.Triggered.Volume = 0
	    Globals.MainUI.Initiator.Main_Game.PromptService.Holding.Volume = 0
        Globals.MainUI.Initiator.Main_Game.PromptService.Notification.Volume = 0
	    Globals.MainUI.Initiator.Main_Game.Reminder.Caption.Volume =  0
    end

    if not Functions.CheckCompatability({"hookfunction"}) and Toggles.DisableEntityJumpscares.Value then
        Globals.MainUI.Initiator.Main_Game.RemoteListener.Jumpscares.Name = "Jumpscares_Disabled"
    end

    CustomPhysics = PhysicalProperties.new(100, RootPart.CustomPhysicalProperties.Friction, RootPart.CustomPhysicalProperties.Elasticity, RootPart.CustomPhysicalProperties.FrictionWeight, RootPart.CustomPhysicalProperties.ElasticityWeight)
    for Index, Part in pairs(NewCharacter:GetDescendants()) do
        if Part:IsA("BasePart") then
            PartProperties[Part] = Part.CustomPhysicalProperties
            if Toggles.RemoveAcceleration.Value then
                Part.CustomPhysicalProperties = CustomPhysics
            end
        end
    end

    Connections.LibraryCodeHandler1 = LocalPlayer.PlayerGui.PermUI.Hints.ChildAdded:Connect(function(Child)
        if Toggles.NotifyLibraryCode.Value then
            local Code = Functions.GetLibraryCode()
            if Code and not string.find(Code, "_") and Globals.LibraryCodeFound ~= true then
                local Lock = workspace:FindFirstChild("Padlock", true)
                Functions.Notify({Title = "Padlock code found!", Body = "The code is: '" .. Code .. "'", Time = 15})
                Globals.LibraryCodeFound = true
            end
        end
    end)

    Connections.LibraryCodeHandler2 = Character.ChildAdded:Connect(function(Child)
        if Child.Name == "LibraryHintPaper" and Toggles.NotifyLibraryCode.Value or Child.Name == "LibraryHintPaperHard" and Toggles.NotifyLibraryCode.Value then
            local Code = Functions.GetLibraryCode()
            if Code and not string.find(Code, "_") and Globals.LibraryCodeFound ~= true then
                local Lock = workspace:FindFirstChild("Padlock", true)
                Functions.Notify({Title = "Padlock code found!", Body = "The code is: '" .. Code .. "'", Time = 15})
                Globals.LibraryCodeFound = true
            end
        end
    end)

    Connections.OxygenConnection = Character:GetAttributeChangedSignal("Oxygen"):Connect(function()
        Globals.OxygenUI_Text.Text = Functions.FormatOxygen(Character:GetAttribute("Oxygen"))
        Globals.OxygenUI.Enabled = (Toggles.NotifyOxygen.Value and Character:GetAttribute("Oxygen") < 100 and true or false)
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
            Functions.Notify({Title = "Successfully disabled the anticheat.", Body = "It will be re-enabled after a cutscene or halt room."})
            Globals.AnticheatDisabled = true
        end
    end)

    Connections.AnticheatEnableDetector1 = RemotesFolder:WaitForChild("Cutscene").OnClientEvent:Connect(function(CutsceneName)
	    if Globals.AnticheatDisabled == true and not string.find(CutsceneName, "SewerSeek") then
            Globals.AnticheatDisabled = false
            Functions.Notify({Title = "The anticheat has been re-enabled.", Body = "Interact with a ladder to disable it again."})
	    end
    end)

    Connections.AnticheatEnableDetector2 = RemotesFolder:WaitForChild("UseEnemyModule").OnClientEvent:Connect(function(ModuleName)
	    if ModuleName == "Void" or ModuleName == "Glitch" then
		    if Globals.AnticheatDisabled == true then
			    Globals.AnticheatDisabled = false
                unctions.Notify({Title = "The anticheat has been re-enabled.", Body = "Interact with a ladder to disable it again."})
		    end
            LocalPlayer:SetAttribute("CurrentRoom", LatestRoom.Value)
	    end
    end)

    Connections.AnimationHandler = Character.ChildAdded:Connect(function()
        local Tool = Character:FindFirstChild("Lockpick") or Character:FindFirstChild("Shears") or Character:FindFirstChild("SkeletonKey") or Character:FindFirstChild("Key") or Character:FindFirstChild("KeyElectrical") or Character:FindFirstChild("KeyBackdoor") or Character:FindFirstChild("KeyIron")
        if Tool then
            local UseAnimation = Tool:FindFirstChild("use", true) or Tool:FindFirstChild("promptanim", true)
            if UseAnimation then
                UseAnimation = Humanoid:LoadAnimation(UseAnimation)
                UseAnimation.Priority = Enum.AnimationPriority.Action4

                Globals.UseAnimation = UseAnimation
            end
            local UseAnimationBreak = Tool:FindFirstChild("usefinish", true) or Tool:FindFirstChild("promptanimend", true) or Tool:FindFirstChild("lockpickuse", true)
            if UseAnimationBreak then
                UseAnimationBreak = Humanoid:LoadAnimation(UseAnimationBreak)
                UseAnimationBreak.Priority = Enum.AnimationPriority.Action4

                Globals.UseAnimationBreak = UseAnimationBreak
            end
        end
    end)

    Connections.JumpHandler = Character:GetAttributeChangedSignal("CanJump"):Connect(function()
        if Toggles.EnableCharacterJump.Value and Character:GetAttribute("CanJump") ~= true or not Toggles.EnableCharacterJump.Value then
            OldJump = Character:GetAttribute("CanJump")
        end
        if Toggles.EnableCharacterJump.Value then
            Character:SetAttribute("CanJump", true)
        end
    end)

    Connections.SlideHandler = Character:GetAttributeChangedSignal("CanSlide"):Connect(function()
        if Toggles.EnableCharacterSlide.Value and Character:GetAttribute("CanSlide") ~= true or not Toggles.EnableCharacterSlide.Value then
            OldSlide = Character:GetAttribute("CanSlide")
        end
        if Toggles.EnableCharacterSlide.Value then
            Character:SetAttribute("CanSlide", true)
        end
    end)

    if Main_Game then
        Connections.CrouchConnection1 = Services.UserInputService.InputBegan:Connect(function(Input)
            if Input.KeyCode == Enum.KeyCode.C or Input.KeyCode == Enum.KeyCode.LeftShift or Input.KeyCode == Enum.KeyCode.LeftControl then
                if Functions.IsCrouching() then
                    task.wait()
                    if Functions.IsCrouching() then
                        Main_Game.crouch(false)
                    end
                end
            end
        end)
        Connections.CrouchConnection2 = Globals.MainUI.MainFrame.MobileButtons.CrouchButton.MouseButton1Down:Connect(function()
            if Functions.IsCrouching() then
                task.wait()
                if Functions.IsCrouching() then
                    Main_Game.crouch(false)
                end
            end
        end)
    end

    Connections.InfiniteJumpConnection1 = Services.UserInputService.InputBegan:Connect(function(Input)
        if Input.KeyCode == Enum.KeyCode.Space and Toggles.InfiniteJumps.Value then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    if Globals.MainUI.MainFrame.MobileButtons:FindFirstChild("JumpButton") then
        Connections.InfiniteJumpConnection2 = Globals.MainUI.MainFrame.MobileButtons.JumpButton.MouseButton1Down:Connect(function()
            if Toggles.InfiniteJumps.Value then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end

    Globals.LastAutoHide = tick()
    Connections.AutoHideConnection = Services.RunService.Heartbeat:Connect(function()
        if Toggles.AutoClosetToggle.Value and tick() - Globals.LastAutoHide > 0.05 then
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
        else
            Globals.AutoClosetActive = false
        end
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
        if Toggles.AutoSolveAnchors.Value and Globals.MainUI:FindFirstChild("AnchorHintFrame") and tick() - Globals.LastAutoAnchor > 0.1 then
            local Anchor = Functions.GetCurrentAnchor()
            if Anchor and LocalPlayer:DistanceFromCharacter(Anchor.PrimaryPart.Position) < Anchor.ActivateEventPrompt.MaxActivationDistance and not Anchor:GetAttribute("Activated") then
                Anchor:WaitForChild("AnchorRemote"):InvokeServer(Globals.MainUI.AnchorHintFrame.Code.Text)
                Functions.Notify({Title = "Successfully solved Anchor '" .. Anchor.Sign.TextLabel.Text .. "'", Body = "The code was '" .. Globals.MainUI.AnchorHintFrame.Code.Text .. "'"})
            end
            Globals.LastAutoAnchor = tick()
        end
    end)

    Globals.ManipulateBody = Instance.new("BodyVelocity")
    Globals.ManipulateBody.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    Globals.FlyBody = Instance.new("BodyVelocity")
    Globals.FlyBody.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    Globals.SelfKilled = false
    Globals.ThirdPersonParts = {}
    for Index, Object in pairs(Character:GetDescendants()) do
        if Object:IsA("Accessory") and Object:FindFirstChild("Handle") then
            table.insert(Globals.ThirdPersonParts, Object.Handle)
        end
    end
    table.insert(Globals.ThirdPersonParts, Character:WaitForChild("Head"))

    local Previous = tick()
    local NextDelay = math.random(2100, 2400) / 10000
    Connections.MainHandler = Services.RunService.RenderStepped:Connect(function()
        if Toggles.SpeedBoostToggle.Value then
            Humanoid.WalkSpeed = Functions.GetCurrentSpeed() + Options.SpeedBoostSlider.Value
        end
        if Toggles.JumpBoostToggle.Value then
            Humanoid.JumpHeight = 5 + Options.JumpBoostSlider.Value
        else
            Humanoid.JumpHeight = 5
        end

        if Globals.Lagging or Options.SpeedBoostSlider.Value <= 6 then
            CollisionPartClone.Massless = true
        end

        if tick() - Previous > NextDelay and Toggles.SpeedBoostToggle.Value and Options.SpeedBoostSlider.Value > 6 and Floor ~= "Fools" and Floor ~= "OldHotel" then
            if CollisionPart.Anchored or Globals.Lagging or Toggles.VelocityManipulationToggle.Value then
                CollisionPartClone.Massless = true
            else
                CollisionPartClone.Massless = not CollisionPartClone.Massless
            end
            Previous = tick()
            NextDelay = math.random(2100, 2400) / 10000
        end

        if Services.Workspace:FindFirstChild("Eyes") or Services.Workspace:FindFirstChild("Lookman") then
            Globals.IsEyes = true
        else
            Globals.IsEyes = false
        end

        if Services.Workspace:FindFirstChild("BackdoorLookman") then
            Globals.IsLookman = true
        else
            Globals.IsLookman = false
        end

        if Toggles.AmbientToggle.Value then
            Services.TweenService:Create(Services.Lighting, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {Ambient = Options.AmbientColor.Value}):Play()
        end

        if Toggles.RemoveCameraShake.Value then
            Main_Game.csgo = CFrame.new()
        end

        if Globals.SelfKilled then
            Globals.MainUI.Statistics.Death.Text = "Died to Abysall Hub"
        end
        if Globals.MainUI.MainFrame.Healthbar:FindFirstChild("Effects") and Globals.MainUI.MainFrame.Healthbar.Effects:FindFirstChild("Crouching") then
            Globals.MainUI.MainFrame.Healthbar.Effects.Crouching.Visible = Functions.IsCrouching()
        end
        if Toggles.CrouchSpoof.Value and not MainHook and RemotesFolder:FindFirstChild("Crouch") or Toggles.PositionSpoof.Value and not MainHook and RemotesFolder:FindFirstChild("Crouch") then
            RemotesFolder.Crouch:FireServer(true)
        end

        if Floor ~= "Fools" and Floor ~= "OldHotel" then
            RootPart.CanCollide = false
            if Character.LowerTorso:FindFirstChild("Root") then
                Character.LowerTorso.Root.C0 = Character.LowerTorso.Root.C0 * CFrame.new(0, Toggles.PositionSpoof.Value and 2.146 or 0, 0)
            end
        end

        for Index, Part in pairs(Character:GetChildren()) do
            if Part:IsA("BasePart") then
                Part.CanCollide = false
            end
        end
        if LocalPlayer:GetAttribute("Alive") == true then
            Services.SoundService:WaitForChild("Main").Volume = 1
        end
        
        if Floor == "OldHotel" or Floor == "Fools" then
            Collision.Position = RootPart.Position + Vector3.new(0, Toggles.PositionSpoof.Value and Functions.GetNearestEntity() and (Floor == "OldHotel" and 200 or -5) or 0, 0)
            Collision.CanCollide = false
            if Floor == "Fools" then
                Collision.CollisionCrouch.CanCollide = false
                CollisionClone.CollisionCrouch.CanCollide = false
            end
            RootPart.CanCollide = not (Toggles.NoclipToggle.Value and true or Toggles.VelocityManipulationToggle.Value or false)
        else
            Collision.CanCollide = false
            Collision.CollisionCrouch.CanCollide = false
            if CollisionClone:FindFirstChild("CollisionCrouch") then
                CollisionClone.CanCollide = not (Toggles.NoclipToggle.Value and true or Toggles.VelocityManipulationToggle.Value or Functions.IsCrouching() and true or false)
                CollisionClone.CollisionCrouch.CanCollide = not (Toggles.NoclipToggle.Value and true or Toggles.VelocityManipulationToggle.Value or Functions.IsCrouching() == false and true or false)
            else
                RootPart.CanCollide = not (Toggles.NoclipToggle.Value and true or Toggles.VelocityManipulationToggle.Value or false)
            end

            Collision.Position = RootPart.Position + Vector3.new(0, 0.18, 0)
            CollisionPart.Position = RootPart.Position + Vector3.new(0, 0.18, 0)
            if Collision:FindFirstChild("CollisionCrouch") then
                Collision.CollisionCrouch.Position = RootPart.Position + Vector3.new(0, Toggles.PositionSpoof.Value and 1.128 or -0.982, 0)
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
            Globals.ManipulateBody.Velocity = RootPart.CFrame.LookVector * 2
        else
            Globals.ManipulateBody.Parent = nil
        end

        if Toggles.FlyToggle.Value then
            Globals.FlyBody.Parent = RootPart
            Globals.FlyBody.Velocity = Functions.GetFlyVelocity() * Options.FlySpeed.Value
        else
            Globals.FlyBody.Parent = nil
        end

        if Toggles.BypassEyes.Value and Globals.IsEyes and not MainHook or Toggles.BypassLookman.Value and Globals.IsLookman and not MainHook then
            if Floor == "Fools" and Floor == "OldHotel" then
                RemotesFolder.MotorReplication:FireServer(0, -65, 0, false)
            else
                RemotesFolder.MotorReplication:FireServer(-650)
            end
        end

        if Toggles.ThirdPersonToggle.Value then
            Camera.CFrame = Camera.CFrame * CFrame.new(Options.ThirdPersonOffsetX.Value, Options.ThirdPersonOffsetY.Value, Options.ThirdPersonOffsetZ.Value)
        end

        for Index, Part in pairs(Globals.ThirdPersonParts) do
            Part.Transparency = (Toggles.ThirdPersonToggle.Value and 0 or 1)
            Part.LocalTransparencyModifier = (Toggles.ThirdPersonToggle.Value and 0 or 1)
        end

        if Main_Game then
            task.wait()
            Main_Game.fovtarget = Options.FieldOfView.Value
        else
            Camera.FieldOfView = Options.FieldOfView.Value
        end

        task.wait()
        if Toggles.RemoveClosetDelay.Value and Humanoid.MoveDirection ~= Vector3.zero and (CollisionPart.Anchored or RootPart.Anchored) and Character:GetAttribute("AnimatingClient") ~= true and Character:GetAttribute("Hiding") == true then
            RemotesFolder.CamLock:FireServer()
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
    for Index, Part in pairs(Model:GetDescendants()) do
        if Part:IsA("BasePart") then
            Part:SetAttribute("Transparency_Old", Part.Transparency)
            table.insert(Parts, Part)
        end
        if Part.Name == "HiddenPlayer" then
            local Connection = Part:GetPropertyChangedSignal("Value"):Connect(function()
                for Index2, Part2 in pairs(Parts) do
                    Services.TweenService:Create(Part2, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {Transparency = (Part.Value == Character and Toggles.TransparentHidingSpotsToggle.Value and Options.TransparentHidingSpotsSlider.Value or Part2:GetAttribute("Transparency_Old"))}):Play()
                end
            end)
            table.insert(Connections, Connection)

            Model.Destroying:Once(function()
                Connection:Disconnect()

                local Position = table.find(Connections, Connection)
                table.remove(Connections, Position)
            end)
        end
    end
end

Globals.AllowedInstances = {
	"Lava",
	"GoldPile",
	"KeyObtain",
	"KeyObtainFake",
	"Drakobloxxer",
	"FuseObtain",
	"MinesGenerator",
	"JeffTheKiller",
	"Snare",
	"FakeDoor",
	"DoorFake",
	"SideroomSpace",
	"ChestBox",
	"ChestBoxLocked",
	"Chest_Vine",
	"Locker_Small_Locked",
	"Toolbox",
	"Toolbox_Locked",
	"Wardrobe",
	"Toolshed",
	"Toolshed_Small",
	"Bed",
	"MinesAnchor",
	"Double_Bed",
	"RetroWardrobe",
	"Backdoor_Wardrobe",
	"Rooms_Locker",
	"Rooms_Locker_Fridge",
	"Locker_Large",
	"FigureRig",
	"FigureRagdoll",
	"TimerLever",
	"Seek_Arm",
	"ChandelierObstruction",
	"ScaryWall",
	"Ladder",
	"CircularVent",
	"Dumpster",
	"SquareGrate",
	"TriggerEventCollision",
	"GrumbleRig",
	"GiggleCeiling",
	"MinesGateButton",
	"ElectricalKeyObtain",
	"LibraryHintPaper",
	"WaterPump",
	"PickupItem",
	"LiveHintBook",
	"LiveBreakerPolePickup",
	"LeverForGate",
	"GloomPile",
	"SeekFloodline",
	"Door",
	"Green_Herb",
	"GiggleCeiling",
	"Bridge",
	"MouseHole",
	"BananaPeel",
	"JeffTheKiller",
	"NannerPeel",
	"PowerupPad",
	"IndustrialGate",
	"CollisionFloor",
    "ElevatorCar",
	"Wax_Door",
	"ThingToOpen",
	"MovingDoor",
	"StardustPickup",
	"Hole",
	"Groundskeeper",
	"MandrakeLive",
	"GardenGateButton",
	"LotusPetalPickup",
	"VineGuillotine",
	"LiveEntityBramble",
	"RiftSpawn",
	"ElevatorBreaker",
    "RunnerNodes",
    "PathLights",
    "DuckBoard",
    "Padlock"
}

Functions.HandleObject = function(Object)
    if not table.find(Globals.AllowedInstances, Object.Name) and not Object:IsA("ProximityPrompt") and Object.Parent ~= CurrentRooms and not ItemNames[Object.Name] then
        return
    end

    if not Object:IsA("ProximityPrompt")then
        task.wait(math.random(25, 35) / 100)
    end

    for Index, Room in pairs(CurrentRooms:GetChildren()) do
        if Object:IsDescendantOf(Room) then
            Object:SetAttribute("ParentRoom", tonumber(Room.Name))
            break
        end
    end

    if Object.Parent == CurrentRooms then
        if Object:GetAttribute("Firedamp") then
            Object:SetAttribute("Firedamp_Old", Object:GetAttribute("Firedamp"))
        else
            Object:SetAttribute("Firedamp_Old", false)
        end

        if Toggles.DisableFiredampEffect.Value then
            Object:SetAttribute("Firedamp", false)
        end
    end

    if Object.Name == "KeyObtain" then
        task.wait(0.5)
        if Object.Parent ~= nil then
            if Toggles.ObjectiveESPToggle.Value then
                Functions.AddESP({
                    Object = Object,
                    Text = "Door Key",
                    Color = Options.ObjectiveESPColor.Value,
                }, true)
            end
            table.insert(Objects.Objectives, Object)
        end
    elseif Object.Name == "ElectricalKeyObtain" then
        task.wait(0.5)
        if Object.Parent ~= nil then
            if Toggles.ObjectiveESPToggle.Value then
                Functions.AddESP({
                    Object = Object,
                    Text = "Electrical Key",
                    Color = Options.ObjectiveESPColor.Value,
                }, true)
            end
            table.insert(Objects.Objectives, Object)
        end
    elseif Object.Name == "KeyObtainFake" then
        task.wait(0.5)
        if Object.Parent ~= nil then
            if Toggles.EntityESPToggle.Value then
                Functions.AddESP({
                    Object = Object,
                    Text = "Fake Key",
                    Color = Options.EntityESPColor.Value,
                }, true)
            end
            table.insert(Objects.Entities, Object)
        end
    elseif Object.Name == "TimerLever" then
        task.wait(0.5)
        if Object.Parent ~= nil then
            Object:SetAttribute("AddTime", (Object.TakeTimer.TextLabel.Text == "01:00" and 60 or 30))
            if Toggles.ObjectiveESPToggle.Value then
                Functions.AddESP({
                    Object = Object,
                    Text = "Time Lever [+" .. Object:GetAttribute("AddTime") .. "s]",
                    Color = Options.ObjectiveESPColor.Value,
                }, true)
            end

            Object:WaitForChild("Main").SoundToPlay.Played:Once(function()
                Functions.RemoveESP(Object)
                Functions.BlacklistESP(Object)
            end)
            table.insert(Objects.Objectives, Object)
        end
    elseif Object.Name == "LiveHintBook" then
        if Toggles.ObjectiveESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Hint Book",
                Color = Options.ObjectiveESPColor.Value,
            }, true)
        end
        table.insert(Objects.Objectives, Object)
    elseif Object.Name == "LiveBreakerPolePickup" then
        if Toggles.ObjectiveESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Fuse Breaker",
                Color = Options.ObjectiveESPColor.Value,
            }, true)
        end

        for Index2, Object2 in pairs(Object:GetChildren()) do
            if Object2.Name == "ActivateEventPrompt" and Object2.MaxActivationDistance == 5 or Object2.Name == "ActivateEventPrompt" and Object2:GetAttribute("MaxActivationDistance_Old") and Object2:GetAttribute("MaxActivationDistance_Old") == 5 then
                Object2:Destroy()
            end 
        end

        table.insert(Objects.Objectives, Object)
    elseif Object.Name == "LibraryHintPaper" or Object.Name == "PickupItem" then
        if Toggles.ObjectiveESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Hint Paper",
                Color = Options.ObjectiveESPColor.Value,
            }, true)
        end
        table.insert(Objects.Objectives, Object)
    elseif Object.Name == "MinesAnchor" then
        if Toggles.ObjectiveESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Anchor [" .. Object:WaitForChild("Sign").TextLabel.Text .. "]",
                Color = Options.ObjectiveESPColor.Value
            }, true)
        end

        Object:GetAttributeChangedSignal("Activated"):Once(function()
            Functions.RemoveESP(Object)
            Functions.BlacklistESP(Object)
        end)
        table.insert(Objects.Objectives, Object)
    elseif Object.Name == "WaterPump" then
        if Toggles.ObjectiveESPToggle.Value then
            Functions.AddESP({
                Object = Object.Wheel,
                Text = "Water Pump",
                Color = Options.ObjectiveESPColor.Value
            }, true)
        end
        
        Object:WaitForChild("Wheel").Sound.Played:Once(function()
            Functions.RemoveESP(Object.Wheel)
            Functions.BlacklistESP(Object.Wheel)
        end)
    elseif Object.Name == "LeverForGate" then
        if Toggles.ObjectiveESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Gate Lever",
                Color = Options.ObjectiveESPColor.Value,
            }, true)
        end

        Object:WaitForChild("Main").SoundToPlay.Played:Once(function()
            Functions.RemoveESP(Object)
            Functions.BlacklistESP(Object)
        end)
        table.insert(Objects.Objectives, Object)
    elseif Object.Name == "VineGuillotine" then
        if Toggles.ObjectiveESPToggle.Value then
            Functions.AddESP({
                Object = Object.Lever,
                Text = "Vine Lever",
                Color = Options.ObjectiveESPColor.Value,
            }, true)
        end

        Object.Lever:WaitForChild("ActivateEventPrompt"):GetAttributeChangedSignal("Interactions"):Once(function()
            Functions.RemoveESP(Object)
            Functions.BlacklistESP(Object)
        end)
        table.insert(Objects.Objectives, Object)
    elseif Object.Name == "MandrakeLive" then
        if Toggles.ObjectiveESPToggle.Value then
            Functions.AddESP({
                Object = Object.Hole,
                Text = "Mandrake Hole",
                Color = Options.EntityESPColor.Value,
            }, true)
        end
        table.insert(Objects.Entities, Object.Hole)
    elseif Object.Name == "MinesGenerator" then
        task.wait(0.75)
        if Object.Parent ~= nil then
            if Toggles.ObjectiveESPToggle.Value then
                Functions.AddESP({
                    Object = Object,
                    Text = "Generator",
                    Color = Options.ObjectiveESPColor.Value
                }, true)
            end

            Object:WaitForChild("Lever").Sound.Played:Once(function()
                Functions.RemoveESP(Object)
                Functions.BlacklistESP(Object)
            end)
            table.insert(Objects.Objectives, Object)
        end
    elseif Object.Name == "FuseObtain" then
        if Toggles.ObjectiveESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Generator Fuse",
                Color = Options.ObjectiveESPColor.Value
            }, true)
        end

        Object:WaitForChild("Hitbox").FuseModel:GetPropertyChangedSignal("LocalTransparencyModifier"):Once(function()
            Functions.RemoveESP(Object)
            Functions.BlacklistESP(Object)
        end)
        table.insert(Objects.Objectives, Object)
    elseif Object.Name == "MinesGateButton" then
        if Toggles.ObjectiveESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Gate Button",
                Color = Options.ObjectiveESPColor.Value
            }, true)
        end

        Object.Parent:WaitForChild("MinesGate").Main.SoundOpen.Played:Once(function()
            Functions.RemoveESP(Object)
            Functions.BlacklistESP(Object)
        end)
        table.insert(Objects.Objectives, Object)
    elseif Object.Name == "GardenGateButton" then
        if Toggles.ObjectiveESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Gate Button",
                Color = Options.ObjectiveESPColor.Value
            }, true)
        end

        Object.Parent:WaitForChild("GardenGate").Collision.Sound.Played:Once(function()
            Functions.RemoveESP(Object)
            Functions.BlacklistESP(Object)
        end)
        table.insert(Objects.Objectives, Object)
    elseif Object.Name == "Ladder" then
        if Toggles.LadderESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Ladder",
                Color = Options.LadderESPColor.Value
            }, true)
        end
        table.insert(Objects.Ladders, Object)
    elseif Object.Name == "Door" and Object.Parent ~= nil and tonumber(Object.Parent.Name) then
        local Children = 0
        local Doors = {}
        for Index2, Object2 in pairs(Object:GetChildren()) do
            if Object2.Name == "Door" and Object2:IsA("BasePart") then
                Children = Children + 1
                table.insert(Doors, Object2)
            end
        end
        if Children == 2 then
            local HighlightModel = Instance.new("Model", Object)
            HighlightModel.Name = "HighlightModel"

            local HighlightHumanoid = Instance.new("Humanoid", HighlightModel)
            HighlightHumanoid.Name = "HighlightHumanoid"

            HighlightModel:SetAttribute("ParentRoom", tonumber(Object.Parent.Name))

            for Index2, Object2 in pairs(Doors) do
                local HighlightPart = Instance.new("Part", Object2)
                HighlightPart.Transparency = 0.99
                HighlightPart.Size = Object2.Size
                HighlightPart.CanCollide = false
                HighlightPart.CFrame = Object2.CFrame
                HighlightPart.Name = "HighlightPart"
                HighlightPart:SetAttribute("ParentRoom", tonumber(Object.Parent.Name))

                local Weld = Instance.new("WeldConstraint", HighlightPart)
                Weld.Part0 = HighlightPart
                Weld.Part1 = Object2
                Weld.Enabled = true

                HighlightPart.Parent = HighlightModel
            end
            table.insert(Objects.Doors, HighlightModel)
            if Toggles.DoorESPToggle.Value then
                Functions.AddESP({
                    Object = HighlightModel,
                    Text = "Door",
                    Color = Options.DoorESPColor.Value,
                }, true)
            end
        else
            local Root = Object:WaitForChild("Door", 9e9)
            local HighlightPart = Instance.new("Part", Object)
            HighlightPart.Transparency = 0.99
            HighlightPart.Size = Root.Size
            HighlightPart.CanCollide = false
            HighlightPart.CFrame = Root.CFrame
            HighlightPart.Name = "HighlightPart"
            HighlightPart:SetAttribute("ParentRoom", tonumber(Object.Parent.Name))

            local Weld = Instance.new("WeldConstraint", HighlightPart)
            Weld.Part0 = HighlightPart
            Weld.Part1 = Root
            Weld.Enabled = true

            local HighlightHumanoid = Instance.new("Humanoid", Object)
            HighlightHumanoid.Name = "HighlightHumanoid"

            table.insert(Objects.Doors, HighlightPart)
            if Toggles.DoorESPToggle.Value then
                Functions.AddESP({
                    Object = HighlightPart,
                    Text = "Door",
                    Color = Options.DoorESPColor.Value,
                }, true)
            end
        end

        local LastFire = tick()
        local Connection = Services.RunService.Heartbeat:Connect(function()
            if Object:FindFirstChild("Door") and Object:FindFirstChild("ClientOpen") then
                local Distance = LocalPlayer:DistanceFromCharacter(Object.Door.Position)
                if Distance < 150 and tick() - LastFire > 0.1 and Toggles.DoorReachToggle.Value then
                    Object.ClientOpen:FireServer()
                    LastFire = tick()
                end
            end
        end)

        Object:WaitForChild("Door").Open.Played:Once(function()
            Connection:Disconnect()
        end)

        table.insert(Connections, Connection)
    elseif Object.Name == "PathLights" then
       local function CreateHighlight(Object2)
            if Object2.Name == "SeekGuidingLight" then
                local NewNode = Instance.new("Part")
                NewNode.Size = Vector3.new(1,1,1)
                NewNode.Transparency = 1
                NewNode.Parent = Globals.SeekNodesFolder
                NewNode.Anchored = true
                NewNode.CFrame = Object2.CFrame
                NewNode.CanCollide = false
                NewNode.Name = "SeekLightNode"

                if PreviousNode == nil then
                    PreviousNode = NewNode
                end

                local NewBeam = Instance.new("Beam")
                NewBeam.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Options.ShowSeekPathColor.Value),
                    ColorSequenceKeypoint.new(1, Options.ShowSeekPathColor.Value)
                })

                NewBeam.FaceCamera = true
                NewBeam.Width0 = 0.2
                NewBeam.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, (Toggles.ShowSeekPathToggle.Value and 0 or 1)),
                    NumberSequenceKeypoint.new(1, (Toggles.ShowSeekPathToggle.Value and 0 or 1)),
                })

                NewBeam.Width1 = 0.2
                NewBeam.Brightness = 10
                NewBeam.LightInfluence = 0
                NewBeam.LightEmission = 0
                NewBeam.Enabled = true
                NewBeam.Parent = Globals.SeekNodesFolder

                local Attachment0 = Instance.new("Attachment")
                Attachment0.Parent = NewNode

                local Attachment1 = Instance.new("Attachment")
                Attachment1.Parent = PreviousNode

                NewBeam.Attachment0 = Attachment0
                NewBeam.Attachment1 = Attachment1

                PreviousNode = NewNode
                table.insert(Objects.SeekHighlights, NewBeam)
            end
        end
        for Index2, Object2 in pairs(Object:GetChildren()) do
            CreateHighlight(Object2)
        end

        local Connection = Object.ChildAdded:Connect(function(Object2)
            CreateHighlight(Object2)
        end)

        table.insert(Connections, Connection)
        Object.Destroying:Once(function()
            Connection:Disconnect()
        end)
    elseif Object.Name == "Bridge" then
        for Index2, Object2 in pairs(Object:GetChildren()) do
            if Object2.Name == "PlayerBarrier" and Object2.Size.Y == 2.75 and Object2.Rotation.X == 0 or Object2.Name == "PlayerBarrier" and Object2.Size.Y == 2.75 and Object2.Rotation.X == 180 then
				local NewBridge = Object2:Clone()
				NewBridge.CFrame = NewBridge.CFrame * CFrame.new(0, 0, -5)
				NewBridge.Name = ESPLibrary:GenerateRandomString()
				NewBridge.Size = Vector3.new(NewBridge.Size.X, NewBridge.Size.Y, 11)
				NewBridge.Parent = Object
				NewBridge.CanCollide = Toggles.BypassSeekObstructions.Value
                NewBridge.Color = Color3.fromRGB(0, 255, 255)
                NewBridge.Transparency = (Toggles.BypassSeekObstructions.Value and 0 or 1)
                NewBridge.Material = Enum.Material.ForceField
				table.insert(Objects.SeekBridges, NewBridge)
			end
        end
    elseif Object.Name == "RunnerNodes" then
        local function IsBehind(Part1, Part2)
			local Point1, Point2 = (Part1.CFrame + Part1.CFrame.LookVector),(Part1.CFrame + Part1.CFrame.LookVector*-1)
			local Magnitude1, Magnitude2 = (Point1.Position-Part2.Position).Magnitude,(Point2.Position-Part2.Position).Magnitude
			return not (Magnitude1 <= Magnitude2)
		end
        
        local function GetDirection(Part1, Part2)
			local Direction = Part1.Position - Part2.Position
			local RightDistance = Part1.CFrame.RightVector:Dot(Direction)

			if RightDistance > 0.5 then					
				return (IsBehind(Part1, Part2) and "Right" or "Left")
			elseif RightDistance < -0.5 then					
			    return (IsBehind(Part1, Part2) and "Left" or "Right")
			end
			return "Straight"
		end

		for Index, NewNode in pairs(Object:GetChildren()) do
			local NodeID = tonumber(NewNode.Name:split("MinecartNode")[2])
            if NewNode:GetAttribute("DeathType") then
                NewNode:SetAttribute("DistanceBlacklist", true)
            end
			for Index2 = 1, 20, 1 do
                if NodeID and Object:FindFirstChild("MinecartNode" .. NodeID + Index2) and Object:FindFirstChild("MinecartNode" .. NodeID + Index2):GetAttribute("DeathType") ~= nil then
                    NewNode:SetAttribute("DistanceBlacklist", true)
                end
            end
            if NodeID and Object:FindFirstChild("MinecartNode" .. NodeID - 1) and Object:FindFirstChild("MinecartNode" .. NodeID - 1):GetAttribute("ForceConnect") then
                NewNode:SetAttribute("DistanceBlacklist", nil)
            end
		end

        local function GetClosestNode(Node)
			local ClosestNodeDistance = math.huge
			local ClosestNode = nil
			for i,NewNode in pairs(Object:GetChildren()) do
				local NodeID = NewNode.Name:split("MinecartNode")[2]
				local NodeID2 = Node.Name:split("MinecartNode")[2]
				if NewNode ~= Node and tonumber(NodeID) > tonumber(NodeID2) then					
				    local Distance = (Node.Position - NewNode.Position).Magnitude
					if Distance < ClosestNodeDistance and NewNode:GetAttribute("DistanceBlacklist") ~= true then
						ClosestNodeDistance = Distance
						ClosestNode = NewNode		
					end
				end
			end
			return ClosestNode
		end

        for Index, Node in pairs(Object:GetChildren()) do
            if Node:GetAttribute("ForceConnect") then
                local NextNode = GetClosestNode(Node)
                if NextNode then
                    Node:SetAttribute("Turn", GetDirection(Node, NextNode))
                    table.insert(Objects.SeekNodes, Node)
                end
            end
        end
    elseif Object.Name == "DuckBoard" then
        table.insert(Objects.SeekDuckBoards, Object)
    elseif Object.Name == "Wardrobe" or Object.Name == "Backdoor_Wardrobe" or Object.Name == "Toolshed" or Object.Name == "RetroWardrobe" then
        if Toggles.HidingSpotESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Closet",
                Color = Options.HidingSpotESPColor.Value
            }, true)
        end
        Functions.HandleHidingTransparency(Object)
        table.insert(Objects.HidingSpots, Object)
    elseif Object.Name == "Lava" then
        if Toggles.BypassKillbricks.Value then
            Object.CanTouch = false
        end
        table.insert(Objects.Obstructions, Object)
    elseif Object.Name == "ScaryWall" then
        for Index2, Object2 in pairs(Object:GetDescendants()) do
            if Object2:IsA("BasePart") then
                Object2.CanTouch = false
                Object2.CanCollide = false
            end
        end
        table.insert(Objects.Obstructions, Object)
    elseif Object.Name == "Locker_Large" or Object.Name == "Rooms_Locker" or Object.Name == "Rooms_Locker_Fridge" then
        if Toggles.HidingSpotESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Locker",
                Color = Options.HidingSpotESPColor.Value
            }, true)
        end
        Functions.HandleHidingTransparency(Object)
        table.insert(Objects.HidingSpots, Object)
    elseif Object.Name == "Bed" then
        if Toggles.HidingSpotESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Bed",
                Color = Options.HidingSpotESPColor.Value
            }, true)
        end
        Functions.HandleHidingTransparency(Object)
        table.insert(Objects.HidingSpots, Object)
    end

    if Object.Name == "Double_Bed" then
        if Toggles.HidingSpotESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Double Bed",
                Color = Options.HidingSpotESPColor.Value
            }, true)
        end
        Functions.HandleHidingTransparency(Object)
        table.insert(Objects.HidingSpots, Object)
    elseif Object.Name == "CircularVent" then
        if Toggles.HidingSpotESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Vent",
                Color = Options.HidingSpotESPColor.Value
            }, true)
        end
        Functions.HandleHidingTransparency(Object)
        table.insert(Objects.HidingSpots, Object)
    elseif Object.Name == "Dumpster" then
        if Toggles.HidingSpotESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Dumpster",
                Color = Options.HidingSpotESPColor.Value
            }, true)
        end
        Functions.HandleHidingTransparency(Object)
        table.insert(Objects.HidingSpots, Object)
    elseif Object.Name == "ChestBox" or Object.Name == "ChestBoxLocked" then
        if Toggles.ChestESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = (Object:GetAttribute("Locked") and "Locked Chest" or "Chest"),
                Color = Options.ChestESPColor.Value
            }, true)
        end
        table.insert(Objects.Chests, Object)
    elseif Object.Name == "Toolbox" or Object.Name == "Toolbox_Locked" then
        if Toggles.ChestESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = (Object:GetAttribute("Locked") and "Locked Toolbox" or "Toolbox"),
                Color = Options.ChestESPColor.Value
            }, true)
        end
        table.insert(Objects.Chests, Object)
    elseif Object.Name == "Chest_Vine" then
        if Toggles.ChestESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Vine Chest",
                Color = Options.ChestESPColor.Value
            }, true)
        end
        table.insert(Objects.Chests, Object)
    elseif Object.Name == "Toolshed_Small" then
        if Toggles.ChestESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Toolshed",
                Color = Options.ChestESPColor.Value
            }, true)
        end
        table.insert(Objects.Chests, Object)
    elseif Object.Name == "Locker_Small_Locked" then
        if Toggles.ChestESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Locked Item Locker",
                Color = Options.ChestESPColor.Value
            }, true)
        end
        table.insert(Objects.Chests, Object)
    elseif Object.Name == "MouseHole" then
        if Toggles.ChestESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Mouse",
                Color = Options.ChestESPColor.Value
            }, true)
        end
        table.insert(Objects.Chests, Object)
    elseif ItemNames[Object.Name] and Object:FindFirstChild("ModulePrompt") then
        if Toggles.ItemESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = ItemNames[Object.Name],
                Color = Options.ItemESPColor.Value
            }, (Object:GetAttribute("ParentRoom") and true or false))
        end
        if Object.Name == "LotusHolder" or Object.Name == "LotusPetalPickup" then
            Object.Handle:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
                Abysall.ESPLibrary:RemoveESP(Object)
                Abysall.ESPLibrary:BlacklistESP(Object)
            end)
        end
        table.insert(Objects.Items, Object)
    elseif Object.Name == "Green_Herb" then
        if Toggles.ItemESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Green Herb",
                Color = Options.ItemESPColor.Value
            }, true)
        end
        table.insert(Objects.Items, Object)
    elseif Object.Name == "GoldPile" and Object:GetAttribute("GoldValue") then
        if Toggles.CurrencyESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Gold Pile [" .. Object:GetAttribute("GoldValue") .. "]",
                Color = Options.CurrencyESPColor.Value
            }, true)
        end
        table.insert(Objects.Currency, Object)
    elseif Object.Name == "StardustPickup" then
        if Toggles.CurrencyESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Stardust Pile",
                Color = Options.CurrencyESPColor.Value
            }, true)
        end
        table.insert(Objects.Currency, Object)
    elseif Object.Name == "GiggleCeiling" then
        if Toggles.EntityESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Giggle",
                Color = Options.EntityESPColor.Value
            }, true)
        end
        if Toggles.BypassGiggle.Value then
            Object:WaitForChild("Hitbox").CanTouch = false
        end
        table.insert(Objects.Entities, Object)
    elseif Object.Name == "GloomPile" then
        if Toggles.BypassGloombatEggs.Value then
            for Index2, Object2 in pairs(Object:GetDescendants()) do
                if Object2:IsA("BasePart") then
                    Object2.CanTouch = false
                end
            end
        end
        if Toggles.EntityESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Gloombat Eggs",
                Color = Options.EntityESPColor.Value
            }, true)
        end
        table.insert(Objects.Entities, Object)
    elseif Object.Name == "TriggerEventCollision" and Functions.CheckCompatability({"firetouchinterest"}) then
        if Floor == "Fools" and Toggles.RemoveSeekTrigger.Value or Floor == "OldHotel" and Toggles.RemoveSeekTrigger.Value then
            local Tries = 0
            while Object:FindFirstChild("Collision") and Tries < 150 do
                for Index2, Object2 in pairs(Object:GetChildren()) do
                    if Object2:IsA("BasePart") then
                        Abysall.Environment.firetouchinterest(RootPart, Object2, 1)
                        task.wait()
                        Abysall.Environment.firetouchinterest(RootPart, Object2, 0)
                    end
                end
                task.wait()
                Tries = Tries + 1
            end
        end
        table.insert(Objects.EventTriggers, Object)
    elseif Object.Name == "DoorFake" or Object.Name == "FakeDoor" then
        if Object.Parent and Object:FindFirstChild("Hidden") then
            if Toggles.BypassDupe.Value then
                Object:WaitForChild("Hidden").CanTouch = false
                if Object:FindFirstChild("Lock") and Object.Lock:FindFirstChild("UnlockPrompt") then
                    Object.Lock.UnlockPrompt.Enabled = false
                end
            end
            table.insert(Objects.Entities, Object)
        end
    elseif Object.Name == "SideroomSpace" then
        if Toggles.BypassVacuum.Value then
            Object:WaitForChild("Collision").CanCollide = true
            Object:WaitForChild("Collision").CanTouch = false
        end
        table.insert(Objects.Entities, Object)
    elseif Object.Name == "Snare" then
        if Object:FindFirstChild("Snare") then
			Object:WaitForChild("Snare").Roots.Transparency = 1
			Object:WaitForChild("Snare").SnareBase.Transparency = 1
		end
		if Object:FindFirstChild("Void") then
			Object:WaitForChild("Void").Transparency = 0	
			Object:WaitForChild("Void").Color = Color3.fromRGB(76, 67, 55)
		end
        if Toggles.EntityESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Snare",
                Color = Options.EntityESPColor.Value
            }, true)
        end
        if Toggles.BypassSnare.Value and Object:FindFirstChild("Hitbox") then
            Object.Hitbox.CanTouch = false
        end
        table.insert(Objects.Entities, Object)
    elseif Object.Name == "Seek_Arm" or Object.Name == "ChandelierObstruction" then
        for Index, Part in pairs(Object:GetDescendants()) do
            if Part:IsA("BasePart") then
                Part.CanTouch = not Toggles.BypassSeekObstructions.Value
                table.insert(Objects.SeekObstructions, Part)
            end
        end
    elseif Object.Name == "SeekFloodline" then
        Object.CanCollide = Toggles.BypassSeekObstructions.Value

        local Connection = Object:GetPropertyChangedSignal("CanCollide"):Connect(function()
            if Object.CanCollide ~= Toggles.BypassSeekObstructions.Value then
                Object.CanCollide = Toggles.BypassSeekObstructions.Value
            end
        end)
        Object.Destroying:Once(function()
            Connection:Disconnect()
        end)

        table.insert(Objects.SeekObstructions, Object)
    elseif Object:GetAttribute("RawName") and string.find(Object:GetAttribute("RawName"), "Halt") or Object:GetAttribute("Shade") == true then
        if Toggles.NotifyEntities.Value and Options.EntityList.Value["Halt"] then
            Functions.Notify({Title = "Entity 'Halt' will spawn in the next room."})
            
            if Toggles.EntityChatToggle.Value then
                Functions.SendChat("Halt next room!")
            end
        end
        local Connection
        Connection = Services.LogService.MessageOut:Connect(function(Message)
            if Message == "client teleporting" then
                if Globals.AnticheatDisabled == true then
                    Globals.AnticheatDisabled = false
                    Functions.Notify({Title = "The anticheat has been re-enabled.", Body = "Interact with a ladder to disable it again."})
                end
                Connection:Disconnect()
            end
        end)
    elseif Object.Name == "BananaPeel" then
        if Toggles.BypassBanana.Value then
            Object.CanTouch = false
        end
        table.insert(Objects.Entities, Object)
    elseif Object.Name == "JeffTheKiller" then
        if Toggles.BypassJeff.Value then
            task.wait(1)
            for Index2, Object2 in pairs(Object:GetDescendants()) do
                if Object2:IsA("BasePart") then
                    Object2.CanCollide = false
                    Object2.CanTouch = false
                end
            end
            Object:WaitForChild("Humanoid").Health = 0
        end
    elseif Object.Name == "GrumbleRig" then
        if Toggles.EntityESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Grumble",
                Color = Options.EntityESPColor.Value
            }, true)
        end
        table.insert(Objects.Entities, Object)
    elseif Object.Name == "Drakobloxxer" then
        if Toggles.EntityESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Drakobloxxer",
                Color = Options.EntityESPColor.Value
            }, true)
        end
        table.insert(Objects.Entities, Object)
    elseif Object.Name == "LiveEntityBramble" then
        if Toggles.EntityESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Bramble",
                Color = Options.EntityESPColor.Value
            }, true)
        end
        table.insert(Objects.Entities, Object)
    elseif Object.Name == "Groundskeeper" then
        if Toggles.EntityESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Groundskeeper",
                Color = Options.EntityESPColor.Value
            }, true)
        end

        local EntityData = Entities["Groundskeeper"]
        if Toggles.NotifyEntities.Value and Options.EntityList.Value["Groundskeeper"] then
            Functions.Notify({Title = EntityData.NotifyMessage.Title, Body = EntityData.NotifyMessage.Body})
        end

        table.insert(Objects.Entities, Object)
    elseif Object.Name == "Figure" or Object.Name == "FigureRig" or Object.Name == "FigureRagdoll" then
        if Toggles.EntityESPToggle.Value then
            Functions.AddESP({
                Object = Object,
                Text = "Figure",
                Color = Options.EntityESPColor.Value
            }, true)
        end
        table.insert(Objects.Entities, Object)

        if Toggles.RemoveFigure.Value and Functions.CheckCompatability({"isnetworkowner", "firetouchinterest"}) then
            if Floor == "Mines" then
                for Index2, Object2 in pairs(Object:GetDescendants()) do
                    if Object2:IsA("BasePart") then
                        task.spawn(function()
                            Abysall.Environment.firetouchinterest(RootPart, Object2, 1)
                            task.wait()
                            Abysall.Environment.firetouchinterest(RootPart, Object2, 0)
                            while Abysall.Environment.isnetworkowner(Object2) do
                                Object2.CFrame = CFrame.new(-49999, -49999, -49999)
                                break
                            end
                        end)
                    end
                end
            elseif Floor == "OldHotel" or Floor == "Fools" then
                local OwnershipReceived = false
                CurrentRooms.ChildAdded:Wait()
                Character:PivotTo(Object:GetPivot())
                for Index2, Object2 in pairs(Object:GetDescendants()) do
                    if Object2:IsA("BasePart") then
                        task.spawn(function()
                            Abysall.Environment.firetouchinterest(RootPart, Object2, 1)
                            task.wait()
                            Abysall.Environment.firetouchinterest(RootPart, Object2, 0)
                            while Abysall.Environment.isnetworkowner(Object2) do
                                OwnershipReceived = true
                                Object2.CFrame = CFrame.new(49999, 49999, 49999)
                                Object:Destroy()
                                task.wait()
                            end
                        end)
                    end
                end
            end
        end
    elseif Object.Name == "ThingToOpen" and Floor == "Fools" or Object.Name == "ThingToOpen" and Floor == "OldHotel" then
        Object:SetAttribute("OriginalPosition", Object:GetPivot())
        
        if Toggles.RemoveBasementGate.Value then
            Object:PivotTo(CFrame.new(-10000, -10000, -10000))
        end
        table.insert(Objects.Obstructions, Object)
    elseif Object.Name == "MovingDoor" and Floor == "Fools" or Object.Name == "MovingDoor" and Floor == "OldHotel" then
        Object:SetAttribute("OriginalPosition", Object:GetPivot())
        
        if Toggles.RemovePaintingsDoor.Value then
            Object:PivotTo(CFrame.new(-10000, -10000, -10000))
        end
        table.insert(Objects.Obstructions, Object)
    elseif Object.Name == "Wax_Door" and Floor == "Fools" then
        Object:SetAttribute("OriginalPosition", Object:GetPivot())
        
        if Toggles.RemoveSkeletonDoor.Value then
            Object:PivotTo(CFrame.new(-10000, -10000, -10000))
        end
        table.insert(Objects.Obstructions, Object)
    elseif Object.Name == "ElevatorBreaker" then
        if Toggles.AutoBreakerBox.Value and not Globals.BreakerBoxNotified then
            Functions.Notify({Title = "Interact with the breaker box.", Body = "It will be automatically solved."})
            Globals.BreakerBoxNotified = true
        end
        Connections.BreakerConnection = Object:WaitForChild("SurfaceGui").Frame.Code:GetPropertyChangedSignal("Text"):Connect(function()
            if Toggles.AutoBreakerBox.Value then
                if not Globals.BreakerBoxStartNotified and Floor == "Fools" or not Globals.BreakerBoxStartNotified and Floor == "OldHotel" then
                    Functions.Notify({Title = "Attempting to solve the breaker box.", Body = "Please wait."})
                    Globals.BreakerBoxStartNotified = true
                end
                RemotesFolder.EBF:FireServer()
            end
            Globals.BreakerBoxInteracted = true
        end)
    elseif Object.Name == "ElevatorCar" then
        local Connection = Object.DescendantAdded:Connect(function(Object2)
            if Toggles.AutoBreakerBox.Value and Object2.Name == "TouchInterest" and not Globals.BreakerBoxFinishedNotified then
                Functions.Notify({Title = "Successfully solved the breaker box.", Body = "Try going to the elevator!"})
                Globals.BreakerBoxFinishedNotified = true
            end
        end)

        Object.Destroying:Once(function()
            Connection:Disconnect()
        end)
    elseif Object:IsA("ProximityPrompt") and not Object:GetAttribute("FakePrompt") then
        if Object:HasTag("DisableWhenEnabledOnClient") then
            Object:RemoveTag("DisableWhenEnabledOnClient")
        end

        Object:SetAttribute("HoldDuration_Old", Object.HoldDuration)
        Object:SetAttribute("RequiresLineOfSight_Old", Object.RequiresLineOfSight)
        Object:SetAttribute("MaxActivationDistance_Old", Object.MaxActivationDistance)

        local LockPrompts = {
			"UnlockPrompt",
			"SkullPrompt",
			"LockPrompt",
			"ThingToEnable",
			"FusesPrompt",
		}

        if Functions.CheckCompatability({"fireproximityprompt"}) and Floor ~= "OldHotel" and Floor ~= "Fools" then
            if table.find(LockPrompts, Object.Name) or Object.Parent ~= nil and Object.Parent:GetAttribute("Locked") == true or Object.Parent ~= nil and Object.Parent.Parent ~= nil and Object.Parent.Parent.Name == "Locker_Small_Locked" and Object.Name == "ActivateEventPrompt" then
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

                if Toggles.InstantPrompts.Value then
                    FakePrompt.HoldDuration = 0
                end
                if Toggles.PromptClip.Value then
                    FakePrompt.RequiresLineOfSight = false
                end
                if Toggles.PromptReachToggle.Value then
                    FakePrompt.MaxActivationDistance = FakePrompt:GetAttribute("MaxActivationDistance_Old") * Options.PromptReachSlider.Value
                end

                FakePrompts[FakePrompt] = Object
                pcall(function()
                    Object.Parent = Globals.PromptContainer
                end)

                local Connection = Object:GetPropertyChangedSignal("Enabled"):Connect(function()
                    FakePrompt.Enabled = Object.Enabled
                end)
                Object:GetPropertyChangedSignal("ActionText"):Once(function()
                    Object.Parent = FakePrompt.Parent
                    FakePrompt:Destroy()
                    Connection:Disconnect()
                end)
                Object.Destroying:Once(function()
                    FakePrompt:Destroy()
                    Connection:Disconnect()
                end)
                table.insert(Connections, Connection)
                table.insert(Objects.Prompts, FakePrompt)

                FakePrompt.Enabled = false
                task.wait()
                FakePrompt.Enabled = Object.Enabled
            end
        end

        table.insert(Objects.Prompts, Object)

        if Toggles.InstantPrompts.Value then
            Object.HoldDuration = 0
        end
        if Toggles.PromptClip.Value then
            Object.RequiresLineOfSight = false
        end
        if Toggles.PromptReachToggle.Value then
            Object.MaxActivationDistance = Object:GetAttribute("MaxActivationDistance_Old") * Options.PromptReachSlider.Value
        end
    elseif Object.Name == "Padlock" then
        Connections.PadlockConnection = Services.RunService.Heartbeat:Connect(function()
            if Toggles.AutoUnlockPadlockToggle.Value and Object.PrimaryPart then
                local Distance = LocalPlayer:DistanceFromCharacter(Object.PrimaryPart.Position)
                local Code = Functions.GetLibraryCode()

                if Code and tonumber(Code) and Distance < Options.AutoUnlockPadlockSlider.Value then
                    RemotesFolder.PL:FireServer(Code)
                end
            end
        end)

        Object.Destroying:Once(function()
            Connections.PadlockConnection:Disconnect()
        end)
    end

    return
end

Connections.PromptAnimationFixer1 = Services.ProximityPromptService.PromptButtonHoldBegan:Connect(function(Object)
    if Object:GetAttribute("FakePrompt") then
        local Tool = Character:FindFirstChild("Lockpick") or Character:FindFirstChild("Shears") or Character:FindFirstChild("SkeletonKey") or Character:FindFirstChild("Key") or Character:FindFirstChild("KeyElectrical") or Character:FindFirstChild("KeyBackdoor") or Character:FindFirstChild("KeyIron")
		if Tool then
            if Globals.UseAnimation then
                Globals.UseAnimationBreak:Stop()
                Globals.UseAnimation:Stop()
                Globals.UseAnimation:Play()

                if Tool.Name == "Shears" then
                    Tool:WaitForChild("Handle"):WaitForChild("sound_prompt"):Play()
                end
            end
		end
    end
end)

for Index, Object in pairs(Services.Workspace:GetDescendants()) do
    task.spawn(function()
        Functions.HandleObject(Object)
    end)
end

Connections.InstanceHandler = Services.Workspace.DescendantAdded:Connect(function(Object)
    Functions.HandleObject(Object)
end)

for Index, Object in pairs(Services.Players:GetPlayers()) do
    if Object ~= LocalPlayer then
        if Object.Character and Toggles.PlayerESPToggle.Value then
            Functions.AddESP({
                Object = Object.Character,
                Text = Object.Name,
                Color = Options.PlayerESPColor.Value
            })
        end
        local Connection = Object.CharacterAdded:Connect(function(NewCharacter)
            Functions.AddESP({
                Object = NewCharacter,
                Text = NewCharacter.Name,
                Color = Options.PlayerESPColor.Value
            })
        end)
        table.insert(Connections, Connection)
        Object.Destroying:Once(function()
            Connection:Disconnect()
        end)
    end
end

Connections.PlayerHandler = Services.Players.PlayerAdded:Connect(function(Object)
    if Object ~= LocalPlayer then
        if Object.Character and Toggles.PlayerESPToggle.Value then
            Functions.AddESP({
                Object = Object.Character,
                Text = Object.Name,
                Color = Options.PlayerESPColor.Value
            })
        end
        local Connection = Object.CharacterAdded:Connect(function(NewCharacter)
            Functions.AddESP({
                Object = NewCharacter,
                Text = NewCharacter.Name,
                Color = Options.PlayerESPColor.Value
            })
        end)
        table.insert(Connections, Connection)
        Object.Destroying:Connect(function()
            Connection:Disconnect()
        end)
    end
end)

Functions.FirePrompt = Abysall.Environment.fireproximityprompt
Functions.ForceFirePrompt = Abysall.Environment.fireproximityprompt
if not Functions.FirePrompt then
    Functions.FirePrompt = function(Prompt)
        local OldHold = Prompt.HoldDuration
        local OldEnabled = Prompt.Enabled
        local OldClip = Prompt.RequiresLineOfSight
        Prompt.HoldDuration = 0
        Prompt.Enabled = true
        Prompt.RequiresLineOfSight = false
        Prompt:InputHoldBegin()
        Prompt:InputHoldEnd()
        Prompt.HoldDuration = OldHold
        Prompt.Enabled = OldEnabled
        Prompt.RequiresLineOfSight = OldClip
    end
    Functions.ForceFirePrompt = function(Prompt)
        local OldHold = Prompt.HoldDuration
        local OldEnabled = Prompt.Enabled
        local OldClip = Prompt.RequiresLineOfSight
        Prompt.HoldDuration = 0
        Prompt.Enabled = true
        Prompt.RequiresLineOfSight = false

        local Position

        if Prompt.Parent:IsA("BasePart") then
            Position = Prompt.Parent.CFrame
        elseif Prompt.Parent:IsA("Model") then
            if Prompt.Parent.PrimaryPart then
                Position = Prompt.Parent.PrimaryPart.CFrame
            else
                Position = Prompt.Parent:GetPivot()
            end
        end

        for i = 1, 10, 1 do
            Camera.CFrame = CFrame.lookAt(Position.LookVector * 3, Position.Position)
            Prompt:InputHoldBegin()
            Prompt:InputHoldEnd()
            task.wait()
        end

        Prompt.HoldDuration = OldHold
        Prompt.Enabled = OldEnabled
        Prompt.RequiresLineOfSight = OldClip
    end
end

local AutoInteractBlacklist = {
    "HidePrompt",
    "RiftPrompt",
    "StarRiftPrompt",
    "InteractPrompt",
    "ClimbPrompt",
    "DonatePrompt",
    "DialoguePrompt",
    "RevivePrompt",
    "EnterPrompt",
    "AnimatePrompt",
    "Prompt"
}

local Triggered = {}
local Debounce = false
Functions.TriggerPrompt = function(Prompt)
    if table.find(AutoInteractBlacklist, Prompt.Name) then
        return
    end

    if Prompt == nil or Prompt.Parent == nil then
        return
    end

    if Debounce then
        return
    end

    if Functions.HasItem(Prompt.Parent.Name) and Functions.HasItem(Prompt.Parent.Name):GetAttribute("Durability") and Functions.HasItem(Prompt.Parent.Name):GetAttribute("DurabilityMax") and Functions.HasItem(Prompt.Parent.Name):GetAttribute("Durability") >= Functions.HasItem(Prompt.Parent.Name):GetAttribute("DurabilityMax") then
        return
    end

    if Prompt.Name == "UnlockPrompt" or Prompt.Name == "SkullPrompt" or Prompt.Parent:GetAttribute("Locked") == true and Prompt.Name == "ActivateEventPrompt" or Prompt.Parent.Parent and Prompt.Parent.Parent:GetAttribute("Locked") == true and Prompt.Name == "ActivateEventPrompt" then
        if Options.AutoInteractIgnoreList.Value["Locks"] then
            return
        end
        if not Functions.HasItem("Key", true) and not Functions.HasItem("KeyBackdoor", true) and not Functions.HasItem("KeyElectrical", true) and not Functions.HasItem("KeyIron", true) and not Functions.HasItem("Lockpick", true) and not Functions.HasItem("SkeletonKey", true) and not Functions.HasItem("Shears", true) and not Functions.HasItem("Multitool", true) then
            return
        end
    end

    if Prompt.Parent.Name == "GlitchCube" and Options.AutoInteractIgnoreList.Value["Glitch Fragments"] then
        return
    end

    if Prompt.Parent.Name == "KeyObtain" and Functions.HasItem("Key") or Prompt.Parent.Name == "KeyObtain" and Functions.HasItem("KeyBackdoor") or Prompt.Parent.Name == "ElectricalKeyObtain" and Functions.HasItem("KeyElectrical") then
        return
    end

    if Prompt:IsDescendantOf(Drops) and Options.AutoInteractIgnoreList.Value["Dropped Items"] then
        return
    end

    if Prompt.Parent.Name == "TrackLever" then
        return
    end

    if Prompt.Name == "ActivateEventPrompt" and Prompt.ActionText == "Close" or Prompt.Name == "ActivateEventPrompt" and Prompt.Parent.Name == "ElevatorBreaker" or Prompt.Name == "ActivateEventPrompt" and Prompt.Parent.Parent and Prompt.Parent.Parent.Name == "IndustrialGate" then
        return
    end

    if Prompt.Name == "ActivateEventPrompt" and Prompt.Parent.Name == "Padlock" or Prompt.Name == "ActivateEventPrompt" and Prompt.Parent.Name == "MinesAnchor" then
        return
    end

    if Prompt.Parent.Name == "LeverForGate" and Prompt:GetAttribute("Interactions") then
        return
    end

    if Prompt.Parent.Parent and Prompt.Parent.Parent.Name == "DoorFake" or Prompt.Parent.Parent and Prompt.Parent.Parent.Name == "FakeDoor" then
        return
    end

    if Prompt.Parent:GetAttribute("JeffShop") and Options.AutoInteractIgnoreList.Value["Jeff Items"] then
        return
    end

    if Prompt:GetAttribute("AutoInteractIgnore") then
        return
    end

    if Prompt.Name == "PushPrompt" and Options.AutoInteractIgnoreList.Value["Minecarts"] then
        return
    end

    if Prompt.Name == "PropPrompt" and Options.AutoInteractIgnoreList.Value["Paintings"] then
        return
    end

    if Prompt.Parent.Name == "GoldPile" and Options.AutoInteractIgnoreList.Value["Currency"] or Prompt.Parent.Name == "StardustPickup" and Options.AutoInteractIgnoreList.Value["Currency"] then
        return
    end

    if Prompt.Parent.Name == "Bandage" and Humanoid.Health >= Humanoid.MaxHealth or Prompt.Parent.Name == "Bandage" and Functions.HasItem("BandagePack") and Functions.HasItem("BandagePack"):GetAttribute("Durability") >= Functions.HasItem("BandagePack"):GetAttribute("DurabilityMax") then
        return
    end

    if Prompt.Parent.Name == "Battery" and not Character:FindFirstChildOfClass("Tool") or Prompt.Parent.Name == "Battery" and Functions.HasItem("BatteryPack") and Functions.HasItem("BatteryPack"):GetAttribute("Durability") >= Functions.HasItem("BatteryPack"):GetAttribute("DurabilityMax") then
        return
    end

    if Prompt.Parent.Name == "Battery" and Character:FindFirstChildOfClass("Tool") and Character:FindFirstChildOfClass("Tool"):GetAttribute("LightSource") then
        local Tool = Character:FindFirstChildOfClass("Tool")
        if Tool:GetAttribute("Durability") and Tool:GetAttribute("DurabilityMax") and Tool:GetAttribute("Durability") > Tool:GetAttribute("DurabilityMax") or Tool.Name ~= "Lighter" or Tool.Name ~= "Glowsticks" or Tool.Name ~= "Candle" or Tool.Name ~= "RiftCandle" then
            return
        end
    end

    if Prompt.Name == "HerbPrompt" and Globals.MainUI.MainFrame.Healthbar:FindFirstChild("Effects") and Globals.MainUI.MainFrame.Healthbar.Effects.HerbGreenEffect.Visible then
        return
    end

    if Prompt.Parent.Name == "Battery" and Character:FindFirstChildOfClass("Tool") and Character:FindFirstChildOfClass("Tool"):GetAttribute("LightSource") ~= true then
        return
    end

    if Prompt.Parent.Name == "LibraryHintPaper" and Functions.HasItem("LibraryHintPaper") or Prompt.Parent.Name == "PickupItem" and Functions.HasItem("LibraryHintPaper") or Prompt.Parent.Name == "PickupItem" and Functions.HasItem("LibraryHintPaperHard") or Prompt.Parent.Name == "AlarmClock" and Functions.HasItem("AlarmClock") then
        return
    end

    if Prompt.Parent.Name == "KeyObtainFake" then
        return
    end
   
    Functions.FirePrompt(Prompt)
    Debounce = true       
    if Floor == "OldHotel" then
        task.wait()
    end
    Debounce = false
end

local LastFire = tick()
Connections.AutoInteract = Services.RunService.Heartbeat:Connect(function()
    if Toggles.AutoInteractToggle.Value and tick() - LastFire > 0.05 or Options.AutoInteractKeybind:GetState() and tick() - LastFire > 0.05 then
        for Index, Prompt in pairs(Objects.Prompts) do
           task.spawn(function()
                if Prompt.Parent ~= nil and Prompt.Parent:IsA("BasePart") or Prompt.Parent ~= nil and Prompt.Parent:IsA("Model") then
                    local Distance
                    if Prompt.Parent:IsA("BasePart") then
                        Distance = LocalPlayer:DistanceFromCharacter(Prompt.Parent.Position)
                    else
                        Distance = LocalPlayer:DistanceFromCharacter(Prompt.Parent:GetPivot().Position)
                    end

                    if Distance <= Prompt.MaxActivationDistance and Prompt.Enabled then
                        Functions.TriggerPrompt(Prompt)
                    end
                end
            end)
        end
        LastFire = tick()
    end
end)

Connections.InfiniteItemsHandler = Services.ProximityPromptService.PromptTriggered:Connect(function(Object)
    if Object:GetAttribute("FakePrompt") then
        local Tool = Character:FindFirstChild("Lockpick") or Character:FindFirstChild("Shears") or Character:FindFirstChild("SkeletonKey") or Character:FindFirstChild("Key") or Character:FindFirstChild("KeyElectrical") or Character:FindFirstChild("KeyBackdoor") or Character:FindFirstChild("KeyIron")
		if Tool then
            if Globals.UseAnimation and Globals.UseAnimationBreak then
                Globals.UseAnimation:Stop()
                Globals.UseAnimationBreak:Stop()
                Globals.UseAnimationBreak:Play()

                if Tool.Name == "Shears" then
                    Tool:WaitForChild("Handle"):WaitForChild("sound_prompt"):Play()
                end
            end
		end
    end
    if Object:GetAttribute("FakePrompt") then
        local Tool = Character:FindFirstChildOfClass("Tool")
        local ToolData = Tool and ItemNames[Tool.Name]
        if Tool and ToolData and Toggles.InfiniteItemsToggle.Value and Options.InfiniteItemsList.Value[ToolData] then
            Drops.ChildAdded:Once(function(NewTool)
                local Prompt = NewTool:FindFirstChild("ModulePrompt")
                local RealPrompt = FakePrompts[Object]
                Functions.FirePrompt(Prompt)
                Functions.FirePrompt(RealPrompt)
            end)
            Character.ChildAdded:Once(function(NewTool)
                if NewTool.Name == "Shears" then
                    NewTool:WaitForChild("Handle"):WaitForChild("sound_promptend"):Play()
                end
            end)
            RemotesFolder.DropItem:FireServer(Tool)
        else
            local RealPrompt = FakePrompts[Object]
            Functions.FirePrompt(RealPrompt)
        end
    end
end)

Connections.FloorReplicatedHandler = FloorReplicated.DescendantAdded:Connect(function(Object)
    if Object.Name == "GlitchScreech" then
        Modules.GlitchScreech = Object
        if Toggles.RemoveScreech.Value and not Functions.CheckCompatability({"hookfunction"}) then
            Object.Name = "GlitchScreech_Disabled"
        end
    end
    if string.find(Object.Name, "Jumpscare") and Object:IsA("ModuleScript") then
        Object:SetAttribute("OriginalName", Object.Name)

        if Toggles.DisableEntityJumpscares.Value and not Functions.CheckCompatability({"hookfunction"}) then
            Object.Name = Object.Name .. "_Disabled"
        end

        table.insert(Objects.JumpscareModules, Object)
    end
end)

Connections.FogHandler = Services.Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
    if Services.Lighting.FogEnd ~= 10000000 then
        Globals.OldFog = Services.Lighting.FogEnd
    end
    if Toggles.RemoveCameraFog.Value then
        Services.Lighting.FogEnd = 10000000
    end
end)

Connections.EntityHandler = Services.Workspace.ChildAdded:Connect(function(Entity)
    if Entities[Entity.Name] then
        local EntityData = Entities[Entity.Name]

        local Rushers = {
            "Rush",
            "Ambush",
            "Eyes",
            "Lookman",
            "Blitz",
            "A-60",
            "A-120",
            "AR0xMBUSH",
            "RNIUSHCG==",
            "Custom Entity"
        }

        while not Entity.PrimaryPart do
            for Index, Child in pairs(Entity:GetChildren()) do
                if Child:IsA("BasePart") then
                    Entity.PrimaryPart = Child
                end
            end
            task.wait()
        end

        if LocalPlayer:DistanceFromCharacter(Entity.PrimaryPart.Position) < 10000 then
            if Options.EntityList.Value[EntityData.Alias] and Toggles.NotifyEntities.Value then
                local NotifyMessage = EntityData.NotifyMessage
                local Alias = EntityData.Alias
                if Entity.Name == "RushMoving" and Entity.PrimaryPart.Name ~= "RushNew" then
                    NotifyMessage.Title = NotifyMessage.Title:gsub("Rush", Entity.PrimaryPart.Name)
                    Alias = Entity.PrimaryPart.Name
                end

                Functions.Notify({Title = NotifyMessage.Title, Body = NotifyMessage.Body})

                if Toggles.EntityChatToggle.Value then
                    Functions.SendChat(Alias .. " " .. Options.EntityChatMessage.Value)
                end
            end

            if Entity.Name ~= "GloombatSwarm" then
                if Toggles.EntityESPToggle.Value then
                    Functions.AddESP({
                        Object = Entity,
                        Text = EntityData.Alias,
                        Color = Options.EntityESPColor.Value
                    })
                end
                table.insert(Objects.Entities, Entity)
            end
            
            if table.find(Rushers, EntityData.Alias) then
                local HighlightHumanoid = Instance.new("Humanoid", Entity)
                HighlightHumanoid.Name = "HighlightHumanoid"

                local Root = Entity.PrimaryPart
                if Root then
                    Root.Transparency = 0.99
                end

                local Sound = Root:FindFirstChild("Footsteps")
                if Sound then
                    local Old = 0

                    local Connection = Sound:GetPropertyChangedSignal("Volume"):Connect(function()
                        if Sound.Volume < 0.1 and Old > 0.1 then
                            Entity:SetAttribute("Inactive", true)
                            Functions.RemoveESP(Entity)
                            Functions.BlacklistESP(Entity)
                        end
                        if Sound.Volume > 0.1 then
                            Old = Sound.Volume
                        end
                    end)

                    Entity.Destroying:Once(function()
                        Connection:Disconnect()
                    end)
                end
            end

            if Entity.Name == "Lookman" then
                CurrentRooms.ChildAdded:Wait()
                task.wait(3)
                Entity:Destroy()
            end
        end
    end
end)

local LastClean = tick()
Connections.Cleaner = Services.RunService.Heartbeat:Connect(function()
    if tick() - LastClean > 0.2 then
        for Index, Array in pairs(Objects) do
            for Index2, Object in pairs(Array) do
                local Position = table.find(Array, Object)
                if Object == nil and Position or not Object:IsDescendantOf(Services.Workspace) and Position then
                    table.remove(Array, Position)
                    if ESPConnections[Object] then
                        local Connection = ESPConnections[Object]
                        Connection:Disconnect()

                        local Position = table.find(Connections, Connection)
                        table.remove(Connections, Position)
                    end
                end
            end
        end
        LastClean = tick()
    end
end)

local LastFix = tick()
Connections.PromptFixer = Services.RunService.Heartbeat:Connect(function()
    if tick() - LastFix > 0.2 then
        for Index, Prompt in pairs(Objects.Prompts) do
            if Prompt:HasTag("DisableWhenEnabledOnClient") then
                Prompt:RemoveTag("DisableWhenEnabledOnClient")
            end
        end
        LastFix = tick()
    end
end)

if LocalPlayer.Character then
    task.spawn(function()
        Functions.HandleCharacter(LocalPlayer.Character)
    end)
end
LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
    if Connections.MainHandler then
        Connections.MainHandler:Disconnect()
    end
    Functions.HandleCharacter(NewCharacter)
end)

Abysall.Interface.ApplySettingsTab(Window)
Library:OnUnload(function()
    for Index, Toggle in pairs(Library.Toggles) do
        Toggle:SetValue(false)
    end
    for Index, Connection in pairs(Connections) do
        Connection:Disconnect()
    end

    local OldAmbient = CurrentRooms:FindFirstChild(tostring(LocalPlayer:GetAttribute("CurrentRoom"))):GetAttribute("Ambient")
    Services.TweenService:Create(Services.Lighting, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {Ambient = OldAmbient}):Play()

    for Index, Prompt in pairs(Objects.Prompts) do
        if FakePrompts[Prompt] then
            FakePrompts[Prompt].Parent = Prompt.Parent
            Prompt:Destroy()
        end

        Prompt.HoldDuration = Prompt:GetAttribute("HoldDuration_Old")
        Prompt.RequiresLineOfSight = Prompt:GetAttribute("RequiresLineOfSight_Old")
        Prompt.MaxActivationDistance = Prompt:GetAttribute("MaxActivationDistance_Old")
    end

    Character:SetAttribute("CanJump", OldJump)
    Character:SetAttribute("CanSlide", OldSlide)

    for Index, Object in pairs(Services.Workspace:GetDescendants()) do
        task.spawn(function()
            Functions.RemoveESP(Object)
        end)
    end

    Humanoid.WalkSpeed = Functions.GetCurrentSpeed()
    Humanoid.JumpPower = 5
    Humanoid.HipHeight = 2.367

    Collision.Position = RootPart.Position + Vector3.new(0, 0.18, 0)
    CollisionPart.Position = RootPart.Position + Vector3.new(0, 0.18, 0)
    CollisionPartClone.Position = RootPart.Position + Vector3.new(0, 0.18, 0)

    if Collision:FindFirstChild("CollisionCrouch") then
        Collision.CollisionCrouch.Position = RootPart.Position + Vector3.new(0, -0.982, 0)
    end

    CollisionPartClone:Destroy()
    Abysall.ESPLibrary:Unload()
    if Main_Game then
        Main_Game.fovtarget = 70
        Main_Game.spring.Speed = 8
    end

    getgenv().Abysall = nil
end)

task.wait(0.5)
Functions.Notify({Title = "Successfully loaded in " .. math.floor((tick() - LoadStart) * 1000) / 1000 .. " seconds."})
