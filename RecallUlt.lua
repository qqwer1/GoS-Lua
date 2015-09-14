require('InspiredNew')

recallMenu = Menu("RecallUlt", "RecallUlt1")
recallMenu:SubMenu("recallult", "Recall Ult (Beta)")
recallMenu.recallult:Boolean("recallult1", "Recall Ult (Beta)", true)
recallMenu.recallult:Boolean("recalldraw", "Draw Ult Pos", true)
recallMenu:SubMenu("baseult", "BaseUlt")
recallMenu.baseult:Boolean("baseult1", "Base Ult", true)


PrintChat("Noddy | RecallUlt loaded.")

global_ticks = 0
global_ticks1 = 0
TickerStart = 0

local myHero = GetMyHero()

-- Team
if GetTeam(myHero) == 100 then 
	enemyBasePos = Vector(14340, 171, 14390)
elseif GetTeam(myHero) == 200 then 
	enemyBasePos = Vector(400, 200, 400)
end


-- Champ List 
--Ashe
if GetObjectName(myHero) == "Ashe" then 
skillrange = 50000
speedChamp = 1600
speedSpawn = 1600
delay = 250
colision = true
dmg = function(target) return GoS:CalcDamage(myHero, target, 0, 175*GetCastLevel(myHero,_R)+ 75 + GetBonusAP(myHero)) end
--Draven
elseif GetObjectName(myHero) == "Draven" then
skillrange = 50000
speedChamp = 2000
speedSpawn = 2000
delay = 400
colision = false
dmg = function(target) return GoS:CalcDamage(myHero, target, 0, 60*GetCastLevel(myHero,_R)+ 30 + (0.44*GetBonusDmg(myHero)+GetBaseDamage(myHero))) end
--Ezreal
elseif GetObjectName(myHero) == "Ezreal" then
skillrange = 50000
speedChamp = 2000
speedSpawn = 2000
delay = 1000
colision = false
-- dmg = function(target) return GoS:CalcDamage(myHero, target, 0, (150*GetCastLevel(myHero,_R)+ 40 + (0.80*GetBonusAP(myHero)) + (0.90*(GetBaseDamage(myHero) + GetBonusDmg(myHero))))) end
dmg = function(target) return GoS:CalcDamage(myHero, target, 0, 45*GetCastLevel(myHero,_R)+ 60 + (0.27*GetBonusAP(myHero)) + (0.90*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))) end
--Jinx
elseif GetObjectName(myHero) == "Jinx" then 
skillrange = 50000
speedChamp = 2000
speedSpawn = (GoS:GetDistance(enemyBasePos) / (1 + (GoS:GetDistance(enemyBasePos)-1700)/2600))
delay = 600
colision = true
dmg = function(target) return GoS:CalcDamage(myHero, target, ((GetMaxHP(target)-GetCurrentHP(target))*(0.2+0.05*GetCastLevel(myHero, _R))) + 100*GetCastLevel(myHero,_R) + 150 + GetBonusDmg(myHero)) end
--Gangplank
elseif GetObjectName(myHero) == "Gangplank" then
skillrange = 50000
speedChamp = 500000
speedSpawn = 500000
delay = 0
colision = false
dmg = function(target) return GoS:CalcDamage(myHero, target, 0, 20*GetCastLevel(myHero,_R)+ 30 + 0.1*GetBonusAP(myHero)) end
--Lux
elseif GetObjectName(myHero) == "Lux" then
skillrange = 3340
speedChamp = 33400
speedSpawn = 33400
delay = 500
colision = false
dmg = function(target) return GoS:CalcDamage(myHero, target, 0, 100*GetCastLevel(myHero,_R)+ 200 + 0.75*GetBonusAP(myHero)) end
--Ziggs
elseif GetObjectName(myHero) == "Ziggs" then
skillrange = 5400
speedChamp = skillrange/3.5
speedSpawn = skillrange/3.5
delay = 0
colision = false
dmg = function(target) return GoS:CalcDamage(myHero, target, 0, 100*GetCastLevel(myHero,_R)+ 100 + 0.72*GetBonusAP(myHero)) end
end

-- RECALL ULT
OnLoop (function (myHero)

Ticker1 = GetTickCount()

if EndPos ~= nil and recallMenu.recallult.recalldraw:Value() then
DrawCircle(EndPos,25,1,100,0xff00ffff)
	GoS:DelayAction(function ()	
		EndPos = nil	
	end, 8000)
end

for i,enemy in pairs(GoS:GetEnemyHeroes()) do	
	if CanUseSpell(myHero,_R) == READY and recallMenu.recallult.recallult1:Value() and GoS:ValidTarget(enemy) and GetCurrentHP(enemy) < dmg(enemy) then

		Ticker = GetTickCount()
		
		if (global_ticks + 1000) < Ticker then
		GoS:DelayAction( function ()
		
			if IsVisible(enemy) then
			enemyPos2 = GetOrigin(enemy)
			-- PrintChat("enemyPos2")
			end
			
		end,1000)
		
		global_ticks = Ticker
		
		end

		
-- Start Timers

	if (global_ticks1 + 10) < Ticker1 and GetCurrentHP(enemy) < dmg(enemy) then
	
		GoS:DelayAction( function ()
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

if CanUseSpell(myHero,_R) == READY and GetTeam(Object) ~= GetTeam(myHero) and GetCurrentHP(Object)+GetHPRegen(Object)*3 < dmg(Object) and recallMenu.recallult.recallult1:Value() then

enemyPos1 = GetOrigin(Object)

if enemyPos2 ~= nil and enemyPos1 ~= nil then
x1 = enemyPos2.x - enemyPos1.x
y1 = enemyPos2.y - enemyPos1.y
z1 = enemyPos2.z - enemyPos1.z


		TickerEnd = GetTickCount()
		s = TickerEnd - TickerStart
		ssec = s / 1000
	
	-- PrintChat("Sec: "..ssec)
	
	if ssec < 3 then
		PrintChat("RecallUlt on "..GetObjectName(Object))
	elseif ssec > 3 and recallMenu.baseult.baseult1:Value() and GoS:GetDistance(enemyBasePos) <= skillrange then
		PrintChat("BaseUlt on "..GetObjectName(Object))
	end
	
	local t = recallProc.totalTime

	local myHeroPos = GetOrigin(myHero)
	local targetPos = GetOrigin(Object)
	
		EndPosX = targetPos.x + (-ssec*(x1))
		EndPosY = targetPos.y + (-ssec*(y1))
		EndPosZ = targetPos.z + (-ssec*(z1))

		 EndPos = Vector(EndPosX,EndPosY,EndPosZ)
		
	distanceChamp = math.sqrt(math.pow((myHeroPos.x - EndPosX),2) + math.pow((myHeroPos.y - EndPosY),2) + math.pow((myHeroPos.z - EndPosZ),2))

	tChamp = ((distanceChamp / speedChamp) + (delay/1000)) * 1000
	
	
		if tChamp < t and ssec < 3 and distanceChamp <= skillrange then

			-- PrintChat("RecallUlt on "..GetObjectName(Object))
			CastSkillShot(_R, EndPosX, EndPosY, EndPosZ)
			enemyPos2 = nil
		end
end		
end
end	
end)

-- BASE ULT --------------------
OnProcessRecall(function(Object,recallProc)

if recallProc.isStart == true then

	if CanUseSpell(myHero,_R) == READY and GetTeam(Object) ~= GetTeam(myHero) and GetCurrentHP(Object)+GetHPRegen(Object)*8 < dmg(Object) and recallMenu.baseult.baseult1:Value() then

	local t = recallProc.totalTime	
	local myHeroPos = GetOrigin(myHero)
	
	tSpawn = ((GoS:GetDistance(enemyBasePos) / speedSpawn) + (delay/1000)) * 1000
	distanceSpawn = GoS:GetDistance(enemyBasePos)

	tt = t - tSpawn

		if (tSpawn+delay) < t and distanceSpawn <= skillrange then
					-- PrintChat("BaseUlt on "..GetObjectName(Object))
					GoS:DelayAction( function()
						CastSkillShot(_R,enemyBasePos.x,enemyBasePos.y,enemyBasePos.z) end
						, tt)
		end
	
end	
end	
end)
