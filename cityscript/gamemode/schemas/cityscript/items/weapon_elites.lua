ITEM.Name = "Dual Elites";
ITEM.Class = "weapon_elites";
ITEM.GiveClass = "weapon_real_cs_elites";
ITEM.Description = "Pistols";
ITEM.Model = "models/weapons/w_pist_p228.mdl";
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
