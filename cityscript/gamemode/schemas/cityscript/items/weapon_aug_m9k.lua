ITEM.Name = "Steyr AUG (M9K)";
ITEM.Class = "bb_aug_alt";
ITEM.Description = "Assault Rifle";
ITEM.Model = "models/weapons/3_rif_aug.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 350;
ITEM.ItemGroup = 3;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)
	CAKE.Response(ply, self.Name .. " placed in backpack!")
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:Give("bb_aug_alt")
	self:Remove()
end
