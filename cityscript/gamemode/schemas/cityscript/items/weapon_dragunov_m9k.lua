ITEM.Name = "SVD Dragunov (M9K)";
ITEM.Class = "m9k_dragunov";
ITEM.Description = "Sniper Rifle";
ITEM.Model = "models/weapons/w_svd_dragunov.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 680;
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
