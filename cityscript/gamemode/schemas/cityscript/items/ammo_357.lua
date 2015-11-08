ITEM.Name = ".357 Ammo";
ITEM.Class = "ammo_357";
ITEM.Description = "Don't forget to reload!";
ITEM.Model = "models/items/357ammo.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 55;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)
end

function ITEM:Pickup(ply)
	self:Remove();
end

function ITEM:UseItem(ply)
	ply:GiveAmmo(48, "357")
	self:Remove();
end
