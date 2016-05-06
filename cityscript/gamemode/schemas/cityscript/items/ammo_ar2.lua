ITEM.Name = "AR2 Ammo";
ITEM.Class = "ammo_ar2";
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
	ply:GiveAmmo_ReloadFix(100, "ar2")
	self:Remove();
end
