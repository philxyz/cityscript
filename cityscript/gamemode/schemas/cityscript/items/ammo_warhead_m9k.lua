ITEM.Name = "Nuclear Warhead (M9K)"
ITEM.Class = "item_rpg_round"
ITEM.Description = "Level-it."
ITEM.Model = "models/weapons/w_missile_closed.mdl"
ITEM.Purchaseable = true
ITEM.Price = 60000
ITEM.ItemGroup = 5

function ITEM:Drop(ply)
end

function ITEM:Pickup(ply)
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:GiveAmmo_ReloadFix(1, "Nuclear_Warhead")
	self:Remove()
end
