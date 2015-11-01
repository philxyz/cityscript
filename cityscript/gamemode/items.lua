CAKE.ItemData = {}

function CAKE.LoadItem(schema, filename)
	local path = "schemas/" .. schema .. "/items/" .. filename
	ITEM = {}
	include(path)
	
	CAKE.ItemData[ITEM.Class] = ITEM
end

function CAKE.CreateItem(ply, class, pos, ang, fromBackpack)
	if CAKE.ItemData[class] == nil then return; end
	
	local itemtable = CAKE.ItemData[class]

	local item
	
	if itemtable.ContentClass then
		-- It's a Shipment
		item = ents.Create("spawned_shipment")
		item:SetContents(itemtable.ContentClass, itemtable.ContentCount, itemtable.ContentItemWeight)
	elseif itemtable.VehicleScript then
		-- It's a Vehicle
		item = ents.Create(itemtable.VehicleClass)
		item:SetKeyValue("vehiclescript", itemtable.VehicleScript)
		item:SetNWString("Owner", "Shared") -- Do this explicitly for vehicles
	else
		item = ents.Create(itemtable.Sent or "item_prop")
	end

	local wepTable = weapons.GetStored(itemtable.Class)
	if not wepTable then
		wepTable = scripted_ents.GetStored(itemtable.Class)
		if wepTable then
			wepTable = wepTable.t or scripted_ents.Get(itemtable.Class)
		end
	end

	if wepTable ~= nil then
		if wepTable.Primary ~= nil then
			item:SetNWInt("Clip1A", (fromBackpack and 0) or wepTable.Primary.DefaultClip or 0)
			item:SetNWInt("PAmmoType", game.GetAmmoID(wepTable.Primary.Ammo or 0) or "")
		end

		if wepTable.Secondary ~= nil then
			item:SetNWInt("Clip2A", (fromBackpack and 0) or wepTable.Secondary.DefaultClip or 0)
			item:SetNWInt("SAmmoType", game.GetAmmoID(wepTable.Secondary.Ammo or 0) or "")
		end
	end

	if item:GetClass() == "storage_box" then item.ply = ply end

	item:SetNWInt("ownIndex", ply:EntIndex())
	item:SetModel(itemtable.Model)
	item:SetAngles(ang)
	item:SetPos(pos)
	item.SID = ply.SID
	
	for k, v in pairs(itemtable) do
		item[k] = v
		if type(v) == "string" then
			item:SetNWString(k, v)
		end
	end
	
	item:Spawn()
	item:Activate()

	if itemtable.VehicleExtras then
		item:Fire("setbodygroup", itemtable.VehicleExtras)
	end

	return item
end

function ccCreateItem(ply, cmd, args)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		-- Drop the item 80 units infront of him.
		CAKE.CreateItem(ply, args[1], ply:CalcDrop(), Angle(0, 0, 0))
	end
end
concommand.Add("rp_createitem", ccCreateItem)

function ccDropItem(ply, cmd, args)
	local inv = CAKE.GetCharField(ply, "inventory")

	print("Dropping item: " .. args[1])

	for k, v in pairs(inv) do
		-- If an item matches in the inventory
		if v == args[1] then
			-- Produce it.
			CAKE.CreateItem(ply, args[1], ply:CalcDrop(), Angle(0, 0, 0), true)
			ply:TakeItem(args[1])
			break
		end
	end
	
end
concommand.Add("rp_dropitem", ccDropItem)

function ccBuyItem(ply, cmd, args)
	if CAKE.ItemData[args[1]] ~= nil then
		if CAKE.Teams[ply:Team()].business then
			if table.HasValue(CAKE.Teams[ply:Team()].item_groups, CAKE.ItemData[args[1]].ItemGroup) then
				if CAKE.ItemData[args[1]].Purchaseable and tonumber(CAKE.GetCharField(ply, "money")) >= CAKE.ItemData[args[1]].Price then
					CAKE.ChangeMoney(ply, 0 - CAKE.ItemData[args[1]].Price)
					CAKE.CreateItem(ply, args[1], ply:CalcDrop(), Angle(0, 0, 0))
				else
					CAKE.Response(ply, "You do not have enough money to purchase this item!")
				end
			else
				CAKE.Response(ply, "You cannot purchase this item!")
			end
		else
			CAKE.Response(ply, "You do not have access to Business!")
		end
	end
end
concommand.Add("rp_buyitem", ccBuyItem)
