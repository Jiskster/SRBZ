SRBZ.infohud = function(v, player)
	if gametype ~= GT_SRBZ then return end
	if SRBZ.game_ended then return end
	if player.shop_open then return end
	if player and not player.mo then return end
	
	local skinpatch = v.getSprite2Patch(player.mo.skin, SPR2_XTRA)
	local hppatch = v.cachePatch("SRBZHPBAR1")
	local timeemb = v.cachePatch("NGRTIMER")
	local the_time 
	local colormap = v.getColormap(skinname, player.mo.color)
	
	local health = player.mo.health
	local maxhealth = player.mo.maxhealth
	
	if SRBZ.round_active then
		if SRBZ.time_limit then
			the_time = G_TicsToMTIME(SRBZ.time_limit - SRBZ.game_time)
		else
			the_time = G_TicsToMTIME(SRBZ.game_time)
		end
	else
		the_time = G_TicsToMTIME(SRBZ.wait_time - leveltime)
	end
	
	if player.chosecharacter or not player.choosing then
		if not player["srbz_info"].ghostmode then
			-- [Player Icon] --
		
			v.drawScaled(0, 176*FRACUNIT, FixedDiv(3*FRACUNIT, 4*FRACUNIT),
			skinpatch, (V_SNAPTOBOTTOM|V_SNAPTOLEFT), colormap)
			-- [Player Name] --
			customhud.CustomFontString(v, 24, 192, 
			skins[player.mo.skin].realname, "TNYFC", 
			(V_SNAPTOBOTTOM|V_SNAPTOLEFT), nil , nil, player.skincolor)
			
			-- [Rubies] --
			if player.rubies ~= nil then
				customhud.CustomFontString(v, 24, 184, "Rubies: "..player.rubies, "TNYFC", 
				(V_SNAPTOBOTTOM|V_SNAPTOLEFT), nil , nil, SKINCOLOR_RED)
			end
			
			-- [Sprint Meter] --
			if player.sprintmeter ~= nil and player.zteam == 1 then
				local sprintmeter = L_FixedDecimal(player.sprintmeter,1).."%"
				customhud.CustomFontString(v, 0, 168, "Run: "..sprintmeter, "TNYFC", 
				(V_SNAPTOBOTTOM|V_SNAPTOLEFT), nil , nil, SKINCOLOR_SKY)
			end
			
			-- [Health] --
			local healthstring = "+ "..health.."/"..maxhealth
			customhud.CustomFontString(v, 24, 176, healthstring, "TNYFC", 
			(V_SNAPTOBOTTOM|V_SNAPTOLEFT), nil , nil, SKINCOLOR_GREEN)
			
						
			-- [Survivor Count] --			
			v.drawStretched((138-28-7)*FU, 2*FU, 16*FU, 6*FU, v.cachePatch("Z_BG_BLUE"), 
			V_SNAPTOTOP)
			
			customhud.CustomFontString(v, 138-28, 1, tostring(SRBZ.SurvivorCount()), "STCFC", 
			(V_SNAPTOTOP), "center" , nil, SKINCOLOR_BLUE)
			

			
			-- [Zombie Count] --
			
			v.drawStretched((138+64-7)*FU, 2*FU, 16*FU, 6*FU, v.cachePatch("Z_BG_RED"), 
			V_SNAPTOTOP)
			
			customhud.CustomFontString(v, 138+64, 1, tostring(SRBZ.ZombieCount()), "STCFC", 
			(V_SNAPTOTOP), "center" , nil, SKINCOLOR_RED)
			

			
		end
		
		-- [Timer] --
		if the_time ~= nil then
			-- Time
			customhud.CustomFontString(v, 150, 1, the_time, "STCFC", 
			(V_SNAPTOTOP), nil , nil, SKINCOLOR_BEIGE)
			
			-- Clock Icon
			v.drawScaled(138*FRACUNIT, 0, FRACUNIT,
			timeemb, (V_SNAPTOTOP))
		end
		-- [Event Timer HUD] --
		
		for i,timer in ipairs(SRBZ.MapTimers) do 
			local event_name_string = ("# "..timer.name.." #") or "Event Name Error"
			local event_time_string = ("* "..G_TicsToMTIME(timer.time).." *") or "Failed To Get Event Time"
			local event_color
			if timer.extrainfo then
				event_color = timer.extrainfo.color or SKINCOLOR_TEAL
			else
				event_color = SKINCOLOR_TEAL
			end
			
			customhud.CustomFontString(v, 160, 10+((i-1)*16), (event_name_string), "STCFC", 
			(V_SNAPTOTOP), "center" , nil, event_color)
			
			-- Time
			customhud.CustomFontString(v, 160, 18+((i-1)*16), (event_time_string), "STCFC", 
			(V_SNAPTOTOP), "center" , nil, event_color)
		end
	else
		if the_time ~= nil then
			-- Time
			customhud.CustomFontString(v, 300, 6, the_time, "STCFC", 
			(V_SNAPTOTOP|V_SNAPTORIGHT), "right" , nil, SKINCOLOR_BEIGE)
			
			-- Clock Icon
			v.drawScaled(300*FRACUNIT, 5*FRACUNIT, FRACUNIT,
			timeemb, (V_SNAPTOTOP|V_SNAPTORIGHT))
		end
	end
end
