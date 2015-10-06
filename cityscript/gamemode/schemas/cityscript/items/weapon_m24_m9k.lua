ITEM.Name = "M24 (M9K)";
ITEM.Class = "m9k_m24";
ITEM.Description = "Sniper Rifle";
ITEM.Model = "models/weapons/w_snip_m24_6.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 338;
ITEM.ItemGroup = 6;

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
