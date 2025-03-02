-- UI Library
local UILibrary = {}

local function CreateGui()
    -- Create ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "AdminPanel"
    
    -- Create main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 800, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -400, 0.5, -225)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = gui
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Create sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 60, 1, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame
    
    -- Create content area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -60, 1, 0)
    contentArea.Position = UDim2.new(0, 60, 0, 0)
    contentArea.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    contentArea.BorderSizePixel = 0
    contentArea.Parent = mainFrame
    
    return gui, mainFrame, sidebar, contentArea
end

function UILibrary.new()
    local self = {}
    self.gui, self.mainFrame, self.sidebar, self.contentArea = CreateGui()
    
    -- Keep track of sections
    self.sections = {}
    self.currentSection = nil
    
    function self:AddSection(name)
        local section = Instance.new("Frame")
        section.Name = name
        section.Size = UDim2.new(1, 0, 1, 0)
        section.BackgroundTransparency = 1
        section.Visible = false
        section.Parent = self.contentArea
        
        -- Add to sections table
        self.sections[name] = section
        
        -- Create tab button
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, 0, 0, 40)
        tabButton.Position = UDim2.new(0, 0, 0, #self.sections * 45)
        tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        tabButton.BorderSizePixel = 0
        tabButton.Text = name
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.Parent = self.sidebar
        
        -- Tab button click handler
        tabButton.MouseButton1Click:Connect(function()
            for _, otherSection in pairs(self.sections) do
                otherSection.Visible = false
            end
            section.Visible = true
            self.currentSection = section
        end)
        
        -- Show first section by default
        if #self.sections == 1 then
            section.Visible = true
            self.currentSection = section
        end
        
        return section
    end
    
    -- Parent the ScreenGui to the correct location based on context
    local success, result = pcall(function()
        if game:GetService("RunService"):IsStudio() then
            self.gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        else
            self.gui.Parent = game:GetService("CoreGui")
        end
    end)
    
    if not success then
        warn("Failed to parent ScreenGui:", result)
        self.gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    return self
end

-- Example usage
local ui = UILibrary.new()

-- Add sections
local generalSection = ui:AddSection("General")
local combatSection = ui:AddSection("Combat")
local visualsSection = ui:AddSection("Visuals")

return UILibrary
