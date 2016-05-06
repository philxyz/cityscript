ITEM.Name = "SMG Ammo"
ITEM.Class = "ammo_smg"
ITEM.Description = "Don't forget to reload!"
ITEM.Model = "models/items/boxsrounds.mdl"
ITEM.Purchaseable = true
ITEM.Price = 75
ITEM.ItemGroup = 2

function ITEM:Drop(ply)
end

function ITEM:Pickup(ply)
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:GiveAmmo_ReloadFix(148, "smg1")
	self:Remove()
end
