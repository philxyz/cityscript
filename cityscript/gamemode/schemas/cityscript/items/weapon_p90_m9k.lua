ITEM.Name = "P90 (M9K)";
ITEM.Class = "bb_p90_alt";
ITEM.Description = "Sub-Machine Gun";
ITEM.Model = "models/weapons/3_smg_p90.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 405;
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
