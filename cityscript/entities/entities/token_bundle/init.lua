AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props/cs_assault/money.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then phys:Wake() end

	self:GetTable().MoneyBag = true
	self:GetTable().Amount = 0
end

function ENT:Pickup(ply)
	CAKE.Response(ply, TEXT.SelectUseItemToPickUpTokens)
	return false
end

function ENT:SetValue(value)
	self:GetTable().Amount = value
end

function ENT:UseItem(ply)
	CAKE.ChangeMoney( ply,  self:GetTable().Amount);
	ply:ConCommand("say " .. TEXT.MePocketsABundleOfTokens);
	self:Remove();
end

function ENT:Touch( hitEnt )
   
end
