local CatWare = {
	API = {},
	Connections = {},
}

local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function CatWare.Initialize()
	if shared.CatWareLoaded then return end
	shared.CatWareLoaded = true

	local gui = Instance.new("ScreenGui")
	gui.Name = "CatWareUI"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.Parent = game:GetService("CoreGui")

	local container = Instance.new("Frame")
	container.Parent = gui
	container.Size = UDim2.fromScale(0.22, 0.65)
	container.Position = UDim2.fromScale(0.75, 0.2)
	container.BackgroundTransparency = 1

	local list = Instance.new("UIListLayout")
	list.Parent = container
	list.Padding = UDim.new(0, 5)
	list.SortOrder = Enum.SortOrder.LayoutOrder

	CatWare.ScreenGui = gui

	local Config = {}
	local ConfigSys = {
		Path = "CatWare/Configs/" .. game.PlaceId .. ".json",
		canSave = true,
		save = function(self)
			if RunService:IsStudio() or not self.canSave then return end
			pcall(function()
				if isfile(self.Path) then delfile(self.Path) end
				writefile(self.Path, HttpService:JSONEncode(Config))
			end)
		end,
		load = function(self)
			if RunService:IsStudio() then return end
			if isfile(self.Path) then
				Config = HttpService:JSONDecode(readfile(self.Path))
			end
		end
	}

	if not RunService:IsStudio() then
		if not isfolder("CatWare") then
			makefolder("CatWare")
			makefolder("CatWare/Configs")
		end
	end

	ConfigSys:load()

	local Windows = {}
	local WindowIndex = 0

	CatWare.API.Uninject = function()
		ConfigSys.canSave = false
		for _, c in CatWare.Connections do c:Disconnect() end
		for _, win in Windows do
			for _, mod in win.Modules do
				if mod.Enabled then mod:Toggle() end
			end
		end
		gui:Destroy()
		shared.CatWareLoaded = false
		shared.CatWare = nil
	end

	CatWare.API.CreateWindow = function(Name)
		local window = Instance.new("Frame")
		window.Parent = gui
		window.Position = UDim2.fromScale(0.1 + (WindowIndex / 8), 0.18)
		window.Size = UDim2.new(0.14, 0, 0, 34)
		window.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
		window.BorderSizePixel = 0
		window.BackgroundTransparency = 0.15
		window.AutomaticSize = Enum.AutomaticSize.Y

		local corner = Instance.new("UICorner", window)
		corner.CornerRadius = UDim.new(0, 6)

		local title = Instance.new("TextLabel")
		title.Parent = window
		title.Size = UDim2.new(1, 0, 0, 34)
		title.BackgroundTransparency = 1
		title.Text = Name
		title.TextColor3 = Color3.fromRGB(255, 182, 193)
		title.Font = Enum.Font.FredokaOne
		title.TextSize = 15
		title.TextXAlignment = Enum.TextXAlignment.Center

		local moduleFrame = Instance.new("Frame")
		moduleFrame.Parent = window
		moduleFrame.Size = UDim2.fromScale(1, 0)
		moduleFrame.BackgroundTransparency = 1
		moduleFrame.AutomaticSize = Enum.AutomaticSize.Y

		local moduleLayout = Instance.new("UIListLayout", moduleFrame)
		moduleLayout.SortOrder = Enum.SortOrder.LayoutOrder
		moduleLayout.Padding = UDim.new(0, 3)

		table.insert(CatWare.Connections, UserInputService.InputBegan:Connect(function(key, gpe)
			if not gpe and key.KeyCode == Enum.KeyCode.RightShift then
				window.Visible = not window.Visible
			end
		end))

		WindowIndex += 1

		Windows[Name] = {
			Modules = {},
			CreateModule = function(self, info)
				if not Config[info.Name] then
					Config[info.Name] = {Enabled = false, Keybind = "Unknown"}
				end

				local button = Instance.new("TextButton")
				button.Parent = moduleFrame
				button.Size = UDim2.new(1, 0, 0, 28)
				button.Text = info.Name
				button.Font = Enum.Font.FredokaOne
				button.TextColor3 = Color3.fromRGB(255, 105, 180)
				button.TextSize = 12
				button.BackgroundColor3 = Color3.fromRGB(0, 191, 255)
				button.BorderSizePixel = 0

				local corner = Instance.new("UICorner", button)
				corner.CornerRadius = UDim.new(0, 5)

				local module = {
					Enabled = false,
					Toggle = function(self)
						self.Enabled = not self.Enabled
						Config[info.Name].Enabled = self.Enabled
						local targetColor = self.Enabled and Color3.fromRGB(255, 182, 193) or Color3.fromRGB(255, 105, 180)
						TweenService:Create(button, TweenInfo.new(0.15), {TextColor3 = targetColor}):Play()
						if info.Function then task.spawn(info.Function, self.Enabled) end
						ConfigSys:save()
					end
				}

				table.insert(CatWare.Connections, button.MouseButton1Click:Connect(function()
					module:Toggle()
				end))

				table.insert(CatWare.Connections, UserInputService.InputBegan:Connect(function(k, g)
					if not g and tostring(k.KeyCode):gsub("Enum.KeyCode.", "") == Config[info.Name].Keybind then
						module:Toggle()
					end
				end))

				if Config[info.Name].Enabled then
					task.delay(0.1, function()
						module:Toggle()
					end)
				end

				self.Modules[info.Name] = module
				return module
			end
		}

		return Windows[Name]
	end
end

shared.CatWare = CatWare
return CatWare
