ITEM.Name = "Sarin Gas (M9K)";
ITEM.Class = "m9k_nerve_gas";
ITEM.Description = "Chemical";
ITEM.Model = "models/weapons/w_grenade.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 1950;
ITEM.ItemGroup = 5;
ITEM.IncludeAmmo = true

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
