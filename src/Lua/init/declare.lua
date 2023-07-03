rawset(_G, "SRBZ", {});
/* Was meant for the ringslinger-esk system. Might use this name for separating 
what SRBZ has.

rawset(_G, "XSLINGER", {});
*/
rawset(_G, "srbz_modname", "srbz"); -- For customhud.
freeslot("TOL_SRBZ");

SRBZ.survival_time = (60*10)*TICRATE;
SRBZ.swarm_time = (60*5)*TICRATE;
SRBZ.wait_time = 12*TICRATE;
SRBZ.init_gamevars = function() -- Variables vary per game.
	SRBZ.round_active = false;
	SRBZ.onwinscreen = false;
	SRBZ.wintics = 0; -- How many tics after a win screen. Resets on mapload.
end;SRBZ.init_gamevars()

G_AddGametype({
	name = "SRBZ Survival",
	identifier = "srbz",
	typeoflevel = TOL_SRBZ,
	rules = GTR_HURTMESSAGES|GTR_TIMELIMIT|GTR_ALLOWEXIT|GTR_RESPAWNDELAY|GTR_SPAWNENEMIES|GTR_CUTSCENES,
	intermissiontype = int_none, -- No intermission screen for possible inbuilt screen.
	--headerleftcolor = 152,
	--headerrightcolor = 40,
	description = "Escape from the Zombies! Don't get caught and eaten by them! They can catch up with you anytime..."
})