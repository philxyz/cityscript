ITEM.Name = "Barrett M98B (M9K)";
ITEM.Class = "m9k_m98b";
ITEM.Description = "Machine Gun";
ITEM.Model = "models/weapons/w_barrett_m98b.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 705;
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
