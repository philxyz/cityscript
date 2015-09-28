ITEM.Name = "M249 (M9K)";
ITEM.Class = "bb_m249_alt";
ITEM.Description = "Machine Gun";
ITEM.Model = "models/weapons/3_mach_m249para.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 780;
ITEM.ItemGroup = 3;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)
	CAKE.Response(ply, self.Name .. " placed in backpack!")
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:Give(self.Class)
	self:Remove()
end
