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
		panel:AddItem(b)

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
				usm:AddOption(v:SteamID() .. " " .. v:Name(), function()
					net.Start("upp.de")
					net.WriteEntity(v)
					net.SendToServer()
				end):SetIcon("icon16/user_delete.png")
			end
			cm:Open()
		end
		panel:AddItem(c)
	end)
	spawnmenu.AddToolMenuOption("upp", "uppCategory", "uppMyProps", "#upp.my_props", "", "", function(panel)
		
	end)
	spawnmenu.AddToolMenuOption("upp", "uppCategory", "uppTrustedPlayers", "#upp.trusted_players", "", "", function() end)
end)

net.Receive("upp.notify", function(len, sender)
	local which = net.ReadInt(7)

	if which == UPP.Messages.YourPropsCleanedUp then
		GAMEMODE:AddNotify("#upp.prop_cleanup", NOTIFY_CLEANUP, 3)
	elseif which == UPP.Messages.AllPropsCleanedUp then
		GAMEMODE:AddNotify("#upp.prop_cleanup_all", NOTIFY_CLEANUP, 3)
	elseif which == UPP.Messages.YourEntsCleanedUp then
		GAMEMODE:AddNotify("#upp.ent_cleanup", NOTIFY_CLEANUP, 3)
	elseif which == UPP.Messages.AllEntsCleanedUp then
		GAMEMODE:AddNotify("#upp.ent_cleanup_all", NOTIFY_CLEANUP, 3)
	end
end)
