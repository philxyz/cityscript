ITEM.Name = "Sticky Grenade (M9K)";
ITEM.Class = "m9k_sticky_grenade";
ITEM.Description = "Grenade";
ITEM.Model = "models/weapons/w_sticky_grenade.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 355;
ITEM.ItemGroup = 5;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)
	CAKE.Response(ply, self.Name .. " placed in backpack!")
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:Give(self.Class)
	self:Remove()
end
