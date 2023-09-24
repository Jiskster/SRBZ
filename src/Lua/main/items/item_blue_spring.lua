SRBZ:CreateItem("Blue Spring",  {
	icon = "BLUESPRINGIND",
	firerate = 2*TICRATE,
	limited = true,
	count = 5,
	ontrigger = function(player)
		local spring = P_SpawnMobj(player.mo.x+FixedMul(128*FRACUNIT, cos(player.mo.angle)),
					             player.mo.y+FixedMul(128*FRACUNIT, sin(player.mo.angle)), 
								 player.mo.z, MT_BLUESPRING)
		spring.angle = player.mo.angle+ANGLE_90
		S_StartSound(player.mo, sfx_jshard)
		spring.target = player.mo
	end,
	price = 120,
})