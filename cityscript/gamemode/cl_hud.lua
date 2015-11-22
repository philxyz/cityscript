-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- cl_hud.lua 
-- General HUD stuff.
-------------------------------

include("cl_upp.lua")

LocalPlayer().MyModel = "" -- Has to be blank for the initial value, so it will create a spawnicon in the first place.

surface.CreateFont("ATMFont", {
	font = "ChatFont",
	size = 48,
	weight = 120,
	antialias = true
})

surface.CreateFont("PlInfoFont", {
	font = "ChatFont",
	size = 22,
	weight = 100,
	antialias = true
})

surface.CreateFont("PlAmmoFont1", {
	font = "ChatFont",
	size = 72,
	weight = 120,
	antialias = true
})

surface.CreateFont("PlAmmoFont2", {
        font = "ChatFont",
        size = 36,
        weight = 120,
        antialias = true
})

local function DrawTime()
	draw.DrawText(GetGlobalString("time"), "PlInfoFont", 10, 10, Color(255, 255, 255, 255), 0)
end

function DrawTargetInfo()
	local tr = LocalPlayer():GetEyeTrace()
	
	if not tr.HitNonWorld or not IsValid(tr.Entity) then
		return
	end
	
	if (not tr.Entity:IsVehicle() and not tr.Entity:IsPlayer() and not tr.Entity:IsNPC()) and tr.Entity:GetPos():Distance(LocalPlayer():GetPos()) < 100 then
		local screenpos = tr.Entity:GetPos():ToScreen()

		draw.DrawText(tr.Entity:GetNWString("Name"), "ChatFont", screenpos.x + 2, screenpos.y + 2, Color(0, 0, 0, 255), 1)
		draw.DrawText(tr.Entity:GetNWString("Name"), "ChatFont", screenpos.x, screenpos.y, Color(255, 255, 255, 255), 1)

		if tr.Entity:GetNWString("Title") ~= "" and not CAKE.IsDoor(tr.Entity) then
			draw.DrawText(tr.Entity:GetNWString("Title"), "ChatFont", screenpos.x + 2, screenpos.y + 22, Color( 0, 0, 0, 255 ), 1)
			draw.DrawText(tr.Entity:GetNWString("Title"), "ChatFont", screenpos.x, screenpos.y + 20, Color( 255, 255, 255, 255 ), 1)
		else
			draw.DrawText(tr.Entity:GetNWString("Description"), "ChatFont", screenpos.x + 2, screenpos.y + 22, Color(0, 0, 0, 255), 1)
			draw.DrawText(tr.Entity:GetNWString("Description"), "ChatFont", screenpos.x, screenpos.y + 20, Color(255, 255, 255, 255), 1)
		end

		if tr.Entity:GetNWBool("shipment") then
			draw.DrawText(tostring(tr.Entity.dt.count) .. " units\n" .. tostring(math.floor(((tr.Entity.dt.count * tr.Entity.dt.itemWt)*100)+0.5)/100) .. "kg NET", "ChatFont", screenpos.x + 2, screenpos.y + 42, Color( 0, 0, 0, 255 ), 1)
			draw.DrawText(tostring(tr.Entity.dt.count) .. " units\n" .. tostring(math.floor(((tr.Entity.dt.count * tr.Entity.dt.itemWt)*100)+0.5)/100) .. "kg NET", "ChatFont", screenpos.x, screenpos.y + 40, Color( 255, 255, 255, 255 ), 1)
		end

		if tr.Entity:GetNWBool("ATM") then
			draw.DrawText( TEXT.ATMText, "ATMFont", screenpos.x + 2, screenpos.y + 22, Color( 0, 255, 0, 255 ), 1)
			draw.DrawText( TEXT.ATMText, "ATMFont", screenpos.x, screenpos.y + 20, Color( 255, 255, 255, 255 ), 1)
		end
	end
end
		
function GM:HUDShouldDraw( name )
	if not IsValid(LocalPlayer()) then return false end

	if LocalPlayer():GetNWInt("charactercreate") == 1 or LocalPlayer():GetNWInt("charactercreate") == nil then
		return false
	end
	
	local nodraw = 
	{ 
	
		"CHudHealth",
		"CHudAmmo",
		"CHudSecondaryAmmo",
		"CHudBattery",
	
	}
	
	for k, v in pairs(nodraw) do
		if name == v then
			return false
		end
	end
	
	return true
end

function GM:PostDrawViewModel(vm, ply, weapon)
	if weapon.UseHands or not weapon:IsScripted() then
		local hands = LocalPlayer():GetHands()

		if IsValid(hands) then
			hands:DrawModel()
		end
	end
end

function DrawInfoPanel()
	local hx = 9
	local hy = ScrH() - 22
	local hw = 190
	local hh = 10

	-- Tokens Display
	draw.DrawText(LocalPlayer():GetNWString("money") .. " " .. TEXT.Tokens, "TargetID", hx + 1, hy - 34, Color(0, 0, 0, 200), 0)
	draw.DrawText(LocalPlayer():GetNWString("money") .. " " .. TEXT.Tokens, "TargetID", hx, hy - 35, Color(255, 255, 255, 200), 0)

	-- Health Bar Background
	draw.RoundedBox(0, hx - 1, hy - 1, hw + 2, hh + 2, Color(0, 0, 0, 200))

	-- Health Bar Foreground
	if LocalPlayer():Health() > 0 then
		draw.RoundedBox(0, hx, hy, math.Clamp(hw * (LocalPlayer():Health() / 100), 0, 190), hh, Color(255, 255, 255, 200))
	end
end

function DrawDeathMeter()
	local timeleft = LocalPlayer():GetDTInt(2)
	local w = (timeleft / 120) * 198
	
	draw.RoundedBox(8, ScrW() / 2 - 100, 5, 200, 50, Color(GUIcolor_trans))
	draw.RoundedBox(8, ScrW() / 2 - 98, 7, w, 46, Color(255, 0, 0, 255))
	
	draw.DrawText(TEXT.TimeLeft .. " " .. TEXT.HowToRespawn, "ChatFont", ScrW() / 2 - 93, 25 - 5, Color(255, 255, 255, 255), 0)
end

function ShowHelpPopup()
	local frame = vgui.Create("DFrame")
	local ok = vgui.Create("DButton", frame)
	local label = vgui.Create("DLabel", frame)
	label:SetFont("ScoreboardText")
	label:SetPos(10, 30)
	label:SetText(TEXT.ItemsHelpHintText)
	label:SizeToContents()
	local label2 = vgui.Create("DLabel", frame)
	label2:SetFont("ScoreboardText")
	label2:SetPos(10, 56)
	label2:SetText(TEXT.MainHelpHintText)
	label2:SizeToContents()
	
	local check = vgui.Create("DCheckBoxLabel", frame)
	check:SetPos(10, 88)
	check:SetText(TEXT.HideHelpHintsCheckText)
	check:SetValue(false)
	check:SizeToContents()
	check.OnChange = function(me, status)
		net.Start("Ca")
		net.WriteBool(not status)
		net.SendToServer()
	end;

	ok:SetText(TEXT.HelpHintCloseBtn)
	ok:SetSize(85, 25)

	ok.DoClick = function()
		frame:SetVisible(false)
	end

	frame:SetSize(500, 160)
	ok:SetPos(frame:GetWide()/2-ok:GetWide()/2, 120)
	frame:SetTitle(TEXT.FirstTimeHelpTitle)
	frame:SetVisible(true)
	frame:SetDraggable(false)
	frame:ShowCloseButton(false)
	frame:SetBackgroundBlur(true)
	frame:SetDeleteOnClose(true)
	frame:Center()
	frame:MakePopup()
end

function DrawPlayerInfo()
	for k, v in pairs(player.GetAll()) do
		if v ~= LocalPlayer() then
			if v:Alive() then
				local alpha = 0
				local position = v:GetPos()
				local position = Vector(position.x, position.y, position.z + 75)
				local screenpos = position:ToScreen()
				local dist = position:Distance(LocalPlayer():GetPos())
				local dist = dist / 2
				local dist = math.floor(dist)
				
				if dist > 100 then
					alpha = 255 - (dist - 100)
				else
					alpha = 255
				end
				
				if alpha > 255 then
					alpha = 255
				elseif alpha < 0 then
					alpha = 0
				end
				
				draw.DrawText(v:Nick(), "DefaultSmall", screenpos.x, screenpos.y, Color(255, 255, 255, alpha), 1)
				draw.DrawText(team.GetName(v:Team()), "DefaultSmall", screenpos.x, screenpos.y + 10, Color(255, 255, 255, alpha), 1)
				draw.DrawText(v:GetNWString("title"), "DefaultSmall", screenpos.x, screenpos.y + 20, Color(255, 255, 255, alpha), 1)
				
				if v:GetDTInt(3) == 1 then
					draw.DrawText(TEXT.Typing, "ChatFont", screenpos.x, screenpos.y - 50, Color(255, 255, 255, alpha), 1)
				end
			end
		end
	end
end

function DrawAmmoDisplay()
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()

	if IsValid(wep) then
		local ammoCount = ply:GetAmmoCount(wep:GetPrimaryAmmoType())

		draw.DrawText(tostring(wep:Clip1()), "PlAmmoFont1", ScrW() - 120, ScrH() - 80, Color(255, 255, 255, 240), TEXT_ALIGN_RIGHT)
		draw.DrawText(tostring(ammoCount), "PlAmmoFont2", ScrW() - 78, ScrH() - 84, Color(255, 255, 255, 240), TEXT_ALIGN_LEFT)

		draw.RoundedBox(0, ScrW() - 102, ScrH() - 80, 8, 60, Color(0, 0, 0, 255))

		local barHeight = math.floor((wep:Clip1() / wep:GetMaxClip1()) * 58)
		draw.RoundedBox(0, ScrW() - 101, ScrH() - 21 - barHeight, 6, barHeight, Color(255, 255, 255, 240))

		-- debug only:
		--[[
		local primaryAmmoName = game.GetAmmoName(wep:GetPrimaryAmmoType()) or "None"
		local secondaryAmmoName = game.GetAmmoName(wep:GetSecondaryAmmoType()) or "None"
		local str = "Primary Ammo: " .. primaryAmmoName .. ", Secondary Ammo: " .. secondaryAmmoName
		surface.SetFont("DefaultSmall")
		local w, h = surface.GetTextSize(str)
		draw.DrawText(str, "DefaultSmall", ScrW()/2.0 - w, ScrH() - 60, Color(255,255,255,255), TEXT_ALIGN_LEFT)
		]]
	end
end

function DrawRevivalTimer()
	local dmr = LocalPlayer():GetNWInt("deathmoderemaining")
	if dmr > 0 then
		local text = TEXT.TimeUntilDeath(tostring(dmr or "-"))
		draw.DrawText(text, "PlAmmoFont1", (ScrW() / 2)+2, 102, Color(0, 0, 0, 0), TEXT_ALIGN_CENTER)
		draw.DrawText(text, "PlAmmoFont1", ScrW() / 2, 100, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		draw.DrawText(TEXT.AcceptFate, "PlAmmoFont2", (ScrW() / 2)+2, 172, Color(0, 0, 0, 0), TEXT_ALIGN_CENTER)
		draw.DrawText(TEXT.AcceptFate, "PlAmmoFont2", ScrW() / 2, 170, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end
end

function GM:HUDPaint()
	local tr = LocalPlayer():GetEyeTrace()
	local superAdmin = LocalPlayer():IsSuperAdmin()

	if IsValid(tr.Entity) and CAKE.IsDoor(tr.Entity) and tr.Entity:GetPos():Distance(LocalPlayer():GetPos()) < 200 then
		local pos = tr.HitPos:ToScreen()
		local ent = tr.Entity
		local st

		if ent:GetNWBool("nonRentable") then
			st = ent:GetNWString("dTitle") -- show disabled door title
		else
			st = ent:GetNWString("title") or "" --  show enabled door title
		end

		draw.DrawText(st, "TargetID", pos.x + 1, pos.y + 1, Color(0, 0, 0, 200), 1)
		draw.DrawText(st, "TargetID", pos.x, pos.y, Color(255, 255, 255, 200), 1)
	end
	
	if LocalPlayer():GetDTInt(1) == 1 then
		DrawDeathMeter()
	end
	
	DrawTime()
	DrawPlayerInfo()
	DrawTargetInfo()
	DrawInfoPanel()
	DrawAmmoDisplay()
	DrawRevivalTimer()
	UPP.DrawUI()
end
