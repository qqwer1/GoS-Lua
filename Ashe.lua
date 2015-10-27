if GetObjectName(GetMyHero()) ~= "Ashe" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua!") return end

PrintChat("ADC MAIN | Ashe loaded.")
PrintChat("by Noddy")

local mainMenu = Menu("ADC MAIN | Ashe", "Ashe")
mainMenu:Menu("Combo", "Combo")
mainMenu.Combo:Boolean("useQ", "Use Q in combo", true)
mainMenu.Combo:Boolean("useW", "Use W in combo", true)
mainMenu.Combo:Boolean("useE", "Use E in combo", true)
mainMenu.Combo:Boolean("useR", "Use R in combo", true)
mainMenu.Combo:Key("Combo1", "Combo", string.byte(" "))
------------------------------------------------------	
mainMenu:Menu("Harass", "Harass")
mainMenu.Harass:Boolean("useQ", "Use Q in harass", true)
mainMenu.Harass:Boolean("useW", "Use W in harass", true)
mainMenu.Harass:Slider("Mana","Mana", 60 , 0, 100, 1)
mainMenu.Harass:Key("Harass1", "Harass", string.byte("C"))
------------------------------------------------------	
mainMenu:Menu("Killsteal", "Killsteal")
mainMenu.Killsteal:Boolean("ksW", "Use W - KS", true)
mainMenu.Killsteal:Boolean("ksR", "Use R - KS", true)
------------------------------------------------------	
mainMenu:Menu("Drawings", "Drawings")
mainMenu.Drawings:Boolean("DrawDMG","Draw damage", true)
mainMenu.Drawings:Boolean("DrawCombo","Draw R Combo range", true)
mainMenu.Drawings:Slider("Quality","Circle Quality", 100 , 1, 255, 1)
------------------------------------------------------
mainMenu:Menu("Items", "Items")
mainMenu.Items:Boolean("useCut", "Bilgewater Cutlass", true)
mainMenu.Items:Boolean("useBork", "Blade of the Ruined King", true)
mainMenu.Items:Boolean("useGhost", "Youmuu's Ghostblade", true)
mainMenu.Items:Boolean("useRedPot", "Elixir of Wrath", true)

local baseSpeed = GetBaseAttackSpeed(GetMyHero())
local global_ticks = 0

OnDraw(function(myHero)
local myHeroPos = GetOrigin(myHero)
local target = GetCurrentTarget()

-- Draw
if mainMenu.Drawings.DrawCombo:Value() and CanUseSpell(myHero,_R) == READY and ValidTarget(target,2000) then
	DrawCircle(GetOrigin(myHero),1200,0,mainMenu.Drawings.Quality:Value(),ARGB(100,33,139,6))
end

-- DMG
if mainMenu.Combo.useR:Value() then
	if CanUseSpell(myHero,_R) == READY and ValidTarget(target, 2000) then
		local aaDMG = CalcDamage(myHero,target,((baseSpeed * GetAttackSpeed(myHero)) * (GetBaseDamage(myHero) + GetBonusDmg(myHero))),0) * 1.5
		local rDMG = CalcDamage(myHero,target,0, 175*GetCastLevel(myHero,_R)+ 75 + GetBonusAP(myHero))
		
			if CanUseSpell(myHero,_W) == READY and mainMenu.Combo.useW:Value() and ValidTarget(target, 2000) then
				wDMG = CalcDamage(myHero,target,15*GetCastLevel(myHero,_W)+5+(GetBaseDamage(myHero) + GetBonusDmg(myHero)),0)
			elseif CanUseSpell(myHero,_W) ~= READY then
				wDMG = 0
			end
		
		DPS = (aaDMG*(GetCritChance(myHero)+1.1)) + rDMG + wDMG
		
	if mainMenu.Drawings.DrawDMG:Value() then
		DrawDmgOverHpBar(target,GetCurrentHP(target),DPS,0,ARGB(255,33,139,6))
	end
	else
		DPS = 0
	end
end
end)

OnTick(function (myHero)

local myHeroPos = GetOrigin(myHero)
local target = GetCurrentTarget()

-- Items
local CutBlade = GetItemSlot(myHero,3144)
local bork = GetItemSlot(myHero,3153)
local ghost = GetItemSlot(myHero,3142)
local redpot = GetItemSlot(myHero,2140)

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

	if ghost >= 1 and ValidTarget(target,550) and mainMenu.Items.useGhost:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,3142)) == READY then
			CastSpell(GetItemSlot(myHero,3142))
		end
	end
	
	if redpot >= 1 and ValidTarget(target,550) and mainMenu.Items.useRedPot:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,2140)) == READY then
			CastSpell(GetItemSlot(myHero,2140))
		end
	end
end


-- E Pos
if mainMenu.Combo.useE:Value() then
Ticker = GetTickCount()
	if (global_ticks + 10) < Ticker then
	
		DelayAction( function ()
			if not IsVisible(target) then
				targetPos = GetOrigin(target)
			end		
		 end , 10) 
		global_ticks = Ticker

	end	
end

-- Combo
if mainMenu.Combo.Combo1:Value() then

-- Ult 
if mainMenu.Combo.useR:Value() and CanUseSpell(myHero,_R) == READY then
	if ValidTarget(target,1200) and IsTargetable(target) and GetCurrentHP(target) + GetDmgShield(target) + GetMagicShield(target) <= DPS and GotBuff(target,"BlackShield") == 0 then
		local RPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),2000,250,1500,70,false,false)
			if RPred.HitChance == 1 then
				CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
			end
	end			
end

-- W
if CanUseSpell(myHero,_W) == READY and mainMenu.Combo.useW:Value() and ValidTarget(target,1200) and IsTargetable(target) then
	local WPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),1600,250,1200,20,true,false)
		if WPred.HitChance == 1 then
			CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
		end
end

-- Q
if CanUseSpell(myHero,_Q) == READY and mainMenu.Combo.useQ:Value() and ValidTarget(target,650) and IsTargetable(target) and GotBuff(myHero,"asheqcastready") == 5 then
	CastSpell(_Q)
end

-- E
if CanUseSpell(myHero,_E) == READY and mainMenu.Combo.useE:Value() and targetPos ~= nil and GetDistance(targetPos) < 1400 then
	CastSkillShot(_E,targetPos)
	targetPos = nil
end

end -- Combo

-- Harass
if mainMenu.Harass.Harass1:Value() and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= mainMenu.Harass.Mana:Value() then
-- W
if CanUseSpell(myHero,_W) == READY and mainMenu.Harass.useW:Value() and ValidTarget(target,1200) and IsTargetable(target) then
	local WPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),1600,250,1200,20,true,false)
		if WPred.HitChance == 1 then
			CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
		end
end

-- Q
if CanUseSpell(myHero,_Q) == READY and mainMenu.Harass.useQ:Value() and ValidTarget(target,650) and IsTargetable(target) and GotBuff(myHero,"asheqcastready") == 5 then
	CastSpell(_Q)
end

end -- Harass

-- KSW
if mainMenu.Killsteal.ksW:Value() then
for i,enemy in pairs(GetEnemyHeroes()) do
	if CanUseSpell(myHero,_W) == READY and IsTargetable(enemy) and ValidTarget(enemy,1200) and GetCurrentHP(enemy)+GetDmgShield(enemy) < CalcDamage(myHero,target,15*GetCastLevel(myHero,_W)+5+(GetBaseDamage(myHero) + GetBonusDmg(myHero)),0) then
		local WPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),1600,250,1200,20,true,false)
			if WPred.HitChance == 1 then
				CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
			end	
	end
end
end

-- KSR
if mainMenu.Killsteal.ksR:Value() then
for i,enemy in pairs(GetEnemyHeroes()) do
	if CanUseSpell(myHero,_R) == READY and IsTargetable(enemy) and not IsInDistance(enemy, 1200) and ValidTarget(enemy,3000) and GetCurrentHP(enemy)+GetMagicShield(enemy) < CalcDamage(myHero,enemy,0, 175*GetCastLevel(myHero,_R)+ 75 + GetBonusAP(myHero)) then
		local RPred = GetPredictionForPlayer(myHeroPos,enemy,GetMoveSpeed(enemy),2000,250,20000,70,false,false)
			if RPred.HitChance == 1 then
				CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
			end
	end
end
end


end)

