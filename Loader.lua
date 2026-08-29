-- SovietIlyaGG Hub | Mobile Fixed
-- Без крашей для Delta

local GitHubRaw = "https://raw.githubusercontent.com/SovietIlyaGG/MM2-Hub/main/"

local function loadFile(fileName)
    local success, result = pcall(function()
        return game:HttpGet(GitHubRaw .. fileName)
    end)
    if success then
        local loadSuccess, module = pcall(function()
            return loadstring(result)()
        end)
        if loadSuccess then
            return module
        end
    end
    return nil
end

local GUI = loadFile("GUI.lua")
local Functions = loadFile("Functions.lua")

if GUI and Functions then
    GUI.Init(Functions, true)
end
