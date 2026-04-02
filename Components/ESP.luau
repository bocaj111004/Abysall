local Library = {
	ObjectsFolder = Instance.new("Folder"),
	ScreenGui = Instance.new("ScreenGui"),
	HighlightsFolder = Instance.new("Folder"),
	BillboardsFolder = Instance.new("Folder"),
	TracersFrame = Instance.new("Frame"),
	ArrowsFrame = Instance.new("Frame"),
	Highlights = {},
	Labels = {},
	Elements = {},
	ElementsEnabled = {},
	Frames = {},
	TotalObjects = {},
	TransparencyEnabled = {},
	Connections = {},
	Billboards = {},
	ColorTable = {},
	TextTable = {},
	Lines = {},
	ArrowsTable = {},
	Font = Enum.Font.RobotoCondensed,
	ConnectionsTable = {},
	Objects = {},
	ConnectionsManager = {},
	TracerTable = {},
	HighlightedObjects = {},
	Rainbow = false,
	Tracers = false,
	Unloaded = false,
	ShowDistance = false,
	MatchColors = true,
	Arrows = false,
	TextTransparency = 0,
	TracerOrigin = "Bottom",
	FillTransparency = 0.75,
	OutlineTransparency = 0,
	TextOffset = 0,
	TextOutlineTransparency = 0,
	FadeTime = 0,
	TracerSize = 0.5,
	ArrowRadius = 200,
	TextSize = 20,
	DistanceSizeRatio = 1,
	OutlineColor = Color3.fromRGB(255,255,255),
	RainbowColor = Color3.fromRGB(255,255,255),
}
local RainbowTable = {
	HueSetup = 0,
	Hue = 0,
	Step = 0,
	Color = Color3.new(),
	Enabled = false,
}

function Library:GenerateRandomString()
	local FinishedString = {}
	local CharacterList = [==[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890]==]
	local function GenerateSegment()
		local RandomIndex = math.random(1,#CharacterList)
		local Character = CharacterList:sub(RandomIndex,RandomIndex)
		return Character
	end
	for i = 1,24,1 do
		local NewCharacter = GenerateSegment()
		table.insert(FinishedString, NewCharacter)
	end
	return table.concat(FinishedString)
end

local CloneReference = (cloneref and cloneref or function(Object) return Object end)
local Players = CloneReference(game:GetService("Players"))
local CoreGui = (game:FindFirstChild("CoreGui") and CloneReference(game:GetService("CoreGui")) or Players.LocalPlayer.PlayerGui)
local function GetHiddenUI()
	if gethui then
		return gethui()
	end
	local HiddenUI = Instance.new("Folder", CoreGui)
	HiddenUI.Name = Library:GenerateRandomString()
	return HiddenUI
end

local Workspace = CloneReference(workspace)
local HttpService = CloneReference(game:GetService("HttpService"))
local UserInputService = CloneReference(game:GetService("UserInputService"))
local RunService = CloneReference(game:GetService("RunService"))
local TweenService = CloneReference(game:GetService("TweenService"))
local Debris = CloneReference(game:GetService("Debris"))
local LocalPlayer = Players.LocalPlayer
local ObjectsFolder = Library.ObjectsFolder
local HighlightedObjects = Library.HighlightedObjects
local Highlights = Library.Highlights
local ConnectionsTable = Library.ConnectionsTable
local Objects = Library.Objects
local TotalObjects = Library.TotalObjects
local Billboards = Library.Billboards
local Frames = Library.Frames
local ScreenGui = Library.ScreenGui
local ArrowsTable = Library.ArrowsTable
local HighlightsFolder = Library.HighlightsFolder
local Labels = Library.Labels
local Connections = Library.Connections
local Elements = Library.Elements
local TextTable = Library.TextTable
local HiddenUI = GetHiddenUI();
local ColorTable = Library.ColorTable
local Camera = Workspace.CurrentCamera
local Mouse = CloneReference(LocalPlayer:GetMouse())
local TracersFrame = Library.TracersFrame
local ArrowsFrame = Library.ArrowsFrame

ScreenGui.Parent = HiddenUI
HighlightsFolder.Parent = ScreenGui
BillboardsFolder = Library.BillboardsFolder
BillboardsFolder.Parent = ScreenGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
TracersFrame.Size = UDim2.new(1,0,1,0)
TracersFrame.BackgroundTransparency = 1
TracersFrame.Parent = ScreenGui
ArrowsFrame.Size = UDim2.new(1,0,1,0)
ArrowsFrame.BackgroundTransparency = 1
ArrowsFrame.Parent = ScreenGui
TracersFrame.Visible = false
ArrowsFrame.Visible = false
local ArrowTemplate = Instance.new("ImageLabel")
ArrowTemplate.Image = "http://www.roblox.com/asset/?id=16368985219"
ArrowTemplate.Size = UDim2.new(0, 50,0, 50)
ArrowTemplate.AnchorPoint = Vector2.new(0.5, 0.5)
ArrowTemplate.BackgroundTransparency = 1
ArrowTemplate.ImageTransparency = 1
local Constraint = Instance.new("UIAspectRatioConstraint")
Constraint.Parent = ArrowTemplate
Constraint.AspectRatio = 1
Constraint.Name = "Constraint"

if Library.Unloaded == true then return end
function Library:AddESP(Parameters)
	local Object = Parameters.Object
	if Library.ElementsEnabled[Object] == true or Library.Unloaded == true then return end
	if not Object:IsA("BasePart") and not Object:IsA("Model") then
		return
	end
	Library.TransparencyEnabled[Object] = false
	if Highlights[Object] then
		Highlights[Object]:Destroy()
		Highlights[Object] = nil
	end
	local MainPart = nil
	if Parameters.BasePart then
		MainPart = Parameters.BasePart
	end
	local Highlight = Instance.new("Highlight")
	Highlight.FillTransparency = 1
	Highlight.OutlineTransparency = 1
	Highlight.Name = Library:GenerateRandomString()
	Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	Highlight.Parent = HighlightsFolder
	Highlight.Adornee = Object
	Highlights[Object] = Highlight
	local ObjectTable = {Object}
	TextTable[Object] = Parameters.Text
	local TextFrame = Instance.new("Frame")
	TextFrame.Visible = false
	TextFrame.Name = Library:GenerateRandomString()
	TextFrame.Size = UDim2.fromScale(1,1)
	TextFrame.Parent = BillboardsFolder
	TextFrame.BackgroundTransparency = 1
	TextFrame.AnchorPoint = Vector2.new(0.5,0.5)
	local TextLabel = Instance.new("TextLabel")
	TextLabel.Name = Library:GenerateRandomString()
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = Parameters.Text
	TextLabel.TextTransparency = 1
	TextLabel.TextStrokeTransparency = Library.TextOutlineTransparency
	TextLabel.Size = UDim2.new(1,0,1,0)
	TextLabel.Font = Library.Font
	TextLabel.TextSize = Library.TextSize
	TextLabel.RichText = true
	TextLabel.Parent = TextFrame
	TextLabel.TextColor3 = Parameters.Color
	Labels[Object] = TextLabel
	Objects[Object] = ObjectTable
	Library.ElementsEnabled[Object] = true
	Labels[Object] = TextLabel
	local Manager = Library.ConnectionsManager[Object]
	if Highlight then
		TweenService:Create(Highlight,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{FillTransparency = Library.FillTransparency}):Play()
		TweenService:Create(Highlight,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{OutlineTransparency = Library.OutlineTransparency}):Play()
	end
	Frames[Object] = TextFrame
	Labels[Object] = TextLabel
	Objects[Object] = Object
	ColorTable[Object] = Parameters.Color 
	local LineFrame = Instance.new("Frame")
	LineFrame.Size = UDim2.new(0,0,0,0)
	LineFrame.BackgroundTransparency = 1
	LineFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	LineFrame.Parent = TracersFrame
	LineFrame.Name = Library:GenerateRandomString()
	local Stroke = Instance.new("UIStroke")
	Stroke.Thickness = Library.TracerSize
	Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	Stroke.Parent = LineFrame
	Stroke.Transparency = 1
	Stroke.Name = Library:GenerateRandomString()
	TweenService:Create(LineFrame,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{BackgroundTransparency = 0}):Play()
	TweenService:Create(Stroke,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{Transparency = 0}):Play()
	Library.Lines[Object] = {LineFrame, Stroke}
	if TextLabel then
		local Tween = TweenService:Create(TextLabel,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{TextTransparency = Library.TextTransparency})
		Tween:Play()
		TweenService:Create(TextLabel,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{TextStrokeTransparency = Library.TextOutlineTransparency}):Play()
		local TweenConnection = Tween.Completed:Once(function()
			Library.TransparencyEnabled[Object] = true
		end)
	end
	table.insert(Elements,TextFrame)
	table.insert(TotalObjects, Object)
	local Destroying1 = Object:GetPropertyChangedSignal("Parent"):Once(function()
		Library:RemoveESP(Object)
	end)
	if Object.Parent ~= nil then
		local Destroying2 = Object.Parent:GetPropertyChangedSignal("Parent"):Once(function()
			Library:RemoveESP(Object)
		end)
	end
	if Object:IsA("Model") and Object.PrimaryPart then
		local Destroying3 = Object.PrimaryPart:GetPropertyChangedSignal("Parent"):Once(function()
			Library:RemoveESP(Object)
		end)
	end

	task.spawn(function()
		local function Render()
			local Position
			Position = Object:GetPivot().Position
			if Position then
				local ScreenPoint, OnScreen = Camera:WorldToViewportPoint(Position)
				local Frame = Frames[Object]
				local Label = Labels[Object]
				local Highlight = Highlights[Object]
				if Library.Lines[Object][1] then
					Library.Lines[Object][1].Visible = (OnScreen)
				end
				if Frame then Frame.Visible = OnScreen end
				if not OnScreen then
					if Highlight then 
						Highlight:Destroy() 
						Highlights[Object] = nil 
						Highlight = nil 
					end
				elseif Frame then

					Frame.Position = UDim2.new(0,ScreenPoint.X,0,ScreenPoint.Y)
				end
				if Library.ElementsEnabled[Object] == true and OnScreen then
					if not Highlight then
						Highlight = Instance.new("Highlight")
						Highlight.FillTransparency = 1
						Highlight.OutlineTransparency = 1
						Highlight.Name = Library:GenerateRandomString()
						Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						Highlight.Parent = HighlightsFolder
						Highlight.Adornee = Object
						Highlights[Object] = Highlight
					end
				end
				Label.TextColor3 = Library.Rainbow and RainbowTable.Color or ColorTable[Object] or Color3.fromRGB(255,255,255)
				if Highlight then
					local distance = math.floor((Camera.CFrame.Position - Position).Magnitude)
					local distanceText = Library.ShowDistance and ("\n" .. '<font size="' .. math.round(Library.TextSize * Library.DistanceSizeRatio) .. '">[' .. distance .. ']</font>') or ""
					Label.Text = TextTable[Object] .. distanceText
					Highlight.Enabled = true
					Highlight.FillColor = Library.Rainbow and RainbowTable.Color or ColorTable[Object] or Color3.fromRGB(255,255,255)
					Highlight.OutlineColor = Library.MatchColors and Highlight.FillColor or Library.OutlineColor
					Highlight.FillColor = Library.Rainbow and RainbowTable.Color or ColorTable[Object] or Color3.fromRGB(255,255,255)
					if Library.TransparencyEnabled[Object] == true then
						Highlight.FillTransparency = Library.FillTransparency
						Highlight.OutlineTransparency = Library.OutlineTransparency
						Label.TextTransparency = Library.TextTransparency
						Label.TextStrokeTransparency = Library.TextOutlineTransparency
					end
				end
				local LineFrame = Library.Lines[Object][1]
				local Stroke = Library.Lines[Object][2]
				local Origin = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y * 1)
				if LineFrame and Highlight and Library.Tracers == true and OnScreen then
					if Library.TracerOrigin == "Center" then
						local MousePos = UserInputService:GetMouseLocation();
						Origin = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
					elseif Library.TracerOrigin == "Top" then
						Origin = Vector2.new(Camera.ViewportSize.X/2, 0)	
					elseif Library.TracerOrigin == "Mouse" then
						Origin = Vector2.new(LocalPlayer:GetMouse().X,UserInputService:GetMouseLocation().Y)
					end
					local Destination = Vector2.new(ScreenPoint.X, ScreenPoint.Y)
					local Position = (Origin + Destination) / 2
					local Rotation = math.deg(math.atan2(Destination.Y - Origin.Y, Destination.X - Origin.X))
					local Length = (Origin - Destination).Magnitude
					LineFrame.Position = UDim2.new(0, Position.X, 0, Position.Y)
					LineFrame.Size = UDim2.new(0, Length, 0, 1)
					LineFrame.Rotation = Rotation
					LineFrame.BackgroundColor3 = Highlight.FillColor
					LineFrame.BorderSizePixel = 0
					Stroke.Color = Highlight.FillColor
					Stroke.Thickness = Library.TracerSize
					LineFrame.Visible = true
				end

				local function GetArrowData(objPos)
					local ScreenSize = Camera.ViewportSize
					local ScreenCenter = Vector2.new(ScreenSize.X / 2, ScreenSize.Y / 2)
					local ToObj = (objPos - Camera.CFrame.Position).Unit
					local CamForward = Camera.CFrame.LookVector
					local Dir = Vector2.new(ScreenPoint.X, ScreenPoint.Y) - ScreenCenter
					local Dot = CamForward:Dot(ToObj)
					if Dot < 0 then
						Dir = -Dir
					end
					local Angle = math.atan2(Dir.Y, Dir.X)
					local radius = math.min(ScreenSize.X, ScreenSize.Y) / 2 - (400 - Library.ArrowRadius)
					local ArrowPos = ScreenCenter + Dir.Unit * radius
					return ArrowPos, math.deg(Angle)
				end

				if Object and Library.Arrows == true then
					local Arrow = ArrowsTable[Object] or nil
					if Arrow == nil and Library.ElementsEnabled[Object] == true then
						Arrow = ArrowTemplate:Clone()
						Arrow.Parent = ArrowsFrame
						Arrow.Name = Library:GenerateRandomString()
						Arrow:WaitForChild("Constraint").Name = Library:GenerateRandomString()
						ArrowsTable[Object] = Arrow
						TweenService:Create(Arrow ,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{ImageTransparency = 0}):Play()
					elseif Library.ElementsEnabled[Object] == true then
						if OnScreen and ScreenPoint.Z > 0 then
							ArrowsTable[Object].Visible = false
						else
							local arrowPos, angle = GetArrowData(Object:GetPivot().Position)
							ArrowsTable[Object].Position = UDim2.new(0, arrowPos.X, 0, arrowPos.Y)
							ArrowsTable[Object].Rotation = angle - 90
							ArrowsTable[Object].Visible = true
							ArrowsTable[Object].ImageColor3 = (Library.Rainbow == true and Library.RainbowColor or ColorTable[Object])
						end
					end
				end
			end
		end
		local Connection = RunService.PreRender:Connect(function()
			Render()
		end)
		ConnectionsTable[Object] = Connection
	end)
end

function Library:SetColorTable(Name,Color)
	ColorTable[Name] = Color
end

function Library:SetFadeTime(Number)
	Library.FadeTime = Number
end

function Library:SetTextTransparency(Number)
	Library.TextTransparency = Number
	for i,Label in pairs(Labels) do
		Label.TextTransparency = Number
	end
end

function Library:SetFillTransparency(Number)
	Library.FillTransparency = Number
	for i,Highlight in pairs(Highlights) do
		if Highlight:IsA("Highlight") then
			Highlight.FillTransparency = Number
		end
	end
end

function Library:SetOutlineTransparency(Number)
	Library.OutlineTransparency = Number
	for i,Highlight in pairs(Highlights) do
		if Highlight:IsA("Highlight") then
			Highlight.OutlineTransparency = Number
		end
	end
end

function Library:SetTextSize(Number)
	Library.TextSize = Number
	for i,Label in pairs(Labels) do
		Label.TextSize = Number
	end
end
function Library:SetTextOutlineTransparency(Number)
	Library.TextOutlineTransparency = Number
	for i,Label in pairs(Labels) do
		Label.TextStrokeTransparency = Number
	end
end
function Library:SetFont(Font)
	Library.Font = Font
	for i,Label in pairs(Labels) do
		Label.Font = Font
	end
end

function Library:UpdateObjectText(Object,Text)
	if Labels[Object] then
		TextTable[Object] = Text
	end
end
function Library:UpdateObjectColor(Object,Color)
	ColorTable[Object] = Color
	if Labels[Object] then
		Labels[Object].TextColor3 = Color
	end
end

function Library:SetOutlineColor(Color)
	Library.OutlineColor = Color
end

function Library:SetRainbow(Value)
	Library.Rainbow = Value
end

function Library:SetShowDistance(Value)
	Library.ShowDistance = Value
end

function Library:SetMatchColors(Value)
	Library.MatchColors = Value
end

function Library:SetTracers(Value)
	Library.Tracers = Value
	TracersFrame.Visible = Value
end

function Library:SetArrows(Value)
	Library.Arrows = Value
	ArrowsFrame.Visible = Value
end

function Library:SetArrowRadius(Value)
	Library.ArrowRadius = Value
end

function Library:SetTracerOrigin(Value)
	Library.TracerOrigin = Value
end

function Library:SetDistanceSizeRatio(Value)
	Library.DistanceSizeRatio = Value
end

function Library:SetTracerSize(Value)
	Library.TracerSize = 0.5 * Value
end

function RemoveObjectFromTables(Object)
	for index, obj in pairs(TotalObjects) do

		if obj == Object then

			table.remove(TotalObjects, index)

			break
		end

	end
end

function Library:RemoveESP(Object)
	if Library.Unloaded == true or Library.ElementsEnabled[Object] ~= true then return end
	Library.ElementsEnabled[Object] = false
	Library.TransparencyEnabled[Object] = false
	local Value = Instance.new("Frame", game.ReplicatedStorage)
	Value.BackgroundTransparency = 0
	Value.Name = Library:GenerateRandomString()
	Debris:AddItem(Value, Library.FadeTime + 0.5)
	local TextFrame = Frames[Object]
	local TextLabel = Labels[Object]
	if TextLabel then
		TweenService:Create(TextLabel,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{TextTransparency = 1}):Play()
	end
	if Library.Lines[Object] ~= nil then
		if Library.Lines[Object][1] ~= nil  then
			TweenService:Create(Library.Lines[Object][1],TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{BackgroundTransparency = 1}):Play()
		end
		if Library.Lines[Object][2] ~= nil  then
			TweenService:Create(Library.Lines[Object][2],TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{Transparency = 1}):Play()
		end
	end
	local Highlight
	if Highlights[Object] then
		TweenService:Create(Highlights[Object],TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{FillTransparency = 1}):Play()
		TweenService:Create(Highlights[Object],TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{OutlineTransparency = 1}):Play()
		Highlight = Highlights[Object]
	end
	if Library.Lines[Object][2] ~= nil then
		TweenService:Create(Library.Lines[Object][2] ,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{Transparency = 1}):Play()
	end
	if ArrowsTable[Object] ~= nil then
		TweenService:Create(ArrowsTable[Object] ,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{ImageTransparency = 1}):Play()
	end
	if Object.Parent == nil then
		if Library.ElementsEnabled[Object] == false then
			if Frames[Object] then
				Frames[Object]:Destroy()
				Frames[Object] = nil
			end
			Objects[Object] = nil
			if Highlight then
				Highlight:Destroy()
				Highlights[Object] = nil

			end
			RemoveObjectFromTables(Object)
			if ArrowsTable[Object] then
				ArrowsTable[Object]:Destroy()
				ArrowsTable[Object] = nil
			end
			if Connections[Object] then
				Connections[Object]:Disconnect()
			end
			if Library.Lines[Object] ~= nil then
				if Library.Lines[Object][1] ~= nil  then
					Library.Lines[Object][1]:Destroy()
				end
				if Library.Lines[Object][2] ~= nil  then
					Library.Lines[Object][2]:Destroy()
				end
				Library.Lines[Object] = {}
			end
			if Library.TracerTable[Object] ~= nil then
				Library.TracerTable[Object]:Destroy()
			end
			Value:Destroy()
		else
			if Highlight then
				TweenService:Create(Highlight,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{FillTransparency = Library.FillTransparency}):Play()
				TweenService:Create(Highlight,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{OutlineTransparency = Library.OutlineTransparency}):Play()
			end
		end
	else
		local DestroyTween = TweenService:Create(Value,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{BackgroundTransparency = 1})
		DestroyTween:Play()
		local DestroyTween1 = DestroyTween.Completed:Once(function()
			if Library.ElementsEnabled[Object] == false then
				if Frames[Object] then
					Frames[Object]:Destroy()
					Frames[Object] = nil
				end
				RemoveObjectFromTables(Object)
				if Connections[Object] then
					Connections[Object]:Disconnect()
				end
				if ArrowsTable[Object] then
					ArrowsTable[Object]:Destroy()
					ArrowsTable[Object] = nil
				end
				if Highlight then
					Highlight:Destroy()
					Highlights[Object] = nil
				end
				if Library.Lines[Object] ~= nil then
					if Library.Lines[Object][1] ~= nil  then
						Library.Lines[Object][1]:Destroy()
					end
					if Library.Lines[Object][2] ~= nil  then
						Library.Lines[Object][2]:Destroy()
					end
					Library.Lines[Object] = {}
				end
				if Library.TracerTable[Object] ~= nil then
					Library.TracerTable[Object]:Destroy()
				end
				Value:Destroy()
			else
				if Highlight then
					TweenService:Create(Highlight,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{FillTransparency = Library.FillTransparency}):Play()
					TweenService:Create(Highlight,TweenInfo.new(Library.FadeTime,Enum.EasingStyle.Quad),{OutlineTransparency = Library.OutlineTransparency}):Play()
				end
			end
		end)
	end
end
local RainbowConnection = RunService.RenderStepped:Connect(function(Delta)
	RainbowTable.Step = RainbowTable.Step + Delta
	if RainbowTable.Step >= (1 / 60) then
		RainbowTable.Step = 0
		RainbowTable.HueSetup = RainbowTable.HueSetup + (1 / 400);
		if RainbowTable.HueSetup > 1 then RainbowTable.HueSetup = 0; end;
		RainbowTable.Hue = RainbowTable.HueSetup;
		RainbowTable.Color = Color3.fromHSV(RainbowTable.Hue, 0.8, 1);
		Library.RainbowColor = Color3.fromHSV(RainbowTable.Hue, 0.8, 1);
	end
end)
CameraConnection = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	Camera = Workspace.CurrentCamera
end)
function Library:Unload()
	for i,Object in pairs(Library.Objects) do
		Library:RemoveESP(Object)
	end
	for i,Connection in pairs(ConnectionsTable) do
		Connection:Disconnect()
	end
	RainbowConnection:Disconnect()
	CameraConnection:Disconnect()
	ScreenGui.Enabled = false
	Library.Unloaded = true
end
ObjectsFolder.Name = Library:GenerateRandomString()
ScreenGui.Name = Library:GenerateRandomString()
HighlightsFolder.Name = Library:GenerateRandomString()
TracersFrame.Name = Library:GenerateRandomString()
ArrowsFrame.Name = Library:GenerateRandomString()
BillboardsFolder.Name = Library:GenerateRandomString()
if getgenv then
	getgenv().ESPLibrary = Library
end
return Library
