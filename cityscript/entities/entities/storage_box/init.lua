-- Storage Box by philxyz. Requested by 101kl
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/cardboard_box001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self.contents = {}
	self:SetNWBool("storage_box", true)
	self.dt.sparking = false
	self.dt.damage = 100
	self:SetNWString("Owner", "Shared")
	self:SetNWString("Title", TEXT.UseTitleToLabel)
	self.locked = false
end

function ENT:OnTakeDamage(dmg)
	self.dt.damage = self.dt.damage - dmg:GetDamage()
	if self.dt.damage <= 0 then
		self:Destruct()
		self:Remove()
	end
end

function ENT:Destruct()
	local i = 0
	for k, v in ipairs(self.contents) do
		CAKE.CreateItem(self.ply, v, self:GetPos() + Vector(0, 0, 25 + i), Angle(0,0,0))
		i = i + 10
	end
end

function ENT:AddItem(ply, itemClass)
	if #self.contents < 16 then
		for k, v in pairs(CAKE.ItemData) do
			if v.Class == itemClass then
				self.contents[#self.contents + 1] = itemClass
				CAKE.Response(ply, TEXT.AnnouncePlacedInBox(v.Name))
				return true
			end
		end
	else
		CAKE.Response(ply, TEXT.BoxFull)
		self:OpenMenu(ply)
		return false
	end
end

function ENT:RemoveItem(ply, item)
	local ItemPos = self:GetPos() + Vector(0, 0, 25)

	for i, j in ipairs(self.contents) do
		if j and j == item then
			CAKE.CreateItem(ply, item, Vector(ItemPos.x + 15, ItemPos.y, ItemPos.z + 15), Angle(0,0,0))
			table.remove(self.contents, i)
			return
		end
	end
end

function ENT:SetTitle(title)
	self:SetNWString("Title", title)
end

function ENT:SpawnItem(ply, cmd, args)
	self:RemoveItem(ply, args[1])
	self.dt.sparking = false
	self.locked = false
end

concommand.Add("drrp_storage_box_spawn", function(ply, cmd, args)
	c = args[1]
	eI = tonumber(args[2])

	s = Entity(eI)

	if s:GetPos():Distance(ply:GetPos()) > 150 then
		CAKE.Response(ply, TEXT.StandCloserToTheBox)
		return
	end

	s.locked = true
	s.dt.sparking = true
	timer.Simple(2, function() s:SpawnItem(ply, cmd, args) end)
end)

function ENT:Think()
	if not self.dt.sparking then return end

	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetMagnitude(1)
	effectdata:SetScale(1)
	effectdata:SetRadius(2)
	util.Effect("Sparks", effectdata)
end

function ENT:OpenMenu(ply)
	umsg.Start("_storage_box_reset", ply)
		umsg.Short(self:EntIndex())
	umsg.End()

	for i, j in ipairs(self.contents) do
		local itemtable = CAKE.ItemData[j]
		umsg.Start("_storage_box_icon", ply)
			umsg.Short(self:EntIndex())
			umsg.Short(i)
			umsg.String(j)
			umsg.String(itemtable.Name)
			umsg.String(itemtable.Model)
		umsg.End()
	end
	umsg.Start("_storage_box_open", ply)
		umsg.Short(self:EntIndex())
	umsg.End()
	CAKE.Response(ply, TEXT.OpeningTheBox)
end

function ENT:UseItem(ply)
	if self.locked then return end

	-- If there is nothing near the box
	local entshere = ents.FindInSphere(self:GetPos(), 100)

	for k, v in pairs(entshere) do
		if v ~= self and v.Class and v.Class ~= "storage_box" and not v.VehicleClass then		
			if self:AddItem(ply, v.Class) then
				v:Remove()
			end
			return
		end
	end

	self:OpenMenu(ply)
end

function ENT:Pickup(ply)
	CAKE.Response(ply, TEXT.WontFitInBackpack)
	return false
end

function ENT:Drop()
end

function ENT:Touch( hitEnt )
end
