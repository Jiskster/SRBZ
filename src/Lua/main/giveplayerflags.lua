SRBZ.giveplayerflags = function(player)
	if gametype == GT_SRBZ then
		player.charflags = SF_NOJUMPSPIN|SF_NOJUMPDAMAGE|SF_NOSKID
		player.pflags = $ & ~PF_DIRECTIONCHAR
		SRBZ.SetCCtoplayer(player)
	else 
		if leveltime < 2 then
			SRBZ.RevertChars(player) 
		end
	end
end