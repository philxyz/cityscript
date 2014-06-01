AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.Entity:SetModel("models/props_junk/Rock001a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:Ignite(20,0)
	local phys = self.Entity:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:Wake()
	end

	self.Entity:GetPhysicsObject():EnableMotion(true)
	self.Entity:GetPhysicsObject():SetMass(1000)
	self.Entity:GetPhysicsObject():EnableGravity(false)
end

function ENT:SetTarget(ent)
	local foundSky = util.IsInWorld(ent:GetPos())
	local zPos = ent:GetPos().z

	for a = 1, 30, 1 do
		zPos = zPos + 100
		foundSky = util.IsInWorld(Vector(ent:GetPos().x ,ent:GetPos().y ,zPos))
		if (foundSky == false) then
			zPos = zPos - 120
			break
		end
	end

	self.Entity:SetPos(Vector(ent:GetPos().x + math.random(-4000,4000),ent:GetPos().y + math.random(-4000,4000), zPos))
	local speed = 100000000
	local VNormal = (Vector(ent:GetPos().x + math.random(-500,500),ent:GetPos().y + math.random(-500,500),ent:GetPos().z) - self.Entity:GetPos()):GetNormal()
	self:GetPhysicsObject():ApplyForceCenter(VNormal * speed)
end

function ENT:Destruct(notexplode)
	if not notexplode then
		util.BlastDamage(self.Entity, self.Entity, self.Entity:GetPos(), 200, 60)
	end

	self:Extinguish()
	local vPoint = self.Entity:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
	self.Entity:Remove()
end

function ENT:OnTakeDamage(dmg)
	if (dmg:GetDamage() > 5) then
		self.Entity:Destruct(true)
	end
end

function ENT:PhysicsCollide(data, physobj)
	if data.HitEntity:GetClass() == "func_breakable_surf" then self:Remove() return end
	self.Entity:Destruct()
end
