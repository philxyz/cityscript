ITEM.Name = "Noodles";
ITEM.Class = "noodles";
ITEM.Description = "Fresh from Asia.";
ITEM.Model = "models/props_junk/garbage_takeoutcarton001a.mdl"
ITEM.Purchaseable = true;
ITEM.Price = 10;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:SetHealth(math.Clamp(ply:Health() + 10, 0, ply:MaxHealth()));
	ply:ConCommand("say /me eats a carton of noodles.");
	self:Remove();

end
