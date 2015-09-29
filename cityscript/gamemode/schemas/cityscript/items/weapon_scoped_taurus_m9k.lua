ITEM.Name = "Scoped Taurus (M9K)";
ITEM.Class = "m9k_scoped_taurus";
ITEM.Description = "Pistol";
ITEM.Model = "models/weapons/w_raging_bull_scoped.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 210;
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
