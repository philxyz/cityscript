ITEM.Name = "Orange";
ITEM.Class = "orange";
ITEM.Description = "Fruit.";
ITEM.Model = "models/props/cs_italy/orange.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 1;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:SetHealth(math.Clamp(ply:Health() + 8, 0, ply:MaxHealth()));
	ply:ConCommand("say /me eats a healthy orange");
	self:Remove();

end
