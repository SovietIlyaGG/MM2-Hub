-- GUI Module for SovietIlya Hub
return (function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    
    local GUI = {}
    local ScreenGui
    local MainFrame
    local StarIcon
    local IsOpen = false
    local Functions
    
    -- Создание компонентов
    local function createCheckbox(parent, text, callback, default, y)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -10, 0, 28)
        container.Position = UDim2.new(0, 5, 0, y)
        container.BackgroundTransparency = 1
        container.Parent = parent
        
        local box = Instance.new("Frame")
        box.Size = UDim2.new(0, 18, 0, 18)
        box.Position = UDim2.new(0, 0, 0, 5)
        box.BackgroundColor3 = default and Color3.fromRGB(140, 0, 0) or Color3.fromRGB(50, 50, 50)
        box.BorderSizePixel = 0
        box.Parent = container
        
        local check = Instance.new("TextLabel")
        check.Size = UDim2.new(1, 0, 1, 0)
        check.BackgroundTransparency = 1
        check.Text = "✓"
        check.TextColor3 = Color3.fromRGB(255, 255, 255)
        check.Font = Enum.Font.GothamBold
        check.TextSize = 13
        check.Visible = default or false
        check.Parent = box
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -25, 1, 0)
        label.Position = UDim2.new(0, 25, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        local enabled = default or false
        container.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                enabled = not enabled
                TweenService:Create(box, TweenInfo.new(0.2), {
                    BackgroundColor3 = enabled and Color3.fromRGB(140, 0, 0) or Color3.fromRGB(50, 50, 50)
                }):Play()
                check.Visible = enabled
                if callback then callback(enabled) end
            end
        end)
        
        return {Set = function(v) enabled = v; box.BackgroundColor3 = v and Color3.fromRGB(140,0,0) or Color3.fromRGB(50,50,50); check.Visible = v end}
    end
    
    local function createSlider(parent, text, min, max, default, callback, y)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -10, 0, 42)
        container.Position = UDim2.new(0, 5, 0, y)
        container.BackgroundTransparency = 1
        container.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 18)
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. default
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, 0, 0, 5)
        sliderBg.Position = UDim2.new(0, 0, 0, 22)
        sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        sliderBg.BorderSizePixel = 0
        sliderBg.Parent = container
        
        local sliderFill = Instance.new("Frame")
        local percent = (default - min) / (max - min)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(140, 0, 0)
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBg
        
        local value = default
        local function setValue(newVal)
            value = math.clamp(newVal, min, max)
            local p = (value - min) / (max - min)
            TweenService:Create(sliderFill, TweenInfo.new(0.1), {Size = UDim2.new(p, 0, 1, 0)}):Play()
            label.Text = text .. ": " .. math.floor(value)
            if callback then callback(value) end
        end
        
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local function update(pos)
                    local relPos = (pos.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
                    setValue(min + relPos * (max - min))
                end
                update(input.Position)
                
                local conn
                conn = UserInputService.InputChanged:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseMovement then
                        update(inp.Position)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        conn:Disconnect()
                    end
                end)
            end
        end)
        
        return {Set = setValue}
    end
    
    local function createButton(parent, text, callback, y)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 28)
        btn.Position = UDim2.new(0, 5, 0, y)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 12
        btn.Parent = parent
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(140, 0, 0)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
        end)
        btn.MouseButton1Click:Connect(callback)
        
        return btn
    end
    
    -- Создание звезды
    local function createStarIcon()
        StarIcon = Instance.new("ImageButton")
        StarIcon.Size = UDim2.new(0, 55, 0, 55)
        StarIcon.Position = UDim2.new(0.85, 0, 0.5, 0)
        StarIcon.BackgroundTransparency = 1
        StarIcon.Image = "rbxassetid://9648657963"
        StarIcon.ImageColor3 = Color3.fromRGB(255, 30, 30)
        StarIcon.ZIndex = 100
        StarIcon.Parent = ScreenGui
        
        local glow = Instance.new("ImageLabel")
        glow.Size = UDim2.new(1, 16, 1, 16)
        glow.Position = UDim2.new(0, -8, 0, -8)
        glow.BackgroundTransparency = 1
        glow.Image = "rbxassetid://9648657963"
        glow.ImageColor3 = Color3.fromRGB(255, 0, 0)
        glow.ImageTransparency = 0.6
        glow.ZIndex = 99
        glow.Parent = StarIcon
        
        spawn(function()
            while task.wait(0.05) do
                local t = tick()
                glow.ImageTransparency = 0.4 + math.sin(t * 3) * 0.2
                glow.Size = UDim2.new(1, 16 + math.sin(t * 3) * 6, 1, 16 + math.sin(t * 3) * 6)
            end
        end)
        
        -- Drag
        local dragging, startPos, dragStart
        StarIcon.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                startPos = StarIcon.Position
                dragStart = input.Position
            end
        end)
        StarIcon.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                StarIcon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end
    
    -- Создание главного меню
    local function createMainMenu()
        MainFrame = Instance.new("Frame")
        MainFrame.Size = UDim2.new(0, 520, 0, 380)
        MainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
        MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        MainFrame.BorderSizePixel = 0
        MainFrame.Visible = false
        MainFrame.ZIndex = 200
        MainFrame.Parent = ScreenGui
        
        -- Border
        local border = Instance.new("Frame")
        border.Size = UDim2.new(1, 4, 1, 4)
        border.Position = UDim2.new(0, -2, 0, -2)
        border.BackgroundColor3 = Color3.fromRGB(140, 0, 0)
        border.BorderSizePixel = 0
        border.Parent = MainFrame
        
        -- Title Bar
        local titleBar = Instance.new("Frame")
        titleBar.Size = UDim2.new(1, 0, 0, 40)
        titleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        titleBar.BorderSizePixel = 0
        titleBar.Parent = MainFrame
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -70, 1, 0)
        title.Position = UDim2.new(0, 15, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "⭐ SOVIET ILYA | MM2 PRO"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = titleBar
        
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 28, 0, 28)
        closeBtn.Position = UDim2.new(1, -33, 0, 6)
        closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
        closeBtn.BorderSizePixel = 0
        closeBtn.Text = "✕"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 14
        closeBtn.Parent = titleBar
        closeBtn.MouseButton1Click:Connect(function() ToggleMenu() end)
        
        -- Drag
        local dragging, startPos, dragStart
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                startPos = MainFrame.Position
                dragStart = input.Position
            end
        end)
        titleBar.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        -- Left Panel
        local leftPanel = Instance.new("Frame")
        leftPanel.Size = UDim2.new(0, 110, 1, -40)
        leftPanel.Position = UDim2.new(0, 0, 0, 40)
        leftPanel.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        leftPanel.BorderSizePixel = 0
        leftPanel.Parent = MainFrame
        
        -- Tabs
        local tabs = {"👤 Игрок", "👁 Визуал", "🔫 Оружие", "🎮 Фан", "⚙ Настройки"}
        local selectedTab = 1
        local contentFrames = {}
        local tabButtons = {}
        
        for i, tabName in ipairs(tabs) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Position = UDim2.new(0, 0, 0, (i-1)*31 + 5)
            btn.BackgroundColor3 = i == 1 and Color3.fromRGB(140, 0, 0) or Color3.fromRGB(30, 30, 35)
            btn.BorderSizePixel = 0
            btn.Text = tabName
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 11
            btn.AutoButtonColor = false
            btn.Parent = leftPanel
            
            btn.MouseButton1Click:Connect(function()
                selectedTab = i
                for j, b in ipairs(tabButtons) do
                    b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                end
                btn.BackgroundColor3 = Color3.fromRGB(140, 0, 0)
                for j, cf in ipairs(contentFrames) do
                    cf.Visible = (j == i)
                end
            end)
            
            table.insert(tabButtons, btn)
            
            -- Content
            local content = Instance.new("ScrollingFrame")
            content.Size = UDim2.new(1, -115, 1, -40)
            content.Position = UDim2.new(0, 113, 0, 40)
            content.BackgroundTransparency = 1
            content.BorderSizePixel = 0
            content.ScrollBarThickness = 3
            content.ScrollBarImageColor3 = Color3.fromRGB(140, 0, 0)
            content.CanvasSize = UDim2.new(0, 0, 0, 800)
            content.Visible = (i == 1)
            content.Parent = MainFrame
            
            table.insert(contentFrames, content)
        end
        
        return contentFrames
    end
    
    -- Переключение меню
    function ToggleMenu()
        IsOpen = not IsOpen
        MainFrame.Visible = IsOpen
    end
    
    -- Инициализация
    function GUI.Initialize(funcs)
        Functions = funcs
        
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "SovietIlyaHub"
        ScreenGui.Parent = CoreGui
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        createStarIcon()
        local contents = createMainMenu()
        
        -- Подключаем функции к кнопкам
        local y1, y2, y3, y4, y5 = 10, 10, 10, 10, 10
        
        -- Вкладка Игрок
        createCheckbox(contents[1], "Fly", function(v) Functions.ToggleFly(v) end, false, y1); y1 += 32
        createSlider(contents[1], "Скорость Fly", 10, 100, 20, function(v) Functions.SetFlySpeed(v) end, y1); y1 += 46
        createCheckbox(contents[1], "NoClip", function(v) Functions.ToggleNoClip(v) end, false, y1); y1 += 32
        createCheckbox(contents[1], "God Mode", function(v) Functions.ToggleGodMode(v) end, false, y1); y1 += 32
        createCheckbox(contents[1], "Невидимость", function(v) Functions.ToggleInvisible(v) end, false, y1); y1 += 32
        createSlider(contents[1], "Скорость", 16, 200, 16, function(v) Functions.SetSpeed(v) end, y1); y1 += 46
        createSlider(contents[1], "Прыжок", 50, 300, 50, function(v) Functions.SetJumpPower(v) end, y1); y1 += 46
        createCheckbox(contents[1], "Авто-Бот", function(v) Functions.ToggleBot(v) end, false, y1); y1 += 32
        
        -- Вкладка Визуал
        createCheckbox(contents[2], "ESP", function(v) Functions.ToggleESP(v) end, false, y2); y2 += 32
        createCheckbox(contents[2], "ESP Боксы", function(v) Functions.ToggleESPBoxes(v) end, false, y2); y2 += 32
        createCheckbox(contents[2], "ESP Имена", function(v) Functions.ToggleESPNames(v) end, false, y2); y2 += 32
        createCheckbox(contents[2], "ESP Дистанция", function(v) Functions.ToggleESPDistance(v) end, false, y2); y2 += 32
        createCheckbox(contents[2], "ESP Трейсеры", function(v) Functions.ToggleESPTracers(v) end, false, y2); y2 += 32
        createCheckbox(contents[2], "Full Bright", function(v) Functions.ToggleFullBright(v) end, false, y2); y2 += 32
        createCheckbox(contents[2], "No Fog", function(v) Functions.ToggleNoFog(v) end, false, y2); y2 += 32
        createCheckbox(contents[2], "Chams", function(v) Functions.ToggleChams(v) end, false, y2); y2 += 32
        createCheckbox(contents[2], "Crosshair", function(v) Functions.ToggleCrosshair(v) end, false, y2); y2 += 32
        
        -- Вкладка Оружие
        createCheckbox(contents[3], "Aimbot", function(v) Functions.ToggleAimbot(v) end, false, y3); y3 += 32
        createCheckbox(contents[3], "Auto Shoot", function(v) Functions.ToggleAutoShoot(v) end, false, y3); y3 += 32
        createCheckbox(contents[3], "Silent Aim", function(v) Functions.ToggleSilentAim(v) end, false, y3); y3 += 32
        createCheckbox(contents[3], "Trigger Bot", function(v) Functions.ToggleTriggerBot(v) end, false, y3); y3 += 32
        createSlider(contents[3], "FOV Aimbot", 50, 500, 150, function(v) Functions.SetAimbotFOV(v) end, y3); y3 += 46
        createSlider(contents[3], "Сглаживание", 1, 10, 2, function(v) Functions.SetAimbotSmooth(v) end, y3); y3 += 46
        createCheckbox(contents[3], "No Recoil", function(v) Functions.ToggleNoRecoil(v) end, false, y3); y3 += 32
        createCheckbox(contents[3], "No Spread", function(v) Functions.ToggleNoSpread(v) end, false, y3); y3 += 32
        createCheckbox(contents[3], "Rapid Fire", function(v) Functions.ToggleRapidFire(v) end, false, y3); y3 += 32
        
        -- Вкладка Фан
        createButton(contents[4], "🎵 Spawn Music", function() Functions.SpawnMusic() end, y4); y4 += 32
        createButton(contents[4], "💥 Взрыв всех", function() Functions.ExplodeAll() end, y4); y4 += 32
        createButton(contents[4], "🌀 Спин бот", function() Functions.ToggleSpinBot() end, y4); y4 += 32
        createButton(contents[4], "👻 Призрак", function() Functions.ToggleGhost() end, y4); y4 += 32
        createButton(contents[4], "🌈 Rainbow Body", function() Functions.ToggleRainbowBody() end, y4); y4 += 32
        createButton(contents[4], "📦 Spam Boxes", function() Functions.SpamBoxes() end, y4); y4 += 32
        createButton(contents[4], "💀 Fake Crash", function() Functions.FakeCrash() end, y4); y4 += 32
        
        -- Вкладка Настройки
        createButton(contents[5], "💾 Сохранить настройки", function() Functions.SaveSettings() end, y5); y5 += 32
        createButton(contents[5], "📂 Загрузить настройки", function() Functions.LoadSettings() end, y5); y5 += 32
        createButton(contents[5], "🔄 Перезагрузить скрипт", function() Functions.ReloadScript() end, y5); y5 += 32
        createButton(contents[5], "🌐 Открыть GitHub", function() Functions.OpenGitHub() end, y5); y5 += 32
        
        -- Открытие по клику на звезду
        StarIcon.MouseButton1Click:Connect(function()
            if not IsOpen then ToggleMenu() end
        end)
        
        -- Открытие по клавише
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.RightShift then
                ToggleMenu()
            end
        end)
        
        print("[GUI] Интерфейс загружен!")
    end
    
    return GUI
end)
