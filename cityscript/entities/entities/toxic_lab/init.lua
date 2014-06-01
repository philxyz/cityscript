AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_mine01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then phys:Wake() end
	self.dt.sparking = false
	self.dt.damage = 100
	self:SetNWString("Owner", "Shared")
end

function ENT:OnTakeDamage(dmg)
	self.dt.damage = self.dt.damage - dmg:GetDamage()
	if self.dt.damage <= 0 then
		self:Destruct()
		self:Remove()
	end
end

function ENT:GiveMoney()
	local ownIndex = self.dt.ownIndex
	if ownIndex == 0 then return end

	local ply = player.GetByID(ownIndex)
	if IsValid(ply) then
		if ply:Alive() and not ply:GetTable().Arrested then
			CAKE.ChangeMoney(ply,  45);
			CAKE.Response(ply, TEXT.PaidForSellingToxics)
		end
	end
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
end

function ENT:Activation(user)
	if not self.locked then
		self.locked = true

		self.dt.sparking = true
		timer.Simple(1, function() self:CreateToxic() end)
	end
end

function ENT:CreateToxic(user)
	if tonumber(CAKE.GetCharField( user, "money" )) < 45 then
		CAKE.Response(user, TEXT.TooPoorForToxics)
		return
	end
	local ownIndex = self.dt.ownIndex
	if ownIndex == 0 then return end

	local owner = player.GetByID(ownIndex)

	local toxicPos = self:GetPos()
	toxic = ents.Create("toxic")
	toxic:SetPos(Vector(toxicPos.x, toxicPos.y, toxicPos.z + 10))
	toxic.dt.ownIndex = user:EntIndex()
	toxic:Spawn()
	if user == owner then
		CAKE.Response(user, TEXT.FreeToxicsForYou)
	else
		CAKE.ChangeMoney(user, -45)
		CAKE.ChangeMoney(owner, 45)
		CAKE.Response(user, TEXT.BoughtToxics)
		CAKE.Response(owner, TEXT.SoldToxics)
	end
	self.dt.sparking = false
	self.locked = false
end

function ENT:Pickup(ply)
	CAKE.Response(ply, TEXT.ToxicCongrats)
	self:Remove()
end

function ENT:DropItem(ply)
	self.dt.ownIndex = ply:EntIndex()
end

function ENT:UseItem(ply)
	self:Activation(ply)
end

function ENT:Think()
	if self.dt.sparking then
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetMagnitude(1)
		effectdata:SetScale(1)
		effectdata:SetRadius(2)
		util.Effect("Sparks", effectdata)
	end
end
