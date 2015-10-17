ITEM.Name = "M249 LMG (M9K)";
ITEM.Class = "m9k_m249lmg";
ITEM.Description = "Machine Gun";
ITEM.Model = "models/weapons/w_m249_machine_gun.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 402;
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
