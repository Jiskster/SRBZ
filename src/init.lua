dofile "init/gametype.lua"

dofile "libraries/json.lua"
dofile "libraries/mobjlib.lua"
dofile "libraries/customhudlib.lua"
dofile "libraries/countingplayers.lua"
dofile "libraries/getcharacterlist.lua"
dofile "libraries/itemlib.lua"
dofile "libraries/mtimeconv.lua"
dofile "libraries/basexx.lua" -- https://github.com/aiq/basexx

// ITEMS
dofile "main/items/item_red_ring.lua"
dofile "main/items/item_auto_ring.lua"
dofile "main/items/item_apple.lua"
dofile "main/items/item_milk.lua"
dofile "main/items/item_insta_burst.lua"
dofile "main/items/item_ws_mirror.lua"
dofile "main/items/item_tails_fence.lua"
dofile "main/items/item_explosion_ring.lua"
dofile "main/items/item_negative_ring.lua"
dofile "main/items/item_blue_spring.lua"
dofile "main/items/item_bounce_ring.lua"
dofile "main/items/item_scatter_ring.lua"
dofile "main/items/item_green_shell.lua"
dofile "main/items/item_red_shell.lua"
dofile "main/items/item_scatra.lua"
// ITEMS END

dofile "main/netvars.lua"

dofile "main/characterselect_logic.lua"
dofile "main/baseplayer.lua"
dofile "main/characterconfigs.lua"

dofile "main/zombie/zombie_checkpoints.lua"
dofile "main/zombie/zombie_visuals.lua"

dofile "main/healthncombat.lua" -- main stuff 

dofile "main/enemies.lua"
dofile "main/intermission.lua"
dofile "main/capitalism.lua"
dofile "main/megahp.lua"
dofile "main/exiting.lua"
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
