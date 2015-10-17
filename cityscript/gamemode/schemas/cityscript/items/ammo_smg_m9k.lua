ITEM.Name = "SMG Ammo (M9K)";
ITEM.Class = "m9k_ammo_smg";
ITEM.Description = "Don't forget to reload!";
ITEM.Model = "models/items/boxsrounds.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 85;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)
end

function ITEM:Pickup(ply)
	self:Remove();
end

function ITEM:UseItem(ply)
	ply:GiveAmmo(150, "smg1")
	self:Remove();
end
