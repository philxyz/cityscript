ITEM.Name = "I.E.D (M9K)";
ITEM.Class = "m9k_improvised_explosive";
ITEM.Description = "Free Snacks!";
ITEM.Model = "models/props_junk/cardboard_box004a.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 1580;
ITEM.ItemGroup = 5;

function ITEM:Drop(ply)
end

function ITEM:Pickup(ply)
	self:Remove();
end

function ITEM:UseItem(ply)
	ply:GiveAmmo(1, "Improvised_Explosive")
	self:Remove();
end
