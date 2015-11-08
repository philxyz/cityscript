ITEM.Name = "Smoke Grenade (M9K)";
ITEM.Class = "bb_css_smoke_alt";
ITEM.Description = "Provides momentary cover";
ITEM.Model = "models/weapons/w_eq_smokegrenade_thrown.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 180;
ITEM.ItemGroup = 3;
ITEM.IncludeAmmo = true

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)
	CAKE.Response(ply, self.Name .. " placed in backpack!")
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:Give("bb_css_smoke_alt")
	self:Remove()
end
