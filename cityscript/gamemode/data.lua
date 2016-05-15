include("static_data.lua")

function DB.Init()
	sql.Begin()
		sql.Query("CREATE TABLE IF NOT EXISTS cityscript_players('steamid64' TEXT NOT NULL, 'proptrust' INTEGER NOT NULL, 'extraragdolls' INTEGER NOT NULL, 'tooltrust' INTEGER NOT NULL, 'gravtrust' INTEGER NOT NULL, 'phystrust' INTEGER NOT NULL, 'extraeffects' INTEGER NOT NULL, 'extravehicles' INTEGER NOT NULL, 'extraprops' INTEGER NOT NULL, 'showhelppopup' INTEGER NOT NULL, PRIMARY KEY('steamid64'));")
		sql.Query("CREATE TABLE IF NOT EXISTS cityscript_player_characters('steamid64' TEXT NOT NULL, 'name' TEXT NOT NULL, 'model' TEXT NOT NULL, 'bank' INTEGER NOT NULL, 'money' INTEGER NOT NULL, 'inventory' TEXT NOT NULL, 'flags' TEXT NOT NULL);")
		sql.Query("CREATE TABLE IF NOT EXISTS cityscript_jailpositions('map' TEXT NOT NULL, 'x' NUMERIC NOT NULL, 'y' NUMERIC NOT NULL, 'z' NUMERIC NOT NULL, 'lastused' NUMERIC NOT NULL, PRIMARY KEY('map', 'x', 'y', 'z'));")
		sql.Query("CREATE TABLE IF NOT EXISTS cityscript_wiseguys('steam' TEXT NOT NULL, 'time' NUMERIC NOT NULL, PRIMARY KEY('steam'));")
		sql.Query("CREATE TABLE IF NOT EXISTS cityscript_disableddoors('map' TEXT NOT NULL, 'idx' INTEGER NOT NULL, 'title' TEXT NOT NULL, PRIMARY KEY('map', 'idx'));")
		sql.Query("CREATE TABLE IF NOT EXISTS cityscript_restricteddoors('map' TEXT NOT NULL, 'idx' INTEGER NOT NULL, 'title' TEXT NOT NULL, PRIMARY KEY('map', 'idx'));")
		sql.Query("CREATE TABLE IF NOT EXISTS cityscript_teamspawns('id' INTEGER NOT NULL, 'map' TEXT NOT NULL, 'team' INTEGER NOT NULL, 'x' NUMERIC NOT NULL, 'y' NUMERIC NOT NULL, 'z' NUMERIC NOT NULL, PRIMARY KEY('id'));")
		sql.Query("CREATE TABLE IF NOT EXISTS cityscript_atmpositions('id' INTEGER NOT NULL, 'map' TEXT NOT NULL, 'x' NUMERIC NOT NULL, 'y' NUMERIC NOT NULL, 'z' NUMERIC NOT NULL, 'a' NUMERIC NOT NULL, 'b' NUMERIC NOT NULL, 'c' NUMERIC NOT NULL, PRIMARY KEY('id'));")
		sql.Query("CREATE TABLE IF NOT EXISTS cityscript_zombiespawns('map' TEXT NOT NULL, 'x' NUMERIC NOT NULL, 'y' NUMERIC NOT NULL, 'z' NUMERIC NOT NULL);")
		sql.Query("CREATE TABLE IF NOT EXISTS cityscript_soundabusers('steamid64' TEXT NOT NULL);")
		sql.Query("CREATE TABLE IF NOT EXISTS cityscript_log('when' DATETIME DEFAULT CURRENT_TIMESTAMP, 'section' TEXT NOT NULL, 'message' TEXT NOT NULL);")
		sql.Query("CREATE TABLE IF NOT EXISTS cityscript_time('day' INTEGER NOT NULL, 'month' INTEGER NOT NULL, 'year' INTEGER NOT NULL, 'minutes' INTEGER NOT NULL);")
	sql.Commit()
end

function DB.LogEvent(section, text)
	sql.Query("INSERT INTO cityscript_log('section', 'message') VALUES(" .. sql.SQLStr(section) .. ", " .. sql.SQLStr(text) .. ");")
	local err = sql.LastError()
	if err ~= nil then
		print("SQL ERROR in DB.LogEvent: " .. err)
	end
end

function DB.InitRPTime(d, m, y, s)
	sql.Query("INSERT INTO cityscript_time('day', 'month', 'year', 'minutes') VALUES(" .. tostring(d) .. ", " .. tostring(m) .. ", " .. tostring(y) .. ", " .. tostring(s) .. ");")
	local err = sql.LastError()
	if err ~= nil then
		print("SQL ERROR in DB.InitRPTime")
	end
end

function DB.GetRPTime()
	local res = sql.Query("SELECT day, month, year, minutes FROM cityscript_time;")

	if not res then
		return nil
	else
		local err = sql.LastError()
		if err ~= nil then
			print("SQL ERROR in DB.GetRPTime")
		end

		local result = {}
		local iterCheck = false

		for _, r in ipairs(res) do
			result.day = r.day
			result.month = r.month
			result.year = r.year
			result.minutes = r.minutes

			return result -- Exit function
		end
	end
end

function DB.SaveRPTime(d, m, y, mins)
	sql.Query("UPDATE cityscript_time SET day = " .. tostring(d) .. ", month = " .. tostring(m) .. ", year = " .. tostring(y) .. ", minutes = " .. tostring(mins) .. ";")
	local err = sql.LastError()
	if err ~= nil then
		print("SQL ERROR in DB.SaveRPTime")
	end
end

function DB.CreateJailPos()
	if not jail_positions then return end
	local map = string.lower(game.GetMap())

	sql.Begin()
		sql.Query("DELETE FROM cityscript_jailpositions;")
		for k, v in pairs(jail_positions) do
			if map == string.lower(v[1]) then
				sql.Query("INSERT INTO cityscript_jailpositions VALUES(" .. sql.SQLStr(map) .. ", " .. v[2] .. ", " .. v[3] .. ", " .. v[4] .. ", " .. 0 .. ");")
			end
		end
	sql.Commit()
end

function DB.StoreJailPos(ply, addingPos)
	local map = string.lower(game.GetMap())
	local pos = string.Explode(" ", tostring(ply:GetPos()))
	local already = tonumber(sql.QueryValue("SELECT COUNT(*) FROM cityscript_jailpositions WHERE map = " .. sql.SQLStr(map) .. ";"))
	if not already or already == 0 then
		sql.Query("INSERT INTO cityscript_jailpositions VALUES(" .. sql.SQLStr(map) .. ", " .. pos[1] .. ", " .. pos[2] .. ", " .. pos[3] .. ", " .. 0 .. ");")
		CAKE.Response(ply, TEXT.FirstJailPosCreated)
	else
		if addingPos then
			sql.Query("INSERT INTO cityscript_jailpositions VALUES(" .. sql.SQLStr(map) .. ", " .. pos[1] .. ", " .. pos[2] .. ", " .. pos[3] .. ", " .. 0 .. ");")
			CAKE.Response(ply, TEXT.ExtraJailPosCreated)
		else
			sql.Begin()
			sql.Query("DELETE FROM cityscript_jailpositions WHERE map = " .. sql.SQLStr(map) .. ";")
			sql.Query("INSERT INTO cityscript_jailpositions VALUES(" .. sql.SQLStr(map) .. ", " .. pos[1] .. ", " .. pos[2] .. ", " .. pos[3] .. ", " .. 0 .. ");")
			sql.Commit()
			CAKE.Response(ply, TEXT.RemovedAllCreatedNew)
		end
	end
end

function DB.RetrieveJailPos()
	local map = string.lower(game.GetMap())
	local r = sql.Query("SELECT x, y, z, lastused FROM cityscript_jailpositions WHERE map = " .. sql.SQLStr(map) .. ";")
	if not r then return false end

	-- Retrieve the least recently used jail position
	local now = CurTime()
	local oldest = 0
	local ret = nil

	for _, row in pairs(r) do
		if (now - tonumber(row.lastused)) > oldest then
			oldest = (now - tonumber(row.lastused))
			ret = row
		end
	end

	-- Mark that position as having been used just now
	sql.Query("UPDATE cityscript_jailpositions SET lastused = " .. CurTime() .. " WHERE map = " .. sql.SQLStr(map) .. " AND x = " .. ret.x .. " AND y = " .. ret.y .. " AND z = " .. ret.z .. ";")

	return Vector(ret.x, ret.y, ret.z)
end

function DB.CountJailPos()
	return tonumber(sql.QueryValue("SELECT COUNT(*) FROM cityscript_jailpositions WHERE map = " .. sql.SQLStr(string.lower(game.GetMap())) .. ";"))
end

function DB.StoreJailStatus(ply, time)
	local steamID = ply:SteamID()
	-- Is there an existing outstanding jail sentence for this player?
	local r = tonumber(sql.QueryValue("SELECT time FROM cityscript_wiseguys WHERE steam = " .. sql.SQLStr(steamID) .. ";"))


	if not r and time ~= 0 then
		-- If there is no jail record for this player and we're not trying to clear an existing one
		sql.Query("INSERT INTO cityscript_wiseguys VALUES(" .. sql.SQLStr(steamID) .. ", " .. time .. ");")
	else
		-- There is a jail record for this player
		if time == 0 then
			-- If we are reducing their jail time to zero, delete their record
			sql.Query("DELETE FROM cityscript_wiseguys WHERE steam = " .. sql.SQLStr(steamID) .. ";")
		else
			-- Increase this player's sentence by the amount specified
			sql.Query("UPDATE cityscript_wiseguys SET time = " .. r + time .. " WHERE steam = " .. sql.SQLStr(steamID) .. ");")
		end
	end
end

function DB.RetrieveJailStatus(ply)
	-- How much time does this player owe in jail?
	local r = tonumber(sql.QueryValue("SELECT time FROM cityscript_wiseguys WHERE steam = " .. sql.SQLStr(ply:SteamID()) .. ";"))
	if r then
		return r
	else
		return 0
	end
end

function DB.AddTeamSpawnPos(t, pos)
	local map = string.lower(game.GetMap())
	sql.Query("INSERT INTO cityscript_teamspawns VALUES(NULL, " .. sql.SQLStr(map) .. ", " .. t .. ", " .. pos[1] .. ", " .. pos[2] .. ", " .. pos[3] .. ");")
end

function DB.RemoveTeamSpawns(t)
	local map = string.lower(game.GetMap())
	sql.Query("DELETE FROM cityscript_teamspawns WHERE team = "..t..";")
end

function DB.RetrieveTeamSpawnPos(ply)
	local map = string.lower(game.GetMap())
	local t = ply:Team()

	-- this should return a map name.
	local r = sql.Query("SELECT * FROM cityscript_teamspawns WHERE team = " .. t .. " AND map = ".. sql.SQLStr(map)..";")
	if not r or #r < 1 then return nil end

	local returnal = {}

	for k,v in pairs(r) do
		table.insert(returnal, Vector(v.x, v.y, v.z))
	end
	return returnal
end

function DB.StoreDoorRentability(ent)
	local map = string.lower(game.GetMap())
	local nonRentable = ent:GetNWBool("nonRentable")
	local r = tonumber(sql.QueryValue("SELECT COUNT(1) FROM cityscript_disableddoors WHERE map = " .. sql.SQLStr(map) .. " AND idx = " .. ent:GetGlobalID() .. ";"))
	if not r then return end

	if r > 0 and not nonRentable then
		sql.Query("DELETE FROM cityscript_disableddoors WHERE map = " .. sql.SQLStr(map) .. " AND idx = " .. ent:GetGlobalID() .. ";")
		ent:SetNWString("dTitle", "")
	elseif r == 0 and nonRentable then
		sql.Query("INSERT INTO cityscript_disableddoors VALUES(" .. sql.SQLStr(map) .. ", " .. ent:GetGlobalID() .. ", " .. sql.SQLStr(TEXT.NonRentableDoor) .. ");")
		ent:SetNWString("dTitle", TEXT.NonRentableDoor)
	end
end

function DB.StoreDoorRestriction(ent)
	local map = string.lower(game.GetMap())
	local pmOnly = ent:GetNWBool("pmOnly")
	local r = tonumber(sql.QueryValue("SELECT COUNT(1) FROM cityscript_restricteddoors WHERE map = " .. sql.SQLStr(map) .. " AND idx = " .. ent:GetGlobalID() .. ";"))
	if not r then return end

	if r > 0 and not pmOnly then
		sql.Query("DELETE FROM cityscript_restricteddoors WHERE map = " .. sql.SQLStr(map) .. " AND idx = " .. ent:GetGlobalID() .. ";")
		ent:SetNWString("dTitle", "")
	elseif r == 0 and pmOnly then
		sql.Query("INSERT INTO cityscript_restricteddoors VALUES(" .. sql.SQLStr(map) .. ", " .. ent:GetGlobalID() .. ", " .. sql.SQLStr(TEXT.RestrictedArea) .. ");")
		ent:SetNWString("dTitle", TEXT.RestrictedArea)
	end
end

function DB.StoreNonRentableDoorTitle(ent, text)
	text = text .. "\n" .. TEXT.NonRentableDoor
	sql.Query("UPDATE cityscript_disableddoors SET title = " .. sql.SQLStr(text) .. " WHERE map = " .. sql.SQLStr(string.lower(game.GetMap())) .. " AND idx = " .. ent:GetGlobalID() .. ";")
	ent:SetNWString("dTitle", text)
end

function DB.StoreRestrictedDoorTitle(ent, text)
	text = text .. "\n" .. TEXT.RestrictedArea
	sql.Query("UPDATE cityscript_restricteddoors SET title = " .. sql.SQLStr(text) .. " WHERE map = " .. sql.SQLStr(string.lower(game.GetMap())) .. " AND idx = " .. ent:GetGlobalID() .. ";")
	ent:SetNWString("dTitle", text)
end

function DB.SetUpNonRentableDoors()
	local r = sql.Query("SELECT idx, title FROM cityscript_disableddoors WHERE map = " .. sql.SQLStr(string.lower(game.GetMap())) .. ";")
	if not r then return end

	for _, row in pairs(r) do
		local e = ents.GetByGlobalID(tonumber(row.idx))
		e:SetNWBool("nonRentable", true)
		e:SetNWString("dTitle", row.title)
	end
end

function DB.SetUpRestrictedAreaDoors()
	local r = sql.Query("SELECT idx, title FROM cityscript_restricteddoors WHERE map = " .. sql.SQLStr(string.lower(game.GetMap())) .. ";")
	if not r then return end

	for _, row in pairs(r) do
		local e = ents.GetByGlobalID(tonumber(row.idx))
		e:SetNWBool("pmOnly", true)
		e:SetNWString("dTitle", row.title)
	end
end

function DB.NewATM(ent)
	local pos = ent:GetPos()
	local ang = ent:GetAngles()
	sql.Query("INSERT INTO cityscript_atmpositions VALUES(NULL, " .. sql.SQLStr(string.lower(game.GetMap())) .. ", " .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. ", " .. ang.p .. ", " .. ang.y .. ", " .. ang.r .. ");")
	local r = sql.Query("SELECT * FROM cityscript_atmpositions WHERE map = " .. sql.SQLStr(string.lower(game.GetMap())) .. ";")

	local highest = -1
	for _, row in pairs(r) do
		if tonumber(row.id) > highest then highest = tonumber(row.id) end
	end

	return highest -- (id of the most recently added atm for this map)
end

function DB.RemoveATM(ent)
	local id = ent.ATMID
	sql.Query("DELETE FROM cityscript_atmpositions WHERE id = " .. tostring(id) .. ";")
	ent:Remove()
end

function DB.InstallATMs()
	local r = sql.Query("SELECT * FROM cityscript_atmpositions WHERE map = " .. sql.SQLStr(string.lower(game.GetMap())) .. ";")
	if not r then return end

	-- For each ATM in the database for this map, install them
	for _, row in pairs(r) do
		if not row.x then
			for a, b in pairs(r) do
				print("key: " .. a .. " = value: " .. b)
			end

			return
		end

		local atm = ents.Create("atm")
		atm:SetPos(Vector(row.x, row.y, row.z))
		atm:SetAngles(Angle(tonumber(row.a), tonumber(row.b), tonumber(row.c)))
		atm:SetNWString("Owner", "World")
		atm:Spawn()
		atm:GoToSleep()
		atm.ATMID = row.id
	end
end

function DB.StoreZombies()
	local map = string.lower(game.GetMap())
	sql.Begin()
	sql.Query("DELETE FROM cityscript_zombiespawns WHERE map = " .. sql.SQLStr(map) .. ";")

	for k, v in pairs(zombieSpawns) do
		local s = string.Explode(" ", v)
		sql.Query("INSERT INTO cityscript_zombiespawns VALUES(" .. sql.SQLStr(map) .. ", " .. s[1] .. ", " .. s[2] .. ", " .. s[3] .. ");")
	end
	sql.Commit()
end

function DB.RetrieveZombies()
	zombieSpawns = {}
	local r = sql.Query("SELECT * FROM cityscript_zombiespawns WHERE map = " .. sql.SQLStr(string.lower(game.GetMap())) .. ";")
	if not r then return end
	for map, row in pairs(r) do
		zombieSpawns[map] = tostring(row.x) .. " " .. tostring(row.y) .. " " .. tostring(row.z)
	end
end

function DB.DropZombies()
	zombieSpawns = {}
	sql.Query("DELETE FROM cityscript_zombiespawns WHERE map = " .. sql.SQLStr(string.lower(game.GetMap())) .. ";")
end

function DB.FetchQuietPlayers()
	local r = sql.Query("SELECT steamid64 FROM cityscript_soundabusers;")
	if not r then return end
	for _, id in pairs(r) do
		table.insert(CAKE.QuietPlayers, id.steamid64)
	end
end

function DB.AllowSounds(s64, allow)
	if allow then
		sql.Query("DELETE FROM cityscript_soundabusers WHERE steamid64 = " .. sql.SQLStr(s64) .. ";")
	else
		local r = sql.Query("SELECT 1 FROM cityscript_soundabusers WHERE steamid64 = " .. sql.SQLStr(s64) .. ";")
		if not r then
			sql.Query("INSERT INTO cityscript_soundabusers(steamid64) VALUES(" .. sql.SQLStr(s64) .. ");")
		end
	end
end

local function IsEmpty(vector)
	local point = util.PointContents(vector)
	local a = point ~= CONTENTS_SOLID
	and point ~= CONTENTS_MOVEABLE
	and point ~= CONTENTS_LADDER
	and point ~= CONTENTS_PLAYERCLIP
	and point ~= CONTENTS_MONSTERCLIP
	local b = true

	for k,v in pairs(ents.FindInSphere(vector, 35)) do
		if v:IsNPC() or v:IsPlayer() or v:GetClass() == "prop_physics" then
			b = false
		end
	end
	return a and b
end

function DB.RetrieveRandomZombieSpawnPos()
	local map = string.lower(game.GetMap())
	local r = false
	local c = tonumber(sql.QueryValue("SELECT COUNT(*) FROM cityscript_zombiespawns WHERE map = " .. sql.SQLStr(map) .. ";"))

	if c and c >= 1 then
		r = sql.QueryRow("SELECT * FROM cityscript_zombiespawns WHERE map = " .. sql.SQLStr(map) .. ";", math.random(1, c))
        if not IsEmpty(Vector(r.x, r.y, r.z)) then
			local found = false
			for i = 40, 200, 10 do
				if IsEmpty(Vector(r.x, r.y, r.z) + Vector(i, 0, 0)) then
					found = true
					return Vector(r.x, r.y, r.z) + Vector(i, 0, 0)
				end
			end

			if not found then
				for i = 40, 200, 10 do
					if IsEmpty(Vector(r.x, r.y, r.z) + Vector(0, i, 0)) then
						found = true
						return Vector(r.x, r.y, r.z) + Vector(0, i, 0)
					end
				end
			end

			if not found then
				for i = 40, 200, 10 do
					if IsEmpty(Vector(r.x, r.y, r.z) + Vector(-i, 0, 0)) then
						found = true
						return Vector(r.x, r.y, r.z) + Vector(-i, 0, 0)
					end
				end
			end

			if not found then
				for i = 40, 200, 10 do
					if IsEmpty(Vector(r.x, r.y, r.z) + Vector(0, -i, 0)) then
						found = true
						return Vector(r.x, r.y, r.z) + Vector(0, -i, 0)
					end
				end
			end
		else
			return Vector(r.x, r.y, r.z)
		end
	end
	return Vector(r.x, r.y, r.z) + Vector(0, 0, 70)
end

-- Gets the player data table into memory. If there isn't one, make one.
function DB.LoadPlayerData(ply)
	local SteamID64 = ply:SteamID64()

	CAKE.PlayerData[SteamID64] = {}

	local rs = sql.Query("SELECT proptrust, extraragdolls, tooltrust, gravtrust, phystrust, extraeffects, extravehicles, extraprops, showhelppopup FROM cityscript_players WHERE steamid64 = " .. sql.SQLStr(SteamID64) .. ";")

	-- If an entry exists for this user
	if rs then
		CAKE.CallHook("LoadPlayerData", ply)

		DB.LogEvent("script", TEXT.LoadingPlayerDataFor .. " SteamID64: " .. SteamID64)

		-- Insert the table into the data table
		CAKE.PlayerData[SteamID64] = rs

		-- Retrieve the data table for easier access
		local PlayerTable = CAKE.PlayerData[SteamID64]
		CAKE.PlayerData[SteamID64].characters = {}
		local CharTable = CAKE.PlayerData[SteamID64].characters

		-- Retrieve the player's characters
		local chars = sql.Query("SELECT name, model, bank, money, inventory, flags FROM cityscript_player_characters WHERE steamid64 = " .. sql.SQLStr(SteamID64) .. ";")
		if chars then
			for k, v in ipairs(chars) do
				v.inventory = util.JSONToTable(v.inventory) or {}
				CharTable[k] = v
				print("NAME: " .. tostring(v.name))
			end
		end

		CAKE.CallHook("LoadedPlayerData", ply, Data_Table)
	else
		-- Seems they don't have a player table. Let's create a default
		-- one for them with an empty character table.
		DB.LogEvent("script", TEXT.CreatingNewPlayerDataFor .. " " .. SteamID64)

		local cv = CAKE.ConVars -- For convenience.

		CAKE.PlayerData[SteamID64] = {
			proptrust = cv.Default_Proptrust,
			tooltrust = cv.Default_Tooltrust,
			gravtrust = cv.Default_Gravtrust,
			phystrust = cv.Default_Phystrust,
			extraragdolls = cv.Default_Extraragdolls,
			extraeffects = cv.Default_Extraeffects,
			extravehicles = cv.Default_Extravehicles,
			extraprops = cv.Default_Extraprops,
			showhelppopup = true, -- Always true at first
			characters = {}
		}

		-- We won't make a character, obviously. That is done later.
		DB.PersistPlayerData(ply)

		-- Technically, we didn't load it, but the necessary structure
		-- now exists.
		CAKE.CallHook("LoadedPlayerData", ply, Data_Table)
	end
end

function DB.PersistPlayerData(ply)
	local SteamID64 = ply:SteamID64()
	local toSave = CAKE.PlayerData[SteamID64]
	local cv = CAKE.ConVars -- For convenience.
	local err = nil

	local exists = sql.Query("SELECT 1 FROM cityscript_players WHERE steamid64 = " .. sql.SQLStr(ply:SteamID64()) .. ";")
	if exists then
		sql.Query("UPDATE cityscript_players SET proptrust = " .. tostring(toSave.proptrust or cv.Default_Proptrust) ..
			", extraragdolls = " .. tostring(toSave.extraragdolls or cv.Default_Extraragdolls) ..
			", tooltrust = " .. tostring(toSave.tooltrust or cv.Default_Tooltrust) ..
			", gravtrust = " .. tostring(toSave.gravtrust or cv.Default_Gravtrust) ..
			", phystrust = " .. tostring(toSave.phystrust or cv.Default_Phystrust) ..
			", extraeffects = " .. tostring(toSave.extraeffects or cv.Default_Extraeffects) ..
			", extravehicles = " .. tostring(toSave.extravehicles or cv.Default_Extravehicles) ..
			", extraprops = " .. tostring(toSave.extraprops or cv.Default_Extraprops) ..
			", showhelppopup = " .. (toSave.showhelppopup and "1" or "0") ..
			" WHERE steamid64 = " .. sql.SQLStr(SteamID64) .. ";")

		err = sql.LastError()
		if err ~= nil then
			print("SQL ERROR in DB.PersistPlayerData 1: " .. err)
		end
	else
		-- Insert
		sql.Query("INSERT INTO cityscript_players(steamid64, proptrust, extraragdolls, tooltrust, gravtrust, phystrust, extraeffects, extravehicles, extraprops, showhelppopup) " ..
			"VALUES(" .. sql.SQLStr(SteamID64) .. ", " ..
				tostring(cv.Default_Proptrust) .. ", " ..
				tostring(cv.Default_Extraragdolls) .. ", " ..
				tostring(cv.Default_Tooltrust) .. ", " ..
				tostring(cv.Default_Gravtrust) .. ", " ..
				tostring(cv.Default_Phystrust) .. ", " ..
				tostring(cv.Default_Extraeffects) .. ", " ..
				tostring(cv.Default_Extravehicles) .. ", " ..
				tostring(cv.Default_Extraprops) .. ", " ..
				"1" ..
				");")
		err = sql.LastError()
		if err ~= nil then
			print("SQL ERROR in DB.PersistPlayerData 2: " .. err)
		end
	end

	-- Drop any existing characters and recreate them
	sql.Query("DELETE FROM cityscript_player_characters WHERE steamid64 = " .. sql.SQLStr(SteamID64) .. ";")
	err = sql.LastError()
	if err ~= nil then
		print("SQL ERROR in DB.PersistPlayerData 3:" .. err)
	end

	for _, v in ipairs(toSave.characters) do
		sql.Query("INSERT INTO cityscript_player_characters(steamid64, name, model, bank, money, inventory, flags) VALUES(" ..
			sql.SQLStr(SteamID64) .. ", " ..
			sql.SQLStr(v.name or "Set Your Name") .. ", " ..
			sql.SQLStr(v.model or "models/player/group01/male_07.mdl") .. ", " ..
			tostring(v.bank or 0) .. ", " ..
			tostring(v.money or 0) .. ", " ..
			sql.SQLStr(util.TableToJSON(v.inventory or {})) .. ", " ..
			sql.SQLStr(v.flags or "") ..
		");")

		err = sql.LastError()
		if err ~= nil then
			print("SQL ERROR in DB.PersistPlayerData 4:" .. err)
		end
	end

	-- deal with util.TableToJSON(inventory)





	--[[
	CAKE.AddDataField(1, "characters", {})
	CAKE.AddDataField(1, "showhelppopup", 1) -- Whether or not to show the initial help box

	-- These fields are what would be the default value, and it also allows the field to actually EXIST.
	-- If there is a field in the data and it isn't added, it will automatically be removed.

	-- Character Fields
	CAKE.AddDataField(2, "name", "Set Your Name") -- Let's hope this never gets used.
	CAKE.AddDataField(2, "model", "models/player/group01/male_07.mdl")
	CAKE.AddDataField(2, "money", CAKE.ConVars.Default_Money) -- How much money do players start out with.
	CAKE.AddDataField(2, "bank", CAKE.ConVars.Default_Bank) -- How much bank money do players start out with.
	CAKE.AddDataField(2, "inventory", CAKE.ConVars.Default_Inventory) -- What inventory do they start with

	]]
end

DB.Init()
