ITEM.Name = "Winchester Ammo (M9K)"
ITEM.Class = "m9k_ammo_winchester"
ITEM.Description = "Don't forget to reload!"
ITEM.Model = "models/items/sniper_round_box.mdl"
ITEM.Purchaseable = true
ITEM.Price = 80
ITEM.ItemGroup = 2

function ITEM:Drop(ply)
end

function ITEM:Pickup(ply)
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:GiveAmmo_ReloadFix(100, "AirboatGun")
	self:Remove()
end
