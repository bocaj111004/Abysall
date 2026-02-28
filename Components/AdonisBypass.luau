return function()
	local AdonisFunctions = {}
	for Index, Data in pairs(getgc(true)) do
		if typeof(Data) == "table" and rawget(Data, "Detected") or typeof(Data) == "table" and rawget(Data, "RLocked") then
			for Index, Function in pairs(Data) do
				if typeof(Function) == "function" then
					table.insert(AdonisFunctions, Function)
					hookfunction(Function, function(action, info, nocrash)
						return task.wait(9e9)
					end)
				end
			end
		end
	end
	local OldDebug
	OldDebug = hookfunction(debug.info, function(...)
		local Args = {...}
		if table.find(AdonisFunctions, Args[1]) then
			return task.wait(9e9)
		else
			return OldDebug(...)
		end
	end)
end
