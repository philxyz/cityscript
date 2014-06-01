AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/glassjug01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()

	if phys and phys:IsValid() then phys:Wake() end

	self.dt.damage = 10

	self:SetNWString("Owner", "Shared")
end

function ENT:OnTakeDamage(dmg)
	self.dt.damage = self.dt.damage - dmg:GetDamage()

	if self.dt.damage <= 0 then
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetMagnitude(2)
		effectdata:SetScale(2)
		effectdata:SetRadius(3)
		util.Effect("Sparks", effectdata)
		self:Remove()
	end
end

function ENT:Pickup(ply)
	self:Remove();
end

function ENT:UseItem(ply)
	CAKE.ToxicPlayer(ply, 1);
	self:Remove();
end
