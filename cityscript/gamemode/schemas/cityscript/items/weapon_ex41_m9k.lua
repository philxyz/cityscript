ITEM.Name = "EX41 (M9K)";
ITEM.Class = "m9k_ex41";
ITEM.Description = "RPG";
ITEM.Model = "models/weapons/w_ex41.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 548;
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
