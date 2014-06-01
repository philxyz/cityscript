ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = TEXT.TokenPrinter
ENT.Author = "Render Case and philxyz"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:DTVar("Int", 0, "damage")
	self:DTVar("Bool", 0, "sparking")
end
