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

-- Weapons can't be reloaded unless ammo was available at the point
-- the weapon was last switched-to (Gmod bug?).
--
-- A version of GiveAmmo which re-enables weapon-reloading while restocking
-- ammo for a currently selected weapon that was originally selected while no ammo
-- of that type was available.
function meta:GiveAmmo_ReloadFix(amount, typ, hidePopup)
	local wep = self:GetActiveWeapon()

	local paType = wep:GetPrimaryAmmoType()
	local paName = game.GetAmmoName(paType)

	local saType = wep:GetSecondaryAmmoType()
	local saName = game.GetAmmoName(saType)

	-- Determine whether we need to switch the player's weapon away and back
	-- so as to re-enable reloads of the weapon.
	local switchRequired = (paName ~= nil and paName:lower() == typ:lower() and self:GetAmmoCount(paType) == 0) or (saName ~= nil and saName:lower() == typ:lower() and self:GetAmmoCount(saType) == 0)

	-- Call the original GiveAmmo implementation
	self:GiveAmmo(amount, typ, hidePopup)

	if switchRequired then
		self:SelectWeapon("hands") -- Gamemode specific. This can be anything that all players have by default.
		self:SelectWeapon(wep:GetClass())
	end
end

function CAKE.FormatCharString(ply)
	return ply:SteamID() .. "-" .. ply:SteamID64() .. "-" .. tostring(ply:GetNWInt("uid"))
end

function CAKE.ResendCharData(ply) -- Network all of the player's character data
	local SteamID64 = ply:SteamID64()

	if CAKE.PlayerData[SteamID64].characters[ply:GetNWInt("uid")] == nil then
		return
	end

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
