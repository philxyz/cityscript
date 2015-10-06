ITEM.Name = "H&K SL8 (M9K)";
ITEM.Class = "m9k_sl8";
ITEM.Description = "Sniper Rifle";
ITEM.Model = "models/weapons/w_hk_sl8.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 330;
ITEM.ItemGroup = 6;

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
