local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RunService = game:GetService("RunService")

-- 1. XOÁ MENU CŨ
if Player.PlayerGui:FindFirstChild("DerelictBypass") then
    Player.PlayerGui.DerelictBypass:Destroy()
end

-- 2. TẠO GIAO DIỆN
local sg = Instance.new("ScreenGui", Player.PlayerGui)
sg.Name = "DerelictBypass"
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
title.Text = "DERELICT BYPASS V2"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold

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

createToggle("BẤT TỬ (BYPASS)", UDim2.new(0, 10, 0, 40), "GodMode", Color3.fromRGB(0, 120, 255))
createToggle("VÔ HẠN STAMINA", UDim2.new(0, 10, 0, 80), "InfStamina", Color3.fromRGB(255, 150, 0))
createToggle("ONE HIT (INSTANT)", UDim2.new(0, 10, 0, 120), "OneHit", Color3.fromRGB(255, 0, 0))

-- 3. HỆ THỐNG BYPASS SÁT THƯƠNG
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- Chặn lệnh trừ máu từ quái vật (God Mode)
    if _G.GodMode and method == "FireServer" and tostring(self) == "DamageEvent" then
        if args[1] == Player.Character then return nil end
    end
    
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- 4. VÒNG LẶP HỖ TRỢ
RunService.Heartbeat:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        if _G.GodMode then Player.Character.Humanoid.Health = 100 end
        if _G.InfStamina then
            -- Thử tìm mọi biến liên quan đến thể lực
            for _, v in pairs(Player.Character:GetDescendants()) do
                if v.Name:find("Stamina") or v.Name:find("Energy") then v.Value = 100 end
            end
        end
    end
end)

-- 5. ONE HIT QUA TOUCHED
function dealOneHit(hit)
    if _G.OneHit and hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
        if hit.Parent.Name ~= Player.Name then
            hit.Parent.Humanoid.Health = -999999
        end
    end
end

function apply(char)
    char.ChildAdded:Connect(function(item)
        if item:IsA("Tool") then
            for _, v in pairs(item:GetDescendants()) do
                if v:IsA("BasePart") then v.Touched:Connect(dealOneHit) end
            end
        end
    end)
end

Player.CharacterAdded:Connect(apply)
if Player.Character then apply(Player.Character) end
print("BYPASS LOADED!")
