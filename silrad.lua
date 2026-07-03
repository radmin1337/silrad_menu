local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

local Theme = {
	Main = Color3.fromRGB(8, 8, 10),
	Sidebar = Color3.fromRGB(12, 12, 15),
	-- СЕРЬЕЗНЫЕ ЦВЕТА
	Accent = Color3.fromRGB(200, 0, 0), -- Темно-красный
	Accent2 = Color3.fromRGB(0, 80, 200), -- Глубокий синий
	
	White = Color3.fromRGB(255, 255, 255),
	Black = Color3.fromRGB(0, 0, 0),
	Inactive = Color3.fromRGB(50, 50, 55), -- Тот самый серый
	ElementBase = Color3.fromRGB(25, 25, 30)
}

local function ApplyCleanText(label, size)
	label.TextColor3 = Theme.White
	label.Font = Enum.Font.GothamBold
	label.TextSize = size or 12
	local Stroke = Instance.new("UIStroke")
	Stroke.Thickness = 1.5
	Stroke.Color = Theme.Black
	Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	Stroke.Parent = label
end

local function ApplySeriousNeon(parent, trans)
	local Grad = Instance.new("UIGradient")
	Grad.Color = ColorSequence.new(Theme.Accent, Theme.Accent2)
	if trans then Grad.Transparency = trans end
	Grad.Parent = parent
	return Grad
end

-- ФУНКЦИЯ ДЛЯ СКРУГЛЕНИЯ ТОЛЬКО ЛЕВОГО НИЖНЕГО УГЛА
local function ApplyCustomRounding(frame, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = frame
	
	-- Маскирующие фреймы, чтобы сделать остальные углы квадратными
	local maskTop = Instance.new("Frame")
	maskTop.Name = "MaskTop"
	maskTop.Size = UDim2.new(1, 0, 0.5, 0)
	maskTop.BackgroundColor3 = frame.BackgroundColor3
	maskTop.BorderSizePixel = 0
	maskTop.ZIndex = frame.ZIndex
	maskTop.Parent = frame
	
	local maskRight = Instance.new("Frame")
	maskRight.Name = "MaskRight"
	maskRight.Size = UDim2.new(0.5, 0, 1, 0)
	maskRight.Position = UDim2.new(0.5, 0, 0, 0)
	maskRight.BackgroundColor3 = frame.BackgroundColor3
	maskRight.BorderSizePixel = 0
	maskRight.ZIndex = frame.ZIndex
	maskRight.Parent = frame
end

local function Drag(frame, target)
	local dragging, dragInput, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true; dragStart = input.Position; startPos = target.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
end

function Library:CreateWindow(name)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "SeriousNeon"
	ScreenGui.Parent = (gethui and gethui()) or CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Parent = ScreenGui
	Main.Size = UDim2.new(0, 450, 0, 320)
	Main.Position = UDim2.new(0.5, -225, 0.5, -160)
	Main.BackgroundColor3 = Theme.Main
	Main.BorderSizePixel = 0
	
	-- Только левый нижний угол круглый
	ApplyCustomRounding(Main, 15)

	local WinStroke = Instance.new("UIStroke", Main)
	WinStroke.Thickness = 2.5
	ApplySeriousNeon(WinStroke)

	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 40)
	TopBar.BackgroundTransparency = 1
	TopBar.Parent = Main
	TopBar.ZIndex = 5
	Drag(TopBar, Main)

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, -60, 1, 0)
	Title.Position = UDim2.new(0, 15, 0, 0)
	Title.Text = name:upper()
	Title.TextColor3 = Theme.White
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.BackgroundTransparency = 1
	Title.Parent = TopBar
	ApplySeriousNeon(Title)

	local MinBtn = Instance.new("TextButton")
	MinBtn.Size = UDim2.new(0, 26, 0, 26)
	MinBtn.Position = UDim2.new(1, -38, 0.5, -13)
	MinBtn.BackgroundColor3 = Theme.ElementBase
	MinBtn.Text = "—"
	MinBtn.TextColor3 = Theme.White
	MinBtn.Font = Enum.Font.GothamBold
	MinBtn.TextSize = 18
	MinBtn.Parent = TopBar
	MinBtn.ZIndex = 6
	Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 4)
	ApplySeriousNeon(Instance.new("UIStroke", MinBtn))

	local Holder = Instance.new("Frame")
	Holder.Size = UDim2.new(1, 0, 1, -40)
	Holder.Position = UDim2.new(0, 0, 0, 40)
	Holder.BackgroundTransparency = 1
	Holder.ClipsDescendants = true
	Holder.Parent = Main

	local Minimized = false
	MinBtn.MouseButton1Click:Connect(function()
		Minimized = not Minimized
		local targetSize = Minimized and UDim2.new(0, 450, 0, 40) or UDim2.new(0, 450, 0, 320)
		MinBtn.Text = Minimized and "+" or "—"
		Holder.Visible = not Minimized
		TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = targetSize}):Play()
	end)

	local Sidebar = Instance.new("Frame")
	Sidebar.Size = UDim2.new(0, 130, 1, 0)
	Sidebar.BackgroundColor3 = Theme.Sidebar
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = Holder
	ApplyCustomRounding(Sidebar, 15)

	local TabHolder = Instance.new("Frame")
	TabHolder.Size = UDim2.new(1, 0, 1, -10)
	TabHolder.Position = UDim2.new(0, 0, 0, 10)
	TabHolder.BackgroundTransparency = 1
	TabHolder.Parent = Sidebar
	TabHolder.ZIndex = 10
	local Layout = Instance.new("UIListLayout", TabHolder)
	Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	Layout.Padding = UDim.new(0, 8)

	local Pages = Instance.new("Frame")
	Pages.Size = UDim2.new(1, -150, 1, -20)
	Pages.Position = UDim2.new(0, 140, 0, 10)
	Pages.BackgroundTransparency = 1
	Pages.Parent = Holder

	local Tabs = { Active = nil }

	function Library:AddTab(tabName)
		local Page = Instance.new("ScrollingFrame")
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.BackgroundTransparency = 1
		Page.Visible = false
		Page.ScrollBarThickness = 0
		Page.Parent = Pages
		Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

		-- КНОПКА РАЗДЕЛА
		local TabBtn = Instance.new("TextButton")
		TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
		TabBtn.BackgroundColor3 = Theme.ElementBase
		TabBtn.Text = tabName
		TabBtn.Font = Enum.Font.GothamBold
		TabBtn.TextSize = 12
		TabBtn.Parent = TabHolder
		TabBtn.ZIndex = 11
		Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)
		
		-- Обводка раздела
		local TabStroke = Instance.new("UIStroke", TabBtn)
		TabStroke.Thickness = 1.5
		TabStroke.Color = Theme.Inactive -- Изначально серая
		
		local TGrad = ApplySeriousNeon(TabStroke)
		TGrad.Enabled = false
		
		ApplyCleanText(TabBtn, 12)

		TabBtn.MouseButton1Click:Connect(function()
			if Tabs.Active then
				Tabs.Active.Grad.Enabled = false
				Tabs.Active.Stroke.Color = Theme.Inactive
				Tabs.Active.Page.Visible = false
			end
			Tabs.Active = {Btn = TabBtn, Page = Page, Grad = TGrad, Stroke = TabStroke}
			TGrad.Enabled = true -- Вспыхивает градиент
			TabStroke.Color = Color3.new(1,1,1)
			Page.Visible = true
		end)

		if not Tabs.Active then 
			Tabs.Active = {Btn = TabBtn, Page = Page, Grad = TGrad, Stroke = TabStroke} 
			TGrad.Enabled = true
			TabStroke.Color = Color3.new(1,1,1)
			Page.Visible = true 
		end

		local TabItems = {}

		function TabItems:Button(text, callback)
			local B = Instance.new("Frame")
			B.Size = UDim2.new(0.95, 0, 0, 38)
			B.BackgroundColor3 = Theme.ElementBase
			B.Parent = Page
			Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
			
			local Lbl = Instance.new("TextLabel")
			Lbl.Size = UDim2.new(1, -10, 1, 0)
			Lbl.Position = UDim2.new(0, 10, 0, 0)
			Lbl.BackgroundTransparency = 1
			Lbl.Text = text
			Lbl.TextXAlignment = Enum.TextXAlignment.Left
			Lbl.Parent = B
			ApplyCleanText(Lbl, 12)

			local Clicker = Instance.new("TextButton")
			Clicker.Size = UDim2.new(1, 0, 1, 0)
			Clicker.BackgroundTransparency = 1
			Clicker.Text = ""
			Clicker.Parent = B
			
			Clicker.MouseButton1Click:Connect(function()
				task.spawn(callback)
				B.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
				task.wait(0.1)
				B.BackgroundColor3 = Theme.ElementBase
			end)
		end

		function TabItems:Toggle(text, callback)
			local Toggled = false
			local T = Instance.new("Frame")
			T.Size = UDim2.new(0.95, 0, 0, 38)
			T.BackgroundColor3 = Theme.ElementBase
			T.Parent = Page
			Instance.new("UICorner", T).CornerRadius = UDim.new(0, 6)

			local Lbl = Instance.new("TextLabel")
			Lbl.Size = UDim2.new(1, 0, 1, 0)
			Lbl.Position = UDim2.new(0, 10, 0, 0)
			Lbl.Text = text
			Lbl.BackgroundTransparency = 1
			Lbl.TextXAlignment = Enum.TextXAlignment.Left
			Lbl.Parent = T
			ApplyCleanText(Lbl, 12)

			local Ind = Instance.new("Frame")
			Ind.Size = UDim2.new(0, 32, 0, 18)
			Ind.Position = UDim2.new(1, -40, 0.5, -9)
			Ind.BackgroundColor3 = Theme.Inactive -- СЕРЫЙ КОГДА ВЫКЛ
			Ind.Parent = T
			Instance.new("UICorner", Ind).CornerRadius = UDim.new(1, 0)
			
			local IGrad = ApplySeriousNeon(Ind)
			IGrad.Enabled = false
			
			local Dot = Instance.new("Frame")
			Dot.Size = UDim2.new(0, 14, 0, 14)
			Dot.Position = UDim2.new(0, 2, 0.5, -7)
			Dot.BackgroundColor3 = Theme.White
			Dot.Parent = Ind
			Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

			local Clicker = Instance.new("TextButton")
			Clicker.Size = UDim2.new(1, 0, 1, 0)
			Clicker.BackgroundTransparency = 1
			Clicker.Text = ""
			Clicker.Parent = T

			Clicker.MouseButton1Click:Connect(function()
				Toggled = not Toggled
				local targetX = Toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
				TweenService:Create(Dot, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = targetX}):Play()
				IGrad.Enabled = Toggled
				Ind.BackgroundColor3 = Toggled and Color3.new(1,1,1) or Theme.Inactive
				task.spawn(callback, Toggled)
			end)
		end

		function TabItems:Slider(text, min, max, def, callback)
			local S = Instance.new("Frame")
			S.Size = UDim2.new(0.95, 0, 0, 55)
			S.BackgroundColor3 = Theme.ElementBase
			S.Parent = Page
			Instance.new("UICorner", S).CornerRadius = UDim.new(0, 6)

			local L = Instance.new("TextLabel")
			L.Text = text
			L.Size = UDim2.new(1, 0, 0, 30)
			L.Position = UDim2.new(0, 10, 0, 0)
			L.BackgroundTransparency = 1
			L.TextXAlignment = Enum.TextXAlignment.Left
			L.Parent = S
			ApplyCleanText(L, 11)
			
			local V = Instance.new("TextLabel")
			V.Text = tostring(def)
			V.Size = UDim2.new(1, -10, 0, 30)
			V.BackgroundTransparency = 1
			V.TextXAlignment = Enum.TextXAlignment.Right
			V.Parent = S
			ApplyCleanText(V, 12)

			local Bar = Instance.new("Frame")
			Bar.Size = UDim2.new(0.9, 0, 0, 5)
			Bar.Position = UDim2.new(0.05, 0, 0.75, 0)
			Bar.BackgroundColor3 = Theme.Inactive -- СЕРЫЙ ФОН
			Bar.Parent = S
			Instance.new("UICorner", Bar)
			
			local Fill = Instance.new("Frame")
			Fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
			Fill.BackgroundColor3 = Color3.new(1,1,1)
			Fill.Parent = Bar
			Instance.new("UICorner", Fill)
			ApplySeriousNeon(Fill)

			local dragging = false
			local function update()
				local p = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
				Fill.Size = UDim2.new(p, 0, 1, 0)
				local val = math.floor(min + (max-min)*p)
				V.Text = tostring(val)
				task.spawn(callback, val)
			end
			Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update() end end)
			UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update() end end)
			UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
		end

		return TabItems
	end

	return Library
end
--by silrad <3 v1.2
return Library
