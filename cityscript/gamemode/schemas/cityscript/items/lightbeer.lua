ITEM.Name = "Light Beer";
ITEM.Class = "lightbeer";
ITEM.Description = "Just for a buzz.";
ITEM.Model = "models/props_junk/garbage_glassbottle003a.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 8;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	CAKE.ToxicPlayer(ply, 5);
	ply:ConCommand("say " .. TEXT.SlashMeCommand .. " drinks some light beer");
	ply:SetHealth(math.Clamp(ply:Health() - 2, 0, ply:MaxHealth()));
	self:Remove();

end
