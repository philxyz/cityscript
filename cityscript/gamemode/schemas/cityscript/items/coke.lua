ITEM.Name = "Coke";
ITEM.Class = "coke";
ITEM.Description = "Can of cold Coke";
ITEM.Model = "models/props_junk/PopCan01a.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 3;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:ConCommand("say /me drinks a refreshing Coke.");
	ply:SetHealth(math.Clamp(ply:Health() - 2, 0, ply:MaxHealth()));
	self:Remove();

end
