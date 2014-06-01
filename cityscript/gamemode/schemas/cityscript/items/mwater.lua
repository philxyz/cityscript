ITEM.Name = "Malt \"Water\"";
ITEM.Class = "mwater";
ITEM.Description = "Not a cure for dizziness.";
ITEM.Model = "models/props_junk/glassjug01.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 15;
ITEM.ItemGroup = 5;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	CAKE.ToxicPlayer(ply, 2);
	ply:ConCommand("say /me drinks some malt \"water\"");
	ply:SetHealth(math.Clamp(ply:Health() - 15, 0, ply:MaxHealth()));
	self:Remove();

end
