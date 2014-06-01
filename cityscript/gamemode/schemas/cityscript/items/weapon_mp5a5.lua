ITEM.Name = "MP5A5";
ITEM.Class = "weapon_mp5a5";
ITEM.GiveClass = "weapon_real_cs_mp5a5";
ITEM.Description = "Assault Rifle";
ITEM.Model = "models/weapons/w_smg_mp5.mdl";
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
