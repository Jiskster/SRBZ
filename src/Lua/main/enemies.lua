
// Gold Crawla Freeslot
freeslot( 
"MT_GOLDCRAWLA", 
"S_GOSS_STND",
"S_GOSS_RUN1",
"S_GOSS_RUN2",
"S_GOSS_RUN3",
"S_GOSS_RUN4",
"S_GOSS_RUN5",
"S_GOSS_RUN6",
"SPR_GOSS"
)

mobjinfo[MT_BLUECRAWLA].npc_name = "Blue Crawla"
mobjinfo[MT_BLUECRAWLA].npc_spawnhealth = {12,23}
mobjinfo[MT_BLUECRAWLA].npc_name_color = SKINCOLOR_BLUE
mobjinfo[MT_BLUECRAWLA].rubydrop = {3,6}
mobjinfo[MT_BLUECRAWLA].painsound = sfx_dmpain

mobjinfo[MT_REDCRAWLA].npc_name = "Red Crawla"
mobjinfo[MT_REDCRAWLA].npc_spawnhealth = {30,60}
mobjinfo[MT_REDCRAWLA].npc_name_color = SKINCOLOR_RED
mobjinfo[MT_REDCRAWLA].rubydrop = {6,10}
mobjinfo[MT_REDCRAWLA].painsound = sfx_dmpain

mobjinfo[MT_GOLDCRAWLA] = {
	doomednum = -1,
	spawnstate = S_GOSS_STND,
	seestate = S_GOSS_RUN1,
	deathstate = S_XPLD_FLICKY,
	deathsound = sfx_pop,
	spawnhealth = 1,
	reactiontime = 32,
	painchance = 170,
	speed = 20,
	radius = 24*FRACUNIT,
	height = 32*FRACUNIT,
	mass = 100,
	flags = MF_ENEMY|MF_SPECIAL|MF_SHOOTABLE,
}

mobjinfo[MT_GOLDCRAWLA].npc_name = "Gold Crawla"
mobjinfo[MT_GOLDCRAWLA].npc_spawnhealth = {100,245}
mobjinfo[MT_GOLDCRAWLA].npc_name_color = SKINCOLOR_GOLD
mobjinfo[MT_GOLDCRAWLA].rubydrop = {50,60}
mobjinfo[MT_GOLDCRAWLA].painsound = sfx_dmpain

states[S_GOSS_STND] = {SPR_GOSS, A, 5, A_Look, 0, 0, S_GOSS_STND}
states[S_GOSS_RUN1] = {SPR_GOSS, A, 1, A_Chase, 0, 0, S_GOSS_RUN2}
states[S_GOSS_RUN2] = {SPR_GOSS, B, 1, A_Chase, 0, 0, S_GOSS_RUN3}
states[S_GOSS_RUN3] = {SPR_GOSS, C, 1, A_Chase, 0, 0, S_GOSS_RUN4}
states[S_GOSS_RUN4] = {SPR_GOSS, D, 1, A_Chase, 0, 0, S_GOSS_RUN5}
states[S_GOSS_RUN5] = {SPR_GOSS, E, 1, A_Chase, 0, 0, S_GOSS_RUN6}
states[S_GOSS_RUN6] = {SPR_GOSS, F, 1, A_Chase, 0, 0, S_GOSS_RUN1}

mobjinfo[MT_GOLDBUZZ].npc_name = "Gold Buzz"
mobjinfo[MT_GOLDBUZZ].npc_spawnhealth = {3,8}
mobjinfo[MT_GOLDBUZZ].npc_name_color = SKINCOLOR_GOLD
mobjinfo[MT_GOLDBUZZ].rubydrop = {1,5}
mobjinfo[MT_GOLDBUZZ].painsound = sfx_dmpain

mobjinfo[MT_REDBUZZ].npc_name = "Red Buzz"
mobjinfo[MT_REDBUZZ].npc_spawnhealth = {10,17}
mobjinfo[MT_REDBUZZ].npc_name_color = SKINCOLOR_RED
mobjinfo[MT_REDBUZZ].rubydrop = {5,7}
mobjinfo[MT_REDBUZZ].painsound = sfx_dmpain

local function GoldCrawlaRNG(mobj)
	if gametype ~= GT_SRBZ then return end
	if P_RandomChance(FRACUNIT/20) then
		P_SpawnMobjFromMobj(mobj,0,0,0,MT_GOLDCRAWLA)
		mobj.fuse = 1
		return true
	end
end
addHook("MobjSpawn", GoldCrawlaRNG, MT_BLUECRAWLA)
addHook("MobjSpawn", GoldCrawlaRNG, MT_REDCRAWLA)
