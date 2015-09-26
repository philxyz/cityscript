ITEM.Name = "Rifle Ammo";
ITEM.Class = "ammo_rifle";
ITEM.Description = "Use wisely!";
ITEM.Model = "models/items/BoxSRounds.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 3;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)
	ply:GiveAmmo(20, "smg1")
	self:Remove();
end
