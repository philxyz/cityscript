ITEM.Name = "M4A1 Carbine";
ITEM.Class = "weapon_m4a1";
ITEM.GiveClass = "weapon_real_cs_m4a1";
ITEM.Description = "Assault Rifle";
ITEM.Model = "models/weapons/w_rif_m4a1.mdl";
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
