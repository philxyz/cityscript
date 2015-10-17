ITEM.Name = "IED Detonator (M9K)";
ITEM.Class = "m9k_ied_detonator";
ITEM.Description = "IED Detonator";
ITEM.Model = "models/weapons/w_camphon2.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 1800;
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
