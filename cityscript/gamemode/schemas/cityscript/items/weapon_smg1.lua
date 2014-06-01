ITEM.Name = "Combine-Issue SMG1";
ITEM.Class = "weapon_smg1";
ITEM.Description = "Rapid-fire submachine gun.";
ITEM.Model = "models/weapons/w_smg1.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 350;
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
