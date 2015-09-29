ITEM.Name = "MP5SD (M9K)";
ITEM.Class = "m9k_mp5sd";
ITEM.Description = "Sub-Machine Gun";
ITEM.Model = "models/weapons/3_smg_mp5.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 315;
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
