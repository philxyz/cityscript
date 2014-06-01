ITEM.Name = "Refried Beans";
ITEM.Class = "beans";
ITEM.Description = "It expired a month ago..";
ITEM.Model = "models/props_junk/garbage_metalcan001a.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 3;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:ConCommand("say /me eats some refried beans");
	ply:SetHealth(math.Clamp(ply:Health() - 6, 0, ply:MaxHealth()));
	self:Remove();

end
