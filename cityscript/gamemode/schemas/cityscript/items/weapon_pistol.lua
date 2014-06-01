ITEM.Name = "Combine-Issue Pistol";
ITEM.Class = "weapon_pistol";
ITEM.Description = "";
ITEM.Model = "models/weapons/w_pistol.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 200;
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
