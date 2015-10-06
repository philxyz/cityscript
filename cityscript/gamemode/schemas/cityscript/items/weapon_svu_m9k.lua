ITEM.Name = "Dragunov SVU (M9K)";
ITEM.Class = "m9k_svu";
ITEM.Description = "Sniper Rifle";
ITEM.Model = "models/weapons/w_dragunov_svu.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 692;
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
