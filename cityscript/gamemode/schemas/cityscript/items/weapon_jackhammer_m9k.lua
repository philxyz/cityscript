ITEM.Name = "Pancor Jackhammer (M9K)";
ITEM.Class = "m9k_jackhammer";
ITEM.Description = "Shotgun";
ITEM.Model = "models/weapons/w_pancor_jackhammer.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 480;
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
