ITEM.Name = "Steyr AUG";
ITEM.Class = "weapon_aug";
ITEM.GiveClass = "weapon_real_cs_aug";
ITEM.Description = "Assault Rifle";
ITEM.Model = "models/weapons/w_rif_aug.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 3;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)
	CAKE.Response(ply, self.Name .. " placed in backpack!")
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:Give(self.GiveClass)
	self:Remove()
end
