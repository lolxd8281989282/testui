-- Create the UI Library
local UILibrary = {}

function UILibrary.new()
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
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = gui
    
    -- Create sections container
    local sectionsContainer = Instance.new("Frame")
    sectionsContainer.Name = "SectionsContainer"
    sectionsContainer.Size = UDim2.new(1, 0, 1, -30)
    sectionsContainer.Position = UDim2.new(0, 0, 0, 30)
    sectionsContainer.BackgroundTransparency = 1
    sectionsContainer.Parent = mainFrame
    
    -- Create title bar
    local titleBar = Instance.new("TextLabel")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleBar.TextSize = 14
    titleBar.Font = Enum.Font.SourceSansBold
    titleBar.Text = "Admin Panel"
    titleBar.Parent = mainFrame
    
    self.sections = {}
    self.currentSection = nil
    
    function self:AddSection(name)
        local section = {}
        
        -- Create section button
        section.button = Instance.new("TextButton")
        section.button.Name = name.."Button"
        section.button.Size = UDim2.new(0, 100, 0, 30)
        section.button.Position = UDim2.new(0, #self.sections * 100, 0, 0)
        section.button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        section.button.TextColor3 = Color3.fromRGB(255, 255, 255)
        section.button.TextSize = 14
        section.button.Font = Enum.Font.SourceSans
        section.button.Text = name
        section.button.Parent = sectionsContainer
        
        -- Create section content
        section.content = Instance.new("ScrollingFrame")
        section.content.Name = name.."Content"
        section.content.Size = UDim2.new(1, 0, 1, -30)
        section.content.Position = UDim2.new(0, 0, 0, 30)
        section.content.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        section.content.BorderSizePixel = 0
        section.content.ScrollBarThickness = 4
        section.content.Visible = false
        section.content.Parent = sectionsContainer
        
        -- Handle section selection
        section.button.MouseButton1Click:Connect(function()
            if self.currentSection then
                self.currentSection.content.Visible = false
                self.currentSection.button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end
            section.content.Visible = true
            section.button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            self.currentSection = section
        end)
        
        -- Show first section by default
        if #self.sections == 0 then
            section.content.Visible = true
            section.button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            self.currentSection = section
        end
        
        self.sections[name] = section
        return section
    end
    
    function self:AddToggle(sectionName, text, callback)
        local section = self.sections[sectionName]
        if not section then return end
        
        local toggle = Instance.new("Frame")
        toggle.Name = text.."Toggle"
        toggle.Size = UDim2.new(1, -20, 0, 30)
        toggle.Position = UDim2.new(0, 10, 0, #section.content:GetChildren() * 35)
        toggle.BackgroundTransparency = 1
        toggle.Parent = section.content
        
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
        
        local enabled = false
        button.MouseButton1Click:Connect(function()
            enabled = not enabled
            button.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            button.Text = enabled and "ON" or "OFF"
            callback(enabled)
        end)
        
        section.content.CanvasSize = UDim2.new(0, 0, 0, #section.content:GetChildren() * 35)
    end
    
    return self
end

return UILibrary
