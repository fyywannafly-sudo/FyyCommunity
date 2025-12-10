local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:AddTheme({
    Name = "Fyy Exploit", 
    
    Accent = WindUI:Gradient({                                                  
        ["0"] = { Color = Color3.fromHex("#1f1f23"), Transparency = 0 },        
        ["100"]   = { Color = Color3.fromHex("#18181b"), Transparency = 0 },    
    }, {                                                                        
        Rotation = 0,                                                           
    }),                                                                         
    Dialog = Color3.fromHex("#161616"),
    Outline = Color3.fromHex("#FFFFFF"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#101010"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#a1a1aa")
})
local Window = WindUI:CreateWindow({
    Title = "FyyExploit",
    Icon = "rbxassetid://106899268176689", 
    Author = "Fyy X Fish IT",
    Folder = "FyyConfig",
    
    Size = UDim2.fromOffset(530, 300),
    MinSize = Vector2.new(320, 300),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = false,
})

Window:SetToggleKey(Enum.KeyCode.G)

WindUI:Notify({
    Title = "FyyLoader",
    Content = "Press G To Open/Close Menu!",
    Duration = 4, 
    Icon = "slack",
})

Window:EditOpenButton({
    Title = "FyyCommunity",
    Icon = "rbxassetid://106899268176689",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})

Window:SetIconSize(35) 
Window:Tag({
    Title = "Premium",
    Radius = 13, -- from 0 to 13
})
---------------- TAB ---------------

local Info = Window:Tab({
    Title = "Info",
    Icon = "info", 
})

local Player = Window:Tab({
    Title = "Player",
    Icon = "user", 
})

local Auto = Window:Tab({
    Title = "Main",
    Icon = "play", 
})

local Shop = Window:Tab({
    Title = "Shop",
    Icon = "shopping-cart", 
})

local Teleport = Window:Tab({
    Title = "Teleport",
    Icon = "map-pin",
})

local Quest = Window:Tab({
    Title = "Quest",
    Icon = "loader", 
})

local Setting = Window:Tab({
    Title = "Settings",
    Icon = "settings", 
})

local Enchant = Window:Tab({
	Title = "Enchants",
	Icon = "star",
})

local Discord = Window:Tab({
    Title = "Webhook",
    Icon = "megaphone", 
})

local Config = Window:Tab({
	Title = "Config",
	Icon = "folder",
})

----------- END OF TAB -------------
local InfoSection = Info:Section({
    Title = "Have Problem / Need Help? Join Server Now",
    Box = true,
    TextTransparency = 0.05,
    TextXAlignment = "Center",
    TextSize = 17,
    Opened = true,
})

Info:Select()

local function CopyLink(link, title, notifTitle, notifContent)
    Info:Button({
        Title = title or "Copy Link",
        Desc = "Click to copy link",
        Callback = function()
            if setclipboard then
                setclipboard(link)
            end
            WindUI:Notify({
                Title = notifTitle or "Copied!",
                Content = notifContent or ("Link '" .. link .. "' copied to clipboard"),
                Duration = 3,
                Icon = "bell",
            })
        end
    })
end

CopyLink(
    "https://discord.gg/77nEeYeFRp",
    "Copy Discord Link",
    "Discord Copied!",
    "Link copied to clipboard"
)

---------------------------------------------------------------
--// PLAYER TAB
local PlayerSection = Player:Section({ Title = "Player Feature" })

local WalkSpeedInput = Player:Input({
    Title = "Set WalkSpeed",
    Placeholder = "Enter number (e.g. 50)",
    Callback = function(value)
        WalkSpeedInput.Value = tonumber(value) or 16
    end
})

local WalkSpeedToggle = Player:Toggle({
    Title = "WalkSpeed",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        humanoid.WalkSpeed = state and (WalkSpeedInput.Value or 16) or 16
    end
})

Player:Divider()

--// Infinite Jump
local InfiniteJumpConn
Player:Toggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state)
        local UIS = game:GetService("UserInputService")
        if state then
            InfiniteJumpConn = UIS.JumpRequest:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        elseif InfiniteJumpConn then
            InfiniteJumpConn:Disconnect()
            InfiniteJumpConn = nil
        end
    end
})

--// NoClip
local NoClipConn
Player:Toggle({
    Title = "NoClip",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        if state then
            NoClipConn = game:GetService("RunService").Stepped:Connect(function()
                local char = player.Character
                if char then
                    for _, part in ipairs(char:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        elseif NoClipConn then
            NoClipConn:Disconnect()
            NoClipConn = nil
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

--// Walk On Water
local walkOnWater = false
local waterPart

Player:Toggle({
    Title = "Walk On Water",
    Default = false,
    Callback = function(state)
        walkOnWater = state
        local player = game.Players.LocalPlayer
        local char = player.Character
        if state and char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if waterPart then waterPart:Destroy() end
                waterPart = Instance.new("Part")
                waterPart.Anchored = true
                waterPart.CanCollide = true
                waterPart.Size = Vector3.new(20, 1, 20)
                waterPart.Transparency = 1
                waterPart.Position = Vector3.new(hrp.Position.X, 0, hrp.Position.Z)
                waterPart.Parent = workspace
            end
        elseif waterPart then
            waterPart:Destroy()
            waterPart = nil
        end
    end
})

local lastRespawnPosition = nil

game:GetService("RunService").Heartbeat:Connect(function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            lastRespawnPosition = hrp.Position
        end
    end
end)

Player:Button({
    Title = "Respawn at Current Position",
    Callback = function()
        if not lastRespawnPosition then return end
        
        local player = game.Players.LocalPlayer
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                player.CharacterAdded:Connect(function(newChar)
                    task.wait(0.1)
                    local hrp = newChar:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = CFrame.new(lastRespawnPosition)
                    end
                end)
                
                humanoid.Health = 0
            end
        end
    end
})
Player:Space()
Player:Divider()

local Section = Player:Section({
    Title = "Gui External",
    Opened = true,
})

local FlyButton = Player:Button({
    Title = "Fly GUI",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()

        WindUI:Notify({
            Title = "Fly",
            Content = "Fly GUI berhasil dijalankan ✅",
            Duration = 3,
            Icon = "bell"
        })
    end
})

---------------- END OF PLAYER ------------------
local VirtualInputManager = game:GetService("VirtualInputManager")

task.spawn(function()
    local cycle = 0
    while true do
        
        local waitTime = math.random(600, 700)
        task.wait(waitTime)
        local keyCombos = {
            {Enum.KeyCode.LeftShift, Enum.KeyCode.E},    
            {Enum.KeyCode.LeftControl, Enum.KeyCode.F},                
            {Enum.KeyCode.LeftShift, Enum.KeyCode.Q},     
            {Enum.KeyCode.E, Enum.KeyCode.F},             
        }
        
        local chosenCombo = keyCombos[math.random(1, #keyCombos)]
        pcall(function()
            for _, key in pairs(chosenCombo) do
                VirtualInputManager:SendKeyEvent(true, key, false, nil)
            end
            
            task.wait(0.1) 
                for _, key in pairs(chosenCombo) do
                VirtualInputManager:SendKeyEvent(false, key, false, nil)
            end
        end)        
    end
end)

local Section = Auto:Section({ 
    Title = "Main Feature",
})

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:AddTheme({
    Name = "Fyy Exploit", 
    
    Accent = WindUI:Gradient({                                                  
        ["0"] = { Color = Color3.fromHex("#1f1f23"), Transparency = 0 },        
        ["100"]   = { Color = Color3.fromHex("#18181b"), Transparency = 0 },    
    }, {                                                                        
        Rotation = 0,                                                           
    }),                                                                         
    Dialog = Color3.fromHex("#161616"),
    Outline = Color3.fromHex("#FFFFFF"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#101010"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#a1a1aa")
})
local Window = WindUI:CreateWindow({
    Title = "FyyExploit",
    Icon = "rbxassetid://106899268176689", 
    Author = "Fyy X Fish IT",
    Folder = "FyyConfig",
    
    Size = UDim2.fromOffset(530, 300),
    MinSize = Vector2.new(320, 300),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = false,
})

Window:SetToggleKey(Enum.KeyCode.G)

WindUI:Notify({
    Title = "FyyLoader",
    Content = "Press G To Open/Close Menu!",
    Duration = 4, 
    Icon = "slack",
})

Window:EditOpenButton({
    Title = "FyyCommunity",
    Icon = "rbxassetid://106899268176689",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})

Window:SetIconSize(35) 
Window:Tag({
    Title = "Premium",
    Radius = 13, -- from 0 to 13
})
---------------- TAB ---------------

local Info = Window:Tab({
    Title = "Info",
    Icon = "info", 
})

local Player = Window:Tab({
    Title = "Player",
    Icon = "user", 
})

local Auto = Window:Tab({
    Title = "Main",
    Icon = "play", 
})

local Shop = Window:Tab({
    Title = "Shop",
    Icon = "shopping-cart", 
})

local Teleport = Window:Tab({
    Title = "Teleport",
    Icon = "map-pin",
})

local Quest = Window:Tab({
    Title = "Quest",
    Icon = "loader", 
})

local Setting = Window:Tab({
    Title = "Settings",
    Icon = "settings", 
})

local Enchant = Window:Tab({
	Title = "Enchants",
	Icon = "star",
})

local Discord = Window:Tab({
    Title = "Webhook",
    Icon = "megaphone", 
})

local Config = Window:Tab({
	Title = "Config",
	Icon = "folder",
})

----------- END OF TAB -------------
local InfoSection = Info:Section({
    Title = "Have Problem / Need Help? Join Server Now",
    Box = true,
    TextTransparency = 0.05,
    TextXAlignment = "Center",
    TextSize = 17,
    Opened = true,
})

Info:Select()

local function CopyLink(link, title, notifTitle, notifContent)
    Info:Button({
        Title = title or "Copy Link",
        Desc = "Click to copy link",
        Callback = function()
            if setclipboard then
                setclipboard(link)
            end
            WindUI:Notify({
                Title = notifTitle or "Copied!",
                Content = notifContent or ("Link '" .. link .. "' copied to clipboard"),
                Duration = 3,
                Icon = "bell",
            })
        end
    })
end

CopyLink(
    "https://discord.gg/77nEeYeFRp",
    "Copy Discord Link",
    "Discord Copied!",
    "Link copied to clipboard"
)

---------------------------------------------------------------
--// PLAYER TAB
local PlayerSection = Player:Section({ Title = "Player Feature" })

local WalkSpeedInput = Player:Input({
    Title = "Set WalkSpeed",
    Placeholder = "Enter number (e.g. 50)",
    Callback = function(value)
        WalkSpeedInput.Value = tonumber(value) or 16
    end
})

local WalkSpeedToggle = Player:Toggle({
    Title = "WalkSpeed",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        humanoid.WalkSpeed = state and (WalkSpeedInput.Value or 16) or 16
    end
})

Player:Divider()

--// Infinite Jump
local InfiniteJumpConn
Player:Toggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state)
        local UIS = game:GetService("UserInputService")
        if state then
            InfiniteJumpConn = UIS.JumpRequest:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        elseif InfiniteJumpConn then
            InfiniteJumpConn:Disconnect()
            InfiniteJumpConn = nil
        end
    end
})

--// NoClip
local NoClipConn
Player:Toggle({
    Title = "NoClip",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        if state then
            NoClipConn = game:GetService("RunService").Stepped:Connect(function()
                local char = player.Character
                if char then
                    for _, part in ipairs(char:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        elseif NoClipConn then
            NoClipConn:Disconnect()
            NoClipConn = nil
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

--// Walk On Water
local walkOnWater = false
local waterPart

Player:Toggle({
    Title = "Walk On Water",
    Default = false,
    Callback = function(state)
        walkOnWater = state
        local player = game.Players.LocalPlayer
        local char = player.Character
        if state and char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if waterPart then waterPart:Destroy() end
                waterPart = Instance.new("Part")
                waterPart.Anchored = true
                waterPart.CanCollide = true
                waterPart.Size = Vector3.new(20, 1, 20)
                waterPart.Transparency = 1
                waterPart.Position = Vector3.new(hrp.Position.X, 0, hrp.Position.Z)
                waterPart.Parent = workspace
            end
        elseif waterPart then
            waterPart:Destroy()
            waterPart = nil
        end
    end
})

local lastRespawnPosition = nil

game:GetService("RunService").Heartbeat:Connect(function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            lastRespawnPosition = hrp.Position
        end
    end
end)

Player:Button({
    Title = "Respawn at Current Position",
    Callback = function()
        if not lastRespawnPosition then return end
        
        local player = game.Players.LocalPlayer
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                player.CharacterAdded:Connect(function(newChar)
                    task.wait(0.1)
                    local hrp = newChar:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = CFrame.new(lastRespawnPosition)
                    end
                end)
                
                humanoid.Health = 0
            end
        end
    end
})
Player:Space()
Player:Divider()

local Section = Player:Section({
    Title = "Gui External",
    Opened = true,
})

local FlyButton = Player:Button({
    Title = "Fly GUI",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()

        WindUI:Notify({
            Title = "Fly",
            Content = "Fly GUI berhasil dijalankan ✅",
            Duration = 3,
            Icon = "bell"
        })
    end
})

---------------- END OF PLAYER ------------------
local VirtualInputManager = game:GetService("VirtualInputManager")

task.spawn(function()
    local cycle = 0
    while true do
        
        local waitTime = math.random(600, 700)
        task.wait(waitTime)
        local keyCombos = {
            {Enum.KeyCode.LeftShift, Enum.KeyCode.E},    
            {Enum.KeyCode.LeftControl, Enum.KeyCode.F},                
            {Enum.KeyCode.LeftShift, Enum.KeyCode.Q},     
            {Enum.KeyCode.E, Enum.KeyCode.F},             
        }
        
        local chosenCombo = keyCombos[math.random(1, #keyCombos)]
        pcall(function()
            for _, key in pairs(chosenCombo) do
                VirtualInputManager:SendKeyEvent(true, key, false, nil)
            end
            
            task.wait(0.1) 
                for _, key in pairs(chosenCombo) do
                VirtualInputManager:SendKeyEvent(false, key, false, nil)
            end
        end)        
    end
end)

local Section = Auto:Section({ 
    Title = "Main Feature",
})

-- Script untuk teleport ke zombie dengan Tween dan spam remote event
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Remote event untuk mengaktifkan senjata
local toolService = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages")
    :WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService")
    :WaitForChild("RF"):WaitForChild("ToolActivated")

-- Konfigurasi
local TELEPORT_SPEED = 80 -- Kecepatan teleport (unit per detik) - dipercepat
local ATTACK_COOLDOWN = 0.1 -- Cooldown antara spam attack
local CHECK_INTERVAL = 0.3 -- Interval cek zombie masih hidup (dipersingkat)
local SAFE_DISTANCE = 3 -- Jarak aman dari zombie (di bawah kaki)
local MAX_TELEPORT_RETRIES = 3 -- Maksimal percobaan teleport

-- Variabel kontrol
local TARGET_ZOMBIES = { "Zombie" }
local AUTO_FARM = false
local isRunning = false
local currentSpamConnection = nil
local connections = {}
local currentTargetZombie = nil
local teleportRetryCount = 0

-- Fungsi untuk membersihkan koneksi
function cleanupConnections()
    if currentSpamConnection then
        currentSpamConnection:Disconnect()
        currentSpamConnection = nil
    end
    
    for _, connection in pairs(connections) do
        if connection then
            connection:Disconnect()
        end
    end
    connections = {}
    currentTargetZombie = nil
    teleportRetryCount = 0
end

-- FUNGSI YANG DIPERBAIKI: Filter zombie yang lebih akurat
function findZombies()
    local zombies = {}
    
    -- Cari semua zombie di folder Living
    local livingFolder = workspace:FindFirstChild("Living")
    if not livingFolder then
        return zombies
    end
    
    for _, child in pairs(livingFolder:GetChildren()) do
        -- Cek apakah ini zombie
        local isZombieModel = false
        
        -- Filter berdasarkan TARGET_ZOMBIES dengan exact match atau prefix
        for _, zombieType in pairs(TARGET_ZOMBIES) do
            -- PERBAIKAN 1: Exact match untuk "Zombie" saja
            if zombieType == "Zombie" then
                if child.Name == "Zombie" then
                    isZombieModel = true
                    break
                end
            -- PERBAIKAN 2: Cek awalan untuk zombie jenis lainnya
            elseif child.Name:find(zombieType) == 1 then -- Cek di awal nama
                isZombieModel = true
                break
            end
        end
        
        if isZombieModel then
            -- Cek apakah zombie masih hidup (ada Humanoid)
            local humanoid = child:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                table.insert(zombies, child)
            end
        end
    end
    
    -- Urutkan berdasarkan jarak terdekat
    local charPos = character and character:GetPivot().Position
    if not charPos then return zombies end
    
    table.sort(zombies, function(a, b)
        local posA = a:GetPivot().Position
        local posB = b:GetPivot().Position
        return (posA - charPos).Magnitude < (posB - charPos).Magnitude
    end)
    
    return zombies
end

-- FUNGSI BARU: Posisi di BAWAH kaki zombie (lebih aman)
function getSafePositionUnderZombie(zombie)
    if not zombie then return nil end
    
    local zombieRoot = zombie:FindFirstChild("HumanoidRootPart")
    if not zombieRoot then
        return CFrame.new(zombie:GetPivot().Position + Vector3.new(0, -3, 0))
    end
    
    -- Ambil posisi zombie
    local zombiePos = zombieRoot.Position
    
    -- Hitung posisi di BAWAH zombie (bukan di belakang)
    -- Cari arah dari zombie ke karakter atau random direction
    local direction
    if character and character:FindFirstChild("HumanoidRootPart") then
        direction = (character.HumanoidRootPart.Position - zombiePos).Unit
    else
        -- Random direction jika karakter tidak ada
        direction = Vector3.new(math.random() - 0.5, 0, math.random() - 0.5).Unit
    end
    
    -- Posisi di bawah kaki zombie dengan offset horizontal kecil
    local offset = Vector3.new(direction.X * SAFE_DISTANCE, -3, direction.Z * SAFE_DISTANCE)
    return CFrame.new(zombiePos + offset)
end

-- FUNGSI DIPERBAIKI: Teleport dengan auto-tracking
function teleportToZombie(zombie)
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local humanoidRootPart = character.HumanoidRootPart
    
    -- Simpan target saat ini
    currentTargetZombie = zombie
    
    -- Hitung posisi target
    local targetPosition = getSafePositionUnderZombie(zombie)
    if not targetPosition then return false end
    
    -- Hitung jarak dan durasi
    local distance = (targetPosition.Position - humanoidRootPart.Position).Magnitude
    local duration = math.min(distance / TELEPORT_SPEED, 1.5) -- Maksimal 1.5 detik
    
    if duration <= 0 then return true end
    
    -- Non-collide sementara
    local originalCollision = humanoidRootPart.CanCollide
    humanoidRootPart.CanCollide = false
    
    -- Connection untuk membatalkan jika zombie hilang
    local zombieCheckConnection
    zombieCheckConnection = RunService.Heartbeat:Connect(function()
        if not zombie or not zombie:IsDescendantOf(workspace) then
            if zombieCheckConnection then
                zombieCheckConnection:Disconnect()
            end
            currentTargetZombie = nil
        end
    end)
    
    table.insert(connections, zombieCheckConnection)
    
    -- FUNGSI BARU: Smooth teleport dengan lerp (lebih responsive)
    local startTime = tick()
    local startPos = humanoidRootPart.CFrame
    
    while tick() - startTime < duration and AUTO_FARM do
        if not zombie or not zombie:IsDescendantOf(workspace) then
            break
        end
        
        -- Update target position (zombie mungkin bergerak)
        local updatedTargetPos = getSafePositionUnderZombie(zombie)
        if updatedTargetPos then
            targetPosition = updatedTargetPos
        end
        
        -- Calculate lerp
        local alpha = (tick() - startTime) / duration
        alpha = math.min(alpha, 1)
        
        -- Smooth movement
        local newCFrame = startPos:Lerp(targetPosition, alpha)
        humanoidRootPart.CFrame = newCFrame
        
        task.wait()
    end
    
    -- Set final position
    if zombie and zombie:IsDescendantOf(workspace) then
        local finalTargetPos = getSafePositionUnderZombie(zombie)
        if finalTargetPos then
            humanoidRootPart.CFrame = finalTargetPos
        end
        teleportRetryCount = 0 -- Reset retry counter jika berhasil
    else
        teleportRetryCount = teleportRetryCount + 1
    end
    
    -- Kembalikan collision
    humanoidRootPart.CanCollide = originalCollision
    
    if zombieCheckConnection then
        zombieCheckConnection:Disconnect()
    end
    
    return zombie and zombie:IsDescendantOf(workspace)
end

-- FUNGSI DIPERBAIKI: Spam attack dengan auto-positioning
function spamAttack()
    local args = {"Weapon"}
    
    local spamConnection
    spamConnection = RunService.Heartbeat:Connect(function()
        if not AUTO_FARM then
            spamConnection:Disconnect()
            return
        end
        
        -- Cek apakah karakter masih hidup
        if not character or not character:FindFirstChild("Humanoid") or character.Humanoid.Health <= 0 then
            return
        end
        
        -- AUTO-REPOSITIONING: Jika ada target zombie, selalu update posisi
        if currentTargetZombie and currentTargetZombie:IsDescendantOf(workspace) then
            local zombieHumanoid = currentTargetZombie:FindFirstChild("Humanoid")
            if zombieHumanoid and zombieHumanoid.Health > 0 then
                -- Cek jarak ke zombie
                local charPos = character:GetPivot().Position
                local zombiePos = currentTargetZombie:GetPivot().Position
                local distance = (zombiePos - charPos).Magnitude
                
                -- Jika terlalu jauh, teleport ulang
                if distance > 10 then
                    teleportToZombie(currentTargetZombie)
                end
            end
        end
        
        -- Invoke server dengan argument "Weapon"
        local success, result = pcall(function()
            return toolService:InvokeServer(unpack(args))
        end)
        
        if not success then
            warn("Gagal invoke server:", result)
        end
        
        task.wait(ATTACK_COOLDOWN)
    end)
    
    return spamConnection
end

-- FUNGSI DIPERBAIKI: Main hunting loop dengan auto-tracking
function zombieHunter()
    print("Memulai zombie hunter...")
    print("Target zombie:", table.concat(TARGET_ZOMBIES, ", "))
    isRunning = true
    
    while AUTO_FARM do
        -- Tunggu sampai character ada dan sehat
        if not character or not character.Parent or not character:FindFirstChild("Humanoid") then
            character = player.Character or player.CharacterAdded:Wait()
            task.wait(2) -- Tunggu karakter spawn lengkap
            if not AUTO_FARM then break end
        end
        
        -- Cek kesehatan karakter
        if character.Humanoid.Health <= 0 then
            print("Karakter mati, menunggu respawn...")
            task.wait(5)
            character = player.Character or player.CharacterAdded:Wait()
            task.wait(2)
        end
        
        -- Cari zombie
        local zombies = findZombies()
        
        if #zombies == 0 then
            print("Tidak ada " .. table.concat(TARGET_ZOMBIES, "/") .. " yang ditemukan, menunggu...")
            task.wait(1)
        else
            -- Pilih target zombie
            local targetZombie = zombies[1]
            
            -- Skip jika ini zombie yang sama dan masih hidup
            if currentTargetZombie and currentTargetZombie == targetZombie and 
               currentTargetZombie:IsDescendantOf(workspace) then
                local zombieHumanoid = currentTargetZombie:FindFirstChild("Humanoid")
                if zombieHumanoid and zombieHumanoid.Health > 0 then
                    -- Lanjutkan attack saja, sudah di posisi yang benar
                    task.wait(CHECK_INTERVAL)
                    continue
                end
            end
            
            print("Menargetkan zombie:", targetZombie.Name)
            
            -- Stop spam attack sebelumnya jika ada
            if currentSpamConnection then
                currentSpamConnection:Disconnect()
                currentSpamConnection = nil
            end
            
            -- Teleport ke zombie dengan retry mechanism
            local teleportSuccess = false
            for attempt = 1, MAX_TELEPORT_RETRIES do
                if not AUTO_FARM then break end
                
                teleportSuccess = teleportToZombie(targetZombie)
                
                if teleportSuccess then
                    print("Berhasil teleport ke", targetZombie.Name)
                    break
                else
                    print("Percobaan teleport ke-" .. attempt .. " gagal")
                    task.wait(0.5)
                end
            end
            
            if teleportSuccess and AUTO_FARM then
                -- Mulai spam attack
                currentSpamConnection = spamAttack()
                
                -- Monitor zombie dan auto-reposition
                while AUTO_FARM and targetZombie:IsDescendantOf(workspace) do
                    local humanoid = targetZombie:FindFirstChild("Humanoid")
                    if not humanoid or humanoid.Health <= 0 then
                        break
                    end
                    
                    -- Auto-reposition check
                    local charPos = character:GetPivot().Position
                    local zombiePos = targetZombie:GetPivot().Position
                    local distance = (zombiePos - charPos).Magnitude
                    
                    -- Jika terlalu jauh, teleport ulang
                    if distance > 8 then
                        teleportToZombie(targetZombie)
                    end
                    
                    task.wait(CHECK_INTERVAL)
                end
                
                -- Stop spam attack
                if currentSpamConnection then
                    currentSpamConnection:Disconnect()
                    currentSpamConnection = nil
                end
                
                print("Zombie", targetZombie.Name, "telah mati, mencari target baru...")
                task.wait(0.5)
            else
                print("Gagal teleport ke zombie, mencari target lain...")
                task.wait(0.5)
            end
        end
        
        if AUTO_FARM then
            task.wait(0.1)
        end
    end
    
    isRunning = false
    cleanupConnections()
    print("Zombie hunter dihentikan.")
end

-- Handler untuk karakter mati
character.Destroying:Connect(function()
    print("Karakter hancur, menghentikan zombie hunter...")
    AUTO_FARM = false
    cleanupConnections()
end)

-- Handler untuk karakter baru
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    task.wait(2) -- Tunggu karakter spawn
    if AUTO_FARM and not isRunning then
        coroutine.wrap(zombieHunter)()
    end
end)

-- Fungsi untuk memulai/menghentikan auto farm
function toggleAutoFarm(state)
    AUTO_FARM = state
    if AUTO_FARM and not isRunning then
        cleanupConnections()
        teleportRetryCount = 0
        coroutine.wrap(zombieHunter)()
    elseif not AUTO_FARM then
        cleanupConnections()
    end
end

------------------------------
-- WINDUI INTEGRATION
------------------------------

-- Dropdown untuk pilih zombie
local ZombieDropdown = Auto:Dropdown({
    Title = "Target Zombie",
    Desc = "Pilih zombie yang ingin diburu",
    Values = { "Zombie", "Brute Zombie", "Delver Zombie", "Elite Zombie" },
    Value = { "Zombie" },
    Multi = true,
    AllowNone = false,
    Callback = function(selected)
        TARGET_ZOMBIES = selected
        print("Zombie terpilih:", game:GetService("HttpService"):JSONEncode(selected))
        
        WindUI:Notify({
            Title = "Target Diubah",
            Content = "Sekarang menargetkan: " .. table.concat(selected, ", "),
            Duration = 3,
            Icon = "target"
        })
    end
})

-- Toggle untuk auto farm
local AutoFarmToggle = Auto:Toggle({
    Title = "Auto Farm Zombies",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        toggleAutoFarm(state)
        if state then
            WindUI:Notify({
                Title = "Auto Farm Dimulai",
                Content = "Menargetkan: " .. table.concat(TARGET_ZOMBIES, ", "),
                Duration = 4,
                Icon = "play"
            })
        else
            WindUI:Notify({
                Title = "Auto Farm Dihentikan",
                Content = "Auto farm telah dimatikan",
                Duration = 3,
                Icon = "stop"
            })
        end
    end
})

print("Zombie Hunter Script loaded successfully!")
