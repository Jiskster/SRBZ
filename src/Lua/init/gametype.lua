rawset(_G, "SRBZ", {});
/* Was meant for the ringslinger-esk system. Might use this name for separating 
what SRBZ has.

rawset(_G, "XSLINGER", {});
*/

freeslot("sfx_zdi1","sfx_zdi2","sfx_zish1","sfx_zpa1","sfx_pa2")
rawset(_G, "srbz_modname", "srbz"); -- For customhud.


freeslot("TOL_SRBZ");

rawset(_G, 'L_ZCollide', function(mo1,mo2)
	if mo1.z > mo2.height+mo2.z then return false end
	if mo2.z > mo1.height+mo1.z then return false end
	return true
end)

SRBZ.survival_time = (60*10)*TICRATE;
SRBZ.swarm_time = (60*5)*TICRATE;
SRBZ.wait_time = 12*TICRATE;
SRBZ.init_gamevars = function() -- Variables vary per game.
	SRBZ.round_active = false;
	SRBZ.onwinscreen = false;
	SRBZ.wintics = 0; -- How many tics after a win screen. Resets on mapload.
end;SRBZ.init_gamevars()

SRBZ.teams = {"Survivors", "Zombies"}

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

addHook("MobjDamage", function(mo, inf, src, dmg)
	if dmg >= mo.health then
		P_KillMobj(mo)
		return true
	end
	mo.player.powers[pw_flashing] = 35
	P_FlashPal(mo.player, PAL_NUKE, 2)
	if mo.player then
		S_StartSound(mo, sfx_s3kb9)
	end
	local speed1 = FixedHypot(FixedHypot(inf.momx, inf.momy), inf.momz)
	--P_SetObjectMomZ(mo, 5*FRACUNIT)
	--P_Thrust(mo, inf.angle, speed1*5)
	mo.health = $ - dmg
	return true
end, MT_PLAYER)

addHook("MobjMoveCollide", function(thing,tmthing)
	if L_ZCollide(thing,tmthing) then
		local speed1 = FixedHypot(FixedHypot(tmthing.momx, tmthing.momy), tmthing.momz)
		local speed2 = FixedHypot(FixedHypot(thing.momx, thing.momy), thing.momz)
		
		if speed1 > speed2 and not tmthing.player.powers[pw_flashing] then
			P_DamageMobj(thing, tmthing, nil, 10)
		end
	end
end)