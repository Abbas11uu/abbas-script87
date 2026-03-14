--// SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- حذف نسخة قديمة
if CoreGui:FindFirstChild("SuriHub") then
    CoreGui.SuriHub:Destroy()
end

--// SCREEN GUI
local sg = Instance.new("ScreenGui")
sg.Name = "SuriHub"
sg.Parent = CoreGui

--// MAIN FRAME
local main = Instance.new("Frame")
main.Parent = sg
main.Size = UDim2.new(0,320,0,360)
main.Position = UDim2.new(0.5,-160,0.5,-180)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0

local corner = Instance.new("UICorner",main)
corner.CornerRadius = UDim.new(0,8)

--// TOP BAR
local top = Instance.new("Frame")
top.Parent = main
top.Size = UDim2.new(1,0,0,40)
top.BackgroundColor3 = Color3.fromRGB(25,25,25)
top.BorderSizePixel = 0

local topCorner = Instance.new("UICorner",top)
topCorner.CornerRadius = UDim.new(0,8)

-- TITLE
local title = Instance.new("TextLabel")
title.Parent = top
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "SURI HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)

--// CLOSE BUTTON
local close = Instance.new("TextButton")
close.Parent = top
close.Size = UDim2.new(0,40,0,40)
close.Position = UDim2.new(1,-40,0,0)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 16
close.TextColor3 = Color3.new(1,1,1)
close.BackgroundColor3 = Color3.fromRGB(170,40,40)
close.BorderSizePixel = 0

local closeCorner = Instance.new("UICorner",close)

--// BUTTON AREA
local container = Instance.new("Frame")
container.Parent = main
container.Position = UDim2.new(0,10,0,50)
container.Size = UDim2.new(1,-20,1,-60)
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout",container)
layout.Padding = UDim.new(0,8)

--// BUTTON FUNCTION
local function createButton(text)
    
    local btn = Instance.new("TextButton")
    btn.Parent = container
    btn.Size = UDim2.new(1,0,0,40)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    
    local c = Instance.new("UICorner",btn)
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    end)
    
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    end)

    return btn
end

--// BUTTONS
local btn1 = createButton("Feature 1")
local btn2 = createButton("Feature 2")
local btn3 = createButton("Feature 3")
local btn4 = createButton("Feature 4")
local btn5 = createButton("Feature 5")

--// OPEN BUTTON
local open = Instance.new("TextButton")
open.Parent = sg
open.Size = UDim2.new(0,120,0,40)
open.Position = UDim2.new(0,20,0.5,0)
open.Text = "OPEN HUB"
open.Font = Enum.Font.GothamBold
open.TextSize = 14
open.TextColor3 = Color3.new(1,1,1)
open.BackgroundColor3 = Color3.fromRGB(30,30,30)

local openCorner = Instance.new("UICorner",open)

--// OPEN / CLOSE
open.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

close.MouseButton1Click:Connect(function()
    main.Visible = false
end)

--// DRAG SYSTEM
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

top.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

print("SURI HUB LOADED")
