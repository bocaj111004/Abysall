local Support = {}

local function RunTest(Test)
	pcall(Test)
end

pcall(function()
	if not isfolder("Abysall") then
		makefolder("Abysall")
	end

	if not isfolder("Abysall/Tests") then
		makefolder("Abysall/Tests")
	end
end)

RunTest(function()
	local Tests = {}
	writefile("Abysall/Tests/TestFile.txt", "example data")
	local Data = readfile("Abysall/Tests/TestFile.txt")
	if typeof(Data) == "string" and Data == "example data" then
		Tests.readfile = true
		Tests.writefile = true
	end

	appendfile("Abysall/Tests/TestFile.txt", " 2")
	local Data = readfile("Abysall/Tests/TestFile.txt")
	if typeof(Data) == "string" and Data == "example data 2" then
		Tests.appendfile = true
	end

	local Result1 = isfile("Abysall/Tests/TestFile.txt")
	local Result2 = isfile("not_valid")

	if Result1 == true and Result2 == false then
		Tests.isfile = true
	end

	delfile("Abysall/Tests/TestFile.txt")
	if isfile("Abysall/Tests/TestFile.txt") == false then
		Tests.delfile = true
	end
	if Tests.readfile == true and Tests.writefile == true and Tests.appendfile == true and Tests.isfile == true and Tests.delfile == true then
		Support.file = true
	end
end)

RunTest(function()
	if typeof(crypt) == "table" and typeof(crypt.hash) == "function" and crypt.hash("example", "md5") == "1a79a4d60de6718e8e5b326e338ae533" then
		Support.hash = true
	end
end)

RunTest(function()
	if typeof(gethui()) == "Instance" and gethui() ~= game:GetService("CoreGui") then
		Support.gethui = true
	end
end)

RunTest(function()
	local TestFunction = function()
		return 10
	end

	local TestC = newcclosure(TestFunction)
	if debug.info(TestC, "s") == "[C]" and TestFunction ~= TestC and TestFunction() == TestC() then
		Support.newcclosure = true
	end
end)

RunTest(function()
	pcall(function()
		game:Example()
	end)

	local Method = getnamecallmethod()
	if typeof(Method) == "string" and Method == "Example" then
		Support.getnamecallmethod = true
	end
end)

RunTest(function()
	local Test = {Value = ""}
	local Original
	Original = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
		local Args = {...}
		local Method = getnamecallmethod()

		if Method == "Example" then
			Support.hookmetamethod = true
			hookmetamethod(game, "__namecall", Original)
		end
		return Original(self, table.unpack(Args))
	end))
	pcall(function()
		game:Example()
        game:Test()
	end)
end)

RunTest(function()
	local Object = workspace
	local Clone = cloneref(Object)

	if Object ~= Clone and Object.ClassName == "Workspace" and Clone.ClassName == "Workspace" then
		Support.cloneref = true
	end
end)

RunTest(function()
	local TestAsset = game:HttpGet("https://raw.githubusercontent.com/bocaj111004/Abysall/refs/heads/main/Assets/Loading.png")

	writefile("Abysall/Tests/ExampleAsset.png", TestAsset)

	local LoadedAsset = getcustomasset("Abysall/Tests/ExampleAsset.png")
	if typeof(LoadedAsset) == "string" and string.find(LoadedAsset, "rbxasset://") then
		Support.getcustomasset = true
	end
end)

pcall(function()
	delfolder("Abysall/Tests")
end)

return Support
