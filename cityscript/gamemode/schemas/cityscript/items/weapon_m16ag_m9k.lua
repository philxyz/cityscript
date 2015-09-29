ITEM.Name = "M16A4 ACOG (M9K)";
ITEM.Class = "m9k_m16a4_acog";
ITEM.Description = "Assault Rifle";
ITEM.Model = "models/weapons/w_dmg_m16ag.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 345;
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
