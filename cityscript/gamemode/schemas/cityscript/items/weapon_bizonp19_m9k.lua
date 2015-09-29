ITEM.Name = "Bizon PP19 (M9K)";
ITEM.Class = "m9k_bizonp19";
ITEM.Description = "Sub-Machine Gun";
ITEM.Model = "models/weapons/w_pp19_bizon.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 365;
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
