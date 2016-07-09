-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- player_data.lua
-- Handles player data and such.
-------------------------------

-- Define the table of player information.
CAKE.PlayerData = {}

local meta = FindMetaTable("Player")

function CAKE.FormatCharString(ply)
	return ply:SteamID() .. "-" .. ply:SteamID64() .. "-" .. tostring(ply:GetNWInt("uid"))
end

function CAKE.ResendCharData(ply) -- Network all of the player's character data
	local SteamID64 = ply:SteamID64()

	for fieldname, data in pairs(CAKE.PlayerData[SteamID64].characters[ply:GetNWInt("uid")]) do
		if type(data) ~= "table" then
			ply:SetNWString(fieldname, tostring(data))
		end
	end
end

function CAKE.SetPlayerField(ply, fieldname, data)
	CAKE.PlayerData[ply:SteamID64()][fieldname] = data
	DB.PersistPlayerData(ply)
end

function CAKE.GetPlayerField(ply, fieldname)
	return CAKE.PlayerData[ply:SteamID64()][fieldname]
end

function CAKE.SetCharField(ply, fieldname, data)
	if CAKE.PlayerData[ply:SteamID64()].characters[ply:GetNWInt("uid")] ~= nil then
		CAKE.PlayerData[ply:SteamID64()].characters[ply:GetNWInt("uid")][fieldname] = data
		DB.PersistPlayerData(ply)
	end
end

function CAKE.GetCharField(ply, fieldname)
	if CAKE.PlayerData[ply:SteamID64()].characters[ply:GetNWInt("uid")] == nil then
		return nil
	else
		return CAKE.PlayerData[ply:SteamID64()].characters[ply:GetNWInt("uid")][fieldname]
	end
end
