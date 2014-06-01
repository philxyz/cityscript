ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = TEXT.ToxicLab
ENT.Author = "Rickster"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:DTVar("Int", 0, "ownIndex")
	self:DTVar("Int", 1, "damage")
	self:DTVar("Bool", 0, "sparking")
end
