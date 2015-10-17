ITEM.Name = "USAS (M9K)";
ITEM.Class = "m9k_usas";
ITEM.Description = "12-Bore Shotgun";
ITEM.Model = "models/weapons/w_usas_12.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 422;
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
