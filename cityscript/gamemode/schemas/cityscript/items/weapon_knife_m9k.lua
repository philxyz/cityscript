ITEM.Name = "Knife (M9K)";
ITEM.Class = "bb_css_knife_alt";
ITEM.Description = "Knife";
ITEM.Model = "models/weapons/3_knife_t.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 50;
ITEM.ItemGroup = 3;
ITEM.IncludeAmmo = true

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)
	CAKE.Response(ply, self.Name .. " placed in backpack!")
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:Give("bb_css_knife_alt")
	self:Remove()
end
