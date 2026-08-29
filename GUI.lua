-- GUI Module for SovietIlya MM2 Hub
-- GitHub: SovietIlyaGG
-- Часть 1: Интерфейс

return {
    Init = function(Functions, isMobile)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local CoreGui = game:GetService("CoreGui")
        local TweenService = game:GetService("TweenService")
        local UserInputService = game:GetService("UserInputService")
        
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "SovietIlyaGG_Hub"
        ScreenGui.Parent = CoreGui
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        -- Звезда
        local StarIcon = Instance.new("ImageButton")
        StarIcon.Size = isMobile and UDim2.new(0, 50, 0, 50) or UDim2.new(0, 55, 0, 55)
        StarIcon.Position = isMobile and UDim2.new(0.75, 0, 0.5, 0) or UDim2.new(0.85, 0, 0.5, 0)
        StarIcon.BackgroundTransparency = 1
        StarIcon.Image = "rbxassetid://9648657963"
        StarIcon.ImageColor3 = Color3.fromRGB(255, 30, 30)
        StarIcon.ZIndex = 100
        StarIcon.Parent = ScreenGui
        
        local Glow = Instance.new("ImageLabel")
        Glow.Size = UDim2.new(1, 20, 1, 20)
        Glow.Position = UDim2.new(0, -10, 0, -10)
        Glow.BackgroundTransparency = 1
        Glow.Image = "rbxassetid://9648657963"
        Glow.ImageColor3 = Color3.fromRGB(255, 0, 0)
        Glow.ImageTransparency = 0.6
        Glow.ZIndex = 99
        Glow.Parent = StarIcon
        
        spawn(function()
            while task.wait(0.05) do
                local t = tick()
                Glow.ImageTransparency = 0.4 + math.sin(t * 3) * 0.2
                Glow.Size = UDim2.new(1, 20 + math.sin(t * 3) * 8, 1, 20 + math.sin(t * 3) * 8)
            end
        end)
        
        -- Drag звезды
        local draggingStar, starStartPos, starDragStart
        StarIcon.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingStar = true
                starStartPos = StarIcon.Position
                starDragStart = input.Position
            end
        end)
        StarIcon.InputChanged:Connect(function(input)
            if draggingStar and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - starDragStart
                StarIcon.Position = UDim2.new(starStartPos.X.Scale, starStartPos.X.Offset + delta.X, starStartPos.Y.Scale, starStartPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingStar = false
            end
        end)
        
        -- Меню
        local menuWidth = isMobile and 300 or 540
        local menuHeight = isMobile and 420 or 390
        
        local IsOpen = false
        local Main = Instance.new("Frame")
        Main.Size = UDim2.new(0, menuWidth, 0, menuHeight)
        Main.Position = UDim2.new(0.5, -menuWidth/2, 0.5, -menuHeight/2)
        Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        Main.BorderSizePixel = 0
        Main.Visible = false
        Main.ZIndex = 200
        Main.Parent = ScreenGui
        
        local Border = Instance.new("Frame")
        Border.Size = UDim2.new(1, 4, 1, 4)
        Border.Position = UDim2.new(0, -2, 0, -2)
        Border.BackgroundColor3 = Color3.fromRGB(140, 0, 0)
        Border.BorderSizePixel = 0
        Border.Parent = Main
        
        local Gradient = Instance.new("UIGradient")
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 0, 180)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 255))
        })
        Gradient.Rotation = 45
        Gradient.Parent = Border
        
        local Inner = Instance.new("Frame")
        Inner.Size = UDim2.new(1, -4, 1, -4)
        Inner.Position = UDim2.new(0, 2, 0, 2)
        Inner.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        Inner.BorderSizePixel = 0
        Inner.Parent = Main
        
        local titleBarHeight = isMobile and 35 or 40
        local TitleBar = Instance.new("Frame")
        TitleBar.Size = UDim2.new(1, 0, 0, titleBarHeight)
        TitleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        TitleBar.BorderSizePixel = 0
        TitleBar.Parent = Inner
        
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -70, 1, 0)
        Title.Position = UDim2.new(0, 15, 0, 0)
        Title.BackgroundTransparency = 1
        Title.Text = "⭐ SOVIET ILYA | MM2 PRO"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Font = Enum.Font.GothamBlack
        Title.TextSize = isMobile and 11 or 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = TitleBar
        
        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0, isMobile and 26 or 28, 0, isMobile and 26 or 28)
        CloseBtn.Position = UDim2.new(1, isMobile and -30 or -33, 0, isMobile and 5 or 6)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
        CloseBtn.BorderSizePixel = 0
        CloseBtn.Text = "✕"
        CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseBtn.Font = Enum.Font.GothamBold
        CloseBtn.TextSize = isMobile and 12 or 14
        CloseBtn.AutoButtonColor = false
        CloseBtn.Parent = TitleBar
        
        -- Drag меню
        local dragging, dragStartPos, dragStartInput
        TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStartPos = Main.Position
                dragStartInput = input.Position
            end
        end)
        TitleBar.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStartInput
                Main.Position = UDim2.new(dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X, dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        -- Левая панель
        local leftPanelWidth = isMobile and 90 or 110
        local LeftPanel = Instance.new("Frame")
        LeftPanel.Size = UDim2.new(0, leftPanelWidth, 1, -titleBarHeight)
        LeftPanel.Position = UDim2.new(0, 0, 0, titleBarHeight)
        LeftPanel.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        LeftPanel.BorderSizePixel = 0
        LeftPanel.Parent = Inner
        
        local tabs = {"👤 Игрок", "👁 Визуал", "🔫 Оружие", "⚡ Функции", "⚙ Настройки"}
        local selectedTab = 1
        local tabButtons = {}
        local contentFrames = {}
        
        local tabHeight = isMobile and 28 or 30
        local tabSpacing = isMobile and 29 or 31
        
        for i, tabName in ipairs(tabs) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, tabHeight)
            btn.Position = UDim2.new(0, 0, 0, (i-1)*tabSpacing + 5)
            btn.BackgroundColor3 = i == 1 and Color3.fromRGB(140, 0, 0) or Color3.fromRGB(30, 30, 35)
            btn.BorderSizePixel = 0
            btn.Text = tabName
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = isMobile and 9 or 11
            btn.AutoButtonColor = false
            btn.Parent = LeftPanel
            
            local function selectTab()
                selectedTab = i
                for j, b in ipairs(tabButtons) do
                    b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                end
                btn.BackgroundColor3 = Color3.fromRGB(140, 0, 0)
                for j, cf in ipairs(contentFrames) do
                    cf.Visible = (j == i)
                end
            end
            
            btn.MouseButton1Click:Connect(selectTab)
            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    selectTab()
                end
            end)
            
            table.insert(tabButtons, btn)
            
            local content = Instance.new("ScrollingFrame")
            content.Size = UDim2.new(1, -leftPanelWidth - 5, 1, -titleBarHeight)
            content.Position = UDim2.new(0, leftPanelWidth + 3, 0, titleBarHeight)
            content.BackgroundTransparency = 1
            content.BorderSizePixel = 0
            content.ScrollBarThickness = 3
            content.ScrollBarImageColor3 = Color3.fromRGB(140, 0, 0)
            content.CanvasSize = UDim2.new(0, 0, 0, 800)
            content.Visible = (i == 1)
            content.Parent = Inner
            
            table.insert(contentFrames, content)
        end
        
        -- Компоненты
        local function createCheckbox(parent, text, callback, default, y)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -10, 0, isMobile and 26 or 28)
            container.Position = UDim2.new(0, 5, 0, y)
            container.BackgroundTransparency = 1
            container.Parent = parent
            
            local box = Instance.new("Frame")
            box.Size = UDim2.new(0, isMobile and 16 or 18, 0, isMobile and 16 or 18)
            box.Position = UDim2.new(0, 0, 0, isMobile and 4 or 5)
            box.BackgroundColor3 = default and Color3.fromRGB(140, 0, 0) or Color3.fromRGB(50, 50, 50)
            box.BorderSizePixel = 0
            box.Parent = container
            
            local check = Instance.new("TextLabel")
            check.Size = UDim2.new(1, 0, 1, 0)
            check.BackgroundTransparency = 1
            check.Text = "✓"
            check.TextColor3 = Color3.fromRGB(255, 255, 255)
            check.Font = Enum.Font.GothamBold
            check.TextSize = isMobile and 11 or 13
            check.Visible = default or false
            check.Parent = box
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -25, 1, 0)
            label.Position = UDim2.new(0, 25, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.Font = Enum.Font.Gotham
            label.TextSize = isMobile and 10 or 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            
            local enabled = default or false
            
            local function toggle()
                enabled = not enabled
                TweenService:Create(box, TweenInfo.new(0.2), {
                    BackgroundColor3 = enabled and Color3.fromRGB(140, 0, 0) or Color3.fromRGB(50, 50, 50)
                }):Play()
                check.Visible = enabled
                if callback then callback(enabled) end
            end
            
            container.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    toggle()
                end
            end)
            
            return {Toggle = toggle}
        end
        
        local function createSlider(parent, text, min, max, default, callback, y)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -10, 0, isMobile and 38 or 42)
            container.Position = UDim2.new(0, 5, 0, y)
            container.BackgroundTransparency = 1
            container.Parent = parent
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, isMobile and 15 or 18)
            label.BackgroundTransparency = 1
            label.Text = text .. ": " .. default
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.Font = Enum.Font.Gotham
            label.TextSize = isMobile and 9 or 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            
            local sliderBg = Instance.new("Frame")
            sliderBg.Size = UDim2.new(1, 0, 0, isMobile and 4 or 5)
            sliderBg.Position = UDim2.new(0, 0, 0, isMobile and 20 or 22)
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
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local function update(pos)
                        local relPos = (pos.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
                        setValue(min + relPos * (max - min))
                    end
                    update(input.Position)
                    
                    local conn
                    conn = UserInputService.InputChanged:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                            update(inp.Position)
                        end
                    end)
                    
                    UserInputService.InputEnded:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                            conn:Disconnect()
                        end
                    end)
                end
            end)
            
            return {Set = setValue}
        end
        
        local function createButton(parent, text, callback, y)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, isMobile and 26 or 28)
            btn.Position = UDim2.new(0, 5, 0, y)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.BorderSizePixel = 0
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = isMobile and 9 or 12
            btn.AutoButtonColor = false
            btn.Parent = parent
            
            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    callback()
                end
            end)
            
            return btn
        end
        
        -- Заполнение вкладок
        local y1, y2, y3, y4, y5 = 10, 10, 10, 10, 10
        local checkboxSpacing = isMobile and 30 or 32
        local sliderSpacing = isMobile and 42 or 46
        local buttonSpacing = isMobile and 32 or 34
        
        -- Игрок
        createCheckbox(contentFrames[1], "Fly", function(v) Functions.ToggleFly(v) end, false, y1); y1 += checkboxSpacing
        createSlider(contentFrames[1], "Скорость Fly", 10, 100, 20, function(v) Functions.SetFlySpeed(v) end, y1); y1 += sliderSpacing
        createCheckbox(contentFrames[1], "NoClip", function(v) Functions.ToggleNoClip(v) end, false, y1); y1 += checkboxSpacing
        createCheckbox(contentFrames[1], "God Mode", function(v) Functions.ToggleGodMode(v) end, false, y1); y1 += checkboxSpacing
        createCheckbox(contentFrames[1], "Невидимость", function(v) Functions.ToggleInvisible(v) end, false, y1); y1 += checkboxSpacing
        createSlider(contentFrames[1], "Скорость", 16, 200, 16, function(v) Functions.SetSpeed(v) end, y1); y1 += sliderSpacing
        createSlider(contentFrames[1], "Прыжок", 50, 300, 50, function(v) Functions.SetJumpPower(v) end, y1); y1 += sliderSpacing
        createCheckbox(contentFrames[1], "Авто-Бот", function(v) Functions.ToggleBot(v) end, false, y1); y1 += checkboxSpacing
        
        -- Визуал
        createCheckbox(contentFrames[2], "ESP", function(v) Functions.ToggleESP(v) end, false, y2); y2 += checkboxSpacing
        createCheckbox(contentFrames[2], "ESP Боксы", function(v) Functions.ToggleESPBoxes(v) end, false, y2); y2 += checkboxSpacing
        createCheckbox(contentFrames[2], "ESP Имена", function(v) Functions.ToggleESPNames(v) end, false, y2); y2 += checkboxSpacing
        createCheckbox(contentFrames[2], "ESP Дистанция", function(v) Functions.ToggleESPDistance(v) end, false, y2); y2 += checkboxSpacing
        createCheckbox(contentFrames[2], "ESP Трейсеры", function(v) Functions.ToggleESPTracers(v) end, false, y2); y2 += checkboxSpacing
        createSlider(contentFrames[2], "Макс. дистанция ESP", 100, 1000, 500, function(v) Functions.SetESPMaxDistance(v) end, y2); y2 += sliderSpacing
        createCheckbox(contentFrames[2], "Full Bright", function(v) Functions.ToggleFullBright(v) end, false, y2); y2 += checkboxSpacing
        createCheckbox(contentFrames[2], "No Fog", function(v) Functions.ToggleNoFog(v) end, false, y2); y2 += checkboxSpacing
        
        -- Оружие
        createCheckbox(contentFrames[3], "Aimbot", function(v) Functions.ToggleAimbot(v) end, false, y3); y3 += checkboxSpacing
        createCheckbox(contentFrames[3], "Auto Shoot", function(v) Functions.ToggleAutoShoot(v) end, false, y3); y3 += checkboxSpacing
        createCheckbox(contentFrames[3], "Auto Knife", function(v) Functions.ToggleAutoKnife(v) end, false, y3); y3 += checkboxSpacing
        createCheckbox(contentFrames[3], "Silent Aim", function(v) Functions.ToggleSilentAim(v) end, false, y3); y3 += checkboxSpacing
        createSlider(contentFrames[3], "FOV Aimbot", 50, 500, 150, function(v) Functions.SetAimbotFOV(v) end, y3); y3 += sliderSpacing
        createSlider(contentFrames[3], "Сглаживание", 1, 10, 2, function(v) Functions.SetAimbotSmooth(v) end, y3); y3 += sliderSpacing
        createCheckbox(contentFrames[3], "No Recoil", function(v) Functions.ToggleNoRecoil(v) end, false, y3); y3 += checkboxSpacing
        createCheckbox(contentFrames[3], "No Spread", function(v) Functions.ToggleNoSpread(v) end, false, y3); y3 += checkboxSpacing
        
                -- Функции
        createButton(contentFrames[4], "💀 КРАШ СЕРВЕРА", function() Functions.CrashServer() end, y4); y4 += buttonSpacing
        createButton(contentFrames[4], "💥 Взрыв всех", function() Functions.ExplodeAll() end, y4); y4 += buttonSpacing
        createButton(contentFrames[4], "🎵 Spawn Music", function() Functions.SpawnMusic() end, y4); y4 += buttonSpacing
        createButton(contentFrames[4], "🌀 Спин бот", function() Functions.SpinBot() end, y4); y4 += buttonSpacing
        createButton(contentFrames[4], "📦 Спам боксов", function() Functions.SpamBoxes() end, y4); y4 += buttonSpacing
        createButton(contentFrames[4], "👻 Призрак", function() Functions.ToggleGhost() end, y4); y4 += buttonSpacing
        createButton(contentFrames[4], "🌈 Rainbow Body", function() Functions.ToggleRainbowBody() end, y4); y4 += buttonSpacing
        
        -- Настройки
        createButton(contentFrames[5], "💾 Сохранить", function() Functions.SaveSettings() end, y5); y5 += buttonSpacing
        createButton(contentFrames[5], "📂 Загрузить", function() Functions.LoadSettings() end, y5); y5 += buttonSpacing
        createButton(contentFrames[5], "🔄 Перезагрузить", function() Functions.ReloadScript() end, y5); y5 += buttonSpacing
        createButton(contentFrames[5], "🌐 Открыть GitHub", function() Functions.OpenGitHub() end, y5); y5 += buttonSpacing
        
        -- Открытие/закрытие
        local function ToggleMenu()
            IsOpen = not IsOpen
            Main.Visible = IsOpen
        end
        
        StarIcon.MouseButton1Click:Connect(function()
            if not draggingStar then ToggleMenu() end
        end)
        StarIcon.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                task.wait(0.1)
                if not draggingStar then ToggleMenu() end
            end
        end)
        
        CloseBtn.MouseButton1Click:Connect(ToggleMenu)
        CloseBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then ToggleMenu() end
        end)
        
        if not isMobile then
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode == Enum.KeyCode.RightShift then ToggleMenu() end
            end)
        end
        
        print("[SovietIlyaGG Hub] ✅ GUI загружен")
    end
} 
