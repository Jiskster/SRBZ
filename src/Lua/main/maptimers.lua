-- Custom timers for maps
-- Code by LeonardoTheMutant and Jisk

--AddMapTimer Function Parameters:
--
--	SRBZ.AddMapTimer(
--		name string, --name of the timer
--		map number, --map ID where it is meant to run
--		time number*TICRATE, --time
--		on_end function(timerID number, TimerName string), --function that executes at the end of the timer
--		extrainfo={ --allows for several events during runtime
--			color skincolor_t --optional, used for HUD to represent timer
--			[1]={
--				event_time = number*TICRATE, --time
--				event_func = function(timerID number, TimerName string) --something that should happen
--					chatprint("Hello world!")
--				end
--			}
--      }
--	)

-- Example:
--
--	SRBZ.AddMapTimer(
--		"Stonewood Timer1",
--		424, -- "MAPJ0"
--		5*TICRATE,
--		function(timernum,timername)
--			print("Timer done: "..timername.." [".. timernum .. "]")
--		end,
--		{
--			color = SKINCOLOR_BLUE
--			[1]={
--				event_time = 3*TICRATE
--				event_func = function(timerID, timerName)
--					chatprint(timerName.." with ID "..timerID.." has 3 seconds left!")
--				end
--			}
--			[2]={
--				event_time = 1*TICRATE
--				event_func = function(timerID, timerName)
--					chatprint("Timer with ID"..timerID.." ("..timerName..") has one second remaining!")
--				end
--			}
--		}
--  )

SRBZ.maptimerdebug = CV_RegisterVar({
	name = "z_maptimerdebug",
	defaultvalue = "Off",
	PossibleValue = CV_OnOff,
})

SRBZ.MapTimers = {}

function SRBZ.AddMapTimer()
	print("SRBZ.AddMapTimer is deprecated, try SRBZ:AddTimer instead")
end

function SRBZ:AddTimer(_name,_table) 
	if _name == nil then
		error("Timer: Arg1 is required (Arg1 _name)")
	elseif type(_name) ~= "string" then
		error("Timer: Arg1 must be string (Arg1 _name)")
	end
	
	if _table == nil then
		error("Timer: Table is required (Arg2 _table)")
	elseif type(_table) ~= "table" then
		error("Timer: Arg2 must be table (Arg2 _table)")
	end
	
	local _table_recieve = _table
	local _next_index = #SRBZ.MapTimers + 1
	
	_table_recieve.name = $ or _name -- why would you wanna change after tho? lol
	_table_recieve.active = $ or false
	_table_recieve.time = $ or 15*TICRATE
	_table_recieve.original_time = _table_recieve.time
	
	SRBZ.MapTimers[_next_index] = _table_recieve
	
	return SRBZ.MapTimers[#SRBZ.MapTimers]
end

function SRBZ:ResetTimer(_timer)
	_timer.active = false
	_timer.time = _timer.original_time
end

function SRBZ:GetActiveTimers()
	local activetimers = {}
	for i,timer in ipairs(SRBZ.MapTimers) do
		if timer.active then
			table.insert(activetimers, timer)
		end
	end
	return activetimers
end

addHook("MapLoad", function()
	for i,timer in ipairs(SRBZ.MapTimers) do
		SRBZ:ResetTimer(timer)
	end
end)

addHook("ThinkFrame",do
	for i,timer in ipairs(SRBZ.MapTimers) do
		if (timer.active) then
			if (SRBZ.maptimerdebug.value) then
				print(timer.name..": "..(timer.time/35)) end

			timer.time = $ - 1

			if timer.extrainfo then
				for _,info in ipairs(timer.extrainfo) do
					if (info.event_time) and (info.event_func) then
						if (timer.time == info.event_time) then
							info.event_func(i, timer.name)
						end
					end
				end
				
				/*
					extrainfo::
					{
						[1] = {
							event_time = 5*TICRATE, -- This event activates when theres exactly 5 seconds left on a timer.
							event_func = function(i, timer.name) -- Same parameters as onend
								chatprint("\x86\Stone Platform \x80will leave in\x85 5 \x80seconds")
								-- Prints "Stone Platform will leave in 5 seconds"
							end
						}
					}
				*/
				
			end
			if timer.time <= 0 then 
				if (timer.on_end) then
					timer.on_end(i, timer.name)
				end
				timer.active = false
			end
		end
	end
end)
