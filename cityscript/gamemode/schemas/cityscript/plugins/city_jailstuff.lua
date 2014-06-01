PLUGIN.Name = "Jail Code from DarkRP"; -- What is the plugin name
PLUGIN.Author = "philxyz"; -- Author of the plugin
PLUGIN.Description = "A set of jail-related chat commands"; -- The description or purpose of the plugin

local JailPos = function(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		DB.StoreJailPos(ply)
	else
		CAKE.Response(ply, TEXT.AdminOnly)
	end
	return ""
end

local AddJailPos = function(ply)
	-- Admin or Chief can add Jail Positions
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		DB.StoreJailPos(ply, true)
	else
		CAKE.Response(ply, TEXT.AdminOnly)
	end
	return ""
end

function PLUGIN.Init()
	CAKE.ChatCommand(TEXT.AddJailPosCommand, JailPos)
	CAKE.ChatCommand(TEXT.AddExtraJailPosCommand, AddJailPos)
end
