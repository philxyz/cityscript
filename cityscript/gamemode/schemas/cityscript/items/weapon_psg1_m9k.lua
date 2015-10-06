ITEM.Name = "H&K PSG-1 (M9K)";
ITEM.Class = "m9k_psg1";
ITEM.Description = "Sniper Rifle";
ITEM.Model = "models/weapons/w_hk_psg1.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 800;
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
