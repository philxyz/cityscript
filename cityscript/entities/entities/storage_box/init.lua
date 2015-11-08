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
	self:SetSparking(false)
	self:SetDamage(100)
	self:SetNWString("Title", TEXT.UseTitleToLabel)
	self.locked = false
end

function ENT:OnTakeDamage(dmg)
	self:SetDamage(self:GetDamage() - dmg:GetDamage())
	if self:GetDamage() <= 0 then
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

function ENT:AddItem(ply, itemClass, clip1, clip2)
	if #self.contents < 16 then
		for k, v in pairs(CAKE.ItemData) do
			if v.Class == itemClass then
				self.contents[#self.contents + 1] = {
					itemClass = itemClass,
					Clip1 = clip1 or 0,
					Clip2 = clip2 or 0
				}
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
	local ItemPos = self:GetPos() + Vector(0, 0, 45)

	local idx

	for i, j in ipairs(self.contents) do
		if j and (tonumber(i) == tonumber(item)) then
			CAKE.CreateItem(ply, j.itemClass, Vector(ItemPos.x + 15, ItemPos.y, ItemPos.z + 15), Angle(0,0,0), j.Clip1, j.Clip2)
			idx = i
			break
		end
	end

	table.remove(self.contents, idx)
end

function ENT:SetTitle(title)
	self:SetNWString("Title", title)
end

function ENT:SpawnItem(ply, cmd, args)
	self:RemoveItem(ply, args[2])
	self:SetSparking(false)
	self.locked = false
end

concommand.Add("drrp_storage_box_spawn", function(ply, cmd, args)
	s = Entity(tonumber(args[1]))

	if IsValid(s) and s:GetPos():Distance(ply:GetPos()) > 150 then
		CAKE.Response(ply, TEXT.StandCloserToTheBox)
		return
	end

	s.locked = true
	s:SetSparking(true)
	timer.Simple(2, function() s:SpawnItem(ply, cmd, args) end)
end)

function ENT:Think()
	if not self:GetSparking() then return end

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
		local itemtable = CAKE.ItemData[j.itemClass]
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

	local entshere = ents.FindInSphere(self:GetPos(), 100)

	for _, v in pairs(entshere) do
		if v ~= self and v.Class and not v.VehicleClass and (not v.GetClass or (v.GetClass and v:GetClass() ~= "spawned_shipment")) then
			local clip1 = nil
			local clip2 = nil

			if v:GetNWInt("Clip1A") then
				clip1 = v:GetNWInt("Clip1A") or 0
			end

			if v:GetNWInt("Clip2A") then
				clip2 = v:GetNWInt("Clip2A") or 0
			end

			if self:AddItem(ply, v.Class, clip1, clip2) then
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

function ENT:Touch(hitEnt)
end
