--========================================================--
--              JJD HUB V1 — Ultimate Reach               --
--========================================================--

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

--========================================================--
-- GUI
--========================================================--
local gui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
gui.Name = "JJD_HUB"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 320)
frame.Position = UDim2.new(0.7, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

-- سحب القائمة
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

--========================================================--
-- Title
--========================================================--
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "JJD HUB V1 — Ultimate Reach"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.TextScaled = true

--========================================================--
-- Buttons
--========================================================--
local reachBtn = Instance.new("TextButton", frame)
reachBtn.Size = UDim2.new(1,-20,0,40)
reachBtn.Position = UDim2.new(0,10,0,40)
reachBtn.Text = "تشغيل Reach (Infinite)"
reachBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
reachBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", reachBtn)

local counter = Instance.new("TextLabel", frame)
counter.Size = UDim2.new(1,-20,0,30)
counter.Position = UDim2.new(0,10,0,90)
counter.Text = "Bombs Given: 0"
counter.TextColor3 = Color3.fromRGB(255,255,0)
counter.BackgroundTransparency = 1
counter.TextScaled = true

--========================================================--
-- Message Animation
--========================================================--
local msg = Instance.new("TextLabel", gui)
msg.Size = UDim2.new(0, 300, 0, 40)
msg.Position = UDim2.new(0.5, -150, 0.1, 0)
msg.BackgroundTransparency = 1
msg.TextColor3 = Color3.fromRGB(0,255,0)
msg.TextScaled = true
msg.Visible = false

local function showMessage(text)
    msg.Text = text
    msg.Visible = true
    msg.TextTransparency = 1
    for i = 1, 10 do
        msg.TextTransparency = 1 - (i / 10)
        task.wait(0.03)
    end
    task.wait(1)
    for i = 1, 10 do
        msg.TextTransparency = i / 10
        task.wait(0.03)
    end
    msg.Visible = false
end

--========================================================--
-- FUNCTIONS
--========================================================--
local reachEnabled = false
local bombsGiven = 0

local function updateCounter()
    bombsGiven += 1
    counter.Text = "Bombs Given: " .. bombsGiven
end

local function isEnemy(plr)
    return plr.Team ~= localPlayer.Team
end

local function getEnemy()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= localPlayer and isEnemy(plr) and plr.Character then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if root then return plr, root end
        end
    end
    return nil
end

local function giveBomb(enemy)
    local backpack = localPlayer:FindFirstChild("Backpack")
    if not backpack then return end
    local tool = backpack:FindFirstChildOfClass("Tool")
    if not tool then return end
    tool.Parent = enemy:WaitForChild("Backpack")
    updateCounter()
    showMessage("✔ تم إعطاء القنبلة (Reach Infinite)")
end

--========================================================--
-- INFINITE REACH SYSTEM
--========================================================--
RunService.RenderStepped:Connect(function()
    if not reachEnabled then return end
    local enemy, enemyRoot = getEnemy()
    if not enemy then return end
    -- Reach لا نهائي: أي عدو داخل الماب
    giveBomb(enemy)
end)

--========================================================--
-- BUTTONS
--========================================================--
reachBtn.MouseButton1Click:Connect(function()
    reachEnabled = not reachEnabled
    reachBtn.Text = reachEnabled and "Reach: شغال (Infinite)" or "تشغيل Reach"
    showMessage(reachEnabled and "✔ Reach شغال" or "✖ Reach متوقف")
end)
