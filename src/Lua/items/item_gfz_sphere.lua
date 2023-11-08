-- Render by Marilyn / Speccy

freeslot("MT_SRBZ_GFZSPHERE", "S_SRBZ_GFZSPHERE", "SPR_GFZS")

mobjinfo[MT_SRBZ_GFZSPHERE] = { 
	spawnstate = S_SRBZ_GFZSPHERE,
	--activesound = sfx_shgn,
	deathstate = S_SPRK1,
	xdeathstate = S_SPRK1,
	speed = 60*FRACUNIT,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_MISSILE|MF_NOGRAVITY
}

states[S_SRBZ_GFZSPHERE] = {
	nextstate = S_SRBZ_GFZSPHERE,
	sprite = SPR_GFZS,
	frame = FF_FULLBRIGHT|FF_ANIMATE,
	tics = -1,
	var1 = 3,
	var2 = 2,
}

SRBZ:CreateItem("GFZSPHERE",  {
	object = MT_SRBZ_GFZSPHERE,
	icon = "GFZSPHEREIND",
	firerate = 40,
	--color = SKINCOLOR_RED,
	knockback = 125*FRACUNIT,
	damage = 26,
	price = 920,
	sound = sfx_kc5b,
	ammo = 3,
	autouse = true,
	reload_time = TICRATE*4,
})