-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- player_shared.lua
-- This is a shared file that contains functions for the players, of which is loaded on client and server.
-------------------------------

local meta = FindMetaTable("Player")

function meta:CanTraceTo(ent) -- Can the player and the entity "see" eachother?
	local tr = util.TraceLine({
		start = self:EyePos(),
		endpos = ent:EyePos(),
		filter = function(ent) if ent:GetClass() == "prop_physics" then return true end end
	})

	if IsValid(tr.Entity) and tr.Entity:EntIndex() == ent:EntIndex() then return true end

	return false
end

function meta:Nick()
	return self:GetNWString("name")
end

function meta:CalcDrop()
	local pos = self:GetShootPos()
	local ang = self:GetAimVector()

	local trace = util.TraceLine({
		start = pos,
		endpos = pos + (ang * 200),
		filter = function(ent) if ent:GetClass() == "prop_physics" then return true end end
	})

	return trace.HitPos
end
