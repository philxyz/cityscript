ITEM.Name = "Remington 7615P (M9K)";
ITEM.Class = "m9k_remington7615p";
ITEM.Description = "Sniper Rifle";
ITEM.Model = "models/weapons/w_remington_7615p.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 670;
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
