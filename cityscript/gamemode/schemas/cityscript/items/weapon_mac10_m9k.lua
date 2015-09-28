ITEM.Name = "Mac 10 (M9K)";
ITEM.Class = "bb_mac10_alt";
ITEM.Description = "Sub-Machine Gun";
ITEM.Model = "models/weapons/3_smg_mac10.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 305;
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
