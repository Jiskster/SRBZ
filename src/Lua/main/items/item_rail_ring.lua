local raildmg = 90

freeslot("MT_SRBZ_RAILSHOT")

mobjinfo[MT_SRBZ_RAILSHOT] = {
	spawnstate = S_RRNG1,
	deathstate = S_SPRK1,
	deathsound = sfx_rs_die,
	speed = 128*FRACUNIT,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_MISSILE|MF_NOGRAVITY,
}

mobjinfo[MT_SRBZ_RAILSHOT].forcedamage = raildmg

local ring = function(x,y,z,scale,angle)
	local th = P_SpawnMobj(x, y, z, MT_THOK)
	if th and th.valid
		th.angle = angle + ANGLE_90
		th.spriteyoffset = -20*FRACUNIT
		th.sprite = SPR_STAB
		th.frame = FF_PAPERSPRITE|TR_TRANS80
		th.color = SKINCOLOR_WHITE
		th.blendmode = AST_ADD
		th.colorized = true
		th.scale = scale
		th.destscale = th.scale*6
		th.scalespeed = $ * 2
		th.tics = 6
	end
end

SRBZ:CreateItem("Rail Ring", {
	shake = 5,
	icon = "RAILIND",
	firerate = 50,
	knockback = 100*FRACUNIT,
	damage = raildmg,
	price = 1350,
	ontrigger = function(player, wpinfo)
		local mo = player.mo
		mo.momx = $ / 3
		mo.momy = $ / 3
		P_SetObjectMomZ(mo, 2*FRACUNIT, false)
		mo.state = S_PLAY_SPRING
		mo.player.pflags = $ & ~(PF_JUMPED | PF_SPINNING)
		S_StartSound(mo, sfx_rail1)
		local rail = P_SPMAngle(mo, MT_SRBZ_RAILSHOT, mo.angle, 1, MF2_DONTDRAW)
		
		if rail and rail.valid then
			rail.forcedamage = SRBZ:FetchInventorySlot(player).damage
			rail.forceknockback = SRBZ:FetchInventorySlot(player).knockback
			local range = 16
			for i = 0, range do
				local ang = P_RandomRange(0, 359) * ANG1
				if i % 2 == 0
					local spark = P_SpawnMobj(rail.x, rail.y, rail.z, MT_SPARK)
					if spark and spark.valid
						spark.forcedamage = SRBZ:FetchInventorySlot(player).damage
						spark.forceknockback = SRBZ:FetchInventorySlot(player).knockback
						spark.weaponinfo = wpinfo
						if i % 3 == 0
							spark.color = player.skincolor
							spark.colorized = true
						else
							spark.scale = $ * 3/4
						end
					
						if (i - 2) % 10 == 0
							ring(rail.x,rail.y,rail.z,rail.scale/2,rail.angle)
						end
					end
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
				ring(rail.x,rail.y,rail.z,rail.scale,rail.angle)
				P_KillMobj(rail)
			end
		end
	end
})