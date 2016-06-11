ITEM.Name = "Two-Liter Soda";
ITEM.Class = "sodatwoliter";
ITEM.Description = "Lots of soda.";
ITEM.Model = "models/props_junk/garbage_plasticbottle003a.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 5;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:ConCommand("say " .. TEXT.SlashMeCommand .. " drinks a lot of soda");
	ply:SetHealth(math.Clamp(ply:Health() - 5, 0, ply:MaxHealth()));
	self:Remove();

end
