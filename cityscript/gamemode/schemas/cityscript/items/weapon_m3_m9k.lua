ITEM.Name = "M3 (M9K)";
ITEM.Class = "bb_m3_alt";
ITEM.Description = "Shotgun";
ITEM.Model = "models/weapons/3_shot_m3super90.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 185;
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
