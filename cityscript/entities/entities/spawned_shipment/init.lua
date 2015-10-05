-- ========================
-- =          Crate SENT by Mahalis
-- ========================

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Items/item_item_crate.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetNWBool("shipment", true)
	self.locked = false
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then phys:Wake() end
	self.dt.damage = 100
	self:SetNWString("Owner", "Shared")
end

function ENT:OnTakeDamage(dmg)
	self.dt.damage = self.dt.damage - dmg:GetDamage()
	if not self.destroyed and self.dt.damage <= 0 then
		self:Destruct()
	end
end

function ENT:SetContents(s, c, w)
	self:SetNWString("contents", s)
	self.dt.count = c
	if w and w > 0 then
		local phys = self:GetPhysicsObject()
		if phys and phys:IsValid() then phys:SetMass(math.floor((((w * c) + 15)*100)+0.5)/100) end
	end
	self.dt.itemWt = w
end

function ENT:UseItem()
	if not self.locked then
		self.locked = true -- One activation per second
		self.dt.sparking = true
		timer.Create(self:EntIndex() .. "crate", 1, 1, function() self:SpawnItem() end)
	end
end

function ENT:Drop(ply)
	
end

function ENT:Pickup(ply)
	CAKE.Response(ply, "This item can't be picked up")
	return false -- Abort the pickup!
end

function ENT:SpawnItem()
	if not IsValid(self) then
		return false
	end

	timer.Destroy(self:EntIndex() .. "crate")
	self.dt.sparking = false
	local count = self.dt.count
	local pos = self:GetPos()
	if count <= 1 then self:Remove() end
	local owner = self.dt.ownIndex
	owner = player.GetByID(owner)
	CAKE.CreateItem(owner, self:GetNWString("contents"), pos + Vector(0, 0, 35), Angle(0,0,0))
	self.dt.count = count - 1
	local newmass = math.floor((((count*self.dt.itemWt) + 15) * 100) + 0.5) / 100
	if newmass and newmass > 0 then
		local phys = self:GetPhysicsObject()
		if phys and phys:IsValid() then phys:SetMass(newmass) end
	end
	self.locked = false
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

function ENT:Destruct()
	self.destroyed = true

	local vPoint = self:GetPos()
	local contents = self:GetNWString("contents")
	local count = self.dt.count
	self:Remove()

	local owner = self.dt.ownIndex
	owner = player.GetByID(owner)
	
	for i=1, count, 1 do
		CAKE.CreateItem(owner, self:GetNWString("contents"), Vector(vPoint.x, vPoint.y, vPoint.z + (i*10)), Angle(0,0,0))
	end
end
