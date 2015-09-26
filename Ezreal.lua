require('Inspired')

PrintChat("ADC MAIN | Ezreal loaded.")
PrintChat("by Noddy")

mainMenu = Menu("ADC MAIN | Ezreal", "Ezreal")
mainMenu:SubMenu("Combo", "Combo")
mainMenu.Combo:Boolean("useQ", "Use Q in combo", true)
mainMenu.Combo:Boolean("useW", "Use W in combo", true)
mainMenu.Combo:Boolean("useSheen", "SheenProc weaving", true)
mainMenu.Combo:Key("Combo1", "Combo", string.byte(" "))
------------------------------------------------------
mainMenu:SubMenu("Killsteal", "Killsteal")
mainMenu.Killsteal:Boolean("ksQ", "Use Q - KS", true)
mainMenu.Killsteal:Boolean("ksR", "Use R - KS", true)
------------------------------------------------------
mainMenu:SubMenu("Misc", "Misc")
mainMenu.Misc:Boolean("tearStack", "Tear stacking (Beta)", SCRIPT_PARAM_ONOFF, false)

OnLoop (function (myHero)

local myHeroPos = GetOrigin(myHero)
local target = GetCurrentTarget()

-- Items
local Sheen = GetItemSlot(myHero,3057)
local TonsOfDamage = GetItemSlot(myHero,3078)
local Iceborn = GetItemSlot(myHero,3025)
local Muramana = GetItemSlot(myHero,3042)
local Manamune = GetItemSlot(myHero,3004)
local Tear = GetItemSlot(myHero,3070)
local CutBlade = GetItemSlot(myHero,3144)
local bork = GetItemSlot(myHero,3153)

-- BORK & CutBlade
if CutBlade >= 1 and GoS:ValidTarget(target,550) and mainMenu.Combo.Combo1:Value() then
	CastTargetSpell(target, GetItemSlot(myHero,3144))
elseif bork >= 1 and GoS:ValidTarget(target,550) and mainMenu.Combo.Combo1:Value() and (GetMaxHP(myHero) / GetCurrentHP(myHero)) >= 1.25 then 
	CastTargetSpell(target,GetItemSlot(myHero,3153))
end

-- Stacking: BETA
if GoS:ValidTarget(target,3000) then

elseif Tear >= 1 and mainMenu.Misc.tearStack:Value() and CanUseSpell(myHero,_Q) == READY and GotBuff(myHero,"recall") == 0 and (GetMaxMana(myHero) / GetCurrentMana(myHero)) <= 1.5 then
	CastSkillShot(_Q, myHeroPos.x, myHeroPos.y, myHeroPos.z)
elseif Manamune >= 1 and mainMenu.Misc.tearStack:Value() and CanUseSpell(myHero,_Q) == READY and GotBuff(myHero,"recall") == 0 and (GetMaxMana(myHero) / GetCurrentMana(myHero)) <= 1.5 then
	CastSkillShot(_Q, myHeroPos.x, myHeroPos.y, myHeroPos.z)
end

-- Muramana: DONE
if mainMenu.Combo.Combo1:Value() then
if GoS:ValidTarget(target,GetCastRange(myHero,_Q)) and Muramana >= 1 and GotBuff(myHero,"Muramana") == 0 then
	CastSpell(GetItemSlot(myHero,3042))
elseif GotBuff(myHero,"Muramana") == 1 and not GoS:ValidTarget(target, 1500) then
	CastSpell(GetItemSlot(myHero,3042))
end
end
if GotBuff(myHero,"Muramana") == 1 and not GoS:ValidTarget(target, 2500) then
	CastSpell(GetItemSlot(myHero,3042))
end

-- KS

for i,enemy in pairs(GoS:GetEnemyHeroes()) do
if CanUseSpell(myHero,_R) == READY then
local rDMG = GoS:CalcDamage(myHero, enemy, 0, (150*GetCastLevel(myHero,_R)+ 40 + (0.80*GetBonusAP(myHero)) + (0.90*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))))
	DrawDmgOverHpBar(enemy,GetCurrentHP(enemy),rDMG,0,0xff00ff00)
end
	if CanUseSpell(myHero,_R) == READY and mainMenu.Killsteal.ksR:Value() and GetCurrentHP(enemy) < GoS:CalcDamage(myHero, enemy, 0, (150*GetCastLevel(myHero,_R)+ 100 + (0.80*GetBonusAP(myHero)) + (0.90*(GetBaseDamage(myHero) + GetBonusDmg(myHero))))) then
		local origin = GetOrigin(myHero)
		local myscreenpos = WorldToScreen(1,origin.x,origin.y,origin.z)
			if CanUseSpell(myHero,_R) == READY and GoS:ValidTarget(enemy, 4000) then
				DrawText("R-KS - Press T",22,myscreenpos.x,myscreenpos.y,0xff00ff00)
			end
	end

USER = KeyIsDown(84)
if USER == true then
		  
	if CanUseSpell(myHero,_R) == READY then
		local rDMG = GoS:CalcDamage(myHero, enemy, 0, (150*GetCastLevel(myHero,_R)+ 100 + (0.80*GetBonusAP(myHero)) + (0.90*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))))
		local RPred = GetPredictionForPlayer(myHeroPos,enemy,GetMoveSpeed(enemy),2000,1100,4000,160,false,false)
			if CanUseSpell(myHero, _R) == READY and RPred.HitChance == 1 and GoS:ValidTarget(enemy, 4000) and mainMenu.Killsteal.ksR:Value() and GetCurrentHP(enemy) < rDMG then  
				CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
			end
	end	
end

		  
	if CanUseSpell(myHero,_Q) == READY then
		local qDMG = GoS:CalcDamage(myHero, enemy, 0, (20*GetCastLevel(myHero,_Q)+ 15 + (0.40*GetBonusAP(myHero)) + (1.1*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))))
		local QPred = GetPredictionForPlayer(myHeroPos,enemy,GetMoveSpeed(enemy),2000,250,1200,60,true,false)
			if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and GoS:ValidTarget(enemy, 1200) and mainMenu.Killsteal.ksQ:Value() and GetCurrentHP(enemy) < qDMG then  
				CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
			end
		end	
end

		

if GoS:ValidTarget(target,20000) then
if CanUseSpell(myHero,_R) == READY then
local rDMG = GoS:CalcDamage(myHero, target, 0, 150*GetCastLevel(myHero,_R)+ 100 + (0.80*GetBonusAP(myHero)) + (0.90*(GetBaseDamage(myHero) + GetBonusDmg(myHero))))
DrawDmgOverHpBar(target,GetCurrentHP(target),rDMG,0,0xff00ff00)
end
end


if mainMenu.Combo.Combo1:Value() and GoS:ValidTarget(target, 2000) then


-- Combo - noSheen
if not mainMenu.Combo.useSheen:Value() then
	
	local QPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),2000, 250, GetCastRange(myHero,_Q), 60, true, false)
		if QPred.HitChance == 1 and CanUseSpell(myHero,_Q) == READY and mainMenu.Combo.useQ:Value() then
			CastSkillShot(_Q, QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
		end

	local WPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1600, 250, GetCastRange(myHero,_W), 80, false, false)
		if WPred.HitChance == 1 and CanUseSpell(myHero,_W) == READY and mainMenu.Combo.useW:Value() then
			CastSkillShot(_W, WPred.PredPos.x, WPred.PredPos.y, WPred.PredPos.z)
		end
		
end	

-- Combo SheenWeave

if Sheen >= 1 or TonsOfDamage >= 1 or Iceborn >= 1 and mainMenu.Combo.useSheen:Value() then

	if GoS:ValidTarget(target,GetRange(myHero)) and GotBuff(myHero,"sheen") == 1 or GotBuff(myHero,"itemfrozenfist") == 1 then
	
			local QPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),2000, 250, GetCastRange(myHero,_Q), 60, true, false)
				if QPred.HitChance == 1 and CanUseSpell(myHero,_Q) == READY and mainMenu.Combo.useQ:Value() then
					CastSkillShot(_Q, QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
				end
		
	elseif GoS:ValidTarget(target,GetRange(myHero)) and GotBuff(myHero,"sheen") == 0 or GotBuff(myHero,"itemfrozenfist") == 0 then

			local QPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),2000, 250, GetCastRange(myHero,_Q), 60, true, false)
				if QPred.HitChance == 1 and CanUseSpell(myHero,_Q) == READY and mainMenu.Combo.useQ:Value() then
					CastSkillShot(_Q, QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
				end	
	
			local WPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1600, 250, GetCastRange(myHero,_W), 80, false, false)
				if WPred.HitChance == 1 and CanUseSpell(myHero,_W) == READY and mainMenu.Combo.useW:Value() then
					CastSkillShot(_W, WPred.PredPos.x, WPred.PredPos.y, WPred.PredPos.z)
				end	

--		
		
elseif GoS:ValidTarget(target,2000) then

			local QPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),2000, 250, GetCastRange(myHero,_Q), 60, true, false)
				if QPred.HitChance == 1 and CanUseSpell(myHero,_Q) == READY and mainMenu.Combo.useQ:Value() then
					CastSkillShot(_Q, QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
				end
		
			local WPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1600, 250, GetCastRange(myHero,_W), 80, false, false)
				if WPred.HitChance == 1 and CanUseSpell(myHero,_W) == READY and mainMenu.Combo.useW:Value() then
					CastSkillShot(_W, WPred.PredPos.x, WPred.PredPos.y, WPred.PredPos.z)
				end			

end
	
elseif GoS:ValidTarget(target,2000) then

			local QPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),2000, 250, GetCastRange(myHero,_Q), 60, true, false)
				if QPred.HitChance == 1 and CanUseSpell(myHero,_Q) == READY and mainMenu.Combo.useQ:Value() then
					CastSkillShot(_Q, QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
				end

			local WPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1600, 250, GetCastRange(myHero,_W), 80, false, false)
				if WPred.HitChance == 1 and CanUseSpell(myHero,_W) == READY and mainMenu.Combo.useW:Value() then
					CastSkillShot(_W, WPred.PredPos.x, WPred.PredPos.y, WPred.PredPos.z)
				end	
		

end
end
end)
