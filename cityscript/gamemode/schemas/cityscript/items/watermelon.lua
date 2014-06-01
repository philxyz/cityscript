ITEM.Name = "Watermelon";
ITEM.Class = "watermelon";
ITEM.Description = "OM NOM NOM NOM...";
ITEM.Model = "models/props_junk/watermelon01.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 10;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:ConCommand("/me eats a watermelon");
	ply:SetHealth(math.Clamp(ply:Health() + 15, 0, ply:MaxHealth()));
	self:Remove();

end
