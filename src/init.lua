dofile "init/gametype.lua"

dofile "libraries/json.lua"
dofile "libraries/mobjlib.lua"
dofile "libraries/customhudlib.lua"
dofile "libraries/countingplayers.lua"
dofile "libraries/getcharacterlist.lua"
dofile "libraries/mtimeconv.lua"
dofile "libraries/basexx.lua" -- https://github.com/aiq/basexx

dofile "main/netvars.lua"

dofile "main/player/characterselect_logic.lua"
dofile "main/player/baseplayer.lua"
dofile "main/player/characterconfigs.lua"

dofile "main/zombie/zombie_checkpoints.lua"
dofile "main/zombie/zombie_visuals.lua"

dofile "main/enemies.lua"
dofile "main/intermission.lua"
dofile "main/capitalism.lua"
dofile "main/megahp.lua"
dofile "main/exiting.lua"
dofile "main/healthncombat.lua"
dofile "main/itemdef.lua"
dofile "main/mapinfo_animation.lua"
dofile "main/timers.lua"
dofile "main/shop.lua"
dofile "main/savedata.lua"
dofile "main/name_tags.lua"
dofile "main/maptimers.lua"


dofile "hud/characterselect.lua"
dofile "hud/info.lua"
dofile "hud/shop.lua"
dofile "hud/inventory.lua"
dofile "hud/mapinfo_animation.lua"
dofile "hud/toggle.lua"
dofile "hud/intermission.lua"

dofile "hooks/gamelogic.lua"
dofile "hooks/hud.lua"

dofile "levelscripts/concealed_woodland.lua"
dofile "levelscripts/thefarland.lua"
dofile "levelscripts/minecraft.lua"
dofile "levelscripts/specialstage.lua"
dofile "levelscripts/undertale.lua"
