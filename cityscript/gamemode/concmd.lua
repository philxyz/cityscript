-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- concmd.lua
-- Contains the concommands and changes the way other concommands work.
-------------------------------

function GM:PlayerSpawnSWEP(ply, class)
	CAKE.CallTeamHook("PlayerSpawnSWEP", ply, class) -- Perhaps allow certain roles to spawn with sweps, eh?

	return ply:IsSuperAdmin()
end

function GM:PlayerGiveSWEP(ply)
	CAKE.CallTeamHook("PlayerGiveSWEP", ply, class) -- Perhaps allow certain roles to use sweps, eh?

	return ply:IsSuperAdmin()
end

function math.IsFinite(num)
	return not (num ~= num and num ~= math.huge and num ~= -math.huge)
end

-- This is the F1 menu
function GM:ShowHelp(ply)
	local PlyCharTable = {}
	local steam = ply:SteamID64()

	if steam and CAKE.PlayerData[steam] then
		PlyCharTable = CAKE.PlayerData[steam].characters
	end

	net.Start("Cz")
	net.WriteInt(#PlyCharTable, 32)
	for k, v in pairs(PlyCharTable) do
		net.WriteInt(k, 32)
		net.WriteString(v.name)
		net.WriteString(v.model)
	end
	net.Send(ply)

	net.Start("C1")
	net.Send(ply)
end

-- NO SENT FOR YOU.
function GM:PlayerSpawnSENT(ply, class)
	if ply:GetTable().Arrested then return false end

	CAKE.CallTeamHook("PlayerSpawnSWEP", ply, class) -- Perhaps allow certain roles to use sents, eh?

	return ply:IsSuperAdmin()
end

function GM:PlayerSpawnEffect(ply, model)
	return self.BaseClass:PlayerSpawnEffect(ply, model) and not ply:GetTable().Arrested
end

function GM:PlayerSpawnVehicle(ply, model)
	return self.BaseClass:PlayerSpawnVehicle(ply, model) and not ply:GetTable().Arrested
end

function GM:PlayerSpawnNPC(ply, model)
	return self.BaseClass:PlayerSpawnNPC(ply, model) and not ply:GetTable().Arrested
end

function GM:PlayerSpawnRagdoll(ply, model)
	return self.BaseClass:PlayerSpawnRagdoll(ply, model) and not ply:GetTable().Arrested
end

function GM:PlayerSpawnedProp(ply, model, ent)
	self.BaseClass:PlayerSpawnedProp(ply, model, ent)
	ent.SID = ply.SID
end

function GM:PlayerSpawnedSWEP(ply, model, ent)
	self.BaseClass:PlayerSpawnedSWEP(ply, model, ent)
	ent.SID = ply.SID
end

function GM:PlayerSpawnedRagdoll(ply, model, ent)
	self.BaseClass:PlayerSpawnedRagdoll(ply, model, ent)
	ent.SID = ply.SID
end

-- Disallows suicide
function GM:CanPlayerSuicide(ply)
	if ply:GetTable().Arrested or CAKE.ConVars["SuicideEnabled"] ~= "1" then
		ply:ChatPrint(TEXT.SuicideIsDisabled)
		return false
	end

	return true
end

net.Receive("C7", function(_, ply)
	local newrole = net.ReadString()
	local RoleTo = {}

	-- Find a Team with a matching role
	-- if there is one, set that to RoleTo
	for k, v in pairs(CAKE.Teams) do
		if v.role_key == newrole then
			RoleTo = v -- Team Details
			RoleTo.n = k -- Index into CAKE.Teams at which this Team exists
			break
		end
	end

	local function CheckLimit(teamName, convar)
		local count = 0
		local ps = player.GetAll()

		for k, v in pairs(ps) do
			if team.GetName(v:Team()) == teamName then
				count = count + 1
			end
		end

		-- If someone is already this team
		if count > 0 then
			-- If adding another person would go over the limit
			if (((count + 1) / #ps) * 100) > convar then
				CAKE.Response(ply, TEXT.MaxReached)
				return true
			end
		end

		return false
	end

	if RoleTo.name == TEXT.CityMayor or
		RoleTo.name == TEXT.CityPolice or
		RoleTo.name == TEXT.BloodBrothersGangLeader or
		RoleTo.name == TEXT.LaFamigliaVontoriniGangLeader or
		RoleTo.name == TEXT.TheLegionGangLeader then
		-- Max is 1
		for k, v in pairs(player.GetAll()) do
			if team.GetName(v:Team()) == RoleTo.name then
				CAKE.Response(ply, TEXT.MaxIsOne)
				return
			end
		end
	elseif RoleTo.name == TEXT.CityPolice then
		if CheckLimit(RoleTo.name, CAKE.ConVars.PolicePcnt) then return; end
	elseif RoleTo.name == TEXT.GroceryStoreOwner then
		if CheckLimit(RoleTo.name, CAKE.ConVars.GroceryStoreOwnerPcnt) then return; end
	elseif RoleTo.name == TEXT.GunStoreOwner then
		if CheckLimit(RoleTo.name, CAKE.ConVars.GunStoreOwnerPcnt) then return; end
	elseif RoleTo.name == TEXT.CarDealershipOwner then
		if CheckLimit(RoleTo.name, CAKE.ConVars.CarDealershipOwnerPcnt) then return; end
	elseif RoleTo.name == TEXT.BlackMarketDealer then
		if CheckLimit(RoleTo.name, CAKE.ConVars.BlackMarketDealerPcnt) then return; end
	elseif RoleTo.name == TEXT.MedicalSpecialist then
		if CheckLimit(RoleTo.name, CAKE.ConVars.MedicalSpecialistPcnt) then return; end
	elseif RoleTo.name == TEXT.BloodBrothersGangMember then
		if CheckLimit(RoleTo.name, CAKE.ConVars.BloodBrothersGangPcnt) then return; end
	elseif RoleTo.name == TEXT.LaFamigliaVontoriniGangMember then
		if CheckLimit(RoleTo.name, CAKE.ConVars.VontoriniGangPcnt) then return; end
	elseif RoleTo.name == TEXT.TheLegionGangMember then
		if CheckLimit(RoleTo.name, CAKE.ConVars.LegionGangPcnt) then return; end
	elseif RoleTo.name == TEXT.Citizen then
		-- It's always OK.
	else
		CAKE.Response(ply, TEXT.IncorrectRole)
		return
	end

	if ply:GetTable().Arrested then
		if not ply:Alive() then
			CAKE.Response(ply, TEXT.NoJobChangeWhileDeadInJail)
			return
		else
			CAKE.Response(ply, TEXT.NoJobChangeWhileAliveInJail)
			return
		end
	end

	local inv = CAKE.GetCharField(ply, "inventory")

	-- If the player has items in their inventory, clear them out.
	if #inv > 0 then
		for k, v in pairs(inv) do
			ply:TakeItem(v)
		end

		CAKE.Response(ply, TEXT.NewRoleBackpackEmptied)
	end

	-- Set the player's team
	ply:SetTeam(RoleTo.n)

	-- Reload their business tab
	ply:RefreshBusiness()
	ply.RoleChangeHealth = ply:Health()
	ply:Spawn()

	return
end)

util.AddNetworkString("CA")
net.Receive("CA", function(_, ply)
	local who = net.ReadInt(16)
	local whoPly = Entity(who)
	local door = net.ReadInt(16)
	local doorEnt = Entity(door)

	if IsValid(doorEnt) and IsValid(whoPly) then
		-- Only the person renting the door can give keys away to it.
		if doorEnt:GetNWInt("rby") == ply:EntIndex() then

			-- Give the keys to the person
			local found = false
			for k, v in ipairs(doorEnt.Keyholders) do
				if v == whoPly then
					found = true
					break
				end
			end

			if not found then
				table.insert(doorEnt.Keyholders, whoPly)
				CAKE.Response(ply, TEXT.KeysGivenToPlayer(CAKE.GetCharField(whoPly, "name") or whoPly:Name()))
			else
				CAKE.Response(ply, TEXT.PlayerAlreadyHasKeys)
			end
		end
	else
		CAKE.Response(ply, TEXT.InvalidDoorEntityOrTargetPlayer)
	end
end)

util.AddNetworkString("Co")
net.Receive("Co", function(_, ply)
	local which = net.ReadInt(16)

	-- If we delete a character with a lower ID number than the one we are using, our id will
	-- reduce by one.

	if which < ply:GetNWInt("uid") then
		ply:SetNWInt("uid", ply:GetNWInt("uid") - 1)
	end

	table.remove(CAKE.PlayerData[ply:SteamID64()].characters, which)

	DB.PersistPlayerData(ply)

	CAKE.ResendCharData(ply)

	CAKE.Response(ply, TEXT.CharacterDeleted)
end)

-- Lock door
net.Receive("Cn", function(_, ply)
	local entIndex = net.ReadInt(16)
	local entity = ents.GetByIndex(entIndex)

	local rentable = not entity:GetNWBool("nonRentable")
	local restrictedArea = entity:GetNWBool("pmOnly")
	local playerCanAccessRestrictedAreas = CAKE.Teams[ply:Team()].can_access_restricted_areas

	if CAKE.IsDoor(entity) then
		local isKeyholder = false

		-- If the door isn't owned by the originator of this message
		if entity:GetNWInt("rby") ~= ply:EntIndex() then
			-- Check whether the originator of this message is a keyholder
			for _, v in ipairs(entity.Keyholders or {}) do
				if v == ply then
					isKeyholder = true
					break
				end
			end
		end

		if rentable and (entity.owner == ply or (restrictedArea and playerCanAccessRestrictedAreas)) or isKeyholder then
			entity:Fire("lock", "", 0)
			ply:EmitSound("buttons/lever" .. math.floor(math.Rand(7,8)) .. ".wav")
			CAKE.Response(ply, TEXT.DoorLocked)
		else
			CAKE.Response(ply, TEXT.NotYourDoor)
		end
	end
end)

-- Unlock door
net.Receive("Cm", function(_, ply)
	local entIndex = net.ReadInt(16)
	local entity = ents.GetByIndex(entIndex)

	local rentable = not entity:GetNWBool("nonRentable")
	local restrictedArea = entity:GetNWBool("pmOnly")
	local playerCanAccessRestrictedAreas = CAKE.Teams[ply:Team()].can_access_restricted_areas

	local isKeyholder = false

	-- If the door isn't owned by the originator of this message
	if entity:GetNWInt("rby") ~= ply:EntIndex() then
		-- Check whether the originator of this message is a keyholder
		for _, v in ipairs(entity.Keyholders or {}) do
			if v == ply then
				isKeyholder = true
				break
			end
		end
	end

	if CAKE.IsDoor(entity) then
		if rentable and (entity.owner == ply or (restrictedArea and playerCanAccessRestrictedAreas)) or isKeyholder then
			entity:Fire("unlock", "", 0)
			ply:EmitSound("buttons/lever" .. math.floor(math.Rand(7,8)) .. ".wav")
			CAKE.Response(ply, TEXT.DoorUnlocked)
		else
			CAKE.Response(ply, TEXT.NotYourDoor)
		end
	end
end)

-- Rent door
net.Receive("Ck", function(_, ply)
	local entIndex = net.ReadInt(16)
	local door = ents.GetByIndex(entIndex)

	if door:GetNWBool("nonRentable") then
		CAKE.Response(ply, TEXT.DoorNotRentable)
		return
	end

	if door:GetNWBool("pmOnly") then
		CAKE.Response(ply, TEXT.DoorNotRentable)
		return
	end

	local pos = door:GetPos()

	if CAKE.IsDoor(door) then
		if door.owner == nil then
			if tonumber(CAKE.GetCharField(ply, "money")) >= 50 then
				-- Enough money to start off, let's start the rental.
				CAKE.ChangeMoney(ply, -50)
				door:SetNWInt("rby", ply:EntIndex())
				door.owner = ply
				door.Keyholders = {}
				CAKE.Response(ply, TEXT.DoorRented)

				local function Rental(ply, doornum)
					local door = ents.GetByIndex(tonumber(doornum))

					if door.owner == ply then
						if tonumber(CAKE.GetCharField(ply, "money")) >= 50 then
							CAKE.ChangeMoney(ply, 0 - 50)
							CAKE.Response(ply, TEXT.DoorCharged)
							-- Start the timer again
							timer.Simple(900, function() ply:Rental(doornum) end) -- 15 minutes hoo rah
						else
							CAKE.Response(ply, TEXT.DoorLost)
							door:SetNWString("title", "")
							door.owner = nil
							door:SetNWInt("rby", 0)
						end
					end
				end

				timer.Simple(900, function() Rental(ply, entIndex) end)
			else
				CAKE.Response(ply, TEXT.Poor)
			end
		elseif door.owner == ply then
			door.owner = nil
			door:SetNWInt("rby", 0)
			CAKE.Response(ply, TEXT.DoorRentCancelled)
		else
			CAKE.Response(ply, TEXT.DoorAlreadyRented)
		end
	end
end)

-- Toggle admin-controlled door attributes (per door)
net.Receive("Cc", function(_, ply)
	local doorEnt = Entity(net.ReadInt(16))
	local mode = net.ReadInt(8)
	local featureEnabled = net.ReadBool()

	if not ply:IsSuperAdmin() then
		CAKE.Response(ply, TEXT.SuperAdminOnly)
		return
	end

	if mode == 0 then
		doorEnt:SetNWBool("nonRentable", not featureEnabled)
		DB.StoreDoorRentability(doorEnt)

		CAKE.Response(ply, featureEnabled and TEXT.DoorRentingEnabled or TEXT.DoorRentingDisabled)
	elseif mode == 1 then
		doorEnt:SetNWBool("pmOnly", featureEnabled)
		DB.StoreDoorRestriction(doorEnt)

		CAKE.Response(ply, featureEnabled and TEXT.DoorRestricted or TEXT.DoorUnrestricted)
	end
end)

-- Lock vehicle
net.Receive("Cnv", function(_, ply)
	local entIndex = net.ReadInt(16)
	local entity = ents.GetByIndex(entIndex)

	if not entity:IsVehicle() then return end

	if entity:GetNWEntity("c_ent") ~= ply then return end

	entity:Fire("lock", "", 0)
	ply:EmitSound("buttons/lever" .. math.floor(math.Rand(7,8)) .. ".wav")
	CAKE.Response(ply, TEXT.VehicleLocked)
end)

-- Unlock vehicle
net.Receive("Cmv", function(_, ply)
	local entIndex = net.ReadInt(16)
	local entity = ents.GetByIndex(entIndex)

	if not entity:IsVehicle() then return end

	if entity:GetNWEntity("c_ent") ~= ply then return end

	entity:Fire("unlock", "", 0)
	ply:EmitSound("buttons/lever" .. math.floor(math.Rand(7,8)) .. ".wav")
	CAKE.Response(ply, TEXT.VehicleUnlocked)
end)

CAKE.ChatCommand(TEXT.DropWeaponCommand, function(ply, args)
	local wep = ply:GetActiveWeapon()

	if CAKE.ItemData[wep:GetClass()] == nil then
		CAKE.Response(ply, TEXT.WeaponNotDroppable)
		return
	end

	local clip1 = wep:Clip1() or 0
	local clip2 = wep:Clip2() or 0

	local wepclass = weapons.GetStored(wep:GetClass())

	if wepclass.Primary and (clip1 > 0) then
		ply:GiveAmmo_ReloadFix(-clip1, wepclass.Primary.Ammo, true)
	end

	if wepclass.Secondary and (clip2 > 0) then
		ply:GiveAmmo_ReloadFix(-clip2, wepclass.Secondary.Ammo, true)
	end

	ply:StripWeapon(wep:GetClass())

	CAKE.CreateItem(ply, wep:GetClass(), ply:CalcDrop(), Angle(0, 0, 0), clip1, clip2)
end)


util.AddNetworkString("veh")
CAKE.ChatCommand(TEXT.ManageVehicleAddonsCommand, function(ply, args)
	if not ply:IsSuperAdmin() then return "" end

	net.Start("veh")
	net.Send(ply)

	print("running find...")
	local vehs, dirs = file.Find("models/*.mdl", "GAME")

	for _, v in ipairs(vehs) do
		print("attempting to read " .. v)
		--[[local f = file.Read(v, "GAME")
		if string.match(f, "vehicle", 1) then
			print("Vehicle Found: " .. tostring(v))
		else
			print("No match for " .. v)
		end]]
	end

	return ""
end)

-- Scrap the vehicle
net.Receive("Sv", function(_, ply)
	local vehEnt = Entity(net.ReadInt(16))

	if not IsValid(ply) or not IsValid(vehEnt) then return end

	local vehOwner = vehEnt:GetNWEntity("c_ent")
	if not IsValid(vehOwner) then return end

	if vehOwner ~= ply then return end

	local amt = math.floor(vehEnt.PurchasePrice * 0.1)

	CAKE.Response(ply, TEXT.VehicleScrappedFor(amt))
	CAKE.ChangeMoney(ply, amt)

	vehEnt:Remove()
end)

-- Set a vehicle sale price
net.Receive("Ssp", function(_, ply)
	local vehEnt = Entity(net.ReadInt(16))
	local amt = net.ReadString()

	if (not IsValid(vehEnt)) or (vehEnt:GetNWEntity("c_ent") ~= ply) then return end

	local saleValue = tonumber(amt)

	if saleValue == nil then return end

	if saleValue < 0 then
		saleValue = -1
	end

	vehEnt:SetNWInt("svl", math.floor(saleValue))
end)

-- Buy a vehicle
net.Receive("Bv", function(_, buyer)
	local vehEnt = Entity(net.ReadInt(16))
	local vehowner = vehEnt:GetNWEntity("c_ent")

	if not IsValid(buyer) or not IsValid(vehEnt) or not IsValid(vehowner) or vehowner == buyer then return end

	local saleValue = vehEnt:GetNWInt("svl")

	if saleValue == nil or saleValue < 0 then return end

	-- If the buyer can afford the price of the vehicle
	-- perform the transaction
	local money = math.floor(tonumber(CAKE.GetCharField(buyer, "money") or 0))
	if money < saleValue then
		CAKE.Response(buyer, TEXT.Poor)
	else
		CAKE.ChangeMoney(buyer, -saleValue)
		CAKE.ChangeMoney(vehowner, saleValue)
		CAKE.Response(buyer, TEXT.BoughtVehicleFor(saleValue))
		CAKE.Response(vehowner, TEXT.SoldVehicleFor(saleValue))
		vehEnt.PurchasePrice = saleValue -- Used for calculating scrap value

		UPP.SetOwnership(vehEnt, buyer)
	end
end)

-- Pickup item
net.Receive("Cj", function(_, ply)
	local itemEntIdx = net.ReadInt(16)
	local item = ents.GetByIndex(itemEntIdx)

	if IsValid(item) and
		(not CAKE.IsDoor(item) and not item:IsVehicle() and not item:IsPlayer() and not item:IsNPC()) and
		item:GetPos():Distance(ply:GetShootPos()) < 100 then

		local inv = CAKE.GetCharField(ply, "inventory")

		if table.Count(inv) < 10 then
			if item:Pickup(ply) ~= false then
				if item:GetNWInt("Clip1A") > 0 then
					ply:GiveAmmo_ReloadFix(item:GetNWInt("Clip1A"), game.GetAmmoName(item:GetNWInt("PAmmoType")))
				end

				if item:GetNWInt("Clip2A") > 0 then
					ply:GiveAmmo_ReloadFix(item:GetNWInt("Clip2A"), game.GetAmmoName(item:GetNWInt("SAmmoType")))
				end

				if item:GetClass() == "spawned_weapon" then
					ply:GiveItem(item.class)
				else
					ply:GiveItem(item.Class)
				end
			end
		else
			CAKE.Response(ply, TEXT.InventoryFull)
		end
	end
end)

-- Use item
net.Receive("Ci", function(_, ply)
	local itemEntIdx = net.ReadInt(16)
	local item = ents.GetByIndex(itemEntIdx)

	if IsValid(item) and (not CAKE.IsDoor(item) and not item:IsVehicle() and not item:IsPlayer() and not item:IsNPC()) and item.UseItem and item:GetPos():Distance(ply:GetShootPos()) < 100 then

		-- Picking up an item should not cause it to give out free ammo...
		-- .. to get around this, we modify the weapon's SWEP table before
		-- ply:Give("<class>") gets a chance to read it
		local wepTable = weapons.GetStored(item.Class)
		if not wepTable then
			wepTable = scripted_ents.GetStored(item.Class)
			if wepTable then
				wepTable = wepTable.t or scripted_ents.Get(item.Class)
			end
		end

		if wepTable and not item.IncludeAmmo then
			if wepTable.Primary then
				wepTable.Primary.DefaultClip = 0
			end

			if wepTable.Secondary then
				wepTable.Secondary.DefaultClip = 0
			end
		end

		item:UseItem(ply)

		if ply:HasWeapon(item.Class or item:GetClass()) then
			ply:SelectWeapon(item.Class or item:GetClass())
		end

		-- If there was any ammo left in the magazine, set this up.
		if (item:GetNWInt("Clip1A") or 0) > 0 then
			ply:GetActiveWeapon():SetClip1(item:GetNWInt("Clip1A"))
		end
		if (item:GetNWInt("Clip2A") or 0) > 0 then
			ply:GetActiveWeapon():SetClip(item:GetNWInt("Clip2A"))
		end
	end
end)

-- Take ammo from a weapon in world.
net.Receive("Ch", function(_, ply)
	local itemEntIdx = net.ReadInt(16)
	local item = ents.GetByIndex(itemEntIdx)

	if IsValid(item) and (not CAKE.IsDoor(item) and not item:IsVehicle() and not item:IsPlayer() and not item:IsNPC()) and item.UseItem and item:GetPos():Distance(ply:GetShootPos()) < 100 then

		if (item:GetNWInt("Clip1A") or 0) > 0 then
			CAKE.Response(ply, "Found " .. tostring(item:GetNWInt("Clip1A")) .. " units of " .. tostring(game.GetAmmoName(item:GetNWInt("PAmmoType") or 0) or "") ..  " ammunition.")
		end

		if (item:GetNWInt("Clip2A") or 0) > 0 then
			CAKE.Response(ply, "Found " .. tostring(item:GetNWInt("Clip2A")) .. " units of " .. tostring(game.GetAmmoName(item:GetNWInt("SAmmoTpe") or 0) or "") ..  " ammunition.")
		end

		ply:GiveAmmo_ReloadFix(item:GetNWInt("Clip1A"), tostring(game.GetAmmoName(item:GetNWInt("PAmmoType") or 0) or ""))
		item:SetNWInt("Clip1A", 0)

		ply:GiveAmmo_ReloadFix(item:GetNWInt("Clip2A"), tostring(game.GetAmmoName(item:GetNWInt("SAmmoType") or 0) or ""))
		item:SetNWInt("Clip2A", 0)
	end
end)

function ccSetMoney(ply, cmd, args)
	if not args[1] or not tonumber(args[2]) or not math.IsFinite(tonumber(args[2])) or not ply:IsSuperAdmin() then
		CAKE.Response(ply, TEXT.SetMoneyUsedIncorrectly)
		return
	end

	local amt = math.floor(tonumber(args[2]))

	local tp = nil

	local plys = player.GetAll()

	for k, v in ipairs(plys) do
		if v:GetName():lower():find(args[1]:lower()) then
			tp = v
			break
		end
	end

	if tp ~= nil then
		if amt > 0 then
			CAKE.ChangeMoney(tp, -CAKE.GetCharField(tp, "money"))
			CAKE.ChangeMoney(tp, amt)
			CAKE.Response(ply, TEXT.YouGaveX_Y_Tokens(tp:Nick(), amt))
			CAKE.Response(tp, TEXT.X_GaveYouY_Tokens(ply:Nick(), amt))
		else
			CAKE.Response(ply, "Invalid Amount")
		end
	else
		CAKE.Response(ply, "Player Not Found")
	end
end
concommand.Add("rp_setmoney", ccSetMoney)

net.Receive("gmn", function(_, ply)
	local target = Entity(net.ReadInt(16))
	local strAmount = net.ReadString()
	if not IsValid(target) then
		CAKE.Response(ply, TEXT.TargetNotFound)
		return
	end

	if not tonumber(strAmount) or not math.IsFinite(tonumber(strAmount)) then
		CAKE.Response(ply, TEXT.GiveMoneyUsedIncorrectly)
		return
	end

	if tonumber(strAmount) <= 0 then
		CAKE.Response(ply, TEXT.InvalidAmount)
		return
	end

	if tonumber(CAKE.GetCharField(ply, "money")) >= tonumber(strAmount) then
		CAKE.ChangeMoney(target, tonumber(strAmount))
		CAKE.ChangeMoney(ply, 0 - tonumber(strAmount))
		CAKE.Response(ply, TEXT.YouGaveX_Y_Tokens(target:Nick(), strAmount))
		CAKE.Response(target, TEXT.X_GaveYouY_Tokens(ply:Nick(), strAmount))
	else
		CAKE.Response(ply, TEXT.NotEnoughTokens)
	end
end)

-- Opened chat.
net.Receive("Cg", function(_, ply)
	ply:SetNWInt("chatopen", 1)
end)

-- Closed chat.
net.Receive("Cf", function(_, ply)
	ply:SetNWInt("chatopen", 0)
end)

net.Receive("Ca", function(_, ply)
	local show = net.ReadBool()

	if IsValid(ply) and ply:IsPlayer() then
		CAKE.SetPlayerField(ply, "showhelppopup", show)
	end
end)
