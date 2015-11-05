ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = TEXT.StorageBox
ENT.Author = "philxyz"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Damage")
	self:NetworkVar("Bool", 0, "Sparking")
end
