include("static_data.lua")

function DB.Init()
	sql.Begin()
		sql.Query("CREATE TABLE IF NOT EXISTS cityscript_jailpositions('map' TEXT NOT NULL, 'x' NUMERIC NOT NULL, 'y' NUMERIC NOT NULL, 'z' NUMERIC NOT NULL, 'lastused' NUMERIC NOT NULL, PRIMARY KEY('map', 'x', 'y', 'z'));")
		sql.Query("CREATE TABLE IF NOT EXISTS cityscript_wiseguys('steam' TEXT NOT NULL, 'time' NUMERIC NOT NULL, PRIMARY KEY('steam'));")
		sql.Query("CREATE TABLE IF NOT EXISTS cityscript_disableddoors('map' TEXT NOT NULL, 'idx' INTEGER NOT NULL, 'title' TEXT NOT NULL, PRIMARY KEY('map', 'idx'));")
		sql.Query("CREATE TABLE IF NOT EXISTS cityscript_teamspawns('id' INTEGER NOT NULL, 'map' TEXT NOT NULL, 'team' INTEGER NOT NULL, 'x' NUMERIC NOT NULL, 'y' NUMERIC NOT NULL, 'z' NUMERIC NOT NULL, PRIMARY KEY('id'));")
		sql.Query("CREATE TABLE IF NOT EXISTS cityscript_atmpositions('id' INTEGER NOT NULL, 'map' TEXT NOT NULL, 'x' NUMERIC NOT NULL, 'y' NUMERIC NOT NULL, 'z' NUMERIC NOT NULL, 'a' NUMERIC NOT NULL, 'b' NUMERIC NOT NULL, 'c' NUMERIC NOT NULL, PRIMARY KEY('id'));")
		sql.Query("CREATE TABLE IF NOT EXISTS cityscript_zombiespawns('map' TEXT NOT NULL, 'x' NUMERIC NOT NULL, 'y' NUMERIC NOT NULL, 'z' NUMERIC NOT NULL);")
	sql.Commit()

	DB.CreateJailPos()
	DB.SetUpNonRentableDoors()
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
	local r = tonumber(sql.QueryValue("SELECT COUNT(*) FROM cityscript_disableddoors WHERE map = " .. sql.SQLStr(map) .. " AND idx = " .. ent:EntIndex() .. ";"))
	if not r then return end

	if r > 0 and not nonRentable then
		sql.Query("DELETE FROM cityscript_disableddoors WHERE map = " .. sql.SQLStr(map) .. " AND idx = " .. ent:EntIndex() .. ";")
	elseif r == 0 and nonRentable then
		sql.Query("INSERT INTO cityscript_disableddoors VALUES(" .. sql.SQLStr(map) .. ", " .. ent:EntIndex() .. ", " .. sql.SQLStr("Non-Rentable Door") .. ");")
		ent:SetNWString("dTitle", "Non-Rentable Door")
	end
end

function DB.StoreNonRentableDoorTitle(ent, text)
	sql.Query("UPDATE cityscript_disableddoors SET title = " .. sql.SQLStr(text) .. " WHERE map = " .. sql.SQLStr(string.lower(game.GetMap())) .. " AND idx = " .. ent:EntIndex() .. ";")
	ent:SetNWString("dTitle", text)
end

function DB.SetUpNonRentableDoors()
	local r = sql.Query("SELECT idx, title FROM cityscript_disableddoors WHERE map = " .. sql.SQLStr(string.lower(game.GetMap())) .. ";")
	if not r then return end

	for _, row in pairs(r) do
		local e = ents.GetByIndex(tonumber(row.idx))
		e:SetNWBool("nonRentable", true)
		e:SetNWString("dTitle", row.title)
	end
end

function DB.NewATM(ent)
	print("inside newatm function!")
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
			print("IT WAS NOT A ROWSET, BUT RATHER CONTAINS:")
			for a, b in pairs(r) do
				print("key: " .. a .. " = value: " .. b)
			end
			return
		end
		local atm = ents.Create("atm")
		atm:SetPos(Vector(row.x, row.y, row.z))
		atm:SetAngles(Angle(row.a, row.b, row.c))
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
