-- Universal Script - Комплексный тест античита
local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalScript_GUI"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Text = "Universal Script - AntiCheat Test"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

-- Контейнер для кнопок
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -10, 1, -50)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 45)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 1000)
ScrollingFrame.ScrollBarThickness = 5
ScrollingFrame.Parent = MainFrame

-- Функция создания кнопки
local function CreateButton(text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 35)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = text
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = ScrollingFrame
    
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Переменные состояний
local speedEnabled = false
local flyEnabled = false
local noclipEnabled = false
local espEnabled = false
local xrayEnabled = false

-- 1. ТЕСТ СКОРОСТИ И ПЕРЕМЕЩЕНИЯ
CreateButton("🏃‍♂️ Скорость x3", UDim2.new(0, 5, 0, 10), function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        local conn = game:GetService("RunService").Heartbeat:Connect(function()
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid.WalkSpeed = 48
                Player.Character.Humanoid.JumpPower = 100
            end
        end)
        print("✅ Скорость и прыжок активированы")
    else
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = 16
            Player.Character.Humanoid.JumpPower = 50
        end
        print("❌ Скорость отключена")
    end
end)

-- 2. ТЕСТ ПОЛЕТА
CreateButton("🕊️ Включить полет", UDim2.new(0, 5, 0, 55), function()
    flyEnabled = not flyEnabled
    if flyEnabled then
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
        
        local BodyGyro = Instance.new("BodyGyro")
        local BodyVelocity = Instance.new("BodyVelocity")
        
        BodyGyro.Parent = HumanoidRootPart
        BodyVelocity.Parent = HumanoidRootPart
        
        BodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
        BodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        
        game:GetService("UserInputService").InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W then
                BodyVelocity.Velocity = HumanoidRootPart.CFrame.LookVector * 50
            elseif input.KeyCode == Enum.KeyCode.S then
                BodyVelocity.Velocity = -HumanoidRootPart.CFrame.LookVector * 50
            elseif input.KeyCode == Enum.KeyCode.A then
                BodyVelocity.Velocity = -HumanoidRootPart.CFrame.RightVector * 50
            elseif input.KeyCode == Enum.KeyCode.D then
                BodyVelocity.Velocity = HumanoidRootPart.CFrame.RightVector * 50
            elseif input.KeyCode == Enum.KeyCode.Space then
                BodyVelocity.Velocity = Vector3.new(0, 50, 0)
            elseif input.KeyCode == Enum.KeyCode.LeftShift then
                BodyVelocity.Velocity = Vector3.new(0, -50, 0)
            end
        end)
        
        print("✅ Полет активирован (WASD + Space/Shift)")
    else
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            for _, obj in pairs(Player.Character.HumanoidRootPart:GetChildren()) do
                if obj:IsA("BodyGyro") or obj:IsA("BodyVelocity") then
                    obj:Destroy()
                end
            end
        end
        print("❌ Полет отключен")
    end
end)

-- 3. ТЕСТ НОКЛИПА
CreateButton("👻 Включить ноклип", UDim2.new(0, 5, 0, 100), function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        local conn = game:GetService("RunService").Stepped:Connect(function()
            if noclipEnabled and Player.Character then
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        print("✅ Ноклип активирован")
    else
        if Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        print("❌ Ноклип отключен")
    end
end)

-- 4. ТЕСТ ESP (ПОДСВЕТКА ИГРОКОВ)
CreateButton("🎯 ESP Игроков", UDim2.new(0, 5, 0, 145), function()
    espEnabled = not espEnabled
    if espEnabled then
        for _, targetPlayer in pairs(game:GetService("Players"):GetPlayers()) do
            if targetPlayer ~= Player then
                coroutine.wrap(function()
                    local character = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESP_" .. targetPlayer.Name
                    highlight.Parent = character
                    highlight.FillColor = Color3.new(1, 0, 0)
                    highlight.OutlineColor = Color3.new(1, 1, 1)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                end)()
            end
        end
        print("✅ ESP активирован")
    else
        for _, targetPlayer in pairs(game:GetService("Players"):GetPlayers()) do
            if targetPlayer.Character then
                local esp = targetPlayer.Character:FindFirstChild("ESP_" .. targetPlayer.Name)
                if esp then
                    esp:Destroy()
                end
            end
        end
        print("❌ ESP отключен")
    end
end)

-- 5. ТЕСТ X-RAY
CreateButton("🔍 X-Ray режим", UDim2.new(0, 5, 0, 190), function()
    xrayEnabled = not xrayEnabled
    if xrayEnabled then
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency < 1 then
                part.Transparency = 0.6
            end
        end
        print("✅ X-Ray активирован")
    else
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
        print("❌ X-Ray отключен")
    end
end)

-- 6. ТЕСТ TELEPORT
CreateButton("✨ Телепорт вперед", UDim2.new(0, 5, 0, 235), function()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = Player.Character.HumanoidRootPart
        local newPosition = hrp.Position + hrp.CFrame.LookVector * 50
        hrp.CFrame = CFrame.new(newPosition)
        print("✅ Телепорт выполнен")
    end
end)

-- 7. ТЕСТ REMOTEEVENTS
CreateButton("⚡ Тест RemoteEvents", UDim2.new(0, 5, 0, 280), function()
    local count = 0
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            count = count + 1
            pcall(function()
                obj:FireServer("test_payload_" .. count)
                obj:FireServer({action = "test", data = "exploit"})
            end)
        end
    end
    print("✅ Протестировано RemoteEvents: " .. count)
end)

-- 8. ТЕСТ REMOTEFUNCTIONS
CreateButton("🔧 Тест RemoteFunctions", UDim2.new(0, 5, 0, 325), function()
    local count = 0
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteFunction") then
            count = count + 1
            pcall(function()
                obj:InvokeServer("test_invoke")
            end)
        end
    end
    print("✅ Протестировано RemoteFunctions: " .. count)
end)

-- 9. ПОИСК АНТИЧИТА
CreateButton("🛡️ Поиск античита", UDim2.new(0, 5, 0, 370), function()
    local found = false
    for _, obj in pairs(game:GetDescendants()) do
        local name = obj.Name:lower()
        if name:find("anti") or name:find("cheat") or name:find("ac") or name:find("security") then
            print("🔍 Найден: " .. obj:GetFullName())
            found = true
        end
    end
    if not found then
        print("❌ Античит не обнаружен")
    end
end)

-- 10. АВТО-КЛИКЕР
local autoClicker = false
CreateButton("🤖 Авто-кликер", UDim2.new(0, 5, 0, 415), function()
    autoClicker = not autoClicker
    if autoClicker then
        spawn(function()
            while autoClicker do
                task.wait(0.1)
                -- Симуляция клика
                local VirtualInputManager = game:GetService("VirtualInputManager")
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.1)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
        end)
        print("✅ Авто-кликер активирован")
    else
        print("❌ Авто-кликер отключен")
    end
end)

-- 11. АНТИ-АФК
local antiAFK = false
CreateButton("⏰ Анти-АФК", UDim2.new(0, 5, 0, 460), function()
    antiAFK = not antiAFK
    if antiAFK then
        local VirtualInputManager = game:GetService("VirtualInputManager")
        spawn(function()
            while antiAFK do
                task.wait(30)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
                print("🔄 Анти-АФК: движение выполнено")
            end
        end)
        print("✅ Анти-АФК активирован")
    else
        print("❌ Анти-АФК отключен")
    end
end)

-- 12. ИНФОРМАЦИЯ О СЕРВЕРЕ
CreateButton("📊 Инфо о сервере", UDim2.new(0, 5, 0, 505), function()
    local players = game:GetService("Players"):GetPlayers()
    local fps = math.round(1 / game:GetService("RunService").Heartbeat:Wait())
    
    print("=== ИНФОРМАЦИЯ О СЕРВЕРЕ ===")
    print("👥 Игроков: " .. #players)
    print("🎮 FPS: " .. fps)
    print("🆔 ID места: " .. game.PlaceId)
    print("🏷️ Название: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
end)

-- 13. ОЧИСТКА ЭФФЕКТОВ
CreateButton("🧹 Очистить эффекты", UDim2.new(0, 5, 0, 550), function()
    -- Очистка ESP
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player.Character then
            local esp = player.Character:FindFirstChild("ESP_" .. player.Name)
            if esp then esp:Destroy() end
        end
    end
    
    -- Восстановление прозрачности
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
        end
    end
    
    -- Восстановление скорости
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = 16
        Player.Character.Humanoid.JumpPower = 50
    end
    
    print("✅ Все эффекты очищены")
end)

-- 14. ЗАКРЫТЬ МЕНЮ
CreateButton("❌ Закрыть меню", UDim2.new(0, 5, 0, 595), function()
    ScreenGui:Destroy()
    print("✅ Меню закрыто")
end)

-- Перемещение окна
local dragging = false
local dragInput, dragStart, startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

print("=== Universal Script загружен ===")
print("✅ GUI создано")
print("🛡️ Готов к тестированию античита")
print("📝 Используйте кнопки для проверки защиты")

-- Автоматическое обновление при возрождении
Player.CharacterAdded:Connect(function(character)
    task.wait(2)
    print("🔁 Персонаж возрожден - эффекты сброшены")
end)
