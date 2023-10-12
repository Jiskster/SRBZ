addHook("NetVars", function(net)
	SRBZ.time_limit = net($);
	SRBZ.wait_time = net($);
	SRBZ.round_active = net($); -- stays on even if the end screen is on
	SRBZ.game_ended = net($);
	SRBZ.win_tics = net($); -- Increases if SRBZ.game_ended is true
	SRBZ.game_time = net($);
	SRBZ.team_won = net($);
	
	SRBZ.VoteTimeLimit = net($);
	SRBZ.MapsOnVote = net($);
	SRBZ.NextMapVoted = net($);
	
	SRBZ.CurrentZombieCheckpoint = net($);
	SRBZ.ZombieCheckpoints = net($);
	
	SRBZ.TWRITE_COUNT = net($);
	SRBZ.TWRITE_MAPNAME_COUNT = net($);
	
	for i,v in ipairs(SRBZ.MapTimers) do
		v.name = net($);
		v.time = net($);
		v.active = net($);
	end
end)

