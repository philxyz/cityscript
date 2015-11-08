ITEM.Name = "Buckshot Ammo"
ITEM.Class = "ammo_buckshot"
ITEM.Description = "Don't forget to reload!"
ITEM.Model = "models/items/boxbuckshot.mdl"
ITEM.Purchaseable = false
ITEM.Price = 80
ITEM.ItemGroup = 3

function ITEM:Drop(ply)
end

function ITEM:Pickup(ply)
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:GiveAmmo(72, "buckshot")
	self:Remove()
end
