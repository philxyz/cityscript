ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = TEXT.TokenBundle
ENT.Author = "philxyz"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "amount")
end
