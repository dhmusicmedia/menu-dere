--[[
    DERELICT ULTIMATE HUB
    Tính năng: God Mode, One Hit Damage, Infinite Stamina
--]]

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Xóa Menu cũ
if PlayerGui:FindFirstChild("DerelictUltimate") then
    PlayerGui.DerelictUltimate:Destroy()
end

-- TẠO GIAO DIỆN
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "DerelictUltimate"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 220, 0, 170)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "DERELICT ULTIMATE"
title.TextColor3 = Color3.fromRGB(255, 215, 0) -- Màu vàng Gold
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- BIẾN TRẠNG THÁI
_G.GodMode = false
_G.OneHit = false
_G.InfStamina = false

-- HÀM TẠO NÚT BẤM
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
        if _G[varName] then
            btn.Text = name .. ": ON"
            btn.BackgroundColor3 = onColor
        else
            btn.Text = name .. ": OFF"
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end
    end)
end

createToggle("BẤT TỬ (GOD)", UDim2.new(0, 10, 0, 40), "GodMode", Color3.fromRGB(0, 120, 255))
createToggle("VÔ HẠN NĂNG LƯỢNG", UDim2.new(0, 10, 0, 80), "InfStamina", Color3.fromRGB(255, 150, 0))
createToggle("ONE HIT DAMAGE", UDim2.new(0, 10, 0, 120), "OneHit", Color3.fromRGB(200, 0, 0))

-- VÒNG LẶP HỆ THỐNG (Bất tử & Vô hạn Stamina)
RunService.Heartbeat:Connect(function()
    local char = Player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            -- Bất tử: Hồi máu cực nhanh
            if _G.GodMode then
                hum.Health = hum.MaxHealth
            end
            
            -- Vô hạn Năng lượng (Stamina)
            -- Trong Derelict, Stamina thường nằm trong giá trị gọi là 'Stamina' hoặc 'Energy' 
            -- Chúng ta sẽ quét các thuộc tính có tên tương tự
            if _G.InfStamina then
                local stamina = char:FindFirstChild("Stamina") or char:FindFirstChild("Energy") or char:FindFirstChild("Mana")
                if stamina and stamina:IsA("NumberValue") then
                    stamina.Value = 100 -- Hoặc giá trị tối đa của game
                end
            end
        end
    end
end)

-- LOGIC ONE HIT (Dame cực lớn)
local function applyHitbox(obj)
    if obj:IsA("BasePart") then
        obj.Touched:Connect(function(hit)
            if _G.OneHit and hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
                local target = hit.Parent.Humanoid
                if hit.Parent.Name ~= Player.Name then
                    target.Health = 0 -- Kết liễu ngay lập tức
                    -- Thử gây sát thương cực lớn nếu Health = 0 bị
