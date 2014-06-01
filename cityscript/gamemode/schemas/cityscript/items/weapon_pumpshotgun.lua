ITEM.Name = "M3";
ITEM.Class = "weapon_pumpshotgun";
ITEM.GiveClass = "weapon_real_cs_pumpshotgun";
ITEM.Description = "Pump Shotgun";
ITEM.Model = "models/weapons/w_shot_m3super90.mdl";
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
