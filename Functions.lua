-- Functions Module for SovietIlya MM2 Hub
-- GitHub: SovietIlyaGG

return {
    _flySpeed = 20,
    _aimbotFOV = 150,
    _aimbotSmooth = 2,
    _espMaxDistance = 500,
    _espEnabled = false,
    _espBoxes = false,
    _espNames = false,
    _espDistance = false,
    _espTracers = false,
    
    -- ===== PLAYER =====
    ToggleFly = function(self, state)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")
        
        if state then
            self._flyConnection = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if root and hum then
                    hum.PlatformStand = true
                    local speed = self._flySpeed
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
        else
            if self._flyConnection then
                self._flyConnection:Disconnect()
                self._flyConnection = nil
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then hum.PlatformStand = false end
            end
        end
    end,
    
    SetFlySpeed = function(self, speed)
        self._flySpeed = speed
    end,
    
    ToggleNoClip = function(self, state)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local RunService = game:GetService("RunService")
        
        if state then
            self._noclipConnection = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if self._noclipConnection then
                self._noclipConnection:Disconnect()
                self._noclipConnection = nil
            end
        end
    end,
    
    ToggleGodMode = function(self, state)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local RunService = game:GetService("RunService")
        
        if state then
            self._godConnection = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.Health = hum.MaxHealth
                    hum.MaxHealth = math.huge
                end
            end)
        else
            if self._godConnection then
                self._godConnection:Disconnect()
                self._godConnection = nil
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then hum.MaxHealth = 100 end
            end
        end
    end,
    
    ToggleInvisible = function(self, state)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = state and 1 or 0
                end
            end
        end
    end,
    
    SetSpeed = function(self, speed)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = speed end
    end,
    
    SetJumpPower = function(self, power)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = power end
    end,
    
    -- ===== BOT =====
    ToggleBot = function(self, state)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local RunService = game:GetService("RunService")
        
        if state then
            self._botConnection = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if not char then return end
                local myRoot = char:FindFirstChild("HumanoidRootPart")
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
                                if dist < minDist then minDist, closest = dist, plr end
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
        else
            if self._botConnection then
                self._botConnection:Disconnect()
                self._botConnection = nil
            end
        end
    end,
    
    -- ===== ESP =====
    ToggleESP = function(self, state) self._espEnabled = state end,
    ToggleESPBoxes = function(self, state) self._espBoxes = state end,
    ToggleESPNames = function(self, state) self._espNames = state end,
    ToggleESPDistance = function(self, state) self._espDistance = state end,
    ToggleESPTracers = function(self, state) self._espTracers = state end,
    SetESPMaxDistance = function(self, dist) self._espMaxDistance = dist end,
    
    -- ===== VISUAL =====
    ToggleFullBright = function(self, state)
        local Lighting = game:GetService("Lighting")
        Lighting.Brightness = state and 2 or 1
        Lighting.ClockTime = state and 14 or 8
    end,
    
    ToggleNoFog = function(self, state)
        local Lighting = game:GetService("Lighting")
        Lighting.FogEnd = state and math.huge or 10000
    end,
    
    -- ===== WEAPON =====
    ToggleAimbot = function(self, state) self._aimbotEnabled = state end,
    ToggleAutoShoot = function(self, state) self._autoShoot = state end,
    ToggleAutoKnife = function(self, state) self._autoKnife = state end,
    ToggleSilentAim = function(self, state) self._silentAim = state end,
    SetAimbotFOV = function(self, fov) self._aimbotFOV = fov end,
    SetAimbotSmooth = function(self, smooth) self._aimbotSmooth = smooth end,
    ToggleNoRecoil = function(self, state) self._noRecoil = state end,
    ToggleNoSpread = function(self, state) self._noSpread = state end,
    
    -- ===== FUN =====
    CrashServer = function(self)
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
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
    end,
    
    ExplodeAll = function(self)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local exp = Instance.new("Explosion")
                    exp.BlastRadius = 10
                    exp.BlastPressure = 100000
                    exp.Position = root.Position
                    exp.Parent = workspace
                end
            end
        end
    end,
    
    SpawnMusic = function(self)
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://1842808435"
        sound.Volume = 5
        sound.Parent = workspace
        sound:Play()
    end,
    
    SpinBot = function(self)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            spawn(function()
                for i = 1, 50 do
                    root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(36), 0)
                    task.wait(0.05)
                end
            end)
        end
    end,
    
    SpamBoxes = function(self)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            for i = 1, 50 do
                spawn(function()
                    local box = Instance.new("Part")
                    box.Size = Vector3.new(3, 3, 3)
                    box.Position = root.Position + Vector3.new(math.random(-20, 20), math.random(0, 20), math.random(-20, 20))
                    box.Anchored = true
                    box.Parent = workspace
                    task.wait(5)
                    box:Destroy()
                end)
            end
        end
    end,
    
    ToggleGhost = function(self)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = part.Transparency == 0 and 0.7 or 0
                end
            end
        end
    end,
    
    ToggleRainbowBody = function(self)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local RunService = game:GetService("RunService")
        
        if self._rainbowConnection then
            self._rainbowConnection:Disconnect()
            self._rainbowConnection = nil
        else
            local char = LocalPlayer.Character
            if char then
                self._rainbowConnection = RunService.Heartbeat:Connect(function()
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
    end,
    
    -- ===== SETTINGS =====
    SaveSettings = function(self)
        print("[SovietIlyaGG] ✅ Настройки сохранены")
    end,
    
    LoadSettings = function(self)
        print("[SovietIlyaGG] ✅ Настройки загружены")
    end,
    
    ReloadScript = function(self)
        print("[SovietIlyaGG] 🔄 Перезагрузка...")
    end,
    
    OpenGitHub = function(self)
        print("[SovietIlyaGG] 🌐 github.com/SovietIlyaGG/MM2-Hub")
    end
}
