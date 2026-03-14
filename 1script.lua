local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

-- إحداثياتك التي سجلتها
local PathPoints = {
    Vector3.new(354.75, 18, -35.24),
    Vector3.new(153.62, 18, 312.77),
    Vector3.new(-248.79, 18, 312.64),
    Vector3.new(-449.17, 18, -35.34),
    Vector3.new(-248.96, 18, -382.90),
    Vector3.new(153.72, 18, -383.45),
    Vector3.new(354.79, 18, -34.86)
}

local isMoving = false
local currentTween = nil
local SPEED = 350

-- 1) إنشاء الواجهة مع خاصية عدم الاختفاء عند الموت
-- حذف أي نسخة قديمة من الواجهة لتجنب التكرار
if CoreGui:FindFirstChild("HexagonPathGui") then
    CoreGui.HexagonPathGui:Destroy()
end

local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "HexagonPathGui"
screenGui.ResetOnSpawn = false -- هذا السطر يمنع السكربت من الحذف عند الموت

local mainBtn = Instance.new("TextButton", screenGui)
mainBtn.Size = UDim2.new(0, 160, 0, 50)
mainBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
mainBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainBtn.Text = "START HEXAGON"
mainBtn.TextColor3 = Color3.new(1, 1, 1)
mainBtn.Font = Enum.Font.SourceSansBold
mainBtn.TextSize = 18
mainBtn.Draggable = true
mainBtn.Active = true

local corner = Instance.new("UICorner", mainBtn)
corner.CornerRadius = UDim.new(0, 8)

-- 2) دالة الحصول على الـ RootPart (تحدث تلقائياً عند الموت)
local function getRoot()
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

-- 3) دالة الحركة
local function walkTo(target)
    local root = getRoot()
    if not root or not isMoving then return end
    
    local dist = (root.Position - target).Magnitude
    local info = TweenInfo.new(dist/SPEED, Enum.EasingStyle.Linear)
    
    currentTween = TweenService:Create(root, info, {CFrame = CFrame.new(target)})
    currentTween:Play()
    currentTween.Completed:Wait()
end

-- 4) منطق التشغيل والإيقاف
local function stopPath()
    isMoving = false
    mainBtn.Text = "START HEXAGON"
    mainBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 80)
    if currentTween then currentTween:Cancel() end
end

local function startPath()
    isMoving = true
    mainBtn.Text = "STOP PATH"
    mainBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    
    task.spawn(function()
        while isMoving do
            for i = 1, #PathPoints do
                if not isMoving then break end
                walkTo(PathPoints[i])
                task.wait(0.1)
            end
        end
    end)
end

mainBtn.MouseButton1Click:Connect(function()
    if isMoving then
        stopPath()
    else
        startPath()
    end
end)

-- 5) حل مشكلة الموت: يطفي السكربت تلقائياً عند الموت وينتظر تشغيلك
player.CharacterAdded:Connect(function(char)
    -- عند عودة اللاعب للحياة، نتأكد أن الحالة "موقفة"
    stopPath()
    warn("تمت إعادة الإرساء.. السكربت بانتظار تشغيلك.")
end)

-- تأمين حالة الموت الحالية
local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
if humanoid then
    humanoid.Died:Connect(function()
        stopPath()
    end)
end

print("السكربت جاهز ومقاوم للموت!")
