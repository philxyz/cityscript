-- CityScript - city_earthquake.lua
-- by philxyz 2007-2010
-- MIT License

PLUGIN.Name = "Earthquake"; -- What is the plugin name
PLUGIN.Author = "philxyz"; -- Author of the plugin
PLUGIN.Description = "Earthquake code."; -- The description or purpose of the plugin

function PLUGIN.Init()
end

resource.AddFile("sound/earthquake.mp3")
util.PrecacheSound("earthquake.mp3")
quakechance = 8000
quakenotify = nil -- When the next quake report comes up
lastmagnitudes = {} -- The magnitudes of the last tremors

local next_update_time
local tremor = ents.Create("env_physexplosion")
tremor:SetPos(Vector(0,0,0))
tremor:SetKeyValue("radius",9999999999)
tremor:SetKeyValue("spawnflags", 7)
tremor:Spawn()

function TremorReport(alert)
	local mag = table.remove(lastmagnitudes, 1)
	if mag then
		print("Seismic activity: " .. tostring(mag) .. "Mw\n")
        end
end

function QuakeThink()
	if CurTime() > (next_update_time or 0) then
		local en = ents.FindByClass("prop_physics")
		local plys = ents.FindByClass("player")
		if math.random(0, quakechance) < 1 then
			local force = math.random(10,1000)
			tremor:SetKeyValue("magnitude", force/6)
			for k,v in pairs(plys) do
				v:EmitSound("earthquake.mp3", force/6, 100)
			end
			tremor:Fire("explode", "", 0.5)
			util.ScreenShake(Vector(0,0,0), force, math.random(25,50), math.random(5,12), 9999999999)
			table.insert(lastmagnitudes, math.floor((force / 10) + .5) / 10)
			timer.Simple(10, function() TremorReport(alert) end)
			for k, e in pairs(en) do
				if not IsValid(e) then
					continue
				end
				local rand = math.random(650,1000)
				if rand < force and rand % 2 == 0 then
					if e:GetClass() ~= "atm" then
						e:Fire("enablemotion", "", 0)
						constraint.RemoveAll(e)
					end
				end
				if e:IsOnGround() then
					e:TakeDamage((force / 100) + 15, game.GetWorld())
				end
			end
		end
		next_update_time = CurTime() + 1
	end
end
hook.Add("Think", "QuakeThink", QuakeThink)
