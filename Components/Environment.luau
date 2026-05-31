local Environment = {}
local Log = {}
local Tested = 0
local Failed = 0
local Passed = 0

local BrokenFeatures = {
    ["Volcano"] = {"run_on_actor", "oth"},
    ["Solara"] = {"require"},
    ["Xeno"] = {"require"}
}

local function GetGlobal(Path)
	local Value = getfenv(0)
	while Value ~= nil and Path ~= "" do
		local Name, NextValue = string.match(Path, "^([^.]+)%.?(.*)$")
		Value = Value[Name]
		Path = NextValue
	end
	return Value
end

local Global = setmetatable({}, {
    __index = function(self, Name)
        local RawGlobal = GetGlobal(Name) or nil
        return RawGlobal
    end
})

local Services = setmetatable({}, {
    __index = function(self, Name)
        return game:GetService(Name)
    end
})

local Results = {}

local function AddResult(Name, Text)
    table.insert(Results, Text)
    Log[Name] = {
        Passed = string.find(Text, "✅") and true or false,
        Reason = Text,
    }
end

Environment.Results = Results
Environment.PrintResults = function()
    local Executor = Environment.identifyexecutor and Environment.identifyexecutor() or "Unknown"
    print("Test Result")
    for Index, Result in pairs(Results) do
        print(Result)
        task.wait()
    end
    print("Executor - " .. Executor)
    print("Tests passed: " .. Passed .. "/" .. Tested)
    print("Test score: " .. math.round((Passed / Tested) * 100) .. "%")
end

local function RunTest(Name, Test, InternalName)
    local TimedOut = false
    Tested = Tested + 1

    local ExecutorName = Global.identifyexecutor and Global.identifyexecutor() or "Unknown"
    if BrokenFeatures[ExecutorName] and table.find(BrokenFeatures[ExecutorName], Name) then
        AddResult(Name, "❌ " .. Name .. " failed: test has been skipped")
        Failed = Failed + 1
        return
    end

    local NewGlobal = Global[Name]
    if not NewGlobal then
        AddResult(Name, "❌ " .. Name .. " failed: function is nil")
        Failed = Failed + 1
        return
    end
    local Time = 0
    local Finished = false
    task.spawn(function()
        local Success, Result = pcall(Test)
        if not TimedOut then
            if Success then
                if InternalName then
                    Environment[InternalName] = NewGlobal
                else
                    Environment[Name] = NewGlobal
                end
                AddResult(Name, "✅ " .. Name)
                Passed = Passed + 1
            else
                AddResult(Name, "❌ " .. Name .. " failed: " .. Result)
                Failed = Failed + 1
            end
        end
        Finished = true
    end)
    while not Finished do
        Time = Time + 1
        if Time > 50 then
        AddResult(Name, "❌ " .. Name .. " failed: test timed out")
        Failed = Failed + 1
        TimedOut = true
        break
        end
        task.wait(0.1)
    end
end

--[[ Environment ]]

RunTest("getgenv", function()
    assert(typeof(Global.getgenv()) == "table", "Did not return a table")

    Global.getgenv().Example = "Test"
    assert(Example == "Test", "Failed to set a global variable")
    Global.getgenv().Example = nil
end)

RunTest("getrenv", function()
    assert(Environment.getgenv, "getgenv is required to test")
    local Env = Global.getrenv()

    assert(typeof(Env) == "table", "Did not return a table")
    assert(typeof(Env.print) == "function", "Did not return an environment table")
    assert(Global.getrenv ~= Global.getgenv, "getrenv is an alias of getgenv")
    assert(Global.getgenv() ~= Global.getrenv(), "Returned executor environment")

    local Success, Result = pcall(function()
        return Env.loadstring([[return 10]])()
    end)

    assert(Success == false, "Should error when calling loadstring from roblox environment")
end)

RunTest("getgc", function()
    local TestFunction = function()
        return 10
    end
    local TestTable = {
        Value = 10
    }

    local YesTables = Global.getgc(true)
    local NoTables = Global.getgc(false)

    assert(table.find(YesTables, TestTable), "Failed to find a table")
    assert(table.find(YesTables, TestFunction), "Failed to find a function")

    assert(not table.find(NoTables, TestTable), "Should not return a table when called with false")
    assert(table.find(NoTables, TestFunction), "Failed to find a function")
end)

--[[ Miscellaneous ]]

RunTest("identifyexecutor", function()
    assert(typeof(Global.identifyexecutor()) == "string", "Did not return a string")
end)

RunTest("request", function()
    local Response = Global.request({
        Url = "https://httpbin.org/get",
        Method = "GET"
    })

    assert(Response.StatusCode == 200, "Status code should be 200")
    assert(typeof(Response.Body) == "string", "Body should be a string")
end)

--[[ Instances ]]

RunTest("cloneref", function()
    local TestPart = Instance.new("Part")
    local Clone = Global.cloneref(TestPart)

    assert(typeof(Clone) == "Instance", "Should return an Instance")
    assert(TestPart ~= Clone, "Clone should not be equal to original")

    TestPart.Name = "Test"
    assert(Clone.Name == "Test", "Changing the original did not change the clone")
    end)

    RunTest("gethui", function()
    assert(typeof(Global.gethui()) == "Instance", "Should return an instance")

    local ValidClasses = {
        "ScreenGui",
        "Folder",
        "BasePlayerGui",
        "CoreGui"
    }
    if not Global.gethui():IsDescendantOf(Services.CoreGui) and Global.gethui().ClassName ~= "CoreGui" or not table.find(ValidClasses, Global.gethui().ClassName) then
    error("Did not return a valid gui container")
    end
end)

RunTest("getcallbackvalue", function()
    local TestBindable = Instance.new("BindableFunction")
    TestBindable.OnInvoke = function(Value)
        return Value * 10
    end

    local Callback = Global.getcallbackvalue(TestBindable, "OnInvoke")
    assert(typeof(Callback) == "function", "Did not return a function")
    assert(Callback(5) == 50, "Did not return the callback value")
end)

RunTest("getinstances", function()
    local TestPart1 = Instance.new("Part")
    local TestPart2 = Instance.new("Part", Services.Workspace)

    local InstanceList = Global.getinstances()
    assert(table.find(InstanceList, TestPart2), "Did not return an instance")
    assert(table.find(InstanceList, TestPart1), "Did not return an instance parented to nil")

    TestPart1:Destroy()
    TestPart2:Destroy()
end)

RunTest("getnilinstances", function()
    local TestPart1 = Instance.new("Part")
    local TestPart2 = Instance.new("Part", Services.Workspace)

    local InstanceList = Global.getnilinstances()
    assert(not table.find(InstanceList, TestPart2), "Returned an instance not parented to nil")
    assert(table.find(InstanceList, TestPart1), "Did not return an instance parented to nil")

    TestPart1:Destroy()
    TestPart2:Destroy()
end)

RunTest("fireproximityprompt", function()
    local TestPart = Instance.new("Part", Services.Workspace)
    local TestPrompt = Instance.new("ProximityPrompt", TestPart)
    local Fired = false

    TestPrompt.Triggered:Connect(function()
    Fired = true
    end)

    Global.fireproximityprompt(TestPrompt)

    local Tries = 0
    while not Fired and Tries < 10 do
        Tries = Tries + 1
        task.wait(0.1)
    end

    TestPart:Destroy()
    assert(Fired == true, "Failed to fire a proximity prompt")
end)

RunTest("fireclickdetector", function()
    local TestPart = Instance.new("Part", workspace)
    local TestClick = Instance.new("ClickDetector", TestPart)
    local Fired = false

    TestClick.MouseClick:Connect(function()
    Fired = true
    end)

    Global.fireclickdetector(TestClick)

    local Tries = 0
    while not Fired and Tries < 10 do
        Tries = Tries + 1
        task.wait(0.1)
    end

    TestPart:Destroy()
    assert(Fired == true, "Failed to fire a click detector")
end)

RunTest("firetouchinterest", function()
    local TestPart1 = Instance.new("Part", Services.Workspace)
    TestPart1.Position = Vector3.new(0, 1000, 0)
    local TestPart2 = Instance.new("Part", Services.Workspace)
    TestPart2.Position = Vector3.new(0, 1000, 0)

    local Fired = false

    TestPart1.Touched:Connect(function(Child)
        if Child == TestPart2 then
            Fired = true
        end
    end)

    Global.firetouchinterest(TestPart1, TestPart2, 0)
    task.wait()
    Global.firetouchinterest(TestPart1, TestPart2, 1)

    local Tries = 0
    while not Fired and Tries < 10 do
        Tries = Tries + 1
        task.wait(0.1)
    end

    TestPart1:Destroy()
    TestPart2:Destroy()
    assert(Fired == true, "Failed to fire a touch interest")
end)

--[[ Closures ]]

RunTest("clonefunction", function()
    local TestFunction = function()
        return 10
    end
    local TestClone = Global.clonefunction(TestFunction)
    assert(TestFunction ~= TestClone, "Returned the original function")
    assert(TestFunction() == TestClone(), "Clone did not return the same as the original")
    end)

    RunTest("newcclosure", function()
    local TestFunction = function()
        return 10
    end
    local TestC = Global.newcclosure(TestFunction)

    assert(TestFunction ~= TestC, "Returned the original function")
    assert(TestFunction() == TestC(), "Did not return the same value as the original")
    assert(TestC() == 10, "Did not return the correct value")
    assert(debug.info(TestC, "s") == "[C]", "Did not return a C function")
end)

RunTest("hookfunction", function()
    local TestFunction = function()
        return 10
    end
    local TestC = Global.newcclosure(function()
        return 25
    end)
    local TestHook = function()
        return 100
    end

    local Old = Global.hookfunction(TestFunction, TestHook)
    local OldC = Global.hookfunction(TestC, TestHook)
    assert(TestFunction ~= TestHook, "Original and hook are the same function")
    assert(debug.info(TestC, "s") == "[C]", "Hooked C function is no longer in C")
    assert(TestFunction() == 100, "Did not change the return value")
    assert(Old() == 10, "Did not return the original function")
    assert(OldC() == 25, "Did not return the original C function")
end)

RunTest("restorefunction", function()
    assert(Environment.hookfunction, "hookfunction is required to test")

    local TestFunction = function()
        return 10
    end
    local TestHook = function()
        return 100
    end

    Global.hookfunction(TestFunction, TestHook)
    Global.restorefunction(TestFunction)
    assert(TestFunction() == 10, "Failed to unhook a function")
end)

RunTest("isfunctionhooked", function()
    assert(Environment.hookfunction, "hookfunction is required to test")
    assert(Environment.restorefunction, "restorefunction is required to test")

    local TestFunction = function()
        return 10
    end
    local TestHook = function()
        return 100
    end

    Global.hookfunction(TestFunction, TestHook)
    assert(Global.isfunctionhooked(TestFunction) == true, "Did not return true for a hooked function")
    Global.restorefunction(TestFunction)
    assert(Global.isfunctionhooked(TestFunction) == false, "Did not return false for an unhooked function")
end)

RunTest("isexecutorclosure", function()
    assert(Environment.newcclosure, "newcclosure is required to test")

    local TestFunction = function()
        return 10
    end
    local TestC = Global.newcclosure(TestFunction)

    assert(Global.isexecutorclosure(TestFunction) == true, "Did not return true for an executor function")
    assert(Global.isexecutorclosure(Global.newcclosure) == true, "Did not return true for an executor global")
    assert(Global.isexecutorclosure(warn) == false, "Did not return false for a Roblox global")
    assert(Global.isexecutorclosure(TestC) == true, "Did not return true for an executor C function")
end)

--[[ Metatables ]]

RunTest("getnamecallmethod", function()
    pcall(function()
        game:ExampleNamecall()
    end)

    assert(typeof(Global.getnamecallmethod()) == "string", "Did not return a string")
    assert(Global.getnamecallmethod() == "ExampleNamecall", "Did not return the correct method")
end)

RunTest("hookmetamethod", function()
    assert(Environment.getnamecallmethod, "getnamecallmethod is required to test")
    assert(Environment.newcclosure, "newcclosure is required to test")

    local TestTable = setmetatable({}, {
        __index = Global.newcclosure(function()
            return "normal"
        end)
    })

    local Original
    Original = Global.hookmetamethod(TestTable, "__index", Global.newcclosure(function()
        return "hooked"
    end))

    assert(TestTable.Example == "hooked", "Failed to hook a metamethod")
end)

RunTest("getrawmetatable", function()
    local TestTable = {__metatable == "Locked!"}
    local TestObject = setmetatable({}, TestTable)
    assert(Global.getrawmetatable(TestObject) == TestTable, "Did not return the metatable")
    end)

    RunTest("setrawmetatable", function()
    assert(Environment.getrawmetatable, "getrawmetatable is required to test")

    local TestTable = {__metatable == "Locked!"}
    local TestObject = setmetatable({}, TestTable)

    Global.setrawmetatable(TestTable, {
        __index = function()
            return "Edited!"
        end
    })
    assert(TestTable.Example == "Edited!", "Failed to set the metatable")
end)

RunTest("isreadonly", function()
    local TestTable = {}
    local FrozenTable = table.freeze({})

    assert(Global.isreadonly(TestTable) == false, "Did not return false for a writeable table")
    assert(Global.isreadonly(FrozenTable) == true, "Did not return true for a readonly table")
    end)

    RunTest("setreadonly", function()
    assert(Environment.isreadonly, "isreadonly is required to test")

    local TestTable = {Value = 10}
    table.freeze(TestTable)
    Global.setreadonly(TestTable, false)

    TestTable.Value = 100
    assert(Global.isreadonly(TestTable) == false, "Failed to set readonly")
end)

-- [[Drawing ]]

RunTest("Drawing.new", function()
    assert(typeof(Global.Drawing.new) == "function", "Drawing.new is not a function")

    local NewShape = Global.Drawing.new("Circle")
    NewShape.Visible = false
    NewShape.Radius = 10
    NewShape.Thickness = 1
    NewShape.Filled = false
    NewShape.NumSides = 10

    NewShape:Remove()
end, "Drawing_New")

RunTest("Drawing.Fonts", function()
    assert(typeof(Global.Drawing.Fonts) == "table", "Drawing.Fonts is not a table")
end, "Drawing_Fonts")

--[[ File System ]]

RunTest("writefile", function()
    Global.writefile("Abysall_Test_File", "example")
    assert(Global.isfile("Abysall_Test_File") == true, "Failed to create a file")
    assert(Global.readfile("Abysall_Test_File") == "example", "File does not contain expected data")
end)

RunTest("isfile", function()
    assert(Global.isfile("Abysall_Test_File") == true, "Did not return true for a valid file")
end)

RunTest("readfile", function()
    assert(Global.readfile("Abysall_Test_File") == "example", "Did not return the expected data")
end)

RunTest("appendfile", function()
Global.appendfile("Abysall_Test_File", "_appended")
assert(Global.readfile("Abysall_Test_File") == "example_appended", "Failed to append content to a file")
end)

RunTest("loadfile", function()
    Global.writefile("Abysall_Test_Load", [[return 25]])
    assert(Global.loadfile("Abysall_Test_Load")() == 25, "Failed to load and execute a file")
end)

RunTest("delfile", function()
    Global.delfile("Abysall_Test_File")
    Global.delfile("Abysall_Test_Load")
    assert(Global.isfile("Abysall_Test_File") == false, "Failed to delete a file")
end)

RunTest("makefolder", function()
    Global.makefolder("Abysall_Test_Folder")
    assert(Global.isfolder("Abysall_Test_Folder") == true, "Failed to create a folder")
end)

RunTest("delfolder", function()
    Global.delfolder("Abysall_Test_Folder")
    assert(Global.isfolder("Abysall_Test_Folder") == false, "Failed to delete a folder")
end)

RunTest("listfiles", function()
    Global.makefolder("Abysall_ListFiles_Test")
    Global.writefile("Abysall_ListFiles_Test/Test1", "test 1")
    Global.writefile("Abysall_ListFiles_Test/Test2", "test 2")

    local FilesList = Global.listfiles("Abysall_ListFiles_Test")
    local Found1 = false
    local Found2 = false

    assert(#FilesList == 2, "Did not return the correct number of files")
    for Index, File in pairs(FilesList) do
        if Global.readfile(File) == "test 1" then
            Found1 = true
        end
        if Global.readfile(File) == "test 2" then
            Found2 = true
        end
    end
    assert(Found1 == true, "Did not return the first file")
    assert(Found2 == true, "Did not return the second file")
    Global.delfolder("Abysall_ListFiles_Test")
end)

RunTest("getcustomasset", function()
    assert(Environment.writefile, "writefile is required to test")

    local Content = game:HttpGet("https://httpbin.org/image/png")
    Global.writefile("Abysall_Test_Image", Content)
    local Asset = Global.getcustomasset("Abysall_Test_Image")

    local TestImage = Instance.new("ImageLabel", Services.CoreGui.RobloxGui)
    TestImage.Image = Asset

    local Tries = 0
    while not TestImage.IsLoaded and Tries < 10 do
        Tries = Tries + 1
        task.wait(0.1)
    end

    assert(string.find(Asset, "rbxasset://"), "Should return an rbxasset id")
    assert(TestImage.IsLoaded == true, "Failed to load a PNG image")
    Global.delfile("Abysall_Test_Image")
end)

--[[ Reflection ]]

RunTest("gethiddenproperty", function()
    local TestPart = Instance.new("Part")

    assert(Global.gethiddenproperty(TestPart, "NetworkIsSleeping") == false, "Did not return the correct property value")
end)

RunTest("sethiddenproperty", function()
    assert(Environment.gethiddenproperty, "gethiddenproperty is required to test")

    local TestPart = Instance.new("Part")
    Global.sethiddenproperty(TestPart, "NetworkIsSleeping", true)
    assert(Global.gethiddenproperty(TestPart, "NetworkIsSleeping") == true, "Failed to set a hidden property")
end)

RunTest("getthreadidentity", function()
    assert(typeof(Global.getthreadidentity()) == "number", "Did not return a number")
    assert(Global.getthreadidentity() > 0, "Returned an invalid identity")
    assert(Global.getthreadidentity() < 9, "Returned an invalid identity")
end)

RunTest("setthreadidentity", function()
    assert(Environment.getthreadidentity, "getthreadidentity is needed to test")

    local Old = Global.getthreadidentity()
    Global.setthreadidentity(2)
    assert(Services.CoreGui == nil, "Capabilities do not match set identity")
    Global.setthreadidentity(Old)
end)

RunTest("isnetworkowner", function()
    local Test = Instance.new("Part", Services.Workspace)
    local Test2 = Services.Players.LocalPlayer.Character.HumanoidRootPart
    local TestPart

    Test2.Anchored = true
    for Index, Part in pairs(Services.Workspace:GetDescendants()) do
        if Part:IsA("BasePart") and Part.Anchored then
            TestPart = Part
            break
        end
    end

    local IsOwned = Global.isnetworkowner(Test2)
    Test2.Anchored = false

    assert(TestPart ~= nil, "skipped, no part to test with")
    assert(Global.isnetworkowner(Test) == true, "Did not return true for a client owned part")
    assert(Global.isnetworkowner(TestPart) == false, "Did not return false for a non client owned part")
    Test:Destroy()
    assert(IsOwned == true, "Did not return true for a client owned anchored part")
end)

--[[ Signals ]]

RunTest("firesignal", function()
    local TestEvent = Instance.new("RemoteEvent")

    local Fired = false
    local Value1
    local Value2
    local Value3
    TestEvent.OnClientEvent:Connect(function(Arg1, Arg2, Arg3)
        Fired = true
        Value1 = Arg1
        Value2 = Arg2
        Value3 = Arg3
    end)

    Global.firesignal(TestEvent.OnClientEvent, "Example", 10, true)
    local Tries = 0
    while not Fired and Tries < 10 do
        Tries = Tries + 1
        task.wait(0.1)
    end

    assert(Fired == true, "Failed to fire a signal")
    assert(Value1 == "Example", "Fired signal with incorrect data")
    assert(Value2 == 10, "Fired signal with incorrect data")
    assert(Value3 == true, "Fired signal with incorrect data")
end)

RunTest("replicatesignal", function()
    local TestButton = Instance.new("Frame")

    Global.replicatesignal(TestButton.MouseWheelForward, 69, 420)

    local Success, Result = pcall(function()
    Global.replicatesignal(TestButton.MouseWheelForward)
    Global.replicatesignal(TestButton.MouseWheelForward, 69)
    end)

    -- replicatesignal doesn't trigger client signals so we can't properly test it
    assert(Success == false, "Did not throw an error with invalid arguments")
end)

RunTest("getconnections", function()
    local Fired = false

    game.ChildAdded:Connect(function(Child)
        if Child == "Example" then
            Fired = true
        end
    end)

    for Index, Connection in pairs(getconnections(game.ChildAdded)) do
        Connection:Fire("Example")
    end

    local Tries = 0
    while not Fired and Tries < 10 do
        Tries = Tries + 1
        task.wait(0.1)
    end

    assert(Fired == true, "Failed to fire a connection's signals")
end)

RunTest("require", function()
    local TestScript = Global.require(Services.Players.LocalPlayer.PlayerScripts.PlayerModule)

    assert(typeof(TestScript) == "table", "Did not return a table")
    assert(typeof(TestScript.GetControls == "function"), "Did not return the expected data")

    local Original = TestScript.GetControls
    TestScript.GetControls = function()
        return "test"
    end
    assert(TestScript.GetControls() == "test", "Unable to change module values")
    TestScript.GetControls = Original
end)

return Environment
