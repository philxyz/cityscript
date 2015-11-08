ITEM.Name = "Launched-Grenade Ammo (M9K)"
ITEM.Class = "ammo_40mmgrenade_m9k"
ITEM.Description = "Don't forget to reload!"
ITEM.Model = "models/items/boxsrounds.mdl"
ITEM.Purchaseable = true
ITEM.Price = 140
ITEM.ItemGroup = 5

function ITEM:Drop(ply)
end

function ITEM:Pickup(ply)
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:GiveAmmo(1, "40mmGrenade")
	self:Remove()
end
