local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local PlayerGui = Player:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("DerelictFinal") then
    PlayerGui.DerelictFinal:Destroy()
end

local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "DerelictFinal"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 220, 0, 180)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "DERELICT HUB PRO"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16

_G.GodMode = false
_G.OneHit = false
_G.InfStamina = false

local function createButton(txt, pos, varName, color)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = txt .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        btn.Text = txt .. ": " .. (_G[varName] and "ON" or "OFF")
        btn.BackgroundColor3 = _G[varName] and color or Color3.fromRGB(40, 40, 40)
    end)
end

createButton("BẤT TỬ", UDim2.new(0, 10, 0, 45), "GodMode", Color3.fromRGB(0, 100, 200))
createButton("VÔ HẠN STAMINA", UDim2.new(0, 10, 0, 90), "InfStamina", Color3.fromRGB(200, 150, 0))
createButton("ONE HIT DAME", UDim2.new(0, 10, 0, 135), "OneHit", Color3.fromRGB(150, 0, 0))

RunService.Heartbeat:Connect(function()
    local char = Player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if _G.GodMode then hum.Health = hum.MaxHealth end
            if _G.InfStamina then
                local s = char:FindFirstChild("Stamina") or char:FindFirstChild("Energy") or hum:FindFirstChild("Stamina")
                if s and (s:IsA("NumberValue") or s:IsA("IntValue")) then s.Value = 100 end
            end
        end
    end
end)

local function apply(obj)
    if obj:IsA("BasePart") then
        obj.Touched:Connect(function(hit)
            if _G.OneHit and hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
                if hit.Parent.Name ~= Player.Name then
                    hit.Parent.Humanoid.Health = 0
                end
            end
        end)
    end
end

local function setup(char)
    for _, v in pairs(char:GetDescendants()) do apply(v) end
    char.ChildAdded:Connect(function(i)
        for _, v in pairs(i:GetDescendants()) do apply(v) end
    end)
end

Player.CharacterAdded:Connect(setup)
if Player.Character then setup(Player.Character) end
print("Script Loaded Successfully!")
