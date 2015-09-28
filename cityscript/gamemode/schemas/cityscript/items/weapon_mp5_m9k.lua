ITEM.Name = "MP5 (M9K)";
ITEM.Class = "bb_mp5_alt";
ITEM.Description = "Sub-Machine Gun";
ITEM.Model = "models/weapons/3_smg_mp5.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 295;
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
