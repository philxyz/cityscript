InventoryTable = {}

function AddItem(data)
	local itemdata = {}
	itemdata.Name = data:ReadString();
	itemdata.Class = data:ReadString();
	itemdata.Description = data:ReadString();
	itemdata.Model = data:ReadString();
	
	table.insert(InventoryTable, itemdata);
end
usermessage.Hook("addinventory", AddItem);

function ClearItems()
	
	InventoryTable = {}
	
end
usermessage.Hook("clearinventory", ClearItems);

BusinessTable = {};

function AddBusinessItem(data)
	local itemdata = {}
	itemdata.Name = data:ReadString();
	itemdata.Class = data:ReadString();
	itemdata.Description = data:ReadString();
	itemdata.Model = data:ReadString();
	itemdata.Price = data:ReadLong();
	
	table.insert(BusinessTable, itemdata);
end
usermessage.Hook("addbusiness", AddBusinessItem);

function ClearBusinessItems()
	
	BusinessTable = {}
	
end
usermessage.Hook("clearbusiness", ClearBusinessItems);

local function InitHiddenButton()
	HiddenButton = vgui.Create("DButton")
	HiddenButton:SetSize(ScrW(), ScrH());
	HiddenButton:SetText("");
	HiddenButton:SetDrawBackground(false);
	HiddenButton:SetDrawBorder(false);
	HiddenButton.DoRightClick = function()
		local Vect = gui.ScreenToVector(gui.MouseX(), gui.MouseY());
		local tracedata = {};
		tracedata.start = LocalPlayer():GetShootPos();
		tracedata.endpos = LocalPlayer():GetShootPos() + (Vect * 100);
		tracedata.filter = LocalPlayer();
		local trace = util.TraceLine(tracedata);
		
		if(trace.HitNonWorld) then
			local target = trace.Entity;
			
			local ContextMenu = DermaMenu()
				if(CAKE.IsDoor(target) or target:IsVehicle()) then
					if not target:GetNWBool("notRentable") then
						ContextMenu:AddOption(TEXT.RentUnrent, function() RunConsoleCommand("rp_purchasedoor", tostring(target:EntIndex())) end);
						ContextMenu:AddOption(TEXT.Lock, function() RunConsoleCommand("rp_lockdoor", tostring(target:EntIndex())) end);
						ContextMenu:AddOption(TEXT.Unlock, function() RunConsoleCommand("rp_unlockdoor", tostring(target:EntIndex())) end);
					end
					if LocalPlayer():IsSuperAdmin() then
						if target:GetNWBool("nonRentable") then
							ContextMenu:AddOption(TEXT.EnableRenting, function() RunConsoleCommand("rp_doorrenting", tostring(target:EntIndex()), "1") end);
						else
							ContextMenu:AddOption(TEXT.DisableRenting, function() RunConsoleCommand("rp_doorrenting", tostring(target:EntIndex()), "0") end);
						end
					end
				elseif(target:IsPlayer()) then
					local function PopupCredits()
						local CreditPanel = vgui.Create( "DFrame" );
						CreditPanel:SetPos((ScrW()/2)-100, (ScrH()/2)-87);
						CreditPanel:SetSize( 200, 175 )
						CreditPanel:SetTitle( TEXT.GivePersonTokens(target:Nick()));
						CreditPanel:SetVisible(true);
						CreditPanel:SetDraggable(true);
						CreditPanel:ShowCloseButton(true);
						CreditPanel:MakePopup();
						
						local Credits = vgui.Create( "DNumSlider", CreditPanel );
						Credits:SetPos( 25, 50 );
						Credits:SetWide(150);
						Credits:SetText("Tokens to Give");
						Credits:SetMin( 0 );
						Credits:SetMax( tonumber(LocalPlayer():GetNWString("money")) );
						Credits:SetDecimals( 0 );
						
						local Give = vgui.Create( "DButton", CreditPanel );
						Give:SetText("Give");
						Give:SetPos( 25, 125 );
						Give:SetSize( 150, 25 );
						Give.DoClick = function()
							RunConsoleCommand("rp_givemoney", tostring(target:EntIndex()), tostring(Credits:GetValue()));
							CreditPanel:Remove();
							CreditPanel = nil;
						end
					end
					
					ContextMenu:AddOption(TEXT.GiveTokens, PopupCredits);
					if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
						ContextMenu:AddOption(TEXT.Warn, function() WarnPlayer(target) end)
						ContextMenu:AddOption(TEXT.Kick, function() KickPlayer(target) end)
						ContextMenu:AddOption(TEXT.Ban, function() BanPlayer(target) end)
					end
				elseif(target:IsNPC()) then
				else
					ContextMenu:AddOption(TEXT.UseItem, function() RunConsoleCommand("rp_useitem",  tostring(target:EntIndex())) end);
					ContextMenu:AddOption(TEXT.PlaceInBackpack, function() RunConsoleCommand("rp_pickup", tostring(target:EntIndex())) end);
				end
			ContextMenu:SetPos(ScrW()/2, ScrH()/2)
			ContextMenu:Open();
		end
	end
end

function CreateModelWindow()

	if(ModelWindow) then
	
		ModelWindow:Remove();
		ModelWindow = nil;
		
	end

	ModelWindow = vgui.Create( "DFrame" )
	ModelWindow:SetTitle(TEXT.SelectModel);

	local mdlPanel = vgui.Create( "DModelPanel", ModelWindow )
	mdlPanel:SetSize( 300, 300 )
	mdlPanel:SetPos( 10, 20 )
	mdlPanel:SetModel( ValidCakeModels[1] )
	mdlPanel:SetAnimSpeed( 0.0 )
	mdlPanel:SetAnimated( false )
	mdlPanel:SetAmbientLight( Color( 50, 50, 50 ) )
	mdlPanel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	mdlPanel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	mdlPanel:SetCamPos( Vector( 50, 0, 50 ) )
	mdlPanel:SetLookAt( Vector( 0, 0, 50 ) )
	mdlPanel:SetFOV( 70 )

	local RotateSlider = vgui.Create("DNumSlider", ModelWindow);
	RotateSlider:SetMax(360);
	RotateSlider:SetMin(0);
	RotateSlider:SetText(TEXT.Rotate);
	RotateSlider:SetDecimals( 0 );
	RotateSlider:SetWidth(300);
	RotateSlider:SetPos(10, 290);

	local BodyButton = vgui.Create("DButton", ModelWindow);
	BodyButton:SetText(TEXT.Body);
	BodyButton.DoClick = function()

		mdlPanel:SetCamPos( Vector( 50, 0, 50) );
		mdlPanel:SetLookAt( Vector( 0, 0, 50) );
		mdlPanel:SetFOV( 70 );
		
	end
	BodyButton:SetPos(10, 40);

	local FaceButton = vgui.Create("DButton", ModelWindow);
	FaceButton:SetText(TEXT.Face);
	FaceButton.DoClick = function()

		mdlPanel:SetCamPos( Vector( 50, 0, 60) );
		mdlPanel:SetLookAt( Vector( 0, 0, 60) );
		mdlPanel:SetFOV( 40 );
		
	end
	FaceButton:SetPos(10, 60);

	local FarButton = vgui.Create("DButton", ModelWindow);
	FarButton:SetText(TEXT.Far);
	FarButton.DoClick = function()

		mdlPanel:SetCamPos( Vector( 100, 0, 30) );
		mdlPanel:SetLookAt( Vector( 0, 0, 30) );
		mdlPanel:SetFOV( 70 );
		
	end
	FarButton:SetPos(10, 80);
	
	local OkButton = vgui.Create("DButton", ModelWindow);
	OkButton:SetText(TEXT.OK);
	OkButton.DoClick = function()

		SetChosenModel(mdlPanel.Entity:GetModel());
		ModelWindow:Remove();
		ModelWindow = nil;
		
	end
	OkButton:SetPos(10, 100);

	function mdlPanel:LayoutEntity(Entity)

		self:RunAnimation();
		Entity:SetAngles( Angle( 0, RotateSlider:GetValue(), 0) )
		
	end

	local i = 1;
	
	local LastMdl = vgui.Create( "DButton", ModelWindow )
	LastMdl:SetText("Prev")
	LastMdl.DoClick = function()

		i = i - 1;
		
		if(i == 0) then
			i = #ValidCakeModels;
		end
		
		mdlPanel:SetModel(ValidCakeModels[i]);
		
	end

	LastMdl:SetPos(10, 165);

	local NextMdl = vgui.Create( "DButton", ModelWindow )
	NextMdl:SetText("Next")
	NextMdl.DoClick = function()

		i = i + 1;

		if(i > #ValidCakeModels) then
			i = 1;
		end
		
		mdlPanel:SetModel(ValidCakeModels[i]);
		
	end
	NextMdl:SetPos( 245, 165);
	
	ModelWindow:SetSize( 320, 330 )
	ModelWindow:Center()	
	ModelWindow:MakePopup()
	ModelWindow:SetKeyboardInputEnabled( false )
	
end

function InitHUDMenu()

	InitHiddenButton();

	HUDMenu = vgui.Create( "DFrame" )
	HUDMenu:SetPos( ScrW() - 130 - 5, 5 )
	HUDMenu:SetSize( 130, 150 )
	HUDMenu:SetTitle( TEXT.PlayerInformation )
	HUDMenu:SetVisible( true )
	HUDMenu:SetDraggable( false )
	HUDMenu:ShowCloseButton( false )
	HUDMenu:SetAnimationEnabled( true )
	
	local label = vgui.Create("DLabel", HUDMenu);
	label:SetWide(0);
	label:SetPos(8, 25);
	label:SetText(TEXT.Name .. ": " .. LocalPlayer():Nick());
	
	local label3 = vgui.Create("DLabel", HUDMenu);
	label3:SetWide(0);
	label3:SetPos(8, 40);
	label3:SetText(TEXT.Title .. ": " .. LocalPlayer():GetNWString("title"));
	
	local label4 = vgui.Create("DLabel", HUDMenu);
	label4:SetWide(0);
	label4:SetPos(8, 55);
	label4:SetText(TEXT.Association .. ": " .. team.GetName(LocalPlayer():Team()));
	
	local spawnicon = vgui.Create( "SpawnIcon", HUDMenu);
	spawnicon:SetSize( 128, 128 );
	spawnicon:SetModel(LocalPlayer():GetModel());
	spawnicon:SetPos(1,21);
	print("Model: " .. LocalPlayer():GetModel())
	spawnicon:SetToolTip(TEXT.OpenPlayerMenu);
	spawnicon:SetAnimationEnabled( true );

	local lastmodel = LocalPlayer():GetModel()
	
	local FadeSize = 130;
	local NeedsUpdate = false
	
	function UpdateGUIData()
		label:SetText(TEXT.Name .. ": " .. LocalPlayer():Nick());
		
		label3:SetText(TEXT.Title .. ": " .. LocalPlayer():GetNWString("title"));
		
		label4:SetText(TEXT.Association .. ": " .. team.GetName(LocalPlayer():Team()));

		if lastmodel ~= LocalPlayer():GetModel() then
			lastmodel = LocalPlayer():GetModel()
			spawnicon:SetModel(LocalPlayer():GetModel())
		end
		spawnicon:SetToolTip(TEXT.PlayerImage);
	end
	
	spawnicon.PaintOver = function()
		spawnicon:SetPos(FadeSize - 129, 21);
		HUDMenu:SetSize(FadeSize, 150);
		HUDMenu:SetPos(ScrW() - FadeSize - 5, 5 );
		
		label:SetWide(FadeSize - 128);
		label3:SetWide(FadeSize - 128);
		label4:SetWide(FadeSize - 128);
		
		if spawnicon:IsHovered() then
			if FadeSize < 400 then
				FadeSize = FadeSize + 5
			end
		else
			if FadeSize > 130 then
				FadeSize = FadeSize - 5
			end
		end
		
		UpdateGUIData();
	end
end

local function WarnPlayer(ply)
	Derma_StringRequest(TEXT.WarningTo(ply:Name()),
		TEXT.Warning .. ":",
		"",
		function(warning) RunConsoleCommand("rp_admin", "warn", tostring(ply:UserID()), "\"" .. warning .. "\"") end)
end

local function KickPlayer(ply)
	Derma_StringRequest(TEXT.ReasonForKicking(ply:Name()),
		TEXT.Reason .. ":",
		"",
		function(reason) RunConsoleCommand("rp_admin", "kick", tostring(ply:UserID()), "\"" .. reason .. "\"") end)
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
				RunConsoleCommand("rp_admin", "ban", tostring(ply:UserID()), "\"" .. string.upper(timeText) .. ": " .. reason .. "\"", tostring(banMinutes))
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
	if(PlayerMenu) then
		PlayerMenu:Remove();
		PlayerMenu = nil;
	end
	
	PlayerMenu = vgui.Create( "DFrame" )
	PlayerMenu:SetPos( ScrW() / 2 - 320, ScrH() / 2 - 240 )
	PlayerMenu:SetSize( 640, 480 )
	PlayerMenu:SetTitle( TEXT.PlayerMenu )
	PlayerMenu:SetVisible( true )
	PlayerMenu:SetDraggable( true )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:MakePopup()
	
	PropertySheet = vgui.Create( "DPropertySheet" )
	PropertySheet:SetParent(PlayerMenu)
	PropertySheet:SetPos( 2, 30 )
	PropertySheet:SetSize( 636, 448 )
	PropertySheet.Paint = function()
		-- A nice, dark background color so you can read the text
		surface.SetDrawColor( 40, 40, 40, 255 )
		surface.DrawRect( 0, 0, PropertySheet:GetWide(), PropertySheet:GetTall())
	end
	
	local PlayerInfo = vgui.Create( "DPanelList" )
	PlayerInfo:SetPadding(20);
	PlayerInfo:SetSpacing(20);
	PlayerInfo:EnableHorizontal(false);
	
	local icdata = vgui.Create( "DForm" );
	icdata:SetPadding(4);
	icdata:SetName(LocalPlayer():Nick() or "");
	
	local FullData = vgui.Create("DPanelList");
	FullData:SetSize(0, 84);
	FullData:SetPadding(10);
	
	local DataList = vgui.Create("DIconLayout");
	DataList:SetSize(0, 64);
	DataList:SetSpaceY(0);
	DataList:SetSpaceX(0);
	
	local spawnicon = vgui.Create( "SpawnIcon");
	spawnicon:SetModel(LocalPlayer():GetModel());
	spawnicon:SetSize( 64, 64 );
	DataList:Add(spawnicon):SetSize(64, 64);
	
	local DataList2 = vgui.Create( "DPanelList" )
	
	local label2 = vgui.Create("DLabel");
	label2:SetText(TEXT.Title .. ": " .. LocalPlayer():GetNWString("title"));
	DataList2:AddItem(label2);
	
	local label3 = vgui.Create("DLabel");
	label3:SetText(TEXT.Association .. ": " .. team.GetName(LocalPlayer():Team()));
	DataList2:AddItem(label3);

	local Divider = vgui.Create("DHorizontalDivider");
	Divider:SetLeft(spawnicon);
	Divider:SetRight(DataList2);
	Divider:SetLeftWidth(64);
	Divider:SetHeight(64);
	
	DataList:Add(spawnicon);
	DataList:Add(DataList2);
	DataList:Add(Divider);

	FullData:AddItem(DataList)
	
	icdata:AddItem(FullData)
	
	local vitals = vgui.Create( "DForm" );
	vitals:SetPadding(4);
	vitals:SetName(TEXT.VitalSigns);
	
	local VitalData = vgui.Create("DPanelList");
	VitalData:SetAutoSize(true)
	VitalData:SetPadding(10);
	vitals:AddItem(VitalData);
	
	local healthstatus = ""
	local hp = LocalPlayer():Health();
	
	if(!LocalPlayer():Alive()) then healthstatus = TEXT.Dead;
	elseif(hp > 95) then healthstatus = TEXT.Healthy;
	elseif(hp > 50 and hp < 95) then healthstatus = TEXT.OK;
	elseif(hp > 30 and hp < 50) then healthstatus = TEXT.NearDeath;
	elseif(hp > 1 and hp < 30) then healthstatus = TEXT.DeathImminent; end
	
	local health = vgui.Create("DLabel");
	health:SetText("Vitals: " .. healthstatus);
	VitalData:AddItem(health);
	
	PlayerInfo:AddItem(icdata)
	PlayerInfo:AddItem(vitals)
	
	CharPanel = vgui.Create( "DPanelList" )
	CharPanel:SetPadding(20);
	CharPanel:SetSpacing(20);
	CharPanel:EnableHorizontal(false);
	
	local newcharform = vgui.Create( "DForm" );
	newcharform:SetPadding(4);
	newcharform:SetName(TEXT.NewCharacter);
	newcharform:SetAutoSize(true);
	
	local CharMenu = vgui.Create( "DPanelList" )
	newcharform:AddItem(CharMenu);
	CharMenu:SetSize( 316, 386 )
	CharMenu:SetPadding(10);
	CharMenu:SetSpacing(20);
	CharMenu:EnableVerticalScrollbar();
	CharMenu:EnableHorizontal(false);


	
	local label = vgui.Create("DLabel");
	CharMenu:AddItem(label);
	label:SetSize(400, 25);
	label:SetPos(5, 25);
	label:SetText(TEXT.WelcomeToCakescriptG2);

	local info = vgui.Create( "DForm" );
	info:SetName(TEXT.PersonalInformation);
	CharMenu:AddItem(info);

	local label = vgui.Create("DLabel");
	info:AddItem(label);
	label:SetSize(30,25);
	label:SetPos(150, 50);
	label:SetText(TEXT.First .. ": ");

	local firstname = vgui.Create("DTextEntry");
	info:AddItem(firstname);
	firstname:SetSize(100,25);
	firstname:SetPos(185, 50);
	firstname:SetText("");

	local label = vgui.Create("DLabel");
	info:AddItem(label);
	label:SetSize(30,25);
	label:SetPos(5, 50);
	label:SetText(TEXT.Last .. ": ");

	local lastname = vgui.Create("DTextEntry");
	info:AddItem(lastname);
	lastname:SetSize(100,25);
	lastname:SetPos(40, 50);
	lastname:SetText("");

	local label = vgui.Create("DLabel");
	info:AddItem(label);
	label:SetSize(100,25);
	label:SetPos(5, 80);
	label:SetText(TEXT.Title .. ": ");

	local title = vgui.Create("DTextEntry");
	info:AddItem(title);
	title:SetSize(205, 25);
	title:SetPos(80, 80);
	title:SetText(TEXT.Unemployed);

	local spawnicon = nil;

	local modelform = vgui.Create( "DForm" );
	modelform:SetPadding(4);
	modelform:SetName(TEXT.Appearance);
	CharMenu:AddItem(modelform);

	local OpenButton = vgui.Create( "DButton" );
	OpenButton:SetText("Select Model");
	OpenButton.DoClick = CreateModelWindow;
	modelform:AddItem(OpenButton);

	local apply = vgui.Create("DButton");
	apply:SetSize(100, 25);
	apply:SetText(TEXT.Apply);
	apply.DoClick = function ( btn )
		if(firstname:GetValue() == "" or lastname:GetValue() == "") then
			LocalPlayer():PrintMessage(3, TEXT.FirstNameLastNameError);
			return;
		end
		
		if(!table.HasValue(ValidCakeModels, ChosenModel)) then
			LocalPlayer():PrintMessage(3, ChosenModel .. " " .. TEXT.XisNotAValidModel);
			return;
		end
		
		RunConsoleCommand("rp_startcreate");
		RunConsoleCommand("rp_setmodel", "\"" .. ChosenModel .. "\"");
		RunConsoleCommand("rp_changename", "\"" .. firstname:GetValue() .. " " .. lastname:GetValue() .. "\"");
		RunConsoleCommand("rp_title", "\"" .. string.sub(title:GetValue(), 1, 32) .. "\"");
		LocalPlayer().MyModel = ""
		RunConsoleCommand("rp_finishcreate");
		
		PlayerMenu:Remove();
		PlayerMenu = nil;
	end
	CharMenu:AddItem(apply);

	local selectcharform = vgui.Create( "DForm" );
	selectcharform:SetPadding(4);
	selectcharform:SetName(TEXT.SelectCharacter);
	selectcharform:SetSize(316, 386);

	local charlist = vgui.Create( "DPanelList" );
	
	charlist:SetSize( 316, 386 )
	charlist:SetPadding(10);
	charlist:SetSpacing(20);
	charlist:EnableVerticalScrollbar();
	charlist:EnableHorizontal(true);

	
	local n = 1;
	if(ExistingChars[n] != nil) then
	
		mdlPanel = vgui.Create( "DModelPanel" )
		mdlPanel:SetSize( 280, 280 )
		mdlPanel:SetModel( ExistingChars[n]['model'] )
		mdlPanel:SetAnimSpeed( 0.0 )
		mdlPanel:SetAnimated( false )
		mdlPanel:SetAmbientLight( Color( 50, 50, 50 ) )
		mdlPanel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
		mdlPanel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
		mdlPanel:SetCamPos( Vector( 100, 0, 40 ) )
		mdlPanel:SetLookAt( Vector( 0, 0, 40 ) )
		mdlPanel:SetFOV( 70 )

		mdlPanel.PaintOver = function()
			surface.SetTextColor(Color(255,255,255,255));
			surface.SetFont("Trebuchet18");
			surface.SetTextPos((280 - surface.GetTextSize(ExistingChars[n]['name'])) / 2, 260);
			surface.DrawText(ExistingChars[n]['name'])
		end
		
		function mdlPanel:OnMousePressed()
		
			RunConsoleCommand("rp_selectchar", tostring(n));
			LocalPlayer().MyModel = ""
			PlayerMenu:Remove();
			PlayerMenu = nil;
			
		end

		function mdlPanel:LayoutEntity(Entity)

			self:RunAnimation();
			
		end
		
		function InitAnim()
		
			if(mdlPanel.Entity) then
			
				local iSeq = mdlPanel.Entity:LookupSequence( "idle_angry" );
				mdlPanel.Entity:ResetSequence(iSeq);
			
			end
			
		end
		
		InitAnim()
		charlist:AddItem(mdlPanel);
		
	end
	
	local chars = vgui.Create("DListView");
	chars:SetSize(250, 100);
	chars:SetMultiSelect(false)
	chars:AddColumn(TEXT.CharacterName);
	
	function chars:DoDoubleClick(LineID, Line)
		n = LineID
		mdlPanel:SetModel(ExistingChars[n]['model']);
		InitAnim();
	end
	
	for k, v in pairs(ExistingChars) do
		chars:AddLine(v['name']);
	end
	
	selectcharform:AddItem(chars);
	selectcharform:AddItem(charlist);


	local divider = vgui.Create("DHorizontalDivider");
	divider:SetLeft(newcharform);
	divider:SetRight(selectcharform);
	divider:SetLeftWidth(316); 

	CharPanel:AddItem(newcharform);
	CharPanel:AddItem(selectcharform);
	CharPanel:AddItem(divider);
	
	CityCommands = vgui.Create( "DPanelList" )
	CityCommands:SetPadding(20);
	CityCommands:SetSpacing(20);
	CityCommands:EnableHorizontal(true);
	CityCommands:EnableVerticalScrollbar(true);
	
	local CityFlags = vgui.Create("DListView");
	CityFlags:SetSize(550,446);
	CityFlags:SetMultiSelect(false)
	CityFlags:AddColumn(TEXT.FlagName);
	CityFlags:AddColumn(TEXT.Salary);
	CityFlags:AddColumn(TEXT.BusinessAccess);
	CityFlags:AddColumn(TEXT.PublicFlag);
	CityFlags:AddColumn(TEXT.FlagKey);
	
	function CityFlags:DoDoubleClick(LineID, Line)
		RunConsoleCommand("rp_flag", TeamTable[LineID].flagkey);
		PlayerMenu:Remove();
		PlayerMenu = nil;
		
	end
	
	for k, v in pairs(TeamTable) do
		local yesno = "";
		if(v.public) then
			yesno = TEXT.Yes;
		elseif(!v.public) then
			yesno = TEXT.No;
		end
		
		local yesno2 = "";
		if(v.business) then
			yesno2 = TEXT.Yes;
		elseif(!v.business) then
			yesno2 = TEXT.No;
		end
		
		CityFlags:AddLine(v.name, tostring(v.salary), yesno2, yesno, v.flagkey);
	end
	
	CityCommands:AddItem(CityFlags);
	
	Inventory = vgui.Create( "DPanelList" )
	Inventory:SetPadding(20);
	Inventory:SetSpacing(20);
	Inventory:EnableHorizontal(true);
	Inventory:EnableVerticalScrollbar(true);
	
	for k, v in pairs(InventoryTable) do
		local spawnicon = vgui.Create( "SpawnIcon");
		spawnicon:SetSize( 128, 128 );
		spawnicon:SetModel(v.Model);
		spawnicon:SetToolTip(v.Description);
		
		local function DeleteMyself()
			spawnicon:Remove()
		end
		
		spawnicon.DoClick = function ( btn )
		
			local ContextMenu = DermaMenu()
				ContextMenu:AddOption("Drop", function() RunConsoleCommand("rp_dropitem", v.Class); DeleteMyself(); end);
			ContextMenu:Open();
			
		end
		
		spawnicon.PaintOver = function()
			surface.SetTextColor(Color(255,255,255,255));
			surface.SetFont("DefaultSmall");
			surface.SetTextPos(64 - surface.GetTextSize(v.Name) / 2, 5);
			surface.DrawText(v.Name)
		end
		
		spawnicon.PaintOverHovered = function()
			surface.SetTextColor(Color(255,255,255,255));
			surface.SetFont("DefaultSmall");
			surface.SetTextPos(64 - surface.GetTextSize(v.Name) / 2, 5);
			surface.DrawText(v.Name)
		end
		
		Inventory:AddItem(spawnicon);
	end
	
	Business = vgui.Create( "DPanelList" )
	Business:SetPadding(20);
	Business:SetSpacing(20);
	Business:EnableHorizontal(true);
	Business:EnableVerticalScrollbar(true);
	if(TeamTable[LocalPlayer():Team()] != nil) then
		if(TeamTable[LocalPlayer():Team()].business) then
			for k, v in pairs(BusinessTable) do
				local spawnicon = vgui.Create( "SpawnIcon");
				spawnicon:SetSize( 128, 128 );
				spawnicon:SetModel(v.Model);
				spawnicon:SetToolTip(v.Description);
				
				spawnicon.DoClick = function ( btn )
				
					local ContextMenu = DermaMenu()
						if(tonumber(LocalPlayer():GetNWString("money")) >= v.Price) then
							ContextMenu:AddOption(TEXT.Purchase, function() RunConsoleCommand("rp_buyitem", v.Class); end);
						else
							ContextMenu:AddOption(TEXT.NotEnoughTokens);
						end
					ContextMenu:Open();
					
				end
				
				spawnicon.PaintOver = function()
					surface.SetTextColor(Color(255,255,255,255));
					surface.SetFont("DefaultSmall");
					surface.SetTextPos(64 - surface.GetTextSize(v.Name .. " (" .. v.Price .. ")") / 2, 5);
					surface.DrawText(v.Name .. " (" .. v.Price .. ")")
				end
				
				spawnicon.PaintOverHovered = function()
					surface.SetTextColor(Color(255,255,255,255));
					surface.SetFont("DefaultSmall");
					surface.SetTextPos(64 - surface.GetTextSize(v.Name .. " (" .. v.Price .. ")") / 2, 5);
					surface.DrawText(v.Name .. " (" .. v.Price .. ")")
				end
				
				Business:AddItem(spawnicon);
			end
		elseif(!TeamTable[LocalPlayer():Team()].business) then
			local label = vgui.Create("DLabel")
			label:SetText(TEXT.NoAccessToBusinessTab);
			label:SetWide(400);
			
			Business:AddItem(label);
		end
	end
	
	Scoreboard = vgui.Create( "DPanelList" )
	Scoreboard:SetPadding(0);
	Scoreboard:SetSpacing(0);

	-- Let's draw the SCOREBOARD.
	
	for k, v in pairs(player.GetAll()) do
		local DataList = vgui.Create("DIconLayout");
		DataList:SetSpaceY(0)
		DataList:SetSpaceX(0)
		
		local CollapsableCategory = vgui.Create("DCollapsibleCategory");
		CollapsableCategory:SetExpanded(0);
		CollapsableCategory:SetLabel( v:Nick() );
		Scoreboard:AddItem(CollapsableCategory);
		
		local spawnicon = vgui.Create( "SpawnIcon");
		spawnicon:SetModel(v:GetModel());
		spawnicon.DoClick = function()
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
				local AdminFunctions = DermaMenu();
				AdminFunctions:AddOption(TEXT.Warn, function() WarnPlayer(v) end)
				AdminFunctions:AddOption(TEXT.Kick, function() KickPlayer(v) end)
				AdminFunctions:AddOption(TEXT.Ban, function() BanPlayer(v) end)
				AdminFunctions:Open()
			end
		end
		DataList:Add(spawnicon):SetSize(64, 64);
		
		local DataList2 = vgui.Create( "DPanelList" )
		DataList2:SetAutoSize( true )
		
		local label = vgui.Create("DLabel");
		label:SetText(TEXT.OOCName .. ": " .. v:Name());
		DataList2:AddItem(label);
		
		local label2 = vgui.Create("DLabel");
		label2:SetText(TEXT.Title .. ": " .. v:GetNWString("title"));
		DataList2:AddItem(label2);
		
		local label3 = vgui.Create("DLabel");
		label3:SetText(TEXT.Association .. ": " .. team.GetName(v:Team()));
		DataList2:AddItem(label3);
		
		local Divider = vgui.Create("DHorizontalDivider");
		Divider:SetLeft(spawnicon);
		Divider:SetRight(DataList2);
		Divider:SetLeftWidth(64);
		Divider:SetHeight(64);
		
		DataList:Add(DataList2);
		DataList:Add(Divider);
		
		CollapsableCategory:SetContents(DataList);
	end

	local Help = vgui.Create( "DPanelList" )
	Help:SetPadding(20);
	Help:EnableHorizontal(false);
	Help:EnableVerticalScrollbar(true);
	
	local function AddHelpLine(text)
			local label = vgui.Create("DLabel");
			label:SetText(text);
			label:SizeToContents();
			Help:AddItem(label);
	end
	
	for k, v in pairs(TEXT.HelpLong) do
		AddHelpLine(v);
	end

	local Admin
	if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
		Admin = vgui.Create( "DPanelList" )
		Admin:SetPadding(20);
		Admin:SetSpacing(20);
		Admin:EnableHorizontal(true);
		Admin:EnableVerticalScrollbar(true);
		local buttonsCommands = {}
		buttonsCommands["Spawn a New ATM"] = TEXT.NewATMCommand
		buttonsCommands["Freeze an ATM (look at it first)"] = TEXT.FreezeATMCommand
		buttonsCommands["Add spawn position for current flag"] = TEXT.AddSpawnCommand
		buttonsCommands["Remove all custom spawn positions for current flag"] = TEXT.RemoveSpawnsCommand
		buttonsCommands["Enable Zombies"] = TEXT.EnableZombiesCommand
		buttonsCommands["Disable Zombies"] = TEXT.DisableZombiesCommand
		buttonsCommands["Add zombie spawn position here"] = TEXT.AddZombieCommand
		buttonsCommands["Drop Zombies"] = TEXT.DropZombiesCommand
		buttonsCommands["Enable Meteor Storm"] = TEXT.EnableMeteorStormCommand
		buttonsCommands["Disable Meteor Storm"] = TEXT.DisableMeteorStormCommand
		buttonsCommands["Clear all jail positions and set one here"] = TEXT.AddJailPosCommand
		buttonsCommands["Add jail position here"] = TEXT.AddExtraJailPosCommand

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
	
	PropertySheet:AddSheet( TEXT.PlayerMenu, PlayerInfo, "icon16/user.png", false, false, TEXT.GeneralInfo);
	PropertySheet:AddSheet( TEXT.CharacterMenu, CharPanel, "icon16/group.png", false, false, TEXT.CharSwitchOrNew);
	PropertySheet:AddSheet( TEXT.Roles, CityCommands, "icon16/wrench.png", false, false, TEXT.CommonCommandsOrFlag);
	PropertySheet:AddSheet( TEXT.Backpack, Inventory, "icon16/box.png", false, false, TEXT.ViewYourInventory)
	PropertySheet:AddSheet( TEXT.Business, Business, "icon16/box.png", false, false, TEXT.PurchaseItems);
	PropertySheet:AddSheet( TEXT.Scoreboard, Scoreboard, "icon16/application_view_detail.png", false, false, TEXT.ViewScoreboard);		
	PropertySheet:AddSheet( TEXT.Help, Help, "icon16/magnifier.png", false, false, TEXT.HelpTextMenu);
	if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
		PropertySheet:AddSheet( "Admin", Admin, "icon16/application_view_detail.png", false, false, TEXT.AdminCommandsMenu);
	end
end
usermessage.Hook("playermenu", CreatePlayerMenu);
