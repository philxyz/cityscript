ITEM.Name = "M134 Minigun (M9K)";
ITEM.Class = "m9k_minigun";
ITEM.Description = "Machine Gun";
ITEM.Model = "models/weapons/w_m134_minigun.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 410;
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
