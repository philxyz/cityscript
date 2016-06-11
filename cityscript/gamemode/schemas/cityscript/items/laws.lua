ITEM.Name = "Book of The Law"
ITEM.Class = "laws"
ITEM.Description = "Ignorance of it is no defense."
ITEM.Model = "models/props_lab/binderblue.mdl"
ITEM.Purchaseable = true
ITEM.Price = 5
ITEM.ItemGroup = 2

function ITEM:Drop(ply)
end

function ITEM:Pickup(ply)
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:ConCommand("say " .. TEXT.SlashMeCommand .. " reads some of the book: \"Book of The Law\"")
end
