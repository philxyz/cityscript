ITEM.Name = "High Explosive Grenade";
ITEM.Class = "weapon_grenade";
ITEM.GiveClass = "weapon_real_cs_grenade";
ITEM.Description = "Take out a group of enemies!";
ITEM.Model = "models/weapons/w_eq_fraggrenade.mdl";
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
