-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- cl_binds.lua
-- Changes what keys do.
-------------------------------

CAKE.ContextEnabled = false

function GM:PlayerBindPress(ply, bind, pressed)
	if LocalPlayer():GetNWInt("charactercreate") == 1 then
		if bind == "+forward" or bind == "+back" or bind == "+moveleft" or bind == "+moveright" or bind == "+jump" or bind == "+duck" then
			-- Disable ALL movement keys.
			return true
		end
	end
	--[[
	if bind == "+use" then
		local trent = LocalPlayer():GetEyeTrace().Entity

		if trent ~= nil and IsValid(trent) and CAKE.IsDoor(trent) then
			-- Open door
			net.Start("Cl")
			net.SendToServer()
		end
	end
	]]
end

function GM:ScoreboardShow()
	CAKE.ContextEnabled = true
	gui.EnableScreenClicker(true)
	HiddenButton:SetVisible(true)
end

function GM:ScoreboardHide()
	CAKE.ContextEnabled = false
	gui.EnableScreenClicker(false)
	HiddenButton:SetVisible(false)
end

function GM:StartChat()
	net.Start("Cg")
	net.SendToServer()
end

function GM:FinishChat()
	net.Start("Cd")
	net.SendToServer()
end
