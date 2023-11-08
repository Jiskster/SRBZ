-- Ported From RSNEO

freeslot(
"MT_SRBZ_THROWNSCATTER",
"S_SRBZ_THROWNSCATTER1",
"S_SRBZ_THROWNSCATTER2",
"S_SRBZ_THROWNSCATTER3",
"S_SRBZ_THROWNSCATTER4",
"S_SRBZ_THROWNSCATTER5",
"S_SRBZ_THROWNSCATTER6",
"S_SRBZ_THROWNSCATTER7"
)

freeslot("sfx_shgn")

sfxinfo[sfx_shgn].caption = "Shotgun"

-- totally not from ringslinger neo
mobjinfo[MT_SRBZ_THROWNSCATTER] = { 
	spawnstate = S_SRBZ_THROWNSCATTER1,
	--activesound = sfx_shgn,
	deathstate = S_SPRK1,
	xdeathstate = S_SPRK1,
	speed = 60*FRACUNIT,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_MISSILE|MF_NOGRAVITY
}

states[S_SRBZ_THROWNSCATTER1] = {
	nextstate = S_SRBZ_THROWNSCATTER2,
	sprite = SPR_TSCR,
	frame = FF_FULLBRIGHT,
	tics = 1,
}
states[S_SRBZ_THROWNSCATTER2] = {
	nextstate = S_SRBZ_THROWNSCATTER3,
	sprite = SPR_TSCR,
	frame = FF_FULLBRIGHT,
	tics = 1,
}
states[S_SRBZ_THROWNSCATTER3] = {
	nextstate = S_SRBZ_THROWNSCATTER4,
	sprite = SPR_TSCR,
	frame = FF_FULLBRIGHT,
	tics = 1,
}
states[S_SRBZ_THROWNSCATTER4] = {
	nextstate = S_SRBZ_THROWNSCATTER5,
	sprite = SPR_TSCR,
	frame = FF_FULLBRIGHT,
	tics = 1,
}
states[S_SRBZ_THROWNSCATTER5] = {
	nextstate = S_SRBZ_THROWNSCATTER6,
	sprite = SPR_TSCR,
	frame = FF_FULLBRIGHT,
	tics = 1,
}
states[S_SRBZ_THROWNSCATTER6] = {
	nextstate = S_SRBZ_THROWNSCATTER7,
	sprite = SPR_TSCR,
	frame = FF_FULLBRIGHT,
	tics = 1,
}
states[S_SRBZ_THROWNSCATTER7] = {
	nextstate = S_SRBZ_THROWNSCATTER1,
	sprite = SPR_TSCR,
	frame = FF_FULLBRIGHT,
	tics = 1,
}

SRBZ:CreateItem("Scatter Ring",  {
	icon = "SCATIND",
	firerate = TICRATE,
	sound = sfx_shgn,
	knockback = 13*FRACUNIT,
	damage = 12,
	fuse = TICRATE/2,
	color = SKINCOLOR_PURPLE,
	price = 250,
	ammo = 15,
	reload_time = 3*TICRATE,
	ontrigger = function(player)
		local mt = MT_SRBZ_THROWNSCATTER
		local mo = player.mo
		local spread = 4
		--S_StartSound(mo, sfx_shgn)
		for i = -1, 1
			local shot = P_SPMAngle(mo, mt, mo.angle + i * ANG1*spread, 1, 0)
			if shot and shot.valid
				shot.color = SRBZ:FetchInventorySlot(player).color
				shot.fuse = SRBZ:FetchInventorySlot(player).fuse
				shot.forcedamage = SRBZ:FetchInventorySlot(player).damage
				shot.forceknockback = SRBZ:FetchInventorySlot(player).knockback
				
				shot.momx = $ + mo.momx / 3
				shot.momy = $ + mo.momy / 3
				shot.momz = $ + mo.momz / 3
			end
		end
		for i = -1, 1, 2
			local prevaim = player.aiming
			player.aiming = $ + i * ANG1*spread
			local shot = P_SPMAngle(mo, mt, mo.angle, 1, 0)
			player.aiming = prevaim
			if shot and shot.valid
				shot.color = SRBZ:FetchInventorySlot(player).color
				shot.fuse = SRBZ:FetchInventorySlot(player).fuse
				shot.forcedamage = SRBZ:FetchInventorySlot(player).damage
				shot.forceknockback = SRBZ:FetchInventorySlot(player).knockback

				shot.momx = $ + mo.momx / 3
				shot.momy = $ + mo.momy / 3
				shot.momz = $ + mo.momz / 3
			end
		end
		if not P_IsObjectOnGround(mo)
			local aim = max(-FRACUNIT, min(FRACUNIT, -player.aiming/13000))
			if P_MobjFlip(mo) * aim > 0
				aim = ($ * 2)>>3
			end
			mo.momz = $ + FixedMul(mo.scale, aim)
			P_Thrust(mo, mo.angle, -FRACUNIT*9)
		end
	end
})