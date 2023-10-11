SRBZ.ItemPresets = {

}

function SRBZ:CreateItem(name,table)
	local temp_table
	if not name then
		error("Name not included.")
	end
	if type(name) ~= "string" then
		error("Arg1 is not a string.")
	end
	if not table then
		error("Table not found.")
	end
	if type(table) ~= "table" then
		error("Arg2 is not a table.")
	end
	temp_table = SRBZ:Copy(table) -- temp_table is supposed to add extra info before shipping.

	temp_table.item_id = #self.ItemPresets + 1
	temp_table.displayname = name
	if temp_table.count then
		temp_table.maxcount = temp_table.count
	end
	
	if temp_table.ammo then
		temp_table.max_ammo = temp_table.ammo
	end
	
	local idname = ("ITEM_"..name:upper()):gsub(" ","_"):gsub("'","")
	local idglobal = rawset(_G, idname, #self.ItemPresets + 1)
	self.ItemPresets[#self.ItemPresets + 1] = temp_table
	
	print("\x84SRBZ:".."\x82 Weapon ".."\""..name.." ("..idname..")".."\" included ["..(#self.ItemPresets).."]")
	return idglobal
end


function SRBZ:FetchInventory(player)
	if player and player.valid then
		if player["srbz_info"] then
			if player["srbz_info"].survivor_inventory and player.zteam == 1 then
				return player["srbz_info"].survivor_inventory
			elseif player["srbz_info"].zombie_inventory and player.zteam == 2 then
				return player["srbz_info"].zombie_inventory
			end
		end
	end
end

function SRBZ:FetchInventoryLimit(player)
	if player and player.valid then
		if player["srbz_info"] then
			if player.zteam == 1 then
				return player["srbz_info"].survivor_inventory_limit
			elseif player.zteam == 2 then
				return player["srbz_info"].zombie_inventory_limit
			end
		end
	end
	return 1
end

function SRBZ:FetchInventorySlot(player)
	if player and player.valid then
		if player["srbz_info"] and player["srbz_info"].inventory_selection then
			return SRBZ:FetchInventory(player)[player["srbz_info"].inventory_selection] 
		end
	end
end

function SRBZ:ChangeHealth(mobj, amount)
	if amount > mobj.maxhealth then
		mobj.health = mobj.maxhealth
	else
		mobj.health = $ + amount
	end
end

function SRBZ:ChangeStamina(player, amount)
	if amount + player.sprintmeter > 100*FRACUNIT then
		player.sprintmeter = 100*FRACUNIT
	else
		player.sprintmeter = $ + amount
	end
end

function SRBZ:IsInventoryFull(player)
	if player and player.valid then
		if player["srbz_info"] and SRBZ:FetchInventory(player) then
			if #SRBZ:FetchInventory(player) >= SRBZ:FetchInventoryLimit(player) then
				return true
			else
				return false
			end
		else
			return true
		end
	end
end

function SRBZ:CopyItemFromID(item_id)
	local item = SRBZ:Copy(SRBZ.ItemPresets[item_id]) or error("Invalid item_id.")
	item.ontrigger = nil
	item.onspawn = nil
	item.onhit = nil

	return item
end

function SRBZ:GiveItem(player, item_id, count, slot) 
	if player and player.valid then
		if not item_id or not SRBZ.ItemPresets[item_id] then
			CONS_Printf(player, "\x85\Invalid item! ["..item_id.."]")
		elseif player["srbz_info"] and SRBZ:FetchInventory(player) then
			local item = SRBZ:Copy(SRBZ.ItemPresets[item_id])

			--destroy functions
			item.ontrigger = nil
			item.onspawn = nil
			item.onhit = nil
			
			
			if count ~= nil then
				item.count = count
				item.limited = true
			end
			if slot then
				SRBZ:FetchInventory(player)[slot] = item
			else
				if not SRBZ:IsInventoryFull(player) then
					table.insert(SRBZ:FetchInventory(player), item)
				else
					CONS_Printf(player, "\x85\Inventory full!")
				end
			end
		elseif not SRBZ:FetchInventory(player) then
			CONS_Printf(player, "\x85\Invalid inventory!")
		end
	end
end