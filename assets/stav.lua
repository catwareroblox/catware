--[[
	stav.lua
	
	Credits:
	@springs67 - Inspriring me to make an interface
	@sus - Name randomization
]]

local lib = {
	library = {},
	connections = {},
	config = {}
}

local cloneref = cloneref or function(obj)
	return obj
end

local inputService = cloneref(game:GetService('UserInputService'))
local tweenService = cloneref(game:GetService('TweenService'))
local httpService = cloneref(game:GetService('HttpService'))
local playersService = cloneref(game:GetService('Players'))
local runService = cloneref(game:GetService('RunService'))
local lplr = playersService.LocalPlayer

for _, v in {'an4rchy', 'an4rchy/configs'} do
	if not isfolder(v) then
		makefolder(v)
	end
end

lib.configSys = {
	canSave = true,
	filePath = 'an4rchy/configs/'..game.PlaceId..'.json',
	saveCfg = function()
		if runService:IsStudio() then return end
		if not lib.configSys.canSave then return end
		
		task.delay(0.05, function()
			writefile(lib.configSys.filePath, httpService:JSONEncode(lib.config))
		end)
	end,
	loadCfg = function()
		if runService:IsStudio() then return end
		
		if isfile(lib.configSys.filePath) then
			lib.config = httpService:JSONDecode(readfile(lib.configSys.filePath))
		end
	end
}

local gethui = get_hidden_ui or gethui or function()
	return (runService:IsStudio() and lplr.PlayerGui) or cloneref(game:GetService('CoreGui'))
end

local chars = "abcdefghijklmnopqrstuvwxyz0123456789!@#$[]{}';:%&*ᔑʖᓵ↸ᒷ⎓<>/\⊣⍑╎⋮ꖌꖎᒲリ𝙹!.,¡ᑑ∷ᓭℸ̣⚍⍊∴̇/||⨅ʃʒɲɳɾɽʈɖʉɯɵɤɥɕʑʠʡʢʣʤʥʦʧʨʩʪʫʬʭʮʯȡȴȵȶȷɀɂɃɓɔɕɖɗɘəɚɛɜɞɟɠɡɢɣɤɦɧɨɩɪɫɬɭɮɯɰɱɲɳɴɵɶɷɸɹɺɻɽɾɿʀʁʂʃʄʅʆʇʈʉʊʋʌʍʎʏʐʑʒʓʔʕʖʗʘʙʚʛʜʝʞʟʠʡʢʣʤʥʦʧʨʩʪʫʬʭːˑ˞ˤˠˢˣ˪˫ˬ˭ˮ˯˰˱˲˳˴˵˶˷˸˹˺˻˼˽˾˿ͰͱͲͳʹ͵Ͷͷͺͻͼͽ;΄΅·ϐϑϕϖϰϱϵ϶ϷӑӓәөұҳҷҙңһⱠⱢⱤⱧⱲⱵꞌꞎꞏℵℶℷℸ☥☯⚛⚚"
local name = ""
for i = 1, 150 do
	name = name .. chars:sub(math.random(1, #chars), math.random(1, #chars))
end
local ScreenGui = Instance.new('ScreenGui')
ScreenGui.Name = name
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = gethui()

local index = 0
local Windows = {}
local notifs = {}

if inputService.TouchEnabled then
	lplr:Kick('Not mobile supported :)')
end

lib.configSys:loadCfg()

lib.library.CreateNotif = function(title, duration, icon)
	local NotifFrame = Instance.new('Frame')
	NotifFrame.Position = UDim2.fromScale(0.01, 0.005)
	NotifFrame.Size = UDim2.new(0.12, 0, 0, 32)
	NotifFrame.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
	NotifFrame.Parent = ScreenGui
	
	local FrameCorner = Instance.new('UICorner')
	FrameCorner.CornerRadius = UDim.new(0, 12)
	FrameCorner.Parent = NotifFrame
	
	local offset = 0
	if icon then
		local Image = Instance.new('ImageLabel')
		Image.Size = UDim2.fromScale(0.2, 0.8)
		Image.Position = UDim2.fromScale(0.001, 0.1)
		Image.BackgroundTransparency = 1
		Image.Image = 'rbxassetid://'..icon
		Image.ScaleType = Enum.ScaleType.Fit
		Image.Parent = NotifFrame
		
		offset = 0.17
	end

	local WindowLabel = Instance.new('TextLabel')
	WindowLabel.Size = UDim2.fromScale(1, 1)
	WindowLabel.Position = UDim2.fromScale(0.05 + offset, 0)
	WindowLabel.BackgroundTransparency = 1
	WindowLabel.TextXAlignment = Enum.TextXAlignment.Left
	WindowLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	WindowLabel.TextSize = 16
	WindowLabel.Text = title
	WindowLabel.Font = Enum.Font.Montserrat
	WindowLabel.FontFace.Weight = Enum.FontWeight.Medium
	WindowLabel.Parent = NotifFrame
	
	table.insert(notifs, NotifFrame)
	
	if #notifs > 1 then
		local uncnotif = table.remove(notifs, 1)
		
		if uncnotif and uncnotif.Parent then
			uncnotif:Destroy()
		end
	end
	
	task.delay(duration, function()
		table.remove(notifs, 1)
		NotifFrame:Destroy()
	end)
end

lib.library.CreateWindow = function(txt)
	local WindowFrame = Instance.new('Frame')
	WindowFrame.Position = UDim2.fromScale(0.1 + (index / 8), 0.2)
	WindowFrame.Size = UDim2.new(0.12, 0, 0, 32)
	WindowFrame.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
	WindowFrame.Parent = ScreenGui 
	
	local FrameCorner = Instance.new('UICorner')
	FrameCorner.CornerRadius = UDim.new(0, 6)
	FrameCorner.Parent = WindowFrame
	
	local WindowLabel = Instance.new('TextLabel')
	WindowLabel.Size = UDim2.fromScale(1, 1)
	WindowLabel.Position = UDim2.fromScale(0.05, 0)
	WindowLabel.BackgroundTransparency = 1
	WindowLabel.TextXAlignment = Enum.TextXAlignment.Left
	WindowLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	WindowLabel.TextSize = 16
	WindowLabel.Text = txt
	WindowLabel.Font = Enum.Font.Montserrat
	WindowLabel.FontFace.Weight = Enum.FontWeight.Medium
	WindowLabel.Parent = WindowFrame
	
	local ModuleFrame = Instance.new('Frame')
	ModuleFrame.Position = UDim2.fromScale(0, 1)
	ModuleFrame.Size = UDim2.new(1, 0, 0, 0)
	ModuleFrame.AutomaticSize = Enum.AutomaticSize.Y
	ModuleFrame.BackgroundTransparency = 1
	ModuleFrame.Parent = WindowFrame
	
	local ModulePadding = Instance.new('UIPadding')
	ModulePadding.PaddingTop = UDim.new(0, 6)
	ModulePadding.Parent = ModuleFrame
	
	local ModuleSort = Instance.new('UIListLayout')
	ModuleSort.SortOrder = Enum.SortOrder.LayoutOrder
	ModuleSort.Padding = UDim.new(0, 6)
	ModuleSort.Parent = ModuleFrame
	
	table.insert(lib.library, inputService.InputBegan:Connect(function(key, gpe)
		if gpe then return end
		
		if key.KeyCode == Enum.KeyCode.RightShift then
			WindowFrame.Visible = not WindowFrame.Visible
		end
	end))
	
	index += 1
	
	Windows[txt] = {
		Modules = {},
		CreateModule = function(self, Table)
			if not lib.config[Table.Name] then
				lib.config[Table.Name] = {
					Enabled = false,
					Keybind = Table.Keybind or 'Unknown'
				}
			end
			
			local ModuleButton = Instance.new('Frame')
			ModuleButton.Size = UDim2.new(1, 0, 0, 32)
			ModuleButton.BackgroundColor3 = lib.config[Table.Name].Enabled and Color3.fromRGB(29, 29, 29) or Color3.fromRGB(40, 40, 40)
			ModuleButton.Parent = ModuleFrame
			
			local ModuleCorner = Instance.new('UICorner')
			ModuleCorner.CornerRadius = UDim.new(0, 8)
			ModuleCorner.Parent = ModuleButton
			
			local ModuleText = Instance.new('TextButton')
			ModuleText.Position = UDim2.fromScale(0.05, 0)
			ModuleText.Size = UDim2.fromScale(1, 1)
			ModuleText.BackgroundTransparency = 1
			ModuleText.TextXAlignment = Enum.TextXAlignment.Left
			ModuleText.TextColor3 = Color3.fromRGB(255, 255, 255)
			ModuleText.TextSize = 16
			ModuleText.Text = Table.Name
			ModuleText.Font = Enum.Font.Montserrat
			ModuleText.Parent = ModuleButton
			
			local KeybindText = Instance.new('TextButton')
			KeybindText.Position = UDim2.new(1, -59, 0, 0)
			KeybindText.Size = UDim2.new(0, 50, 1, 0)
			KeybindText.BackgroundTransparency = 1
			KeybindText.TextXAlignment = Enum.TextXAlignment.Right
			KeybindText.TextColor3 = Color3.fromRGB(255, 255, 255)
			KeybindText.TextSize = 16
			KeybindText.Text = lib.config[Table.Name].Keybind
			KeybindText.Font = Enum.Font.Montserrat
			KeybindText.Parent = ModuleButton
			
			KeybindText.MouseButton1Click:Connect(function()
				local conn
				conn = inputService.InputBegan:Connect(function(key, gpe)
					if gpe then return end
					
					if key.KeyCode ~= Enum.KeyCode.Unknown then
						lib.config[Table.Name].Keybind = tostring(key.KeyCode):gsub('Enum.KeyCode.', '')
						KeybindText.Text = lib.config[Table.Name].Keybind
						lib.configSys:saveCfg()
						conn:Disconnect()
					end
				end)
			end)
			
			local moduleHandler = {
				Enabled = lib.config[Table.Name].Enabled,
				Toggle = function(self)
					self.Enabled = not self.Enabled
					lib.config[Table.Name].Enabled = not lib.config[Table.Name].Enabled
					
					tweenService:Create(ModuleButton, TweenInfo.new(0.1), {BackgroundColor3 = self.Enabled and Color3.fromRGB(29, 29, 29) or Color3.fromRGB(40, 40, 40)}):Play()
					if Table.Function then
						task.spawn(Table.Function, self.Enabled)
					end
					lib.configSys:saveCfg()
				end,
			}
			
			if moduleHandler.Enabled and table.Function then
				task.spawn(Table.Function, true)
			end
			
			ModuleText.MouseButton1Click:Connect(function()
				moduleHandler:Toggle()
			end)
			
			inputService.InputBegan:Connect(function(key, gpe)
				if gpe then return end
				
				if key.KeyCode ~= Enum.KeyCode.Unknown and key.KeyCode == Enum.KeyCode[lib.config[Table.Name].Keybind] then
					moduleHandler:Toggle()
					
					local enabled = moduleHandler.Enabled and 'ON' or 'OFF'
					lib.library.CreateNotif(Table.Name..': '..enabled, 1.67, 11422155687)
				end
			end)
			
			self.Modules[Table.Name] = moduleHandler
			return moduleHandler
		end,
	}
	
	return Windows[txt]
end

return lib
