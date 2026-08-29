-- Loader for SovietIlya MM2 Hub
-- Адаптирован для телефона и ПК

local GitHubRaw = "https://raw.githubusercontent.com/SovietIlyaGG/MM2-Hub/main/"

-- Определяем устройство
local UserInputService = game:GetService("UserInputService")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local function loadFile(fileName)
    local success, result = pcall(function()
        return game:HttpGet(GitHubRaw .. fileName)
    end)
    if success then
        local loadSuccess, module = pcall(function()
            return loadstring(result)()
        end)
        if loadSuccess then
            print("[SovietIlya Hub] ✅ " .. fileName .. " загружен")
            return module
        else
            warn("[SovietIlya Hub] ❌ Ошибка в " .. fileName .. ": " .. tostring(module))
        end
    else
        warn("[SovietIlya Hub] ❌ Не удалось загрузить " .. fileName)
    end
end

print("[SovietIlya Hub] Загрузка модулей...")
print("[SovietIlya Hub] Устройство: " .. (isMobile and "📱 Телефон" or "💻 ПК"))

local GUI = loadFile("GUI.lua")
local Functions = loadFile("Functions.lua")

if GUI and Functions then
    GUI.Init(Functions, isMobile)
    print("[SovietIlya Hub] ⭐ Всё готово!")
else
    warn("[SovietIlya Hub] Ошибка загрузки")
end
