if GetObjectName(GetMyHero()) ~= "Quinn" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua!") return end

PrintChat("ADC MAIN | Quinn loaded.")
PrintChat("by Noddy")

local mainMenu = Menu("ADC MAIN | Quinn", "Quinn")
mainMenu:Menu("Combo", "Combo")
mainMenu.Combo:Boolean("useQ", "Use Q", true)
mainMenu.Combo:Boolean("useW", "Use W", true)
mainMenu.Combo:Boolean("useE", "Use E", true)
mainMenu.Combo:Key("Combo1", "Combo", string.byte(" "))
------------------------------------------------------
mainMenu:Menu("Items", "Items")
mainMenu.Items:Boolean("useCut", "Bilgewater Cutlass", true)
mainMenu.Items:Boolean("useBork", "Blade of the Ruined King", true)
mainMenu.Items:Boolean("useGhost", "Youmuu's Ghostblade", true)
mainMenu.Items:Boolean("useRedPot", "Elixir of Wrath", true)
------------------------------------------------------
mainMenu:Boolean("drawDMG", "Draw: Damage", true)


local myHitBox = GetHitBox(myHero)
local global_ticks = 0

OnProcessSpellComplete(function(unit,spell)
	if unit == myHero and ( spell.name:lower():find("attack") or spell.name:lower():find("quinnwe") ) and mainMenu.Combo.Combo1:Value() then
		DelayAction(function()
		if CanUseSpell(myHero,2) == READY and ValidTarget(spell.target, 750) and EnemiesAround(GetOrigin(spell.target), 600) < 3 and GetObjectType(spell.target) == Obj_AI_Hero and mainMenu.Combo.useE:Value() then
			CastTargetSpell(spell.target,2)
		end
		end, .005)
		DelayAction(function()
		if CanUseSpell(myHero,0) == READY and ValidTarget(spell.target, 750) and mainMenu.Combo.useQ:Value() and GetObjectType(spell.target) == Obj_AI_Hero then
			local qPred = GetPredictionForPlayer(GetOrigin(myHero),spell.target,GetMoveSpeed(spell.target),1550,313,1050,60,true,false)
			if qPred.HitChance == 1 then
				CastSkillShot(0,qPred.PredPos)
			end
		end
		end, .005)
	end
end)

OnDraw(function(myHero)
if DPS ~= nil and ValidTarget(target, 2000) and mainMenu.drawDMG:Value() then
	DrawDmgOverHpBar(target,GetCurrentHP(target),DPS,0,0xffffffff)
end
end)

OnTick(function(myHero)

target = GetCurrentTarget()
local myHeroPos = GetOrigin(myHero)

-- Items
local CutBlade = GetItemSlot(myHero,3144)
local bork = GetItemSlot(myHero,3153)
local ghost = GetItemSlot(myHero,3142)
local redpot = GetItemSlot(myHero,2140)

-- InvisibleTarget
if mainMenu.Combo.useW:Value() then
if IsVisible(target) and ValidTarget(target, 2000) and CanUseSpell(myHero,1) == READY then
	targetPos = GetOrigin(target)
end
if not IsVisible(target) and targetPos ~= nil then
	DelayAction(function()
		targetPos = nil
	end, 1)
end
if IsDead(target) then
	targetPos = nil
end
end

-- DMG
if ValidTarget(target, 2000) and mainMenu.drawDMG:Value() then
local passiveatk = 0
if CanUseSpell(myHero,_Q) == READY then
	passiveatk = passiveatk + 1
	qDMG = CalcDamage(myHero,target,30*GetCastLevel(myHero,0)-5+(GetBaseDamage(myHero)+GetBonusDmg(myHero))*(0.15*GetCastLevel(myHero,0)+0.65)+GetBonusAP(myHero)*0.5,0)
else qDMG = 0 end
if CanUseSpell(myHero,_E) == READY then
	passiveatk = passiveatk + 1
	eDMG = CalcDamage(myHero,target,30*GetCastLevel(myHero,2)+10+GetBonusDmg(myHero)*0.2,0)
else eDMG = 0 end

local passiveDMG = CalcDamage(myHero,target,5*GetLevel(myHero)+10+(GetBaseDamage(myHero)+GetBonusDmg(myHero))*(0.02*GetLevel(myHero)+1.14),0)*passiveatk
local pDMGCrit = (2*passiveDMG) * GetCritChance(myHero)
DPS = qDMG + eDMG + passiveDMG + pDMGCrit
end

-- Combo
if mainMenu.Combo.Combo1:Value() then

-- Items
	if CutBlade >= 1 and ValidTarget(target,550) and mainMenu.Items.useCut:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,3144)) == READY then
			CastTargetSpell(target, GetItemSlot(myHero,3144))
		end	
	elseif bork >= 1 and ValidTarget(target,550) and (GetMaxHP(myHero) / GetCurrentHP(myHero)) >= 1.25 and mainMenu.Items.useBork:Value() then 
		if CanUseSpell(myHero,GetItemSlot(myHero,3153)) == READY then
			CastTargetSpell(target,GetItemSlot(myHero,3153))
		end
	end

	if ghost >= 1 and ValidTarget(target,GetRange(myHero)+myHitBox) and mainMenu.Items.useGhost:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,3142)) == READY then
			CastSpell(GetItemSlot(myHero,3142))
		end
	end
	
	if redpot >= 1 and ValidTarget(target,GetRange(myHero)+myHitBox) and mainMenu.Items.useRedPot:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,2140)) == READY then
			CastSpell(GetItemSlot(myHero,2140))
		end
	end

-- R E
	if GetCastName(myHero,3) == "quinnrfinale" and mainMenu.Combo.useE:Value() and ValidTarget(target,800) and EnemiesAround(GetOrigin(target), 600) < 3 then
		CastTargetSpell(target,2)
	end

-- Q + Kill
if mainMenu.Combo.useQ:Value() then
	if CanUseSpell(myHero,0) == READY and ValidTarget(target, 1000) and GetCurrentHP(target) + GetDmgShield(target) + GetHPRegen(target)*((GetDistance(myHero,target)/2000)+0.25) < CalcDamage(myHero,target,30*GetCastLevel(myHero,0)-5+(GetBaseDamage(myHero)+GetBonusDmg(myHero))*(0.15*GetCastLevel(myHero,0)+0.65)+GetBonusAP(myHero)*0.5,0) then
		local qPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),1550,313,1050,60,true,false)
		if qPred.HitChance == 1 then
			CastSkillShot(0,qPred.PredPos)
		end
	end
	if ValidTarget(target, 1000) and not IsInDistance(target, GetRange(myHero) + GetHitBox(target) + myHitBox) and CanUseSpell(myHero,0) == READY and GetCastName(myHero,3) ~= "quinnrfinale" then
		local qPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),1550,313,1050,60,true,false)
		if qPred.HitChance == 1 then
			CastSkillShot(0,qPred.PredPos)
		end
	end
	
end

-- Vision
if CanUseSpell(myHero,1) == READY and mainMenu.Combo.useW:Value() and targetPos ~= nil and GetDistance(targetPos) < 1750 and not IsVisible(target) then
	CastSpell(1)
	targetPos = nil
end

-- Agains Close enemy
if CanUseSpell(myHero,2) == READY and mainMenu.Combo.useE:Value() then
	if GetDistance(ClosestEnemy(myHeroPos),myHero) < 350 then
		local cEnemy = ClosestEnemy(myHeroPos)
		PosAfterE = myHeroPos - (VectorWay(myHeroPos,GetOrigin(cEnemy))/GetDistance(myHero,cEnemy))*(525-GetDistance(myHero,cEnemy))
		if EnemiesAround(myHeroPos, 600) > EnemiesAround(PosAfterE, 500) then
			CastTargetSpell(cEnemy,2)
		end
	end
end

	
end
-- Assist
if CanUseSpell(myHero,1) == READY and mainMenu.Combo.useW:Value() then
	for i,enemy in pairs(GetEnemyHeroes()) do
		if ValidTarget(enemy, 2100) then
			if GetCurrentHP(enemy) + GetDmgShield(enemy) - GetDamagePrediction(enemy, 750 + GetLatency()) < 1 then
				CastSpell(1)
			end
		end
	end
end


end)

function VectorWay(A,B)
WayX = B.x - A.x
WayY = B.y - A.y
WayZ = B.z - A.z
return Vector(WayX, WayY, WayZ)
end
