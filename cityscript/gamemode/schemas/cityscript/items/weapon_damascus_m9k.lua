ITEM.Name = "Damascus (M9K)";
ITEM.Class = "m9k_damascus";
ITEM.Description = "Sword";
ITEM.Model = "models/weapons/w_damascus_sword.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 750;
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
