local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Xóa Menu cũ
if Player.PlayerGui:FindFirstChild("DerelictUltimate") then
    Player.PlayerGui.DerelictUltimate:Destroy()
end

-- TẠO GIAO DIỆN
local sg = Instance.new("ScreenGui", Player.PlayerGui)
sg.Name = "DerelictUltimate"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 220, 0, 170)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "DERELICT HUB PRO"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16

_G.GodMode = false
_G.OneHit = false
_G.InfStamina = false

local function createToggle(name, pos, varName, onColor)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        btn.Text = name .. ": " .. (_G[varName] and "ON" or "OFF")
        btn.BackgroundColor3 = _G[varName] and onColor or Color3.fromRGB(45, 45, 45)
    end)
end

createToggle("BẤT TỬ", UDim2.new(0, 10, 0, 40), "GodMode", Color3.fromRGB(0, 120, 255))
createToggle("VÔ HẠN STAMINA", UDim2.new(0, 10, 0, 80), "InfStamina", Color3.fromRGB(255, 150, 0))
createToggle("ONE HIT DAME", UDim2.new(0, 10, 0, 120), "OneHit", Color3.fromRGB(200, 0, 0))

-- VÒNG LẶP XỬ LÝ (Dùng Heartbeat để chạy nhanh nhất)
RunService.Heartbeat:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        local hum = Player.Character.Humanoid
        
        -- Bất tử: Ép máu luôn đầy
        if _G.GodMode then
            hum.Health = hum.MaxHealth
        end
        
        -- Vô hạn Năng lượng
        if _G.InfStamina then
            local s = Player.Character:FindFirstChild("Stamina") or Player.Character:FindFirstChild("Energy")
            if s and s:IsA("NumberValue") then s.Value = s.MaxValue or 100 end
        end
    end
end)

-- ONE HIT DAME (Gây sát thương cực lớn thay vì để bằng 0)
local function dealDamage(hit)
    if _G.OneHit and hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
        local target = hit.Parent.Humanoid
        if hit.Parent.Name ~= Player.Name then
            -- Gây 999 triệu sát thương để vượt qua bảo vệ của Boss
            target:TakeDamage(999999999) 
            if target.Health > 0 then target.Health = 0 end
        end
    end
end

local function apply(char)
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then v.Touched:Connect(dealDamage) end
    end
    char.ChildAdded:Connect(function(new)
        for _, v in pairs(new:GetDescendants()) do
            if v:IsA("BasePart") then v.Touched:Connect(dealDamage) end
        end
    end)
end

Player.CharacterAdded:Connect(apply)
if Player.Character then apply(Player.Character) end
print("DERELICT SCRIPT LOADED!")
