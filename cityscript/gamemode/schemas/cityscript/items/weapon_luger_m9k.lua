ITEM.Name = "P08 Luger (M9K)";
ITEM.Class = "m9k_luger";
ITEM.Description = "Pistols";
ITEM.Model = "models/weapons/w_luger_p08.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 130;
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
