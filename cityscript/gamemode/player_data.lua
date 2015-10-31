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

-- This is to be used only by the main player table.
CAKE.PlayerDataFields = {}

-- This is to be used only by the characters table.
CAKE.CharacterDataFields = {}

local meta = FindMetaTable("Player")

function CAKE.FormatCharString(ply)
	return ply:SteamID() .. "-" .. ply:GetNWString("uid")
end

-- This formats a player's SteamID for things such as data file names
-- For example, STEAM_0:1:5947214 would turn into 015947214
function CAKE.FormatSteamID(SteamID)
	if SteamID == "UNKNOWN" or SteamID == "STEAM_ID_PENDING" or SteamID == "" then
		SteamID = nil
	end

	local SteamID = SteamID or "STEAM_0:0:0"

	s = string.gsub(SteamID, "STEAM", "")
	s = string.gsub(s, ":", "")
	s = string.gsub(s, "_", "")
	
	return s
end

-- When fieldtype is 1, it adds it to the player table.
-- When it is 2, it adds it to the character table.
function CAKE.AddDataField(fieldtype, fieldname, default)
	if fieldtype == 1 then
		CAKE.DayLog("script.txt", TEXT.AddDataField(fieldname, default))
		CAKE.PlayerDataFields[fieldname] = CAKE.ReferenceFix(default)
	elseif fieldtype == 2 then
		CAKE.DayLog("script.txt", TEXT.AddCharDataField(fieldname, default))
		CAKE.CharacterDataFields[fieldname] = CAKE.ReferenceFix(default)
	end
end

-- Load a player's data
function CAKE.LoadPlayerDataFile(ply)
	local SteamID = CAKE.FormatSteamID(ply:SteamID())
	
	CAKE.PlayerData[SteamID]  = {}
	
	if file.Exists("cakescript/playerdata/" .. CAKE.ConVars.Schema .. "/" .. CAKE.FormatSteamID(ply:SteamID()) .. ".txt", "DATA") then
		CAKE.CallHook("LoadPlayerDataFile", ply)
		
		CAKE.DayLog("script.txt", TEXT.LoadingPlayerDataFileFor .. " " .. ply:SteamID())
		
		-- Read the data from their data file
		local Data_Raw = file.Read("cakescript/playerdata/" .. CAKE.ConVars.Schema .. "/" .. CAKE.FormatSteamID(ply:SteamID()) .. ".txt", "DATA")
		
		-- Convert the data into a table
		local Data_Table = util.KeyValuesToTable(Data_Raw) or {}
		
		-- Insert the table into the data table
		CAKE.PlayerData[SteamID] = Data_Table
		
		-- Retrieve the data table for easier access
		local PlayerTable = CAKE.PlayerData[SteamID]
		local CharTable = CAKE.PlayerData[SteamID].characters or {}

		-- If any values were loaded and they aren't in the DataFields table, delete them from the player.
		for _, v in pairs(PlayerTable) do
			if CAKE.PlayerDataFields[_] == nil then
				CAKE.DayLog("script.txt", TEXT.InvalidPlayerDataField(_, ply:SteamID()))
				CAKE.PlayerData[SteamID][_] = nil
			end
		end
		
		-- If any fields were not loaded and they are in the DataFields table, add them.
		for fieldname, default in pairs(CAKE.PlayerDataFields) do
			if PlayerTable[fieldname] == nil then
				CAKE.DayLog("script.txt", TEXT.MissingPlayerDataField(fieldname, ply:SteamID(), default))
				CAKE.PlayerData[SteamID][fieldname] = CAKE.ReferenceFix(default)
			end
		end
		
		-- If any values were loaded and they aren't in the DataFields table, delete them from the character.
		for _, char in pairs(CharTable) do
			for k, v in pairs(char) do
				if CAKE.CharacterDataFields[k] == nil then
					CAKE.DayLog("script.txt", TEXT.InvalidCharacterDataField(_, ply:SteamID()))
					CAKE.PlayerData[SteamID].characters[_][k] = nil
				end
			end
		end
		
		-- If any fields were not loaded and they are in the DataFields table, add them.
		for _, char in pairs(CharTable) do
			for fieldname, default in pairs(CAKE.CharacterDataFields) do
				if char[fieldname] == nil then
					CAKE.DayLog("script.txt", TEXT.MissingCharacterDataField(fieldname, ply:SteamID(), _, default))
					CAKE.PlayerData[SteamID].characters[_][fieldname] = CAKE.ReferenceFix(default)
				end
			end
		end
		
		CAKE.SavePlayerData(ply)
		
		CAKE.CallHook("LoadedPlayerDataFile", ply, Data_Table)
	else
		-- Seems they don't have a player table. Let's create a default one for them.
		CAKE.DayLog("script.txt", TEXT.CreatingNewDataFileFor .. " " .. ply:SteamID())
		
		CAKE.PlayerData[SteamID] = {}
		
		-- Let's get the default fields and add them to the table.
		for fieldname, default in pairs(CAKE.PlayerDataFields) do
			if CAKE.PlayerData[fieldname] == nil then
				CAKE.PlayerData[SteamID][fieldname] = CAKE.ReferenceFix(default)
			end
		end
		
		-- We won't make a character, obviously. That is done later.
		CAKE.SavePlayerData(ply)
		
		-- Technically, we didn't load it, but the data is now there.
		CAKE.CallHook("LoadedPlayerDataFile", ply, Data_Table)
	end
end

function CAKE.ResendCharData(ply) -- Network all of the player's character data
	local SteamID = CAKE.FormatSteamID(ply:SteamID())
	
	if CAKE.PlayerData[SteamID].characters[ply:GetNWString("uid")] == nil then
		return;
	end
	
	for fieldname, data in pairs(CAKE.PlayerData[SteamID].characters[ply:GetNWString("uid")]) do
		if type(data) ~= "table" then
			ply:SetNWString(fieldname, tostring(data))
		end
	end
end

function CAKE.SetPlayerField(ply, fieldname, data)
	local SteamID = CAKE.FormatSteamID(ply:SteamID())
	
	-- Check to see if this is a valid field
	if CAKE.PlayerDataFields[fieldname] then
		CAKE.PlayerData[SteamID][fieldname] = data
		CAKE.SavePlayerData(ply)
	else
		return ""
	end
end
	
function CAKE.GetPlayerField(ply, fieldname)
	local SteamID = CAKE.FormatSteamID(ply:SteamID())

	-- Check to see if this is a valid field
	if CAKE.PlayerDataFields[fieldname] then
		return CAKE.PlayerData[SteamID][fieldname] or ""
	else
		return ""
	end
end

function CAKE.SetCharField(ply, fieldname, data)
	local SteamID = CAKE.FormatSteamID(ply:SteamID())
	
	-- Check to see if this is a valid field
	if CAKE.CharacterDataFields[fieldname] then
		CAKE.PlayerData[SteamID]["characters"][ply:GetNWString("uid")][fieldname] = data
		CAKE.SavePlayerData(ply)
	else
		return ""
	end
end
	
function CAKE.GetCharField(ply, fieldname)
	local SteamID = CAKE.FormatSteamID(ply:SteamID())

	-- Check to see if this is a valid field
	if fieldname and CAKE.CharacterDataFields[fieldname] then
		if CAKE.PlayerData[SteamID].characters[tonumber(ply:GetNWString("uid"))] == nil then
			return ""
		else
			return CAKE.PlayerData[SteamID].characters[tonumber(ply:GetNWString("uid"))][fieldname] or ""
		end
	else
		return ""
	end
	
end

function CAKE.SavePlayerData(ply)
	local keys = util.TableToKeyValues(CAKE.PlayerData[CAKE.FormatSteamID(ply:SteamID())])
	local directory = "cakescript/playerdata/" .. CAKE.ConVars.Schema .. "/";
	if not file.Exists(directory, "DATA") then
		file.CreateDir(directory)
	end
	local filename = "cakescript/playerdata/" .. CAKE.ConVars.Schema .. "/" .. CAKE.FormatSteamID(ply:SteamID()) .. ".txt"
	print("Saving player data to: " .. filename)
	file.Write(filename, keys)
end
