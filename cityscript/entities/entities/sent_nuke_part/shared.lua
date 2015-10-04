ENT.Type 			= "anim"
ENT.PrintName			= "CAUTION! Fissile Material"
ENT.Author			= "Teta_Bonita / philxyz"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

function ENT:SetupDataTables()
	self:DTVar("Int", 0, "ownIndex")
end
