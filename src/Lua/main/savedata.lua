-- dont overlook this script. you will get ignored

--[[
    Todo:

    Write rubies when making an account
    Auto Log in when walking
]]--
local _rchars_ = "abcdefghijklmnopqrstuvwxyz1234567890"
local commandtoken = P_RandomKey(FRACUNIT)

addHook("NetVars", function(net)
    commandtoken = net($)
end)

local function genRNGUsername(pname)
    if type(pname) == "string" then
        local extra = ""
        local extranum = 8

        for i=1,extranum do
            local nc = P_RandomKey(#_rchars_)+1
            local chartoget = _rchars_:sub(nc,nc)
            extra = $ + chartoget
        end

        return pname.."_"..extra
    end

    return
end

local function genRNGPassword()
    local extra = ""
    local extranum = 25

    for i=1,extranum do
        local nc = P_RandomKey(#_rchars_)+1
        local chartoget = _rchars_:sub(nc,nc)
        extra = $ + chartoget
    end
    return extra
end

--print(commandkey)

COM_AddCommand("z_registeraccount", function(player)
    if (player.valid) and ((gamestate == GS_LEVEL) or (gamestate == GS_INTERMISSION)) then
        if not (player.registered) then
            local gen_username = genRNGUsername(player.name)
            local gen_password = genRNGPassword()
            if (isserver) or (isdedicatedserver) then -- Server
                print("Doing server functions.")

                local server_passpath = "SRBZDATA/"..gen_username.."/password.sav2"
                local server_statspath = "SRBZDATA/"..gen_username.."/stats.sav2"

                local passfile = io.openlocal(server_passpath, "w+")
                local statfile = io.openlocal(server_statspath, "w+")

                passfile:write(gen_password)
                passfile:close()

                statfile:write("0")
                statfile:close()
            end

            if (player == consoleplayer) then -- Client
                print("Doing client functions.")

                local clientpath = "client/SRBZ/account.sav2"
                local file = io.openlocal(clientpath, "w+")

                local clientpath_content = ('z_loginaccount '.. '"'.. gen_username ..'" '.. '"'.. gen_password ..'"')

                file:write(clientpath_content)
                file:close()

                print(clientpath_content)
            end

            player.registered_user = gen_username
            player.registered = true
        end
    end
end)

COM_AddCommand("z_loginaccount", function(player, username, password)
    if (player.valid) and ((gamestate == GS_LEVEL) or (gamestate == GS_INTERMISSION)) then
        if (not (player.registered) and not (player.registered_user)) and (username and password) then
            if (isserver) or (isdedicatedserver) then
                local passpath = "SRBZDATA/"..username.."/password.sav2"
                local passfile = io.openlocal(passpath, "r")

                if passfile then
                    local passcontent = passfile:read("*a")
                    if passcontent and (passcontent == password) then
                        print("yay yay yay SENDING CMDDD!!")
                        COM_BufInsertText(server, "z_importdata "..#player.." "..username.." "..commandtoken)
                    end
                end

                passfile:close()
            end
        end
    end
end)

COM_AddCommand("z_importdata", function(player, playernum, username, token)
    if ((isserver) or (isdedicatedserver)) and playernum and username and token then
        print(1)  
        if (tonumber(token) == commandtoken) and players[tonumber(playernum)] then
            local target_player = players[tonumber(playernum)]
            if target_player.valid then
                local statpath = "SRBZDATA/"..username.."/stats.sav2"
                local statfile = io.openlocal(statpath, "r")

                if statfile then
                    local statcontent = statfile:read("*a")
                    if statcontent then 
                        -- SET VALUES FROM FILE
                        player.rubies = tonumber(statcontent)
                        print("set value")
                    end
                else
                    print("no stat file buddy")
                end

                statfile:close()
            end
        else
            print("invalid token")
        end
    end
end, 1)