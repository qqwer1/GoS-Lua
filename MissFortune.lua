if GetObjectName(GetMyHero()) ~= "MissFortune" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua!") return end

PrintChat("ADC MAIN | MissFortune loaded.")
PrintChat("by Noddy")

local mainMenu = Menu("ADC MAIN | MissFortune", "MissFortune")
mainMenu:Menu("Combo", "Combo")
mainMenu.Combo:Boolean("useQ", "Use Q", true)
mainMenu.Combo:Boolean("useQminion", "Use Q through minion", true)
mainMenu.Combo:Boolean("useAutoQ", "Use auto Q through dead minion", true)
mainMenu.Combo:Boolean("useW", "Use W", true)
mainMenu.Combo:Boolean("useE", "Use E", true)
mainMenu.Combo:Boolean("useR", "Use R", true)
mainMenu.Combo:Slider("useRx","Use R if can hit X", 3, 1, 5, 1)
mainMenu.Combo:Key("Combo1", "Combo", string.byte(" "))
------------------------------------------------------------------
mainMenu:Menu("Harass", "Harass")
mainMenu.Harass:Boolean("useQ", "Use Q", true)
mainMenu.Harass:Boolean("useQminion", "Use Q through minion", true)
mainMenu.Harass:Key("Harass1", "Harass", string.byte("C"))
------------------------------------------------------------------
mainMenu:Key("Lasthit1", "Lasthit helper", string.byte("X"))
------------------------------------------------------------------
mainMenu:Menu("Items", "Items")
mainMenu.Items:Boolean("useCut", "Bilgewater Cutlass", true)
mainMenu.Items:Boolean("useBork", "Blade of the Ruined King", true)
mainMenu.Items:Boolean("useGhost", "Youmuu's Ghostblade", true)
mainMenu.Items:Boolean("useRedPot", "Elixir of Wrath", true)
------------------------------------------------------------------
local myHitBox = GetHitBox(myHero)
local baseAS = GetBaseAttackSpeed(myHero)
local passiveMinion = nil
local atk = true
local windup = 200
local ULT = false

OnProcessSpell(function(unit,spell)
	if unit == myHero and spell.name:lower():find("attack") and spell.target == GetCurrentTarget() and mainMenu.Combo.Combo1:Value() and mainMenu.Combo.useW:Value() and CanUseSpell(myHero,_W) == READY then
		CastSpell(_W)
	end
	if unit == myHero and spell.name == "MissFortuneBulletTime" then
		ULT = true
		IOW.movementEnabled = false
	end
end)

OnProcessSpellComplete(function(unit, spell)
if unit == myHero and spell.name:lower():find("attack") then
windup = spell.windUpTime*1000
ASDelay = 1/(baseAS*GetAttackSpeed(myHero))
atk = false
IOW.movementEnabled = true

DelayAction(function()
	atk = true
end, ASDelay*1000 - spell.windUpTime*1000)
end
if CanUseSpell(myHero,_Q) == READY then
	if unit == myHero and spell.name:lower():find("attack") and spell.target == target and ValidTarget(target, 650) and mainMenu.Combo.Combo1:Value() and mainMenu.Combo.useQ:Value() then
		CastTargetSpell(target,_Q)
	end
	if unit == myHero and spell.name:lower():find("attack") and spell.target == target and ValidTarget(target, 650) and mainMenu.Harass.Harass1:Value() and mainMenu.Harass.useQ:Value() then
		CastTargetSpell(target,_Q)
	end
end
end)

OnCreateObj(function(Object)
if GetObjectBaseName(Object) == "MissFortune_Base_P_Mark.troy" then
	passive = Object
end
end)

OnUpdateBuff(function(unit,buff)
if unit == myHero and buff.Name == "missfortunebulletsound" then
	ULT = true
	IOW.movementEnabled = false
end
end)

OnRemoveBuff(function(unit,buff)
if unit == myHero and buff.Name == "missfortunebulletsound" then
	ULT = false
	IOW.movementEnabled = true
end
end)

OnTick(function(myHero)
if passive ~= nil then
	passiveMinion = ClosestMinion((GetOrigin(passive)), ENEMY)
	if GetDistance(passiveMinion,passive) > 10 then
		passiveMinion = nil
	end
end

target = GetCurrentTarget()
local myHeroPos = GetOrigin(myHero)
local myHeroRange = GetRange(myHero)

-- Items
local CutBlade = GetItemSlot(myHero,3144)
local bork = GetItemSlot(myHero,3153)
local ghost = GetItemSlot(myHero,3142)
local redpot = GetItemSlot(myHero,2140)

if mainMenu.Combo.useAutoQ:Value() then

for i,enemy in pairs(GetEnemyHeroes()) do
if CanUseSpell(myHero,_Q) == READY and ValidTarget(enemy, 900) then
	for i,minion in pairs(minionManager.objects) do
		if MINION_ENEMY == GetTeam(minion) then
			local QPred = GetPredictionForPlayer(myHeroPos, enemy, GetMoveSpeed(enemy),5000, 250, 1000, 0, false, false)
			if QPred.HitChance == 1 then
				if ValidTarget(minion, 650) and GetDistance(minion, enemy) < 400 and ValidTarget(enemy, 900) then
					local minionC = ClosestMinion(GetOrigin(enemy), ENEMY)
					if ValidTarget(minionC, 650) then
					 local checkPos = myHeroPos + (VectorWay(myHeroPos,GetOrigin(minion))/GetDistance(myHero,minion))*775
						if minionC ~= passiveMinion and GetDistance(QPred.PredPos, checkPos) < 250 and GetCurrentHP(minionC)-GetDamagePrediction(minionC,(GetDistance(myHero,minionC)/1200)*1000 + 250) < CalcDamage(myHero, minionC, 15*GetCastLevel(myHero,_Q) + 5 + 0.85*(GetBaseDamage(myHero)+GetBonusDmg(myHero)) + (0.30*(GetBaseDamage(myHero)+GetBonusDmg(myHero))) , 0) then
							CastTargetSpell(minion,_Q)
						elseif  minionC == passiveMinion and GetDistance(QPred.PredPos, checkPos) < 250 and GetCurrentHP(minionC)-GetDamagePrediction(minionC,(GetDistance(myHero,minionC)/1200)*1000 + 250) < CalcDamage(myHero, minionC, 15*GetCastLevel(myHero,_Q) + 5 + 0.85*(GetBaseDamage(myHero)+GetBonusDmg(myHero)), 0) then
							CastTargetSpell(minion,_Q)
						end
					end
				end
			end
		end
	end
end
end
end
-- Waves
if CanUseSpell(myHero,_R) == READY and mainMenu.Combo.useR:Value() and ValidTarget(target, 1500) then
if not IsInDistance(target, 550+myHitBox) and IsInDistance(target, 700) then
	wave = 5
elseif not IsInDistance(target, 550+myHitBox) and IsInDistance(target, 800) then
	wave = 4
elseif not IsInDistance(target, 550+myHitBox) and IsInDistance(target, 900) then
	wave = 3
elseif not IsInDistance(target, 550+myHitBox) and IsInDistance(target, 1000) then
	wave = 2
elseif not IsInDistance(target, 550+myHitBox) and IsInDistance(target, 1100) then
	wave = 1
elseif not IsInDistance(target, 550+myHitBox) and IsInDistance(target, 1200) then
	wave = 0
end
end
-- Use Items
if mainMenu.Combo.Combo1:Value() then
	if CutBlade >= 1 and ValidTarget(target,550) and mainMenu.Items.useCut:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,3144)) == READY then
			CastTargetSpell(target, GetItemSlot(myHero,3144))
		end	
	elseif bork >= 1 and ValidTarget(target,550) and (GetMaxHP(myHero) / GetCurrentHP(myHero)) >= 1.25 and mainMenu.Items.useBork:Value() then 
		if CanUseSpell(myHero,GetItemSlot(myHero,3153)) == READY then
			CastTargetSpell(target,GetItemSlot(myHero,3153))
		end
	end

	if ghost >= 1 and ValidTarget(target,550+myHitBox) and mainMenu.Items.useGhost:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,3142)) == READY then
			CastSpell(GetItemSlot(myHero,3142))
		end
	end
	
	if redpot >= 1 and ValidTarget(target,550+myHitBox) and mainMenu.Items.useRedPot:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,2140)) == READY then
			CastSpell(GetItemSlot(myHero,2140))
		end
	end
	
-- Combo --
-----------

if CanUseSpell(myHero,_Q) == READY and mainMenu.Combo.useQ and ValidTarget(target, 650 + myHitBox) and GetCurrentHP(target) - GetDamagePrediction(target,(GetDistance(myHero,target)/1200)*1000) < CalcDamage(myHero, target, 15*GetCastLevel(myHero,_Q) + 5 + 0.85*(GetBaseDamage(myHero)+GetBonusDmg(myHero)), 0) then
	CastTargetSpell(target,_Q)
end
if CanUseSpell(myHero,_Q) == READY and ValidTarget(target, 900) and mainMenu.Combo.useQ:Value() and mainMenu.Combo.useQminion:Value() then
	for i,minion in pairs(minionManager.objects) do
		if MINION_ENEMY == GetTeam(minion) then
			local QPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),5000, 250, 1000, 0, false, false)
			if QPred.HitChance == 1 then
				if ValidTarget(minion, 650) and GetDistance(minion, target) < 400 and ValidTarget(target, 900) then
					local minionC = ClosestMinion(GetOrigin(target), ENEMY)
					if ValidTarget(minionC, 650) then
					 local checkPos = myHeroPos + (VectorWay(myHeroPos,GetOrigin(minion))/GetDistance(myHero,minion))*775
						if GetDistance(QPred.PredPos, checkPos) < 250 then
							CastTargetSpell(minion,_Q)
						end
					end
				end
			end
		end
	end
end
if ULT == false and CanUseSpell(myHero,_E) == READY and ValidTarget(target, 1000) and not IsInDistance(target, 550 + myHitBox) and mainMenu.Combo.useE:Value() then
	local EPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),math.huge, 250, 1000, 1000, false, true)
	if EPred.HitChance == 1 then
		CastSkillShot(_E, EPred.PredPos)
	end
elseif ULT == false and CanUseSpell(myHero,_E) == READY and ValidTarget(target, 600) and mainMenu.Combo.useE:Value() then
	local EPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),math.huge, 250, 1000, 1000, false, true)
	if EPred.HitChance == 1 and GetDistance(myHero, Vector(EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)) < 200 then
		CastSkillShot(_E, EPred.PredPos)
	end
end

if ULT == false and CanUseSpell(myHero,_R) == READY and ValidTarget(target, 1400) and EnemiesAround(myHeroPos, 550+myHitBox) == 0 and not IsInDistance(target, 550+myHitBox) and mainMenu.Combo.useR:Value() then
if GetCurrentHP(target) < CalcDamage(myHero,target,0.75*(GetBaseDamage(myHero)+GetBonusDmg(myHero)),0.25*GetBonusAP(myHero))*(2*GetCastLevel(myHero,_R)+wave) then
	local RPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),2500, 250, 1400, 350, false, true)
	if RPred.HitChance == 1 then
		IOW.movementEnabled = false
		CastSkillShot(_R,RPred.PredPos)
		DelayAction(function()
			IOW.movementEnabled = true
		end, 3000)
	end
end
elseif ULT == true and ValidTarget(target, 1400) and IsInDistance(target, 500+myHitBox) then
	IOW.movementEnabled = true
end

for i,enemy in pairs(GetEnemyHeroes()) do
if ULT == false and CanUseSpell(myHero,_R) == READY and ValidTarget(target, 1400) and EnemiesAround(myHeroPos, 550+myHitBox) == 0 and not IsInDistance(target, 550+myHitBox) and mainMenu.Combo.useR:Value() and CountObjectsOnLineSegment(myHeroPos, (myHeroPos+((VectorWay(myHeroPos,GetOrigin(target))/GetDistance(myHero,target))*1250)), 300, GetEnemyHeroes()) >= mainMenu.Combo.useRx:Value() and GetCurrentHP(enemy) < CalcDamage(myHero,enemy,0.75*(GetBaseDamage(myHero)+GetBonusDmg(myHero)),0.25*GetBonusAP(myHero))*(2*GetCastLevel(myHero,_R)+5) then
	local RPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),2500, 250, 1400, 350, false, true)
	if RPred.HitChance == 1 then
		IOW.movementEnabled = false
		CastSkillShot(_R,RPred.PredPos)
		DelayAction(function()
			IOW.movementEnabled = true
		end, 3000)
	end
end
end

end

if mainMenu.Harass.Harass1:Value() then
for i,enemy in pairs(GetEnemyHeroes()) do
if CanUseSpell(myHero,_Q) == READY and ValidTarget(enemy, 900) and mainMenu.Harass.useQ:Value() and mainMenu.Harass.useQminion:Value() then
	for i,minion in pairs(minionManager.objects) do
		if MINION_ENEMY == GetTeam(minion) then
			local QPred = GetPredictionForPlayer(myHeroPos, enemy, GetMoveSpeed(enemy),5000, 250, 1000, 0, false, false)
			if QPred.HitChance == 1 then
				if ValidTarget(minion, 650) and GetDistance(minion, enemy) < 400 and ValidTarget(enemy, 900) then
					local minionC = ClosestMinion(GetOrigin(enemy), ENEMY)
					if ValidTarget(minionC, 650) then
					 local checkPos = myHeroPos + (VectorWay(myHeroPos,GetOrigin(minion))/GetDistance(myHero,minion))*775
						if GetDistance(QPred.PredPos, checkPos) < 250 then
							
							CastTargetSpell(minion,_Q)
						end
					end
				end
			end
		end
	end
end
end
end

if mainMenu.Lasthit1:Value() then
	for i,minion in pairs(minionManager.objects) do
		if MINION_ENEMY == GetTeam(minion) then
			if ValidTarget(minion, myHeroRange) and GetDistance(myHero, minion) < myHeroRange then
				local minionInRange = minion
				if atk == true and minionInRange ~= passiveMinion and GetCurrentHP(minionInRange) - GetDamagePrediction(minionInRange,((GetDistance(myHero,minionInRange)/2000)*1000) + windup)  < CalcDamage(myHero,minionInRange,GetBaseDamage(myHero)+GetBonusDmg(myHero) + (0.30*(GetBaseDamage(myHero)+GetBonusDmg(myHero))),0) then
					IOW.movementEnabled = false
					DelayAction(function()
						AttackUnit(minionInRange)
					end, 1)
					DelayAction(function()
						IOW.movementEnabled = true
					end, windup)
				end
			end
		end
	end
end

end)

OnDraw(function(myHero)
-- DrawCircle(GetOrigin(myHero),1250,0,155,ARGB(255,255,255,255))
if ValidTarget(target,1400) and mainMenu.Combo.useR:Value() and wave ~= nil and CanUseSpell(myHero,_R) == READY then	
	DrawDmgOverHpBar(target,GetCurrentHP(target),CalcDamage(myHero,target,0.75*(GetBaseDamage(myHero)+GetBonusDmg(myHero)),0.25*GetBonusAP(myHero))*(2*GetCastLevel(myHero,_R)+wave),0,0xff00ff00)
	DrawDmgOverHpBar(target,GetCurrentHP(target)-CalcDamage(myHero,target,0.75*(GetBaseDamage(myHero)+GetBonusDmg(myHero)),0.25*GetBonusAP(myHero))*(2*GetCastLevel(myHero,_R)+wave),CalcDamage(myHero,target,0.75*(GetBaseDamage(myHero)+GetBonusDmg(myHero)),0.25*GetBonusAP(myHero))*(2*GetCastLevel(myHero,_R)+10)-CalcDamage(myHero,target,0.75*(GetBaseDamage(myHero)+GetBonusDmg(myHero)),0.25*GetBonusAP(myHero))*(2*GetCastLevel(myHero,_R)+wave),0,0xffffff00)
end
end)

function VectorWay(A,B)
WayX = B.x - A.x
WayY = B.y - A.y
WayZ = B.z - A.z
return Vector(WayX, WayY, WayZ)
end
