-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- shared.lua
-- Some shared functions
-------------------------------

include("language.lua")

local DoorTypes =
{

	"func_door",
	"func_door_rotating",
	"prop_door_rotating"

}

function CAKE.IsDoor(door)

	local class = door:GetClass()
	
	for k, v in pairs(DoorTypes) do
		if v == class then return true; end
	end
	
	return false
end

-- Allow referring to entities across server config changes
local mtbl = FindMetaTable("Entity")

function mtbl:GetGlobalID()
	return self:EntIndex() - game.MaxPlayers()
end

function ents.GetByGlobalID(globalId)
	return ents.GetByIndex(globalId + game.MaxPlayers())
end
