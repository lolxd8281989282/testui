local UILibrary = {}

function UILibrary.new(title)
    local self = {}
    
    -- Create ScreenGui with synapse support
    local gui = Instance.new("ScreenGui")
    gui.Name = "AdminPanel"
    gui.ResetOnSpawn = false
    
    -- Handle different exploit environments
    if syn then
        syn.protect_gui(gui)
        gui.Parent = game.CoreGui
    elseif gethui then
        gui.Parent = gethui()
    else
        gui.Parent = game:GetService("CoreGui")
    end
    
    -- Create main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 250, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = gui
    
    -- Create title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, 0, 1, 0)
    titleText.BackgroundTransparency = 1
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 14
    titleText.Font = Enum.Font.SourceSans
    titleText.Text = title or "Admin Panel"
    titleText.Parent = titleBar
    
    -- Create content area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, 0, 1, -30)
    contentArea.Position = UDim2.new(0, 0, 0, 30)
    contentArea.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    contentArea.BorderSizePixel = 0
    contentArea.Parent = mainFrame
    
    -- Create sections container
    local sectionsContainer = Instance.new("ScrollingFrame")
    sectionsContainer.Name = "SectionsContainer"
    sectionsContainer.Size = UDim2.new(1, -20, 1, -10)
    sectionsContainer.Position = UDim2.new(0, 10, 0, 5)
    sectionsContainer.BackgroundTransparency = 1
    sectionsContainer.ScrollBarThickness = 0
    sectionsContainer.Parent = contentArea
    
    local currentY = 0
    
    function self:AddLabel(text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 25)
        label.Position = UDim2.new(0, 0, 0, currentY)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.Font = Enum.Font.SourceSans
        label.Text = text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = sectionsContainer
        
        currentY = currentY + 30
        sectionsContainer.CanvasSize = UDim2.new(0, 0, 0, currentY)
    end
    
    function self:AddToggle(text, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, 0, 0, 25)
        toggleFrame.Position = UDim2.new(0, 0, 0, currentY)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.Parent = sectionsContainer
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.Font = Enum.Font.SourceSans
        label.Text = text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.3, 0, 1, 0)
        button.Position = UDim2.new(0.7, 0, 0, 0)
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Font = Enum.Font.SourceSans
        button.Text = "OFF"
        button.Parent = toggleFrame
        
        local enabled = false
        button.MouseButton1Click:Connect(function()
            enabled = not enabled
            button.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            button.Text = enabled and "ON" or "OFF"
            if callback then callback(enabled) end
        end)
        
        currentY = currentY + 30
        sectionsContainer.CanvasSize = UDim2.new(0, 0, 0, currentY)
    end
    
    function self:AddTextBox(text, callback)
        local textBoxFrame = Instance.new("Frame")
        textBoxFrame.Size = UDim2.new(1, 0, 0, 25)
        textBoxFrame.Position = UDim2.new(0, 0, 0, currentY)
        textBoxFrame.BackgroundTransparency = 1
        textBoxFrame.Parent = sectionsContainer
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.4, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.Font = Enum.Font.SourceSans
        label.Text = text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = textBoxFrame
        
        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(0.6, 0, 1, 0)
        textBox.Position = UDim2.new(0.4, 0, 0, 0)
        textBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        textBox.TextSize = 14
        textBox.Font = Enum.Font.SourceSans
        textBox.Text = ""
        textBox.PlaceholderText = "Enter text..."
        textBox.Parent = textBoxFrame
        
        textBox.FocusLost:Connect(function(enterPressed)
            if enterPressed and callback then
                callback(textBox.Text)
            end
        end)
        
        currentY = currentY + 30
        sectionsContainer.CanvasSize = UDim2.new(0, 0, 0, currentY)
    end
    
    function self:AddDropdown(text, options, callback)
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Size = UDim2.new(1, 0, 0, 25)
        dropdownFrame.Position = UDim2.new(0, 0, 0, currentY)
        dropdownFrame.BackgroundTransparency = 1
        dropdownFrame.Parent = sectionsContainer
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.4, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.Font = Enum.Font.SourceSans
        label.Text = text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = dropdownFrame
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.6, 0, 1, 0)
        button.Position = UDim2.new(0.4, 0, 0, 0)
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Font = Enum.Font.SourceSans
        button.Text = options[1] or "Select..."
        button.Parent = dropdownFrame
        
        currentY = currentY + 30
        sectionsContainer.CanvasSize = UDim2.new(0, 0, 0, currentY)
        
        -- Create dropdown menu
        local optionsFrame = Instance.new("Frame")
        optionsFrame.Size = UDim2.new(0.6, 0, 0, #options * 25)
        optionsFrame.Position = UDim2.new(0.4, 0, 1, 0)
        optionsFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        optionsFrame.Visible = false
        optionsFrame.ZIndex = 2
        optionsFrame.Parent = dropdownFrame
        
        for i, option in ipairs(options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Size = UDim2.new(1, 0, 0, 25)
            optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 25)
            optionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            optionButton.TextSize = 14
            optionButton.Font = Enum.Font.SourceSans
            optionButton.Text = option
            optionButton.ZIndex = 2
            optionButton.Parent = optionsFrame
            
            optionButton.MouseButton1Click:Connect(function()
                button.Text = option
                optionsFrame.Visible = false
                if callback then callback(option) end
            end)
        end
        
        button.MouseButton1Click:Connect(function()
            optionsFrame.Visible = not optionsFrame.Visible
        end)
    end
    
    return self
end

return UILibrary
