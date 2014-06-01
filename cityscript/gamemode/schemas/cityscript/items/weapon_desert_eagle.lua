ITEM.Name = "Desert Eagle";
ITEM.Class = "weapon_desert_eagle";
ITEM.GiveClass = "weapon_real_cs_desert_eagle";
ITEM.Description = "Pistol";
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
