ITEM.Name = "Pistol Ammo"
ITEM.Class = "ammo_pistol"
ITEM.Description = "Don't forget to reload!"
ITEM.Model = "models/items/boxbuckshot.mdl"
ITEM.Purchaseable = true
ITEM.Price = 20
ITEM.ItemGroup = 2

function ITEM:Drop(ply)
end

function ITEM:Pickup(ply)
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:GiveAmmo_ReloadFix(60, "Pistol")
	self:Remove()
end
