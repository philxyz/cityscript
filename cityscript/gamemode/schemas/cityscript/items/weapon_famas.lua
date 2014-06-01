ITEM.Name = "Famas";
ITEM.Class = "weapon_famas";
ITEM.GiveClass = "weapon_real_cs_famas";
ITEM.Description = "Assault Rifle";
ITEM.Model = "models/weapons/w_rif_famas.mdl";
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
