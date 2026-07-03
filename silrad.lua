local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

local Theme = {
	Main = Color3.fromRGB(10, 10, 12),
	Sidebar = Color3.fromRGB(15, 15, 20),
	Accent = Color3.fromRGB(0, 255, 255),
	Accent2 = Color3.fromRGB(255, 0, 255),
	BrightCyan = Color3.fromRGB(0, 0, 255),
	BrightPink = Color3.fromRGB(46, 98, 255),
	White = Color3.fromRGB(255, 255, 255),
	Black = Color3.fromRGB(0, 0, 0),
	Inactive = Color3.fromRGB(60, 60, 70),
}

print("silrad_menu by silrad [v0.8]")

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

local function ApplySuperNeon(parent, trans)
	local Grad = Instance.new("UIGradient")
	Grad.Color = ColorSequence.new(Theme.BrightCyan, Theme.BrightPink)
	if trans then Grad.Transparency = trans end
	Grad.Parent = parent
	return Grad
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
	ScreenGui.Name = "silrad_menu"
	ScreenGui.Parent = (gethui and gethui()) or CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Parent = ScreenGui
	Main.Size = UDim2.new(0, 420, 0, 300)
	Main.Position = UDim2.new(0.5, -210, 0.5, -150)
	Main.BackgroundColor3 = Theme.Main
	Main.BorderSizePixel = 0
	Main.ClipsDescendants = true
	Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

	local WinStroke = Instance.new("UIStroke", Main)
	WinStroke.Thickness = 2.5
	WinStroke.Color = Color3.new(1, 1, 1)
	WinStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	ApplySuperNeon(WinStroke)

	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 38)
	TopBar.BackgroundTransparency = 1
	TopBar.Parent = Main
	Drag(TopBar, Main)

	local HeaderIcon = Instance.new("ImageLabel")
	HeaderIcon.Name = "HeaderIcon"
	HeaderIcon.Size = UDim2.new(0, 22, 0, 22)
	HeaderIcon.Position = UDim2.new(0, 12, 0.5, -11)
	HeaderIcon.BackgroundTransparency = 1
	HeaderIcon.Image = "rbxassetid://101449135331723"
	HeaderIcon.Parent = TopBar
	ApplySuperNeon(HeaderIcon)

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, -70, 1, 0)
	Title.Position = UDim2.new(0, 40, 0, 0)
	Title.Text = name:upper()
	Title.TextColor3 = Theme.White
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.BackgroundTransparency = 1
	Title.Parent = TopBar
	ApplySuperNeon(Title)

	local MinBtn = Instance.new("TextButton")
	MinBtn.Size = UDim2.new(0, 26, 0, 26)
	MinBtn.Position = UDim2.new(1, -36, 0.5, -13)
	MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	MinBtn.Text = "—"
	MinBtn.TextColor3 = Theme.White
	MinBtn.Font = Enum.Font.GothamBold
	MinBtn.TextSize = 18
	MinBtn.Parent = TopBar
	Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)
	ApplySuperNeon(Instance.new("UIStroke", MinBtn))

	local Holder = Instance.new("Frame")
	Holder.Size = UDim2.new(1, 0, 1, -38)
	Holder.Position = UDim2.new(0, 0, 0, 38)
	Holder.BackgroundTransparency = 1
	Holder.ClipsDescendants = true
	Holder.Parent = Main

	local Minimized = false
	MinBtn.MouseButton1Click:Connect(function()
		Minimized = not Minimized
		local targetSize = Minimized and UDim2.new(0, 420, 0, 38) or UDim2.new(0, 420, 0, 300)
		MinBtn.Text = Minimized and "+" or "—"
		MinBtn.TextSize = Minimized and 22 or 18
		Holder.Visible = not Minimized
		TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = targetSize}):Play()
	end)

	local Sidebar = Instance.new("Frame")
	Sidebar.Size = UDim2.new(0, 130, 1, 0)
	Sidebar.BackgroundColor3 = Theme.Sidebar
	Sidebar.Parent = Holder
	Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

	local TabHolder = Instance.new("Frame")
	TabHolder.Size = UDim2.new(1, 0, 1, -10)
	TabHolder.Position = UDim2.new(0, 0, 0, 5)
	TabHolder.BackgroundTransparency = 1
	TabHolder.Parent = Sidebar
	local Layout = Instance.new("UIListLayout", TabHolder)
	Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	Layout.Padding = UDim.new(0, 6)

	local Pages = Instance.new("Frame")
	Pages.Size = UDim2.new(1, -145, 1, -10)
	Pages.Position = UDim2.new(0, 140, 0, 5)
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

		local TabBtn = Instance.new("TextButton")
		TabBtn.Size = UDim2.new(0.95, 0, 0, 32)
		TabBtn.BackgroundTransparency = 1
		TabBtn.Text = tabName
		TabBtn.Parent = TabHolder
		Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
		ApplyCleanText(TabBtn, 12)
		local TGrad = ApplySuperNeon(TabBtn)
		TGrad.Enabled = false

		TabBtn.MouseButton1Click:Connect(function()
			if Tabs.Active then
				Tabs.Active.Grad.Enabled = false
				Tabs.Active.Page.Visible = false
			end
			Tabs.Active = {Btn = TabBtn, Page = Page, Grad = TGrad}
			TGrad.Enabled = true 
			Page.Visible = true
		end)

		if not Tabs.Active then 
			Tabs.Active = {Btn = TabBtn, Page = Page, Grad = TGrad} 
			TGrad.Enabled = true
			Page.Visible = true 
		end

		local TabItems = {}

		function TabItems:Button(text, callback)
			local B = Instance.new("Frame")
			B.Size = UDim2.new(0.95, 0, 0, 35)
			B.BackgroundColor3 = Color3.new(1,1,1)
			B.Parent = Page
			Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
			ApplySuperNeon(B, NumberSequence.new(0.85))
			
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
			end)
		end

		function TabItems:Toggle(text, callback)
			local Toggled = false
			local T = Instance.new("Frame")
			T.Size = UDim2.new(0.95, 0, 0, 35)
			T.BackgroundColor3 = Color3.new(1,1,1)
			T.Parent = Page
			Instance.new("UICorner", T).CornerRadius = UDim.new(0, 8)
			ApplySuperNeon(T, NumberSequence.new(0.85))

			local Lbl = Instance.new("TextLabel")
			Lbl.Size = UDim2.new(1, 0, 1, 0)
			Lbl.Position = UDim2.new(0, 10, 0, 0)
			Lbl.Text = text
			Lbl.BackgroundTransparency = 1
			Lbl.TextXAlignment = Enum.TextXAlignment.Left
			Lbl.Parent = T
			ApplyCleanText(Lbl, 12)

			local Ind = Instance.new("Frame")
			Ind.Size = UDim2.new(0, 30, 0, 16)
			Ind.Position = UDim2.new(1, -38, 0.5, -8)
			Ind.BackgroundColor3 = Theme.Inactive
			Ind.Parent = T
			Instance.new("UICorner", Ind).CornerRadius = UDim.new(1, 0)
			
			local IGrad = ApplySuperNeon(Ind)
			IGrad.Enabled = false
			
			local Dot = Instance.new("Frame")
			Dot.Size = UDim2.new(0, 12, 0, 12)
			Dot.Position = UDim2.new(0, 2, 0.5, -6)
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
				local targetX = Toggled and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
				TweenService:Create(Dot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Position = targetX}):Play()
				IGrad.Enabled = Toggled
				Ind.BackgroundColor3 = Toggled and Color3.new(1,1,1) or Theme.Inactive
				task.spawn(callback, Toggled)
			end)
		end

		function TabItems:Slider(text, min, max, def, callback)
			local S = Instance.new("Frame")
			S.Size = UDim2.new(0.95, 0, 0, 50)
			S.BackgroundColor3 = Color3.new(1,1,1)
			S.Parent = Page
			Instance.new("UICorner", S).CornerRadius = UDim.new(0, 8)
			ApplySuperNeon(S, NumberSequence.new(0.85))

			local L = Instance.new("TextLabel")
			L.Text = text
			L.Size = UDim2.new(1, 0, 0, 28)
			L.Position = UDim2.new(0, 10, 0, 0)
			L.BackgroundTransparency = 1
			L.TextXAlignment = Enum.TextXAlignment.Left
			L.Parent = S
			ApplyCleanText(L, 12)
			
			local V = Instance.new("TextLabel")
			V.Text = tostring(def)
			V.Size = UDim2.new(1, -10, 0, 28)
			V.BackgroundTransparency = 1
			V.TextXAlignment = Enum.TextXAlignment.Right
			V.Parent = S
			ApplyCleanText(V, 12)

			local Bar = Instance.new("Frame")
			Bar.Size = UDim2.new(0.9, 0, 0, 4)
			Bar.Position = UDim2.new(0.05, 0, 0.75, 0)
			Bar.BackgroundColor3 = Theme.Inactive
			Bar.Parent = S
			Instance.new("UICorner", Bar)
			
			local Fill = Instance.new("Frame")
			Fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
			Fill.BackgroundColor3 = Color3.new(1,1,1)
			Fill.Parent = Bar
			Instance.new("UICorner", Fill)
			ApplySuperNeon(Fill)

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

return Library
