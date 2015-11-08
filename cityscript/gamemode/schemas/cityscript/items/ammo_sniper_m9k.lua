ITEM.Name = "Sniper Rifle Ammo (M9K)";
ITEM.Class = "m9k_ammo_sniper_rounds";
ITEM.Description = "Don't forget to reload!";
ITEM.Model = "models/items/sniper_round_box.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 85;
ITEM.ItemGroup = 3;

function ITEM:Drop(ply)
end

function ITEM:Pickup(ply)
	self:Remove();
end

function ITEM:UseItem(ply)
	ply:GiveAmmo(64, "SniperPenetratedRound")
	self:Remove();
end
