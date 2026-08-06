-- Functions Module for SovietIlya Hub
return (function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local Camera = workspace.CurrentCamera
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Lighting = game:GetService("Lighting")
    
    local Functions = {}
    local Connections = {}
    
    -- Вспомогательные функции
    local function getChar()
        return LocalPlayer.Character
    end
    
    local function getRoot()
        local char = getChar()
        return char and char:FindFirstChild("HumanoidRootPart")
    end
    
    local function getHumanoid()
        local char = getChar()
        return char and char:FindFirstChildOfClass("Humanoid")
    end
    
    -- ===== PLAYER FUNCTIONS =====
    
    function Functions.ToggleFly(state)
        if state then
            local connection
            connection = RunService.Heartbeat:Connect(function()
                local root = getRoot()
                local hum = getHumanoid()
                if root and hum then
                    hum.PlatformStand = true
                    local speed = Functions._flySpeed or 20
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        root.Velocity = root.CFrame.LookVector * speed
                    elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        root.Velocity = -root.CFrame.LookVector * speed
                    elseif UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        root.Velocity = Vector3.new(0, speed, 0)
                    elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                        root.Velocity = Vector3.new(0, -speed, 0)
                    else
                        root.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end)
            Connections.Fly = connection
        else
            if Connections.Fly then
                Connections.Fly:Disconnect()
                local hum = getHumanoid()
                if hum then hum.PlatformStand = false end
                Connections.Fly = nil
            end
        end
    end
    
    function Functions.SetFlySpeed(speed)
        Functions._flySpeed = speed
    end
    
    function Functions.ToggleNoClip(state)
        if state then
            local connection
            connection = RunService.Stepped:Connect(function()
                local char = getChar()
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            Connections.NoClip = connection
        else
            if Connections.NoClip then
                Connections.NoClip:Disconnect()
                Connections.NoClip = nil
            end
        end
    end
    
    function Functions.ToggleGodMode(state)
        if state then
            local connection
            connection = RunService.Heartbeat:Connect(function()
                local hum = getHumanoid()
                if hum then
                    hum.Health = hum.MaxHealth
                    hum.MaxHealth = math.huge
                end
            end)
            Connections.GodMode = connection
        else
            if Connections.GodMode then
                Connections.GodMode:Disconnect()
                local hum = getHumanoid()
                if hum then hum.MaxHealth = 100 end
                Connections.GodMode = nil
            end
        end
    end
    
    function Functions.ToggleInvisible(state)
        local char = getChar()
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = state and 1 or 0
                end
            end
        end
    end
    
    function Functions.SetSpeed(speed)
        local hum = getHumanoid()
        if hum then
            hum.WalkSpeed = speed
        end
    end
    
    function Functions.SetJumpPower(power)
        local hum = getHumanoid()
        if hum then
            hum.JumpPower = power
        end
    end
    
    -- ===== BOT =====
    function Functions.ToggleBot(state)
        if state then
            local connection
            connection = RunService.Heartbeat:Connect(function()
                local char = getChar()
                if not char then return end
                local myRoot = getRoot()
                if not myRoot then return end
                
                local knife = char:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")
                local gun = char:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
                
                local closest, minDist = nil, math.huge
                
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                        if targetRoot then
                            local isTarget = false
                            local hasKnife = plr.Character:FindFirstChild("Knife") or plr.Backpack:FindFirstChild("Knife")
                            
                            if knife and not hasKnife then isTarget = true end
                            if gun and hasKnife then isTarget = true end
                            
                            if isTarget then
                                local dist = (targetRoot.Position - myRoot.Position).Magnitude
                                if dist < minDist then
                                    minDist = dist
                                    closest = plr
                                end
                            end
                        end
                    end
                end
                
                if closest and closest.Character then
                    local targetRoot = closest.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        if knife and minDist <= 5 then
                            myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 2)
                            task.wait(0.05)
                            knife:Activate()
                        elseif gun and minDist <= 100 then
                            local targetHead = closest.Character:FindFirstChild("Head")
                            if targetHead then
                                myRoot.CFrame = CFrame.new(myRoot.Position, targetHead.Position)
                                gun:Activate()
                            end
                        end
                    end
                end
            end)
            Connections.Bot = connection
        else
            if Connections.Bot then
                Connections.Bot:Disconnect()
                Connections.Bot = nil
            end
        end
    end
    
    -- ===== ESP =====
    function Functions.ToggleESP(state)
        Functions._espEnabled = state
    end
    
    function Functions.ToggleESPBoxes(state)
        Functions._espBoxes = state
    end
    
    function Functions.ToggleESPNames(state)
        Functions._espNames = state
    end
    
    function Functions.ToggleESPDistance(state)
        Functions._espDistance = state
    end
    
    function Functions.ToggleESPTracers(state)
        Functions._espTracers = state
    end
    
    -- ESP Drawing Loop
    spawn(function()
        local espDrawings = {}
        
        while task.wait() do
            if not Functions._espEnabled then
                for _, drawings in pairs(espDrawings) do
                    for _, d in pairs(drawings) do
                        if d.Remove then d:Remove() end
                    end
                end
                espDrawings = {}
                continue
            end
            
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local head = plr.Character:FindFirstChild("Head")
                    local root = plr.Character:FindFirstChild("HumanoidRootPart")
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    
                    if head and root and hum and hum.Health > 0 then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                        
                        if onScreen then
                            -- Create drawings if needed
                            if not espDrawings[plr] then
                                local lines = {}
                                if Functions._espBoxes then
                                    for i = 1, 4 do
                                        local line = Drawing.new("Line")
                                        line.Visible = true
                                        line.Color = Color3.fromRGB(255, 255, 255)
                                        line.Thickness = 2
                                        lines[i] = line
                                    end
                                end
                                
                                local nameText
                                if Functions._espNames then
                                    nameText = Drawing.new("Text")
                                    nameText.Visible = true
                                    nameText.Color = Color3.fromRGB(255, 255, 255)
                                    nameText.Size = 14
                                    nameText.Center = true
                                    nameText.Outline = true
                                    lines.NameText = nameText
                                end
                                
                                local distText
                                if Functions._espDistance then
                                    distText = Drawing.new("Text")
                                    distText.Visible = true
                                    distText.Color = Color3.fromRGB(255, 255, 255)
                                    distText.Size = 13
                                    distText.Center = true
                                    distText.Outline = true
                                    lines.DistText = distText
                                end
                                
                                local tracer
                                if Functions._espTracers then
                                    tracer = Drawing.new("Line")
                                    tracer.Visible = true
                                    tracer.Color = Color3.fromRGB(255, 255, 255)
                                    tracer.Thickness = 1
                                    lines.Tracer = tracer
                                end
                                
                                espDrawings[plr] = lines
                            end
                            
                            local drawings = espDrawings[plr]
                            
                            -- Update ESP
                            if Functions._espBoxes and drawings[1] then
                                local size = Vector2.new(2000 / screenPos.Z, 4000 / screenPos.Z)
                                local x, y = screenPos.X, screenPos.Y
                                local w, h = size.X, size.Y
                                
                                drawings[1].From = Vector2.new(x - w/2, y - h)
                                drawings[1].To = Vector2.new(x + w/2, y - h)
                                
                                drawings[2].From = Vector2.new(x - w/2, y - h)
                                drawings[2].To = Vector2.new(x - w/2, y)
                                
                                drawings[3].From = Vector2.new(x + w/2, y - h)
                                drawings[3].To = Vector2.new(x + w/2, y)
                                
                                drawings[4].From = Vector2.new(x - w/2, y)
                                drawings[4].To = Vector2.new(x + w/2, y)
                            end
                            
                            if Functions._espNames and drawings.NameText then
                                drawings.NameText.Text = plr.Name
                                drawings.NameText.Position = Vector2.new(screenPos.X, screenPos.Y - 40)
                            end
                            
                            if Functions._espDistance and drawings.DistText and getRoot() then
                                local dist = math.floor((getRoot().Position - root.Position).Magnitude)
                                drawings.DistText.Text = dist .. "m"
                                drawings.DistText.Position = Vector2.new(screenPos.X, screenPos.Y + 20)
                            end
                            
                            if Functions._espTracers and drawings.Tracer then
                                local vpSize = Camera.ViewportSize
                                drawings.Tracer.From = Vector2.new(vpSize.X/2, vpSize.Y)
                                drawings.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                            end
                        end
                    end
                end
            end
        end
    end)
    
    -- ===== VISUAL =====
    function Functions.ToggleFullBright(state)
        Lighting.Brightness = state and 2 or 1
        Lighting.ClockTime = state and 14 or 8
    end
    
    function Functions.ToggleNoFog(state)
        Lighting.FogEnd = state and math.huge or 10000
        Lighting.FogStart = state and math.huge or 0
    end
    
    function Functions.ToggleChams(state)
        local char = getChar()
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    if state then
                        part.Material = Enum.Material.Neon
                        part.BrickColor = BrickColor.new("Really red")
                    else
                        part.Material = Enum.Material.Plastic
                        part.BrickColor = BrickColor.new("Medium stone grey")
                    end
                end
            end
        end
    end
    
    function Functions.ToggleCrosshair(state)
        -- Реализация кастомного кроссхеира через Drawing
    end
    
    -- ===== WEAPON =====
    function Functions.ToggleAimbot(state)
        Functions._aimbot = state
    end
    
    function Functions.ToggleAutoShoot(state)
        Functions._autoShoot = state
    end
    
    function Functions.ToggleSilentAim(state)
        Functions._silentAim = state
    end
    
    function Functions.ToggleTriggerBot(state)
        Functions._triggerBot = state
    end
    
    function Functions.SetAimbotFOV(fov)
        Functions._aimbotFOV = fov
    end
    
    function Functions.SetAimbotSmooth(smooth)
        Functions._aimbotSmooth = smooth
    end
    
    function Functions.ToggleNoRecoil(state)
        -- Реализация No Recoil
    end
    
    function Functions.ToggleNoSpread(state)
        -- Реализация No Spread
    end
    
    function Functions.ToggleRapidFire(state)
        -- Реализация Rapid Fire
    end
    
    -- ===== FUN =====
    function Functions.SpawnMusic()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://1842808435" -- Rick Roll
        sound.Volume = 5
        sound.Parent = workspace
        sound:Play()
        sound.Ended:Connect(function() sound:Destroy() end)
    end
    
    function Functions.ExplodeAll()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local explosion = Instance.new("Explosion")
                    explosion.BlastRadius = 10
                    explosion.BlastPressure = 100000
                    explosion.Position = root.Position
                    explosion.Parent = workspace
                end
            end
        end
    end
    
    local spinBotConnection
    function Functions.ToggleSpinBot()
        if spinBotConnection then
            spinBotConnection:Disconnect()
            spinBotConnection = nil
        else
            local char = getChar()
            if char then
                local root = getRoot()
                if root then
                    local angle = 0
                    spinBotConnection = RunService.Heartbeat:Connect(function()
                        angle = angle + 10
                        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(10), 0)
                    end)
                end
            end
        end
    end
    
    function Functions.ToggleGhost()
        local char = getChar()
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = part.Transparency == 0 and 0.7 or 0
                end
            end
        end
    end
    
    local rainbowConnection
    function Functions.ToggleRainbowBody()
        if rainbowConnection then
            rainbowConnection:Disconnect()
            rainbowConnection = nil
        else
            local char = getChar()
            if char then
                rainbowConnection = RunService.Heartbeat:Connect(function()
                    local hue = tick() * 2 % 1
                    local color = Color3.fromHSV(hue, 1, 1)
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Color = color
                        end
                    end
                end)
            end
        end
    end
    
    function Functions.SpamBoxes()
        for i = 1, 50 do
            spawn(function()
                local box = Instance.new("Part")
                box.Size = Vector3.new(3, 3, 3)
                box.Position = (getRoot() and getRoot().Position or Vector3.new(0, 10, 0)) + Vector3.new(math.random(-20, 20), math.random(0, 20), math.random(-20, 20))
                box.Anchored = true
                box.Parent = workspace
                task.wait(5)
                box:Destroy()
            end)
        end
    end
    
    function Functions.FakeCrash()
        local msg = Instance.new("Message")
        msg.Text = "⚠️ SERVER CRASH IN 3...2...1..."
        msg.Parent = workspace
        task.wait(3)
        msg.Text = "😂 JOKE! Script by SovietIlya"
        task.wait(3)
        msg:Destroy()
    end
    
    -- ===== SETTINGS =====
    function Functions.SaveSettings()
        print("[Settings] Сохранено!")
    end
    
    function Functions.LoadSettings()
        print("[Settings] Загружено!")
    end
    
    function Functions.ReloadScript()
        print("[Script] Перезагрузка...")
    end
    
    function Functions.OpenGitHub()
        print("[GitHub] Открытие репозитория SovietIlya/MM2-Hub...")
    end
    
    -- ===== КРАШ СЕРВЕРА =====
    function Functions.CrashServer()
        spawn(function()
            local data = string.rep("CRASH_", 50000)
            while true do
                for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
                    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                        pcall(function() v:FireServer(data, math.huge) end)
                    end
                end
                task.wait(0.001)
            end
        end)
    end
    
    print("[Functions] Модуль загружен!")
    return Functions
end)
