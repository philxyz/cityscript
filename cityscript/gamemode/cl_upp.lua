-- Unobtrusive prop protection by philxyz
-- Client-side code

include("shared_upp.lua")
include("language_english_upp.lua") -- Language strings are defined here.

function UPP.DrawUI()
	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	local tr = util.TraceLine(util.GetPlayerTrace(ply))

	if tr.HitNonWorld then
		if IsValid(tr.Entity) and not tr.Entity:IsPlayer() and not ply:InVehicle() and tr.Entity:GetNWString("creator") ~= "" then
			local creator = "Creator: " .. tr.Entity:GetNWString("creator")
			surface.SetDrawColor(10, 10, 10, 255)
			surface.SetFont("ScoreboardText")
			local wid, hei = surface.GetTextSize(creator)
			surface.DrawRect(ScrW() - wid - 18, 162, wid + 18, hei+6)
			draw.DrawText(creator, "ScoreboardText", ScrW() - 8, 165, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
		end
	end
end

hook.Add("AddToolMenuTabs", "UPP.AddToToolMenu", function()
	spawnmenu.AddToolTab("upp", "Prop Protection", "icon16/shield.png")
end)

hook.Add("AddToolMenuCategories", "UPP.AddToolCategory", function()
	spawnmenu.AddToolCategory("upp", "uppCategory", "#upp.prop_protection")

	spawnmenu.AddToolMenuOption("upp", "uppCategory", "uppAdminTools", "#upp.admin_tools", "", "", function(panel)
		if not panel then return end

		panel:ClearControls()

		local cleanupSlider = vgui.Create("DNumSlider")
		cleanupSlider:SetText("#upp.cleanup_time")
		cleanupSlider:SetConVar("upp_prop_cleanup_dc_timer")
		cleanupSlider:SetMin(0)
		cleanupSlider:SetMax(60)
		cleanupSlider:SetDecimals(0)
		cleanupSlider.LastVal = 0
		cleanupSlider.OnValueChanged = function(me, val)
			local nv = math.floor(val + 0.5)
			if nv ~= cleanupSlider.LastVal then
				cleanupSlider.LastVal = nv
				net.Start("upp.cln_mins")
				net.WriteInt(nv, 7)
				net.SendToServer()
			end
		end
		panel:AddItem(cleanupSlider)

		-- What to do when we receive a response to the bit that comes
		-- after this.
		net.Receive("upp.csv", function(len, sender)
			local newVal = net.ReadInt(7)
			cleanupSlider.LastVal = newVal
			cleanupSlider:SetValue(newVal)
		end)

		-- Request the slider's value from the server. Response is handled
		-- in the above code.
		net.Start("upp.csr") -- Cleanup Slider Ready (for its value)
		net.SendToServer()

		local b = vgui.Create("DButton")
		b:SetText("#upp.remove_props")
		b.DoClick = function()
			-- Get a list of players. Name, RPname and SteamID
			local players = player.GetAll()
			local bm = vgui.Create("DMenu")
			bm:AddOption("#upp.for_all_players", function()
				net.Start("upp.dap")
				net.SendToServer()
			end):SetIcon("icon16/group_delete.png")
			local usm = bm:AddSubMenu("#upp.for_player")
			for _, v in pairs(players) do
				usm:AddOption(v:SteamID() .. " " .. v:Name(), function()
					net.Start("upp.dp")
					net.WriteEntity(v)
					net.SendToServer()
				end):SetIcon("icon16/user_delete.png")
			end
			bm:Open()
		end

		local c = vgui.Create("DButton")
		c:SetText("#upp.remove_ents")
		c.DoClick = function()
			local players = player.GetAll()
			local cm = vgui.Create("DMenu")
			cm:AddOption("#upp.for_all_players", function()
				net.Start("upp.dae")
				net.SendToServer()
			end):SetIcon("icon16/group_delete.png")
			local usm = cm:AddSubMenu("#upp.for_player")
			for _, v in pairs(players) do
				usm:AddOption(v:Name() .. " - " .. v:SteamID(), function()
					net.Start("upp.de")
					net.WriteEntity(v)
					net.SendToServer()
				end):SetIcon("icon16/user_delete.png")
			end
			cm:Open()
		end

		local divider = vgui.Create("DHorizontalDivider")
		divider:Dock(FILL)
		divider:SetLeft(b)
		divider:SetRight(c)
		divider:SetDividerWidth(6)
		divider:SetDragging(false)

		panel:AddItem(divider)
	end)

	spawnmenu.AddToolMenuOption("upp", "uppCategory", "uppMyProps", "#upp.my_props", "", "", function(panel)
		if not panel then return end

		panel:ClearControls()

		local clearProps = vgui.Create("DButton")
		clearProps:SetText("#upp.remove_my_props")
		clearProps.DoClick = function()
			net.Start("upp.rmp")
			net.SendToServer()
		end

		panel:AddItem(clearProps)
	end)

	spawnmenu.AddToolMenuOption("upp", "uppCategory", "uppTrustedPlayers", "#upp.trusted_players", "", "", function(panel)
		if not panel then return end

		panel:ClearControls()

		local removeBtn = vgui.Create("DButton")
		removeBtn:SetVisible(false)

		if UPP.TrustedPlayersPanel == nil then
			UPP.TrustedPlayersPanel = vgui.Create("DListView")
			UPP.TrustedPlayersPanel:SetMultiSelect(false)
			UPP.TrustedPlayersPanel:AddColumn("#upp.name_now")
			UPP.TrustedPlayersPanel:AddColumn("#upp.name_when_added")
			UPP.TrustedPlayersPanel:AddColumn("#upp.s64id")
			UPP.TrustedPlayersPanel:SetHeight(400)
			UPP.TrustedPlayersPanel.OnRowSelected = function(me, idx, row)
				UPP.RemoveTrustedSteamID64 = row.steamID64
				removeBtn:SetVisible(true)
			end

			panel:AddItem(UPP.TrustedPlayersPanel)

			-- Ready to receive the list of trusted players.
			net.Start("upp.tpr")
			net.SendToServer()

			local addBtn = vgui.Create("DButton")
			addBtn:SetText("#upp.add_trusted")
			addBtn.DoClick = function()
				-- Get a list of players.
				local players = player.GetAll()
				local bm = vgui.Create("DMenu")
				for _, v in pairs(players) do
					if v ~= LocalPlayer() then
						bm:AddOption(v:Name(), function()
							net.Start("upp.ntp")
							net.WriteEntity(v)
							net.SendToServer()
						end):SetIcon("icon16/user_add.png")
					end
				end
				bm:Open()
			end

			removeBtn:SetText("#upp.remove_selected")
			removeBtn.DoClick = function()
				if UPP.RemoveTrustedSteamID64 ~= nil then
					net.Start("upp.rtp")
					net.WriteString(UPP.RemoveTrustedSteamID64)
					net.SendToServer()
					removeBtn:SetVisible(false)
				end
			end

			local divider = vgui.Create("DHorizontalDivider")
			divider:Dock(FILL)
			divider:SetLeft(addBtn)
			divider:SetRight(removeBtn)
			divider:SetDividerWidth(6)
			divider:SetDragging(false)

			panel:AddItem(divider)
		end
	end)
end)

-- Add trusted player
net.Receive("upp.atp", function(len, sender)
	local steamID64 = net.ReadString()
	local originalName = net.ReadString() -- What the player was called when you added them.

	if UPP.TrustedPlayersPanel ~= nil then
		local lines = UPP.TrustedPlayersPanel:GetLines()

		local found = false
		for _, line in pairs(lines) do
			if line:GetValue(3) == steamID64 then
				found = true
				break
			end
		end

		if not found then
			steamworks.RequestPlayerInfo(steamID64)
			timer.Simple(2, function()
				local name = steamworks.GetPlayerName(steamID64)
				local line = UPP.TrustedPlayersPanel:AddLine(name, originalName, steamID64)
				line.steamID64 = steamID64
			end)
		end
	end
end)

-- Remove trusted player from client
net.Receive("upp.rtc", function(len, sender)
	local steamID64 = net.ReadString()
	local lines = UPP.TrustedPlayersPanel:GetLines()

	for n, l in ipairs(lines) do
		if l:GetValue(3) == steamID64 then
			UPP.TrustedPlayersPanel:RemoveLine(n)
			break
		end
	end
end)

net.Receive("upp.notify", function(len, sender)
	local which = net.ReadInt(7)

	if which == UPP.Messages.YourPropsCleanedUp then
		GAMEMODE:AddNotify("#upp.prop_cleanup", NOTIFY_CLEANUP, 3)
	elseif which == UPP.Messages.YourPropsCleanedUpByYou then
		GAMEMODE:AddNotify("#upp.prop_cleanup_you", NOTIFY_CLEANUP, 3)
	elseif which == UPP.Messages.AllPropsCleanedUp then
		GAMEMODE:AddNotify("#upp.prop_cleanup_all", NOTIFY_CLEANUP, 3)
	elseif which == UPP.Messages.YourEntsCleanedUp then
		GAMEMODE:AddNotify("#upp.ent_cleanup", NOTIFY_CLEANUP, 3)
	elseif which == UPP.Messages.AllEntsCleanedUp then
		GAMEMODE:AddNotify("#upp.ent_cleanup_all", NOTIFY_CLEANUP, 3)
	elseif which == UPP.Messages.PropDisallowed then
		GAMEMODE:AddNotify("#upp.prop_disallowed", NOTIFY_ERROR, 3)
	elseif which == UPP.Messages.NoSENTsAllowed then
		GAMEMODE:AddNotify("#upp.sents_disallowed", NOTIFY_ERROR, 3)
	elseif which == UPP.Messages.NoRagdollsAllowed then
		GAMEMODE:AddNotify("#upp.ragdolls_disallowed", NOTIFY_ERROR, 3)
	elseif which == UPP.Messages.NoEffectsAllowed then
		GAMEMODE:AddNotify("#upp.effects_disallowed", NOTIFY_ERROR, 3)
	elseif which == UPP.Messages.NoSWEPsAllowed then
		GAMEMODE:AddNotify("#upp.sweps_disallowed", NOTIFY_ERROR, 3)
	elseif which == UPP.Messages.NoNPCsAllowed then
		GAMEMODE:AddNotify("#upp.npcs_disallowed", NOTIFY_ERROR, 3)
	elseif which == UPP.Messages.PlayerAlreadyTrusted then
		GAMEMODE:AddNotify("#upp.player_already_trusted", NOTIFY_ERROR, 3)
	end
end)

-- Replace the Spawnlists tab of the Q menu with one that has UPP-specific features:
local AddBrowseContentForGameProps2 = function(ViewPanel, node, name, path, pathid, pnlContent)
	local models = node:AddFolder(name, path .. "models", pathid, false)
	models:SetIcon(icon)
	models.BrowseContentType = "models"
	models.BrowseExtension = "*.mdl"
	models.ContentType = "model"
	models.ViewPanel = ViewPanel
	models.OnNodeSelected = function(slf, node)
		if ViewPanel and ViewPanel.CurrentNode and ViewPanel.CurrentNode == node then return end

		ViewPanel:Clear(true)
		ViewPanel.CurrentNode = node

		local Path = node:GetFolder()
		local SearchString = Path .. "/*.mdl"

		local Models = file.Find(SearchString, node:GetPathID())
		for k, v in pairs(Models) do
			local cp = spawnmenu.GetContentType("model")
			if cp then
				local icn = cp(ViewPanel, { model = Path .. "/" .. v })
				icn.OpenMenu = function(slf)
					local menu = DermaMenu()
					menu:AddOption("Who's laughing now?", function() end)
					menu:Open()
				end
			end
		end

		pnlContent:SwitchPanel(ViewPanel)
		ViewPanel.CurrentNode = node
	end
end

hook.Add("PopulateContent2", "GameProps2", function(pnlContent, tree, node)
	local MyNode = node:AddNode("#spawnmenu.category.games", "icon16/folder_database.png")

	local ViewPanel = vgui.Create("ContentContainer", pnlContent)
	ViewPanel:SetVisible(false)

	local games = engine.GetGames()
	table.insert(games, {
		title = "All",
		folder = "GAME",
		icon = "all",
		mounted = true
	})
	table.insert(games, {
		title = "Garry's Mod",
		folder = "garrysmod",
		mounted = true
	})

	for _, game in SortedPairsByMemberValue(games, "title") do
		if not game.mounted then continue end

		AddBrowseContentForGameProps2(ViewPanel, MyNode, game.title, "games/16/" .. (game.icon or game.folder) .. ".png", "", game.folder, pnlContent)
	end
end)

local function AddRecursiveAddonProps2(pnl, folder, path, wildcard)
	local files, folders = file.Find(folder .. "*", path)

	for k, v in pairs(files) do
		if not string.EndsWith(v, ".mdl") then continue end

		local cp = spawnmenu.GetContentType("model")
		if cp then
			local icn = cp(pnl, { model = folder .. v})
			icn.OpenMenu = function(slf)
				local menu = DermaMenu()
				menu:AddOption("Who's laughing now?", function() end)
				menu:Open()
			end
		end
	end

	for k, v in pairs(folders) do
		AddRecursiveAddonProps2(pnl, folder .. v .. "/", path, wildcard)
	end
end

hook.Add("PopulateContent2", "AddonProps2", function(pnlContent, tree, node)
	-- If the player is a superadmin, allow real-time prop restriction.
	local ViewPanel = vgui.Create("ContentContainer", pnlContent)
	ViewPanel:SetVisible(false)

	local MyNode = node:AddNode("#spawnmenu.category.addons", "icon16/folder_database.png")

	for _, addon in SortedPairsByMemberValue(engine.GetAddons(), "title") do
		if not addon.downloaded or not addon.mounted or addon.models <= 0 then continue end

		local models = MyNode:AddNode(addon.title .. " (" .. addon.models .. ")", "icon16/bricks.png")
		models.DoClick = function()
			ViewPanel:Clear(true)
			AddRecursiveAddonProps2(ViewPanel, "models/", addon.title, "*.mdl")
			pnlContent:SwitchPanel(ViewPanel)
		end
	end
end)

hook.Add("PopulateContent2", "AddSearchContent2", function(pnlContent, tree, node)
	ContentPanel = pnlContent
end)

local SetupCustomNode = function(node, pnlContent, needsapp)
	if needsapp and needsapp ~= "" then
		node:SetVisible(IsMounted(needsapp))
		node.NeedsApp = needsapp
	end

	node.OnModified = function()
		hook.Run("SpawnlistContentChanged")
	end

	node.SetupCopy = function(self, copy)
		SetupCustomNode(copy, pnlContent)
		self:DoPopulate()

		copy.PropPanel = self.PropPanel:Copy()
		copy.PropPanel:SetVisible(false)

		copy.DoPopulate = function() end
	end

	node.DoRightClick = function(self)
		local menu = DermaMenu()
		menu:AddOption("Edit", function() self:InternalDoClick(); hook.Run("OpenToolbox") end)
		menu:AddOption("New Category", function() node:Remove(); hook.Run("SpawnlistContentChanged") end)
		menu:AddOption("Delete", function() node:Remove(); hook.Run("SpawnlistContentChanged") end)

		menu:Open()
	end

	node.DoPopulate = function(self)
		if not self.PropPanel then
			self.PropPanel = vgui.Create("ContentContainer", pnlContent)
			self.PropPanel:SetVisible(false)
			self.PropPanel:SetTriggerSpawnlistChange(true)
		end
	end

	node.DoClick = function(self)
		self:DoPopulate()
		pnlContent:SwitchPanel(self.PropPanel)
	end
end

local AddCustomizableNode = function(pnlContent, name, icon, parent, needsapp)
	local node = parent:AddNode(name, icon)
	SetupCustomNode(node, pnlContent, needsapp)

	return node
end

hook.Add("PopulateContent2", "AddCustomContent2", function(pnlContent, tree, node)
	local node = AddCustomizableNode(pnlContent, "#spawnmenu.category.your_spawnlists", "", tree)
	node:SetDraggableName("CustomContent")
	node.DoRightClick = function(self)
		local menu = DermaMenu()
		menu:AddOption("New Category", function() AddCustomizableNode(pnlContent, "New Category", "", node); node:SetExpanded(true); hook.Run("SpawnlistContentChanged") end)
		menu:Open()
	end
	node.OnModified = function()
		hook.Run("SpawnlistContentChanged")
	end

	AddPropsOfParent(pnlContent, node, 0)

	node:SetExpanded(true)
	node:MoveToBack()

	CustomizableSpawnlistNode = node

	local FirstNode = node:GetChildNode(0)
	if IsValid(FirstNode) then
		FirstNode:InternalDoClick()
	end
end)

spawnmenu.AddCreationTab("#spawnmenu.content_tab2", function()
	--local ctrl = vgui.Create("UPPSpawnmenuContentPanel")
	local ctrl = vgui.Create("SpawnmenuContentPanel")
	ctrl.OldSpawnlists = ctrl.ContentNavBar.Tree:AddNode("#spawnmenu.category.browse", "icon16/cog.png")

	ctrl:EnableModify()
	hook.Call("PopulatePropMenu", GAMEMODE)
	ctrl:CallPopulateHook("PopulateContent2")
	ctrl.OldSpawnlists:MoveToFront()
	ctrl.OldSpawnlists:SetExpanded(true)

	return ctrl
end, "icon16/application_view_tile.png", -10, nil)
