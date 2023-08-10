freeslot("MT_CRRUBY","S_CRRUBY","SPR_RBY1", "sfx_rbyhit") -- idk what CR means but i just slap it there

SRBZ.RubyLimit = 2500;

mobjinfo[MT_CRRUBY]= {
	doomednum = -1,
	spawnstate = S_CRRUBY,
	spawnhealth = 1,
	deathstate = S_SPRK1,
	deathsound = sfx_rbyhit,
	radius = 25*FU,
	height = 45*FU,
	flags = MF_SLIDEME|MF_SPECIAL,
}

states[S_CRRUBY] = {
	sprite = SPR_RBY1,
	frame = FF_FULLBRIGHT|A,
	tics = -1,
	nextstate = S_CRRUBY,
}

addHook("PlayerThink", function(player)
	player.rubies = $ or 0
	if player.rubies > SRBZ.RubyLimit then
		player.rubies = SRBZ.RubyLimit
	end
end)

addHook("MobjDeath", function(mobj)

	if gametype ~= GT_SRBZ then return end
	
	if mobjinfo[mobj.type].rubydrop and type(mobjinfo[mobj.type].rubydrop) == "table" 
	and #mobjinfo[mobj.type].rubydrop == 2 then
	
		local ruby_count = P_RandomRange(mobjinfo[mobj.type].rubydrop[1],mobjinfo[mobj.type].rubydrop[2])
		
		for i=1,ruby_count do
			local the_ruby = P_SpawnMobjFromMobj(mobj,0,0,10*FU,MT_CRRUBY)
			the_ruby.fuse = 15*TICRATE
			P_SetObjectMomZ(the_ruby, P_RandomRange(5,7)<<16)
		
			if ruby_count > 1 then
				local angle = P_RandomByte() * 256 * 2^16
				P_InstaThrust(the_ruby, angle, 2*FU)
			end
		end
	end
end)



addHook("TouchSpecial", function(special, toucher)
	if toucher and toucher.valid and toucher.player then
		if toucher.player.rubies + 1 > SRBZ.RubyLimit then
			return true
		end
		P_GivePlayerRubies(toucher.player, 1)
	end
end, MT_CRRUBY)

addHook("MobjThinker", function(mobj)
	if mobj.sprite == SPR_SPRK then
		mobj.color = SKINCOLOR_RED
		mobj.colorized = true
	end
	--P_RingZMovement(mobj)
	if mobj.eflags & MFE_JUSTHITFLOOR then
		P_SetObjectMomZ(mobj, abs(FixedDiv(mobj.lastmomz, P_RandomRange(2,3)*FRACUNIT)))
		if mobj.momz < FRACUNIT then
			mobj.momz = 0
		else
			S_StartSound(mobj, sfx_tink)
		end
	end
	mobj.lastmomz = mobj.momz
	
	if mobj.fuse < 3*TICRATE then
		mobj.flags2 = $^^MF2_DONTDRAW
	end
end, MT_CRRUBY)