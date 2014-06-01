ITEM.Name = "M249 Para";
ITEM.Class = "weapon_m249";
ITEM.GiveClass = "weapon_real_cs_m249";
ITEM.Description = "Machine Gun";
ITEM.Model = "models/weapons/w_mach_m249para.mdl";
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
