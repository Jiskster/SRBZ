addHook("PreThinkFrame", SRBZ.charselectlogic)

addHook("PlayerSpawn", SRBZ.playerfunc)

addHook("MobjDeath", SRBZ.HitMegaHP, MT_MEGAHP)

addHook("MapLoad", do
	if gametype == GT_SRBZ then
		SRBZ.init_gamevars()
	end
end)
