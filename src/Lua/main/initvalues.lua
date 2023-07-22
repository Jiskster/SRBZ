freeslot("S_POSS_PAIN","S_POSS_PAIN2","S_SPOS_PAIN","S_SPOS_PAIN2")

states[S_POSS_PAIN] = {
	sprite = SPR_POSS,
	frame = A,
	tics = 15,
	action = A_PlaySound,
	var1 = sfx_dmpain,
	var2 = 1,
	nextstate = S_POSS_PAIN2
}

states[S_POSS_PAIN2] = {
	sprite = SPR_POSS,
	frame = A,
	tics = 0,
	action = A_SetObjectFlags2,
	var1 = MF2_FRET,
	var2 = 1,
	nextstate = S_POSS_RUN1
}
states[S_SPOS_PAIN] = {
	sprite = SPR_SPOS,
	frame = A,
	tics = 10,
	action = A_PlaySound,
	var1 = sfx_dmpain,
	var2 = 1,
	nextstate = S_SPOS_PAIN2
}

states[S_SPOS_PAIN2] = {
	sprite = SPR_POSS,
	frame = A,
	tics = 0,
	var1 = MF2_FRET,
	var2 = 1,
	action = A_SetObjectFlags2,
	nextstate = S_SPOS_RUN1
}

SRBZ.playerfunc = function(player)
	if gametype ~= GT_SRBZ and leveltime then return end
	local pmo = player.mo
	
	if player and player.mo.valid then
		SRBZ.SetCCtoplayer(player)
		SRBZ.SetCChealth(player)
	end
end

mobjinfo[MT_BLUECRAWLA].npc_name = "Blue Crawla"
mobjinfo[MT_BLUECRAWLA].min_spawnhealth = 2
mobjinfo[MT_BLUECRAWLA].max_spawnhealth = 7
mobjinfo[MT_BLUECRAWLA].painstate = S_POSS_PAIN
--
--S_POSS_PAIN2


mobjinfo[MT_REDCRAWLA].npc_name = "Red Crawla"
mobjinfo[MT_REDCRAWLA].min_spawnhealth = 5
mobjinfo[MT_REDCRAWLA].max_spawnhealth = 12
mobjinfo[MT_REDCRAWLA].painstate = S_SPOS_PAIN