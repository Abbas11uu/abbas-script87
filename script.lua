-- // الإعدادات العامة
_G.ESP_Toggle = true
_G.Hitbox_Toggle = true
_G.Reach_Size = 25

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // تنظيف أي سكريبت قديم
if CoreGui:FindFirstChild("SuriHub") then CoreGui.SuriHub:Destroy() end

-- // 1. إنشاء الواجهة (GUI)
local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "SuriHub"

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 180, 0, 160)
frame.Position = UDim2.new(0, 50, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Suri Ultimate Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1

local function createBtn(text, pos, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.8, 0, 0, 30)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local espBtn = createBtn("ESP: ON", UDim2.new(0.1, 0, 0.25, 0), function()
    _G.ESP_Toggle = not _G.ESP_Toggle
end)

local hitBtn = createBtn("Hitbox: ON", UDim2.new(0.1, 0, 0.55, 0), function()
    _G.Hitbox_Toggle = not _G.Hitbox_Toggle
end)

-- // 2. نظام الـ ESP المتكامل (Highlight + Name + Distance + Tracers)
local function addESP(player)
    if player == LocalPlayer then return end

    local function apply()
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart", 10)
        
        -- التوهج (Highlight)
        local hl = Instance.new("Highlight", char)
        hl.Name = "SuriHL"
        hl.FillColor = Color3.fromRGB(255, 0, 0)
        hl.OutlineColor = Color3.new(1, 1, 1)

        -- الاسم والمسافة (Billboard)
        local bb = Instance.new("BillboardGui", char:WaitForChild("Head"))
        bb.Name = "SuriBB"
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 100, 0, 50)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        local lbl = Instance.new("TextLabel", bb)
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.new(1, 1, 1)
        lbl.Font = Enum.Font.GothamBold

        -- الخطوط (Tracers)
        local line = Drawing.new("Line")
        line.Color = Color3.new(1, 1, 1)
        line.Thickness = 1

        RunService.RenderStepped:Connect(function()
            if char and char:FindFirstChild("HumanoidRootPart") and _G.ESP_Toggle then
                hl.Enabled = true
                bb.Enabled = true
                local dist = math.floor((root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                lbl.Text = player.Name .. "\n[" .. dist .. "m]"
                
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    line.To = Vector2.new(pos.X, pos.Y)
                    line.Visible = true
                else
                    line.Visible = false
                end
            else
                hl.Enabled = false
                bb.Enabled = false
                line.Visible = false
            end
        end)
    end
    apply()
    player.CharacterAdded:Connect(apply)
end

-- // 3. الهيت بوكس الدقيق (Hitbox)
RunService.RenderStepped:Connect(function()
    if not _G.Hitbox_Toggle then return end
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = p.Character.HumanoidRootPart
            local dist = (targetRoot.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            
            if dist <= _G.Reach_Size then
                local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
                if handle and firetouchinterest then
                    firetouchinterest(handle, targetRoot, 0)
                    firetouchinterest(handle, targetRoot, 1)
                end
            end
        end
    end
end)

-- تشغيل النظام للجميع
for _, p in pairs(Players:GetPlayers()) do addESP(p) end
Players.PlayerAdded:Connect(addESP)

-- تحديث ألوان الأزرار
spawn(function()
    while task.wait(0.1) do
        espBtn.BackgroundColor3 = _G.ESP_Toggle and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        hitBtn.BackgroundColor3 = _G.Hitbox_Toggle and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    end
end)
