SRBZ:CreateItem("Negative Ring",  {
	object = MT_REDRING,
	icon = "NEGATIVERINGIND",
	firerate = 25,
	color = SKINCOLOR_WHITE,
	knockback = 80*FRACUNIT,
	damage = 27,
	onhit = function(mo, hit)
		P_SetObjectMomZ(hit, 15*FU)
		if hit.player then
			P_FlashPal(hit.player, 3, 5)
		end
	end,
	onspawn = function(pmo, mo)
		mo.momx = $/4
		mo.momy = $/4
		mo.momz = $/4
		mo.scale = $*2
	end,
	price = 650,
})