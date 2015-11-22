-- Unobtrusive prop protection by philxyz
-- Server-side code
UPP = {}

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
	ent:SetNWEntity("lf_by", ply)
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
