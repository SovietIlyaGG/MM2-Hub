-- MM2 PRO HUB | SovietIlya
-- Главный загрузчик с GitHub

local GitHubRaw = "https://raw.githubusercontent.com/SovietIlya/MM2-Hub/main/"

-- Функция загрузки файлов
local function loadFromGitHub(fileName)
    local success, result = pcall(function()
        return game:HttpGet(GitHubRaw .. fileName)
    end)
    
    if success then
        local loadSuccess, loadResult = pcall(function()
            return loadstring(result)()
        end)
        if loadSuccess then
            print("[SovietIlya Hub] Загружено: " .. fileName)
            return loadResult
        else
            warn("[SovietIlya Hub] Ошибка выполнения " .. fileName .. ": " .. tostring(loadResult))
        end
    else
        warn("[SovietIlya Hub] Ошибка загрузки " .. fileName .. ": " .. tostring(result))
    end
end

-- Загружаем GUI и Functions
print("[SovietIlya Hub] Загрузка интерфейса...")
local GUI = loadFromGitHub("GUI.lua")

print("[SovietIlya Hub] Загрузка функций...")
local Functions = loadFromGitHub("Functions.lua")

-- Инициализация после загрузки
if GUI and Functions then
    GUI.Initialize(Functions)
    print("[SovietIlya Hub] ✅ Всё загружено успешно!")
else
    warn("[SovietIlya Hub] ❌ Ошибка загрузки модулей!")
end
