-- Unobtrusive prop protection by philxyz
-- Server-side code

include("shared_upp.lua")

UPP.GamemodeName = "CityScript" -- Change this if you're using UPP in a different gamemode. It keeps UPP's DB-backed settings separated per gamemode.

function UPP.Initialize()
	-- Create the database for UPP settings, if it doesn't already exist

	UPP.PropTimeout = 5 -- Minutes

	sql.Begin()
	sql.Query("CREATE TABLE IF NOT EXISTS UPP_Settings('gamemode' TEXT NOT NULL, 'prop_timeout_mins' INTEGER NOT NULL, PRIMARY KEY('gamemode'));")
	sql.Query("CREATE TABLE IF NOT EXISTS UPP_TrustedPlayers('gamemode' TEXT NOT NULL, 'PlayerSteamID64' INTEGER NOT NULL, 'TrustedPlayerSteamID64' INTEGER NOT NULL, PRIMARY KEY('gamemode', 'PlayerSteamID64'));")
	sql.Commit()

	local pto = sql.Query("SELECT prop_timeout_mins FROM UPP_Settings WHERE gamemode = " .. sql.SQLStr(UPP.GamemodeName) .. ";")

	local err = sql.LastError()
	if err ~= nil then	
		print("SQL ERROR: " .. err)
	else
		if pto == nil then
			-- If there is no record of how long the props should exist after a player disconnects, create one with the default value.
			sql.Query("INSERT INTO UPP_Settings(gamemode, prop_timeout_mins) VALUES(" .. sql.SQLStr(UPP.GamemodeName) .. ", " .. tostring(UPP.PropTimeout) .. ");")
		else
			UPP.PropTimeout = tonumber(pto[1].prop_timeout_mins)
		end
	end
end

function UPP.UpdatePropTimeout(newValue)
	sql.Query("UPDATE UPP_Settings SET prop_timeout_mins = " .. tostring(newValue) .. " WHERE gamemode = " .. sql.SQLStr(UPP.GamemodeName) .. ";")
	if sql.LastError() == nil then
		UPP.PropTimeout = newValue
	end
end

UPP.LastItemSpawned = {}

function UPP.SpamCheck(ply)
	local uid = ply:UserID()

	if UPP.LastItemSpawned[uid] == nil then
		-- An item was spawned, log when it happened
		UPP.LastItemSpawned[uid] = {}
		UPP.LastItemSpawned[uid].When = CurTime()
		UPP.LastItemSpawned[uid].Count = 0 -- How many items were spawned within too-short an interval.
	else
		local now = CurTime()
		local diff = now - UPP.LastItemSpawned[uid].When
		if diff >= 0.15 and diff < 0.85 then
			if UPP.LastItemSpawned[uid].Count >= 3 then
				ply:Kick("Prop spam.")
			else
				UPP.LastItemSpawned[uid].Count = UPP.LastItemSpawned[uid].Count + 1
			end
		else
			UPP.LastItemSpawned[uid].Count = 0
		end

		UPP.LastItemSpawned[uid].When = CurTime()
	end
end

-- Set the identifying info on items created by the player.
function UPP.PlayerSpawnedProp(ply, model, ent)
        ent:SetNWString("creator", ply:Name())
        ent:SetNWEntity("c_ent", ply)
	ent:SetNWFloat("born", CurTime())

	UPP.SpamCheck(ply)
end
hook.Add("PlayerSpawnedProp", "UPP.PlayerSpawnedProp", UPP.PlayerSpawnedProp)

function UPP.PlayerSpawnedSENT(ply, ent)
	ent:SetNWString("creator", ply:Name())
	ent:SetNWEntity("c_ent", ply)
	ent:SetNWFloat("born", CurTime())
end
hook.Add("PlayerSpawnedSENT", "UPP.PlayerSpawnedSENT", UPP.PlayerSpawnedSENT)

function UPP.PlayerSpawnedRagdoll(ply, model, ent)
	ent:SetNWString("creator", ply:Name())
	ent:SetNWEntity("c_ent", ply)
	ent:SetNWFloat("born", CurTime())
end
hook.Add("PlayerSpawnedRagdoll", "UPP.PlayerSpawnedRagdoll", UPP.PlayerSpawnedRagdoll)

function UPP.PlayerSpawnedNPC(ply, ent)
	ent:SetNWString("creator", ply:Name())
	ent:SetNWEntity("c_ent", ply)
	ent:SetNWFloat("born", CurTime())
end
hook.Add("PlayerSpawnedNPC", "UPP.PlayerSpawnedNPC", UPP.PlayerSpawnedNPC)

function UPP.PlayerSpawnedVehicle(ply, ent)
	ent:SetNWString("creator", ply:Name())
	ent:SetNWEntity("c_ent", ply)
	ent:SetNWFloat("born", CurTime())
end
hook.Add("PlayerSpawnedVehicle", "UPP.PlayerSpawnedVehicle", UPP.PlayerSpawnedVehicle)


-- Permission to spawn things
function UPP.PlayerSpawnObject(ply, model, skin)
	-- Depending on allow list or deny list, allow or deny the object.

	-- UPP.NotifyPlayers(UPP.Messages.PropDisallowed, ply)
end
hook.Add("PlayerSpawnObject", "UPP.PlayerSpawnObject", UPP.PlayerSpawnObject)

function UPP.PlayerSpawnSENT(ply, ent)
	if not ply:IsSuperAdmin() then
		UPP.NotifyPlayers(UPP.Messages.NoSENTsAllowed, ply)
		return false
	end
end
hook.Add("PlayerSpawnSENT", "UPP.PlayerSpawnSENT", UPP.PlayerSpawnSENT)

function UPP.PlayerSpawnRagdoll(ply, ent)
	if not ply:IsSuperAdmin() then
		UPP.NotifyPlayers(UPP.Messages.NoRagdollsAllowed, ply)
		return false
	end
end
hook.Add("PlayerSpawnRagdoll", "UPP.PlayerSpawnRagdoll", UPP.PlayerSpawnRagdoll)

function UPP.PlayerSpawnEffect(ply, ent)
	if not ply:IsSuperAdmin() then
		UPP.NotifyPlayers(UPP.Messages.NoEffectsAllowed, ply)
		return false
	end
end
hook.Add("PlayerSpawnEffect", "UPP.PlayerSpawnEffect", UPP.PlayerSpawnEffect)

function UPP.PlayerSpawnSWEP(ply, ent)
	if not ply:IsSuperAdmin() then
		UPP.NotifyPlayers(UPP.Messages.NoSWEPsAllowed, ply)
		return false
	end
end
hook.Add("PlayerSpawnSWEP", "UPP.PlayerSpawnSWEP", UPP.PlayerSpawnSWEP)

function UPP.PlayerSpawnNPC(ply, ent)
	if not ply:IsSuperAdmin() then
		UPP.NotifyPlayers(UPP.Messages.NoNPCsAllowed, ply)
		return false
	end
end
hook.Add("PlayerSpawnNPC", "UPP.PlayerSpawnNPC", UPP.PlayerSpawnNPC)

function UPP.PlayerSpawnVehicle(ply, ent)
	if not ply:IsSuperAdmin() then
		UPP.NotifyPlayers(UPP.Messages.NoVehiclesAllowed, ply)
		return false
	end
end
hook.Add("PlayerSpawnVehicle", "UPP.PlayerSpawnVehicle", UPP.PlayerSpawnVehicle)


-- Props awaiting cleanup
UPP.OrphanedProps = {}

function UPP.PlayerDisconnected(ply)
	-- Find all the player's props and queue them for deletion

	local sid64 = ply:SteamID64()

	if UPP.PropTimeout == 0 then
		-- Delete props now.
		for _, p in pairs(ents.GetAll()) do
			if p:GetNWEntity("c_ent") == ply and
				(
					UPP.IsANormalProp(p) or
					p:IsRagdoll() or
					p:IsVehicle() or
					p:IsNPC() or
					(UPP.IsConsideredASENT(p) and not p.NoRemoveOnCleanup)
				) then	
					p:Remove()
			end
                end
		print("UPP: Props deleted for player with SteamID64: " .. sid64)
	else
		-- Delete props later (unless a reconnect cancels the process)
		UPP.OrphanedProps[sid64] = {}
		for _, p in pairs(ents.GetAll()) do
			if p:GetNWEntity("c_ent") == ply and
				(
					UPP.IsANormalProp(p) or
					p:IsRagdoll() or
					p:IsVehicle() or
					p:IsNPC() or
					(UPP.IsConsideredASENT(p) and not p.NoRemoveOnCleanup)
				) then
					table.insert(UPP.OrphanedProps[sid64], p)
			end
		end
		-- Start a timer which, if the player is not present when it is up, will delete the props discovered above.
		timer.Create("dct" .. sid64, UPP.PropTimeout * 60, 1, function()
			for _, v in pairs(UPP.OrphanedProps[sid64]) do
				if IsValid(v) then
					v:Remove()
				end
			end
			print("UPP: Props deleted for player with SteamID64: " .. sid64)
			timer.Remove("dct" .. sid64)
		end)
	end
end
hook.Add("PlayerDisconnected", "UPP.PlayerDisconnected", UPP.PlayerDisconnected)

function UPP.PlayerInitialSpawn(ply)
	local sid64 = ply:SteamID64()

	-- If there is a prop disconnect timer for this player, cancel it.
	if timer.Exists("dct" .. sid64) then
		timer.Remove("dct" .. sid64)

		-- Reassign props from the last session to the reconnected player
		for _, v in pairs(UPP.OrphanedProps[sid64]) do
			v:SetNWString("creator", ply:Name())
			v:SetNWEntity("c_ent", ply)
		end

		-- Remove props from the deletion queue.
		UPP.OrphanedProps[sid64] = nil
		print("UPP: Props were not deleted for player: " .. sid64 .. ".")
	end
end
hook.Add("PlayerInitialSpawn", "UPP.PlayerInitialSpawn", UPP.PlayerInitialSpawn)

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

	-- Note that ragdolls are not permitted to be picked up

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

		return class == "prop_physics"
	else
		return false
	end
end

-- Whether this is a SENT
function UPP.IsConsideredASENT(ent)
	return ent.Initialize ~= nil
end

util.AddNetworkString("upp.csr")
util.AddNetworkString("upp.csv")
net.Receive("upp.csr", function(length, sender)
	net.Start("upp.csv")
	net.WriteInt(UPP.PropTimeout, 7)
	net.Send(sender)
end)

util.AddNetworkString("upp.cln_mins")
net.Receive("upp.cln_mins", function(len, sender)
	local mins = net.ReadInt(7)
	if sender:IsAdmin() then
		UPP.UpdatePropTimeout(mins)
	end
end)

-- Delete Props (for specific player)
util.AddNetworkString("upp.dp")
net.Receive("upp.dp", function(len, sender)
	local who = net.ReadEntity()

	if sender:IsAdmin() then
		for _, p in pairs(ents.GetAll()) do
			if p:GetNWEntity("c_ent") == who and (UPP.IsANormalProp(p) or p:IsRagdoll() or p:IsVehicle() or p:IsNPC()) then
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
			if UPP.IsANormalProp(p) or p:IsRagdoll() or p:IsVehicle() or p:IsNPC() then
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
			if p:GetNWEntity("c_ent") == who and UPP.IsConsideredASENT(p) and not p.NoRemoveOnCleanup then
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
			if UPP.IsConsideredASENT(p) and not p.NoRemoveOnCleanup then
				p:Remove()
			end
		end
		UPP.NotifyPlayers(UPP.Messages.AllEntsCleanedUp)
	end
end)

UPP.Initialize()
