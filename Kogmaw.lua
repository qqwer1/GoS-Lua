require('Inspired')

PrintChat("ADC MAIN | Kog'Maw loaded.")
PrintChat("by Noddy")

mainMenu = Menu("ADC MAIN | Kog'Maw", "KogMaw")
mainMenu:SubMenu("Combo", "Combo")
mainMenu.Combo:Boolean("useQ", "Use Q in combo", true)
mainMenu.Combo:Boolean("useW", "Use W in combo", true)
mainMenu.Combo:Boolean("useE", "Use E in combo", true)
mainMenu.Combo:Boolean("useR", "Use R in combo", true)
mainMenu.Combo:Slider("RStacks","Max R stacks", 3, 1, 5, 1)
mainMenu.Combo:Key("Combo1", "Combo", string.byte(" "))
--------------------------------
mainMenu:SubMenu("Harass", "Harass")
mainMenu.Harass:Boolean("useQ", "Use Q", true)
mainMenu.Harass:Boolean("useW", "Use W", true)
mainMenu.Harass:Boolean("useE", "Use E", true)
mainMenu.Harass:Boolean("useR", "Use R", true)
mainMenu.Harass:Slider("RStacks","Max R stacks", 2, 1, 5, 1)
mainMenu.Harass:Slider("Mana","Mana-Manager", 60, 1, 100, 1)
mainMenu.Harass:Key("Harass1", "Harass", string.byte("C"))
--------------------------------
mainMenu:SubMenu("Killsteal", "Killsteal")
mainMenu.Killsteal:Boolean("ksQ", "Use Q", true)
mainMenu.Killsteal:Boolean("ksE", "Use E", false)
mainMenu.Killsteal:Boolean("ksR", "Use R", true)
--------------------------------
mainMenu:SubMenu("Items", "Items")
mainMenu.Items:Boolean("useCut", "Bilgewater Cutlass", true)
mainMenu.Items:Boolean("useBork", "Blade of the Ruined King", true)
mainMenu.Items:Boolean("useGhost", "Youmuu's Ghostblade", true)
mainMenu.Items:Boolean("useRedPot", "Elixir of Wrath", true)
--------------------------------
mainMenu:SubMenu("Misc", "Misc")
mainMenu.Misc:Boolean("drawW", "Draw W Range", true)
mainMenu.Misc:Boolean("drawDMG", "Draw AA Damage", true)
mainMenu.Misc:Boolean("drawDMGspell", "Draw Spell Damage", true)

OnLoop (function(myHero)

local target = GetCurrentTarget()
local myHeroPos = GetOrigin(myHero)

-- Items
local CutBlade = GetItemSlot(myHero,3144)
local bork = GetItemSlot(myHero,3153)
local ghost = GetItemSlot(myHero,3142)
local redpot = GetItemSlot(myHero,2140)


if mainMenu.Misc.drawW:Value() and CanUseSpell(myHero,_W) == READY and GoS:ValidTarget(target,2000) then
	DrawCircle(myHeroPos,GetRange(myHero)+(20*GetCastLevel(myHero,_W)+110),2,100,ARGB(210,33,139,6))
end

-- [Combo
if mainMenu.Combo.Combo1:Value() then

-- Items ---------------------------
	if CutBlade >= 1 and GoS:ValidTarget(target,550) and mainMenu.Items.useCut:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,3144)) == READY then
			CastTargetSpell(target, GetItemSlot(myHero,3144))
		end	
	elseif bork >= 1 and GoS:ValidTarget(target,550) and (GetMaxHP(myHero) / GetCurrentHP(myHero)) >= 1.25 and mainMenu.Items.useBork:Value() then 
		if CanUseSpell(myHero,GetItemSlot(myHero,3153)) == READY then
			CastTargetSpell(target,GetItemSlot(myHero,3153))
		end
	end

	if ghost >= 1 and GoS:ValidTarget(target,GetRange(myHero)+GetHitBox(myHero)+GetHitBox(target)) and mainMenu.Items.useGhost:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,3142)) == READY then
			CastSpell(GetItemSlot(myHero,3142))
		end
	end
	
	if redpot >= 1 and GoS:ValidTarget(target,GetRange(myHero)+GetHitBox(myHero)+GetHitBox(target)) and mainMenu.Items.useRedPot:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,2140)) == READY then
			CastSpell(GetItemSlot(myHero,2140))
		end
	end
-----------------------------------

-- Q
if mainMenu.Combo.useQ:Value() then
	if CanUseSpell(myHero,_Q) == READY and GoS:ValidTarget(target, GetRange(myHero)) then
	local QPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),1650,250,1000+GetHitBox(target),70,true,false)
		if QPred.HitChance == 1 then
			CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
		end
	end
end
-- W
if mainMenu.Combo.useW:Value() then
	if CanUseSpell(myHero,_W) == READY and GoS:ValidTarget(target, GetRange(myHero)+(20*GetCastLevel(myHero,_W)+110)) then
		CastSpell(_W)
	end
end
-- E
if mainMenu.Combo.useE:Value() then
	if CanUseSpell(myHero,_E) == READY and GoS:ValidTarget(target, 1280) then 
		local EPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target)*1.33,1350,250,1280+GetHitBox(target),120,false,false)
		if EPred.HitChance == 1 then
			CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
		end
	end
end
-- R
if mainMenu.Combo.useR:Value() then
	if CanUseSpell(myHero,_R) == READY and GoS:ValidTarget(target,(300*GetCastLevel(myHero,_R)+900)) and GotBuff(myHero,"kogmawlivingartillerycost") < mainMenu.Combo.RStacks:Value() then
		local RPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),math.huge,1200,(300*GetCastLevel(myHero,_R)+900),100,false,false)
		if RPred.HitChance == 1 then
			CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
		end
	end
end
		
end -- Combo
-- Harass
if mainMenu.Harass.Harass1:Value() then
-- Q
if mainMenu.Harass.useQ:Value() and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= mainMenu.Harass.Mana:Value() then
	if CanUseSpell(myHero,_Q) == READY and GoS:ValidTarget(target, GetRange(myHero)) then
	local QPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),1650,250,1000+GetHitBox(target),70,true,false)
		if QPred.HitChance == 1 then
			CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
		end
	end
end
-- W
if mainMenu.Harass.useW:Value() then
	if CanUseSpell(myHero,_W) == READY and GoS:ValidTarget(target, GetRange(myHero)+(20*GetCastLevel(myHero,_W)+110)) then
		CastSpell(_W)
	end
end
-- E
if mainMenu.Harass.useE:Value() and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= mainMenu.Harass.Mana:Value() then
	if CanUseSpell(myHero,_E) == READY and GoS:ValidTarget(target, 1280) then 
		local EPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target)*1.33,1350,250,1280+GetHitBox(target),120,false,false)
		if EPred.HitChance == 1 then
			CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
		end
	end
end
-- R
if mainMenu.Harass.useR:Value() and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= mainMenu.Harass.Mana:Value() then
	if CanUseSpell(myHero,_R) == READY and GoS:ValidTarget(target,(300*GetCastLevel(myHero,_R)+900)) and GotBuff(myHero,"kogmawlivingartillerycost") < mainMenu.Harass.RStacks:Value() then
		local RPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),math.huge,1200,(300*GetCastLevel(myHero,_R)+900),100,false,false)
		if RPred.HitChance == 1 then
			CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
		end
	end
end
end -- Harass
-- KS
if mainMenu.Killsteal.ksQ:Value() or mainMenu.Killsteal.ksE:Value() or mainMenu.Killsteal.ksR:Value() then
for i,enemy in pairs(GoS:GetEnemyHeroes()) do
	if mainMenu.Killsteal.ksQ:Value() and CanUseSpell(myHero,_Q) == READY and GoS:ValidTarget(enemy,GetCastRange(myHero,_Q)) and GetCurrentHP(enemy) + GetDmgShield(enemy) + GetMagicShield(enemy) < GoS:CalcDamage(myHero,enemy,0,50*GetCastLevel(myHero,_Q)+30+(0.5*GetBonusAP(myHero))) then
		local ksQPred = GetPredictionForPlayer(myHeroPos,enemy,GetMoveSpeed(enemy),1650,250,1000+GetHitBox(enemy),70,true,false)
		if ksQPred.HitChance == 1 then
			CastSkillShot(_Q,ksQPred.PredPos.x,ksQPred.PredPos.y,ksQPred.PredPos.z)
		end
	end
	if mainMenu.Killsteal.ksE:Value() and CanUseSpell(myHero,_E) == READY and GoS:ValidTarget(enemy,GetCastRange(myHero,_E)) and GetCurrentHP(enemy) + GetDmgShield(enemy) + GetMagicShield(enemy) < GoS:CalcDamage(myHero,enemy,0,50*GetCastLevel(myHero,_E)+10+(0.7*GetBonusAP(myHero))) then
		local ksEPred = GetPredictionForPlayer(myHeroPos,enemy,GetMoveSpeed(enemy),1350,250,1280+GetHitBox(enemy),120,false,false)
		if ksEPred.HitChance == 1 then
			CastSkillShot(_E,ksEPred.PredPos.x,ksEPred.PredPos.y,ksEPred.PredPos.z)
		end
	end
	if mainMenu.Killsteal.ksR:Value() and CanUseSpell(myHero,_R) == READY and GoS:ValidTarget(enemy,(300*GetCastLevel(myHero,_R)+900)) and GetCurrentHP(enemy) + GetDmgShield(enemy) + GetMagicShield(enemy) < GoS:CalcDamage(myHero,enemy,0,80*GetCastLevel(myHero,_R)+80+(0.3*GetBonusAP(myHero))+(0.5*(GetBaseDamage(myHero)+GetBonusDmg(myHero)))) then
		local ksRPred = GetPredictionForPlayer(myHeroPos,enemy,GetMoveSpeed(enemy),math.huge,1200,(300*GetCastLevel(myHero,_R)+900),100,false,false)
		if ksRPred.HitChance == 1 then
			CastSkillShot(_R,ksRPred.PredPos.x,ksRPred.PredPos.y,ksRPred.PredPos.z)
		end
	end
end	
end
-- Draw DMG
if mainMenu.Misc.drawDMG:Value() or mainMenu.Misc.drawDMGspell:Value() then
for i,enemy in pairs(GoS:GetEnemyHeroes()) do
-- SpellDMG
if mainMenu.Misc.drawDMGspell:Value() and GoS:ValidTarget(enemy,(300*GetCastLevel(myHero,_R)+900)) then
	if CanUseSpell(myHero,_Q) == READY then
		qDMG = GoS:CalcDamage(myHero,enemy,0,50*GetCastLevel(myHero,_Q)+30+(0.5*GetBonusAP(myHero)))
	else qDMG = 0 end
	if CanUseSpell(myHero,_E) == READY then
		eDMG = GoS:CalcDamage(myHero,enemy,0,50*GetCastLevel(myHero,_E)+10+(0.7*GetBonusAP(myHero)))
	else eDMG = 0 end
	if CanUseSpell(myHero,_R) == READY then
		rDMG = GoS:CalcDamage(myHero,enemy,0,80*GetCastLevel(myHero,_R)+80+(0.3*GetBonusAP(myHero))+(0.5*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))
	else rDMG = 0 end

	local spellDMG = qDMG + eDMG + rDMG
	DrawDmgOverHpBar(enemy,GetCurrentHP(enemy),spellDMG,0,0xff00ff00)
end
-- AA DMG
if mainMenu.Misc.drawDMG:Value() and GoS:ValidTarget(enemy,(300*GetCastLevel(myHero,_R)+900)) then
	AADMG = GoS:CalcDamage(myHero,enemy,GetBaseDamage(myHero)+GetBonusDmg(myHero),0)
	if GotBuff(myHero,"KogMawBioArcaneBarrage") == 1 then
		extraDMG = GoS:CalcDamage(myHero,enemy,0,GetMaxHP(enemy)*(0.01*GetCastLevel(myHero,_W)+0.01+(0.01*math.floor(0.01*GetBonusAP(myHero)))))
	else extraDMG = 0 end
	if bork >= 1 then
		borkDMG = GoS:CalcDamage(myHero,enemy,GetCurrentHP(enemy)*0.06,0)
	else borkDMG = 0 end
	
	DrawDmgOverHpBar(enemy,GetCurrentHP(enemy),AADMG+extraDMG+borkDMG,0,0xffffffff)
end
end
end

end)
