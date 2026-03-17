local Environment = {}

local BrokenFeatures = {
    ["Seliware"] = {"run_on_actor"},
    ["Volcano"] = {"run_on_actor", "oth"},
    ["Solara"] = {"require"},
    ["Xeno"] = {"require"}
}

local Aliases = {
    ["hookfunction"] = {"replaceclosure", "hookfunc"},
    ["run_on_actor"] = {"runonactor"},
    ["sethiddenproperty"] = {"set_hidden_property", "sethiddenprop"},
    ["gethiddenproperty"] = {"get_hidden_property", "gethiddenprop"},
    ["isexecutorclosure"] = {"isourclosure", "checkclosure"},
    ["request"] = {"httprequest", "http_request"},
    ["gethui"] = {"get_hidden_gui"},
    ["isnetworkowner"] = {"isnetowner"},
    ["firetouchinterest"] = {"firetouchtransmitter"},
    ["crypt.base64encode"] = {"crypt.base64_encode", "base64encode", "base64_encode"},
    ["crypt.base64decode"] = {"crypt.base64_decode", "base64decode", "base64_decode"}
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
        if not RawGlobal and Aliases[Name] then
            for Index, Alias in pairs(Aliases[Name]) do
                local NewGlobal = GetGlobal(Alias)
                if NewGlobal then
                    return NewGlobal
                end
            end
        end
        return RawGlobal
    end
})

local Services = setmetatable({}, {
    __index = function(self, Name)
        return game:GetService(Name)
    end
})

local Results = {}

local function AddResult(Text)
    table.insert(Results, Text)
end

local function PrintResults()
    for Index, Result in pairs(Results) do
        print(Result)
        task.wait()
    end
end

local function RunTest(Name, Test, InternalName)
local ExecutorName = Global.identifyexecutor and Global.identifyexecutor()[1] or "Unknown"
if BrokenFeatures[ExecutorName] and table.find(BrokenFeatures[ExecutorName], Name) then
    AddResult("❌ " .. Name .. " failed: test has been skipped")
    return
end

local NewGlobal = Global[Name]
if not NewGlobal then
    AddResult("❌ " .. Name)
    return
end

local Time = 0
local Finished = false
task.spawn(function()
local Success, Result = pcall(Test, NewGlobal)
if Success then
    if InternalName then
        Environment[InternalName] = NewGlobal
    else
        Environment[Name] = NewGlobal
    end
    AddResult("✅ " .. Name)
else
    AddResult("❌ " .. Name .. " failed: " .. Result)
end
Finished = true
end)

while not Finished do
    Time = Time + 1
    if Time > 500 then
       AddResult("❌ " .. Name .. " failed: test timed out")
    break
    end
    task.wait()
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

local FoundTable = false
local FoundFunction = false
for Index, Value in pairs(YesTables) do
    if Value == TestTable then
        FoundTable = true
    end
    if Value == TestFunction then
        FoundFunction = true
    end
end

assert(FoundTable == true, "Failed to find a table")
assert(FoundFunction == true, "Failed to find a function")

local FoundTable = false
local FoundFunction = false
for Index, Value in pairs(NoTables) do
    if Value == TestTable then
        FoundTable = true
    end
    if Value == TestFunction then
        FoundFunction = true
    end
end

assert(FoundTable == false, "Found a table when called with false")
assert(FoundFunction == true, "Failed to find a function")
end)

RunTest("filtergc", function()
local Dummy_Table = {
    ["Dummy_Value"] = 10
}
local function Dummy_Function() end

local Retrieved = Global.filtergc("function", {
    Name = "Dummy_Function", 
    IgnoreExecutor = false
})

local Retrieved2 = Global.filtergc("table", {
    Keys = {"Dummy_Value"}, 
    Values = {10}
})

assert(table.find(Retrieved, Dummy_Function), "failed to find a function")
assert(table.find(Retrieved2, Dummy_Table), "failed to find a table")
end)

--[[ Miscellaneous ]]

RunTest("identifyexecutor", function()
assert(typeof(Global.identifyexecutor()) == "string", "Did not return a string")
end)

RunTest("setfpscap", function()
local Start = tick()
Global.setfpscap(6)
task.wait(0.1)
Global.setfpscap(240)

local Finish = tick() - Start
assert(Finish > 0.12, "Failed to set fps cap")
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
local InstanceList = Global.getinstances()
local Found = false
local NilFound = false

for Index, Object in pairs(InstanceList) do
    if typeof(Object) == "Instance" then
        Found = true
        if Object.Parent == nil then
            NilFound = true
        end
    end
end

assert(Found == true, "Did not return any instances")
assert(NilFound == true, "Did not return any nil instances")
end)

RunTest("getnilinstances", function()
local InstanceList = Global.getnilinstances()
local Found = false
local NilFound = false


for Index, Object in pairs(InstanceList) do
    if typeof(Object) == "Instance" then
        if Object.Parent == nil then
            NilFound = true
        else
            Found = true
        end
    end
end

assert(Found == false, "Returned an instance not parented to nil")
assert(NilFound == true, "Did not return any nil instances")
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
while not Fired and Tries < 350 do
    Tries = Tries + 1
    task.wait()
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
while not Fired and tries < 350 do
    Tries = Tries + 1
    task.wait()
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
while not Fired and tries < 350 do
    Tries = Tries + 1
    task.wait()
end

assert(Fired == true, "Failed to fire a touch interest")
TestPart1:Destroy()
TestPart2:Destroy()
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

--[[ oth ]]

RunTest("oth.hook", function()
local Old = Global.oth.hook(version, function()
return "hooked!"
end)

assert(version() == "hooked!", "failed to hook a function")
end, "oth_hook")

RunTest("oth.unhook", function()
assert(Environment.oth_hook, "oth.hook is required to test") -- not actually required, just prevents it from passing if oth.hook fails
Global.oth.unhook(version)

assert(version() ~= "hooked!", "failed to unhook a function")
end, "oth_unhook")

RunTest("oth.is_hook_thread", function()
assert(Environment.oth_hook, "oth.hook is required to test")
assert(Environment.oth_unhook, "oth.unhook is required to test")

local Hooked = false
Global.oth.hook(version, function()
Hooked = Global.oth.is_hook_thread()
end)

version()
Global.oth.unhook(version)
assert(Hooked == true, "Did not return true for a hooked thread")
assert(Global.oth.is_hook_thread() == false, "Did not return false for a normal thread")
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
        return true
    end)
})

local Original
Original = Global.hookmetamethod(TestTable, "__index", Global.newcclosure(function()
return false
end))

assert(TestTable.Example == false, "Failed to hook a metamethod")
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

RunTest("dofile", function()
assert(Global.dofile("Abysall_Test_Load") == 25, "Failed to execute a file")
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
Global.makefolder("Abysall_ListFiles_Test/Test2")

local FilesList = Global.listfiles("Abysall_ListFiles_Test")
local Found1 = false
local Found2 = false

assert(#FilesList == 2, "Did not return the correct number of files")
for Index, File in pairs(FilesList) do
if Global.isfile(File) then
    Found1 = true
end
if Global.isfolder(File) then
    Found2 = true
end
end
assert(Found1 == true, "Did not return a file")
assert(Found2 == true, "Did not return a folder")
Global.delfolder("Abysall_ListFiles_Test")
end)

RunTest("getcustomasset", function()
assert(Environment.writefile, "writefile is required to test")

local Content = game:HttpGet("https://httpbin.org/image/png")
Global.writefile("Abysall_Test_Image", Content)
local Asset = Global.getcustomasset("Abysall_Test_Image")

local TestImage = Instance.new("ImageLabel", Services.CoreGui.RobloxGui)
TestImage.Image = Asset

task.wait(0.1)

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
assert(Services.CoreGui == nil, "Failed to set thread identity")
Global.setthreadidentity(Old)
end)

RunTest("isnetworkowner", function()
local Test = Instance.new("Part", Services.Workspace)
local TestPart
for Index, Part in pairs(game:GetDescendants()) do
    if Part:IsA("BasePart") then
        TestPart = Part
        break
    end
end
assert(TestPart ~= nil, "skipped, no part to test with")

assert(Global.isnetworkowner(Test) == true, "Did not return true for a client owned part")
assert(Global.isnetworkowner(TestPart) == false, "Did not return false for a non client owned part")
Test:Destroy()
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
while not Fired and tries < 350 do
    Tries = Tries + 1
    task.wait()
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
while not Fired and tries < 350 do
    Tries = Tries + 1
    task.wait()
end

assert(Fired == true, "Failed to fire a connection's signals")
end)

--[[ Crypt ]]

RunTest("crypt.base64encode", function()
local Encoded = Global.crypt.base64encode("Example")

assert(typeof(Encoded) == "string", "Did not return a string")
assert(Encoded == "RXhhbXBsZQ==", "Did not return the expected data")
end, "crypt_base64encode")

RunTest("crypt.base64decode", function()
local Decoded = Global.crypt.base64decode("RXhhbXBsZQ==")

assert(typeof(Decoded) == "string", "Did not return a string")
assert(Decoded == "Example", "Did not return the expected data")
end, "crypt_base64decode")

RunTest("crypt.generatekey", function()
assert(Environment.crypt_base64decode, "crypt.base64decode is required to test")

local Key = Global.crypt.generatekey()
assert(typeof(Key) == "string", "Did not return a string")
assert(Key ~= Global.crypt.generatekey(), "Returns the same key from multiple calls")
assert(#Environment.crypt_base64decode(Key) == 32, "String is not the correct length after decoding")
end, "crypt_generatekey")

RunTest("crypt.generatebytes", function()
assert(Environment.crypt_base64decode, "crypt.base64decode is required to test")

local Test = math.random(10, 100)
local Bytes = Global.crypt.generatebytes(Test)

assert(typeof(Bytes) == "string", "Did not return a string")
assert(#Environment.crypt_base64decode(Bytes) == Test, "String is not the correct length after decoding")
end)

RunTest("crypt.encrypt", function()
assert(Environment.crypt_generatekey, "crypt.generatekey is required to test")

local Key = Environment.crypt_generatekey()
local Encoded, Iv = Global.crypt.encrypt("Example", Key, nil, "CBC")

assert(typeof(Encoded) == "string", "Did not return a string")
assert(typeof(Iv) == "string", "Did not return an Iv")
end, "crypt_encrypt")

RunTest("crypt.decrypt", function()
assert(Environment.crypt_generatekey, "crypt.generatekey is required to test")
assert(Environment.crypt_encrypt, "crypt.encrypt is required to test")

local Key = Environment.crypt_generatekey()
local Encoded, Iv = Environment.crypt_encrypt("Example", Key, nil, "CBC")
local Decoded = Global.crypt.decrypt(Encoded, Key, Iv, "CBC")

assert(typeof(Decoded) == "string", "Did not return a string")
assert(Decoded == "Example", "Did not return the correct data")
end, "crypt_decrypt")

RunTest("crypt.hash", function()
local ReferenceData = {
["sha1"] = "0f01ed56a1e32a05e5ef96e4d779f34784af9a96",
["sha384"] = "fe27713a5276adef1d34169ed04c52b299bb792bef7c903127893a53c07d910d5fcaae18de99164882a200192b236b14",
["sha512"] = "c6b0919c7fe628ae9056992c4a917e5dc035a9615d497f6eb2bd14063eaad3e6508efc8682fec82823ca3f3de311868a72990946166429f01b38f9f33d9ca610",
["md5"] = "0a52730597fb4ffa01fc117d9e71e3a9",
["sha256"] = "d029f87e3d80f8fd9b1be67c7426b4cc1ff47b4a9d0a8461c826a59d8c5eb6cd",
["sha3-224"] = "45be9eeb144a4067b74f04e5b8f73c26379ff8325fdd2858bb749dfe",
["sha3-256"] = "358d8db68dd7622887b41a01aae8f81cc1bfb7a250c3b11be01fc12831a56837",
["sha3-512"] = "34359a3440cc82648f0175629220c939b1b5d532d22e48aa3e44629281bf1b504cfc40bebd77ee58c51d52b0f0c8795147c293331169b8e45e5fd02300d29340",
}

local Correct = 0
for Index, Hash in pairs(ReferenceData) do
    assert(Global.crypt.hash("Example", Index) == Hash, "Returned incorrect data for algorithm: " .. Index)
end
end, "crypt_hash")

RunTest("crypt.hmac", function()
local Algorithms = {
    "sha1",
    "sha384",
    "sha512",
    "md5",
    "sha256",
    "sha3-224",
    "sha3-256",
    "sha3-512"
    }

for Index, Algorithm in pairs(Algorithms) do
    assert(typeof(crypt.hmac("Example", "TestKey", Algorithm)) == "string", "Did not return a string")
end
end)

--[[ Scripts ]]

RunTest("getscriptbytecode", function()
local TestScript = Services.Players.LocalPlayer.PlayerScripts.PlayerScriptsLoader
local ReferenceData = [[\6\3\5\7require\6script\6Parent\12PlayerModule\12WaitForChild\0\1\4\0\0\1\2\0\13\163\0\0\0\164\0\1\0\0\0\0\64\164\1\3\0\0\0\32\64M\1\1$\4\0\0\0o\3\5\0\188\1\1\211\6\0\0\0\159\1\3\0\159\0\0\1\130\0\1\0\7\3\1\4\0\0\0\64\3\2\4\0\0\32\64\3\3\3\4\3\5\0\1\0\1\24\0\6\0\0\0\0\0\0\0\0\0\0\1\1\0\0\0\0\0]]
local Bytecode = Global.getscriptbytecode(TestScript)

assert(typeof(Bytecode) == "string", "Did not return a string")
assert(Bytecode ~= ReferenceData, "Did not return the expected data")
end)

RunTest("decompile", function()
local TestScript = Services.Players.LocalPlayer.PlayerScripts.PlayerModule
local Output = Global.decompile(TestScript)

assert(typeof(Output) == "string", "Did not return a string")
local Constants = {
    "GetCameras",
    "GetControls",
    "GetClickToMoveController"
}

local Found = 0
for Index, Constant in pairs(Constants) do
if string.find(Output, Constant) then
    Found = Found + 1
end
end

assert(Found == 3, "Decompiled output did not contain expected constants")
assert(typeof(loadstring(Output)) == "function", "Did not return valid luau code")
end)

RunTest("getscriptclosure", function()
local TestScript = Services.Players.LocalPlayer.PlayerScripts.PlayerModule
local Generated = Global.getscriptclosure(TestScript)()

assert(Generated ~= require(TestScript), "Generated module should not be equal to original")
assert(Generated.GetControls, "Did not return the expected data")
end)

RunTest("getscripthash", function()
local TestScript = Services.Players.LocalPlayer.Character.Animate:Clone()
local Generated = Global.getscripthash(TestScript)

assert(typeof(Generated) == "string", "Did not return a string")
assert(Generated == Global.getscripthash(TestScript), "Returned different hashes for the same script")
TestScript.Source = [[return 10]]
assert(Generated ~= Global.getscripthash(TestScript), "Did not return a different hash for different source")
assert(Global.getscripthash(Instance.new("LocalScript")) == nil, "Returned a hash for a script with empty bytecode")
end)

RunTest("getrunningscripts", function()
local TestScriptRunning = Services.Players.LocalPlayer.PlayerScripts.PlayerModule.ControlModule
local TestScriptInactive = Services.Players.LocalPlayer.PlayerScripts.PlayerScriptsLoader

local ActiveFound = false
local InactiveFound = false

local List = Global.getrunningscripts()
for Index, Script in pairs(List) do
    if Script == TestScriptRunning then
        ActiveFound = true
    end
    if Script == TestScriptInactive then
        InactiveFound = true
    end
end

assert(ActiveFound == true, "Did not return a running script")
assert(InactiveFound == false, "Returned a non-running script")
end)

RunTest("getloadedmodules", function()
local TestScriptRunning = Services.Players.LocalPlayer.PlayerScripts.PlayerModule.ControlModule
local TestScriptInactive = Instance.new("ModuleScript", Services.Players.LocalPlayer.PlayerScripts)

local ActiveFound = false
local InactiveFound = false

local List = Global.getloadedmodules()
for Index, Script in pairs(List) do
    if Script == TestScriptRunning then
        ActiveFound = true
    end
    if Script == TestScriptInactive then
        InactiveFound = true
    end
end

assert(ActiveFound == true, "Did not return a loadded module")
assert(InactiveFound == false, "Returned an unloaded module")
TestScriptInactive:Destroy()
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

RunTest("getsenv", function()
local TestScript = Services.Players.LocalPlayer.Character.Animate
local Env = Global.getsenv(TestScript)

assert(typeof(Env) == "table", "Did not return a table")

local Success, Result = pcall(function()
    Env.error("Example", 0)
end)
assert(Result == "Example", "Did not return the script environment")
end)

return Environment
