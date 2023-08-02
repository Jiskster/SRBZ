SRBZ.inventoryhud = function(v, player)
	if gametype ~= GT_SRBZ then return end
	if not player.chosecharacter or player.choosing then return end
	
	local s_patch = v.cachePatch("CURWEAP")
	local sel = player["srbz_info"].inventory_selection
	local sel_x = 116*FU
	if sel > 1 then
		sel_x = $ + ((sel-1)*20*FU)
	end
	local sel_y = 176*FU
	
	for i=1,player["srbz_info"].inventory_limit do
		local x = 116*FU
		local y = 176*FU
		local overone_xpos = ((i-1)*20)*FU
		local patch
		
		if i > 1 then
			x = $ + overone_xpos
		end
		
		if player["srbz_info"].inventory[i]
			if player["srbz_info"].inventory[i].icon then
				patch = v.cachePatch(player["srbz_info"].inventory[i].icon)
			else
				patch = v.cachePatch("BLANKIND")
			end
		else
			patch = v.cachePatch("BLANKIND")
		end
		
		if player["srbz_info"].inventory[i] then
			v.drawStretched(x, y, FU, FU, patch, V_SNAPTOLEFT|V_SNAPTOBOTTOM)
		else
			v.drawStretched(x, y, FU, FU, patch, V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_TRANSLUCENT)
		end
	end
	/*
	for i,value in ipairs(player["srbz_info"].inventory) do
		if i > player["srbz_info"].inventory_limit then 
			-- dont show more than what you need
			continue
		end
		local x = 116*FU
		local y = 176*FU
		local overone_xpos = ((i-1)*20)*FU
		local patch = v.cachePatch(player["srbz_info"].inventory[i].icon)
		
		if i > 1 then
			x = $ + overone_xpos
		end
		
		-- weapon icon
		v.drawStretched(x, y, FU, FU, patch, V_SNAPTOLEFT|V_SNAPTOBOTTOM)
	end
	*/
	-- selection
	v.drawStretched(sel_x-(2*FU), sel_y-(2*FU), FU, FU, s_patch, V_SNAPTOLEFT|V_SNAPTOBOTTOM)
end