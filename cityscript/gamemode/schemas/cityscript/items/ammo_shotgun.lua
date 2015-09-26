ITEM.Name = "Shotgun Ammo";
ITEM.Class = "ammo_shotgun";
ITEM.Description = "You kids get the hell off my lawn!";
ITEM.Model = "models/items/BoxMRounds.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 3;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)
	self:Remove();
end

function ITEM:UseItem(ply)
	ply:GiveAmmo(20, "Buckshot")
	self:Remove();
end
