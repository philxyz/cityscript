ITEM.Name = "RPG Ammo"
ITEM.Class = "ammo_rpg"
ITEM.Description = "Don't forget to reload!"
ITEM.Model = "models/weapons/w_missile_closed.mdl"
ITEM.Purchaseable = true
ITEM.Price = 40
ITEM.ItemGroup = 5

function ITEM:Drop(ply)
end

function ITEM:Pickup(ply)
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:GiveAmmo(1, "RPG_Round")
	self:Remove()
end
