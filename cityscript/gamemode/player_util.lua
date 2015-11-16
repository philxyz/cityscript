-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- player_util.lua
-- Useful functions for players.
-------------------------------

function CAKE.Response(ply, msg)
	if ply == nil then return false end

	if ply:EntIndex() == 0 then
		print(msg)
	else
		ply:PrintMessage(3, msg)
	end
end

DecayingRagdolls = {}

function CAKE.DeathMode(ply)
	if ply == nil then return false end

	CAKE.DayLog("script.txt", TEXT.DeathMode .. " " .. ply:SteamID())
	local mdl = ply:GetModel()
	
	local rag = ents.Create("prop_ragdoll")
	rag:SetModel(mdl)
	rag:SetPos(ply:GetPos())
	rag:SetAngles(ply:GetAngles())
	rag.isdeathdoll = true
	rag.ply = ply
	rag:Spawn()
	
	ply:SetViewEntity(rag)
	
	ply.deathrag = rag
	
	local n = #DecayingRagdolls + 1
	DecayingRagdolls[n] = ply.deathrag
	
	ply:SetNWInt("deathmode", 1)
	
	ply.deathtime = 0
	ply.nextsecond = CurTime() + 1
	ply:PrintMessage(HUD_PRINTCENTER, "UNFORTUNATELY, YOU ARE DYING. SHOUT FOR A MEDIC!")
end

local meta = FindMetaTable("Player")

function meta:MaxHealth()
	return self:GetNWFloat("MaxHealth")
end

function meta:ChangeMaxHealth(amt)
	self:SetNWFloat("MaxHealth", self:MaxHealth() + amt)
end

function meta:MaxArmor()
	return self:GetNWFloat("MaxArmor")
end

function meta:ChangeMaxArmor(amt)
	self:SetNWFloat("MaxArmor", self:MaxArmor() + amt)
end

function meta:MaxWalkSpeed()
	return self:GetNWFloat("MaxWalkSpeed")
end

function meta:ChangeMaxWalkSpeed(amt)
	self:SetNWFloat("MaxWalkSpeed", self:MaxWalkSpeed() + amt)
end

function meta:MaxRunSpeed()
	return self:GetNWFloat("MaxRunSpeed")
end

function meta:ChangeMaxRunSpeed(amt)
	self:SetNWFloat("MaxRunSpeed", self:MaxRunSpeed() + amt)
end

function meta:Arrest(time)
	if self:GetNWBool("wanted") then
		self:SetNetworkedBool("wanted", false)
	end

	-- Always get sent to jail when Arrest() is called, even when already under arrest
	self:SetPos(DB.RetrieveJailPos())

	if not self:GetTable().Arrested then
		self:StripWeapons()
		self:GetTable().Arrested = true
		self.LastJailed = CurTime()

		-- If the player has no remaining jail time,
		-- set it back to the max for this new sentence
		if not time or time == 0 then
			time = 180
		end

		DB.StoreJailStatus(self, time)

		self:PrintMessage(HUD_PRINTCENTER, TEXT.ArrestMessage(time))

		for k, v in pairs(player.GetAll()) do
			if v ~= self then
				v:PrintMessage(HUD_PRINTCENTER, TEXT.ArrestMessage2(self:Name(), time))
			end
		end

		local s = self
		timer.Create(self:SteamID() .. "jailtimer", time, 1, function() s:Unarrest() end)
	end
end

function meta:Unarrest()
	if self and self:GetTable().Arrested then
		self:GetTable().Arrested = false
		self:SetPos(GAMEMODE:PlayerSelectSpawn(self):GetPos())
		GAMEMODE:PlayerLoadout(self)
		DB.StoreJailStatus(self, 0)
		timer.Stop(self:SteamID() .. "jailtimer")
		timer.Destroy(self:SteamID() .. "jailtimer")
	end
end

function meta:CompleteSentence()
	if self.SteamID ~= nil and self:SteamID() ~= nil then
		local time = DB.RetrieveJailStatus(self)

		if time == 0 or not DB.RetrieveJailPos() then
			-- No outstanding jail time to be done
			return ""
		else
			-- Don't pick up the soap this time
			self:Arrest(time)
			CAKE.Response(self, TEXT.JailPunishMessage(time))
		end
	end
end

function meta:GiveItem(class)
	CAKE.DayLog("economy.txt", TEXT.AddingItemToInventory(class, CAKE.FormatCharString(self)))

	local inv = CAKE.GetCharField(self, "inventory")
	table.insert(inv, class)

	CAKE.SetCharField(self, "inventory", inv)
	self:RefreshInventory()
end

function meta:TakeItem(class)
	local inv = CAKE.GetCharField(self, "inventory")
	
	for k, v in pairs(inv) do
		if v == class then
			inv[k] = nil
			PrintTable(inv)
			CAKE.SetCharField(self, "inventory", inv)
			self:RefreshInventory()
			CAKE.DayLog("economy.txt", TEXT.RemovingItemFromInventory(class, CAKE.FormatCharString(self)))
			return
		end
	end
end

function meta:ClearInventory()
	umsg.Start("clearinventory", self)
	umsg.End()
end

function meta:RefreshInventory()
	self:ClearInventory()
	
	local inv = CAKE.GetCharField(self, "inventory")

	if type(inv) ~= "table" then return end

	for k, v in pairs(inv) do
		umsg.Start("addinventory", self)
			umsg.String(CAKE.ItemData[v].Name)
			umsg.String(CAKE.ItemData[v].Class)
			umsg.String(CAKE.ItemData[v].Description)
			umsg.String(CAKE.ItemData[v].Model)
		umsg.End()
	end
end

function meta:ClearBusiness()
	umsg.Start("clearbusiness", self)
	umsg.End()
end

function meta:RefreshBusiness()
	self:ClearBusiness()
		
	if CAKE.Teams[self:Team()] == nil then return end -- Team not assigned
	
	for k, v in pairs(CAKE.ItemData) do
		if v.Purchaseable and table.HasValue(CAKE.Teams[self:Team()].item_groups, v.ItemGroup) then
			umsg.Start("addbusiness", self)
				umsg.String(v.Name)
				umsg.String(v.Class)
				umsg.String(v.Description)
				umsg.String(v.Model)
				umsg.String(v.ContentModel)
				umsg.Long(v.Price)
				umsg.Bool(v.ContentClass ~= nil)
			umsg.End()
		end
	end
end

function CAKE.FindPlayerBySID(sid)
	for k, v in pairs(player.GetAll()) do
		if v.SID == sid then return v end
	end
end

function CAKE.ChangeMoney(ply, amount) -- Modify someone's money amount.
	if ply == nil then return false end

	-- NEVAR EVAR LET IT GO NEGATIVE.
	local money = math.floor(tonumber(CAKE.GetCharField( ply, "money" ) or 0))

	if money + amount < 0 then return false end
	
	CAKE.DayLog("economy.txt", "Changing " .. ply:SteamID() .. "-" .. ply:GetNWString("uid") .. " money by " .. tostring(amount))
	CAKE.SetCharField(ply, "money", money + amount)

	ply:SetNWString("money", money)

	return true
end

function CAKE.ChangeBankMoney(ply, amount) -- Modify someone's bank money amount.
	if ply == nil then return false end

	local bank = tonumber(CAKE.GetCharField(ply, "bank") or 0)

	-- NEVAR EVAR LET IT GO NEGATIVE.
	if bank + amount < 0 then return false end

	CAKE.DayLog("economy.txt", TEXT.LogMoneyChange(ply:SteamID(), ply:GetNWString("uid"), amount))
	CAKE.SetCharField(ply, "bank", bank + amount)

	return true
end

function CAKE.SetMoney(ply, amount) -- Set someone's money amount.
	if ply == nil then return false end

	-- NEVAR EVAR LET IT GO NEGATIVE.
	if amount < 0 then return false end
	
	CAKE.DayLog("economy.txt", TEXT.LogSetMoneyChange(ply:SteamID(), ply:GetNWString("uid"), amount))
	
	CAKE.SetCharField(ply, "money", amount)
	ply:SetNWString("money", CAKE.GetCharField(ply, "money"))

	return true
end

function CAKE.ToxicPlayer(pl, mul) -- TOXIFY
	if pl == nil then return false end

	mul = mul / 10 * 2

	pl:ConCommand("pp_motionblur 1")
	pl:ConCommand("pp_motionblur_addalpha " .. 0.05 * mul)
	pl:ConCommand("pp_motionblur_delay " .. 0.035 * mul)
	pl:ConCommand("pp_motionblur_drawalpha 1.00")
	pl:ConCommand("pp_dof 1")
	pl:ConCommand("pp_dof_initlength 9")
	pl:ConCommand("pp_dof_spacing 8")

	local IDSteam = string.gsub(pl:SteamID(), ":", "")

	timer.Create(IDSteam, 40 * mul, 1, function() CAKE.UnToxicPlayer(pl) end)
end

function CAKE.UnToxicPlayer(pl)
	if pl == nil then return false end

	pl:ConCommand("pp_motionblur 0")
	pl:ConCommand("pp_dof 0")
end
