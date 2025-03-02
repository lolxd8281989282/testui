local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local UILibrary = {}

function UILibrary.new()
    local self = {}
    
    -- Create ScreenGui
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = "AdminPanel"
    self.gui.ResetOnSpawn = false
    
    -- Create main frame
    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Name = "MainFrame"
    self.mainFrame.Size = UDim2.new(0, 300, 0, 400)
    self.mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    self.mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    self.mainFrame.BorderSizePixel = 0
    self.mainFrame.Active = true
    self.mainFrame.Draggable = true
    self.mainFrame.Parent = self.gui
    
    -- Create title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.SourceSansBold
    title.Text = "Admin Panel"
    title.Parent = self.mainFrame
    
    -- Create tab container
    self.tabContainer = Instance.new("Frame")
    self.tabContainer.Name = "TabContainer"
    self.tabContainer.Size = UDim2.new(1, 0, 1, -30)
    self.tabContainer.Position = UDim2.new(0, 0, 0, 30)
    self.tabContainer.BackgroundTransparency = 1
    self.tabContainer.Parent = self.mainFrame
    
    self.tabs = {}
    self.currentTab = nil
    
    function self:AddSection(name)
        local tab = {}
        
        tab.button = Instance.new("TextButton")
        tab.button.Name = name .. "Button"
        tab.button.Size = UDim2.new(0, 100, 0, 30)
        tab.button.Position = UDim2.new(0, #self.tabs * 100, 0, 0)
        tab.button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tab.button.TextColor3 = Color3.fromRGB(255, 255, 255)
        tab.button.TextSize = 14
        tab.button.Font = Enum.Font.SourceSans
        tab.button.Text = name
        tab.button.Parent = self.tabContainer
        
        tab.content = Instance.new("ScrollingFrame")
        tab.content.Name = name .. "Content"
        tab.content.Size = UDim2.new(1, 0, 1, -30)
        tab.content.Position = UDim2.new(0, 0, 0, 30)
        tab.content.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        tab.content.BorderSizePixel = 0
        tab.content.ScrollBarThickness = 4
        tab.content.Visible = false
        tab.content.Parent = self.tabContainer
        
        tab.button.MouseButton1Click:Connect(function()
            self:SelectSection(name)
        end)
        
        self.tabs[name] = tab
        
        if #self.tabs == 1 then
            self:SelectSection(name)
        end
        
        return tab
    end
    
    function self:SelectSection(name)
        for _, tab in pairs(self.tabs) do
            tab.content.Visible = false
            tab.button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
        
        self.tabs[name].content.Visible = true
        self.tabs[name].button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        self.currentTab = self.tabs[name]
    end
    
    function self:AddToggle(sectionName, text, callback)
        local toggle = Instance.new("Frame")
        toggle.Name = text .. "Toggle"
        toggle.Size = UDim2.new(1, -20, 0, 30)
        toggle.Position = UDim2.new(0, 10, 0, #self.tabs[sectionName].content:GetChildren() * 35)
        toggle.BackgroundTransparency = 1
        toggle.Parent = self.tabs[sectionName].content
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.Font = Enum.Font.SourceSans
        label.Text = text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggle
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.3, 0, 1, 0)
        button.Position = UDim2.new(0.7, 0, 0, 0)
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Font = Enum.Font.SourceSans
        button.Text = "OFF"
        button.Parent = toggle
        
        local toggled = false
        button.MouseButton1Click:Connect(function()
            toggled = not toggled
            button.BackgroundColor3 = toggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            button.Text = toggled and "ON" or "OFF"
            callback(toggled)
        end)
        
        self.tabs[sectionName].content.CanvasSize = UDim2.new(0, 0, 0, #self.tabs[sectionName].content:GetChildren() * 35)
    end
    
    function self:AddTextBox(sectionName, text, callback)
        local textBox = Instance.new("Frame")
        textBox.Name = text .. "TextBox"
        textBox.Size = UDim2.new(1, -20, 0, 30)
        textBox.Position = UDim2.new(0, 10, 0, #self.tabs[sectionName].content:GetChildren() * 35)
        textBox.BackgroundTransparency = 1
        textBox.Parent = self.tabs[sectionName].content
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.3, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.Font = Enum.Font.SourceSans
        label.Text = text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = textBox
        
        local input = Instance.new("TextBox")
        input.Size = UDim2.new(0.7, 0, 1, 0)
        input.Position = UDim2.new(0.3, 0, 0, 0)
        input.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        input.TextColor3 = Color3.fromRGB(255, 255, 255)
        input.TextSize = 14
        input.Font = Enum.Font.SourceSans
        input.Text = ""
        input.PlaceholderText = "Enter text..."
        input.Parent = textBox
        
        input.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                callback(input.Text)
            end
        end)
        
        self.tabs[sectionName].content.CanvasSize = UDim2.new(0, 0, 0, #self.tabs[sectionName].content:GetChildren() * 35)
    end
    
    function self:AddDropdown(sectionName, text, options, callback)
        local dropdown = Instance.new("Frame")
        dropdown.Name = text .. "Dropdown"
        dropdown.Size = UDim2.new(1, -20, 0, 30)
        dropdown.Position = UDim2.new(0, 10, 0, #self.tabs[sectionName].content:GetChildren() * 35)
        dropdown.BackgroundTransparency = 1
        dropdown.Parent = self.tabs[sectionName].content
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.3, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.Font = Enum.Font.SourceSans
        label.Text = text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = dropdown
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.7, 0, 1, 0)
        button.Position = UDim2.new(0.3, 0, 0, 0)
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Font = Enum.Font.SourceSans
        button.Text = "Select..."
        button.Parent = dropdown
        
        local optionFrame = Instance.new("Frame")
        optionFrame.Size = UDim2.new(0.7, 0, 0, #options * 30)
        optionFrame.Position = UDim2.new(0.3, 0, 1, 0)
        optionFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        optionFrame.Visible = false
        optionFrame.ZIndex = 2
        optionFrame.Parent = dropdown
        
        for i, option in ipairs(options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Size = UDim2.new(1, 0, 0, 30)
            optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
            optionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            optionButton.TextSize = 14
            optionButton.Font = Enum.Font.SourceSans
            optionButton.Text = option
            optionButton.Parent = optionFrame
            
            optionButton.MouseButton1Click:Connect(function()
                button.Text = option
                optionFrame.Visible = false
                callback(option)
            end)
        end
        
        button.MouseButton1Click:Connect(function()
            optionFrame.Visible = not optionFrame.Visible
        end)
        
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mousePosition = UserInputService:GetMouseLocation()
                if not dropdown.AbsolutePosition.X <= mousePosition.X and mousePosition.X <= dropdown.AbsolutePosition.X + dropdown.AbsoluteSize.X and
                   dropdown.AbsolutePosition.Y <= mousePosition.Y and mousePosition.Y <= dropdown.AbsolutePosition.Y + dropdown.AbsoluteSize.Y then
                    optionFrame.Visible = false
                end
            end
        end)
        
        self.tabs[sectionName].content.CanvasSize = UDim2.new(0, 0, 0, #self.tabs[sectionName].content:GetChildren() * 35)
    end
    
    -- Parent the ScreenGui to the correct location based on context
    local success, result = pcall(function()
        if game:GetService("RunService"):IsStudio() then
            self.gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        else
            self.gui.Parent = game:GetService("CoreGui")
        end
    end)
    
    if not success then
        warn("Failed to parent ScreenGui:", result)
        self.gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    return self
end

return UILibrary
