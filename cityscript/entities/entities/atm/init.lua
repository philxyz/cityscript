-- ATM by philxyz. Requested by 101kl
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_lab/hevplate.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self:SetNWBool("ATM", true)
	self:SetNWString("Owner", "World")
	self:SetColor(Color(0, 255, 0, 255))
	self.frozen = false
end

-- Freeze the physics so it can't move
function ENT:GoToSleep()
	self:SetMoveType(MOVETYPE_NONE)
	self.frozen = true
end

function ENT:OnTakeDamage(dmg)
end

function ENT:UseItem(ply)
	umsg.Start("_atm_use_menu", ply)
	umsg.End()
end

function ENT:Pickup(ply)
	CAKE.Response(ply, TEXT.Weakling)
	return false
end

function ENT:Drop()
end

function ENT:Touch( hitEnt )
end
