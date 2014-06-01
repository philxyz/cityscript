ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = TEXT.Shipment
ENT.Author = "philxyz"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:DTVar("Int", 0, "ownIndex")
	self:DTVar("Int", 1, "count")
	self:DTVar("Int", 2, "damage")
	self:DTVar("Float", 0, "itemWt")
	self:DTVar("Bool", 0, "sparking")
end
