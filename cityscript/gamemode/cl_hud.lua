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

local function DrawPleaseWaitMessage()
	if CAKE.ShowLoadingMessage then
		surface.SetFont("PlInfoFont")
		local w, h = surface.GetTextSize(TEXT.PleaseWaitMessage)
		local w2 = (ScrW() / 2) - (w / 2)
		local h2 = (ScrH() / 2) - (h / 2)
		surface.SetTextPos(w2 - 1, h2 - 1)
		surface.SetTextColor(Color(0, 0, 0, 0))
		surface.DrawText(TEXT.PleaseWaitMessage)
		surface.SetTextColor(Color(255, 255, 255, 255))
		surface.SetTextPos(w2, h2)
		surface.DrawText(TEXT.PleaseWaitMessage)
	end
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
		"CHudBattery"
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
		local st = ent:GetNWString("dTitle") or ""

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
	DrawPleaseWaitMessage()
	UPP.DrawUI()
end

CAKE.Voices = {}

function CAKE.AddVoice(id, path, soundgroup, text, fa)
        local voice = {}
        voice.path = path
        voice.soundgroup = soundgroup or 0
        voice.line = text or ""
        voice.femalealt = fa or ""
	voice.id = id

CAKE.Voices[id] = voice
end

CAKE.AddVoice("question01", "vo/npc/male01/question01.wav", 1, "I don't think this war is ever gonna end.", "vo/npc/female01/question01.wav")
CAKE.AddVoice("question02", "vo/npc/male01/question02.wav", 1, "To think! All I wanted to do was sell insurance.", "vo/npc/female01/question02.wav")
CAKE.AddVoice("question03", "vo/npc/male01/question03.wav", 1, "I don't dream anymore.", "vo/npc/female01/question03.wav")
CAKE.AddVoice("question04", "vo/npc/male01/question04.wav", 1, "When this is all over I'm... nah, who am I kidding.", "vo/npc/female01/question04.wav")
CAKE.AddVoice("question05", "vo/npc/male01/question05.wav", 1, "Woah. Dejavu.", "vo/npc/female01/question05.wav")
CAKE.AddVoice("question06", "vo/npc/male01/question06.wav", 1, "Sometimes.. I dream about cheese.", "vo/npc/female01/question06.wav")
CAKE.AddVoice("question07", "vo/npc/male01/question07.wav", 1, "You smell that? It's freedom.", "vo/npc/female01/question07.wav")
CAKE.AddVoice("question08", "vo/npc/male01/question08.wav", 1, "If I ever get my hands on Doctor Breen..", "vo/npc/female01/question08.wav")
CAKE.AddVoice("question09", "vo/npc/male01/question09.wav", 1, "I could eat a horse! Hooves and all..", "vo/npc/female01/question09.wav")
CAKE.AddVoice("question10", "vo/npc/male01/question10.wav", 1, "I can't believe this day has finally come!", "vo/npc/female01/question10.wav")
CAKE.AddVoice("question11", "vo/npc/male01/question11.wav", 1, "I'm pretty sure this isn't part of the plan.", "vo/npc/female01/question11.wav")
CAKE.AddVoice("question12", "vo/npc/male01/question12.wav", 1, "Looks to me like things are getting worse, not better.", "vo/npc/female01/question12.wav")
CAKE.AddVoice("question13", "vo/npc/male01/question13.wav", 1, "If I could live my life over again..", "vo/npc/female01/question13.wav")
CAKE.AddVoice("question14", "vo/npc/male01/question14.wav", 1, "I'm not even gonna tell you what that reminds me of.", "vo/npc/female01/question14.wav")
CAKE.AddVoice("question15", "vo/npc/male01/question15.wav", 1, "They're never gonna make a stalker out of me!", "vo/npc/female01/question15.wav")
CAKE.AddVoice("question16", "vo/npc/male01/question16.wav", 1, "Finally! Change is in the air!", "vo/npc/female01/question16.wav")
CAKE.AddVoice("question17", "vo/npc/male01/question17.wav", 1, "You feel it? I feel it.", "vo/npc/female01/question17.wav")
CAKE.AddVoice("question18", "vo/npc/male01/question18.wav", 1, "I don't feel anything anymore.", "vo/npc/female01/question18.wav")
CAKE.AddVoice("question19", "vo/npc/male01/question19.wav", 1, "I can't remember the last time I had a shower.", "vo/npc/female01/question19.wav")
CAKE.AddVoice("question20", "vo/npc/male01/question20.wav", 1, "Some day.. this'll all be a bad memory.", "vo/npc/female01/question20.wav")
CAKE.AddVoice("question21", "vo/npc/male01/question21.wav", 1, "I'm not a betting man, but the odds are not good.", "vo/npc/female01/question21.wav")
CAKE.AddVoice("question22", "vo/npc/male01/question22.wav", 1, "Doesn't anyone care what I think?", "vo/npc/female01/question22.wav")
CAKE.AddVoice("question23", "vo/npc/male01/question23.wav", 1, "I can't get this tune out of my head! *whistles*", "vo/npc/female01/question23.wav")
CAKE.AddVoice("question25", "vo/npc/male01/question25.wav", 1, "I just knew it was gonna be one of those days.", "vo/npc/female01/question25.wav")
CAKE.AddVoice("question26", "vo/npc/male01/question26.wav", 1, "This is bullshit!", "vo/npc/female01/question26.wav")
CAKE.AddVoice("question27", "vo/npc/male01/question27.wav", 1, "I think I ate something bad..", "vo/npc/female01/question27.wav")
CAKE.AddVoice("question28", "vo/npc/male01/question28.wav", 1, "God I'm hungry!", "vo/npc/female01/question28.wav")
CAKE.AddVoice("question29", "vo/npc/male01/question29.wav", 1, "When this is all over, I'm gonna mate.", "vo/npc/female01/question29.wav")
CAKE.AddVoice("question30", "vo/npc/male01/question30.wav", 1, "I'm glad there's no kids around to see this.", "vo/npc/female01/question30.wav")
CAKE.AddVoice("answer01", "vo/npc/male01/answer01.wav", 1, "That's you all over.", "vo/npc/female01/answer01.wav")
CAKE.AddVoice("answer02", "vo/npc/male01/answer02.wav", 1, "I won't hold it against you.", "vo/npc/female01/answer02.wav")
CAKE.AddVoice("answer03", "vo/npc/male01/answer03.wav", 1, "Figures.", "vo/npc/female01/answer03.wav")
CAKE.AddVoice("answer04", "vo/npc/male01/answer04.wav", 1, "Try not to dwell on it.", "vo/npc/female01/answer04.wav")
CAKE.AddVoice("answer05", "vo/npc/male01/answer05.wav", 1, "Can we talk about this later?", "vo/npc/female01/answer05.wav")
CAKE.AddVoice("answer07", "vo/npc/male01/answer07.wav", 1, "Same here.", "vo/npc/female01/answer07.wav")
CAKE.AddVoice("answer08", "vo/npc/male01/answer08.wav", 1, "I know what you mean.", "vo/npc/female01/answer08.wav")
CAKE.AddVoice("answer09", "vo/npc/male01/answer09.wav", 1, "You're talking to yourself again.", "vo/npc/female01/answer09.wav")
CAKE.AddVoice("answer10", "vo/npc/male01/answer10.wav", 1, "I wouldn't say that too loud.", "vo/npc/female01/answer10.wav")
CAKE.AddVoice("answer11", "vo/npc/male01/answer11.wav", 1, "I'll put it on your tombstone!", "vo/npc/female01/answer11.wav")
CAKE.AddVoice("answer12", "vo/npc/male01/answer12.wav", 1, "It doesn't bear thinking about.", "vo/npc/female01/answer12.wav")
CAKE.AddVoice("answer13", "vo/npc/male01/answer13.wav", 1, "I'm with you.", "vo/npc/female01/answer13.wav")
CAKE.AddVoice("answer14", "vo/npc/male01/answer14.wav", 1, "Heh! You and me both.", "vo/npc/female01/answer14.wav")
CAKE.AddVoice("answer15", "vo/npc/male01/answer15.wav", 1, "Thaaats... one way of looking at it.", "vo/npc/female01/answer15.wav")
CAKE.AddVoice("answer16", "vo/npc/male01/answer16.wav", 1, "Have you ever had an original thought?", "vo/npc/female01/answer16.wav")
CAKE.AddVoice("answer17", "vo/npc/male01/answer17.wav", 1, "I'm not even gonna tell you to shut up.", "vo/npc/female01/answer17.wav")
CAKE.AddVoice("answer18", "vo/npc/male01/answer18.wav", 1, "Let's concentrate on the task at hand!", "vo/npc/female01/answer18.wav")
CAKE.AddVoice("answer19", "vo/npc/male01/answer19.wav", 1, "Keep your mind on your work!", "vo/npc/female01/answer19.wav")
CAKE.AddVoice("answer20", "vo/npc/male01/answer20.wav", 1, "Your mind is in the gutter.", "vo/npc/female01/answer20.wav")
CAKE.AddVoice("answer21", "vo/npc/male01/answer21.wav", 1, "Don't be so sure of that.", "vo/npc/female01/answer21.wav")
CAKE.AddVoice("answer22", "vo/npc/male01/answer22.wav", 1, "You never know.", "vo/npc/female01/answer22.wav")
CAKE.AddVoice("answer23", "vo/npc/male01/answer23.wav", 1, "You never can tell.", "vo/npc/female01/answer23.wav")
CAKE.AddVoice("answer24", "vo/npc/male01/answer24.wav", 1, "Why are you telling ME?", "vo/npc/female01/answer24.wav")
CAKE.AddVoice("answer25", "vo/npc/male01/answer25.wav", 1, "How about that?", "vo/npc/female01/answer25.wav")
CAKE.AddVoice("answer26", "vo/npc/male01/answer26.wav", 1, "That's more information than I require.", "vo/npc/female01/answer26.wav")
CAKE.AddVoice("answer27", "vo/npc/male01/answer27.wav", 1, "Heheh, wanna bet?", "vo/npc/female01/answer27.wav")
CAKE.AddVoice("answer28", "vo/npc/male01/answer28.wav", 1, "I wish I had a dime for every time somebody said that.", "vo/npc/female01/answer28.wav")
CAKE.AddVoice("answer29", "vo/npc/male01/answer29.wav", 1, "What am I supposed to do about it?", "vo/npc/female01/answer29.wav")
CAKE.AddVoice("answer30", "vo/npc/male01/answer30.wav", 1, "You talkin to me?", "vo/npc/female01/answer30.wav")
CAKE.AddVoice("answer31", "vo/npc/male01/answer31.wav", 1, "You should nip that kind of talk in the bud.", "vo/npc/female01/answer31.wav")
CAKE.AddVoice("answer32", "vo/npc/male01/answer32.wav", 1, "Right on!", "vo/npc/female01/answer32.wav")
CAKE.AddVoice("answer33", "vo/npc/male01/answer33.wav", 1, "No argument there.", "vo/npc/female01/answer33.wav")
CAKE.AddVoice("answer34", "vo/npc/male01/answer34.wav", 1, "Don't forget Hawaii!", "vo/npc/female01/answer34.wav")
CAKE.AddVoice("answer35", "vo/npc/male01/answer35.wav", 1, "Try not to let it get to you.", "vo/npc/female01/answer35.wav")
CAKE.AddVoice("answer36", "vo/npc/male01/answer36.wav", 1, "Wouldn't be the first time.", "vo/npc/female01/answer36.wav")
CAKE.AddVoice("answer37", "vo/npc/male01/answer37.wav", 1, "You sure about that?", "vo/npc/female01/answer37.wav")
CAKE.AddVoice("answer38", "vo/npc/male01/answer38.wav", 1, "Leave it alone.", "vo/npc/female01/answer38.wav")
CAKE.AddVoice("answer39", "vo/npc/male01/answer39.wav", 1, "That's enough out of you.", "vo/npc/female01/answer39.wav")
CAKE.AddVoice("answer40", "vo/npc/male01/answer40.wav", 1, "There's a first time for everything.", "vo/npc/female01/answer40.wav")

CAKE.AddVoice("combine", "vo/npc/male01/combine01.wav", 1, "/y Combine!", "vo/npc/female01/combine01.wav")
CAKE.AddVoice("doingsomething", "vo/npc/male01/doingsomething.wav", 1, "Shouldn't we.. uhh.. be doing something?", "vo/npc/female01/doingsomething.wav")
CAKE.AddVoice("excuseme", "vo/npc/male01/excuseme01.wav", 1, "Excuse me.", "vo/npc/female01/excuseme01.wav")
CAKE.AddVoice("fantastic", "vo/npc/male01/fantastic01.wav", 1, "Fantastic!", "vo/npc/female01/fantastic.wav")
CAKE.AddVoice("finally", "vo/npc/male01/finally.wav", 1, "Finally.", "vo/npc/female01/finally.wav")
CAKE.AddVoice("gethellout", "vo/npc/male01/gethellout.wav", 1, "/y Get the hell out of here!", "vo/npc/female01/gethellout.wav")
CAKE.AddVoice("goodgod", "vo/npc/male01/goodgod.wav", 1, "Good god!", "vo/npc/female01/goodgod.wav")
CAKE.AddVoice("gotone1", "vo/npc/male01/gotone01.wav", 1, "Got one!", "vo/npc/female01/gotone01.wav")
CAKE.AddVoice("gotone2", "vo/npc/male01/gotone02.wav", 1, "Hahah! I got one!", "vo/npc/female01/.wav")
CAKE.AddVoice("help", "vo/npc/male01/help01.wav", 1, "/y HELP!", "vo/npc/female01/help01.wav")
CAKE.AddVoice("hi", "vo/npc/male01/hi01.wav", 1, "Hi.", "vo/npc/female01/hi01.wav")
CAKE.AddVoice("illstayhere", "vo/npc/male01/illstayhere01.wav", 1, "I'll stay here.", "vo/npc/female01/illstayhere01.wav")
CAKE.AddVoice("leadtheway", "vo/npc/male01/leadtheway01.wav", 1, "You lead the way!", "vo/npc/female01/leadtheway01.wav")
CAKE.AddVoice("letsgo", "vo/npc/male01/letsgo01.wav", 1, "/y Let's go!", "vo/npc/female01/letsgo01.wav")
CAKE.AddVoice("noscream1", "vo/npc/male01/no01.wav", 1, "No! NO!", "vo/npc/female01/no01.wav")
CAKE.AddVoice("noscream2", "vo/npc/male01/no02.wav", 1, "/y Noooooo!", "vo/npc/female01/no02.wav")
CAKE.AddVoice("imready", "vo/npc/male01/okimready01.wav", 1, "Ok, I'm ready.", "vo/npc/female01/okimready01.wav")
CAKE.AddVoice("oneforme", "vo/npc/male01/oneforme.wav", 1, "One for me and one... for me.", "vo/npc/female01/oneforme.wav")
CAKE.AddVoice("overhere", "vo/npc/male01/overhere01.wav", 1, "/y Hey, over here!", "vo/npc/female01/overhere01.wav")
CAKE.AddVoice("runforyourlife", "vo/npc/male01/runforyourlife01.wav", 1, "/y Run for your life!", "vo/npc/female01/runforyourlife.wav")
CAKE.AddVoice("sorry", "vo/npc/male01/sorry01.wav", 1, "Sorry.", "vo/npc/female01/sorry01.wav")
CAKE.AddVoice("heregoesnothing", "vo/npc/male01/squad_affirm06.wav", 1, "Here goes nothing.", "vo/npc/female01/squad_affirm06.wav")
CAKE.AddVoice("run", "vo/npc/male01/strider_run.wav", 1, "/y Ruuuuun!", "vo/npc/female01/strider_run.wav")
CAKE.AddVoice("donicely", "vo/npc/male01/thislldonicely01.wav", 1, "This'll do nicely!", "vo/npc/female01/thislldonicely01.wav")
CAKE.AddVoice("waitingsomebody", "vo/npc/male01/waitingsomebody.wav", 1, "You waiting for somebody?", "vo/npc/female01/waitingsomebody.wav")
CAKE.AddVoice("whoops", "vo/npc/male01/whoops01.wav", 1, "Whoops.", "vo/npc/female01/whoops01.wav")
CAKE.AddVoice("yeah", "vo/npc/male01/yeah02.wav", 1, "Yeah!", "vo/npc/female01/yeah02.wav")
CAKE.AddVoice("yougotit", "vo/npc/male01/yougotit02.wav", 1, "You got it!", "vo/npc/female01/yougotit.wav")

CAKE.AddVoice("1199", "npc/metropolice/vo/11-99officerneedsassistance.wav", 2, "/radio 11-99, officer needs assistance!")
CAKE.AddVoice("administer", "npc/metropolice/vo/administer.wav", 2, "Administer.")
CAKE.AddVoice("affirmative", "npc/metropolice/vo/affirmative.wav", 2, "/radio Affirmative.")
CAKE.AddVoice("youcango", "npc/metropolice/vo/allrightyoucango.wav", 2, "All right. You can go.")
CAKE.AddVoice("movein", "npc/metropolice/vo/allunitsmovein.wav", 2, "/radio All units, move in.")
CAKE.AddVoice("amputate", "npc/metropolice/vo/amputate.wav", 2, "Amputate.")
CAKE.AddVoice("anticitizen", "npc/metropolice/vo/anticitizen.wav", 2, "Anticitizen.")
CAKE.AddVoice("apply", "npc/metropolice/vo/apply.wav", 2, "Apply.")
CAKE.AddVoice("cauterize", "npc/metropolice/vo/cauterize.wav", 2, "Cauterize.")
CAKE.AddVoice("miscount", "npc/metropolice/vo/checkformiscount.wav", 2, "/radio Check for miscount.")
CAKE.AddVoice("chuckle", "npc/metropolice/vo/chuckle.wav", 2, "/me chuckles")
CAKE.AddVoice("citizen", "npc/metropolice/vo/citizen.wav", 2, "Citizen.")
CAKE.AddVoice("control100percent", "npc/metropolice/vo/control100percent.wav", 2, "/radio Control is 100 percent at this location. No sign of that 647-E.")
CAKE.AddVoice("controlsection", "npc/metropolice/vo/controlsection.wav", 2, "Control section.")
CAKE.AddVoice("converging", "npc/metropolice/vo/converging.wav", 2, "Converging.")
CAKE.AddVoice("copy", "npc/metropolice/vo/copy.wav", 2, "/radio Copy.")
CAKE.AddVoice("coverme", "npc/metropolice/vo/covermegoingin.wav", 2, "Cover me, I'm going in!")
CAKE.AddVoice("trespass", "npc/metropolice/vo/criminaltrespass63.wav", 2, "/radio 6-3 Criminal Trespass.")
CAKE.AddVoice("destroythatcover", "npc/metropolice/vo/destroythatcover.wav", 2, "Destroy that cover!")
CAKE.AddVoice("introuble", "npc/metropolice/vo/dispatchineed10-78.wav", 2, "/radio Dispatch, I need 10-78. Officer in trouble!")
CAKE.AddVoice("document", "npc/metropolice/vo/document.wav", 2, "Document.")
CAKE.AddVoice("dontmove", "npc/metropolice/vo/dontmove.wav", 2, "Don't move!")
CAKE.AddVoice("verdictadministered", "npc/metropolice/vo/finalverdictadministered.wav", 2, "/radio Final verdict administered.")
CAKE.AddVoice("finalwarning", "npc/metropolice/vo/finalwarning.wav", 2, "Final warning.")
CAKE.AddVoice("firstwarningmove", "npc/metropolice/vo/firstwarningmove.wav", 2, "First warning. Move away.")
CAKE.AddVoice("getdown", "npc/metropolice/vo/getdown.wav", 2, "/y Get down!")
CAKE.AddVoice("getoutofhere", "npc/metropolice/vo/getoutofhere.wav", 2, "Get out of here.")
CAKE.AddVoice("grenade", "npc/metropolice/vo/grenade.wav", 2, "/y Grenade!")
CAKE.AddVoice("help", "npc/metropolice/vo/help.wav", 2, "/y Help!")
CAKE.AddVoice("hesrunning", "npc/metropolice/vo/hesrunning.wav", 2, "/radio He's running!")
CAKE.AddVoice("holdit", "npc/metropolice/vo/holdit.wav", 2, "/y Hold it!")
CAKE.AddVoice("investigate", "npc/metropolice/vo/investigate.wav", 2, "/radio Investigate.")
CAKE.AddVoice("investigating", "npc/metropolice/vo/investigating10-103.wav", 2, "/radio Investigating 10-103.")
CAKE.AddVoice("movealong", "npc/metropolice/vo/isaidmovealong.wav", 2, "I said move along.")
CAKE.AddVoice("isolate", "npc/metropolice/vo/isolate.wav", 2, "Isolate.")
CAKE.AddVoice("keepmoving", "npc/metropolice/vo/keepmoving.wav", 2, "Keep moving.")
CAKE.AddVoice("location", "npc/metropolice/vo/location.wav", 2, "/radio Location.")
CAKE.AddVoice("nowgetoutofhere", "npc/metropolice/vo/nowgetoutofhere.wav", 2, "Now get out of here.")
CAKE.AddVoice("officerneedshelp", "npc/metropolice/vo/officerneedshelp.wav", 2, "/radio Officer needs help!")
CAKE.AddVoice("prosecute", "npc/metropolice/vo/prosecute.wav", 2, "Prosecute.")
CAKE.AddVoice("residentialblock", "npc/metropolice/vo/residentialblock.wav", 2, "/radio Residential block.")
CAKE.AddVoice("responding", "npc/metropolice/vo/responding.wav", 2, "/radio Responding.")
CAKE.AddVoice("rodgerthat", "npc/metropolice/vo/rodgerthat.wav", 2, "/radio Rodger that.")
CAKE.AddVoice("searchingforsuspect", "npc/metropolice/vo/searchingforsuspect.wav", 2, "/radio Searching for suspect, no status.")
CAKE.AddVoice("shit", "npc/metropolice/vo/shit.wav", 2, "/y Shit!")
CAKE.AddVoice("sweepingforsuspect", "npc/metropolice/vo/sweepingforsuspect.wav", 2, "/radio Sweeping for suspect.")
CAKE.AddVoice("thereheis", "npc/metropolice/vo/thereheis.wav", 2, "/y There he is!")
CAKE.AddVoice("unlawfulentry", "npc/metropolice/vo/unlawfulentry603.wav", 2, "/radio 603, unlawful entry.")
CAKE.AddVoice("vacatecitizen", "npc/metropolice/vo/vacatecitizen.wav", 2, "Vacate, citizen.")
CAKE.AddVoice("malcompliance", "npc/metropolice/vo/youwantamalcomplianceverdict.wav", 2, "You want a malcompliance verdict?")

local voiceButtons = {}
for i=1, 20 do
	local idx = #voiceButtons + 1
	voiceButtons[idx] = vgui.Create("DButton")
	voiceButtons[idx]:SetVisible(false)
	voiceButtons[idx]:SetSize(ScrH()/2 - 10, 22)
	voiceButtons[idx]:SetText("Example Button")
	voiceButtons[idx]:SetPos(ScrW()/2 - 100, ScrH() - 450 + (22 * (i-1)))
end

function HideAllButtons()
	for i=1, 20 do
		if voiceButtons[i] ~= nil then
			voiceButtons[i]:SetVisible(false)
		end
	end
end
hook.Add("FinishChat", "Hide voice buttons", HideAllButtons)

local ListVoiceOptions = function(newtext)
	if #newtext == 0 then
		return
	end

	local phrases = {}

	-- Input text split into words
	local splitTextInput = string.gmatch(newtext, "%S+")

	-- the lower-case version of each of the above
	local words = {}

	for word in splitTextInput do
		table.insert(words, string.lower(word))
	end

	for id, tab in pairs(CAKE.Voices) do
		if (LocalPlayer():GetModel() == "models/police.mdl" and tab.soundgroup == 2) or (LocalPlayer():GetModel() ~= "models/police.mdl" and tab.soundgroup == 1) then
			if string.lower(tab.line):find(string.lower(newtext)) ~= nil then
				table.insert(phrases, tab)
			end
		end
	end

	for i=1, 20 do
		if phrases[i] == nil then
			voiceButtons[i]:SetVisible(false)
		else
			voiceButtons[i]:SetText(phrases[i].line)
			voiceButtons[i].DoClick = function()
				net.Start("C8")
				net.WriteString(phrases[i].id)
				net.SendToServer()
			end
			voiceButtons[i]:SetVisible(true)
		end
	end
end

function GM:ChatTextChanged(newtext)
	ListVoiceOptions(newtext)
end
