-- BlockSpin GUI by Grok - Barra superior como en el video
-- Loadstring: loadstring(game:HttpGet("https://raw.githubusercontent.com/Tóxico0110/BlockSpinHub/main/BlockSpin.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local espT = true
local infJumpT = true
local speedT = true
local aimT = true
local speedValue = 45

-- =============== GUI BARRA SUPERIOR ===============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 60)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TopBar.BorderSizePixel = 0
TopBar.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔥 BLOCKSPIN HUB"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = TopBar

local function createTopButton(text, color, posX, toggle)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 0, 45)
    btn.Position = UDim2.new(0, posX, 0, 8)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = TopBar

    btn.MouseButton1Click:Connect(function()
        toggle = not toggle
        btn.BackgroundColor3 = toggle and color or Color3.fromRGB(80, 80, 80)
        btn.Text = text .. (toggle and " ✓" or " ✕")
    end)
    return btn
end

-- Botones como en el video
createTopButton("ESP", Color3.fromRGB(255, 255, 0), 220, espT)           -- Amarillo
createTopButton("Inf Jump", Color3.fromRGB(0, 170, 255), 340, infJumpT) -- Azul
createTopButton("Speed", Color3.fromRGB(0, 255, 100), 460, speedT)      -- Verde
createTopButton("Aimbot", Color3.fromRGB(255, 60, 60), 580, aimT)       -- Rojo

-- Botón para cerrar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 50, 0, 45)
closeBtn.Position = UDim2.new(1, -60, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.TextScaled = true
closeBtn.Parent = TopBar
closeBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- =============== ESP ===============
local function addESP(plr)
    if plr == LocalPlayer then return end
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hl = Instance.new("Highlight", char)
    hl.FillColor = Color3.fromRGB(255, 255, 0)
    hl.OutlineColor = Color3.fromRGB(255, 215, 0)
    hl.FillTransparency = 0.4
end

for _, p in Players:GetPlayers() do addESP(p) end
Players.PlayerAdded:Connect(addESP)

-- =============== INFINITE JUMP ===============
LocalPlayer.CharacterAdded:Connect(function(c)
    c:WaitForChild("Humanoid").JumpPower = 55
end)

RunService.Stepped:Connect(function()
    if infJumpT and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum and hum:GetState() == Enum.HumanoidStateType.Jumping then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- =============== SPEED ===============
RunService.Heartbeat:Connect(function()
    if speedT and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = speedValue end
    end
end)

-- =============== AIMBOT ===============
RunService.RenderStepped:Connect(function()
    if not aimT then return end
    local closest, minDist = nil, 9999
    for _, p in Players:GetPlayers() do
        if p ~= LocalPlayer and p.Character then
            local root = p.Character:FindFirstChild("HumanoidRootPart")
            local head = p.Character:FindFirstChild("Head")
            if root and head then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
                if dist < minDist and dist < 300 then
                    minDist = dist
                    closest = p
                end
            end
        end
    end
    if closest and closest.Character and closest.Character:FindFirstChild("Head") then
        Workspace.CurrentCamera.CFrame = CFrame.lookAt(Workspace.CurrentCamera.CFrame.Position, closest.Character.Head.Position)
    end
end)

game.StarterGui:SetCore("SendNotification", {
    Title = "BlockSpin Hub",
    Text = "Barra superior cargada ✓\nUsa los botones de colores",
    Duration = 7
})
