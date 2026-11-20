local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("CustomMobileHub") then
	playerGui.CustomMobileHub:Destroy()
end

local Library = {}

function Library:CreateWindow(config)
	local titleText = (config and config.Title) or "ZENOX HUB 1.0"

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CustomMobileHub"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui

	local Colors = {
		MainBg = Color3.fromRGB(22, 24, 30),
		SidebarBg = Color3.fromRGB(18, 20, 25),
		TopbarBg = Color3.fromRGB(16, 18, 22),
		CardBg = Color3.fromRGB(30, 33, 41),
		InputBg = Color3.fromRGB(20, 22, 28),
		TextPrimary = Color3.fromRGB(240, 242, 248),
		TextSecondary = Color3.fromRGB(155, 160, 175),
		Accent = Color3.fromRGB(130, 85, 255),
		ToggleOn = Color3.fromRGB(65, 175, 245),
		ToggleOff = Color3.fromRGB(55, 60, 72)
	}

	local floatBtn = Instance.new("TextButton")
	floatBtn.Name = "FloatingToggle"
	floatBtn.Size = UDim2.fromOffset(48, 48)
	floatBtn.Position = UDim2.new(0.04, 0, 0.2, 0)
	floatBtn.BackgroundColor3 = Colors.TopbarBg
	floatBtn.Text = "UI"
	floatBtn.TextColor3 = Colors.TextPrimary
	floatBtn.Font = Enum.Font.GothamBold
	floatBtn.TextSize = 15
	floatBtn.Visible = false
	floatBtn.Parent = screenGui

	Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(1, 0)
	local floatStroke = Instance.new("UIStroke", floatBtn)
	floatStroke.Color = Colors.Accent
	floatStroke.Thickness = 2

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.fromOffset(480, 295)
	mainFrame.Position = UDim2.new(0.5, -240, 0.5, -147)
	mainFrame.BackgroundColor3 = Colors.MainBg
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = screenGui

	Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
	local mainStroke = Instance.new("UIStroke", mainFrame)
	mainStroke.Color = Colors.Accent
	mainStroke.Thickness = 1.5

	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 34)
	topBar.BackgroundColor3 = Colors.TopbarBg
	topBar.BorderSizePixel = 0
	topBar.Parent = mainFrame

	local topTitle = Instance.new("TextLabel")
	topTitle.Size = UDim2.new(1, -110, 1, 0)
	topTitle.Position = UDim2.fromOffset(14, 0)
	topTitle.BackgroundTransparency = 1
	topTitle.Text = titleText
	topTitle.TextColor3 = Colors.TextPrimary
	topTitle.Font = Enum.Font.GothamSemibold
	topTitle.TextSize = 13
	topTitle.TextXAlignment = Enum.TextXAlignment.Left
	topTitle.Parent = topBar

	local function createTopBtn(symbol, offsetX, callback)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.fromOffset(28, 28)
		btn.Position = UDim2.new(1, offsetX, 0.5, -14)
		btn.BackgroundTransparency = 1
		btn.Text = symbol
		btn.TextColor3 = Colors.TextSecondary
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 14
		btn.Parent = topBar
		btn.MouseButton1Click:Connect(callback)
	end

	createTopBtn("✕", -32, function() screenGui:Destroy() end)

	local isExpanded = false
	createTopBtn("□", -62, function()
		isExpanded = not isExpanded
		TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
			Size = isExpanded and UDim2.fromOffset(550, 330) or UDim2.fromOffset(480, 295),
			Position = isExpanded and UDim2.new(0.5, -275, 0.5, -165) or UDim2.new(0.5, -240, 0.5, -147)
		}):Play()
	end)

	createTopBtn("—", -92, function()
		mainFrame.Visible = false
		floatBtn.Visible = true
	end)

	local function makeDraggable(dragTarget, moveTarget, onClickNoDrag)
		local dragging, dragMoved, dragInput, dragStart, startPos = false, false, nil, nil, nil
		dragTarget.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				dragMoved = false
				dragStart = input.Position
				startPos = moveTarget.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
						if not dragMoved and onClickNoDrag then onClickNoDrag() end
					end
				end)
			end
		end)
		dragTarget.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
				dragInput = input
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				local delta = input.Position - dragStart
				if delta.Magnitude > 6 then dragMoved = true end
				moveTarget.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
	end

	makeDraggable(topBar, mainFrame, nil)
	makeDraggable(floatBtn, floatBtn, function()
		floatBtn.Visible = false
		mainFrame.Visible = true
	end)
  	local sidebar = Instance.new("ScrollingFrame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, 130, 1, -86)
	sidebar.Position = UDim2.fromOffset(0, 34)
	sidebar.BackgroundColor3 = Colors.SidebarBg
	sidebar.BorderSizePixel = 0
	sidebar.ScrollBarThickness = 2
	sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
	sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
	sidebar.Parent = mainFrame

	local padSide = Instance.new("UIPadding", sidebar)
	padSide.PaddingTop = UDim.new(0, 8)
	padSide.PaddingLeft = UDim.new(0, 8)
	padSide.PaddingRight = UDim.new(0, 8)

	local laySide = Instance.new("UIListLayout", sidebar)
	laySide.Padding = UDim.new(0, 6)
	laySide.SortOrder = Enum.SortOrder.LayoutOrder

	local profileCard = Instance.new("Frame")
	profileCard.Name = "ZenoxAvatarProfile"
	profileCard.Size = UDim2.fromOffset(118, 40)
	profileCard.Position = UDim2.new(0, 6, 1, -46)
	profileCard.BackgroundColor3 = Colors.TopbarBg
	profileCard.BackgroundTransparency = 0.05
	profileCard.ZIndex = 12
	profileCard.Parent = mainFrame

	Instance.new("UICorner", profileCard).CornerRadius = UDim.new(0, 8)
	local pStroke = Instance.new("UIStroke", profileCard)
	pStroke.Color = Colors.Accent
	pStroke.Thickness = 1.2

	local avatarImg = Instance.new("ImageLabel")
	avatarImg.Name = "AvatarIcon"
	avatarImg.Size = UDim2.fromOffset(28, 28)
	avatarImg.Position = UDim2.new(0, 5, 0.5, -14)
	avatarImg.BackgroundColor3 = Colors.CardBg
	avatarImg.ZIndex = 13
	avatarImg.Parent = profileCard

	Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)
	local aStroke = Instance.new("UIStroke", avatarImg)
	aStroke.Color = Color3.fromRGB(255, 255, 255)
	aStroke.Thickness = 1.2

	task.spawn(function()
		pcall(function()
			local content, isReady = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
			if isReady and avatarImg and avatarImg.Parent then avatarImg.Image = content end
		end)
	end)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "RainbowUsername"
	nameLabel.Size = UDim2.new(1, -38, 1, 0)
	nameLabel.Position = UDim2.fromOffset(36, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = player.Name
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 10
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	nameLabel.ZIndex = 13
	nameLabel.Parent = profileCard

	local rainbowGrad = Instance.new("UIGradient", nameLabel)
	rainbowGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 65, 85)),
		ColorSequenceKeypoint.new(0.20, Color3.fromRGB(255, 185, 45)),
		ColorSequenceKeypoint.new(0.40, Color3.fromRGB(95, 255, 120)),
		ColorSequenceKeypoint.new(0.60, Color3.fromRGB(65, 195, 255)),
		ColorSequenceKeypoint.new(0.80, Color3.fromRGB(165, 95, 255)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 75, 195))
	})

	local avatarRainbowGrad = Instance.new("UIGradient", aStroke)
	avatarRainbowGrad.Color = rainbowGrad.Color

	task.spawn(function()
		local offset = 0
		while profileCard and profileCard.Parent do
			local dt = RunService.RenderStepped:Wait()
			offset = (offset + dt * 0.35) % 1
			rainbowGrad.Offset = Vector2.new(offset, 0)
			avatarRainbowGrad.Rotation = (offset * 360) % 360
		end
	end)

	local pagesFolder = Instance.new("Folder", mainFrame)
	pagesFolder.Name = "Pages"

	local tabs, firstTab, WindowObj = {}, true, {}

	function WindowObj:AddTab(tabName, iconText)
		local tabBtn = Instance.new("TextButton")
		tabBtn.Name = tabName .. "_Tab"
		tabBtn.Size = UDim2.new(1, 0, 0, 32)
		tabBtn.BackgroundColor3 = Colors.CardBg
		tabBtn.BackgroundTransparency = 1
		tabBtn.Text = ""
		tabBtn.AutoButtonColor = false
		tabBtn.Parent = sidebar

		Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
		local tabStroke = Instance.new("UIStroke", tabBtn)
		tabStroke.Color = Colors.Accent
		tabStroke.Thickness = 1.2
		tabStroke.Transparency = 1

		local indicator = Instance.new("Frame", tabBtn)
		indicator.Size = UDim2.new(0, 3, 0.6, 0)
		indicator.Position = UDim2.new(0, 3, 0.2, 0)
		indicator.BackgroundColor3 = Colors.ToggleOn
		indicator.BorderSizePixel = 0
		indicator.Visible = false
		Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

		local tabLabel = Instance.new("TextLabel", tabBtn)
		tabLabel.Size = UDim2.new(1, -16, 1, 0)
		tabLabel.Position = UDim2.fromOffset(12, 0)
		tabLabel.BackgroundTransparency = 1
		tabLabel.Text = (iconText and (iconText .. "  ") or "") .. tabName
		tabLabel.TextColor3 = Colors.TextSecondary
		tabLabel.Font = Enum.Font.GothamSemibold
		tabLabel.TextSize = 12
		tabLabel.TextXAlignment = Enum.TextXAlignment.Left

		local page = Instance.new("ScrollingFrame")
		page.Name = tabName .. "_Page"
		page.Size = UDim2.new(1, -130, 1, -34)
		page.Position = UDim2.fromOffset(130, 34)
		page.BackgroundTransparency = 1
		page.BorderSizePixel = 0
		page.ScrollBarThickness = 3
		page.ScrollBarImageColor3 = Colors.Accent
		page.CanvasSize = UDim2.new(0, 0, 0, 0)
		page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		page.Visible = false
		page.Parent = pagesFolder

		local pagePad = Instance.new("UIPadding", page)
		pagePad.PaddingTop = UDim.new(0, 10)
		pagePad.PaddingLeft = UDim.new(0, 14)
		pagePad.PaddingRight = UDim.new(0, 14)
		pagePad.PaddingBottom = UDim.new(0, 14)

		local pageLay = Instance.new("UIListLayout", page)
		pageLay.Padding = UDim.new(0, 8)
		pageLay.SortOrder = Enum.SortOrder.LayoutOrder

		local header = Instance.new("TextLabel", page)
		header.Size = UDim2.new(1, 0, 0, 26)
		header.BackgroundTransparency = 1
		header.Text = tabName
		header.TextColor3 = Colors.TextPrimary
		header.Font = Enum.Font.GothamBold
		header.TextSize = 18
		header.TextXAlignment = Enum.TextXAlignment.Left

		local function selectTab()
			for _, t in ipairs(tabs) do
				t.Page.Visible = false
				t.Btn.BackgroundTransparency = 1
				t.Stroke.Transparency = 1
				t.Indicator.Visible = false
				t.Label.TextColor3 = Colors.TextSecondary
			end
			page.Visible = true
			tabBtn.BackgroundTransparency = 0
			tabStroke.Transparency = 0
			indicator.Visible = true
			tabLabel.TextColor3 = Colors.TextPrimary
		end

		tabBtn.MouseButton1Click:Connect(selectTab)
		table.insert(tabs, { Btn = tabBtn, Stroke = tabStroke, Indicator = indicator, Label = tabLabel, Page = page })
		if firstTab then firstTab = false; selectTab() end

		local TabObj = { Page = page, ScreenGui = screenGui }

		function TabObj:AddSection(secName)
			local lbl = Instance.new("TextLabel", page)
			lbl.Size = UDim2.new(1, 0, 0, 20)
			lbl.BackgroundTransparency = 1
			lbl.Text = secName
			lbl.TextColor3 = Colors.TextPrimary
			lbl.Font = Enum.Font.GothamBold
			lbl.TextSize = 14
			lbl.TextXAlignment = Enum.TextXAlignment.Left
		end

		function TabObj:AddToggle(titleStr, descStr, defaultState, callback)
			local state = defaultState or false
			local card = Instance.new("TextButton", page)
			card.Size = UDim2.new(1, 0, 0, descStr and 48 or 38)
			card.BackgroundColor3 = Colors.CardBg
			card.Text = ""
			card.AutoButtonColor = false
			Instance.new("UICorner", card).CornerRadius = UDim.new(0, 7)
			local stroke = Instance.new("UIStroke", card)
			stroke.Color = Color3.fromRGB(48, 52, 65)
			stroke.Thickness = 1

			local tLbl = Instance.new("TextLabel", card)
			tLbl.Size = UDim2.new(1, -66, 0, 18)
			tLbl.Position = UDim2.fromOffset(12, descStr and 7 or 10)
			tLbl.BackgroundTransparency = 1
			tLbl.Text = titleStr
			tLbl.TextColor3 = Colors.TextPrimary
			tLbl.Font = Enum.Font.GothamBold
			tLbl.TextSize = 12
			tLbl.TextXAlignment = Enum.TextXAlignment.Left

			if descStr then
				local dLbl = Instance.new("TextLabel", card)
				dLbl.Size = UDim2.new(1, -66, 0, 16)
				dLbl.Position = UDim2.fromOffset(12, 25)
				dLbl.BackgroundTransparency = 1
				dLbl.Text = descStr
				dLbl.TextColor3 = Colors.TextSecondary
				dLbl.Font = Enum.Font.Gotham
				dLbl.TextSize = 11
				dLbl.TextXAlignment = Enum.TextXAlignment.Left
			end

			local swBg = Instance.new("Frame", card)
			swBg.Size = UDim2.fromOffset(40, 20)
			swBg.Position = UDim2.new(1, -52, 0.5, -10)
			swBg.BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff
			Instance.new("UICorner", swBg).CornerRadius = UDim.new(1, 0)

			local knob = Instance.new("Frame", swBg)
			knob.Size = UDim2.fromOffset(14, 14)
			knob.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
			knob.BackgroundColor3 = Color3.fromRGB(245, 248, 255)
			Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

			card.MouseButton1Click:Connect(function()
				state = not state
				TweenService:Create(swBg, TweenInfo.new(0.18), { BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff }):Play()
				TweenService:Create(knob, TweenInfo.new(0.18), { Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7) }):Play()
				if callback then callback(state) end
			end)
		end

		function TabObj:AddNumberSlider(titleStr, descStr, minVal, maxVal, defaultVal, callback)
			local currentVal = math.clamp(defaultVal or minVal, minVal, maxVal)
			local card = Instance.new("Frame", page)
			card.Size = UDim2.new(1, 0, 0, 68)
			card.BackgroundColor3 = Colors.CardBg
			Instance.new("UICorner", card).CornerRadius = UDim.new(0, 7)
			local stroke = Instance.new("UIStroke", card)
			stroke.Color = Color3.fromRGB(48, 52, 65)
			stroke.Thickness = 1

			local tLbl = Instance.new("TextLabel", card)
			tLbl.Size = UDim2.new(1, -86, 0, 18)
			tLbl.Position = UDim2.fromOffset(12, 7)
			tLbl.BackgroundTransparency = 1
			tLbl.Text = titleStr
			tLbl.TextColor3 = Colors.TextPrimary
			tLbl.Font = Enum.Font.GothamBold
			tLbl.TextSize = 12
			tLbl.TextXAlignment = Enum.TextXAlignment.Left

			if descStr then
				local dLbl = Instance.new("TextLabel", card)
				dLbl.Size = UDim2.new(1, -86, 0, 14)
				dLbl.Position = UDim2.fromOffset(12, 23)
				dLbl.BackgroundTransparency = 1
				dLbl.Text = descStr
				dLbl.TextColor3 = Colors.TextSecondary
				dLbl.Font = Enum.Font.Gotham
				dLbl.TextSize = 10
				dLbl.TextXAlignment = Enum.TextXAlignment.Left
			end

			local box = Instance.new("TextBox", card)
			box.Size = UDim2.fromOffset(58, 24)
			box.Position = UDim2.new(1, -70, 0, 8)
			box.BackgroundColor3 = Colors.InputBg
			box.Text = tostring(currentVal)
			box.TextColor3 = Colors.ToggleOn
			box.Font = Enum.Font.GothamBold
			box.TextSize = 12
			box.ClearTextOnFocus = false
			Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
			local bStroke = Instance.new("UIStroke", box)
			bStroke.Color = Colors.Accent
			bStroke.Thickness = 1

			local track = Instance.new("Frame", card)
			track.Size = UDim2.new(1, -24, 0, 8)
			track.Position = UDim2.new(0, 12, 1, -18)
			track.BackgroundColor3 = Colors.ToggleOff
			Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

			local fill = Instance.new("Frame", track)
			fill.Size = UDim2.new((currentVal - minVal) / (maxVal - minVal), 0, 1, 0)
			fill.BackgroundColor3 = Colors.ToggleOn
			Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

			local thumb = Instance.new("TextButton", track)
			thumb.Size = UDim2.fromOffset(16, 16)
			thumb.Position = UDim2.new((currentVal - minVal) / (maxVal - minVal), -8, 0.5, -8)
			thumb.BackgroundColor3 = Color3.fromRGB(245, 248, 255)
			thumb.Text = ""
			thumb.AutoButtonColor = false
			Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)

			local function setVal(v)
				local num = tonumber(v)
				if not num then box.Text = tostring(currentVal); return end
				currentVal = math.clamp(math.floor(num + 0.5), minVal, maxVal)
				local r = (currentVal - minVal) / (maxVal - minVal)
				fill.Size = UDim2.new(r, 0, 1, 0)
				thumb.Position = UDim2.new(r, -8, 0.5, -8)
				box.Text = tostring(currentVal)
				if callback then callback(currentVal) end
			end

			local sliding = false
			local function updX(x)
				if track.AbsoluteSize.X <= 0 then return end
				local r = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
				setVal(minVal + r * (maxVal - minVal))
			end
			local function beginS(inp)
				if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
					sliding = true; updX(inp.Position.X)
					inp.Changed:Connect(function() if inp.UserInputState == Enum.UserInputState.End then sliding = false end end)
				end
			end
			track.InputBegan:Connect(beginS)
			thumb.InputBegan:Connect(beginS)
			UserInputService.InputChanged:Connect(function(inp)
				if sliding and (inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseMovement) then
					updX(inp.Position.X)
				end
			end)
			box.FocusLost:Connect(function() setVal(box.Text) end)
		end

		function TabObj:AddColorPickerPopup(titleStr, descStr, colorList, defaultName, callback)
			local selectedName = defaultName or (colorList[1] and colorList[1].Name) or "ม่วง"
			local card = Instance.new("TextButton", page)
			card.Size = UDim2.new(1, 0, 0, descStr and 48 or 38)
			card.BackgroundColor3 = Colors.CardBg
			card.Text = ""
			card.AutoButtonColor = false
			Instance.new("UICorner", card).CornerRadius = UDim.new(0, 7)
			local stroke = Instance.new("UIStroke", card)
			stroke.Color = Color3.fromRGB(48, 52, 65)
			stroke.Thickness = 1

			local tLbl = Instance.new("TextLabel", card)
			tLbl.Size = UDim2.new(1, -110, 0, 18)
			tLbl.Position = UDim2.fromOffset(12, descStr and 7 or 10)
			tLbl.BackgroundTransparency = 1
			tLbl.Text = titleStr
			tLbl.TextColor3 = Colors.TextPrimary
			tLbl.Font = Enum.Font.GothamBold
			tLbl.TextSize = 12
			tLbl.TextXAlignment = Enum.TextXAlignment.Left

			if descStr then
				local dLbl = Instance.new("TextLabel", card)
				dLbl.Size = UDim2.new(1, -110, 0, 16)
				dLbl.Position = UDim2.fromOffset(12, 25)
				dLbl.BackgroundTransparency = 1
				dLbl.Text = descStr
				dLbl.TextColor3 = Colors.TextSecondary
				dLbl.Font = Enum.Font.Gotham
				dLbl.TextSize = 11
				dLbl.TextXAlignment = Enum.TextXAlignment.Left
			end

			local badge = Instance.new("TextLabel", card)
			badge.Size = UDim2.fromOffset(86, 24)
			badge.Position = UDim2.new(1, -96, 0.5, -12)
			badge.BackgroundColor3 = Colors.InputBg
			badge.Text = "สี: " .. selectedName .. " >"
			badge.TextColor3 = Colors.ToggleOn
			badge.Font = Enum.Font.GothamBold
			badge.TextSize = 11
			Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 5)
			local bStroke = Instance.new("UIStroke", badge)
			bStroke.Color = Colors.Accent
			bStroke.Thickness = 1

			local popup = Instance.new("Frame", screenGui)
			popup.Name = "ColorPickerPopup"
			popup.Size = UDim2.fromOffset(250, 215)
			popup.Position = UDim2.new(0.5, -125, 0.5, -107)
			popup.BackgroundColor3 = Colors.MainBg
			popup.ZIndex = 20
			popup.Visible = false
			Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 10)
			local pStroke = Instance.new("UIStroke", popup)
			pStroke.Color = Colors.Accent
			pStroke.Thickness = 2

			local pTitle = Instance.new("TextLabel", popup)
			pTitle.Size = UDim2.new(1, -40, 0, 30)
			pTitle.Position = UDim2.fromOffset(12, 4)
			pTitle.BackgroundTransparency = 1
			pTitle.Text = "เลือกสีมองผู้เล่น"
			pTitle.TextColor3 = Colors.TextPrimary
			pTitle.Font = Enum.Font.GothamBold
			pTitle.TextSize = 13
			pTitle.TextXAlignment = Enum.TextXAlignment.Left
			pTitle.ZIndex = 21

			local closeBtn = Instance.new("TextButton", popup)
			closeBtn.Size = UDim2.fromOffset(26, 26)
			closeBtn.Position = UDim2.new(1, -32, 0, 6)
			closeBtn.BackgroundTransparency = 1
			closeBtn.Text = "✕"
			closeBtn.TextColor3 = Colors.TextSecondary
			closeBtn.Font = Enum.Font.GothamBold
			closeBtn.TextSize = 13
			closeBtn.ZIndex = 21
			closeBtn.MouseButton1Click:Connect(function() popup.Visible = false end)

			local holder = Instance.new("Frame", popup)
			holder.Size = UDim2.new(1, -20, 1, -42)
			holder.Position = UDim2.fromOffset(10, 36)
			holder.BackgroundTransparency = 1
			holder.ZIndex = 21
			local listLay = Instance.new("UIListLayout", holder)
			listLay.Padding = UDim.new(0, 5)
			listLay.SortOrder = Enum.SortOrder.LayoutOrder

			for _, item in ipairs(colorList) do
				local opt = Instance.new("TextButton", holder)
				opt.Size = UDim2.new(1, 0, 0, 27)
				opt.BackgroundColor3 = Colors.CardBg
				opt.Text = ""
				opt.AutoButtonColor = false
				opt.ZIndex = 22
				Instance.new("UICorner", opt).CornerRadius = UDim.new(0, 6)

				local sw = Instance.new("Frame", opt)
				sw.Size = UDim2.fromOffset(16, 16)
				sw.Position = UDim2.new(0, 10, 0.5, -8)
				sw.BackgroundColor3 = item.Color or Color3.fromRGB(255, 255, 255)
				sw.BorderSizePixel = 0
				sw.ZIndex = 23
				Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)

				if item.IsRainbow then
					local grad = Instance.new("UIGradient", sw)
					grad.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 65, 65)),
						ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 200, 50)),
						ColorSequenceKeypoint.new(0.5, Color3.fromRGB(65, 255, 130)),
						ColorSequenceKeypoint.new(0.75, Color3.fromRGB(65, 175, 255)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(185, 75, 255))
					})
				end

				local lbl = Instance.new("TextLabel", opt)
				lbl.Size = UDim2.new(1, -36, 1, 0)
				lbl.Position = UDim2.fromOffset(34, 0)
				lbl.BackgroundTransparency = 1
				lbl.Text = item.Name
				lbl.TextColor3 = Colors.TextPrimary
				lbl.Font = Enum.Font.GothamSemibold
				lbl.TextSize = 12
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				lbl.ZIndex = 23

				opt.MouseButton1Click:Connect(function()
					selectedName = item.Name
					badge.Text = "สี: " .. selectedName .. " >"
					popup.Visible = false
					if callback then callback(item.Name, item.Color, item.IsRainbow) end
				end)
			end

			card.MouseButton1Click:Connect(function() popup.Visible = not popup.Visible end)
		end

		return TabObj
	end

	return WindowObj
end
local Window = Library:CreateWindow({ Title = "ZENOX HUB 1.0" })
local GeneralTab = Window:AddTab("General", "🏠")
local CharTab = Window:AddTab("Character", "👤")
local VisualsTab = Window:AddTab("Visuals", "👁️")
local SettingsTab = Window:AddTab("Settings", "⚙️")

local faceNearestEnabled = false
local function getNearestTarget(maxRange)
	local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not myRoot then return nil end
	local closest, distMin = nil, maxRange or math.huge
	for _, m in ipairs(workspace:GetDescendants()) do
		if m:IsA("Model") and m ~= player.Character then
			local hum, root = m:FindFirstChildOfClass("Humanoid"), m:FindFirstChild("HumanoidRootPart")
			if hum and root and hum.Health > 0 then
				local d = (root.Position - myRoot.Position).Magnitude
				if d < distMin then distMin = d; closest = root end
			end
		end
	end
	return closest
end

GeneralTab:AddSection("Combat / Target")
GeneralTab:AddToggle("Face Nearest Target (No Cam)", "หันหน้าตัวละครหาผู้เล่น/บอท/Dummy ใกล้สุด โดยไม่หันกล้อง", false, function(s) faceNearestEnabled = s end)

GeneralTab:AddSection("Teleport")
do
	local chosenPlayer, targetNameLbl = nil, nil
	local popupFrame = Instance.new("Frame", GeneralTab.ScreenGui)
	popupFrame.Name = "ZenoxTpPopup"
	popupFrame.Size = UDim2.fromOffset(250, 210)
	popupFrame.Position = UDim2.new(0.5, -125, 0.5, -105)
	popupFrame.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
	popupFrame.ZIndex = 35
	popupFrame.Visible = false
	Instance.new("UICorner", popupFrame).CornerRadius = UDim.new(0, 10)
	local pStroke = Instance.new("UIStroke", popupFrame)
	pStroke.Color = Color3.fromRGB(130, 85, 255)
	pStroke.Thickness = 2

	local closeX = Instance.new("TextButton", popupFrame)
	closeX.Size = UDim2.fromOffset(24, 24)
	closeX.Position = UDim2.new(1, -28, 0, 4)
	closeX.BackgroundTransparency = 1
	closeX.Text = "✕"
	closeX.TextColor3 = Color3.fromRGB(155, 160, 175)
	closeX.Font = Enum.Font.GothamBold
	closeX.TextSize = 12
	closeX.ZIndex = 36
	closeX.MouseButton1Click:Connect(function() popupFrame.Visible = false end)

	local listHolder = Instance.new("ScrollingFrame", popupFrame)
	listHolder.Size = UDim2.new(1, -14, 1, -36)
	listHolder.Position = UDim2.fromOffset(7, 30)
	listHolder.BackgroundTransparency = 1
	listHolder.BorderSizePixel = 0
	listHolder.ScrollBarThickness = 2
	listHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
	listHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
	listHolder.ZIndex = 36
	local lLay = Instance.new("UIListLayout", listHolder)
	lLay.Padding = UDim.new(0, 5)
	lLay.SortOrder = Enum.SortOrder.LayoutOrder

	local function rebuildTpList()
		for _, item in ipairs(listHolder:GetChildren()) do
			if item:IsA("TextButton") or item:IsA("TextLabel") then item:Destroy() end
		end
		local total = 0
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player then
				total += 1
				local rowBtn = Instance.new("TextButton", listHolder)
				rowBtn.Size = UDim2.new(1, -4, 0, 26)
				rowBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
				rowBtn.Text = (plr.DisplayName ~= plr.Name) and (plr.DisplayName .. " (@" .. plr.Name .. ")") or plr.Name
				rowBtn.TextColor3 = Color3.fromRGB(240, 242, 248)
				rowBtn.Font = Enum.Font.GothamSemibold
				rowBtn.TextSize = 11
				rowBtn.TextXAlignment = Enum.TextXAlignment.Left
				rowBtn.TextTruncate = Enum.TextTruncate.AtEnd
				Instance.new("UICorner", rowBtn).CornerRadius = UDim.new(0, 5)
				Instance.new("UIPadding", rowBtn).PaddingLeft = UDim.new(0, 8)
				rowBtn.MouseButton1Click:Connect(function()
					chosenPlayer = plr
					if targetNameLbl then
						targetNameLbl.Text = "เป้าหมาย: " .. rowBtn.Text
						targetNameLbl.TextColor3 = Color3.fromRGB(65, 175, 245)
					end
					popupFrame.Visible = false
				end)
			end
		end
		if total == 0 then
			local noneLbl = Instance.new("TextLabel", listHolder)
			noneLbl.Size = UDim2.new(1, 0, 0, 24)
			noneLbl.BackgroundTransparency = 1
			noneLbl.Text = "ไม่มีผู้เล่นอื่นในห้อง"
			noneLbl.TextColor3 = Color3.fromRGB(155, 160, 175)
			noneLbl.Font = Enum.Font.Gotham
			noneLbl.TextSize = 11
		end
	end

	local box = Instance.new("Frame", GeneralTab.Page)
	box.Size = UDim2.new(1, 0, 0, 74)
	box.BackgroundColor3 = Color3.fromRGB(30, 33, 41)
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 7)

	local openBtn = Instance.new("TextButton", box)
	openBtn.Size = UDim2.new(1, -16, 0, 28)
	openBtn.Position = UDim2.fromOffset(8, 8)
	openBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
	openBtn.Text = "เลือกชื่อผู้เล่นที่จะวาป  ▼"
	openBtn.TextColor3 = Color3.fromRGB(240, 242, 248)
	openBtn.Font = Enum.Font.GothamBold
	openBtn.TextSize = 11
	Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 6)

	targetNameLbl = Instance.new("TextLabel", box)
	targetNameLbl.Size = UDim2.new(1, -104, 0, 26)
	targetNameLbl.Position = UDim2.fromOffset(10, 41)
	targetNameLbl.BackgroundTransparency = 1
	targetNameLbl.Text = "เป้าหมาย: ยังไม่ได้เลือก"
	targetNameLbl.TextColor3 = Color3.fromRGB(155, 160, 175)
	targetNameLbl.Font = Enum.Font.GothamSemibold
	targetNameLbl.TextSize = 11
	targetNameLbl.TextXAlignment = Enum.TextXAlignment.Left
	targetNameLbl.TextTruncate = Enum.TextTruncate.AtEnd

	local tpBtn = Instance.new("TextButton", box)
	tpBtn.Size = UDim2.fromOffset(84, 26)
	tpBtn.Position = UDim2.new(1, -92, 0, 41)
	tpBtn.BackgroundColor3 = Color3.fromRGB(65, 175, 245)
	tpBtn.Text = "วาปไปหา"
	tpBtn.TextColor3 = Color3.fromRGB(16, 18, 22)
	tpBtn.Font = Enum.Font.GothamBold
	tpBtn.TextSize = 11
	Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)

	openBtn.MouseButton1Click:Connect(function() rebuildTpList(); popupFrame.Visible = not popupFrame.Visible end)
	tpBtn.MouseButton1Click:Connect(function()
		if not chosenPlayer or not chosenPlayer.Parent then
			targetNameLbl.Text = "เป้าหมาย: ยังไม่ได้เลือก"
			targetNameLbl.TextColor3 = Color3.fromRGB(255, 95, 110)
			return
		end
		local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		local targetRoot = chosenPlayer.Character and chosenPlayer.Character:FindFirstChild("HumanoidRootPart")
		if myRoot and targetRoot then myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3) end
	end)
end

local speedEnabled, targetSpeed = false, 16
local jumpEnabled, targetJumpPower = false, 50
local noclipEnabled, savedCollision = false, {}
local infJumpEnabled, airJumpPower, jumpCooldown = false, 50, false

local function applyJumpPower(hum, power)
	if not hum then return end
	if hum.UseJumpPower then hum.JumpPower = power
	else hum.JumpHeight = math.clamp((power * power) / (2 * workspace.Gravity), 1, 500) end
end

local function setCharacterNoclip(char, enabled)
	if not char then return end
	if enabled then
		for _, p in ipairs(char:GetDescendants()) do
			if p:IsA("BasePart") then
				if savedCollision[p] == nil then savedCollision[p] = p.CanCollide end
				p.CanCollide = false
			end
		end
	else
		for p, old in pairs(savedCollision) do
			if p and p.Parent then p.CanCollide = old end
		end
		table.clear(savedCollision)
	end
end

CharTab:AddSection("Movement")
CharTab:AddToggle("Smooth WalkSpeed", "เปิดใช้งานความเร็ววิ่งแบบลื่นไหล กันบัคเมื่อ FPS ตก", false, function(s)
	speedEnabled = s
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if hum and not s then hum.WalkSpeed = 16 end
end)
CharTab:AddNumberSlider("WalkSpeed (1 - 500)", "ลากสไลด์หรือพิมพ์ตัวเลข 1 ถึง 500 ได้เลย", 1, 500, 16, function(v) targetSpeed = v end)
CharTab:AddToggle("Custom JumpPower", "เปิดใช้งานแรงกระโดดตามค่าที่ตั้งไว้", false, function(s)
	jumpEnabled = s
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if hum and not s then applyJumpPower(hum, 50) end
end)
CharTab:AddNumberSlider("JumpPower (1 - 300)", "ลากสไลด์หรือพิมพ์ค่าแรงกระโดดได้เลย", 1, 300, 50, function(v) targetJumpPower = v end)
CharTab:AddToggle("NoClip", "เดินทะลุกำแพงและสิ่งกีดขวาง พร้อมคืนค่าการชนเมื่อปิด", false, function(s)
	noclipEnabled = s; setCharacterNoclip(player.Character, s)
end)

CharTab:AddSection("Air & Reset")
CharTab:AddToggle("Infinite Jump", "กระโดดกลางอากาศได้เรื่อยๆ ตามแรงที่ตั้งไว้", false, function(s) infJumpEnabled = s end)
CharTab:AddNumberSlider("Air Jump Power (1 - 500)", "ปรับแรงดีดตัวตอนกระโดดกลางอากาศ", 1, 500, 50, function(v) airJumpPower = v end)

do
	local resetCard = Instance.new("Frame", CharTab.Page)
	resetCard.Name = "ZenoxInstantResetCard"
	resetCard.Size = UDim2.new(1, 0, 0, 44)
	resetCard.BackgroundColor3 = Color3.fromRGB(30, 33, 41)
	Instance.new("UICorner", resetCard).CornerRadius = UDim.new(0, 7)
	local rStroke = Instance.new("UIStroke", resetCard)
	rStroke.Color = Color3.fromRGB(48, 52, 65)
	rStroke.Thickness = 1

	local rTitle = Instance.new("TextLabel", resetCard)
	rTitle.Size = UDim2.new(1, -96, 1, 0)
	rTitle.Position = UDim2.fromOffset(12, 0)
	rTitle.BackgroundTransparency = 1
	rTitle.Text = "เกิดใหม่ไว (Instant Reset)"
	rTitle.TextColor3 = Color3.fromRGB(240, 242, 248)
	rTitle.Font = Enum.Font.GothamSemibold
	rTitle.TextSize = 12
	rTitle.TextXAlignment = Enum.TextXAlignment.Left

	local resetBtn = Instance.new("TextButton", resetCard)
	resetBtn.Size = UDim2.fromOffset(76, 26)
	resetBtn.Position = UDim2.new(1, -86, 0.5, -13)
	resetBtn.BackgroundColor3 = Color3.fromRGB(220, 75, 95)
	resetBtn.Text = "เกิดใหม่"
	resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	resetBtn.Font = Enum.Font.GothamBold
	resetBtn.TextSize = 11
	Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 6)

	resetBtn.MouseButton1Click:Connect(function()
		pcall(function()
			local char = player.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum then hum.Health = 0 end
			if char then char:BreakJoints() end
		end)
	end)
end

UserInputService.JumpRequest:Connect(function()
	if not infJumpEnabled or jumpCooldown then return end
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if hum and root and hum.Health > 0 then
		local st = hum:GetState()
		if st == Enum.HumanoidStateType.Freefall or st == Enum.HumanoidStateType.Jumping then
			jumpCooldown = true
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
			root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, airJumpPower, root.AssemblyLinearVelocity.Z)
			task.delay(0.14, function() jumpCooldown = false end)
		end
	end
end)
local espEnabled, espStaticColor, espRainbow, highlights = false, Color3.fromRGB(165, 65, 255), false, {}
local espColors = {
	{ Name = "ส้ม", Color = Color3.fromRGB(255, 135, 35), IsRainbow = false },
	{ Name = "ขาว", Color = Color3.fromRGB(245, 248, 255), IsRainbow = false },
	{ Name = "แดง", Color = Color3.fromRGB(255, 60, 80), IsRainbow = false },
	{ Name = "ม่วง", Color = Color3.fromRGB(165, 65, 255), IsRainbow = false },
	{ Name = "เรนโบว์", Color = Color3.fromRGB(255, 255, 255), IsRainbow = true }
}

local function getEspColor()
	if espRainbow then return Color3.fromHSV((os.clock() * 0.35) % 1, 0.9, 1) end
	return espStaticColor
end

local function clearHighlights()
	for p, hl in pairs(highlights) do if hl then hl:Destroy() end; highlights[p] = nil end
end

local function applyHighlight(plr)
	if plr == player or not espEnabled or not plr.Character then return end
	local hl = highlights[plr]
	if not hl or not hl.Parent then
		hl = Instance.new("Highlight")
		hl.Name = "ZenoxESP_Highlight"
		hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		hl.FillTransparency = 0.55
		hl.OutlineTransparency = 0
		hl.Adornee = plr.Character
		hl.Parent = plr.Character
		highlights[plr] = hl
	end
	local col = getEspColor()
	hl.FillColor, hl.OutlineColor = col, col
end

local function refreshHighlights()
	if not espEnabled then clearHighlights(); return end
	for _, plr in ipairs(Players:GetPlayers()) do if plr ~= player then applyHighlight(plr) end end
end

VisualsTab:AddSection("Player ESP")
VisualsTab:AddColorPickerPopup("เลือกสีมองผู้เล่น", "กดเพื่อเปิดหน้าต่างเลือกสี (ส้ม / ขาว / แดง / ม่วง / เรนโบว์)", espColors, "ม่วง", function(_, col, rb)
	espStaticColor, espRainbow = col, rb; refreshHighlights()
end)
VisualsTab:AddToggle("เปิดมองผู้เล่น", "ไฮไลต์ผู้เล่นอื่นทะลุกำแพงตามสีที่เลือก", false, function(s)
	espEnabled = s; if s then refreshHighlights() else clearHighlights() end
end)

local entityEspEnabled, redDistEnabled, pinkTracerEnabled = false, false, false
local entityHighlights, distGuis, tracerLines, tracerUiLines = {}, {}, {}, {}
local lastEntityScan, lastDistUpdate, cachedEntities = 0, 0, {}

local GREEN_ENTITY_COLOR = Color3.fromRGB(45, 255, 115)
local SHARP_RED_COLOR = Color3.fromRGB(255, 45, 65)
local BRIGHT_PINK_COLOR = Color3.fromRGB(255, 75, 185)

local tracerGui = Instance.new("ScreenGui")
tracerGui.Name = "ZenoxPinkTracerGui"
tracerGui.ResetOnSpawn = false
tracerGui.IgnoreGuiInset = true
tracerGui.DisplayOrder = 50
tracerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
tracerGui.Parent = playerGui

local function isPlayerCharacterModel(model)
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Character == model then return true end
	end
	return false
end

local function scanEntitiesNow()
	local results = {}
	local myChar = player.Character
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj ~= myChar and not isPlayerCharacterModel(obj) then
			local hum = obj:FindFirstChildOfClass("Humanoid")
			local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head") or obj:FindFirstChildWhichIsA("BasePart")
			local nameLower = obj.Name:lower()
			local looksLikeEntity = (hum ~= nil and hum.Health > 0)
				or nameLower:find("bot")
				or nameLower:find("ghost")
				or nameLower:find("dummy")
				or nameLower:find("entity")
				or nameLower:find("monster")
				or nameLower:find("monochrome")
				or nameLower:find("npc")

			if looksLikeEntity and root and root:IsA("BasePart") then
				table.insert(results, { Model = obj, Root = root })
			end
		end
	end
	cachedEntities = results
	return results
end

local function getActiveEspTargets()
	local targets = {}
	if espEnabled then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character then
				local root = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChildWhichIsA("BasePart")
				if root then
					table.insert(targets, {
						Key = "Plr_" .. tostring(plr.UserId),
						Label = plr.Name,
						Root = root
					})
				end
			end
		end
	end
	if entityEspEnabled then
		for i, ent in ipairs(cachedEntities) do
			if ent.Model and ent.Model.Parent and ent.Root and ent.Root.Parent then
				table.insert(targets, {
					Key = "Ent_" .. tostring(i) .. "_" .. ent.Model.Name,
					Label = ent.Model.Name,
					Root = ent.Root
				})
			end
		end
	end
	return targets
end

local function clearEntityHighlights()
	for model, hl in pairs(entityHighlights) do
		pcall(function() if hl then hl:Destroy() end end)
		entityHighlights[model] = nil
	end
	table.clear(cachedEntities)
end

local function clearDistGuis()
	for key, gui in pairs(distGuis) do
		pcall(function() if gui then gui:Destroy() end end)
		distGuis[key] = nil
	end
end

local function clearTracers()
	for key, line in pairs(tracerLines) do
		pcall(function() line.Visible = false; line:Remove() end)
		tracerLines[key] = nil
	end
	for key, frameLine in pairs(tracerUiLines) do
		pcall(function() if frameLine then frameLine:Destroy() end end)
		tracerUiLines[key] = nil
	end
end

local function refreshEntityHighlights(forceScan)
	if not entityEspEnabled then clearEntityHighlights(); return end
	local now = os.clock()
	if forceScan or (now - lastEntityScan) >= 0.75 then
		lastEntityScan = now
		scanEntitiesNow()
	end
	local activeSet = {}
	for _, ent in ipairs(cachedEntities) do
		local m = ent.Model
		if m and m.Parent then
			activeSet[m] = true
			local hl = entityHighlights[m]
			if not hl or not hl.Parent then
				hl = Instance.new("Highlight")
				hl.Name = "ZenoxEntityESP_Green"
				hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				hl.FillTransparency = 0.52
				hl.OutlineTransparency = 0
				hl.FillColor = GREEN_ENTITY_COLOR
				hl.OutlineColor = GREEN_ENTITY_COLOR
				hl.Adornee = m
				hl.Parent = m
				entityHighlights[m] = hl
			end
		end
	end
	for m, hl in pairs(entityHighlights) do
		if not activeSet[m] then
			pcall(function() if hl then hl:Destroy() end end)
			entityHighlights[m] = nil
		end
	end
end

local function updateRedDistances(targets)
	if not redDistEnabled then clearDistGuis(); return end
	local myRoot = player.Character and (player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChildWhichIsA("BasePart"))
	local aliveKeys = {}
	for _, item in ipairs(targets) do
		if item.Root and item.Root.Parent then
			aliveKeys[item.Key] = true
			local bb = distGuis[item.Key]
			if not bb or not bb.Parent then
				bb = Instance.new("BillboardGui")
				bb.Name = "ZenoxRedDistGui"
				bb.AlwaysOnTop = true
				bb.MaxDistance = 1500
				bb.Size = UDim2.fromOffset(140, 28)
				bb.StudsOffset = Vector3.new(0, 3.2, 0)
				bb.Adornee = item.Root
				bb.Parent = playerGui

				local txt = Instance.new("TextLabel")
				txt.Name = "DistLabel"
				txt.Size = UDim2.fromScale(1, 1)
				txt.BackgroundTransparency = 1
				txt.Font = Enum.Font.GothamBlack
				txt.TextSize = 13
				txt.TextColor3 = SHARP_RED_COLOR
				txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
				txt.TextStrokeTransparency = 0
				txt.Parent = bb

				distGuis[item.Key] = bb
			else
				bb.Adornee = item.Root
			end
			local lbl = bb:FindFirstChild("DistLabel")
			if lbl and lbl:IsA("TextLabel") then
				local distText = myRoot and (math.floor((item.Root.Position - myRoot.Position).Magnitude + 0.5) .. "m") or "?"
				lbl.Text = item.Label .. " [" .. distText .. "]"
				lbl.TextColor3 = SHARP_RED_COLOR
			end
		end
	end
	for k, bb in pairs(distGuis) do
		if not aliveKeys[k] then
			pcall(function() if bb then bb:Destroy() end end)
			distGuis[k] = nil
		end
	end
end

local function positionUiLine(frameObj, p1, p2)
	local dx, dy = p2.X - p1.X, p2.Y - p1.Y
	local dist = math.sqrt(dx * dx + dy * dy)
	if dist <= 1 then frameObj.Visible = false; return end
	frameObj.Visible = true
	frameObj.Size = UDim2.fromOffset(dist, 2.5)
	frameObj.Position = UDim2.fromOffset((p1.X + p2.X) * 0.5, (p1.Y + p2.Y) * 0.5)
	frameObj.Rotation = math.deg(math.atan2(dy, dx))
end

local function updatePinkTracers(targets)
	if not pinkTracerEnabled then clearTracers(); return end
	local cam = workspace.CurrentCamera
	if not cam then return end
	local vp = cam.ViewportSize
	local startPos = Vector2.new(vp.X * 0.5, vp.Y * 0.88)
	local canUseDrawing = (type(Drawing) == "table" and type(Drawing.new) == "function")
	local aliveKeys = {}

	for _, item in ipairs(targets) do
		if item.Root and item.Root.Parent then
			aliveKeys[item.Key] = true
			local screenPos, onScreen = cam:WorldToViewportPoint(item.Root.Position)
			local endPos = Vector2.new(screenPos.X, screenPos.Y)
			local visibleTarget = onScreen and (screenPos.Z > 0)

			if canUseDrawing then
				local line = tracerLines[item.Key]
				if not line then
					local ok, created = pcall(function()
						local l = Drawing.new("Line")
						l.Thickness = 2
						l.Transparency = 1
						l.Color = BRIGHT_PINK_COLOR
						return l
					end)
					if ok and created then line = created; tracerLines[item.Key] = line end
				end
				if line then
					line.Color = BRIGHT_PINK_COLOR
					line.From = startPos
					line.To = endPos
					line.Visible = visibleTarget
				end
			end

			local uiLine = tracerUiLines[item.Key]
			if not uiLine or not uiLine.Parent then
				uiLine = Instance.new("Frame")
				uiLine.Name = "ZenoxPinkTracerUiLine"
				uiLine.AnchorPoint = Vector2.new(0.5, 0.5)
				uiLine.BackgroundColor3 = BRIGHT_PINK_COLOR
				uiLine.BorderSizePixel = 0
				uiLine.Parent = tracerGui
				tracerUiLines[item.Key] = uiLine
			end
			if visibleTarget then positionUiLine(uiLine, startPos, endPos) else uiLine.Visible = false end
		end
	end

	for k, line in pairs(tracerLines) do
		if not aliveKeys[k] then pcall(function() line.Visible = false; line:Remove() end); tracerLines[k] = nil end
	end
	for k, uiLine in pairs(tracerUiLines) do
		if not aliveKeys[k] then pcall(function() if uiLine then uiLine:Destroy() end end); tracerUiLines[k] = nil end
	end
end

VisualsTab:AddSection("Entities & Tracers")
VisualsTab:AddToggle("ESP บอท/ผี/ดัมมี่/เอนทิตี้ (เขียวเท่านั้น)", "ไฮไลต์บอท ผี ดัมมี่ เอนทิตี้ และโมโนโครมเป็นสีเขียวล็อกตายตัว", false, function(s)
	entityEspEnabled = s; refreshEntityHighlights(true)
end)
VisualsTab:AddToggle("ระยะห่างสีแดงคมชัด (Red Distance)", "โชว์ชื่อและระยะห่างของเป้าหมายที่มองอยู่ด้วยสีแดงคมชัด", false, function(s)
	redDistEnabled = s; if not s then clearDistGuis() end
end)
VisualsTab:AddToggle("เส้นสีชมพูตาม ESP (Pink Tracer)", "ลากเส้นสีชมพูขยับตามเป้าหมายที่ระบบ ESP กำลังมองเห็น", false, function(s)
	pinkTracerEnabled = s; if not s then clearTracers() end
end)

RunService.RenderStepped:Connect(function()
	if entityEspEnabled then refreshEntityHighlights(false) end
	if redDistEnabled or pinkTracerEnabled then
		local activeTargets = getActiveEspTargets()
		if pinkTracerEnabled then updatePinkTracers(activeTargets) end
		if redDistEnabled and (os.clock() - lastDistUpdate) >= 0.12 then
			lastDistUpdate = os.clock()
			updateRedDistances(activeTargets)
		end
	end
end)

SettingsTab:AddSection("Hub Info")
SettingsTab:AddToggle("Show Floating Button Now", "ซ่อนหน้าต่างหลักและเปิดปุ่มลอย UI ทันที", false, function(s)
	if s then
		local main = playerGui:FindFirstChild("CustomMobileHub")
		local mf, fb = main and main:FindFirstChild("MainFrame"), main and main:FindFirstChild("FloatingToggle")
		if mf and fb then mf.Visible = false; fb.Visible = true end
	end
end)

do
	local ThemeList = {
		{ Name = "Amber", MainBg = Color3.fromRGB(24, 21, 16), SidebarBg = Color3.fromRGB(19, 17, 13), TopbarBg = Color3.fromRGB(16, 14, 11), TextPrimary = Color3.fromRGB(250, 244, 232), Accent = Color3.fromRGB(245, 158, 11) },
		{ Name = "Warm Cream & Mocha Brown", MainBg = Color3.fromRGB(244, 237, 226), SidebarBg = Color3.fromRGB(233, 223, 208), TopbarBg = Color3.fromRGB(220, 207, 188), TextPrimary = Color3.fromRGB(58, 38, 26), Accent = Color3.fromRGB(120, 72, 42) },
		{ Name = "Charcoal & Neon Lime", MainBg = Color3.fromRGB(20, 22, 20), SidebarBg = Color3.fromRGB(15, 17, 15), TopbarBg = Color3.fromRGB(13, 15, 13), TextPrimary = Color3.fromRGB(238, 250, 236), Accent = Color3.fromRGB(132, 255, 45) },
		{ Name = "Electric Violet", MainBg = Color3.fromRGB(22, 18, 34), SidebarBg = Color3.fromRGB(17, 14, 27), TopbarBg = Color3.fromRGB(14, 11, 22), TextPrimary = Color3.fromRGB(244, 240, 255), Accent = Color3.fromRGB(139, 92, 246) },
		{ Name = "Jet Black & Crimson Red", MainBg = Color3.fromRGB(12, 12, 14), SidebarBg = Color3.fromRGB(9, 9, 11), TopbarBg = Color3.fromRGB(8, 8, 10), TextPrimary = Color3.fromRGB(248, 242, 244), Accent = Color3.fromRGB(225, 29, 72) }
	}

	local function applyThemeToGui(theme)
		local hub = playerGui:FindFirstChild("CustomMobileHub")
		if not hub then return end
		local mf = hub:FindFirstChild("MainFrame")
		local fb = hub:FindFirstChild("FloatingToggle")
		if mf then
			mf.BackgroundColor3 = theme.MainBg
			local mStroke = mf:FindFirstChildOfClass("UIStroke")
			if mStroke then mStroke.Color = theme.Accent end
			local tb = mf:FindFirstChild("TopBar")
			if tb then tb.BackgroundColor3 = theme.TopbarBg end
			local sb = mf:FindFirstChild("Sidebar")
			if sb then sb.BackgroundColor3 = theme.SidebarBg end
			local pf = mf:FindFirstChild("ZenoxAvatarProfile")
			if pf then
				pf.BackgroundColor3 = theme.TopbarBg
				local pSt = pf:FindFirstChildOfClass("UIStroke")
				if pSt then pSt.Color = theme.Accent end
			end
		end
		if fb then
			fb.BackgroundColor3 = theme.TopbarBg
			local fStroke = fb:FindFirstChildOfClass("UIStroke")
			if fStroke then fStroke.Color = theme.Accent end
		end
	end

	local function applyWindowFade(fadePercent)
		local hub = playerGui:FindFirstChild("CustomMobileHub")
		local mf = hub and hub:FindFirstChild("MainFrame")
		if not mf then return end
		local clamped = math.clamp(tonumber(fadePercent) or 1, 1, 120)
		mf.BackgroundTransparency = ((clamped - 1) / 119) * 0.85
	end

	SettingsTab:AddSection("Themes & Fade")

	local currentThemeIdx = 1
	local themeCard = Instance.new("Frame", SettingsTab.Page)
	themeCard.Name = "ZenoxThemeCard"
	themeCard.Size = UDim2.new(1, 0, 0, 44)
	themeCard.BackgroundColor3 = Color3.fromRGB(30, 33, 41)
	Instance.new("UICorner", themeCard).CornerRadius = UDim.new(0, 7)

	local tLbl = Instance.new("TextLabel", themeCard)
	tLbl.Size = UDim2.new(1, -150, 1, 0)
	tLbl.Position = UDim2.fromOffset(12, 0)
	tLbl.BackgroundTransparency = 1
	tLbl.Text = "ธีม: " .. ThemeList[currentThemeIdx].Name
	tLbl.TextColor3 = Color3.fromRGB(240, 242, 248)
	tLbl.Font = Enum.Font.GothamSemibold
	tLbl.TextSize = 11
	tLbl.TextXAlignment = Enum.TextXAlignment.Left
	tLbl.TextTruncate = Enum.TextTruncate.AtEnd

	local cycleBtn = Instance.new("TextButton", themeCard)
	cycleBtn.Size = UDim2.fromOffset(128, 26)
	cycleBtn.Position = UDim2.new(1, -138, 0.5, -13)
	cycleBtn.BackgroundColor3 = Color3.fromRGB(130, 85, 255)
	cycleBtn.Text = "เปลี่ยนธีมถัดไป"
	cycleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	cycleBtn.Font = Enum.Font.GothamBold
	cycleBtn.TextSize = 11
	Instance.new("UICorner", cycleBtn).CornerRadius = UDim.new(0, 6)

	cycleBtn.MouseButton1Click:Connect(function()
		currentThemeIdx = (currentThemeIdx % #ThemeList) + 1
		local chosen = ThemeList[currentThemeIdx]
		tLbl.Text = "ธีม: " .. chosen.Name
		cycleBtn.BackgroundColor3 = chosen.Accent
		applyThemeToGui(chosen)
	end)

	SettingsTab:AddNumberSlider("Window Fade (1 - 120)", "ปรับความจางหน้าต่างเพื่อดูสีธีมและฉากหลังได้ชัดขึ้น", 1, 120, 1, function(val)
		applyWindowFade(val)
	end)

	SettingsTab:AddSection("Reset")

	local resetCard = Instance.new("Frame", SettingsTab.Page)
	resetCard.Name = "ZenoxResetAllCard"
	resetCard.Size = UDim2.new(1, 0, 0, 44)
	resetCard.BackgroundColor3 = Color3.fromRGB(30, 33, 41)
	Instance.new("UICorner", resetCard).CornerRadius = UDim.new(0, 7)

	local rLbl = Instance.new("TextLabel", resetCard)
	rLbl.Size = UDim2.new(1, -110, 1, 0)
	rLbl.Position = UDim2.fromOffset(12, 0)
	rLbl.BackgroundTransparency = 1
	rLbl.Text = "รีเซ็ตค่าฟีเจอร์ทั้งหมด"
	rLbl.TextColor3 = Color3.fromRGB(240, 242, 248)
	rLbl.Font = Enum.Font.GothamSemibold
	rLbl.TextSize = 12
	rLbl.TextXAlignment = Enum.TextXAlignment.Left

	local rBtn = Instance.new("TextButton", resetCard)
	rBtn.Size = UDim2.fromOffset(88, 26)
	rBtn.Position = UDim2.new(1, -98, 0.5, -13)
	rBtn.BackgroundColor3 = Color3.fromRGB(220, 75, 95)
	rBtn.Text = "Reset All"
	rBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	rBtn.Font = Enum.Font.GothamBold
	rBtn.TextSize = 11
	Instance.new("UICorner", rBtn).CornerRadius = UDim.new(0, 6)

	rBtn.MouseButton1Click:Connect(function()
		speedEnabled = false
		jumpEnabled = false
		noclipEnabled = false
		infJumpEnabled = false
		faceNearestEnabled = false
		espEnabled = false
		entityEspEnabled = false
		redDistEnabled = false
		pinkTracerEnabled = false
		targetSpeed = 16
		targetJumpPower = 50
		airJumpPower = 50
		clearHighlights()
		clearEntityHighlights()
		clearDistGuis()
		clearTracers()
		setCharacterNoclip(player.Character, false)
		applyWindowFade(1)
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = 16
			applyJumpPower(hum, 50)
		end
	end)
end

RunService.Heartbeat:Connect(function(dt)
	local cdt = math.min(dt, 0.1)
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")

	if speedEnabled and hum and hum.Health > 0 then
		hum.WalkSpeed = hum.WalkSpeed + (targetSpeed - hum.WalkSpeed) * math.clamp(cdt * 20, 0, 1)
		if math.abs(hum.WalkSpeed - targetSpeed) < 0.25 then hum.WalkSpeed = targetSpeed end
	end
	if jumpEnabled and hum and hum.Health > 0 then applyJumpPower(hum, targetJumpPower) end
	if noclipEnabled and char then setCharacterNoclip(char, true) end
	if faceNearestEnabled and root and hum and hum.Health > 0 then
		local tRoot = getNearestTarget(300)
		if tRoot then
			local pos, look = root.Position, Vector3.new(tRoot.Position.X, root.Position.Y, tRoot.Position.Z)
			if (look - pos).Magnitude > 0.05 then
				root.CFrame = root.CFrame:Lerp(CFrame.lookAt(pos, look), math.clamp(cdt * 18, 0, 1))
			end
		end
	end
	if espEnabled and espRainbow then
		local rbCol = getEspColor()
		for plr, hl in pairs(highlights) do
			if plr and plr.Parent and plr.Character and hl and hl.Parent then
				hl.FillColor, hl.OutlineColor = rbCol, rbCol
			else
				applyHighlight(plr)
			end
		end
	end
end)

player.CharacterAdded:Connect(function(newChar)
	table.clear(savedCollision)
	local hum = newChar:WaitForChild("Humanoid", 5)
	if hum then
		if not speedEnabled then hum.WalkSpeed = 16 end
		if not jumpEnabled then applyJumpPower(hum, 50) end
	end
	if noclipEnabled then setCharacterNoclip(newChar, true) end
end)

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		if espEnabled then task.wait(0.2); applyHighlight(plr) end
	end)
end)

Players.PlayerRemoving:Connect(function(plr)
	if highlights[plr] then highlights[plr]:Destroy(); highlights[plr] = nil end
end)
