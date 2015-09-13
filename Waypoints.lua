require('Inspired')

Config = scriptConfig("Waypoint", "Waypoint")
Config.addParam("hitchancelow", "LowHitChance", SCRIPT_PARAM_ONOFF, true)
global_ticks = 0

OnProcessWaypoint(function(Object)
if Object == GetMyHero() then
Ticker = GetTickCount()
if place ~= nil then
	if (global_ticks + 2000) < Ticker then
	-- PrintChat("-------------")
	place = nil
	global_ticks = Ticker
	end
end	
if place2 ~= nil then
	place2 = nil
end	
if place3 ~= nil then
	place3 = nil
end	
if place4 ~= nil then
	place4 = nil
end	
end
end)

OnProcessWaypoint(function(Object,waypointProc)

DelayAction (function()
if Object == GetMyHero() then
	if waypointProc.index == 1 then
		place = waypointProc.position;
		end
	if waypointProc.index == 2 then
		place2 = waypointProc.position;
		end
	if waypointProc.index == 3 then
		place3 = waypointProc.position;
		end	
	if waypointProc.index == 4 then
		place4 = waypointProc.position;
		end	
	end
end
, 0)

	
end)



OnLoop(function(myHero)

if place ~= nil then
	DrawCircle(place,100,0,0,ARGB(255,255,255,255));
	end
if place2 ~= nil then
	DrawCircle(place2,100,0,0,ARGB(255,255,255,255));
	end
if place3 ~= nil then
	DrawCircle(place3,100,0,0,ARGB(255,255,255,255));
	end	
if place4 ~= nil then
	DrawCircle(place4,100,0,0,ARGB(255,255,255,255));
	end
	
movespd = GetMoveSpeed(myHero)

-------------------------------
if place4 ~= nil then

	distance3 = DistanceBetween(place3, place4)
	distance2 = DistanceBetween(place2, place3)
	distance1 = DistanceBetween(place, place2)
	time3 = distance3/movespd
	time2 = distance2/movespd
	time1 = distance1/movespd
	
	time123 = time1 + time2 + time3
	
	totalTime = time1 + time2 + time3
	totalDistance = distance1 + distance2 + distance3
	
	-- PrintChat("Needed time4: "..totalTime)
elseif place3 ~= nil then

	distance2 = DistanceBetween(place2, place3)
	distance1 = DistanceBetween(place, place2)
	time2 = distance2/movespd
	time1 = distance1/movespd
	
	time12 = time1 + time2
	
	totalTime = time1 + time2
	totalDistance = distance1 + distance2
	
	-- PrintChat("Needed time3: "..totalTime)
elseif place2 ~= nil then

	distance1 = DistanceBetween(place, place2)
	time01 = distance1/movespd
	
	
	
	totalTime = time01
	totalDistance = distance1
	
	-- PrintChat("Needed time2: "..totalTime)
	
end

ssec = 4

USER = KeyIsDown(82) --R
	if USER == true then
	
if totalTime ~= nil then
if place4 ~= nil and time123 ~= nil then
-- PrintChat("time123: "..time123)
end
if place3 ~= nil and time12 ~= nil then
PrintChat("time12: "..time12)
end
if place2 ~= nil and time01 ~= nil then
-- PrintChat("time01: "..time01)
end
end

if ssec ~= nil then
-- PrintChat("1") -- true
if ssec < 10 then --Done
-- PrintChat("2") -- True
if totalTime ~= nil then
-- PrintChat("3") -- true
	-- if totalTime <= ssec then
	-- PrintChat("Calculation!")
	if time123 ~= nil then
		if time123 <= ssec then
		    MoveTime = ssec - time123
		    PrintChat("Time3")
		    PrintChat("MoveTime: "..MoveTime)
		end	
	end
	
	
-- 3 Waypoints	
	if time12 ~= nil then
------------------------------------
	if place4 == nil then
------------------------------------	
		if time12 >= ssec then
		
------------------------------------		
			if time1 >= ssec then
			vector1 = VectorWay(place,place2)
			-- PrintChat("Movespeed: "..movespd)
			MoveTime = time1 - ssec
		
			EndPosX = place.x + (-MoveTime*(vector1.x / -time1))
			EndPosY = place.y + (-MoveTime*(vector1.y / -time1))
			EndPosZ = place.z + (-MoveTime*(vector1.z / -time1))
			EndPos = Vector(EndPosX,EndPosY,EndPosZ)
				PrintChat("HighHitChance12_1")
			end
		
-------------------
			
			
			if time12 >= ssec then
			vector2 = VectorWay(place2,place3)
			-- PrintChat("Movespeed: "..movespd)
			MoveTime = time2 - ssec
		
			EndPosX = place2.x + (-MoveTime*(vector2.x / -time2))
			EndPosY = place2.y + (-MoveTime*(vector2.y / -time2))
			EndPosZ = place2.z + (-MoveTime*(vector2.z / -time2))
			EndPos = Vector(EndPosX,EndPosY,EndPosZ)
				PrintChat("HighHitChance12_3")
			end
		
			if Config.hitchancelow then
			if time12 < ssec then
			vector2 = VectorWay(place2,place3)
			-- PrintChat("vector1x: "..vector1.x)
			MoveTime = time2 - ssec
		
			EndPosX = place2.x + (-MoveTime*(vector2.x / -time2))
			EndPosY = place2.y + (-MoveTime*(vector2.y / -time2))
			EndPosZ = place2.z + (-MoveTime*(vector2.z / -time2))
			EndPos = Vector(EndPosX,EndPosY,EndPosZ)
				PrintChat("LowHitChance12_4")
			end
			end			
			-- end
			
			DelayAction ( function ()
				place3 = nil
				place4 = nil
			end , 1000)
			
		end
		
	end
------------------------------------
	end

	
-- DO NOT TOUCH IT WORKS! Kappa 
	if time01 ~= nil then
	--------------------------------
	if place3 == nil then
	if place4 == nil then
	--------------------------------
		if time01 >= ssec then
	
	--------------------------------	
		vector1 = VectorWay(place,place2)
		MoveTime = time01 - ssec
		
		EndPosX = place.x + (-MoveTime*(vector1.x / -time01))
		EndPosY = place.y + (-MoveTime*(vector1.y / -time01))
		EndPosZ = place.z + (-MoveTime*(vector1.z / -time01))
		EndPos = Vector(EndPosX,EndPosY,EndPosZ)
		    PrintChat("HighHitChance1")
		end
		if Config.hitchancelow then
		if time01 < ssec then
		vector1 = VectorWay(place,place2)
		-- PrintChat("vector1x: "..vector1.x)
		MoveTime = time01 - ssec
		
		EndPosX = place.x + (-MoveTime*(vector1.x / -time01))
		EndPosY = place.y + (-MoveTime*(vector1.y / -time01))
		EndPosZ = place.z + (-MoveTime*(vector1.z / -time01))
		EndPos = Vector(EndPosX,EndPosY,EndPosZ)
		    PrintChat("LowHitChance1")
		end
		end
		
		
		DelayAction ( function ()
			place3 = nil
			place4 = nil
		end , 1000)	
		------------------
		end
		end
		------------------
	end
-- ^^^^^^^^	
		if 0 == ssec then
		    MoveTime = ssec
		    PrintChat("Time0")
		    PrintChat("MoveTime: "..MoveTime)
		end    
	elseif totalTime < ssec then
	
	-- end	
end
end
end


end

-- if ssec < 10 then
	-- if totalTime > ssec then
		-- vector1 = VectorWay(place,place2)
		-- EndPosX = place.x + (-ssec*(vector1.x))
		-- EndPosY = place.y + (-ssec*(vector1.y))
		-- EndPosZ = place.z + (-ssec*(vector1.z))
	-- elseif totalTime > ssec then
		-- vector2 = VectorWay(place2,place3)
		-- EndPosX = place2.x + (-ssec*(vector2.x))
		-- EndPosY = place2.y + (-ssec*(vector2.y))
		-- EndPosZ = place2.z + (-ssec*(vector2.z))
	-- elseif totalTime > ssec then
		-- vector3 = VectorWay(place3,place4)
		-- EndPosX = place3.x + (-ssec*(vector3.x))
		-- EndPosY = place3.y + (-ssec*(vector3.y))
		-- EndPosZ = place3.z + (-ssec*(vector3.z))
	-- end
if EndPosX ~= nil then	
	-- PrintChat("EndPosX: "..EndPosX)
	DrawCircle(EndPos,25,0,0,ARGB(255,0,255,0));
end	
end)

-- DistanceBetween2Points
function DistanceBetween(p1,p2)
return  math.sqrt(math.pow((p2.x - p1.x),2) + math.pow((p2.y - p1.y),2) + math.pow((p2.z - p1.z),2))
end
-- GetVectorXYZNeeded
function VectorWay(A,B)
WayX = B.x - A.x
WayY = B.y - A.y
WayZ = B.z - A.z
return Vector(WayX, WayY, WayZ)
end
