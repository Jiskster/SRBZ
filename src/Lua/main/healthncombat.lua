SRBZ.LimitMobjHealth = function(mobj)
	if mobj.health and mobj.maxhealth then
		if mobj.health > mobj.maxhealth then
			mobj.health = mobj.maxhealth
		end
	end
end

addHook("MobjDamage", function(mo, inf, src, dmg)
	if (gametype ~= GT_SRBZ) return end
	if SRBZ.game_ended then return true end
	
	local knockback = 0
	
	if inf and inf.player and mo and mo.player then
		if mo.player.zteam == inf.player.zteam then
			return true
		end
	end
	
	
	if src and src.player and mo and mo.player then
		if mo.player.zteam == src.player.zteam then
			return true
		end
	end

	if mo.player then
		mo.player.shop_open = false
		mo.player.shop_anim = 0
	end
	
	if inf then
		if inf.forcedamage ~= nil then
			dmg = inf.forcedamage
		end
		
		if inf.forceknockback ~= nil then
			knockback = inf.forceknockback
		end
		
		if inf.weaponinfo and SRBZ.ItemPresets[inf.weaponinfo.item_id] and SRBZ.ItemPresets[inf.weaponinfo.item_id].onhit and inf.target then
			SRBZ.ItemPresets[inf.weaponinfo.item_id].onhit(inf.target, mo, inf)
		end
	end
	
	if (inf and inf.player) then P_AddPlayerScore(inf.player, dmg)
	elseif (src and src.player) then P_AddPlayerScore(src.player, dmg) end
	
	if inf and inf.info.forceknockback then
		knockback = inf.info.forceknockback
	end
	
	if mo.player then
		if mo.player.zteam == 1 then
			mo.player.powers[pw_flashing] = 35
			P_FlashPal(mo.player, PAL_NUKE, 2)
			S_StartSound(mo, sfx_s3kb9)
		elseif mo.player.zteam == 2 then
			local zombie_hurtsounds = {
				sfx_zpa1,
				sfx_zpa2,
			}
			local chosen_hurtsound = zombie_hurtsounds[P_RandomRange(1,2)]
			if inf and inf.valid then
				P_Thrust(mo, inf.angle, 20*FRACUNIT)
			end
			
			
			S_StartSound(mo, chosen_hurtsound)
		end
	elseif mobjinfo[mo.type].npc_name
		if (not mo.target) and (inf or src.player) then --enemies wake up if you hit them from behind
			mo.target = src
			mo.state = mo.info.seestate
		end

		if mobjinfo[mo.type].painsound and mobjinfo[mo.type].painsound ~= sfx_None then
			S_StartSound(mo,mobjinfo[mo.type].painsound)
		end
		P_Thrust(mo, inf.angle, mo.info.mass/100 * knockback) --you know it's better to make alt mass
	
	end
	
	if (not inf) or (not inf.weaponinfo) then
		if ((mobjinfo[src.type].npc_name) and (mo.player)) 
		or ((src.player) and mobjinfo[mo.type].npc_name) then
			dmg = P_RandomKey(9)+3
			if inf and inf.info.forcedamage then
				dmg = inf.info.forcedamage
			end
		end
	end
	if dmg >= mo.health then
		if mo.player and mo.player.valid then
			local player = mo.player 
			local ztype = player.ztype
			
			if ztype and SRBZ.ZombieConfig[ztype] and SRBZ.ZombieConfig[ztype].killaward then
				local killaward = SRBZ.ZombieConfig[ztype].killaward
				A_RubyDrop(mo, killaward)
			end
		end
		P_KillMobj(mo,inf)
		return true
	end


	if mo.rubiesholding and (mo.rubiesholding - (mo.rubiesholding/3)) > 0 then
		 A_RubyDrop(mo, mo.rubiesholding/3)
		 mo.rubiesholding = $ - mo.rubiesholding/3
	end
	mo.health = $ - dmg -- fake damage i guess
	
	return true
end)

--ram into players as zombie
addHook("MobjMoveCollide", function(thing,tmthing)
	if (gametype ~= GT_SRBZ) return end
	if (SRBZ.game_ended) then return end
	if L_ZCollide(thing,tmthing) and tmthing.player and tmthing.player.zteam == 2 and thing.player
	and thing.player.zteam ~= 2 then
		local speed1 = FixedHypot(FixedHypot(tmthing.momx, tmthing.momy), tmthing.momz)
		local speed2 = FixedHypot(FixedHypot(thing.momx, thing.momy), thing.momz)
		
		if speed1 > speed2 and tmthing.player and tmthing.player.valid
		and not tmthing.player.powers[pw_flashing] then
			P_DamageMobj(thing, tmthing, tmthing, 15)
		end
	end
end)

addHook("MobjSpawn", function(mobj)
	if gametype ~= GT_SRBZ then return end
	if mobjinfo[mobj.type].npc_name then
		if mobjinfo[mobj.type].spawnhealth and type(mobjinfo[mobj.type].npc_spawnhealth) == "table" then
			local rng_health = P_RandomRange(mobjinfo[mobj.type].npc_spawnhealth[1],mobjinfo[mobj.type].npc_spawnhealth[2])
			mobj.health = rng_health
			mobj.maxhealth = mobj.health
		else
			mobj.maxhealth = mobj.health
		end
	end
end)

addHook("PreThinkFrame", function()
	if gametype ~= GT_SRBZ then return end
	for player in players.iterate do
		local cmd = player.cmd
		player["srbz_info"] = $ or {
			inventory_selection = 1,

			survivor_inventory_limit = 5,
			
			survivor_inventory = {
				SRBZ:CopyItemFromID(ITEM_RED_RING)
			},

			weapondelay = 0,
			ghostmode = false,
			
			vote_selection = 1,
			voted = false,
			vote_leftpressed = false,
			vote_rightpressed = false,
			vote_selectpressed = false,
			vote_deselectpressed = false,

			shop_selection = 1,
			shop_leftpressed = false,
			shop_rightpressed = false,
			shop_selectpressed = false,
			shop_exitpressed = false,
			shop_confirmscreen = false,
		}
		
		if not player["srbz_info"].zombie_inventory or not player["srbz_info"].zombie_inventory_limit then
			SRBZ.SetZCinventory(player)
		end
		
		if player.playerstate ~= PST_DEAD then
			if #SRBZ:FetchInventory(player) > SRBZ:FetchInventoryLimit(player) then
				table.remove(SRBZ:FetchInventory(player),#SRBZ:FetchInventory(player))
			end

			if player["srbz_info"].inventory_selection > SRBZ:FetchInventoryLimit(player) then
				player["srbz_info"].inventory_selection = SRBZ:FetchInventoryLimit(player)
			end
		end
		
		if player and not player.mo then continue end
		
		-- decrement
		if player["srbz_info"].weapondelay then
			player["srbz_info"].weapondelay = $ - 1
		end
		
		if not SRBZ.game_ended and not player["srbz_info"].ghostmode then 
			if (cmd.buttons & BT_WEAPONPREV) and not player.choosing then
				if not player["srbz_info"].pressedprev then
					if player["srbz_info"].inventory_selection - 1 <= 0 then
						player["srbz_info"].inventory_selection = SRBZ:FetchInventoryLimit(player)
					else
						player["srbz_info"].inventory_selection = $ - 1
					end
					
					S_StartSound(nil,sfx_mnu1a,player)
				end
			
				player["srbz_info"].pressedprev = true
			else
				player["srbz_info"].pressedprev = false
			end
		
			if (cmd.buttons & BT_WEAPONNEXT) and not player.choosing then
				if not player["srbz_info"].pressednext then
				
					if player["srbz_info"].inventory_selection + 1 > SRBZ:FetchInventoryLimit(player) then
						player["srbz_info"].inventory_selection = 1
					else
						player["srbz_info"].inventory_selection = $ + 1
					end

					S_StartSound(nil,sfx_mnu1a,player)
				end
				
				player["srbz_info"].pressednext = true
			else
				player["srbz_info"].pressednext = false	
			end

			--make keyboard weapon keys work for inventory selection
			if (cmd.buttons & BT_WEAPONMASK >=1 and cmd.buttons & BT_WEAPONMASK<=5) and (not player.choosing) then
				if not player["srbz_info"].pressedbtn then
					player["srbz_info"].inventory_selection=cmd.buttons&BT_WEAPONMASK
					S_StartSound(nil,sfx_mnu1a,player)
				end
				player["srbz_info"].pressedbtn = true
			else player["srbz_info"].pressedbtn = false end
			--^^^ make a proper replacement for this if you're gonna remove it again ^^^
			
			-- try shoot
			if (cmd.buttons & BT_ATTACK) and not player["srbz_info"].weapondelay 
			and SRBZ:FetchInventorySlot(player) and player.playerstate ~= PST_DEAD and not player.shop_open then
				
				local weaponinfo = SRBZ:FetchInventorySlot(player)
				local ring
				
				if not SRBZ.ItemPresets[weaponinfo.item_id] then
					continue
				end
				
				if SRBZ.game_ended or player.choosing then 
					continue
				end

				if weaponinfo.object
					ring = P_SPMAngle(player.mo, weaponinfo.object, player.mo.angle, 1, weaponinfo.flags2)
				end
				
				if SRBZ.ItemPresets[weaponinfo.item_id].ontrigger and SRBZ.ItemPresets[weaponinfo.item_id].ontrigger(player,weaponinfo) == true then
					continue
				end
				
				if SRBZ.ItemPresets[weaponinfo.item_id].shake then
					local shake = SRBZ.ItemPresets[weaponinfo.item_id].shake
					if splitscreen or player == displayplayer then
						P_StartQuake(shake * FRACUNIT, 7)
					end
				end
				
				
				player["srbz_info"].weapondelay = weaponinfo.firerate
				
				if weaponinfo.count ~= nil and weaponinfo.count > 0 and weaponinfo.limited == true then
					weaponinfo.count = $ - 1
				elseif weaponinfo.count ~= nil and weaponinfo.count <= 0 and weaponinfo.limited == true then
					continue
				end
				
				if weaponinfo.sound then
					S_StartSound(player.mo, weaponinfo.sound)
				end

				
				if ring then
					if weaponinfo.color ~= nil then
						ring.color = weaponinfo.color
					end 
					
					if weaponinfo.fuse ~= nil then
						ring.fuse = weaponinfo.fuse
					end
					
					if weaponinfo.damage ~= nil then
						ring.forcedamage = weaponinfo.damage
					end
					
					if weaponinfo.knockback ~= nil then
						ring.forceknockback = weaponinfo.knockback
					end

					if SRBZ.ItemPresets[weaponinfo.item_id].onspawn then
						SRBZ.ItemPresets[weaponinfo.item_id].onspawn(ring.target,ring,weaponinfo)
					end
					
					local temp_weaponinfo = SRBZ:Copy(weaponinfo)

					-- destroy functions on fire just in case
					temp_weaponinfo.onspawn = nil
					temp_weaponinfo.ontrigger = nil
					temp_weaponinfo.onhit = nil

					ring.weaponinfo = temp_weaponinfo
				end

				
			end	
			
			-- clear items below 0 count
			for i=1,SRBZ:FetchInventoryLimit(player) do
				if SRBZ:FetchInventory(player)[i] then
					if SRBZ:FetchInventory(player)[i].limited and SRBZ:FetchInventory(player)[i].count <= 0 then
						table.remove(SRBZ:FetchInventory(player),i)
					end
				end
			end
			
		end
	end
end)

addHook("MobjThinker", function(mobj)
	if mobj and mobj.valid and mobj.weaponinfo and SRBZ.ItemPresets[mobj.weaponinfo.item_id] 
	and SRBZ.ItemPresets[mobj.weaponinfo.item_id].thinker and mobj.target then
		SRBZ.ItemPresets[mobj.weaponinfo.item_id].thinker(mobj.target,mobj)
	end
end)

COM_AddCommand("z_giveitem", function(player, item_id, count, slot)
	if player.mo and player.mo.valid and player["srbz_info"] and SRBZ:FetchInventory(player) then
		if item_id then
			item_id = tonumber($)
		else
			CONS_Printf(player, "z_giveitem <item_id> <count> <slot>: gives an item to yourself.")
			return
		end

		if count then
			count = tonumber($)
		end

		if slot then 
			slot = tonumber($)
		end

		SRBZ:GiveItem(player,item_id,count,slot)
	end
end, COM_ADMIN)

COM_AddCommand("z_sellinventory", function(player)
	for i=1,player["srbz_info"].survivor_inventory_limit do
		if player["srbz_info"].survivor_inventory[i] and player["srbz_info"].survivor_inventory[i].price then
			local item_name = player["srbz_info"].survivor_inventory[i].displayname
			local item_cost = player["srbz_info"].survivor_inventory[i].price
			local item_count 
			local item_maxcount
			if player["srbz_info"].survivor_inventory[i].count then
				item_count = player["srbz_info"].survivor_inventory[i].count
				item_maxcount = player["srbz_info"].survivor_inventory[i].maxcount
			end
			if item_count and item_maxcount then
				item_cost = (item_cost*item_count)/item_maxcount
			end
			item_cost = ($*3)/4 -- Give only 75% back.
			
			local toprint = string.format("%s sold for \x85%s Rubies. (75 percent given back)",item_name,tostring(item_cost))
			
			CONS_Printf(player,toprint)
			
			player.rubies = $ + item_cost
		end
	end
	player["srbz_info"].survivor_inventory = {
		SRBZ:CopyItemFromID(ITEM_RED_RING)
	}
	player["srbz_info"].zombie_inventory = {
		SRBZ:CopyItemFromID(ITEM_INSTA_BURST)
	}
	CONS_Printf(player, "\x85".."Cleared inventory!")
end)

COM_AddCommand("z_sellhand", function(player)
	local inventory 
	if player.zteam == 1 then
		inventory = player["srbz_info"].survivor_inventory
	elseif player.zteam == 2 then
		inventory = player["srbz_info"].zombie_inventory
	end
	local inventory_slot = inventory[player["srbz_info"].inventory_selection]
	if inventory_slot and inventory_slot.price then -- Sellable
		local item_name = inventory[player["srbz_info"].inventory_selection].displayname
		local item_cost = inventory[player["srbz_info"].inventory_selection].price
		local item_count 
		local item_maxcount
		if inventory[player["srbz_info"].inventory_selection].count then
			item_count = inventory[player["srbz_info"].inventory_selection].count
			item_maxcount = inventory[player["srbz_info"].inventory_selection].maxcount
		end
		if item_count and item_maxcount then
			item_cost = (item_cost*item_count)/item_maxcount
		end
		
		item_cost = ($*3)/4 -- Give only 75% back.
		
		local toprint = string.format("%s sold for \x85\%s Rubies. (75 percent given back)",item_name,tostring(item_cost))
		
		CONS_Printf(player,toprint)
		
		inventory[player["srbz_info"].inventory_selection] = nil
		
		player.rubies = $ + item_cost
		
	elseif inventory_slot and not inventory_slot.price then -- Unsellable but has slot
		CONS_Printf(player, "\x85\This item is unsellable!")
	else -- Nothing in slot at all
		CONS_Printf(player, "\x85\Blank inventory slot!")
	end
end)

addHook("SeenPlayer", function(player)
	if gametype == GT_SRBZ then
		return false
	end
end)

addHook("MobjSpawn", function(mobj)
	if mobjinfo[mobj.type].disablehealthhud then
		mobj.dontshowhealth = true
	end
end)