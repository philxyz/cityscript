-- RRPX Money Printer reworked for CityScript by philxyz
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_c17/consolebox01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self:SetNWBool("money_printer", true)
	self.dt.sparking = false
	self.dt.damage = 100
	self.explosionradius = math.random(20, 200)
	timer.Simple(30, function() self:CreateMoneybag() end)
	self:SetNWString("Owner", "Shared")
end

function ENT:OnTakeDamage(dmg)
	if self.burningup then return end

	self.dt.damage = self.dt.damage - dmg:GetDamage()
	if self.dt.damage <= 0 then
		local rnd = math.random(1, 10)
		if rnd < 3 then
			self:BurstIntoFlames()
		else
			self:Destruct()
			self:Remove()
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

function ENT:BurstIntoFlames()
	self.dt.sparking = false
	self.burningup = true
	local burntime = math.random(8, 18)
	self:Ignite(burntime, 0)
	timer.Simple(burntime, function() self:Fireball() end)
end

function ENT:Fireball()
	self:Destruct()
	for k, v in pairs(ents.FindInSphere(self:GetPos(), self.explosionradius)) do
		if IsFlammable(v) and v:EntIndex() ~= self:EntIndex() then
			v:Ignite(math.random(5, 22), 0)
		end
	end
	self:Remove()
end

local function PrintMore(ent)
	if IsValid(ent) then
		ent.dt.sparking = true
		timer.Simple(3, function() ent:CreateMoneybag() end)
	end
end

function ENT:CreateMoneybag()
	if not IsValid(self) then return end
	local MoneyPos = self:GetPos()

	if math.random(1, 22) == 3 then
		self:BurstIntoFlames()
		return
	end

	local moneybag = ents.Create("token_bundle")
	moneybag:SetPos(Vector(MoneyPos.x + 15, MoneyPos.y, MoneyPos.z + 15))
	moneybag:Spawn()
	moneybag:Setamount(250)

	self.dt.sparking = false
	timer.Simple(math.random(40, 350), function() self:PrintMore() end) -- Print more cash in 40 to 350 seconds
end

function ENT:Think()
	if not self.dt.sparking then return end

	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetMagnitude(1)
	effectdata:SetScale(1)
	effectdata:SetRadius(2)
	util.Effect("Sparks", effectdata)
end

function ENT:UseItem(ply)
	CAKE.Response(ply, TEXT.PrintWhenIAmReady)
end

function ENT:Pickup(ply)
	CAKE.Response(ply, TEXT.WontFitInBackpack)
	return false
end

function ENT:Drop()
end

function ENT:Touch( hitEnt )
   
end
