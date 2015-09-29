ITEM.Name = "M29 Satan (M9K)";
ITEM.Class = "m9k_m29satan";
ITEM.Description = "Pistols";
ITEM.Model = "models/weapons/w_m29_satan.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 310;
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
