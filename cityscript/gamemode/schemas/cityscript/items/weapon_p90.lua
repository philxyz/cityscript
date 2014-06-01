ITEM.Name = "P90";
ITEM.Class = "weapon_p90";
ITEM.GiveClass = "weapon_real_cs_p90";
ITEM.Description = "Sub Machine Gun";
ITEM.Model = "models/weapons/w_smg_p90.mdl";
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