local round_active = false
local hud_icon_scale = FU+(FU/4)

addHook("MapLoad", function()
	for player in players.iterate do
		player.choosing = true
		player.chosecharacter = false
	end
end)

SRBZ.getCharacterSelection = function(player)
	return player.selection or 1
end

SRBZ.getSkinFromCharSelect = function(player)
	return skins[SRBZ.getSkinNames(player, true)[player.selection]] or skins["sonic"]
end

SRBZ.characterselecthud = function(v, player, c)
	if SRBZ.round_active then return end 
	if gametype ~= GT_SRBZ then return end
    local pmo = player.mo 
    if not pmo then 
        return
    end

    local cursorpatch = v.cachePatch("CURWEAP")
	local barpatch = v.cachePatch("DABARR")
    local skincount = #SRBZ.getSkinNums(player,true)
	
	if player.chosecharacter then
		return
	end

	local cc = SRBZ.CharacterConfig
	
	--Blue Bar
	v.drawStretched(0, 17*FRACUNIT, 1500*FRACUNIT, FRACUNIT*3, barpatch, V_SNAPTOTOP|V_SNAPTOLEFT)
	
	--Icons
    for i,skinname in ipairs(SRBZ.getSkinNames(player,true)) do
        local sel = SRBZ.getCharacterSelection(player)
		local x
		if player.selection_anim ~= nil and player.prevselection then
			local ese = ease.outexpo(FixedDiv(player.selection_anim*FRACUNIT, ((TICRATE/2)*FRACUNIT)), 
			 (player.prevselection*25)*FRACUNIT, (player.selection*25)*FRACUNIT)
			x = (( (157) + (i*25) ) * FRACUNIT) - (ese) --(sel*25)*FRACUNIT
		else
			x = (( (157) + (i*25) ) * FRACUNIT) - ((sel*25)*FRACUNIT) 
		end
		--- (skincount*25)
        local y = 20*FRACUNIT
		+ 16*FRACUNIT -- the extra 16 fracunit is the offset
        local scale = hud_icon_scale
        local skinpatch = v.getSprite2Patch(skinname, SPR2_LIFE)
        
        local flags = V_SNAPTOTOP
		local colormap = v.getColormap(skinname, skins[SRBZ.getSkinNums(player,true)[i]].prefcolor)
        v.drawScaled(x, y, scale, skinpatch, flags, colormap)
		
		--
    end

	--Selection Square
    do
        local skincount = #SRBZ.getSkinNums(player,true)
		
        local x = ( (145) ) * FU --- skincount*25
        local y = 20*FU

        local scale = hud_icon_scale
        
        local flags = V_SNAPTOTOP

        
        v.drawScaled(x, y, scale, cursorpatch, flags)
    end
	
	local the_color = SRBZ.getSkinFromCharSelect(player).prefcolor
	local the_name = SRBZ.getSkinFromCharSelect(player).realname
	customhud.CustomFontString(v, 160*FU, 0, the_name, "STCFC", (V_SNAPTOTOP), "center" , 2*FRACUNIT, the_color)

	local charinfo_text = {
		[1] = {
			textcolor = SRBZ.getSkinFromCharSelect(player).prefcolor,
			text = SRBZ.getSkinFromCharSelect(player).realname
		},
		[2] = {
			textcolor = SKINCOLOR_GREEN,
			text = "Spawn HP: ".. (
				(cc[SRBZ.getSkinFromCharSelect(player).name] and cc[SRBZ.getSkinFromCharSelect(player).name].health) 
				
				and cc[SRBZ.getSkinFromCharSelect(player).name].health 
				
				or "[UNREGISTERED HP]"
			)
		},
		[3] = {
			textcolor = SKINCOLOR_TEAL,
			text = "Speed: ^".. (
				(cc[SRBZ.getSkinFromCharSelect(player).name] and cc[SRBZ.getSkinFromCharSelect(player).name].normalspeed) 
				
				and L_FixedDecimal(cc[SRBZ.getSkinFromCharSelect(player).name].normalspeed,2)
				
				or "[UNREGISTERED SPEED]"
			)
		},
		[4] = {
			textcolor = SKINCOLOR_ICY,
			text = "Sprint Increment: +".. (
				(cc[SRBZ.getSkinFromCharSelect(player).name] and cc[SRBZ.getSkinFromCharSelect(player).name].sprintboost) 
				
				and L_FixedDecimal(cc[SRBZ.getSkinFromCharSelect(player).name].sprintboost,2)
				
				or "[UNREGISTERED SPRINT SPEED]"
			)
		}

	}

	for i=1,#charinfo_text do
		local t_ese_div = FixedDiv(player.selection_anim*FRACUNIT, ((TICRATE/2)*FRACUNIT))
		local t_ese = ease.outexpo(t_ese_div, 640*FRACUNIT, 320*FRACUNIT)
		local output_color = charinfo_text[i].textcolor or SKINCOLOR_GREY
		local output_text = charinfo_text[i].text or "????", "STCFC"
		customhud.CustomFontString(v, t_ese, 50*FU + (i*(8*FU)), output_text, "TNYFC", (V_SNAPTORIGHT|V_SNAPTOTOP), "right", FU, output_color)
	end

	if leveltime > SRBZ.charselect_waittime	then
		local offset = sin(ANG1*(leveltime*3))*3 
		local offset2 = cos(ANG1*(leveltime*3))*3
		local x = (160*FU) + offset
		local y = (160*FU) + offset2
		local text = "Press FORWARD to continue."
		customhud.CustomFontString(v,x,y,text, "TNYFC", (V_SNAPTOTOP|V_TRANSLUCENT), "center" , FRACUNIT, SKINCOLOR_GREY)
	end
end