ITEM.Name = "Russian Water";
ITEM.Class = "rwater";
ITEM.Description = "Stay of this, kids!";
ITEM.Model = "models/props_junk/glassjug01.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 50;
ITEM.ItemGroup = 5;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	CAKE.ToxicPlayer(ply, 2);
	ply:ConCommand("say /me necks some vodka");
	ply:SetHealth(math.Clamp(ply:Health() - 15, 0, ply:MaxHealth()));
	self:Remove();

end
