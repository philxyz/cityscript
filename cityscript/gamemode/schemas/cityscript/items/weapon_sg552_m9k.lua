ITEM.Name = "SG552 (M9K)";
ITEM.Class = "bb_sg552_alt";
ITEM.Description = "Assault Rifle";
ITEM.Model = "models/weapons/3_rif_sg552.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 400;
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
