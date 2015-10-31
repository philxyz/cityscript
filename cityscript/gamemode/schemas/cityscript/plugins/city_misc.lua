PLUGIN.Name = "CityScript Misc"; -- What is the pugin name
PLUGIN.Author = "philxyz"; -- Author of the plugin
PLUGIN.Description = "Miscellaneous Functionality" -- The description or purpose of the plugin

-- Remove certain items (toxiclabs, moneyprinters, etc)
local function RemoveItem(ply)
	local trace = ply:GetEyeTrace()
	if IsValid(trace.Entity) then
		if trace.Entity.ATMID then
			if ply:IsAdmin() or ply:IsSuperAdmin() then
				if trace.Entity.frozen then
					DB.RemoveATM(trace.Entity)
					CAKE.Response(ply, TEXT.ATMRemoved)
				end
			else
				CAKE.Response(ply, TEXT.SuperAdminOnly)
			end
		elseif trace.Entity.SID and (trace.Entity.SID == ply.SID) then
			trace.Entity:Remove()
			CAKE.Response(ply, TEXT.ItemRemoved)
		else
			CAKE.Response(ply, TEXT.NothingToRemove)
		end
	end

	return ""
end

function PLUGIN.Init( )
	CAKE.ChatCommand(TEXT.RemoveItemCommand, RemoveItem)	
end
