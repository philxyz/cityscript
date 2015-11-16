CAKE.ItemData = {}

function CAKE.LoadItem(schema, filename)
	local path = "schemas/" .. schema .. "/items/" .. filename
	ITEM = {}
	include(path)
	
	CAKE.ItemData[ITEM.Class] = ITEM
end

function CAKE.CreateItem(ply, class, pos, ang, ammo1, ammo2)
	if CAKE.ItemData[class] == nil then return end
	
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
			item:SetNWInt("Clip1A", ammo1 or 0)
			item:SetNWInt("PAmmoType", game.GetAmmoID(wepTable.Primary.Ammo or 0) or "")
		end

		if wepTable.Secondary ~= nil then
			item:SetNWInt("Clip2A", ammo2 or 0)
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

-- Drop inventory item
net.Receive("Ce", function(len, ply)
	local item = net.ReadString()
	local inv = CAKE.GetCharField(ply, "inventory")

	for k, v in pairs(inv) do
		-- If an item matches in the inventory
		if v == item then
			-- Produce it.
			CAKE.CreateItem(ply, item, ply:CalcDrop(), Angle(0, 0, 0))
			ply:TakeItem(item)
			break
		end
	end
end)

-- Equip inventory item
net.Receive("Cq", function(_, ply)
	local classname = net.ReadString()
	local inv = CAKE.GetCharField(ply, "inventory")

	for _, v in pairs(inv) do
		if v == classname then
			local wepTable = weapons.GetStored(v)
                	if not wepTable then
                        	wepTable = scripted_ents.GetStored(v)
                        	if wepTable then
                                	wepTable = wepTable.t or scripted_ents.Get(v)
                        	end
                	end

                	if wepTable and not wepTable.IncludeAmmo then
                        	if wepTable.Primary then
                                	wepTable.Primary.DefaultClip = 0
                        	end

                        	if wepTable.Secondary then
                                	wepTable.Secondary.DefaultClip = 0
                        	end
                	end

			ply:Give(v)
			ply:TakeItem(v)

			break
		end
	end
end)

-- Buy Item (as named by class)
net.Receive("Cd", function(len, ply)
	local item = net.ReadString()
	if CAKE.ItemData[item] ~= nil then
		if CAKE.Teams[ply:Team()].business then
			if table.HasValue(CAKE.Teams[ply:Team()].item_groups, CAKE.ItemData[item].ItemGroup) then
				if CAKE.ItemData[item].Purchaseable and tonumber(CAKE.GetCharField(ply, "money")) >= CAKE.ItemData[item].Price then
					CAKE.ChangeMoney(ply, 0 - CAKE.ItemData[item].Price)
					CAKE.CreateItem(ply, item, ply:CalcDrop(), Angle(0, 0, 0))
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
end)
