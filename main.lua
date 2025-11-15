-- Universal Script - Красивое меню с анимациями
local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Удаляем старое GUI если есть
if CoreGui:FindFirstChild("UniversalScript_GUI") then
    CoreGui:FindFirstChild("UniversalScript_GUI"):Destroy()
end

-- Создаем основное GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalScript_GUI"
ScreenGui.Parent = CoreGui

-- Главный контейнер
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 600, 0, 400)
MainContainer.Position = UDim2.new(0.5, -300, 0.5, -200)
MainContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainContainer.BorderSizePixel = 0
MainContainer.ClipsDescendants = true
MainContainer.Parent = ScreenGui

-- Скругление углов
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainContainer

-- Тень
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(60, 60, 60)
UIStroke.Parent = MainContainer

-- Боковая панель
local SidePanel = Instance.new("Frame")
SidePanel.Size = UDim2.new(0, 150, 1, 0)
SidePanel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SidePanel.BorderSizePixel = 0
SidePanel.Parent = MainContainer

local SidePanelCorner = Instance.new("UICorner")
SidePanelCorner.CornerRadius = UDim.new(0, 12)
SidePanelCorner.Parent = SidePanel

-- Заголовок боковой панели
local SideTitle = Instance.new("TextLabel")
SideTitle.Size = UDim2.new(1, 0, 0, 60)
SideTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SideTitle.TextColor3 = Color3.new(1, 1, 1)
SideTitle.Text = "UNIVERSAL\nSCRIPT"
SideTitle.Font = Enum.Font.GothamBold
SideTitle.TextSize = 16
SideTitle.TextYAlignment = Enum.TextYAlignment.Center
SideTitle.Parent = SidePanel

-- Контейнер для кнопок навигации
local NavContainer = Instance.new("Frame")
NavContainer.Size = UDim2.new(1, 0, 1, -60)
NavContainer.Position = UDim2.new(0, 0, 0, 60)
NavContainer.BackgroundTransparency = 1
NavContainer.Parent = SidePanel

-- Основная область контента
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -150, 1, 0)
ContentArea.Position = UDim2.new(0, 150, 0, 0)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainContainer

-- Контейнеры для разных разделов
local Sections = {
    Movement = Instance.new("ScrollingFrame"),
    Visual = Instance.new("ScrollingFrame"),
    Combat = Instance.new("ScrollingFrame"),
    Misc = Instance.new("ScrollingFrame")
}

local CurrentSection = "Movement"

-- Функция создания раздела
local function CreateSection(name, displayName)
    local section = Instance.new("ScrollingFrame")
    section.Size = UDim2.new(1, 0, 1, 0)
    section.BackgroundTransparency = 1
    section.BorderSizePixel = 0
    section.ScrollBarThickness = 5
    section.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    section.Visible = (name == "Movement")
    section.Parent = ContentArea
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = section
    
    Sections[name] = section
    return section
end

-- Создаем разделы
CreateSection("Movement", "Движение")
CreateSection("Visual", "Визуал")
CreateSection("Combat", "Боевка")
CreateSection("Misc", "Разное")

-- Функция создания кнопки навигации
local function CreateNavButton(text, sectionName, position)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 40)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = text
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.AutoButtonColor = false
    button.Parent = NavContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local highlight = Instance.new("Frame")
    highlight.Size = UDim2.new(0, 4, 0.7, 0)
    highlight.Position = UDim2.new(0, 3, 0.15, 0)
    highlight.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    highlight.BorderSizePixel = 0
    highlight.Visible = (sectionName == "Movement")
    highlight.Parent = button
    
    local highlightCorner = Instance.new("UICorner")
    highlightCorner.CornerRadius = UDim.new(0, 2)
    highlightCorner.Parent = highlight
    
    button.MouseButton1Click:Connect(function()
        SwitchSection(sectionName)
    end)
    
    button.MouseEnter:Connect(function()
        if CurrentSection ~= sectionName then
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if CurrentSection ~= sectionName then
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        end
    end)
    
    return button
end

-- Функция переключения разделов
function SwitchSection(sectionName)
    if CurrentSection == sectionName then return end
    
    -- Анимация исчезновения текущего раздела
    local currentSection = Sections[CurrentSection]
    TweenService:Create(currentSection, TweenInfo.new(0.3), {Position = UDim2.new(1, 0, 0, 0)}):Play()
    
    -- Обновляем подсветку кнопок
    for _, button in pairs(NavContainer:GetChildren()) do
        if button:IsA("TextButton") then
            local highlight = button:FindFirstChildWhichIsA("Frame")
            if highlight then
                highlight.Visible = (button.Text == ({
                    Movement = "🎮 Движение",
                    Visual = "👁️ Визуал", 
                    Combat = "⚔️ Боевка",
                    Misc = "🔧 Разное"
                })[sectionName])
                
                if highlight.Visible then
                    TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
                else
                    TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                end
            end
        end
    end
    
    wait(0.3)
    currentSection.Visible = false
    
    -- Показываем новый раздел с анимацией
    local newSection = Sections[sectionName]
    newSection.Position = UDim2.new(-1, 0, 0, 0)
    newSection.Visible = true
    TweenService:Create(newSection, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    CurrentSection = sectionName
end

-- Создаем кнопки навигации
CreateNavButton("🎮 Движение", "Movement", UDim2.new(0.05, 0, 0, 10))
CreateNavButton("👁️ Визуал", "Visual", UDim2.new(0.05, 0, 0, 60))
CreateNavButton("⚔️ Боевка", "Combat", UDim2.new(0.05, 0, 0, 110))
CreateNavButton("🔧 Разное", "Misc", UDim2.new(0.05, 0, 0, 160))

-- Функция создания переключателя
local function CreateToggle(text, section, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.9, 0, 0, 50)
    container.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    container.BorderSizePixel = 0
    container.Parent = Sections[section]
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    label.Position = UDim2.new(0.05, 0, 0, 0)
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0, 50, 0, 25)
    toggleFrame.Position = UDim2.new(0.8, -25, 0.5, -12)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = container
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleFrame
    
    local toggleDot = Instance.new("Frame")
    toggleDot.Size = UDim2.new(0, 19, 0, 19)
    toggleDot.Position = UDim2.new(0, 3, 0.5, -9.5)
    toggleDot.BackgroundColor3 = Color3.new(1, 1, 1)
    toggleDot.BorderSizePixel = 0
    toggleDot.Parent = toggleFrame
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = toggleDot
    
    local isEnabled = false
    
    local function updateToggle()
        if isEnabled then
            TweenService:Create(toggleDot, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 28, 0.5, -9.5),
                BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            }):Play()
            TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(0, 100, 0)
            }):Play()
        else
            TweenService:Create(toggleDot, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 3, 0.5, -9.5),
                BackgroundColor3 = Color3.new(1, 1, 1)
            }):Play()
            TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            }):Play()
        end
    end
    
    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isEnabled = not isEnabled
            updateToggle()
            callback(isEnabled)
        end
    end)
    
    return {
        Set = function(value)
            isEnabled = value
            updateToggle()
        end
    }
end

-- Функция создания кнопки
local function CreateButton(text, section, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 45)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = text
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.AutoButtonColor = false
    button.Parent = Sections[section]
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        -- Анимация нажатия
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
        wait(0.1)
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
        
        callback()
    end)
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
    end)
    
    return button
end

-- Переменные состояний
local speedEnabled = false
local flyEnabled = false
local noclipEnabled = false
local espEnabled = false

-- === РАЗДЕЛ ДВИЖЕНИЯ ===
CreateToggle("Скорость x3", "Movement", function(enabled)
    speedEnabled = enabled
    if enabled then
        game:GetService("RunService").Heartbeat:Connect(function()
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid.WalkSpeed = 48
            end
        end)
    else
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

CreateToggle("Режим полета", "Movement", function(enabled)
    flyEnabled = enabled
    -- Код полета здесь
end)

CreateToggle("Ноклип", "Movement", function(enabled)
    noclipEnabled = enabled
    if enabled then
        game:GetService("RunService").Stepped:Connect(function()
            if Player.Character then
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

CreateButton("Телепорт вперед", "Movement", function()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = Player.Character.HumanoidRootPart
        local newPosition = hrp.Position + hrp.CFrame.LookVector * 50
        hrp.CFrame = CFrame.new(newPosition)
    end
end)

-- === РАЗДЕЛ ВИЗУАЛА ===
CreateToggle("ESP Игроков", "Visual", function(enabled)
    espEnabled = enabled
    if enabled then
        for _, target in pairs(game:GetService("Players"):GetPlayers()) do
            if target ~= Player and target.Character then
                local highlight = Instance.new("Highlight")
                highlight.Parent = target.Character
                highlight.FillColor = Color3.new(1, 0, 0)
            end
        end
    else
        for _, target in pairs(game:GetService("Players"):GetPlayers()) do
            if target.Character then
                local highlight = target.Character:FindFirstChildOfClass("Highlight")
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

CreateToggle("X-Ray режим", "Visual", function(enabled)
    if enabled then
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0.6
            end
        end
    else
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
    end
end)

-- === РАЗДЕЛ БОЕВКИ ===
CreateButton("Авто-кликер", "Combat", function()
    -- Код авто-кликера
end)

CreateButton("Тест ударов", "Combat", function()
    -- Код теста ударов
end)

-- === РАЗДЕЛ РАЗНОЕ ===
CreateButton("Тест RemoteEvents", "Misc", function()
    local count = 0
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            count = count + 1
            pcall(function() obj:FireServer("test") end)
        end
    end
    print("Протестировано RemoteEvents: " .. count)
end)

CreateButton("Поиск античита", "Misc", function()
    for _, obj in pairs(game:GetDescendants()) do
        if obj.Name:lower():find("anti") or obj.Name:lower():find("cheat") then
            print("Найден: " .. obj:GetFullName())
        end
    end
end)

CreateButton("Закрыть меню", "Misc", function()
    ScreenGui:Destroy()
end)

-- Перемещение окна
local dragging = false
local dragInput, dragStart, startPos

MainContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainContainer.Position
    end
end)

MainContainer.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainContainer.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("🎮 Universal Script загружен!")
print("📁 Используйте боковую панель для навигации")
