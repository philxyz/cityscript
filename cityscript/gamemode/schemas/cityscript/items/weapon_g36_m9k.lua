ITEM.Name = "H&K G36C (M9K)";
ITEM.Class = "m9k_g36";
ITEM.Description = "Assault Rifle";
ITEM.Model = "models/weapons/w_hk_g36c.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 310;
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
