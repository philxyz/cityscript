-- CityScript - city_fire.lua
-- by philxyz 2008 - 2010
-- MIT License

PLUGIN.Name = "Spreadable Fire"; -- What is the plugin name
PLUGIN.Author = "philxyz"; -- Author of the plugin
PLUGIN.Description = "Spreadable fire code."; -- The description or purpose of the plugin

FlammableSENTs =
{
	"spawned_shipment",
	"spawned_weapon",
	"sent_nuke_detpack",
	"sent_nuke_part",
	"token_bundle",
	"token_printer",
	"item_prop"
}

function PLUGIN.Init()
end

function IsFlammable(ent)
	local class = ent:GetClass()

	if class == "prop_physics" then return true end

	for k, v in pairs(FlammableSENTs) do
		if class == v then return true end
	end

	return false
end

function FireSpread(e)
	if e:IsOnFire() then
		if e:GetTable().MoneyBag then
			for k, v in pairs(player.GetAll()) do
				CAKE.Response(v, TEXT.FireShock(e:GetTable().Amount))
			end
			e:Remove()
		end

		local en = ents.FindInSphere(e:GetPos(), math.random(20, 90))

		local maxcount = 3
		local count = 1
		local rand = 0

		for k, v in pairs(en) do
			if IsFlammable(v) and v:GetClass() ~= "atm" then
				if count >= maxcount then break end
				if math.random(0.0, 6000.0) < 1.0 then
					if not v.burned then
						v:Ignite(math.random(5,180), 0)
						v.burned = 1
					else
						local col = v:GetColor()
						if (col.r - 51)>=0 then col.r = col.r - 51 end
						if (col.g - 51)>=0 then col.g = col.g - 51 end
						if (col.b - 51)>=0 then col.b = col.b - 51 end
						v:SetColor(col)
						math.randomseed((col.r / (col.g+1)) + col.b)
						if (col.r+col.g+col.b) < 103 and math.random(1, 100) < 35 then
							v:Fire("enablemotion","",0)
							constraint.RemoveAll(v)
						end
					end
				end
			end
		end
	end
end

function FireThink()
	local php = ents.FindByClass("prop_physics")

	for k, v in pairs(php) do
		FireSpread(v)
	end

	for _, v in ipairs(FlammableSENTs) do
		local en = ents.FindByClass(v)

		for a, b in ipairs(en) do
			FireSpread(b)
		end
	end
end
hook.Add("Think", "FireThink", FireThink)
