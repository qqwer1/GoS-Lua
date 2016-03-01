if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua!") return end

-- Champ List 
local supportedChamp = {
["Ashe"] = {
skillrange = 50000,
speedChamp = 1600,
delay = 250,
colision = true,
dmg = function(target) return CalcDamage(myHero, target, 0, 175*GetCastLevel(myHero,_R)+ 75 + GetBonusAP(myHero)) end
},
["Draven"] = {
skillrange = 50000,
speedChamp = 2000,
delay = 400,
colision = false,
dmg = function(target) return CalcDamage(myHero, target, 60*GetCastLevel(myHero,_R)+ 30 + (0.44*GetBonusDmg(myHero)+GetBaseDamage(myHero)),0) end
},
["Ezreal"] = {
skillrange = 50000,
speedChamp = 2000,
delay = 1000,
colision = false,
dmg = function(target) return CalcDamage(myHero, target, 0, 45*GetCastLevel(myHero,_R)+ 60 + (0.27*GetBonusAP(myHero)) + (0.90*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))) end
},
["Jinx"] = {
skillrange = 50000,
speedChamp = 2000,
delay = 600,
colision = true,
dmg = function(target) return CalcDamage(myHero, target, ((GetMaxHP(target)-GetCurrentHP(target))*(0.2+0.05*GetCastLevel(myHero, _R))) + 100*GetCastLevel(myHero,_R) + 150 + GetBonusDmg(myHero)) end
},
["Gangplank"] = {
skillrange = 50000,
speedChamp = math.huge,
delay = 0,
colision = false,
dmg = function(target) return CalcDamage(myHero, target, 0, 20*GetCastLevel(myHero,_R)+ 30 + 0.1*GetBonusAP(myHero)) end
},
["Lux"] = {
skillrange = 3340,
speedChamp = math.huge,
delay = 500,
colision = false,
dmg = function(target) return CalcDamage(myHero, target, 0, 100*GetCastLevel(myHero,_R)+ 200 + 0.75*GetBonusAP(myHero)) end
},
["Ziggs"] = {
skillrange = 5400,
speedChamp = 5400/3.5,
delay = 0,
colision = false,
dmg = function(target) return CalcDamage(myHero, target, 0, 100*GetCastLevel(myHero,_R)+ 100 + 0.72*GetBonusAP(myHero)) end
},
}

if not supportedChamp[GetObjectName(myHero)] then return end

local recallMenu = Menu("RecallUlt", "RecallUlt")
recallMenu:Boolean("recallult1", "Recall Ult", true)
-- recallMenu:Menu("ultA","Ult On:")
-- DelayAction(function()
-- for i,enemy in pairs(GetEnemyHeroes()) do
 -- recallMenu.ultA:Boolean(i,GetObjectName(enemy), true)
-- end
-- end,0.01)
recallMenu:Boolean("recalldraw", "Draw Ult Pos", true)
recallMenu:Slider("timex","HitChance: 1=High 3.5=Low", 3, 1, 3.5, .1)
recallMenu:Slider("extraDelay","Extra Delay (sec)", 2, 0, 5, .1)
recallMenu:Boolean("print", "Print Information", true)
recallMenu:Key("dontUlt", "Don't Ult if Combo is active", string.byte(" "))

local skillrange = supportedChamp[GetObjectName(myHero)].skillrange
local speedChamp = supportedChamp[GetObjectName(myHero)].speedChamp
local delay = supportedChamp[GetObjectName(myHero)].delay
local dmg = supportedChamp[GetObjectName(myHero)].dmg

local global_ticks = 0
local global_ticks1 = 0
local global_ticks2 = 0

local tName
local tHP

local WP1 = {}
local WP2 = {}
local WP3 = {}
local WP4 = {}

DelayAction(function()
OnProcessWaypoint(function(Object,waypointProc)
if GetTeam(Object) ~= GetTeam(myHero) and GetObjectType(Object) == Obj_AI_Hero then
-- Del
if WP1[GetNetworkID(Object)] ~= nil then
	WP1[GetNetworkID(Object)] = nil
end	
if WP2[GetNetworkID(Object)] ~= nil then
	WP2[GetNetworkID(Object)] = nil
end	
if WP3[GetNetworkID(Object)] ~= nil then
	WP3[GetNetworkID(Object)] = nil
end	
if WP4[GetNetworkID(Object)] ~= nil then
	WP4[GetNetworkID(Object)] = nil
end

-- Add
check = true

DelayAction(function()

	if waypointProc.index == 1 then
		startTime = GetGameTimer()
		WP1[GetNetworkID(Object)] = waypointProc.position;
		end
	if waypointProc.index == 2 then
		WP2[GetNetworkID(Object)] = waypointProc.position;
		end
	if waypointProc.index == 3 then
		WP3[GetNetworkID(Object)] = waypointProc.position;
		end	
	if waypointProc.index == 4 then
		WP4[GetNetworkID(Object)] = waypointProc.position;
		if GetDistance(Object,waypointProc.position) > 50 then
		 check = false
		end
		end		
		
end, .001)

end
end)

OnTick(function(myHero)

for i,enemy in pairs(GetEnemyHeroes()) do

-- Start Timers
if ValidTarget(enemy) and GetCurrentHP(enemy) < dmg(enemy) and CanUseSpell(myHero,_R) == READY then
local Ticker1 = GetTickCount()
	if (global_ticks1 + 1) < Ticker1 then
		DelayAction(function ()
			if not IsVisible(enemy) then

				inStart = GetGameTimer()
			end			
		 end , .001) 
		global_ticks1 = Ticker1
	end	
end

end

if Pos ~= nil and ultON == true then
	if recallMenu.print:Value() then
	local Ticker2 = GetTickCount()
	if (global_ticks2 + 5000) < Ticker2 then
		PrintChat("Possible RecallUlt on "..tName.."! Is backing with "..tHP.." HP")
	global_ticks2 = Ticker2
	end	
	end
	DelayAction(function()
		if ultON == true and Pos ~= nil and not recallMenu.dontUlt:Value() and GetDistance(myHero,Pos) <= skillrange and recallMenu.recallult1:Value() then
			CastSkillShot(_R,Pos)
			DelayAction(function()
				Pos = nil
			end,(GetDistance(myHero,Pos)/speedChamp))
		end
	end, recallMenu.extraDelay:Value())
end

end)

OnDraw(function(myHero)
	if Pos ~= nil and recallMenu.recalldraw:Value() then
		DrawCircle(Pos,25,2,0,ARGB(255,55,255,255));
		DrawCircle(unitPos,circleRange,2,100,ARGB(255,55,255,255));
	end
end)

OnProcessRecall(function(unit,recall)

if CanUseSpell(myHero,_R) == READY and GetTeam(unit) ~= GetTeam(myHero) and GetObjectType(unit) == GetObjectType(myHero) and GetCurrentHP(unit)+GetHPRegen(unit)*(recallMenu.timex:Value() + GetDistance(myHero,unit)/speedChamp) < dmg(unit) and recallMenu.recallult1:Value() and inStart ~= nil and GetDistance(myHero,unit) <= skillrange then
if recall.isStart == true then

	if recallMenu.print:Value() and recall.totalTime/1000 > GetDistance(myHero,unit)/speedChamp + recallMenu.extraDelay:Value() then
		tName = GetObjectName(unit)
		tHP = math.floor(GetCurrentHP(unit))
	end
	passedTime = GetGameTimer() - inStart

	if check == true and passedTime <= recallMenu.timex:Value() then
	local movespd = GetMoveSpeed(unit)
	circleRange = movespd * passedTime
	unitPos = GetOrigin(unit)
-- WP2
	if WP1[GetNetworkID(unit)] ~= nil and WP2[GetNetworkID(unit)] ~= nil and WP3[GetNetworkID(unit)] == nil and WP4[GetNetworkID(unit)] == nil then
		local xTime = DistanceBetween(WP1[GetNetworkID(unit)],WP2[GetNetworkID(unit)])/movespd

		local moveTime = xTime-passedTime
		local WayVector =  VectorWay(WP1[GetNetworkID(unit)],WP2[GetNetworkID(unit)])
		Pos = WP1[GetNetworkID(unit)] + (-moveTime*(WayVector/-xTime))
		-- DrawCircle(Pos,25,2,0,ARGB(255,55,255,255));
	end
	
-- WP3
	if WP1[GetNetworkID(unit)] ~= nil and WP2[GetNetworkID(unit)] ~= nil and WP3[GetNetworkID(unit)] ~= nil and WP4[GetNetworkID(unit)] == nil then
		
		local xTime1 = DistanceBetween(WP1[GetNetworkID(unit)],WP2[GetNetworkID(unit)])/movespd
		local xTime2 = DistanceBetween(WP2[GetNetworkID(unit)],WP3[GetNetworkID(unit)])/movespd
		
		local moveTime1 = xTime1-(passedTime-xTime2)
		local moveTime2 = xTime2-(passedTime)

		local WayVector1 =  VectorWay(WP1[GetNetworkID(unit)],WP2[GetNetworkID(unit)])
		local WayVector2 =  VectorWay(WP2[GetNetworkID(unit)],WP3[GetNetworkID(unit)])

		if moveTime2 > 0 then
			Pos = WP2[GetNetworkID(unit)] + (-moveTime2*(WayVector2/-xTime2))
		end
		if moveTime2 < 0 then
			Pos = WP1[GetNetworkID(unit)] + (-moveTime1*(WayVector1/-xTime1))
		end

		-- DrawCircle(Pos,25,2,0,ARGB(255,55,255,255));

	end
-- WP4
	if WP1[GetNetworkID(unit)] ~= nil and WP2[GetNetworkID(unit)] ~= nil and WP3[GetNetworkID(unit)] ~= nil and WP4[GetNetworkID(unit)] ~= nil then
		
		local xTime1 = DistanceBetween(WP1[GetNetworkID(unit)],WP2[GetNetworkID(unit)])/movespd
		local xTime2 = DistanceBetween(WP2[GetNetworkID(unit)],WP3[GetNetworkID(unit)])/movespd
		local xTime3 = DistanceBetween(WP3[GetNetworkID(unit)],WP4[GetNetworkID(unit)])/movespd
		
		local moveTime1 = xTime1-(passedTime-xTime3-xTime2)
		local moveTime2 = xTime2-(passedTime-xTime3)
		local moveTime3 = xTime3-(passedTime)

		local WayVector1 =  VectorWay(WP1[GetNetworkID(unit)],WP2[GetNetworkID(unit)])
		local WayVector2 =  VectorWay(WP2[GetNetworkID(unit)],WP3[GetNetworkID(unit)])
		local WayVector3 =  VectorWay(WP3[GetNetworkID(unit)],WP4[GetNetworkID(unit)])
		
		if moveTime3 > 0 then
			Pos = WP3[GetNetworkID(unit)] + (-moveTime3*(WayVector3/-xTime3))
		end
		if moveTime3 < 0 and moveTime2 > 0 then
			Pos = WP2[GetNetworkID(unit)] + (-moveTime2*(WayVector2/-xTime2))
		end
		if moveTime2 < 0 and moveTime3 < 0 then
			Pos = WP1[GetNetworkID(unit)] + (-moveTime1*(WayVector1/-xTime1))
		end

		-- DrawCircle(Pos,25,2,0,ARGB(255,55,255,255));

	end
	
	if recall.totalTime/1000 > GetDistance(myHero,Pos)/speedChamp + recallMenu.extraDelay:Value() then
		ultON = true
	end
	
end

-- end

elseif recall.isFinish == true then
	ultON = false
	Pos = nil
else
	ultON = false
	Pos = nil
end

end

end)

end,0.01)

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

PrintChat("RecallUlt loaded.")
