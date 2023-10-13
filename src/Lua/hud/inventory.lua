SRBZ.inventoryhud = function(v, player)
	if gametype ~= GT_SRBZ then return end
	if player.choosing then return end
	if SRBZ.game_ended then return end
	
	if player["srbz_info"].ghostmode then return end
	
	if player and not player.mo then return end
	
	local s_patch = v.cachePatch("CURWEAP")
	local cyan_patch = v.cachePatch("Z_CYANSQUARE")
	local sel = player["srbz_info"].inventory_selection
	local sel_x = 116*FU
	if sel > 1 then
		sel_x = $ + ((sel-1)*20*FU)
	end
	local sel_y = 176*FU
	
	if SRBZ:FetchInventoryLimit(player) and type(SRBZ:FetchInventoryLimit(player)) == "number" then
		for i=1,SRBZ:FetchInventoryLimit(player) do
			local x = 116*FU
			local y = 176*FU
			local overone_xpos = ((i-1)*20)*FU
			local iconscale = FU
			
			if player.shop_open then 
				y = 146*FU
				sel_y = y
			end
			local patch
			
			if i > 1 then
				x = $ + overone_xpos
			end
			
			if SRBZ:FetchInventory(player)[i] then
				if SRBZ:FetchInventory(player)[i].icon then
					patch = v.cachePatch(SRBZ:FetchInventory(player)[i].icon)
				else
					patch = v.cachePatch("BLANKIND")
				end
				if SRBZ:FetchInventory(player)[i].iconscale then
					iconscale = SRBZ:FetchInventory(player)[i].iconscale
				end
			else
				patch = v.cachePatch("BLANKIND")
			end
			
			-- weapon icons
			if SRBZ:FetchInventory(player)[i] then
				v.drawStretched(x, y, iconscale, iconscale, patch, V_SNAPTOBOTTOM)
			else
				v.drawStretched(x, y, iconscale, iconscale, patch, V_SNAPTOBOTTOM|V_TRANSLUCENT)
			end

			if SRBZ:FetchInventory(player)[i] then
				-- item count
				if SRBZ:FetchInventory(player)[i].count and SRBZ:FetchInventory(player)[i].limited then
					local count = tostring(SRBZ:FetchInventory(player)[i].count)
					customhud.CustomFontString(v,x,y,count, "TNYFC", V_SNAPTOBOTTOM, nil, FRACUNIT, SKINCOLOR_CLOUDY)
					--v.drawString(x, y, tostring(SRBZ:FetchInventory(player)[i].count), V_SNAPTOBOTTOM, "thin-fixed")
				elseif SRBZ:FetchInventory(player)[i].ammo ~= nil then -- ammo count
					local ammo = tostring(SRBZ:FetchInventory(player)[i].ammo)
					
					if SRBZ:FetchInventory(player)[i].ammo then
						v.drawString(x, y, ammo, V_SNAPTOBOTTOM, "thin-fixed")
						customhud.CustomFontString(v,x,y,ammo, "TNYFC", V_SNAPTOBOTTOM, nil, FRACUNIT, SKINCOLOR_AQUAMARINE)
					else
						if (leveltime/4)%2 == 0 then
							customhud.CustomFontString(v,x,y,ammo, "TNYFC", V_SNAPTOBOTTOM, nil, FRACUNIT, SKINCOLOR_CRIMSON)
						else
							customhud.CustomFontString(v,x,y,ammo, "TNYFC", V_SNAPTOBOTTOM, nil, FRACUNIT, SKINCOLOR_AQUAMARINE)
						end
					end
				end
			end
		end
	end
	
	if SRBZ:FetchInventorySlot(player) and SRBZ:FetchInventorySlot(player).displayname then
		local iteminfo = ""
		local itemname = SRBZ:FetchInventorySlot(player).displayname
		local itemcolor = SRBZ:FetchInventorySlot(player).color or SKINCOLOR_CLOUDY
		
		if SRBZ:FetchInventorySlot(player).damage then
			iteminfo = $ + "Damage: "..SRBZ:FetchInventorySlot(player).damage.." "
		end
		
		customhud.CustomFontString(v,115*FU,sel_y-(10*FU),itemname, "TNYFC", V_SNAPTOBOTTOM, nil, FRACUNIT, itemcolor)
		customhud.CustomFontString(v,115*FU,sel_y-(18*FU),iteminfo, "TNYFC", V_SNAPTOBOTTOM, nil, FRACUNIT, SKINCOLOR_CRIMSON)
	else
		customhud.CustomFontString(v,115*FU,sel_y-(10*FU),"EMPTY", "TNYFC", V_SNAPTOBOTTOM, nil, FRACUNIT, SKINCOLOR_CLOUDY)
	end
	
	-- weapon selection 
	v.drawStretched(sel_x-(2*FU), sel_y-(2*FU), FU, FU, s_patch, V_SNAPTOBOTTOM)
	if SRBZ:FetchInventorySlot(player) then
		if player["srbz_info"].reload then
			local slotreload = SRBZ:FetchInventorySlot(player).reload_time or 10
			local reload_div = FU - min(FixedDiv(player["srbz_info"].reload, slotreload),FU)
			v.drawStretched(sel_x, sel_y, reload_div, FU, cyan_patch, V_SNAPTOBOTTOM|V_50TRANS)
		elseif player["srbz_info"].weapondelay then
			local slotdelay = SRBZ:FetchInventorySlot(player).firerate
			local delay_div = min(FixedDiv(player["srbz_info"].weapondelay, slotdelay),FU)
			v.drawStretched(sel_x, sel_y, delay_div, FU, cyan_patch, V_SNAPTOBOTTOM|V_50TRANS)
		end
	end
end