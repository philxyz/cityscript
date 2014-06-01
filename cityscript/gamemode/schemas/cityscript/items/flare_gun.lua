ITEM.Name = "Flare Gun";
ITEM.Class = "flare_gun";
ITEM.Description = "A flare gun to call for help.";
ITEM.Model = "models/weapons/W_pistol.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 5;
ITEM.ItemGroup = 3;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:Give("gmod_rp_flare");
	self:Remove();

end
