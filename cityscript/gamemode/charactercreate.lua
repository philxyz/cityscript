-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- charactercreate.lua
-- Contains the character creation concommands.
-------------------------------	
	
-- Set Model
util.AddNetworkString("ncSetModel")
net.Receive("ncSetModel", function(len, client)
	local mdl = net.ReadString()
	
	if client:GetDTInt(0) == 1 then
		local found = false

		for k, v in pairs(CAKE.ValidModels) do
			if v == string.lower(mdl) then
				found = true
				break
			end
		end

		if found then
			CAKE.CallHook("CharacterCreation_SetModel", client, mdl)
			CAKE.SetCharField(client, "model", mdl)
		else
			CAKE.CallHook("CharacterCreation_SetModel", client, "models/player/group01/male_01.mdl")
			CAKE.SetCharField(client, "model", "models/player/group01/male_01.mdl")
		end
	end
	
	return
end)

util.AddNetworkString("ncStartCreate")
net.Receive("ncStartCreate", function(len, client)
	-- Start Creation
	local PlyCharTable = CAKE.PlayerData[CAKE.FormatSteamID(client:SteamID())]["characters"]

	-- Find the highest Unique ID
	local high = 0

	for k, v in pairs(PlyCharTable) do
		k = tonumber(k)
		high = tonumber(high)
		
		if k > high then
			high = k
		end
	end

	high = high + 1
	client:SetNWString("uid", tostring(high))
	client:SetDTInt(0, 1)
	CAKE.PlayerData[CAKE.FormatSteamID(client:SteamID())]["characters"][tostring(high)] = {}
	CAKE.CallHook("CharacterCreation_Start", client)
end)

-- Finish Creation
util.AddNetworkString("ncFinishCreate")
net.Receive("ncFinishCreate", function(len, client)
	if client:GetDTInt(0) == 1 then
		client:SetDTInt(0, 1)

		local SteamID = CAKE.FormatSteamID(client:SteamID())
		for fieldname, default in pairs(CAKE.CharacterDataFields) do
			if CAKE.PlayerData[SteamID]["characters"][client:GetNWString("uid")][fieldname] == nil then
				CAKE.PlayerData[SteamID]["characters"][client:GetNWString("uid")][fieldname] = CAKE.ReferenceFix(default)
			end
		end

		CAKE.ResendCharData(client)

		client:RefreshInventory()
		client:RefreshBusiness()
		client:SetTeam(1)
		client:Spawn()
		client:ConCommand("fadein")
		CAKE.CallHook("CharacterCreation_Finished", client, client:GetNWString("uid"))
	end
end)

net.Receive("Cr", function(_, ply)
	local uid = net.ReadInt(16)
	local SteamID = CAKE.FormatSteamID(ply:SteamID())

	if CAKE.PlayerData[SteamID].characters[uid] != nil then
		ply:SetNWString("uid", uid)
		CAKE.ResendCharData(ply)
		ply:SetDTInt(0, 1)
		ply:SetTeam(1)
		CAKE.CallHook("CharacterSelect_PostSetTeam", ply, CAKE.PlayerData[SteamID].characters[uid])
		ply:RefreshInventory()
		ply:RefreshBusiness()
		ply:ConCommand("fadein")
		ply:Spawn()
		
		CAKE.CallHook("CharacterSelected", ply, CAKE.PlayerData[SteamID].characters[uid])
	else
		return
	end
end)

net.Receive("Cp", function(_, ply)
	if ply.Ready == false then
		ply.Ready = true
	
		-- Find the highest Unique ID and set it - just in case they want to create a character.
		local high = 0

		local PlyCharTable = {}
		local steam = CAKE.FormatSteamID(ply:SteamID())
		if steam and CAKE.PlayerData[steam] then
			PlyCharTable = CAKE.PlayerData[steam]["characters"]
		end
		
		for k, v in pairs(PlyCharTable) do
		
			k = tonumber(k)
			high = tonumber(high)
			
			if k > high then 
				high = k
			end
		end
		
		high = high + 1
		ply:SetNWString("uid", tostring(high))
		
		for k, v in pairs(PlyCharTable) do -- Send them all their characters for selection
			umsg.Start("ReceiveChar", ply)
				umsg.Long(tonumber(k))
				umsg.String(v.name)
				umsg.String(v.model)
			umsg.End()
		end
		
		ply:SetDTInt(0, 1)
		
		local showHelp = CAKE.GetPlayerField(ply, "showhelppopup") == 1

		umsg.Start("_cC", ply)
			umsg.Bool(showHelp)
		umsg.End()
		
		CAKE.CallHook("PlayerReady", ply)
	end
end)
