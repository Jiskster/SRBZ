freeslot("sfx_gulpy")

SRBZ:CreateItem("Milk", {
	icon = "MILKIND",
	iconscale = FU/2,
	firerate = 32,
	sound = sfx_gulpy,
	limited = true,
	count = 12,
	ontrigger = function(player)
		SRBZ:ChangeStamina(player, 25*FRACUNIT)
		SRBZ:ChangeHealth(player.mo, 4)
	end,
	price = 110,
})