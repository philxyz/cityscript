ITEM.Name = "Winch. 87 Carbine (M9K)";
ITEM.Class = "m9k_1887winchester";
ITEM.Description = "Shotgun";
ITEM.Model = "models/weapons/w_winchester_1887.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 340;
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
