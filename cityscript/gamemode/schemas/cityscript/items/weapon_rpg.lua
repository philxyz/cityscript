ITEM.Name = "Rocket Launcher";
ITEM.Class = "weapon_rpg";
ITEM.Description = "Aim away from face.";
ITEM.Model = "models/weapons/w_rocket_launcher.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 800;
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
