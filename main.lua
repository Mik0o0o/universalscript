-- Функция для отображения текста у всех игроков на сервере
local function ShowTextToAllPlayers(message, duration)
    duration = duration or 5 -- По умолчанию 5 секунд
    
    -- Используем RemoteEvent для отправки всем игрокам
    local textRemote = Instance.new("RemoteEvent")
    textRemote.Name = "ShowTextToAll"
    textRemote.Parent = ReplicatedStorage
    
    -- Функция, которая будет выполняться у каждого игрока
    local function showTextOnPlayer(player)
        if player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                -- Удаляем старый текст если есть
                local oldGui = humanoidRootPart:FindFirstChild("GlobalMessageGui")
                if oldGui then
                    oldGui:Destroy()
                end
                
                -- Создаем новый BillboardGui
                local billboardGui = Instance.new("BillboardGui")
                billboardGui.Name = "GlobalMessageGui"
                billboardGui.Size = UDim2.new(0, 300, 0, 80)
                billboardGui.AlwaysOnTop = true
                billboardGui.Enabled = true
                billboardGui.MaxDistance = 150
                billboardGui.SizeOffset = Vector2.new(0, 2.5)
                billboardGui.Parent = humanoidRootPart
                
                -- Фон
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.new(0, 0, 0)
                frame.BackgroundTransparency = 0.3
                frame.BorderSizePixel = 0
                frame.Parent = billboardGui
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 8)
                corner.Parent = frame
                
                -- Текст
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, -10, 1, -10)
                textLabel.Position = UDim2.new(0, 5, 0, 5)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = message
                textLabel.TextColor3 = Color3.new(1, 1, 1)
                textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                textLabel.TextStrokeTransparency = 0
                textLabel.TextScaled = true
                textLabel.Font = Enum.Font.GothamBold
                textLabel.TextWrapped = true
                textLabel.Parent = billboardGui
                
                -- Анимация появления
                billboardGui.StudsOffset = Vector3.new(0, 3, 0)
                TweenService:Create(billboardGui, TweenInfo.new(0.5), {
                    StudsOffset = Vector3.new(0, 5, 0)
                }):Play()
                
                -- Автоматическое удаление через указанное время
                delay(duration, function()
                    if billboardGui then
                        TweenService:Create(billboardGui, TweenInfo.new(0.5), {
                            StudsOffset = Vector3.new(0, 8, 0),
                            StudsOffsetWorldSpace = billboardGui.StudsOffsetWorldSpace
                        }):Play()
                        wait(0.5)
                        billboardGui:Destroy()
                    end
                end)
            end
        end
    end
    
    -- Отправляем всем игрокам
    textRemote:FireAllClients(message, duration)
    
    -- Показываем текст и себе
    showTextOnPlayer(Player)
    
    ShowNotification("Глобальный текст", "Сообщение отправлено всем игрокам", "success")
    
    -- Удаляем RemoteEvent после использования
    delay(2, function()
        if textRemote then
            textRemote:Destroy()
        end
    end)
end

-- Функция для удаления всего глобального текста у всех игроков
local function ClearAllText()
    local clearRemote = Instance.new("RemoteEvent")
    clearRemote.Name = "ClearAllText"
    clearRemote.Parent = ReplicatedStorage
    
    local function clearTextOnPlayer(player)
        if player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local gui = humanoidRootPart:FindFirstChild("GlobalMessageGui")
                if gui then
                    gui:Destroy()
                end
            end
        end
    end
    
    -- Отправляем команду очистки всем
    clearRemote:FireAllClients()
    
    -- Очищаем у себя
    clearTextOnPlayer(Player)
    
    ShowNotification("Глобальный текст", "Все сообщения удалены у всех игроков", "warning")
    
    delay(2, function()
        if clearRemote then
            clearRemote:Destroy()
        end
    end)
end
