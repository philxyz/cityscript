ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = TEXT.Toxics
ENT.Author = "Rickster"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:DTVar("Int", 0, "damage")
end
