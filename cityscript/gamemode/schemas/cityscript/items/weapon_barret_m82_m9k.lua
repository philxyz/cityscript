ITEM.Name = "Barret M82 (M9K)";
ITEM.Class = "m9k_barret_m82";
ITEM.Description = "Sniper Rifle";
ITEM.Model = "models/weapons/w_acc_int_aw50.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 635;
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
