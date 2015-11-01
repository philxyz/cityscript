PLUGIN.Name = "/give, /dropmoney, /moneydrop Commands" -- What is the plugin name
PLUGIN.Author = "philxyz" -- Author of the plugin
PLUGIN.Description = "A set of money-related chat commands" -- The description or purpose of the plugin

local function GiveTokens(ply, args)
	if args == "" then return "" end

	local trace = ply:GetEyeTrace()

	if IsValid(trace.Entity) and trace.Entity:IsPlayer() and trace.Entity:GetPos():Distance(ply:GetPos()) < 150 then
		local amount = math.floor(tonumber(args))

		if not math.IsFinite(amount) then
			CAKE.Response(ply, TEXT.NotFiniteNumber)
			return ""
		end

		if amount < 1 then
			CAKE.Response(ply, TEXT.MustBeAtLeast1Token)
			return ""
		end

		if tonumber(ply:GetNWString("money")) < amount then
			CAKE.Response(ply, TEXT.NotEnoughTokens)
			return ""
		end

		CAKE.ChangeMoney(ply, -amount)
		CAKE.ChangeMoney(trace.Entity, amount)

		CAKE.Response(trace.Entity, TEXT.X_GaveYouY_Tokens(ply:Nick(), tostring(amount)))
		CAKE.Response(ply, TEXT.YouGaveX_Y_Tokens(trace.Entity:Nick(), tostring(amount)))
	else
		CAKE.Response(ply, "Must be looking at and standing close to another player!")
	end
	return ""
end

local function DropTokens(ply, args)
	if args == "" or not tonumber(args) or not math.IsFinite(tonumber(args)) then return "" end

	local amount = math.floor(tonumber(args))

	if not math.IsFinite(amount) then
		CAKE.Response(ply, TEXT.NotFiniteNumber)
		return ""
	end

	if amount < 1 then
		CAKE.Response(ply, TEXT.MustBeAtLeast1Token)
		return ""
	end

	if tonumber(ply:GetNWString("money")) < amount then
		CAKE.Response(ply, TEXT.NotEnoughTokens)
		return ""
	end

	CAKE.ChangeMoney(ply, -amount)

	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
	trace.filter = ply

	local tr = util.TraceLine(trace)
	local moneybag = ents.Create("token_bundle")
	moneybag:SetPos(tr.HitPos)
	moneybag:Spawn()
	moneybag:Setamount(amount)

	return ""
end

local function NewATM(ply, args)
	if ply:IsSuperAdmin() then
		local trace = ply:GetEyeTrace()
		local atm = ents.Create("atm")
		atm:SetPos(trace.HitPos + Vector(0, 0, 20))
		atm:Spawn()
		atm:SetColor(Color(0, 255, 0, 120))
		atm:SetRenderMode( RENDERMODE_TRANSALPHA )
	else
		CAKE.Response(ply, TEXT.SuperAdminOnly)
	end
	return ""
end

local function FreezeATM(ply, args)
	if ply:IsSuperAdmin() then
		local trace = ply:GetEyeTrace()
		
		if trace.Entity and trace.Entity:GetNWBool("ATM") then
			trace.Entity:SetColor(Color(0, 255, 0, 255))
			trace.Entity:GoToSleep()
			trace.Entity.ATMID = DB.NewATM(trace.Entity)
			CAKE.Response(ply, TEXT.ATMFrozen)
			CAKE.Response(ply, TEXT.ToRemoveThisATM)
		end
	else
		CAKE.Response(ply, TEXT.SuperAdminOnly)
	end
	return ""
end

local function QueryBalance(ply, args)
	local trace = ply:GetEyeTrace()

	if trace.Entity and trace.Entity:GetNWBool("ATM") then
		CAKE.Response(ply, TEXT.QueryBalance(CAKE.GetCharField(ply, "bank")))
	end
	return ""
end

local function DepositTokens(ply, args)
	local trace = ply:GetEyeTrace()

	if trace.Entity and trace.Entity:GetNWBool("ATM") then
		if args and tonumber(args) then
			local money = math.floor(tonumber(args))
			if not math.IsFinite(money) then
				CAKE.Response(ply, TEXT.NotFiniteNumber)
				return ""
			end
			if money < 0 then
				CAKE.Response(ply, TEXT.MustBeAtLeast1Token)
				return ""
			end
			local enough = CAKE.ChangeMoney(ply, -money)
			if not enough then
				CAKE.Response(ply, TEXT.NotEnoughTokens)
			else
				CAKE.ChangeBankMoney(ply, money)
				CAKE.Response(ply, TEXT.ConfirmDeposit(money))
			end
		end
	end
	return ""
end

local function WithdrawTokens(ply, args)
	local trace = ply:GetEyeTrace()

	if trace.Entity and trace.Entity:GetNWBool("ATM") then
		if args and tonumber(args) then
			args = math.floor(tonumber(args))
			local money = math.floor(tonumber(args))
			if not math.IsFinite(money) then
				CAKE.Response(ply, TEXT.NotFiniteNumber)
				return ""
			end
			if money < 0 then
				CAKE.Response(ply, TEXT.MustBeAtLeast1Token)
				return ""
			end
			local enough = CAKE.ChangeBankMoney(ply, -money)
			if not enough then
				CAKE.Response(ply, TEXT.NotEnoughInBank)
			else
				-- Spawn the money in front of the machine
				local tb = ents.Create("token_bundle")
				tb:SetPos(trace.Entity:GetPos() + (trace.Entity:GetForward() * 10))
				tb:SetNWString("Owner", "Shared")
				tb:Spawn()
				tb:Setamount(money)
				CAKE.Response(ply, TEXT.ConfirmWithdrawal(money))
			end
		end
	end
	return ""
end

local function TransferTokens(ply, args)
	local trace = ply:GetEyeTrace()

	if trace.Entity and trace.Entity:GetNWBool("ATM") then
		if args then
			local argTable = string.Explode("\\", args)
			if #argTable ~= 2 then
				CAKE.Response(ply, TEXT.TransferCorrection)
				return ""
			end
			local money = math.floor(tonumber(argTable[1]))
			if not math.IsFinite(money) then
				CAKE.Response(ply, TEXT.NotFiniteNumber)
				return ""
			end
			local targetPlayer = CAKE.FindPlayer(argTable[2])
			if money < 0 then
				CAKE.Response(ply, TEXT.MustBeAtLeast1Token)
				return ""
			end
			local enough = CAKE.ChangeBankMoney(ply, -money)
			if not enough then
				CAKE.Response(ply, TEXT.NotEnoughInBank)
			else
				CAKE.ChangeBankMoney(targetPlayer, money)
				CAKE.Response(targetPlayer, TEXT.X_HasGiven_Y_Tokens_YourBank(ply:Nick(), money))
				CAKE.Response(ply, TEXT.X_Tokens_Transferred_to_Y(money, targetPlayer:Nick()))
			end
		end
	end
	return ""
end

local function PayInterest()
	for k, v in pairs(player.GetAll()) do
		if IsValid(v) then
			local bank = tonumber(CAKE.GetCharField(v, "bank")) or 0
			local ip = tonumber(CAKE.ConVars.Default_Interest_Percentage) or 0
			local interest = math.floor((bank * ip) / 100.0)

			CAKE.ChangeBankMoney(v, interest)
			CAKE.Response(v, TEXT.BankInterestReceived(interest))
		end
	end
end

function PLUGIN.Init()
	CAKE.ChatCommand(TEXT.GiveCommand, GiveTokens)
	CAKE.ChatCommand(TEXT.DropTokensCommand, DropTokens)
	CAKE.ChatCommand(TEXT.DropTokensCommand2, DropTokens)
	CAKE.ChatCommand(TEXT.DropTokensCommand3, DropTokens)
	CAKE.ChatCommand(TEXT.DropTokensCommand4, DropTokens)

	CAKE.ChatCommand(TEXT.NewATMCommand, NewATM)
	CAKE.ChatCommand(TEXT.FreezeATMCommand, FreezeATM)

	CAKE.ChatCommand(TEXT.ATMBalanceCommand, QueryBalance)
	CAKE.ChatCommand(TEXT.ATMDepositCommand, DepositTokens)
	CAKE.ChatCommand(TEXT.ATMWithdrawCommand, WithdrawTokens)
	CAKE.ChatCommand(TEXT.ATMTransferCommand, TransferTokens)

	timer.Create("BankDepositInterest", CAKE.ConVars[ "Default_Interest_Period" ] * 60, 0, PayInterest)
end
