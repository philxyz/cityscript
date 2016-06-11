ITEM.Name = "Chinese Takeout"
ITEM.Class = "chinese"
ITEM.Description = "You probably shouldn't eat this."
ITEM.Model = "models/props_junk/garbage_takeoutcarton001a.mdl"
ITEM.Purchaseable = true
ITEM.Price = 6
ITEM.ItemGroup = 2

function ITEM:Drop(ply)
end

function ITEM:Pickup(ply)
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:ConCommand("say " .. TEXT.SlashMeCommand  .. " eats some chinese food and feels sick")
	
	local function KillThem()
		if math.random(1, 5) == 1 then
			ply:ConCommand("say " .. TEXT.SlashMeCommand .. " throws up and passes out")
			ply:Kill()
		end
	end
	
	timer.Simple(30, KillThem)
	
	self:Remove()
end
