include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

net.Receive("C6", function(_, ply)
	local et = LocalPlayer():GetEyeTrace().Entity
	local ContextMenu = DermaMenu()
	ContextMenu:SetPos(ScrW()/2, ScrH()/2)
	if LocalPlayer():IsSuperAdmin() and IsValid(et) and et:GetMoveType() == MOVETYPE_VPHYSICS then
		ContextMenu:AddOption(TEXT.AdminFreezeATM, function()
			RunConsoleCommand("say", TEXT.FreezeATMCommand)
		end)
	end
	ContextMenu:AddOption(TEXT.ShowBalance, function()
		RunConsoleCommand("say", TEXT.ATMBalanceCommand)
	end)
	ContextMenu:AddOption(TEXT.WithdrawTokens, function()
		-- Obtain the amount to withdraw
		Derma_StringRequest(TEXT.MakeAWithdrawal,
			TEXT.HowManyTokens,
			"",
			function(amount)
				if amount == "" or not tonumber(amount) then return end
				RunConsoleCommand("say", TEXT.ATMWithdrawCommand .. " " .. amount)
			end
		)
	end)
	ContextMenu:AddOption(TEXT.DepositTokens, function()
		-- Obtain the amount to deposit
		Derma_StringRequest(TEXT.MakeADeposit,
			TEXT.HowManyTokens,
			"",
			function(amount)
				if amount == "" or not tonumber(amount) then return end
				RunConsoleCommand("say", TEXT.ATMDepositCommand .. " " .. amount)
			end
		)
	end)
	ContextMenu:AddOption(TEXT.TransferTokens, function()
		-- Obtain the amount to transfer
		Derma_StringRequest(TEXT.MakeATransfer,
			TEXT.HowManyTokens,
			"",
			function(amount)
				Derma_StringRequest(TEXT.ToWhichPlayer,
				TEXT.Name .. ":",
				"",
				function(name)
					if amount == "" or not tonumber(amount) then return end
					RunConsoleCommand("say", TEXT.ATMTransferCommand .. " " .. amount .. "\\" .. name)
				end
				)
			end
		)
	end)
	if LocalPlayer():IsSuperAdmin() then
		ContextMenu:AddOption(TEXT.AdminRemoveATM, function()
			RunConsoleCommand("say", TEXT.RemoveATMCommand)
		end)
	end
	ContextMenu:Open()
end)
