PLUGIN.Name = "Title Setting Code" -- What is the plugin name
PLUGIN.Author = "philxyz" -- Author of the plugin
PLUGIN.Description = "A set of title-related chat commands" -- The description or purpose of the plugin

local function SetTitle(ply, args)
	local trace = ply:GetEyeTrace()

	if IsValid(trace.Entity) and ply:GetPos():Distance(trace.Entity:GetPos()) < 110 then
		if CAKE.IsDoor(trace.Entity) then
			if ply:IsSuperAdmin() then
				if trace.Entity:GetNWBool("nonRentable") then
					DB.StoreNonRentableDoorTitle(trace.Entity, args)
					return ""
				end
			else
				if trace.Entity:GetNWBool("nonRentable") then
					CAKE.Response(ply, TEXT.SuperAdminOnly)
				end
			end

			if trace.Entity.owner == ply then
				trace.Entity:SetNWString("title", args)
			else
				CAKE.Response(ply, TEXT.NotRenting)
			end
		elseif trace.Entity.Class and trace.Entity.Class == "storage_box" then
			trace.Entity:SetTitle(args)
			CAKE.Response(ply, TEXT.BoxLabelUpdated)
		end
	end

	return ""
end

function PLUGIN.Init()
	CAKE.ChatCommand(TEXT.TitleCommand, SetTitle)
end
