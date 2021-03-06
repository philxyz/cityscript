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
	local vspacing = 20
	local hspacing = 10
	local i = 0

	local vPoint = self:GetPos()

	for _, v in ipairs(self.contents) do

		local horizPos = math.mod(i, 3)
		local y = 0
		if horizPos == 2 then
			y = -1
		elseif horizPos == 0 then
			y = 1
		end

		local z = math.ceil(i / 3)

		CAKE.CreateItem(self.ply, v.itemClass, Vector(vPoint.x, vPoint.y + (y * hspacing), vPoint.z + (z * vspacing)), Angle(0, CAKE.NeedsRotating[v.itemClass] and 90 or 0, 0), v.Clip1, v.Clip2)

		i = i + 1
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

function ENT:RemoveItem(ply, itemNumber)
	local ItemPos = self:GetPos() + Vector(0, 0, 45)

	local idx

	for i, j in ipairs(self.contents) do
		if j and (tonumber(i) == itemNumber) then
			CAKE.CreateItem(ply, j.itemClass, Vector(ItemPos.x + 15, ItemPos.y, ItemPos.z + 15), Angle(0,0,0), j.Clip1, j.Clip2)
			idx = i
			break
		end
	end

	table.remove(self.contents, idx)
end

-- Titles on boxes may only be set once. It's like putting a shipping label on it.
function ENT:SetTitle(title)
	if not self.titleIsSet then
		self.titleIsSet = true
		self:SetNWString("Title", title)
	end
end

function ENT:SpawnItem(ply, itemNumber)
	self:RemoveItem(ply, itemNumber)
	self:SetSparking(false)
	self.locked = false
end

net.Receive("Cs", function(_, ply)
	local entIndex = net.ReadInt(16)
	local itemNumber = net.ReadInt(16)

	s = Entity(entIndex)

	if IsValid(s) and s:GetPos():Distance(ply:GetPos()) > 150 then
		CAKE.Response(ply, TEXT.StandCloserToTheBox)
		return
	end

	s.locked = true
	s:SetSparking(true)
	timer.Simple(2, function() s:SpawnItem(ply, itemNumber) end)
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
	net.Start("C5")
	net.WriteInt(self:EntIndex(), 16)
	net.Send(ply)

	net.Start("C4")
	net.WriteInt(#self.contents, 16)
	for i, j in ipairs(self.contents) do
		local itemtable = CAKE.ItemData[j.itemClass]
		net.WriteInt(self:EntIndex(), 16)
		net.WriteInt(i, 16)
		net.WriteString(j.itemClass)
		net.WriteString(itemtable.Name)
		net.WriteString(itemtable.Model)
	end
	net.Send(ply)

	net.Start("C3")
	net.WriteInt(self:EntIndex(), 16)
	net.Send(ply)

	CAKE.Response(ply, TEXT.OpeningTheBox)
end

function ENT:UseItem(ply)
	if self.locked then return end

	local entshere = ents.FindInSphere(self:GetPos(), 100)

	for _, v in pairs(entshere) do
		if v ~= self and v.Class and not v.VehicleClass and (not v.GetClass or (v.GetClass and (v:GetClass() ~= "spawned_shipment" and v:GetClass() ~= "storage_box" and v:GetClass() ~= "atm" and v:GetClass() ~= "meteor"))) then
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
