ITEM.Name = "Dark Beer";
ITEM.Class = "darkbeer";
ITEM.Description = "Drink till she's semi-pretty again!";
ITEM.Model = "models/props_junk/garbage_glassbottle003a.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 10;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	CAKE.ToxicPlayer(ply, 3);
	ply:ConCommand("say /me drinks some dark beer");
	ply:SetHealth(math.Clamp(ply:Health() - 2, 0, ply:MaxHealth()));
	self:Remove();

end
