ITEM.Name = "F2000 (M9K)";
ITEM.Class = "m9k_f2000";
ITEM.Description = "Assault Rifle";
ITEM.Model = "models/weapons/w_fn_f2000.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 300;
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
