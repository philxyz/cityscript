ITEM.Name = "H&K G3A3 (M9K)";
ITEM.Class = "m9k_g3a3";
ITEM.Description = "Assault Rifle";
ITEM.Model = "models/weapons/w_hk_g3.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 308;
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
