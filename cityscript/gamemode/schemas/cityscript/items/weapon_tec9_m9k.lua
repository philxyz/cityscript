ITEM.Name = "TEC-9 (M9K)";
ITEM.Class = "m9k_tec9";
ITEM.Description = "Sub-Machine Gun";
ITEM.Model = "models/weapons/w_intratec_tec9.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 330;
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
