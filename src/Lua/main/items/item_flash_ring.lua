-- Ported From RSNEO

local flashdmg = 30
local flashkb = 70*FRACUNIT

freeslot("MT_SRBZ_FLASHSHOT", "S_SRBZ_FLASHBURST", "sfx_wp_vol")

freeslot("S_NEWBOOM")
states[S_NEWBOOM] = {SPR_BARX, FF_ANIMATE|FF_TRANS50|A, 9, nil, 3, 3, S_NULL}

function A_FlashBurst(mo)
	local vfxscale = FixedMul(mo.info.painchance / 192, mo.scale)
	local vfx = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_SPINDUST)
	if vfx.valid
		vfx.scale = vfxscale
		vfx.destscale = vfx.scale * 2
		vfx.frame = $ | FF_FULLBRIGHT
		vfx.color = SKINCOLOR_WHITE
		vfx.colorized = true
		vfx.state = S_NEWBOOM
		P_SetObjectMomZ(vfx, -vfx.scale, false)
	end
	
	for i = 0, 4
		local dust = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_TNTDUST)
		if dust.valid
			if i == 0
				S_StartSound(dust, sfx_s3k45)
			end
			local angle = P_RandomRange(0, 359) * ANG1
			dust.angle = angle
			dust.scale = $ / 3
			dust.destscale = dust.scale * 3
			dust.scalespeed = dust.scale / 24
			P_Thrust(dust, angle, 15 * FixedMul(P_RandomFixed(), dust.scale))
			dust.momz = P_SignedRandom()*dust.scale/64
		end
	end
	
	/*for i = 0, 20
		local smoke = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_SMOKE)
		local angle = P_RandomRange(0, 359) * ANG1
		smoke.color = SKINCOLOR_WHITE
		smoke.colorized = true
		P_InstaThrust(smoke, angle, 10 * smoke.scale)
		smoke.momz = P_RandomRange(-10, 10) * smoke.scale
	end*/

	local maxdist = FixedMul(mo.info.painchance, mo.scale)
	local thok = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_THOK)
	thok.radius = maxdist
	searchBlockmap("objects", function(refmobj, foundmobj)
		if foundmobj == refmobj return end
		if not (foundmobj and foundmobj.valid) return end
		if not (foundmobj.flags & MF_SHOOTABLE) return end
		local dist = P_AproxDistance(P_AproxDistance(foundmobj.x - refmobj.x, foundmobj.y - refmobj.y), foundmobj.z - refmobj.z)
		if (dist > maxdist)
			return
		end
		P_DamageMobj(foundmobj, mo, mo.target, 1, 0)
	end, thok)
	P_RemoveMobj(thok)
end



mobjinfo[MT_SRBZ_FLASHSHOT] = {
	spawnstate = S_RRNG1,
	deathstate = S_SRBZ_FLASHBURST,
	deathsound = sfx_s3k33,
	speed = 43*FRACUNIT,
	radius = 6*FRACUNIT,
	height = 12*FRACUNIT,
	painchance = 165*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_MISSILE,
}
states[S_SRBZ_FLASHBURST] = {
	tics = 0,
	action = A_FlashBurst
}

mobjinfo[MT_SRBZ_FLASHSHOT].forcedamage = flashdmg
mobjinfo[MT_SRBZ_FLASHSHOT].forceknockback = flashkb


SRBZ:CreateItem("Flash Ring", {
	shake = 15,
	icon = "BLININD",
	firerate = 40,
	knockback = flashkb,
	damage = flashdmg,
	price = 1250,
	ontrigger = function(player)
		local mo = player.mo
		mo.momx = $ / 3
		mo.momy = $ / 3
		P_SetObjectMomZ(mo, 8*FRACUNIT, false)
		mo.state = S_PLAY_SPRING
		mo.player.pflags = $ & ~(PF_JUMPED | PF_SPINNING)
		S_StartSound(mo, sfx_wp_vol)
		local rail = P_SPMAngle(mo, MT_SRBZ_FLASHSHOT, mo.angle, 1, MF2_DONTDRAW)
		
		if rail and rail.valid then
			rail.forcedamage = SRBZ:FetchInventorySlot(player).damage
			rail.forceknockback = SRBZ:FetchInventorySlot(player).knockback
			local range = 16
			for i = 0, range do
				local ang = P_RandomRange(0, 359) * ANG1
				local spark = P_SpawnMobj(rail.x + sin(ang)*5, rail.y + cos(ang)*5, rail.z, MT_BOXSPARKLE)
				if spark and spark.valid
					if i % 2
						spark.color = player.skincolor
					end
					spark.colorized = true
				end
				
				local prevx = rail.x
				local prevy = rail.y
				local prevz = rail.z
				
				if rail.momx or rail.momy
					P_XYMovement(rail)
					if not rail.valid
						break
					end
				end
				if rail.momz
					P_ZMovement(rail)
					if not rail.valid
						break
					end
				end
				
				if (not rail.valid) or (xx == rail.x and y == rail.y and z == rail.z)
					break
				end
			end

			if rail and rail.valid then
				P_KillMobj(rail)
			end
		end
	end
})