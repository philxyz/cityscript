ITEM.Name = "Colt Python (M9K)";
ITEM.Class = "m9k_coltpython";
ITEM.Description = "Pistol";
ITEM.Model = "models/weapons/w_colt_python.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 200;
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
