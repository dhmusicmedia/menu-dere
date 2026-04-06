local P = game.Players.LocalPlayer
local R = game:GetService("RunService")
_G.G, _G.S, _G.O = false, false, false

local sg = Instance.new("ScreenGui", P.PlayerGui)
sg.Name = "DerelictFix"
local f = Instance.new("Frame", sg)
f.Size, f.Position, f.Active, f.Draggable = UDim2.new(0,200,0,150), UDim2.new(0,50,0,50), true, true

local function t(n, p, v)
    local b = Instance.new("TextButton", f)
    b.Size, b.Position, b.Text = UDim2.new(1,0,0,40), p, n..": OFF"
    b.MouseButton1Click:Connect(function()
        _G[v] = not _G[v]
        b.Text = n..": "..(_G[v] and "ON" or "OFF")
        b.BackgroundColor3 = _G[v] and Color3.new(0,1,0) or Color3.new(1,1,1)
    end)
end
t("BAT TU", UDim2.new(0,0,0,0), "G")
t("STAMINA", UDim2.new(0,0,0,50), "S")
t("ONE HIT", UDim2.new(0,0,0,100), "O")

R.Heartbeat:Connect(function()
    local c = P.Character
    if c and c:FindFirstChild("Humanoid") then
        if _G.G then c.Humanoid.Health = c.Humanoid.MaxHealth end
        if _G.S then
            local st = c:FindFirstChild("Stamina") or c:FindFirstChild("Energy")
            if st then st.Value = 100 end
        end
    end
end)

local function dmg(h)
    if _G.O and h.Parent and h.Parent:FindFirstChild("Humanoid") and h.Parent.Name ~= P.Name then
        h.Parent.Humanoid.Health = 0
    end
end

P.CharacterAdded:Connect(function(c)
    c.DescendantAdded:Connect(dmg)
end)
if P.Character then 
    for _, v in pairs(P.Character:GetDescendants()) do if v:IsA("BasePart") then v.Touched:Connect(dmg) end end 
end
print("DONE")
