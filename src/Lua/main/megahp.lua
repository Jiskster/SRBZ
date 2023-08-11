freeslot("MT_MEGAHP", "S_MEGAHP", "SPR_MGAO", "sfx_maxhp")

mobjinfo[MT_MEGAHP] = {
	doomednum = 1472,
	spawnstate = S_MEGAHP,
	spawnhealth = 1,
	deathstate = S_RINGEXPLODE,
	deathsound = sfx_maxhp,
	xdeathstate = S_NULL,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	flags = MF_SPECIAL|MF_NOGRAVITY|MF_NOCLIPHEIGHT,
}

states[S_MEGAHP] = {
    sprite = SPR_MGAO,
    frame = FF_ANIMATE|A,
    tics = -1,
    var1 = 3, -- frame count
    var2 = 5, -- duration
}

sfxinfo[sfx_maxhp].caption="Max HP increased"

SRBZ.HitMegaHP = function(special, toucher)
	if toucher and toucher.valid and toucher.player and toucher.player.zteam and toucher.player.zteam == 1 then
		toucher.maxhealth = $ + 60
		toucher.health = toucher.maxhealth
	else
		return true
	end
end
