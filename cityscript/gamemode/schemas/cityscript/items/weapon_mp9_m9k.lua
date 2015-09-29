ITEM.Name = "MP9 (M9K)";
ITEM.Class = "m9k_mp9";
ITEM.Description = "Sub-Machine Gun";
ITEM.Model = "models/weapons/w_brugger_thomet_mp9.mdl";
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
