ITEM.Name = "AI AW50 (M9K)";
ITEM.Class = "m9k_aw50";
ITEM.Description = "Sniper Rifle";
ITEM.Model = "models/weapons/w_acc_int_aw50.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 475;
ITEM.ItemGroup = 5;

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
