PLUGIN.Name = "Setmoney"; -- What is the plugin name
PLUGIN.Author = "philxyz"; -- Author of the plugin
PLUGIN.Description = "rp_admin setmoney command"; -- The description or purpose of the plugin

function PLUGIN.Init()
end

function SetMoneyFunc(ply, cmd, args)
	if args[1] then
		local p = CAKE.FindPlayer(args[1])
		if p then
			if args[2] and tonumber(args[2]) then
				if CAKE.SetMoney(p,  tonumber(args[2])) == false then
					CAKE.Response(ply, TEXT.InvalidAmount)
				else
					CAKE.Response(ply, TEXT.SetMoneyChange(p:Name(), args[2]))
				end
			else
				CAKE.Response(ply, TEXT.BadArgumentTokenAmount)
			end
		else
			CAKE.Response(ply, TEXT.TargetNotFound)
		end
	else
		CAKE.Response(ply, TEXT.SetMoneyUsedIncorrectly)
	end
end

CAKE.AdminCommand("setmoney", SetMoneyFunc, TEXT.SetMoneyCommandAbout, true, true, true)