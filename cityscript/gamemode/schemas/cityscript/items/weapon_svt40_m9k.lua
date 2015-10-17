ITEM.Name = "SVT 40 (M9K)";
ITEM.Class = "m9k_svt40";
ITEM.Description = "Sniper Rifle";
ITEM.Model = "models/weapons/w_svt_40.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 452;
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
