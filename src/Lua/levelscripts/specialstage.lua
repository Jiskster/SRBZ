local ss_mapnum = G_FindMapByNameOrCode("MAPJ6")


local function SS_Tele1()
      for player in players.iterate
	   if (player.zteam == 1) then
	      P_SetOrigin(player.mo, -29024*FRACUNIT, 31648*FRACUNIT, 0*FRACUNIT) 
       end
	   if (player.zteam == 2) then
	      P_SetOrigin(player.mo, -30304*FRACUNIT, 27040*FRACUNIT, 0*FRACUNIT) 
	   end
	end
end

local function SS_Tele2()
	for player in players.iterate
		if (player.zteam == 1) then
			P_SetOrigin(player.mo, -28576*FRACUNIT, 31648*FRACUNIT, 0*FRACUNIT) 
		elseif (player.zteam == 2) then
			P_SetOrigin(player.mo, -30304*FRACUNIT, 27040*FRACUNIT, 0*FRACUNIT) 
		end
	end
end

local function SS_Tele3()
	for player in players.iterate
		if (player.zteam == 1) then
			P_SetOrigin(player.mo, -28128*FRACUNIT, 31648*FRACUNIT, 0*FRACUNIT) 
		elseif (player.zteam == 2) then
			P_SetOrigin(player.mo, -30304*FRACUNIT, 27040*FRACUNIT, 0*FRACUNIT) 
		end
	end
end

local function SS_Objection1()
	chatprint("\x83\Multiplayer Special Stage 1")
	chatprint("Survive for\x83 60 \x80seconds")
	SRBZ.AddMapTimer(
		"Special Stage 1",
		ss_mapnum,
		60*TICRATE,
		function(timernum,timername)
			SS_Tele1()
			P_LinedefExecute(43)
			P_LinedefExecute(49)
		end,
		{color = SKINCOLOR_MINT}
	)
end

local function SS_Objection2()
	chatprint("\x81\Multiplayer Special Stage 2")
	chatprint("Survive for\x83 60 \x80seconds")
	SRBZ.AddMapTimer(
		"Special Stage 2",
		ss_mapnum,
		60*TICRATE,
		function(timernum,timername)
			SS_Tele2()
			P_LinedefExecute(52)
			P_LinedefExecute(44)
		end,
		{color = SKINCOLOR_BUBBLEGUM}
	)
end

local function SS_Objection3()
	chatprint("\x84\Multiplayer Special Stage 3")
	chatprint("Survive for\x85 120 \x80seconds")
	SRBZ.AddMapTimer(
		"Special Stage 3",
		ss_mapnum,
		120*TICRATE,
		function(timernum,timername)
			SS_Tele3()
			P_LinedefExecute(53)
			P_LinedefExecute(46)
		end,
		{color = SKINCOLOR_SKY}
	)
end

local function SS_Objection4()
	chatprint("\x82\Multiplayer Special Stage 4")
	chatprint("Survive for\x85 120 \x80seconds")
	SRBZ.time_limit = SRBZ.game_time + 120*TICRATE
end

addHook("LinedefExecute", SS_Objection1, "45ACT1")
addHook("LinedefExecute", SS_Objection2, "45ACT2")
addHook("LinedefExecute", SS_Objection3, "45ACT3")
addHook("LinedefExecute", SS_Objection4, "45ACT4")