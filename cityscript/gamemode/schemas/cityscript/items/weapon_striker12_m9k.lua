ITEM.Name = "Striker 12 (M9K)";
ITEM.Class = "m9k_striker12";
ITEM.Description = "12-bore Shotgun";
ITEM.Model = "models/weapons/w_striker_12g.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 558;
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
