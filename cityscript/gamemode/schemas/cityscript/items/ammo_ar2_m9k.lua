ITEM.Name = "AR2 Ammo (M9K)";
ITEM.Class = "m9k_ammo_ar2";
ITEM.Description = "Don't forget to reload!";
ITEM.Model = "models/items/boxmrounds.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 60;
ITEM.ItemGroup = 3;

function ITEM:Drop(ply)
end

function ITEM:Pickup(ply)
	self:Remove();
end

function ITEM:UseItem(ply)
	ply:GiveAmmo(100, "ar2")
	self:Remove();
end
