local lib = {
	library = {},
	connections = {},
}

local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local SGui = Instance.new("ScreenGui")
SGui.Parent = CoreGui
SGui.ResetOnSpawn = false

local Config = {}
local ConfigSys = {
	canSave = true,
	file = 'idk/configs/'..game.PlaceId..'.json',
	saveConfig = function(self)
		if RunService:IsStudio() then return end
		if not self.canSave then return end
		if isfile(self.file) then
			delfile(self.file)
			task.wait(0.05)
		end
		writefile(self.file, HttpService:JSONEncode(Config))
	end,
	loadConfig = function(self)
		if RunService:IsStudio() then return end
		if isfile(self.file) then
			Config = HttpService:JSONDecode(readfile(self.file))
		end
	end,
}

ConfigSys:loadConfig()
task.wait(0.1)

local Index = 0
local Windows = {}
function lib.library.CreateTab(Text)
	local Frame = Instance.new("Frame")
	Frame.Parent = SGui
	Frame.Position = UDim2.fromScale(0.1 + (Index / 8), 0.2)
	Frame.Size = UDim2.new(0.12, 0, 0, 32)
	Frame.BorderSizePixel = 0
	Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	local FrameLabel = Instance.new("TextLabel")
	FrameLabel.Parent = Frame
	FrameLabel.Size = UDim2.fromScale(1, 1)
	FrameLabel.Position = UDim2.fromScale(0.05, 0)
	FrameLabel.BackgroundTransparency = 1
	FrameLabel.TextXAlignment = Enum.TextXAlignment.Left
	FrameLabel.TextColor3 = Color3.fromRGB(12, 216, 231)
	FrameLabel.TextSize = 10
	FrameLabel.Text = Text
	local ModuleFrame = Instance.new("Frame")
	ModuleFrame.Parent = Frame
	ModuleFrame.Position = UDim2.fromScale(0, 1)
	ModuleFrame.Size = UDim2.new(1, 0, 0, 0) 
	ModuleFrame.AutomaticSize = Enum.AutomaticSize.Y
	ModuleFrame.BackgroundTransparency = 1
	local ModuleSort = Instance.new("UIListLayout")
	ModuleSort.Parent = ModuleFrame
	ModuleSort.SortOrder = Enum.SortOrder.LayoutOrder
	local connection = UserInputService.InputBegan:Connect(function(Key, Gpe)
		if Gpe then return end
		if Key.KeyCode == Enum.KeyCode.RightShift then
			Frame.Visible = not Frame.Visible
		end
	end)
	table.insert(lib.connections, connection)

	Index += 1

	Windows[Text] = {
		Modules = {},
		CreateModule = function(self, Table)
			if not Config[Table.Name] then
				Config[Table.Name] = {
					Enabled = false,
					Keybind = 'Unknown',
				}
			end

			local ModuleButton = Instance.new("Frame")
			ModuleButton.Parent = ModuleFrame
			ModuleButton.Size = UDim2.new(1, 0, 0, 32)
			ModuleButton.BorderSizePixel = 0
			ModuleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			local ModuleText = Instance.new("TextButton")
			ModuleText.Parent = ModuleButton
			ModuleText.Position = UDim2.fromScale(0.05, 0)
			ModuleText.Size = UDim2.fromScale(1, 1)
			ModuleText.BackgroundTransparency = 1
			ModuleText.TextXAlignment = Enum.TextXAlignment.Left
			ModuleText.TextColor3 = Config[Table.Name].Enabled and Color3.fromRGB(1, 255, 179) or Color3.fromRGB(255, 255, 255)
			ModuleText.TextSize = 11
			ModuleText.Text = Table["Name"]
			local KeybindText = Instance.new("TextButton")
			KeybindText.Parent = ModuleButton
			KeybindText.Size = UDim2.new(0, 50, 1, 0)
			KeybindText.Position = UDim2.new(1, -55, 0, 0) 
			KeybindText.BackgroundTransparency = 1
			KeybindText.TextXAlignment = Enum.TextXAlignment.Right
			KeybindText.TextColor3 = Color3.fromRGB(150, 150, 150)
			KeybindText.TextSize = 10
			KeybindText.Text = Config[Table.Name].Keybind

			KeybindText.MouseButton1Click:Connect(function()
				local conn
				conn = UserInputService.InputBegan:Connect(function(Key, Gpe)
					if not Gpe and Key.KeyCode ~= Enum.KeyCode.Unknown then
						Config[Table.Name].Keybind = tostring(Key.KeyCode):gsub("Enum.KeyCode.", "")
						KeybindText.Text = Config[Table.Name].Keybind
						ConfigSys:saveConfig()
						conn:Disconnect()
					end
				end)
			end)

			local ModuleHandler = {
				Enabled = Config[Table.Name].Enabled,
				Toggle = function(self)
					self.Enabled = not self.Enabled
					Config[Table.Name].Enabled = self.Enabled
					TweenService:Create(ModuleText, TweenInfo.new(0.1), {TextColor3 = self.Enabled and Color3.fromRGB(1, 255, 179) or Color3.fromRGB(255, 255, 255)}):Play()
					if Table["Function"] then
						task.spawn(Table["Function"], self.Enabled)
					end
					ConfigSys:saveConfig()
				end,
			}

			if ModuleHandler.Enabled and Table["Function"] then
				task.spawn(Table["Function"], true)
			end

			ModuleText.MouseButton1Down:Connect(function()
				ModuleHandler:Toggle()
			end)
			UserInputService.InputBegan:Connect(function(Key, Gpe)
				if not Gpe and Key.KeyCode ~= Enum.KeyCode.Unknown and Key.KeyCode == Enum.KeyCode[Config[Table.Name].Keybind] then
					ModuleHandler:Toggle()
				end
			end)

			self.Modules[Table.Name] = ModuleHandler
			return ModuleHandler
		end
	}

	return Windows[Text]
end

return lib
