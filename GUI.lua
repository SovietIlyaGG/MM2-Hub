-- GUI Module | SovietIlyaGG | Mobile Fixed
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
        
        -- Звезда
        local StarIcon = Instance.new("ImageButton")
        StarIcon.Size = UDim2.new(0, 50, 0, 50)
        StarIcon.Position = UDim2.new(0.75, 0, 0.5, 0)
        StarIcon.BackgroundTransparency = 1
        StarIcon.Image = "rbxassetid://9648657963"
        StarIcon.ImageColor3 = Color3.fromRGB(255, 30, 30)
        StarIcon.Parent = ScreenGui
        
        local Glow = Instance.new("ImageLabel")
        Glow.Size = UDim2.new(1, 20, 1, 20)
        Glow.Position = UDim2.new(0, -10, 0, -10)
        Glow.BackgroundTransparency = 1
        Glow.Image = "rbxassetid://9648657963"
        Glow.ImageColor3 = Color3.fromRGB(255, 0, 0)
        Glow.ImageTransparency = 0.6
        Glow.Parent = StarIcon
        
        spawn(function()
            while wait(0.05) do
                local t = tick()
                Glow.ImageTransparency = 0.4 + math.sin(t * 3) * 0.2
            end
        end)
        
        -- Drag звезды
        local draggingStar = false
        local starStartPos
        local starDragStart
        
        StarIcon.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                draggingStar = true
                starStartPos = StarIcon.Position
                starDragStart = input.Position
            end
        end)
        
        StarIcon.InputChanged:Connect(function(input)
            if draggingStar and input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - starDragStart
                StarIcon.Position = UDim2.new(
                    starStartPos.X.Scale, 
                    starStartPos.X.Offset + delta.X, 
                    starStartPos.Y.Scale, 
                    starStartPos.Y.Offset + delta.Y
                )
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                draggingStar = false
            end
        end)
        
        -- Меню
        local IsOpen = false
        local Main = Instance.new("Frame")
        Main.Size = UDim2.new(0, 300, 0, 400)
        Main.Position = UDim2.new(0.5, -150, 0.5, -200)
        Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        Main.Visible = false
        Main.Parent = ScreenGui
        
        local Border = Instance.new("Frame")
        Border.Size = UDim2.new(1, 4, 1, 4)
        Border.Position = UDim2.new(0, -2, 0, -2)
        Border.BackgroundColor3 = Color3.fromRGB(140, 0, 0)
        Border.Parent = Main
        
        local Inner = Instance.new("Frame")
        Inner.Size = UDim2.new(1, -4, 1, -4)
        Inner.Position = UDim2.new(0, 2, 0, 2)
        Inner.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        Inner.Parent = Main
        
        -- Заголовок
        local TitleBar = Instance.new("Frame")
        TitleBar.Size = UDim2.new(1, 0, 0, 35)
        TitleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        TitleBar.Parent = Inner
        
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -40, 1, 0)
        Title.Position = UDim2.new(0, 10, 0, 0)
        Title.BackgroundTransparency = 1
        Title.Text = "⭐ SOVIET ILYA"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Font = Enum.Font.GothamBlack
        Title.TextSize = 12
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = TitleBar
        
        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0, 26, 0, 26)
        CloseBtn.Position = UDim2.new(1, -30, 0, 5)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
        CloseBtn.Text = "X"
        CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseBtn.Font = Enum.Font.GothamBold
        CloseBtn.TextSize = 12
        CloseBtn.Parent = TitleBar
        
        -- Drag меню
        local draggingMenu = false
        local menuStartPos
        local menuDragStart
        
        TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                draggingMenu = true
                menuStartPos = Main.Position
                menuDragStart = input.Position
            end
        end)
        
        TitleBar.InputChanged:Connect(function(input)
            if draggingMenu and input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - menuDragStart
                Main.Position = UDim2.new(
                    menuStartPos.X.Scale,
                    menuStartPos.X.Offset + delta.X,
                    menuStartPos.Y.Scale,
                    menuStartPos.Y.Offset + delta.Y
                )
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                draggingMenu = false
            end
        end)
        
        -- Вкладки
        local LeftPanel = Instance.new("Frame")
        LeftPanel.Size = UDim2.new(0, 90, 1, -35)
        LeftPanel.Position = UDim2.new(0, 0, 0, 35)
        LeftPanel.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        LeftPanel.Parent = Inner
        
        local tabs = {"Игрок", "Визуал", "Оружие", "Функции"}
        local selectedTab = 1
        local tabButtons = {}
        local contentFrames = {}
        
        for i, tabName in ipairs(tabs) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 28)
            btn.Position = UDim2.new(0, 0, 0, (i-1)*29 + 5)
            btn.BackgroundColor3 = i == 1 and Color3.fromRGB(140, 0, 0) or Color3.fromRGB(30, 30, 35)
            btn.Text = tabName
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 10
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
            
            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    selectTab()
                end
            end)
            
            table.insert(tabButtons, btn)
            
            local content = Instance.new("ScrollingFrame")
            content.Size = UDim2.new(1, -95, 1, -35)
            content.Position = UDim2.new(0, 93, 0, 35)
            content.BackgroundTransparency = 1
            content.ScrollBarThickness = 3
            content.ScrollBarImageColor3 = Color3.fromRGB(140, 0, 0)
            content.CanvasSize = UDim2.new(0, 0, 0, 600)
            content.Visible = (i == 1)
            content.Parent = Inner
            
            table.insert(contentFrames, content)
        end
        
        -- Компоненты
        local function createCheckbox(parent, text, callback, y)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -10, 0, 26)
            container.Position = UDim2.new(0, 5, 0, y)
            container.BackgroundTransparency = 1
            container.Parent = parent
            
            local box = Instance.new("Frame")
            box.Size = UDim2.new(0, 16, 0, 16)
            box.Position = UDim2.new(0, 0, 0, 5)
            box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            box.Parent = container
            
            local check = Instance.new("TextLabel")
            check.Size = UDim2.new(1, 0, 1, 0)
            check.BackgroundTransparency = 1
            check.Text = "✓"
            check.TextColor3 = Color3.fromRGB(255, 255, 255)
            check.Font = Enum.Font.GothamBold
            check.TextSize = 11
            check.Visible = false
            check.Parent = box
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -25, 1, 0)
            label.Position = UDim2.new(0, 25, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.Font = Enum.Font.Gotham
            label.TextSize = 10
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            
            local enabled = false
            
            container.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    enabled = not enabled
                    box.BackgroundColor3 = enabled and Color3.fromRGB(140, 0, 0) or Color3.fromRGB(50, 50, 50)
                    check.Visible = enabled
                    if callback then callback(enabled) end
                end
            end)
        end
        
        local function createSlider(parent, text, min, max, default, callback, y)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -10, 0, 38)
            container.Position = UDim2.new(0, 5, 0, y)
            container.BackgroundTransparency = 1
            container.Parent = parent
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 15)
            label.BackgroundTransparency = 1
            label.Text = text .. ": " .. default
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.Font = Enum.Font.Gotham
            label.TextSize = 10
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            
            local sliderBg = Instance.new("Frame")
            sliderBg.Size = UDim2.new(1, 0, 0, 4)
            sliderBg.Position = UDim2.new(0, 0, 0, 20)
            sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            sliderBg.Parent = container
            
            local sliderFill = Instance.new("Frame")
            local percent = (default - min) / (max - min)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderFill.BackgroundColor3 = Color3.fromRGB(140, 0, 0)
            sliderFill.Parent = sliderBg
            
            local value = default
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    local function update(pos)
                        local relPos = (pos.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
                        value = math.clamp(min + relPos * (max - min), min, max)
                        local p = (value - min) / (max - min)
                        sliderFill.Size = UDim2.new(p, 0, 1, 0)
                        label.Text = text .. ": " .. math.floor(value)
                        if callback then callback(value) end
                    end
                    update(input.Position)
                end
            end)
        end
        
        local function createButton(parent, text, callback, y)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 26)
            btn.Position = UDim2.new(0, 5, 0, y)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 10
            btn.Parent = parent
            
            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    callback()
                end
            end)
        end
        
        -- Заполнение
        local y1, y2, y3, y4 = 10, 10, 10, 10
        
        -- Игрок
        createCheckbox(contentFrames[1], "Fly", function(v) Functions.ToggleFly(v) end, y1); y1 += 30
        createSlider(contentFrames[1], "Скорость Fly", 10, 100, 20, function(v) Functions.SetFlySpeed(v) end, y1); y1 += 42
        createCheckbox(contentFrames[1], "NoClip", function(v) Functions.ToggleNoClip(v) end, y1); y1 += 30
        createCheckbox(contentFrames[1], "God Mode", function(v) Functions.ToggleGodMode(v) end, y1); y1 += 30
        createCheckbox(contentFrames[1], "Невидимость", function(v) Functions.ToggleInvisible(v) end, y1); y1 += 30
        createSlider(contentFrames[1], "Скорость", 16, 200, 16, function(v) Functions.SetSpeed(v) end, y1); y1 += 42
        createSlider(contentFrames[1], "Прыжок", 50, 300, 50, function(v) Functions.SetJumpPower(v) end, y1); y1 += 42
        createCheckbox(contentFrames[1], "Авто-Бот", function(v) Functions.ToggleBot(v) end, y1); y1 += 30
        
        -- Визуал
        createCheckbox(contentFrames[2], "ESP", function(v) Functions.ToggleESP(v) end, y2); y2 += 30
        createCheckbox(contentFrames[2], "ESP Боксы", function(v) Functions.ToggleESPBoxes(v) end, y2); y2 += 30
        createCheckbox(contentFrames[2], "ESP Имена", function(v) Functions.ToggleESPNames(v) end, y2); y2 += 30
        createCheckbox(contentFrames[2], "ESP Дистанция", function(v) Functions.ToggleESPDistance(v) end, y2); y2 += 30
        createCheckbox(contentFrames[2], "Full Bright", function(v) Functions.ToggleFullBright(v) end, y2); y2 += 30
        createCheckbox(contentFrames[2], "No Fog", function(v) Functions.ToggleNoFog(v) end, y2); y2 += 30
        
        -- Оружие
        createCheckbox(contentFrames[3], "Aimbot", function(v) Functions.ToggleAimbot(v) end, y3); y3 += 30
        createCheckbox(contentFrames[3], "Auto Shoot", function(v) Functions.ToggleAutoShoot(v) end, y3); y3 += 30
        createCheckbox(contentFrames[3], "Silent Aim", function(v) Functions.ToggleSilentAim(v) end, y3); y3 += 30
        createSlider(contentFrames[3], "FOV Aimbot", 50, 500, 150, function(v) Functions.SetAimbotFOV(v) end, y3); y3 += 42
        
        -- Функции
        createButton(contentFrames[4], "КРАШ СЕРВЕРА", function() Functions.CrashServer() end, y4); y4 += 32
        createButton(contentFrames[4], "Взрыв всех", function() Functions.ExplodeAll() end, y4); y4 += 32
        createButton(contentFrames[4], "Спин бот", function() Functions.SpinBot() end, y4); y4 += 32
        
        -- Открытие
        local function ToggleMenu()
            IsOpen = not IsOpen
            Main.Visible = IsOpen
        end
        
        StarIcon.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                wait(0.1)
                if not draggingStar then
                    ToggleMenu()
                end
            end
        end)
        
        CloseBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                ToggleMenu()
            end
        end)
    end
}
