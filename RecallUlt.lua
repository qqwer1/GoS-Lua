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
dmg = function(target) return CalcDamage(myHero, target, 0, 60*GetCastLevel(myHero,_R)+ 30 + (0.44*GetBonusDmg(myHero)+GetBaseDamage(myHero))) end
},
["Ezreal"] = {
skillrange = 50000,
speedChamp = 2000,
delay = 1000,
colision = false,
-- dmg = function(target) return CalcDamage(myHero, target, 0, (150*GetCastLevel(myHero,_R)+ 40 + (0.80*GetBonusAP(myHero)) + (0.90*(GetBaseDamage(myHero) + GetBonusDmg(myHero))))) end
dmg = function(target) return CalcDamage(myHero, target, 0, 45*GetCastLevel(myHero,_R)+ 60 + (0.27*GetBonusAP(myHero)) + (0.90*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))) end
},
["Jinx"] = {
skillrange = 50000,
speedChamp = 2000,
-- speedSpawn = (GetDistance(enemyBasePos) / (1 + (GetDistance(enemyBasePos)-1700)/2600)),
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
["Lux"] = {
skillrange = 5400,
speedChamp = 5400/3.5,
delay = 0,
colision = false,
dmg = function(target) return CalcDamage(myHero, target, 0, 100*GetCastLevel(myHero,_R)+ 100 + 0.72*GetBonusAP(myHero)) end
},
}

if not supportedChamp[GetObjectName(myHero)] then return end

local recallMenu = Menu("RecallUlt", "RecallUlt1")
recallMenu:Boolean("recallult1", "Recall Ult (Beta)", true)
recallMenu:Boolean("recalldraw", "Draw Ult Pos", true)
recallMenu:Slider("timex","HitChance: 1=High 5=Low", 2, 1, 5, 1)

PrintChat("Noddy | RecallUlt loaded.")

global_ticks = 0
global_ticks1 = 0
TickerStart = 0

local skillrange = supportedChamp[GetObjectName(myHero)].skillrange
local speedChamp = supportedChamp[GetObjectName(myHero)].speedChamp
local delay = supportedChamp[GetObjectName(myHero)].delay
local dmg = supportedChamp[GetObjectName(myHero)].dmg

-- RECALL ULT
OnTick (function (myHero)

Ticker1 = GetTickCount()

if EndPos ~= nil and recallMenu.recalldraw:Value() then
DrawCircle(EndPos,25,1,255,0xff00ffff)
DrawCircle(enemyPos1,circlerange,1,100,0xff00ffff)
	DelayAction(function ()	
		EndPos = nil	
	end, 8000)
end

for i,enemy in pairs(GetEnemyHeroes()) do	

	if CanUseSpell(myHero,_R) == READY and recallMenu.recallult1:Value() and ValidTarget(enemy) and GetCurrentHP(enemy) < dmg(enemy) then
	
		Ticker = GetTickCount()
		
		if (global_ticks + 1000) < Ticker then
		DelayAction( function ()
		
			if IsVisible(enemy) then
			enemyPos2 = GetOrigin(enemy)
			-- PrintChat("enemyPos2")
			end
			
		end,1000)
		
		global_ticks = Ticker
		
		end

		
-- Start Timers

	if (global_ticks1 + 10) < Ticker1 and GetCurrentHP(enemy) < dmg(enemy) then
	
		DelayAction( function ()
			if not IsVisible(enemy) then
				-- PrintChat("Start!")
				enemyPos1 = GetOrigin(enemy)
				TickerStart = GetTickCount()
			end
			if IsVisible(enemy) and GotBuff(enemy,"recall") == 1 then
				TickerStart = GetTickCount()
				-- PrintChat("Start! Visible")
			end
			
		 end , 10) 
		global_ticks1 = Ticker1

	end	
	
end
end	
end)

OnProcessRecall(function(Object,recallProc)

if recallProc.isStart == true then

if CanUseSpell(myHero,_R) == READY and GetTeam(Object) ~= GetTeam(myHero) and GetObjectType(Object) == GetObjectType(myHero) and GetCurrentHP(Object)+GetHPRegen(Object)*recallMenu.timex:Value() < dmg(Object) and recallMenu.recallult1:Value() then

enemyPos1 = GetOrigin(Object)

if enemyPos2 ~= nil and enemyPos1 ~= nil then

local x1 = enemyPos2.x - enemyPos1.x
local y1 = enemyPos2.y - enemyPos1.y
local z1 = enemyPos2.z - enemyPos1.z

		local TickerEnd = GetTickCount()
		local s = TickerEnd - TickerStart
		local ssec = s / 1000
	
	PrintChat("Sec: "..ssec)
	
	local t = recallProc.totalTime

	local myHeroPos = GetOrigin(myHero)
	local targetPos = GetOrigin(Object)
	circlerange = GetMoveSpeed(Object)*ssec
	
		local EndPosX = targetPos.x + (-ssec*(x1))
		local EndPosY = targetPos.y + (-ssec*(y1))
		local EndPosZ = targetPos.z + (-ssec*(z1))

		EndPos = Vector(EndPosX,EndPosY,EndPosZ)
		
	local distanceChamp = math.sqrt(math.pow((myHeroPos.x - EndPosX),2) + math.pow((myHeroPos.y - EndPosY),2) + math.pow((myHeroPos.z - EndPosZ),2))

	tChamp = ((distanceChamp / speedChamp) + (delay/1000)) * 1000

	if GetDistance(targetPos,EndPos) < GetMoveSpeed(Object)*ssec then
	
		if tChamp < t and ssec < recallMenu.timex:Value() and distanceChamp <= skillrange then

			PrintChat("RecallUlt on "..GetObjectName(Object))
			CastSkillShot(_R, EndPosX, EndPosY, EndPosZ)
			enemyPos2 = nil
		end
	end
	
end		
end
end	
end)
