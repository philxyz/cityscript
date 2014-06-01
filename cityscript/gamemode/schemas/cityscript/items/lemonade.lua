ITEM.Name = "Lemonade";
ITEM.Class = "lemonade";
ITEM.Description = "Fizzy drink.";
ITEM.Model = "models/props_junk/garbage_glassbottle003a.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 8;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)
	self:Remove();
end

function ITEM:UseItem(ply)
	CAKE.ToxicPlayer(ply, 2);
	ply:ConCommand("say /me drinks some lemonade and gets poisoned by Aspartame/Aminosweet and other neurotoxic E-number sweeteners");
	ply:SetHealth(ply:Health() - 10)
	self:Remove();
end
