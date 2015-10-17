ITEM.Name = "Milkor Mk1 (M9K)";
ITEM.Class = "m9k_milkormgl";
ITEM.Description = "Grenade Launcher";
ITEM.Model = "models/weapons/w_GDCW_MATADOR_RL.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 958;
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
