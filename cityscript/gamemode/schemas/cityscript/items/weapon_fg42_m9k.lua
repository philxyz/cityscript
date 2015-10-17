ITEM.Name = "FG 42 (M9K)";
ITEM.Class = "m9k_fg42";
ITEM.Description = "Machine Gun";
ITEM.Model = "models/weapons/w_fg42.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 385;
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
