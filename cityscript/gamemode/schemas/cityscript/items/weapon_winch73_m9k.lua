ITEM.Name = "Winch. 73 Carbine (M9K)";
ITEM.Class = "m9k_winchester73";
ITEM.Description = "Shotgun";
ITEM.Model = "models/weapons/w_winchester_1873.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 335;
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
