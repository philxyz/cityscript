-- Unobtrusive prop protection by philxyz
-- Client-side code

include("shared_upp.lua")
include("language_english_upp.lua") -- Language strings are defined here.
include("upp_default_allow_list.lua") -- Include the default allow list.

UPP.Allowed_Models = {} -- All models that may be spawned.

for _, model in ipairs(UPP.Default_Allowed_Model_List) do
	UPP.Allowed_Models[model] = true
end

-- Overrides for which models show in spawn menu.
net.Receive("upp.amdl", function(len)
	local model = net.ReadString()
	UPP.Allowed_Models[model] = true
end)

net.Receive("upp.rmdl", function(len)
	local model = net.ReadString()
	UPP.Allowed_Models[model] = nil
end)
-- End of overrides.

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
		surface.PlaySound("ambient/energy/zap1.wav")
	elseif which == UPP.Messages.YourPropsCleanedUpByYou then
		GAMEMODE:AddNotify("#upp.prop_cleanup_you", NOTIFY_CLEANUP, 3)
		surface.PlaySound("ambient/energy/zap1.wav")
	elseif which == UPP.Messages.AllPropsCleanedUp then
		GAMEMODE:AddNotify("#upp.prop_cleanup_all", NOTIFY_CLEANUP, 3)
		surface.PlaySound("ambient/energy/zap1.wav")
	elseif which == UPP.Messages.YourEntsCleanedUp then
		GAMEMODE:AddNotify("#upp.ent_cleanup", NOTIFY_CLEANUP, 3)
		surface.PlaySound("ambient/energy/zap1.wav")
	elseif which == UPP.Messages.AllEntsCleanedUp then
		GAMEMODE:AddNotify("#upp.ent_cleanup_all", NOTIFY_CLEANUP, 3)
		surface.PlaySound("ambient/energy/zap1.wav")
	elseif which == UPP.Messages.PropDisallowed then
		GAMEMODE:AddNotify("#upp.prop_disallowed", NOTIFY_ERROR, 3)
		surface.PlaySound("vo/Citadel/br_no.wav")
	elseif which == UPP.Messages.NoSENTsAllowed then
		GAMEMODE:AddNotify("#upp.sents_disallowed", NOTIFY_ERROR, 3)
		surface.PlaySound("vo/Citadel/br_no.wav")
	elseif which == UPP.Messages.NoRagdollsAllowed then
		GAMEMODE:AddNotify("#upp.ragdolls_disallowed", NOTIFY_ERROR, 3)
		surface.PlaySound("vo/Citadel/br_no.wav")
	elseif which == UPP.Messages.NoEffectsAllowed then
		GAMEMODE:AddNotify("#upp.effects_disallowed", NOTIFY_ERROR, 3)
		surface.PlaySound("vo/Citadel/br_no.wav")
	elseif which == UPP.Messages.NoSWEPsAllowed then
		GAMEMODE:AddNotify("#upp.sweps_disallowed", NOTIFY_ERROR, 3)
		surface.PlaySound("vo/Citadel/br_no.wav")
	elseif which == UPP.Messages.NoNPCsAllowed then
		GAMEMODE:AddNotify("#upp.npcs_disallowed", NOTIFY_ERROR, 3)
		surface.PlaySound("vo/Citadel/br_no.wav")
	elseif which == UPP.Messages.PlayerAlreadyTrusted then
		GAMEMODE:AddNotify("#upp.player_already_trusted", NOTIFY_ERROR, 3)
		surface.PlaySound("vo/Citadel/br_no.wav")
	end
end)

spawnmenu.AddContentType("model", function(container, obj)
	local mdl = obj.model:lower()

	local isAllowed = UPP.Allowed_Models[mdl] == true

	if not LocalPlayer():IsAdmin() and not isAllowed then return end

	local icon = vgui.Create("SpawnIcon", container)

	if obj.body then
		obj.body = string.Trim(tostring(obj.body), "B")
	end

	if obj.wide then
		icon:SetWide(obj.wide)
	end

	if obj.tall then
		icon:SetTall(obj.tall)
	end

	icon:InvalidateLayout(true)

	icon:SetModel(obj.model, obj.skin or 0, obj.body)

	icon:SetTooltip(string.Replace(string.GetFileFromFilename(obj.model), ".mdl", ""))

	icon.DoClick = function(icon)
		surface.PlaySound("ui/buttonclickrelease.wav")
		RunConsoleCommand("gm_spawn", icon:GetModelName(), icon:GetSkinID() or 0, icon:GetBodyGroup() or "")
	end

	icon.OpenMenu = function(icon)
		local menu = DermaMenu()
		menu:AddOption("Copy to Clipboard", function() SetClipboardText(string.gsub(obj.model, "\\", "/")) end)
		menu:AddOption("Spawn using Toolgun", function()
			RunConsoleCommand("gmod_tool", "creator")
			RunConsoleCommand("creator_type", "4")
			RunConsoleCommand("creator_name", obj.model)
		end)

		local submenu = menu:AddSubMenu("Re-Render", function() icon:RebuildSpawnIcon() end)
		submenu:AddOption("This Icon", function() icon:RebuildSpawnIcon() end)
		submenu:AddOption("All Icons", function() container:RebuildAll() end)

		menu:AddOption("Edit Icon", function()
			local editor = vgui.Create("IconEditor")
			editor:SetIcon(icon)
			editor:Refresh()
			editor:MakePopup()
			editor:Center()
		end)

		local ChangeIconSize = function(w, h)
			icon:SetSize(w, h)
			icon:InvalidateLayout(true)
			container:OnModified()
			container:Layout()
			icon:SetModel(obj.model, obj.skin or 0, obj.body)
		end

		local submenu2 = menu:AddSubMenu("Resize", function() end)
		submenu2:AddOption("64 x 64 (default)", function() ChangeIconSize(64, 64) end)
		submenu2:AddOption("64 x 128", function() ChangeIconSize(64, 128) end)
		submenu2:AddOption("64 x 256", function() ChangeIconSize(64, 256) end)
		submenu2:AddOption("64 x 512", function() ChangeIconSize(64, 512) end)
		submenu2:AddSpacer()
		submenu2:AddOption("128 x 64", function() ChangeIconSize(128, 64) end)
		submenu2:AddOption("128 x 128", function() ChangeIconSize(128, 128) end)
		submenu2:AddOption("128 x 256", function() ChangeIconSize(128, 256) end)
		submenu2:AddOption("128 x 512", function() ChangeIconSize(128, 512) end)
		submenu2:AddSpacer()
		submenu2:AddOption("256 x 64", function() ChangeIconSize(256, 64) end)
		submenu2:AddOption("256 x 128", function() ChangeIconSize(256, 128) end)
		submenu2:AddOption("256 x 256", function() ChangeIconSize(256, 256) end)
		submenu2:AddOption("256 x 512", function() ChangeIconSize(256, 512) end)
		submenu2:AddSpacer()
		submenu2:AddOption("512 x 64", function() ChangeIconSize(512, 64) end)
		submenu2:AddOption("512 x 128", function() ChangeIconSize(512, 128) end)
		submenu2:AddOption("512 x 256", function() ChangeIconSize(512, 256) end)
		submenu2:AddOption("512 x 512", function() ChangeIconSize(512, 512) end)
		submenu2:AddSpacer()

		if LocalPlayer():IsAdmin() then
			menu:AddSpacer()

			menu:AddOption("#upp.allowthese", function()
				UPP.Allowed_Models[mdl] = true
				net.Start("upp.aths")
				net.WriteString(mdl)
				net.SendToServer()
			end)

			menu:AddOption("#upp.disallowthese", function()
				UPP.Allowed_Models[mdl] = nil
				net.Start("upp.dths")
				net.WriteString(mdl)
				net.SendToServer()
			end)

			menu:AddSpacer()
		end

		menu:AddOption("Delete", function() icon:Remove() hook.Run("SpawnlistContentChanged") end)
		menu:Open()
	end

	icon:InvalidateLayout(true)

	if IsValid(container) then
		container:Add(icon)
	end

	return icon
end)
