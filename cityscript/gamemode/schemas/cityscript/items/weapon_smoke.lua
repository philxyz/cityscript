ITEM.Name = "Smoke Grenade";
ITEM.Class = "weapon_smoke";
ITEM.GiveClass = "weapon_real_cs_smoke";
ITEM.Description = "Provides momentary cover";
ITEM.Model = "models/weapons/w_eq_smokegrenade.mdl";
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
