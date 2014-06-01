ITEM.Name = "Pistol Ammo";
ITEM.Class = "ammo_pistol";
ITEM.Description = "Don't forget to reload!";
ITEM.Model = "models/Items/BoxBuckshot.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 3;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)
	ply:GiveAmmo(20, "Pistol")
	self:Remove();
end
