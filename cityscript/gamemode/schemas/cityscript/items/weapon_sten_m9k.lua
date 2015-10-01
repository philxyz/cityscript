ITEM.Name = "STEN (M9K)";
ITEM.Class = "m9k_sten";
ITEM.Description = "Sub-Machine Gun";
ITEM.Model = "models/weapons/w_sten.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 348;
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
