ITEM.Name = "Banana";
ITEM.Class = "banana";
ITEM.Description = "Yellow, bent and fruitful.";
ITEM.Model = "models/props/cs_italy/bananna.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 3;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:ConCommand("say /me eats a banana");
	ply:SetHealth(math.Clamp(ply:Health() + 12, 0, ply:MaxHealth()));
	self:Remove();

end
