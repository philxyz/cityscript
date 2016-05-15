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
	local PlyCharTable = CAKE.PlayerData[client:SteamID64()]["characters"]

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
	client:SetNWInt("uid", high)
	client:SetDTInt(0, 1)
	CAKE.PlayerData[client:SteamID64()]["characters"][high] = {}
	CAKE.CallHook("CharacterCreation_Start", client)
end)

-- Finish Creation
util.AddNetworkString("ncFinishCreate")
net.Receive("ncFinishCreate", function(len, client)
	if client:GetDTInt(0) == 1 then
		client:SetDTInt(0, 1)

		CAKE.ResendCharData(client)

		client:RefreshInventory()
		client:RefreshBusiness()
		client:SetTeam(1)
		client:Spawn()
		client:ConCommand("fadein")
		CAKE.CallHook("CharacterCreation_Finished", client, client:GetNWInt("uid"))
	end
end)

net.Receive("Cr", function(_, ply)
	local uid = net.ReadInt(16)
	local SteamID64 = ply:SteamID64()

	if CAKE.PlayerData[SteamID64].characters[uid] != nil then
		ply:SetNWInt("uid", uid)
		CAKE.ResendCharData(ply)
		ply:SetDTInt(0, 1)
		ply:SetTeam(1)
		CAKE.CallHook("CharacterSelect_PostSetTeam", ply, CAKE.PlayerData[SteamID64].characters[uid])
		ply:RefreshInventory()
		ply:RefreshBusiness()
		ply:ConCommand("fadein")
		ply:Spawn()

		CAKE.CallHook("CharacterSelected", ply, CAKE.PlayerData[SteamID64].characters[uid])
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
		local steam = ply:SteamID64()
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
		ply:SetNWInt("uid", high)

		net.Start("Cz")
		net.WriteInt(#PlyCharTable, 32)
		for k, v in pairs(PlyCharTable) do -- Send them all their characters for selection
			net.WriteInt(tonumber(k), 32)
			net.WriteString(v.name)
			net.WriteString(v.model)
		end
		net.Send(ply)

		ply:SetDTInt(0, 1)

		local showHelp = CAKE.GetPlayerField(ply, "showhelppopup") == true

		net.Start("C2")
		net.WriteBool(showHelp)
		net.Send(ply)

		CAKE.CallHook("PlayerReady", ply)
	end
end)
