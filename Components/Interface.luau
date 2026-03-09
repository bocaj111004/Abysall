local BaseUrl = "https://raw.githubusercontent.com/mstudio45/Obsidian/refs/heads/main/"

return {
  Library = loadstring(game:HttpGet(BaseUrl .. "Library.lua"))(),
  SaveManager = loadstring(game:HttpGet(BaseUrl .. "addons/SaveManager.lua"))(),
  ThemeManager = loadstring(game:HttpGet(BaseUrl .. "addons/ThemeManager.lua"))()
}
