ITEM.Name = "Jar o' Funny Powder Rocks";
ITEM.Class = "funnypowder";
ITEM.Description = "Head asplode!";
ITEM.Model = "models/props_lab/jar01a.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 50;
ITEM.ItemGroup = 5;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	CAKE.ToxicPlayer(ply, 1);
	ply:SetHealth(math.Clamp(ply:Health() - 18, 0, ply:MaxHealth()));
	self:Remove();

end
