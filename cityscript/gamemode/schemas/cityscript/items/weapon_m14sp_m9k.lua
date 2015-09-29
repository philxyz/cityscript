ITEM.Name = "M14SP (M9K)";
ITEM.Class = "m9k_m14sp";
ITEM.Description = "Sniper Rifle";
ITEM.Model = "models/weapons/w_snip_m14sp.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 345;
ITEM.ItemGroup = 3;

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
