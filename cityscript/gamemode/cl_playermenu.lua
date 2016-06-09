surface.CreateFont( "ItemFont", {
        font = "ChatFont",
        size = 12,
        weight = 180,
        antialias = true
})

surface.CreateFont( "ItemFontCash", {
        font = "ChatFont",
        size = 14,
        weight = 200,
        antialias = true
})

InventoryTable = {}

net.Receive("Cw", function(_, ply)
	local nItems = net.ReadInt(32)
	for i=1, nItems do
		local itemdata = {}
		itemdata.Name = net.ReadString()
		itemdata.Class = net.ReadString()
		itemdata.Description = net.ReadString()
		itemdata.Model = net.ReadString()

		table.insert(InventoryTable, itemdata)
	end
end)

net.Receive("Cx", function(_, ply)
	InventoryTable = {}
end)

net.Receive("veh", function(_, ply)




	local vehFrm = vgui.Create("DFrame")
	vehFrm:SetSize(320, 240)
	vehFrm:SetPos(ScrW()/2-(320/2), ScrH()/2-(240/2))
	vehFrm:SetTitle(TEXT.AdminManageVehicleAddons)
	vehFrm:SetVisible(false)
	vehFrm:Show()
	vehFrm:MoveToFront()


end)

BusinessTable = {}
net.Receive("Cu", function(_, ply)
	local count = net.ReadInt(32)
	for i=1, count do
		local itemdata = {}
		itemdata.Name = net.ReadString()
		itemdata.Class = net.ReadString()
		itemdata.Description = net.ReadString()
		itemdata.Model = net.ReadString()
		itemdata.ContentModel = net.ReadString()
		itemdata.Price = net.ReadInt(32)
		itemdata.IsShipment = net.ReadBool()

		table.insert(BusinessTable, itemdata)
	end
end)

net.Receive("Cv", function(_, ply)
	BusinessTable = {}
end)

local function InitHiddenButton()
	HiddenButton = vgui.Create("DButton")
	HiddenButton:SetSize(ScrW(), ScrH())
	HiddenButton:SetText("")
	HiddenButton:SetDrawBackground(false)
	HiddenButton:SetDrawBorder(false)

	HiddenButton.DoRightClick = function()
		local Vect = gui.ScreenToVector(gui.MouseX(), gui.MouseY())
		local tracedata = {}
		tracedata.start = LocalPlayer():GetShootPos()
		tracedata.endpos = LocalPlayer():GetShootPos() + (Vect * 100)
		tracedata.filter = LocalPlayer()
		local trace = util.TraceLine(tracedata)

		if trace.HitNonWorld then
			local target = trace.Entity

			local ContextMenu = DermaMenu()
				if CAKE.IsDoor(target) then
					if not target:GetNWBool("nonRentable") then

						if not target:GetNWBool("pmOnly") then
							if target:GetNWInt("rby") == LocalPlayer():EntIndex() then
								ContextMenu:AddOption(TEXT.UnrentDoor, function() net.Start("Ck"); net.WriteInt(target:EntIndex(), 16); net.SendToServer() end):SetIcon("icon16/house.png")
								ContextMenu:AddSpacer()
								local players = player.GetAll()
								if #players > 1 then
									local subm = ContextMenu:AddSubMenu(TEXT.GiveSomeKeysTo)
									for _, v in ipairs(players) do
										subm:AddOption(CAKE.GetCharField(v, "name") or v:Name(), function() net.Start("CA"); net.WriteInt(v:EntIndex(), 16); net.WriteInt(target:EntIndex(), 16); net.SendToServer() end)
									end
									ContextMenu:AddSpacer()
								end
							else
								if target:GetNWInt("rby") == nil or target:GetNWInt("rby") == 0 then
									ContextMenu:AddOption(TEXT.RentDoor, function() net.Start("Ck"); net.WriteInt(target:EntIndex(), 16); net.SendToServer() end):SetIcon("icon16/house.png")
									ContextMenu:AddSpacer()
								end
							end
						end

						ContextMenu:AddOption(TEXT.LockDoor, function() net.Start("Cn"); net.WriteInt(target:EntIndex(), 16); net.SendToServer() end):SetIcon("icon16/lock.png")
						ContextMenu:AddOption(TEXT.UnlockDoor, function() net.Start("Cm"); net.WriteInt(target:EntIndex(), 16); net.SendToServer() end):SetIcon("icon16/lock_open.png")
					end

					if LocalPlayer():IsSuperAdmin() then

						ContextMenu:AddSpacer()

						local sendfunc = function(enable, mode)
							net.Start("Cc")
							net.WriteInt(target:EntIndex(), 16)
							net.WriteInt(mode, 8)
							net.WriteBool(enable)
							net.SendToServer()
						end

						if not target:GetNWBool("pmOnly") then
							if target:GetNWBool("nonRentable") then
								if target:GetNWInt("rby") == nil or target:GetNWInt("rby") == 0 then
									ContextMenu:AddOption(TEXT.EnableRenting, function() sendfunc(true, 0) end):SetIcon("icon16/tick.png")
								end
							else
								if target:GetNWInt("rby") == nil or target:GetNWInt("rby") == 0 then
									ContextMenu:AddOption(TEXT.DisableRenting, function() sendfunc(false, 0) end):SetIcon("icon16/cross.png")
								end
							end
						end

						if not target:GetNWBool("nonRentable") then
							if not target:GetNWBool("pmOnly") then
								if target:GetNWInt("rby") == nil or target:GetNWInt("rby") == 0 then
									ContextMenu:AddOption(TEXT.RestrictDoor, function() sendfunc(true, 1) end):SetIcon("icon16/key_delete.png")
								end
							else
								if target:GetNWInt("rby") == nil or target:GetNWInt("rby") == 0 then
									ContextMenu:AddOption(TEXT.RemoveRestrictionFromDoor, function() sendfunc(false, 1) end):SetIcon("icon16/key_go.png")
								end
							end
						end
					end
				elseif target:IsPlayer() then
					local function PopupCredits()
						local CreditPanel = vgui.Create("DFrame")
						CreditPanel:SetPos((ScrW()/2)-100, (ScrH()/2)-87)
						CreditPanel:SetSize(200, 175)
						CreditPanel:SetTitle(TEXT.GivePersonTokens(target:Nick()))
						CreditPanel:SetVisible(true)
						CreditPanel:SetDraggable(true)
						CreditPanel:ShowCloseButton(true)
						CreditPanel:MakePopup()

						local Credits = vgui.Create("DNumSlider", CreditPanel)
						Credits:SetPos(25, 50)
						Credits:SetWide(150)
						Credits:SetText(TEXT.NumberOfTokensToGive)
						Credits:SetMin(0)
						Credits:SetMax(tonumber(LocalPlayer():GetNWString("money")))
						Credits:SetDecimals(0)

						local Give = vgui.Create("DButton", CreditPanel)
						Give:SetText("Give")
						Give:SetPos(25, 125)
						Give:SetSize(150, 25)

						Give.DoClick = function()
							net.Start("gmn")
							net.WriteInt(target:EntIndex(), 16)
							net.WriteString(tostring(Credits:GetValue()))
							net.SendToServer()

							CreditPanel:Remove()
							CreditPanel = nil
						end
					end

					ContextMenu:AddOption(TEXT.GiveTokens, PopupCredits)

					if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
						ContextMenu:AddOption(TEXT.Warn, function() WarnPlayer(target) end)
						ContextMenu:AddOption(TEXT.Kick, function() KickPlayer(target) end)
						ContextMenu:AddOption(TEXT.Ban, function() BanPlayer(target) end)
					end
				elseif target:IsNPC() then
				elseif target:IsVehicle() then
					-- If the person clicking is the owner of the vehicle
					if target:GetNWEntity("c_ent") == LocalPlayer() then
						ContextMenu:AddOption(TEXT.LockVehicle, function() net.Start("Cnv"); net.WriteInt(target:EntIndex(), 16); net.SendToServer() end):SetIcon("icon16/lock.png")
						ContextMenu:AddOption(TEXT.UnlockVehicle, function() net.Start("Cmv"); net.WriteInt(target:EntIndex(), 16); net.SendToServer() end):SetIcon("icon16/lock_open.png")
						ContextMenu:AddSpacer()
						if target:GetNWInt("svl") < 0 then
							ContextMenu:AddOption(TEXT.SetSalePrice, function()
								-- Get a sale price from the owner of the vehicle.
								Derma_StringRequest(TEXT.SetSalePrice,
									TEXT.SetSalePrice,
									"",
									function(amount)
										if amount == "" or not tonumber(amount) then return end

										net.Start("Ssp")
										net.WriteInt(target:EntIndex(), 16)
										net.WriteString(amount)
										net.SendToServer()
									end
								)
							end):SetIcon("icon16/tag_blue_edit.png")
						else
							ContextMenu:AddOption(TEXT.RemoveFromSale, function()
								net.Start("Ssp")
								net.WriteInt(target:EntIndex(), 16)
								net.WriteString("-1")
								net.SendToServer()
							end):SetIcon("icon16/cross.png")
						end
						ContextMenu:AddSpacer()
						ContextMenu:AddOption(TEXT.ScrapVehicle, function() net.Start("Sv"); net.WriteInt(target:EntIndex(), 16); net.SendToServer() end):SetIcon("icon16/car_delete.png")
					else -- If the person clicking is not the owner of the vehicle
						local svl = target:GetNWInt("svl")
						if svl ~= nil and svl >= 0 then
							ContextMenu:AddOption(TEXT.BuyVehicle, function() end):SetIcon("icon16/car_add.png")
						end
					end
				else
					-- If the weapon is already being held, you can't pick it up - but you can take its default ammo if there is some.
					if (target:GetClass() == "spawned_weapon" and not LocalPlayer():HasWeapon(target.class)) or not LocalPlayer():HasWeapon(target:GetNWString("Class")) then
						ContextMenu:AddOption(TEXT.UseItem, function() net.Start("Ci"); net.WriteInt(target:EntIndex(), 16); net.SendToServer() end)
					end

					if (target:GetNWInt("Clip1A") or 0) > 0 or (target:GetNWInt("Clip2A") or 0) > 0 then
						ContextMenu:AddOption(TEXT.TakeAmmo, function() net.Start("Ch"); net.WriteInt(target:EntIndex(), 16); net.SendToServer() end)
					end

					ContextMenu:AddOption(TEXT.PlaceInBackpack, function() net.Start("Cj"); net.WriteInt(target:EntIndex(), 16); net.SendToServer() end)
				end
			ContextMenu:SetPos(ScrW()/2, ScrH()/2)
			ContextMenu:Open()
		end
	end
end

function CreateModelWindow()
	if ModelWindow then
		ModelWindow:Remove()
		ModelWindow = nil
	end

	ModelWindow = vgui.Create("DFrame")
	ModelWindow:SetTitle(TEXT.SelectModel)

	local mdlPanel = vgui.Create("DModelPanel", ModelWindow)
	mdlPanel:SetSize(300, 300)
	mdlPanel:SetPos(10, 20)
	mdlPanel:SetModel(ValidCakeModels[1])
	mdlPanel:SetAnimSpeed(0.0)
	mdlPanel:SetAnimated(false)
	mdlPanel:SetAmbientLight(Color(50, 50, 50))
	mdlPanel:SetDirectionalLight(BOX_TOP, Color(255, 255, 255))
	mdlPanel:SetDirectionalLight(BOX_FRONT, Color(255, 255, 255))
	mdlPanel:SetCamPos(Vector(50, 0, 50))
	mdlPanel:SetLookAt(Vector(0, 0, 50))
	mdlPanel:SetFOV(70)

	local RotateSlider = vgui.Create("DNumSlider", ModelWindow)
	RotateSlider:SetMax(360)
	RotateSlider:SetMin(0)
	RotateSlider:SetText(TEXT.Rotate)
	RotateSlider:SetDecimals(0)
	RotateSlider:SetWidth(300)
	RotateSlider:SetPos(10, 290)

	local BodyButton = vgui.Create("DButton", ModelWindow)
	BodyButton:SetText(TEXT.Body)
	BodyButton.DoClick = function()
		mdlPanel:SetCamPos(Vector(50, 0, 50))
		mdlPanel:SetLookAt(Vector(0, 0, 50))
		mdlPanel:SetFOV(70)
	end
	BodyButton:SetPos(10, 40)

	local FaceButton = vgui.Create("DButton", ModelWindow)
	FaceButton:SetText(TEXT.Face)

	FaceButton.DoClick = function()
		mdlPanel:SetCamPos(Vector(50, 0, 60))
		mdlPanel:SetLookAt(Vector(0, 0, 60))
		mdlPanel:SetFOV(40)
	end
	FaceButton:SetPos(10, 60)

	local FarButton = vgui.Create("DButton", ModelWindow)
	FarButton:SetText(TEXT.Far)

	FarButton.DoClick = function()
		mdlPanel:SetCamPos(Vector(100, 0, 30))
		mdlPanel:SetLookAt(Vector(0, 0, 30))
		mdlPanel:SetFOV(70)
	end
	FarButton:SetPos(10, 80)

	local OkButton = vgui.Create("DButton", ModelWindow)
	OkButton:SetText(TEXT.OK)

	OkButton.DoClick = function()
		SetChosenModel(mdlPanel.Entity:GetModel())
		ModelWindow:Remove()
		ModelWindow = nil
	end

	OkButton:SetPos(10, 100)

	function mdlPanel:LayoutEntity(Entity)
		self:RunAnimation()
		Entity:SetAngles(Angle(0, RotateSlider:GetValue(), 0))
	end

	local i = 1

	local LastMdl = vgui.Create("DButton", ModelWindow)
	LastMdl:SetText("Prev")
	LastMdl.DoClick = function()
		i = i - 1

		if i == 0 then
			i = #ValidCakeModels
		end

		mdlPanel:SetModel(ValidCakeModels[i])
	end

	LastMdl:SetPos(10, 165)

	local NextMdl = vgui.Create("DButton", ModelWindow)
	NextMdl:SetText("Next")
	NextMdl.DoClick = function()
		i = i + 1

		if i > #ValidCakeModels then
			i = 1
		end

		mdlPanel:SetModel(ValidCakeModels[i])
	end
	NextMdl:SetPos(245, 165)

	ModelWindow:SetSize(320, 330)
	ModelWindow:Center()
	ModelWindow:MakePopup()
	ModelWindow:SetKeyboardInputEnabled(false)
end

function InitHUDMenu()
	InitHiddenButton()

	HUDMenu = vgui.Create("DFrame")
	HUDMenu:SetPos(ScrW() - 130 - 5, 5)
	HUDMenu:SetSize(130, 150)
	HUDMenu:SetTitle(TEXT.PlayerInformation)
	HUDMenu:SetVisible(true)
	HUDMenu:SetDraggable(false)
	HUDMenu:ShowCloseButton(false)
	HUDMenu:SetAnimationEnabled(true)

	local label = vgui.Create("DLabel", HUDMenu)
	label:SetWide(0)
	label:SetPos(8, 25)
	label:SetText(TEXT.Name .. ": " .. LocalPlayer():Nick())

	local label4 = vgui.Create("DLabel", HUDMenu)
	label4:SetWide(0)
	label4:SetPos(8, 55)
	label4:SetText(TEXT.Association .. ": " .. team.GetName(LocalPlayer():Team()))

	local spawnicon = vgui.Create("SpawnIcon", HUDMenu)
	spawnicon:SetSize(128, 128)
	spawnicon:SetModel(LocalPlayer():GetModel())
	spawnicon:SetPos(1, 21)
	print("Model: " .. LocalPlayer():GetModel())
	spawnicon:SetToolTip(TEXT.OpenPlayerMenu)
	spawnicon:SetAnimationEnabled(true)

	local lastmodel = LocalPlayer():GetModel()

	local FadeSize = 130
	local NeedsUpdate = false

	function UpdateGUIData()
		label:SetText(TEXT.Name .. ": " .. LocalPlayer():Nick())

		label4:SetText(TEXT.Association .. ": " .. team.GetName(LocalPlayer():Team()))

		if lastmodel ~= LocalPlayer():GetModel() then
			lastmodel = LocalPlayer():GetModel()
			spawnicon:SetModel(LocalPlayer():GetModel())
		end
		spawnicon:SetToolTip(TEXT.PlayerImage)
	end

	spawnicon.PaintOver = function()
		spawnicon:SetPos(FadeSize - 129, 21)
		HUDMenu:SetSize(FadeSize, 150)
		HUDMenu:SetPos(ScrW() - FadeSize - 5, 5)

		label:SetWide(FadeSize - 128)
		label4:SetWide(FadeSize - 128)

		if spawnicon:IsHovered() then
			if FadeSize < 400 then
				FadeSize = FadeSize + 5
			end
			label:SetVisible(true)
			label4:SetVisible(true)
		else
			if FadeSize > 130 then
				FadeSize = FadeSize - 5
			else
				label:SetVisible(false)
				label4:SetVisible(false)
			end
		end

		UpdateGUIData()
	end
end

local function WarnPlayer(ply)
	Derma_StringRequest(TEXT.WarningTo(ply:Name()),
		TEXT.Warning .. ":",
		"",
		function(warning) RunConsoleCommand("rp_admin", "warn", tostring(ply:UserID()), warning) end)
end

local function KickPlayer(ply)
	Derma_StringRequest(TEXT.ReasonForKicking(ply:Name()),
		TEXT.Reason .. ":",
		"",
		function(reason) RunConsoleCommand("rp_admin", "kick", tostring(ply:UserID()), reason) end)
end

local function BanPlayer(ply)
	local function GetBanReason(timeText, banMinutes)
		local txt
		if timeText == TEXT.Always then
			txt = " " .. TEXT.ForAlways
		else
			txt = " " .. TEXT.For .. " " .. timeText
		end
		Derma_StringRequest(TEXT.ReasonForBanningName(ply:Name()) .. txt,
			TEXT.Reason .. ":",
			"",
			function(reason)
				if timeText == TEXT.Always then timeText = "PERMA" end
				RunConsoleCommand("rp_admin", "ban", tostring(ply:UserID()), string.upper(timeText) .. ": " .. reason, tostring(banMinutes))
			end)
	end

	local width = 248
	local height = 79

	local BanSelect = vgui.Create("DFrame")
	BanSelect:SetSize(width, height)
	BanSelect:SetPos((ScrW()/2)-(width/2), (ScrH()/2)-(height/2))
	BanSelect:SetSizable(false)
	BanSelect:SetTitle(TEXT.BanFor)
	BanSelect:ShowCloseButton(true)

	local onehr = vgui.Create("DButton", BanSelect)
	onehr:SetPos(2, 25)
	onehr:SetSize(80, 25)
	onehr:SetText(TEXT.OneHour)
	onehr.DoClick = function()
		GetBanReason(TEXT.OneHour, 60)
	end

	local sixhrs = vgui.Create("DButton", BanSelect)
	sixhrs:SetPos(84, 25)
	sixhrs:SetSize(80, 25)
	sixhrs:SetText(TEXT.SixHours)
	sixhrs.DoClick = function()
		GetBanReason(TEXT.SixHours, 60 * 6)
	end

	local oneday = vgui.Create("DButton", BanSelect)
	oneday:SetPos(166, 25)
	oneday:SetSize(80, 25)
	oneday:SetText(TEXT.OneDay)
	oneday.DoClick = function()
		GetBanReason(TEXT.OneDay, 60 * 24)
	end

	local onewk = vgui.Create("DButton", BanSelect)
	onewk:SetPos(2, 52)
	onewk:SetSize(80, 25)
	onewk:SetText(TEXT.OneWeek)
	onewk.DoClick = function()
		GetBanReason(TEXT.OneWeek, 60 * 24 * 7)
	end

	local onemon = vgui.Create("DButton", BanSelect)
	onemon:SetPos(84, 52)
	onemon:SetSize(80, 25)
	onemon:SetText(TEXT.OneMonth)
	onemon.DoClick = function()
		GetBanReason(TEXT.OneMonth, 60 * 24 * 30)
	end

	local ever = vgui.Create("DButton", BanSelect)
	ever:SetPos(166, 52)
	ever:SetSize(80, 25)
	ever:SetText(TEXT.Always)
	ever.DoClick = function()
		GetBanReason(TEXT.Always, 0)
	end

	BanSelect:MakePopup()
end

function CreatePlayerMenu()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end

	PlayerMenu = vgui.Create("DFrame")
	PlayerMenu:SetPos(ScrW() / 2 - 320, ScrH() / 2 - 240)
	PlayerMenu:SetSize(640, 480)
	PlayerMenu:SetTitle(TEXT.PlayerMenu)
	PlayerMenu:SetVisible(true)
	PlayerMenu:SetDraggable(true)
	PlayerMenu:ShowCloseButton(true)
	PlayerMenu:MakePopup()

	PropertySheet = vgui.Create("DPropertySheet")
	PropertySheet:SetParent(PlayerMenu)
	PropertySheet:SetPos(2, 30)
	PropertySheet:SetSize(636, 448)

	PropertySheet.Paint = function()
		-- A nice, dark background color so you can read the text
		surface.SetDrawColor(40, 40, 40, 255)
		surface.DrawRect(0, 0, PropertySheet:GetWide(), PropertySheet:GetTall())
	end

	local PlayerInfo = vgui.Create("DListLayout")
	--PlayerInfo:SetSize(636, 448)
	--PlayerInfo:SetLayoutDir(TOP)
	--PlayerInfo:SetBorder(20)
	--PlayerInfo:SetSpaceX(20)
	--PlayerInfo:SetSpaceY(20)

	local FullData = vgui.Create("DListLayout")
	FullData:SetSize(0, 84)

	local DataList = vgui.Create("DIconLayout")
	DataList:SetSize(0, 64)
	DataList:SetSpaceY(0)
	DataList:SetSpaceX(0)

	local spawnicon = vgui.Create("SpawnIcon")
	spawnicon:SetModel(LocalPlayer():GetModel())
	spawnicon:SetSize(64, 64)
	DataList:Add(spawnicon):SetSize(64, 64)

	local DataList2 = vgui.Create("DListLayout")

	local label3 = vgui.Create("DLabel")
	label3:SetText(TEXT.Association .. ": " .. team.GetName(LocalPlayer():Team()))
	DataList2:Add(label3)

	local Divider = vgui.Create("DHorizontalDivider")
	Divider:SetLeft(spawnicon)
	Divider:SetRight(DataList2)
	Divider:SetLeftWidth(64)
	Divider:SetHeight(64)

	DataList:Add(spawnicon)
	DataList:Add(DataList2)
	DataList:Add(Divider)

	FullData:Add(DataList)

	local icdata = vgui.Create("DForm")
	icdata:SetPadding(4)
	icdata:SetName(LocalPlayer():Nick() or "")
	icdata:AddItem(FullData)

	local vitals = vgui.Create("DForm")
	vitals:SetPadding(4)
	vitals:SetName(TEXT.VitalSigns)

	local VitalData = vgui.Create("DIconLayout")
	VitalData:SetSpaceX(10)
	VitalData:SetSpaceY(10)
	vitals:AddItem(VitalData)

	local healthstatus = ""
	local hp = LocalPlayer():Health()

	if(!LocalPlayer():Alive()) then healthstatus = TEXT.Dead
	elseif(hp > 95) then healthstatus = TEXT.Healthy
	elseif(hp > 50 and hp < 95) then healthstatus = TEXT.OK
	elseif(hp > 30 and hp < 50) then healthstatus = TEXT.NearDeath
	elseif(hp > 1 and hp < 30) then
		healthstatus = TEXT.DeathImminent
	end

	local health = vgui.Create("DLabel")
	health:SetText("Vitals: " .. healthstatus)
	health:SizeToContents()
	VitalData:Add(health)

	PlayerInfo:Add(icdata)
	PlayerInfo:Add(vitals)

	CharPanel = vgui.Create("DPanelList")
	CharPanel:SetPadding(20)
	CharPanel:SetSpacing(20)
	CharPanel:EnableHorizontal(false)

	local newcharform = vgui.Create("DForm")
	newcharform:SetPadding(4)
	newcharform:SetName(TEXT.NewCharacter)
	newcharform:SetAutoSize(true)

	local CharMenu = vgui.Create("DPanelList")
	newcharform:AddItem(CharMenu)
	CharMenu:SetSize(316, 386)
	CharMenu:SetPadding(10)
	CharMenu:SetSpacing(20)
	CharMenu:EnableVerticalScrollbar()
	CharMenu:EnableHorizontal(false)

	local label = vgui.Create("DLabel")
	CharMenu:AddItem(label)
	label:SetSize(400, 25)
	label:SetPos(5, 25)
	label:SetText(TEXT.WelcomeToCakescriptG2)

	local info = vgui.Create("DForm")
	info:SetName(TEXT.PersonalInformation)
	CharMenu:AddItem(info)

	local label = vgui.Create("DLabel")
	info:AddItem(label)
	label:SetSize(30, 25)
	label:SetPos(150, 50)
	label:SetText(TEXT.First .. ": ")

	local firstname = vgui.Create("DTextEntry")
	info:AddItem(firstname)
	firstname:SetSize(100, 25)
	firstname:SetPos(185, 50)
	firstname:SetText("")

	local label = vgui.Create("DLabel")
	info:AddItem(label)
	label:SetSize(30,25)
	label:SetPos(5, 50)
	label:SetText(TEXT.Last .. ": ")

	local lastname = vgui.Create("DTextEntry")
	info:AddItem(lastname)
	lastname:SetSize(100, 25)
	lastname:SetPos(40, 50)
	lastname:SetText("")

	local spawnicon = nil

	local modelform = vgui.Create("DForm")
	modelform:SetPadding(4)
	modelform:SetName(TEXT.Appearance)
	CharMenu:AddItem(modelform)

	local OpenButton = vgui.Create("DButton")
	OpenButton:SetText("Select Model")
	OpenButton.DoClick = CreateModelWindow
	modelform:AddItem(OpenButton)

	local apply = vgui.Create("DButton")
	apply:SetSize(100, 25)
	apply:SetText(TEXT.CreateNewCharacter)

	apply.DoClick = function (btn)
		if firstname:GetValue() == "" or lastname:GetValue() == "" then
			LocalPlayer():PrintMessage(3, TEXT.FirstNameLastNameError)
			return
		end

		if not table.HasValue(ValidCakeModels, ChosenModel) then
			LocalPlayer():PrintMessage(3, ChosenModel .. " " .. TEXT.XIsNotAValidModel)
			return
		end

		net.Start("ncCreateCharacter")
		net.WriteString(ChosenModel)
		net.WriteString(firstname:GetValue() .. " " .. lastname:GetValue())
		net.SendToServer()
		LocalPlayer().MyModel = ""

		PlayerMenu:Remove()
		PlayerMenu = nil
	end
	CharMenu:AddItem(apply)

	local selectcharform = vgui.Create("DForm")
	selectcharform:SetPadding(4);
	selectcharform:SetName(TEXT.SelectCharacter)
	selectcharform:SetSize(316, 386)

	local charlist = vgui.Create("DPanelList")

	charlist:SetSize(316, 386)
	charlist:SetPadding(10)
	charlist:SetSpacing(20)
	charlist:EnableVerticalScrollbar()
	charlist:EnableHorizontal(true)

	local n = 1

	if ExistingChars[n] ~= nil then
		mdlPanel = vgui.Create("DModelPanel")
		mdlPanel:SetSize(280, 280)
		mdlPanel:SetModel(ExistingChars[n]['model'])
		mdlPanel:SetAnimSpeed(0.0)
		mdlPanel:SetAnimated(false)
		mdlPanel:SetAmbientLight(Color(50, 50, 50))
		mdlPanel:SetDirectionalLight(BOX_TOP, Color(255, 255, 255))
		mdlPanel:SetDirectionalLight(BOX_FRONT, Color(255, 255, 255))
		mdlPanel:SetCamPos(Vector(150, 0, 40))
		mdlPanel:SetLookAt(Vector(0, 0, 40))
		mdlPanel:SetFOV(70)

		mdlPanel.PaintOver = function()
			surface.SetTextColor(Color(255, 255, 255, 255))
			surface.SetFont("Trebuchet18")
			surface.SetTextPos((280 - surface.GetTextSize(ExistingChars[n].name)) / 2, 260)
			surface.DrawText(ExistingChars[n]['name'])
		end

		function mdlPanel:OnMousePressed()
			-- Select Character
			net.Start("Cr")
			net.WriteInt(n, 16)
			net.SendToServer()

			LocalPlayer().MyModel = ""
			PlayerMenu:Remove()
			PlayerMenu = nil
		end

		function mdlPanel:LayoutEntity(Entity)
			self:RunAnimation()
		end

		function InitAnim()
			if IsValid(mdlPanel.Entity) then
				local iSeq = mdlPanel.Entity:LookupSequence("idle_all_angry")
				mdlPanel.Entity:ResetSequence(iSeq)
			end
		end

		InitAnim()

		charlist:AddItem(mdlPanel)
	end

	local chars = vgui.Create("DListView")
	chars:SetSize(250, 100)
	chars:SetMultiSelect(false)
	chars:AddColumn(TEXT.CharacterName)

	local RebuildChars = function()
		for k, v in pairs(ExistingChars) do
			chars:AddLine(v.name)
		end
	end

	function chars:OnRowSelected(LineID, Line)
		n = LineID
		mdlPanel:SetModel(ExistingChars[n].model)
		InitAnim()
	end

	function chars:DoDoubleClick(LineID, Line)
		mdlPanel:OnMousePressed()
	end

	function chars:OnRowRightClick(LineID, Line)
		if LocalPlayer():GetNWInt("uid") ~= LineID then
			local dm = DermaMenu()
			dm:AddOption(TEXT.DeleteCharacter, function()
				net.Start("Co")
				net.WriteInt(LineID, 16)
				net.SendToServer()

				if LineID == #ExistingChars then
					n = n - 1
				end

				table.remove(ExistingChars, LineID)
				chars:Clear()
				RebuildChars()
			end)
			dm:Open()
		end
	end

	RebuildChars()

	selectcharform:AddItem(chars)
	selectcharform:AddItem(charlist)

	local divider = vgui.Create("DHorizontalDivider")
	divider:SetLeft(newcharform)
	divider:SetRight(selectcharform)
	divider:SetLeftWidth(316);

	CharPanel:AddItem(newcharform)
	CharPanel:AddItem(selectcharform)
	CharPanel:AddItem(divider)

	CityCommands = vgui.Create("DPanelList")
	CityCommands:SetPadding(20)
	CityCommands:SetSpacing(20)
	CityCommands:EnableHorizontal(true)
	CityCommands:EnableVerticalScrollbar(true)

	local CityRoles = vgui.Create("DListView")
	CityRoles:SetSize(550, 446)
	CityRoles:SetMultiSelect(false)
	CityRoles:AddColumn(TEXT.RoleName)
	CityRoles:AddColumn(TEXT.Salary)
	CityRoles:AddColumn(TEXT.BusinessAccess)
	CityRoles:AddColumn(TEXT.PublicRole)
	CityRoles:AddColumn(TEXT.RoleKey)

	function CityRoles:DoDoubleClick(LineID, Line)
		net.Start("C7")
		net.WriteString(TeamTable[LineID].rolekey)
		net.SendToServer()
		PlayerMenu:Remove()
		PlayerMenu = nil
	end

	for k, v in pairs(TeamTable) do
		local yesno = ""
		if v.public then
			yesno = TEXT.Yes
		elseif not v.public then
			yesno = TEXT.No
		end

		local yesno2 = ""
		if v.business then
			yesno2 = TEXT.Yes
		elseif not v.business then
			yesno2 = TEXT.No
		end

		CityRoles:AddLine(v.name, tostring(v.salary), yesno2, yesno, v.rolekey)
	end

	CityCommands:AddItem(CityRoles)

	Inventory = vgui.Create("DPanelList")
	Inventory:SetPadding(20)
	Inventory:SetSpacing(20)
	Inventory:EnableHorizontal(true)
	Inventory:EnableVerticalScrollbar(true)

	for k, v in pairs(InventoryTable) do
		local spawnicon = vgui.Create("SpawnIcon")
		spawnicon:SetSize(128, 128)
		spawnicon:SetModel(v.Model)
		spawnicon:SetToolTip(v.Description)

		if v.Class == "fire_extinguisher_powder" then
			ang_new = spawnicon:GetLookAng():RotateAroundAxis(Vector(0, 1, 0), 135)
			spawnicon:RebuildSpawnIconEx({
				ent = spawnicon:GetEntity(),
				cam_pos = spawnicon:GetCamPos(),
				cam_ang = ang_new,
				cam_fov = spawnicon:GetFOV()
			})
			spawnicon:PerformLayout()
		end

		local function DeleteMyself()
			spawnicon:Remove()
		end

		spawnicon.DoClick = function (btn)
			local ContextMenu = DermaMenu()
				if weapons.GetStored(v.Class) ~= nil and not LocalPlayer():HasWeapon(v.Class) then
					ContextMenu:AddOption("Equip", function() net.Start("Cq"); net.WriteString(v.Class); net.SendToServer(); DeleteMyself() end):SetIcon("icon16/bullet_add.png")
				end
				ContextMenu:AddOption(TEXT.Drop, function() net.Start("Ce"); net.WriteString(v.Class); net.SendToServer(); DeleteMyself(); end):SetIcon("icon16/briefcase.png");
			ContextMenu:Open()
		end

		spawnicon.Paint = function()
			surface.SetDrawColor(Color(76, 76, 77, 255))
			surface.DrawRect(0, 0, 128, 128)
		end

		spawnicon.PaintOver = function()
			surface.SetTextColor(Color(255, 255, 255, 255))
			surface.SetFont("DefaultSmall")
			surface.SetTextPos(64 - surface.GetTextSize(v.Name) / 2, 5)
			surface.DrawText(v.Name)
		end

		spawnicon.PaintOverHovered = function()
			surface.SetTextColor(Color(255, 255, 255, 255))
			surface.SetFont("DefaultSmall")
			surface.SetTextPos(64 - surface.GetTextSize(v.Name) / 2, 5)
			surface.DrawText(v.Name .. " test")
		end

		Inventory:AddItem(spawnicon)
	end

	Business = vgui.Create("DPanel")
	Business:SetSize(636, 448)
	Business:SetVerticalScrollbarEnabled(true)
	Business.Paint = function(me, w, h)
		surface.SetDrawColor(100, 100, 100, 255)
		surface.DrawRect(0, 0, w, h)
	end

	local magImg = vgui.Create("DImage", Business)
	magImg:SetPos(5, 8)
	magImg:SetSize(16, 16)
	magImg:SetImage("icon16/magnifier.png")

	local FilterIcons
	local bTe = vgui.Create("DTextEntry", Business)
	bTe:SetPos(26, 4)
	bTe:SetSize(588, 24)
	bTe.OnValueChange = function(me, newValue)
		FilterIcons(newValue)
	end
	bTe:SetUpdateOnType(true)

	local busScroll = vgui.Create("DScrollPanel", Business)
	busScroll:SetPos(0, 32)
	busScroll:SetSize(620, 380)
	busScroll.Paint = function(me, w, h)
		surface.SetDrawColor(35, 35, 35, 255)
		surface.DrawRect(0, 0, w, h)
	end

	local iconLayout = vgui.Create("DIconLayout", busScroll)
	iconLayout:SetSize(620, 380)
	iconLayout:SetSpaceX(16)
	iconLayout:SetSpaceY(16)
	iconLayout:SetBorder(12)

	local iconOptions = {}

	FilterIcons = function(filterText)
		-- Return an iterator function
		local words = string.gmatch(filterText, "%S+")

		local wordList = {}

		-- Fill the wordList table with each typed word (as lower case).
		for word in words do
			table.insert(wordList, word:lower())
		end

		-- Decide whether or not to display the icon.
		for _, iOpt in ipairs(iconOptions) do
			iOpt:SetVisible(false)
			iOpt:SetParent(nil)

			if #wordList == 0 then
				-- When the search box is empty, show the icon.
				iOpt:SetVisible(true)
				iOpt:SetParent(iconLayout)
			else
				local show = false
				for _, word in ipairs(wordList) do
					-- If the word supplied matches any of the item names or descriptions, show the icon.
					if iOpt.ToolTipText:find(word) ~= nil or iOpt.ItemName:find(word) ~= nil then
						iOpt:SetVisible(true)
						iOpt:SetParent(iconLayout)
						break
					end
				end
			end
		end

		iconLayout:InvalidateLayout()
	end

	-- Populate the list of icon options (which the above filter selects
	-- when populating the list according to the search criteria).
	if TeamTable[LocalPlayer():Team()] ~= nil then
		if TeamTable[LocalPlayer():Team()].business then
			for k, v in pairs(BusinessTable) do
				local spawnicon = vgui.Create("SpawnIcon")
				spawnicon:SetSize(128, 128)
				spawnicon:SetModel(v.Model)
				spawnicon:SetToolTip(v.Description)
				spawnicon.ItemName = v.Name:lower()
				spawnicon.ToolTipText = v.Description:lower()
				local itemView
				if v.IsShipment then
					itemView = vgui.Create("DModelPanel", spawnicon)
					itemView:SetSize(128, 128)
					itemView:SetModel(v.ContentModel)
					itemView:SetLookAt(Vector(0, 0, 0))
					itemView:SetCamPos(Vector(-20, 0, 0))
					itemView:SetAnimSpeed(8)
					itemView:SetToolTip(v.Description)
				end

				spawnicon.DoClick = function (btn)
					local ContextMenu = DermaMenu()
						if tonumber(LocalPlayer():GetNWString("money")) >= v.Price then
							ContextMenu:AddOption(TEXT.Purchase, function() net.Start("Cd"); net.WriteString(v.Class); net.SendToServer() end):SetIcon("icon16/coins.png")
						else
							ContextMenu:AddOption(TEXT.NotEnoughTokens):SetIcon("icon16/coins_delete.png")
						end
					ContextMenu:Open()
				end

				if itemView then
					itemView.DoClick = spawnicon.DoClick
				end

				spawnicon.Paint = function()
					surface.SetDrawColor(Color(76, 76, 77, 255))
					surface.DrawRect(0, 0, 128, 128)
				end

				spawnicon.PaintOver = function(self)
					surface.SetTextColor(Color(255, 255, 255, 255))
					surface.SetFont("ItemFont")

					surface.SetTextPos(64 - surface.GetTextSize(v.Name) / 2, 5)
					surface.DrawText(v.Name)

					surface.SetTextPos(64 - surface.GetTextSize(v.Description) / 2, 17)
					surface.DrawText(v.Description)

					surface.SetFont("ItemFontCash")
					local toShow = tostring(v.Price) .. " Tokens"
					surface.SetTextPos(128 - surface.GetTextSize(toShow) - 2, 115)
					surface.DrawText(toShow)
				end

				spawnicon:SetParent(iconLayout)

				iconLayout:Add(spawnicon)
				table.insert(iconOptions, spawnicon)

			end
		elseif not TeamTable[LocalPlayer():Team()].business then
			local label = vgui.Create("DLabel")
			label:SetText(TEXT.NoAccessToBusinessTab)
			label:SetWide(400)

			iconLayout:Add(label)
		end
	end

	Scoreboard = vgui.Create("DListLayout")

	-- Let's draw the SCOREBOARD.

	for k, v in pairs(player.GetAll()) do
		local FullData = vgui.Create("DListLayout")
		FullData:SetSize(0, 84)
		--FullData:SetPadding(10)

		local DataList = vgui.Create("DIconLayout")
		DataList:SetSize(0, 64)
		DataList:SetSpaceY(0)
		DataList:SetSpaceX(0)

		local spawnicon = vgui.Create("SpawnIcon")
		spawnicon:SetModel(LocalPlayer():GetModel())
		spawnicon:SetSize(64, 64)
		spawnicon.DoClick = function()
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
				local AdminFunctions = DermaMenu()
				AdminFunctions:AddOption(TEXT.Warn, function() WarnPlayer(v) end):SetIcon("icon16/error.png")
				AdminFunctions:AddOption(TEXT.Kick, function() KickPlayer(v) end):SetIcon("icon16/error_go.png")
				AdminFunctions:AddOption(TEXT.Ban, function() BanPlayer(v) end):SetIcon("icon16/error_delete.png")
				AdminFunctions:Open()
			end
		end
		DataList:Add(spawnicon)

		local DataList2 = vgui.Create("DListLayout")

		local label = vgui.Create("DLabel")
		label:SetText( TEXT.OOCName .. ": " .. v:Name())
		DataList2:Add(label)

		local label3 = vgui.Create("DLabel")
		label3:SetText(TEXT.Association .. ": " .. team.GetName(v:Team()))
		DataList2:Add(label3)

		local Divider = vgui.Create("DHorizontalDivider")
		Divider:SetLeft(spawnicon)
		Divider:SetRight(DataList2)
		Divider:SetLeftWidth(64)
		Divider:SetHeight(64)

		DataList:Add(spawnicon)
		DataList:Add(DataList2)
		DataList:Add(Divider)

		FullData:Add(DataList)

		Scoreboard:Add(FullData)
	end

	local Admin
	if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
		Admin = vgui.Create("DPanelList")
		Admin:SetPadding(20)
		Admin:SetSpacing(20)
		Admin:EnableHorizontal(true)
		Admin:EnableVerticalScrollbar(true)
		local buttonsCommands = {}
		buttonsCommands[TEXT.SpawnNewATM] = TEXT.NewATMCommand
		buttonsCommands[TEXT.FreezeAnATM] = TEXT.FreezeATMCommand
		buttonsCommands[TEXT.AddCustomPosForCurrentRole] = TEXT.AddSpawnCommand
		buttonsCommands[TEXT.CustomSpawnPositions] = TEXT.RemoveSpawnsCommand
		buttonsCommands[TEXT.EnableZombies] = TEXT.EnableZombiesCommand
		buttonsCommands[TEXT.DisableZombies] = TEXT.DisableZombiesCommand
		buttonsCommands[TEXT.AddZombieSpawnPosHere] = TEXT.AddZombieCommand
		buttonsCommands[TEXT.DropZombies] = TEXT.DropZombiesCommand
		buttonsCommands[TEXT.EnableMeteorStorm] = TEXT.EnableMeteorStormCommand
		buttonsCommands[TEXT.DisableMeteorStorm] = TEXT.DisableMeteorStormCommand
		buttonsCommands[TEXT.ClearJailPositions] = TEXT.AddJailPosCommand
		buttonsCommands[TEXT.AddJailPosHere] = TEXT.AddExtraJailPosCommand
		buttonsCommands[TEXT.AdminManageVehicleAddons] = TEXT.ManageVehicleAddonsCommand

		local posY = 5
		for k, v in pairs(buttonsCommands) do
			local btn = vgui.Create("DButton", Admin)
			btn:SetSize(400, 25)
			btn:SetPos(120, posY)
			btn:SetText(k)
			btn.DoClick = function()
				RunConsoleCommand("say", v)
			end
			posY = posY + 30
		end
	end

	PropertySheet:AddSheet( TEXT.PlayerMenu, PlayerInfo, "icon16/user.png", false, false, TEXT.GeneralInfo)
	PropertySheet:AddSheet( TEXT.CharacterMenu, CharPanel, "icon16/group.png", false, false, TEXT.CharSwitchOrNew)
	PropertySheet:AddSheet( TEXT.Roles, CityCommands, "icon16/wrench.png", false, false, TEXT.CommonCommandsOrRole)
	PropertySheet:AddSheet( TEXT.Backpack, Inventory, "icon16/house_go.png", false, false, TEXT.ViewYourInventory)
	PropertySheet:AddSheet( TEXT.Business, Business, "icon16/briefcase.png", false, false, TEXT.PurchaseItems)
	PropertySheet:AddSheet( TEXT.Scoreboard, Scoreboard, "icon16/application_view_detail.png", false, false, TEXT.ViewScoreboard)

	local scrll = vgui.Create("DScrollPanel", PropertySheet)
	scrll:SetSize(PropertySheet:GetWide(), PropertySheet:GetTall())
	scrll:SetPos(0, 0)

	local Help = vgui.Create("DIconLayout", scrll)
	Help:SetSize(scrll:GetWide() - 4, scrll:GetTall() - 4)
	Help:SetPos(2, 2)
	--Help:SetPadding(20)
	--Help:EnableHorizontal(false)
	Help:SetSpaceX(5)
	Help:SetSpaceY(5)

	local function AddHelpLine(text)
		local label = vgui.Create("DLabel")
		label:SetText(text)
		label:SizeToContents()

		local item = Help:Add(label)
		item:SetSize(Help:GetWide(), 10)
	end

	for k, v in pairs(TEXT.HelpLong) do
		AddHelpLine(v)
	end

	PropertySheet:AddSheet( TEXT.Help, scrll, "icon16/magnifier.png", false, false, TEXT.HelpTextMenu)

	if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
		PropertySheet:AddSheet( "Admin", Admin, "icon16/eye.png", false, false, TEXT.AdminCommandsMenu)
	end

	CAKE.ShowLoadingMessage = nil
end
local function MenuWrapper()
	CAKE.ShowLoadingMessage = true

	timer.Simple(0.1, function()
		CreatePlayerMenu()
	end)
end
net.Receive("C1", function(_, ply) MenuWrapper() end)
