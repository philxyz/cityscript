ITEM.Name = "UMP45";
ITEM.Class = "weapon_ump_45";
ITEM.GiveClass = "weapon_real_cs_ump_45";
ITEM.Description = "Sub Machine Gun";
ITEM.Model = "models/weapons/w_smg_ump45.mdl";
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
