-- CityScript - city_fire.lua
-- by philxyz 2008 - 2010
-- MIT License

PLUGIN.Name = "Spreadable Fire"; -- What is the plugin name
PLUGIN.Author = "philxyz"; -- Author of the plugin
PLUGIN.Description = "Spreadable fire code from SeriousRP gamemode"; -- The description or purpose of the plugin

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

function LightOthers(igniter)
	-- Find all the props within a radius of 20 - 90 units of the burning prop
	math.randomseed(os.time())
	local nearbyEnts = ents.FindInSphere(igniter:GetPos(), math.random(20, 90))

	-- Sort them by closest first
	table.sort(nearbyEnts, function(a, b) return igniter:GetPos():Distance(a:GetPos()) < igniter:GetPos():Distance(b:GetPos()) end)

	-- If there is nothing in range, do nothing.
	if #nearbyEnts == 0 then return end

	-- Starting with the closest prop
	for _, prop in ipairs(nearbyEnts) do
		-- If the prop found is not the prop which is trying to
		-- spread its flames and the random number matches
		if prop:EntIndex() ~= igniter:EntIndex() and math.random(1, 7) == 1 then
			-- If the prop that the fire is trying to spread to
			-- has already been considered to be burned
			if prop.HasBurned then
				-- Darken it a little instead
				local col = prop:GetColor()
				if (col.r - 51)>=0 then col.r = col.r - 51 end
				if (col.g - 51)>=0 then col.g = col.g - 51 end
				if (col.b - 51)>=0 then col.b = col.b - 51 end
				prop:SetColor(col)
				math.randomseed(os.time())

				-- If it is burned enough by this point,
				-- break constraints so that burned structures collapse.
				if (col.r+col.g+col.b) < 103 and math.random(1, 100) < 35 then
					prop:Fire("enablemotion","",0)
					constraint.RemoveAll(prop)
				end
			else
				-- Set the prop on fire
				math.randomseed(os.time())
				if prop:IsPlayer() then
					-- Players should only burn for 3 seconds
					-- otherwise when they spawn, you can't
					-- put the fire out again and they die
					-- repeatedly
					prop:Ignite(3, 0)
				else
					-- This is a prop
					prop:Ignite(math.random(5, 180), 0)
					prop.HasBurned = true
				end

				-- When burning money, report a sad story.
				if prop:GetTable().MoneyBag then
					prop:Remove()
					for k, v in pairs(player.GetAll()) do
						CAKE.Response(v, TEXT.FireShock(e:GetTable().Amount))
					end
				end
			end

			break -- after igniting one prop, let the script continue
		end
	end
end

function FireThink()
	-- If the time to burn has not arrived, get out of the way
	if NextFireThink and
		CurTime() < NextFireThink then
		return
	end

	-- Are there any burning SENTs that are listed as flammable?
	-- These should spread their fire.
	for _, flam in ipairs(FlammableSENTs) do
		for _, prop in ipairs(ents.FindByClass(flam)) do
			if prop:IsOnFire() then
				LightOthers(prop)
			end
		end
	end

	-- Burning props should have the opportunity to spread their fire to
	-- one other prop (maybe)
	for _, prop in pairs(ents.FindByClass("prop_physics")) do
		if prop:IsOnFire() then
			LightOthers(prop)
		end
	end

	-- Calculate when the body of this hook should run next
	if NextFireThink == nil or CurTime() >= NextFireThink then
		NextFireThink = CurTime() + math.random(1.5, 3.78)
	end
end
hook.Add("Think", "FireThink", FireThink)
