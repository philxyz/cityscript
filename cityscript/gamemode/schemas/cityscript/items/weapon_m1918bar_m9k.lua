ITEM.Name = "M1918 BAR (M9K)";
ITEM.Class = "m9k_m1918bar";
ITEM.Description = "Machine Gun";
ITEM.Model = "models/weapons/w_m1918_bar.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 372;
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
