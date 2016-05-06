ITEM.Name = "Orbital Strike Order"
ITEM.Class = "ammo_orbital_strike_order"
ITEM.Description = "Don't forget to reload!"
ITEM.Model = "models/props_lab/clipboard.mdl"
ITEM.Purchaseable = true
ITEM.Price = 12000
ITEM.ItemGroup = 5

function ITEM:Drop(ply)
end

function ITEM:Pickup(ply)
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:GiveAmmo_ReloadFix(1, "SatCannon")
	self:Remove()
end
