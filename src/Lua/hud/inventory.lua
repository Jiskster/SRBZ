SRBZ.inventoryhud = function(v, player)
	if gametype ~= GT_SRBZ then return end
	if not player.chosecharacter or player.choosing then return end
	if SRBZ.game_ended then return end
	if player["srbz_info"].ghostmode then return end
	
	local s_patch = v.cachePatch("CURWEAP")
	local sel = player["srbz_info"].inventory_selection
	local sel_x = 116*FU
	if sel > 1 then
		sel_x = $ + ((sel-1)*20*FU)
	end
	local sel_y = 176*FU
	
	for i=1,SRBZ:FetchInventoryLimit(player) do
		local x = 116*FU
		local y = 176*FU
		local overone_xpos = ((i-1)*20)*FU
		local iconscale = FU
		
		local patch
		
		if i > 1 then
			x = $ + overone_xpos
		end
		
		if SRBZ:FetchInventory(player)[i]
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
			v.drawStretched(x, y, iconscale, iconscale, patch, V_SNAPTOLEFT|V_SNAPTOBOTTOM)
		else
			v.drawStretched(x, y, iconscale, iconscale, patch, V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_TRANSLUCENT)
		end
	end
	
	-- weapon selection 
	v.drawStretched(sel_x-(2*FU), sel_y-(2*FU), FU, FU, s_patch, V_SNAPTOLEFT|V_SNAPTOBOTTOM)
end