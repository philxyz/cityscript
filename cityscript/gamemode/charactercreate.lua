-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- charactercreate.lua
-- Contains the character creation concommands.
-------------------------------

-- Set Model
util.AddNetworkString("ncCreateCharacter")
net.Receive("ncCreateCharacter", function(len, ply)
	local mdl = net.ReadString()
	local name = net.ReadString()

	local chars = CAKE.PlayerData[ply:SteamID64()].characters

	if #chars == CAKE.ConVars.MaxPlayerCharacters then
		CAKE.Response(ply, TEXT.MaxCharactersReached)
	else
		-- Model code
		local found = false

		for k, v in pairs(CAKE.ValidModels) do
			if v == string.lower(mdl) then
				found = true
				break
			end
		end

		local thisIsANewPlayer = false

		for i=#DB.NewPlayers, 1, -1 do
			if DB.NewPlayers[i] == ply then
				thisIsANewPlayer = true
				table.remove(DB.NewPlayers, i)
				break
			end
		end

		local startingMoney = (thisIsANewPlayer and (#chars == 0) and CAKE.ConVars.Default_Money or 0)

		table.insert(chars, {
			model = found and mdl or "models/player/group01/male_01.mdl",
			name = name,
			bank = 0,
			money = startingMoney,
			inventory = {},
			flags = ""
		})

		if startingMoney > 0 then
			CAKE.Response(ply, TEXT.FirstCharacterBonus)
		end

		local id = #chars

		ply:SetNWInt("uid", id)
		ply:SetNWString("name", name)

		-- Finish character creation
		ply:SetDTInt(0, 1)

		CAKE.ResendCharData(ply)

		ply:RefreshInventory()
		ply:RefreshBusiness()

		ply:SetTeam(1)

		ply:Spawn()
		ply:ConCommand("fadein")

		DB.PersistPlayerData(ply)
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
