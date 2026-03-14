--// SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// التبديلات البرمجية (Toggles)
_G.ESP_Enabled = false
_G.Radar_Enabled = false
_G.Hitbox_Enabled = false
_G.Tracers_Enabled = false

-- تنظيف أي نسخة قديمة
if CoreGui:FindFirstChild("SuriHub") then CoreGui.SuriHub:Destroy() end

--// SCREEN GUI
local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "SuriHub"

--// MAIN FRAME
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0,320,0,360)
main.Position = UDim2.new(0.5,-160,0.5,-180)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.Visible = true
Instance.new("UICorner",main).CornerRadius = UDim.new(0,8)

--// TOP BAR
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,40)
top.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner",top)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "SURI TACTICAL V3"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)

--// RADAR GUI (الرادار الدائري)
local radar = Instance.new("Frame", sg)
radar.Size = UDim2.new(0,140,0,140)
radar.Position = UDim2.new(0,20,0,100)
radar.BackgroundColor3 = Color3.new(0,0,0)
radar.BackgroundTransparency = 0.4
radar.Visible = false
Instance.new("UICorner", radar).CornerRadius = UDim.new(1,0)
local stroke = Instance.new("UIStroke", radar)
stroke.Color = Color3.new(0,1,0)

--// BUTTON AREA
local container = Instance.new("Frame", main)
container.Position = UDim2.new(0,10,0,50)
container.Size = UDim2.new(1,-20,1,-60)
container.BackgroundTransparency = 1
local layout = Instance.new("UIListLayout",container)
layout.Padding = UDim.new(0,8)

--// وظيفة إنشاء الأزرار مع الربط
local function createButton(text, callback)
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(1,0,0,45)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text .. ": OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner",btn)
    
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

--// ميزة فحص الرؤية (Visibility Check)
local function canSee(targetChar)
    if not targetChar:FindFirstChild("HumanoidRootPart") then return false end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {player.Character, targetChar}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local res = workspace:Raycast(Camera.CFrame.Position, targetChar.HumanoidRootPart.Position - Camera.CFrame.Position, params)
    return res == nil
end

--// نظام الـ ESP والرادار
local function applyESP(p)
    if p == player then return end
    p.CharacterAdded:Connect(function(char)
        task.wait(1)
        local hl = Instance.new("Highlight", char)
        local bb = Instance.new("BillboardGui", char:WaitForChild("Head"))
        bb.Size, bb.AlwaysOnTop = UDim2.new(0,100,0,50), true
        local lbl = Instance.new("TextLabel", bb)
        lbl.Size, lbl.BackgroundTransparency = UDim2.new(1,0,1,0), 1
        lbl.Font, lbl.TextSize = Enum.Font.GothamBold, 11

        local dot = Instance.new("Frame", radar)
        dot.Size = UDim2.new(0,4,0,4)
        Instance.new("UICorner", dot)

        RunService.RenderStepped:Connect(function()
            if char and char:Parent and _G.ESP_Enabled then
                hl.Enabled, bb.Enabled = true, true
                local isVis = canSee(char)
                local col = isVis and Color3.new(1,0,0) or Color3.new(0,1,0)
                hl.FillColor, lbl.TextColor3 = col, col
                local dist = math.floor((char.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude)
                lbl.Text = string.format("%s\n[%dm]\n%s", p.Name, dist, isVis and "DANGER" or "SAFE")
                
                if _G.Radar_Enabled then
                    dot.Visible = true
                    local rel = char.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position
                    dot.Position = UDim2.new(0.5, rel.X/6, 0.5, rel.Z/6)
                    dot.BackgroundColor3 = col
                else dot.Visible = false end
            else hl.Enabled, bb.Enabled, dot.Visible = false, false, false end
        end)
    end)
end

--// ربط الأزرار بالوظائف
createButton("ESP & VISIBILITY", function(b)
    _G.ESP_Enabled = not _G.ESP_Enabled
    b.Text = "ESP: " .. (_G.ESP_Enabled and "ON" or "OFF")
    b.BackgroundColor3 = _G.ESP_Enabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(35,35,35)
end)

createButton("TACTICAL RADAR", function(b)
    _G.Radar_Enabled = not _G.Radar_Enabled
    radar.Visible = _G.Radar_Enabled
    b.Text = "RADAR: " .. (_G.Radar_Enabled and "ON" or "OFF")
    b.BackgroundColor3 = _G.Radar_Enabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(35,35,35)
end)

createButton("SILENT HITBOX", function(b)
    _G.Hitbox_Enabled = not _G.Hitbox_Enabled
    b.Text = "HITBOX: " .. (_G.Hitbox_Enabled and "ON" or "OFF")
    b.BackgroundColor3 = _G.Hitbox_Enabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(35,35,35)
end)

createButton("CLOSE HUB", function() sg:Destroy() end)

--// حلقة الهيت بوكس (الضرب التلقائي)
RunService.RenderStepped:Connect(function()
    if _G.Hitbox_Enabled and player.Character then
        local tool = player.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if (p.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude < 25 then
                        firetouchinterest(tool:FindFirstChildWhichIsA("BasePart"), p.Character.HumanoidRootPart, 0)
                        firetouchinterest(tool:FindFirstChildWhichIsA("BasePart"), p.Character.HumanoidRootPart, 1)
                    end
                end
            end
        end
    end
end)

for _, p in pairs(Players:GetPlayers()) do applyESP(p) end
Players.PlayerAdded:Connect(applyESP)
