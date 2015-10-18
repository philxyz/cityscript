AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/token_banknote.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()

	if phys and phys:IsValid() then
		phys:Wake()
	end

	self:GetTable().MoneyBag = true
	self:Setamount(0)
end

function ENT:Pickup(ply)
	CAKE.Response(ply, TEXT.SelectUseItemToPickUpTokens)
	return false
end

function ENT:UseItem(ply)
	CAKE.ChangeMoney( ply,  self:Getamount());
	ply:ConCommand("say " .. TEXT.MePocketsABundleOfTokens(self:Getamount()));
	self:Remove();
end

function ENT:Touch( hitEnt )
   
end
