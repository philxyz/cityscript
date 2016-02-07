-- Unobtrusive prop protection by philxyz
-- Server-side code

include("shared_upp.lua")

function UPP.PlayerSpawnedProp(ply, model, ent)
        ent:SetNWString("creator", ply:Name())
        ent:SetNWEntity("c_ent", ply)
	ent:SetNWFloat("born", CurTime())
end
hook.Add("PlayerSpawnedProp", "UPP.PlayerSpawnedProp", UPP.PlayerSpawnedProp)

function UPP.PlayerSpawnedVehicle(ply, ent)
        ent:SetNWString("creator", ply:Name())
        ent:SetNWEntity("c_ent", ply)
end
hook.Add("PlayerSpawnedVehicle", "UPP.PlayerSpawnedVehicle", UPP.PlayerSpawnedVehicle)

function UPP.GravGunPunt(ply, ent)
	--[[
	if ent:IsVehicle() then return false end

        local entphys = ent:GetPhysicsObject()

	if ply:KeyDown(IN_ATTACK) then
		entphys:EnableMotion(false)
		local curpos = ent:GetPos()
		timer.Simple(.01, function() entphys:EnableMotion(true) end)
		timer.Simple(.01, function() entphys:Wake() end)
		timer.Simple(.01, function() ent:SetPos(curpos) end)
	else
		return true
	end
	]]
	return false
end
hook.Add("GravGunPunt", "UPP.GravGunPunt", UPP.GravGunPunt)

function UPP.PhysgunPickup(ply, ent)
	local class = ent:GetClass():lower()

	if ply:IsAdmin() then
		-- Specific to CityScript:
		if ent:GetClass() == "atm" then
			return ent:GetMoveType() == MOVETYPE_VPHYSICS
		end

		return true
	end

	-- If you're not an admin, you can't pick players up
	if class == "player" then return false end

	-- You can only interact with prop_physics with the physgun
	if class ~= "prop_physics" then return false end

	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		if not phys:IsMotionEnabled() then
			local creator = ent:GetNWEntity("c_ent")
			if IsValid(creator) and creator:IsPlayer() then
				if creator:UserID() == ply:UserID() then
					return true
				else
					-- Non-owners can't touch a prop for the first 3 seconds of its life
					if ent:GetNWFloat("born") == 0 or CurTime() < ent:GetNWFloat("born") + 3 then
						return false
					else
						local last_frozen_by = ent:GetNWEntity("lf_by")
						if IsValid(last_frozen_by) and ply:UserID() == last_frozen_by:UserID() then
							return true
						else
							return false
						end
					end
				end
			else
				return ply:IsAdmin()
			end
		else
			return true
		end
	end
end
hook.Add("PhysgunPickup", "UPP.PhysgunPickup", UPP.PhysgunPickup)

function UPP.PlayerFrozeObject(ply, ent, phys)
	if IsValid(ent) and IsValid(ply) then
		ent:SetNWEntity("lf_by", ply)
	end
end
hook.Add("PlayerFrozeObject", "UPP.PlayerFrozeObject", UPP.PlayerFrozeObject)

function UPP.PlayerUse(ply, ent)
	return true
end
hook.Add("PlayerUse", "UPP.PlayerUse", UPP.PlayerUse)

function UPP.OnPhysgunReload(physgun, ply)
	print("OnPhysgunReloaded called")
	if ply:IsAdmin() then return true end

	local tr = ply:GetEyeTrace()

	if IsValid(tr.Entity) then
		local creator = tr.Entity:GetNWEntity("creator")
		local last_freezer = tr.Entity:GetNWEntity("lf_by")
		if IsValid(creator) and creator:IsPlayer() then
			return (creator:UserID() == ply:UserID()) or (IsValid(last_freezer) and last_freezer:UserID() == ply:UserID())
		end
	end

	return false
end
hook.Add("OnPhysgunReload", "UPP.OnPhysgunReload", UPP.OnPhysgunReload)

function UPP.CanTool(ply, tr, tool)
	if IsValid(tr.Entity) then
		if tr.Entity:IsPlayer() or tr.Entity:IsVehicle() then
			return ply:IsAdmin()
		end

		local class = tr.Entity:GetClass()
		if class == "prop_physics" then
			-- Only prop creators can use toolgun on physics props
			local creator = tr.Entity:GetNWEntity("c_ent")
			return IsValid(creator) and creator:UserID() == ply:UserID()
		else
			return false
		end
	end
end
hook.Add("CanTool", "UPP.CanTool", UPP.CanTool)

function UPP.CanDrive(ply, ent)
	return false
end
hook.Add("CanDrive", "UPP.CanDrive", UPP.CanDrive)

-- Notify Players
util.AddNetworkString("upp.notify")
function UPP.NotifyPlayers(which, ply) -- The set of valid messages is defined in shared_upp.lua
	-- If we want to send to a single player
	if ply ~= nil then
		if not IsValid(ply) then
			return
		else
			net.Start("upp.notify")
			net.WriteInt(which, 7) -- Max 64 different messages for UPP
			net.Send(ply)
		end
	else
		-- ply specified as nil, send to all players
		net.Start("upp.notify")
		net.WriteInt(which, 7)
		net.Send(player.GetAll())
	end
end

-- Whether this is a prop
function UPP.IsANormalProp(ent)
	if IsValid(ent) then
		local class = ent:GetClass()

		return class == "prop_physics" or class == "prop_ragdoll"
	else
		return false
	end
end

-- Whether this is an entity (this changes depending on the gamemode that UPP is used with).
-- If you want to integrate UPP with your gamemode, update this to reflect the entities you have there.
function UPP.IsConsideredAnEntity(ent)
	local class = ent:GetClass()
	return class == "spawned_shipment" or class == "token_bundle" or class == "toxic" or
		class == "item_prop" or class == "sent_nuke_part" or class == "storage_box" or
		class == "token_printer"
end

util.AddNetworkString("upp.cln_mins")
net.Receive("upp.cln_mins", function(len, sender)
	local mins = net.ReadInt(7)
	if sender:IsAdmin() then
		print("Value changed to: " .. tostring(mins))
	end
end)

-- Delete Props (for specific player)
util.AddNetworkString("upp.dp")
net.Receive("upp.dp", function(len, sender)
	local who = net.ReadEntity()

	if sender:IsAdmin() then
		for _, p in pairs(ents.GetAll()) do
			if p:GetNWEntity("c_ent") == who and UPP.IsANormalProp(p) then
				p:Remove()
			end
		end
		UPP.NotifyPlayers(UPP.Messages.YourPropsCleanedUp, who)
	end
end)

-- Delete All Props (for all players)
util.AddNetworkString("upp.dap")
net.Receive("upp.dap", function(len, sender)
	if sender:IsAdmin() then
		for _, p in pairs(ents.GetAll()) do
			if UPP.IsANormalProp(p) then
				p:Remove()
			end
		end
		UPP.NotifyPlayers(UPP.Messages.AllPropsCleanedUp)
	end
end)

-- Delete Ents (for specific player)
util.AddNetworkString("upp.de")
net.Receive("upp.de", function(len, sender)
	local who = net.ReadEntity()

	if sender:IsAdmin() then
		for _, p in pairs(ents.GetAll()) do
			if p:GetNWEntity("c_ent") == who and UPP.IsConsideredAnEntity(p) then
				p:Remove()
			end
		end
		UPP.NotifyPlayers(UPP.Messages.YourEntsCleanedUp, who)
	end
end)

-- Delete All Entities (for all users)
util.AddNetworkString("upp.dae")
net.Receive("upp.dae", function(len, sender)
	if sender:IsAdmin() then
		for _, p in pairs(ents.GetAll()) do
			if UPP.IsConsideredAnEntity(p) then
				p:Remove()
			end
		end
		UPP.NotifyPlayers(UPP.Messages.AllEntsCleanedUp)
	end
end)
