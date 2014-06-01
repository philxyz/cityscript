ITEM.Name = "USP";
ITEM.Class = "weapon_usp";
ITEM.GiveClass = "weapon_real_cs_usp";
ITEM.Description = "Pistol";
ITEM.Model = "models/weapons/w_pist_usp.mdl";
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
