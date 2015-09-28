require('Inspired')

PrintChat("ADC MAIN | Corki loaded.")
PrintChat("by Noddy")

mainMenu = Menu("ADC MAIN | Corki", "Corki")
mainMenu:SubMenu("Combo", "Combo")
mainMenu.Combo:Boolean("useQ", "Use Q in combo", true)
mainMenu.Combo:Boolean("useE", "Use E in combo", true)
mainMenu.Combo:Boolean("useR", "Use R in combo", true)
mainMenu.Combo:Boolean("useSheen", "SheenProc weaving", true)
mainMenu.Combo:Key("Combo1", "Combo", string.byte(" "))
------------------------------------------
mainMenu:SubMenu("Harass", "Harass")
mainMenu.Harass:Boolean("useQ", "Use Q in harass", true)
mainMenu.Harass:Boolean("useE", "Use E in harass", false)
mainMenu.Harass:Boolean("useR", "Use R in harass", true)
mainMenu.Harass:Slider("Mana","Mana", 60 , 0, 100, 1)
mainMenu.Harass:Key("Harass1", "Harass", string.byte("C"))
------------------------------------------------------	
mainMenu:SubMenu("Killsteal", "Killsteal")
mainMenu.Killsteal:Boolean("ksQ", "Use Q - KS", true)
mainMenu.Killsteal:Boolean("ksR", "Use R - KS", true)
------------------------------------------
mainMenu:SubMenu("Items", "Items")
mainMenu.Items:Boolean("useCut", "Bilgewater Cutlass", true)
mainMenu.Items:Boolean("useBork", "Blade of the Ruined King", true)
mainMenu.Items:Boolean("useGhost", "Youmuu's Ghostblade", true)
mainMenu.Items:Boolean("useRedPot", "Elixir of Wrath", true)
------------------------------------------
mainMenu:SubMenu("Drawings", "Drawings")
mainMenu.Drawings:Boolean("DrawDMG","Draw Damage", true)


OnLoop (function (myHero)

myHeroPos = GetOrigin(myHero)
target = GetCurrentTarget()


-- Drawings
if mainMenu.Drawings.DrawDMG:Value() and GoS:ValidTarget(target, 2500) then
-- Q
	if CanUseSpell(myHero,_Q) == READY then
		qDMG = GoS:CalcDamage(myHero, target, 0, (30*GetCastLevel(myHero,_Q)+50+(0.5*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))+(0.5*GetBonusAP(myHero))))
	else
		qDMG = 0
	end
-- R	
	if CanUseSpell(myHero,_R) == READY and GotBuff(myHero,"mbcheck2") == 1 then
		rDMG = GoS:CalcDamage(myHero, target, 0, (120*GetCastLevel(myHero,_R)+30+((0.15*(GetCastLevel(myHero,_R))+0.15)*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))+(0.45*GetBonusAP(myHero))))
	elseif CanUseSpell(myHero,_R) == READY and GotBuff(myHero,"mbcheck2") == 0 then
		rDMG = GoS:CalcDamage(myHero, target, 0, (50*GetCastLevel(myHero,_R)+20+((0.1*(GetCastLevel(myHero,_R))+0.1)*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))+(0.3*GetBonusAP(myHero))))
	else 
		rDMG = 0
	end
-- AA
	local AA = GoS:CalcDamage(myHero, target, (GetBaseDamage(myHero) + GetBonusDmg(myHero)), 0)
	local trueDMG = (GetBaseDamage(myHero) + GetBonusDmg(myHero))*0.1
		
	local DPS = qDMG + rDMG
	
	if DPS ~= nil then
		DrawDmgOverHpBar(target,GetCurrentHP(target),DPS,0,0xff00ff00)
		DrawDmgOverHpBar(target,GetCurrentHP(target) - DPS, AA + trueDMG,0,0xffffffff)
	end
end

-- Items
local Sheen = GetItemSlot(myHero,3057)
local TonsOfDamage = GetItemSlot(myHero,3078)
local CutBlade = GetItemSlot(myHero,3144)
local bork = GetItemSlot(myHero,3153)
local ghost = GetItemSlot(myHero,3142)
local redpot = GetItemSlot(myHero,2140)


-- KS Q
if mainMenu.Killsteal.ksQ:Value() then
	KillstealQ()
end
-- KS R
if mainMenu.Killsteal.ksR:Value() then
	KillstealR()
end


-- [Combo
if mainMenu.Combo.Combo1:Value() and GoS:ValidTarget(target, GetCastRange(myHero,_R)) then

--Items
	if CutBlade >= 1 and GoS:ValidTarget(target,550) and mainMenu.Items.useCut:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,3144)) == READY then
			CastTargetSpell(target, GetItemSlot(myHero,3144))
		end	
	elseif bork >= 1 and GoS:ValidTarget(target,550) and (GetMaxHP(myHero) / GetCurrentHP(myHero)) >= 1.25 and mainMenu.Items.useBork:Value() then 
		if CanUseSpell(myHero,GetItemSlot(myHero,3153)) == READY then
			CastTargetSpell(target,GetItemSlot(myHero,3153))
		end
	end

	if ghost >= 1 and GoS:ValidTarget(target,550) and mainMenu.Items.useGhost:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,3142)) == READY then
			CastSpell(GetItemSlot(myHero,3142))
		end
	end
	
	if redpot >= 1 and GoS:ValidTarget(target,550) and mainMenu.Items.useRedPot:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,2140)) == READY then
			CastSpell(GetItemSlot(myHero,2140))
		end
	end
--

-- non SheenWeave
	if not mainMenu.Combo.useSheen:Value() then
		if mainMenu.Combo.useQ:Value() then
		useQ(target)
		end
		if mainMenu.Combo.useE:Value() then
		useE(target)
		end
		if mainMenu.Combo.useR:Value() then
		useR(target)
		end
	end
-- sheen
	if mainMenu.Combo.useSheen:Value() and Sheen > 0 or TonsOfDamage > 0 then
		if GoS:ValidTarget(target,GetRange(myHero)+20) and GotBuff(myHero,"sheen") == 1 then
		
		end
		if GoS:ValidTarget(target,GetRange(myHero)+20) and GotBuff(myHero,"sheen") == 0 then
			if mainMenu.Combo.useQ:Value() then
			useQ(target)
			end
			if mainMenu.Combo.useE:Value() then
			useE(target)
			end
			if mainMenu.Combo.useR:Value() then
			useR(target)
			end
		end
		if not GoS:IsInDistance(target, GetRange(myHero)+20) and GoS:ValidTarget(target, GetCastRange(myHero,_R)) then
			if mainMenu.Combo.useQ:Value() then
			useQ(target)
			end
			if mainMenu.Combo.useE:Value() then
			useE(target)
			end
			if mainMenu.Combo.useR:Value() then
			useR(target)
			end
		end		
	elseif mainMenu.Combo.useSheen:Value() and Sheen == 0 or TonsOfDamage == 0 then
			if mainMenu.Combo.useQ:Value() then
			useQ(target)
			end
			if mainMenu.Combo.useE:Value() then
			useE(target)
			end
			if mainMenu.Combo.useR:Value() then
			useR(target)
			end
	end
end-- Combo]

-- [Harass
if mainMenu.Harass.Harass1:Value() and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= mainMenu.Harass.Mana:Value() then
	if mainMenu.Harass.useQ:Value() then
		useQ(target)
	end
	if mainMenu.Harass.useE:Value() then
		useE(target)
	end
	if mainMenu.Harass.useR:Value() then
		useR(target)
	end
end --Harass]

end)

function KillstealQ()
	for i,enemy in pairs(GoS:GetEnemyHeroes()) do
		if CanUseSpell(myHero,_Q) == READY and GoS:ValidTarget(enemy, GetCastRange(myHero,_Q)) and GetCurrentHP(enemy) + GetMagicShield(enemy) < GoS:CalcDamage(myHero, enemy, 0, (30*GetCastLevel(myHero,_Q)+50+(0.5*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))+(0.5*GetBonusAP(myHero)))) then
			local QksPred = GetPredictionForPlayer(myHeroPos, enemy, GetMoveSpeed(enemy),1000, 250, GetCastRange(myHero,_Q), 250, false, true)
				if QksPred.HitChance == 1 then
					CastSkillShot(_Q, QksPred.PredPos.x, QksPred.PredPos.y, QksPred.PredPos.z)
				end
		end
	end
end

function KillstealR()
	for i,enemy in pairs(GoS:GetEnemyHeroes()) do
		if CanUseSpell(myHero,_R) == READY and GoS:ValidTarget(enemy, GetCastRange(myHero,_R)) then
			if GotBuff(myHero,"mbcheck2") == 1 and GetCurrentHP(enemy) + GetMagicShield(enemy) < GoS:CalcDamage(myHero, enemy, 0, (120*GetCastLevel(myHero,_R)+30+((0.15*(GetCastLevel(myHero,_R))+0.15)*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))+(0.45*GetBonusAP(myHero)))) then
			local RksPred = GetPredictionForPlayer(myHeroPos, enemy, GetMoveSpeed(enemy),1670, 250, GetCastRange(myHero,_R), 150, true, true)
				if RksPred.HitChance == 1 then
					CastSkillShot(_R, RksPred.PredPos.x, RksPred.PredPos.y, RksPred.PredPos.z)
				end
			elseif GotBuff(myHero,"mbcheck2") == 0 and GetCurrentHP(enemy) + GetMagicShield(enemy) < GoS:CalcDamage(myHero, enemy, 0, (50*GetCastLevel(myHero,_R)+20+((0.1*(GetCastLevel(myHero,_R))+0.1)*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))+(0.3*GetBonusAP(myHero)))) then
			local RksPred = GetPredictionForPlayer(myHeroPos, enemy, GetMoveSpeed(enemy),1670, 250, GetCastRange(myHero,_R), 75, true, true)
				if RksPred.HitChance == 1 then
					CastSkillShot(_R, RksPred.PredPos.x, RksPred.PredPos.y, RksPred.PredPos.z)
				end
			end
		end
	end
end

-- useQ
function useQ(target)
if GoS:ValidTarget(target,GetCastRange(myHero,_Q)) and CanUseSpell(myHero,_Q) == READY then
	local QPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1000, 250, GetCastRange(myHero,_Q), 250, false, true)
		if QPred.HitChance == 1 then
			CastSkillShot(_Q, QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
		end
end
end

function useE(target)
if GoS:ValidTarget(target,GetCastRange(myHero,_E)) and CanUseSpell(myHero,_E) == READY then
	local EPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target), math.huge, 150, GetCastRange(myHero,_E), 250, false, true)
		if EPred.HitChance == 1 then
			CastSkillShot(_E, EPred.PredPos.x, EPred.PredPos.y, EPred.PredPos.z)
		end
end
end

function useR(target)
if GoS:ValidTarget(target,GetCastRange(myHero,_R)) and CanUseSpell(myHero,_R) == READY then
	if GotBuff(myHero,"mbcheck2") == 0 then	
	local RPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1670, 250, GetCastRange(myHero,_R), 75, true, true)
		if RPred.HitChance == 1 then
			CastSkillShot(_R, RPred.PredPos.x, RPred.PredPos.y, RPred.PredPos.z)
		end
	elseif GotBuff(myHero,"mbcheck2") == 1 then
	local RPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1670, 250, GetCastRange(myHero,_R), 150, true, true)
		if RPred.HitChance == 1 then
			CastSkillShot(_R, RPred.PredPos.x, RPred.PredPos.y, RPred.PredPos.z)
		end
	end
end
end
