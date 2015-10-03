ITEM.Name = "Winch. 97 Carbine (M9K)";
ITEM.Class = "m9k_1897winchester";
ITEM.Description = "Shotgun";
ITEM.Model = "models/weapons/w_winchester_1897_trench.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 348;
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
