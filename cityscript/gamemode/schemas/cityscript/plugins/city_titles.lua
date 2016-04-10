PLUGIN.Name = "Title Setting Code" -- What is the plugin name
PLUGIN.Author = "philxyz" -- Author of the plugin
PLUGIN.Description = "A set of title-related chat commands" -- The description or purpose of the plugin

local function SetTitle(ply, args)
	local trace = ply:GetEyeTrace()

	if IsValid(trace.Entity) and ply:GetPos():Distance(trace.Entity:GetPos()) < 200 then
		if CAKE.IsDoor(trace.Entity) then
			local hasBeenSet = false

			if ply:IsSuperAdmin() then
				if trace.Entity:GetNWBool("nonRentable") then
					DB.StoreNonRentableDoorTitle(trace.Entity, args)
					hasBeenSet = true
				elseif trace.Entity:GetNWBool("pmOnly") then
					DB.StoreRestrictedDoorTitle(trace.Entity, args)
					hasBeenSet = true
				end
			else
				if trace.Entity:GetNWBool("nonRentable") or trace.Entity:GetNWBool("pmOnly") then
					CAKE.Response(ply, TEXT.SuperAdminOnly)
					return ""
				end
			end

			if not hasBeenSet and trace.Entity:GetNWInt("rby") == ply:EntIndex() then
				trace.Entity:SetNWString("dTitle", args)
				CAKE.Response(ply, TEXT.DoorTitleChanged)
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
