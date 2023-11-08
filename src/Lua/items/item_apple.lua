SRBZ:CreateItem("Apple", {
	icon = "APPLEIND",
	iconscale = FU/2,
	firerate = 50,
	sound = sfx_eatapl,
	limited = true,
	count = 5,
	ontrigger = function(player)
		SRBZ:ChangeHealth(player.mo, 16)
	end,
	price = 60,
})