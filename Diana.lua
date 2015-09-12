require('Inspired')

PrintChat("Diana - The moonwalker loaded.")
PrintChat("by Noddy")

mainMenu = Menu("Diana", "Diana")
mainMenu:SubMenu("Combo", "Combo")
mainMenu.Combo:Boolean("useQ", "Use Q in combo", true)
mainMenu.Combo:Boolean("useW", "Use W in combo", true)
mainMenu.Combo:Boolean("useE", "Use E in combo", true)
mainMenu.Combo:Boolean("useR", "Use R in combo", true)
mainMenu.Combo:Key("Combo1", "Combo", string.byte(" "))
-----------------------------------------------------
mainMenu:SubMenu("Killsteal", "Killsteal")
mainMenu.Killsteal:Boolean("ksR", "Use R - KS", true)
-----------------------------------------------------
mainMenu:SubMenu("Harass", "Harass")
mainMenu.Harass:Boolean("useQh", "Use Q in harass", true)
mainMenu.Harass:Boolean("useWh", "Use W in harass", true)
mainMenu.Harass:Key("Harass1", "Harass", string.byte("C"))
-----------------------------------------------------
mainMenu:SubMenu("Drawings", "Drawings")
mainMenu.Drawings:Boolean("DrawDMG", "Draw Damage", true)


OnLoop(function(myHero)


local myHeroPos = GetOrigin(myHero)
local target = GetCurrentTarget()

-- DMG Drawings

	if GoS:ValidTarget(target) and mainMenu.Drawings.DrawDMG:Value() then	
-- QWR
if CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_W) == READY and CanUseSpell(myHero,_R) == READY then 
local trueDMG = GoS:CalcDamage(myHero, target, 0, (60*GetCastLevel(myHero,_R)+40+(0.6*(GetBonusAP(myHero))))) + GoS:CalcDamage(myHero, target, 0, (35*GetCastLevel(myHero,_Q)+25+(0.7*(GetBonusAP(myHero))))) + GoS:CalcDamage(myHero, target, 0, (36*GetCastLevel(myHero,_W)+30+(0.6*(GetBonusAP(myHero)))))
		DrawDmgOverHpBar(target,GetCurrentHP(target),trueDMG,0,0xff00ff00)
		end
-- QW		
if CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_W) == READY then 
local trueDMG = GoS:CalcDamage(myHero, target, 0, (35*GetCastLevel(myHero,_Q)+25+(0.7*(GetBonusAP(myHero))))) + GoS:CalcDamage(myHero, target, 0, (36*GetCastLevel(myHero,_W)+30+(0.6*(GetBonusAP(myHero)))))
		DrawDmgOverHpBar(target,GetCurrentHP(target),trueDMG,0,0xff00ff00)
		end		
-- Q		
if CanUseSpell(myHero,_Q) == READY then 
local trueDMG = GoS:CalcDamage(myHero, target, 0, (35*GetCastLevel(myHero,_Q)+25+(0.7*(GetBonusAP(myHero)))))
		DrawDmgOverHpBar(target,GetCurrentHP(target),trueDMG,0,0xff00ff00)
		end
-- W
if CanUseSpell(myHero,_W) == READY then 
local trueDMG = GoS:CalcDamage(myHero, target, 0, (36*GetCastLevel(myHero,_W)+30+(0.6*(GetBonusAP(myHero)))))
		DrawDmgOverHpBar(target,GetCurrentHP(target),trueDMG,0,0xff00ff00)
		end	
-- R
if CanUseSpell(myHero,_R) == READY then 
local trueDMG = GoS:CalcDamage(myHero, target, 0, (60*GetCastLevel(myHero,_R)+40+(0.6*(GetBonusAP(myHero)))))
		DrawDmgOverHpBar(target,GetCurrentHP(target),trueDMG,0,0xff00ff00)
		end	
-- RQ
if CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_R) == READY then 
local trueDMG = GoS:CalcDamage(myHero, target, 0, (60*GetCastLevel(myHero,_R)+40+(0.6*(GetBonusAP(myHero))))) + GoS:CalcDamage(myHero, target, 0, (35*GetCastLevel(myHero,_Q)+25+(0.7*(GetBonusAP(myHero)))))
		DrawDmgOverHpBar(target,GetCurrentHP(target),trueDMG,0,0xff00ff00)
		end	
-- RW	
if CanUseSpell(myHero,_W) == READY and CanUseSpell(myHero,_R) == READY then 
local trueDMG = GoS:CalcDamage(myHero, target, 0, (60*GetCastLevel(myHero,_R)+40+(0.6*(GetBonusAP(myHero))))) + GoS:CalcDamage(myHero, target, 0, (36*GetCastLevel(myHero,_W)+30+(0.6*(GetBonusAP(myHero)))))
		DrawDmgOverHpBar(target,GetCurrentHP(target),trueDMG,0,0xff00ff00)
		end		
	end
	
-- Harass
if mainMenu.Harass.Harass1:Value() then
	local mymouse = GetMousePos()
	MoveToXYZ(mymouse)
	if GoS:ValidTarget(target, 1200) then
	-- Q
						if CanUseSpell(myHero, _Q) == READY and mainMenu.Harass.useQh:Value() then

							local QPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1670, 250, 830, 150, false, true)

							if QPred.HitChance == 1 then
								CastSkillShot(_Q, QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
							end
						end
-- W
						if GoS:ValidTarget(target, 200) and mainMenu.Harass.useWh:Value() then
							CastSpell(_W)
						end
	end					
	end

if GoS:ValidTarget(target, 1250) then


		if mainMenu.Combo.Combo1:Value() then
-- RQ-Combo 2.0
	    	if CanUseSpell(myHero, _R) == READY and CanUseSpell(myHero, _Q) == READY and mainMenu.Combo.useQ:Value() and mainMenu.Combo.useR:Value() then

					QPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1670, 250, 830, 150, false, true)

						if QPred.HitChance == 1 and CanUseSpell(myHero, _Q) == READY and mainMenu.Combo.useQ:Value() then
							CastSkillShot(_Q, QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
								if GoS:ValidTarget(target, GetCastRange(myHero, _R)) then
									CastTargetSpell(target,_R)
								end
						end
			end
		

-- Q
						if CanUseSpell(myHero, _Q) == READY and mainMenu.Combo.useQ:Value() then

							local QPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1670, 250, 830, 150, false, true)

							if QPred.HitChance == 1 then
								CastSkillShot(_Q, QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
							end
						end
-- W
						if GoS:ValidTarget(target, 200) and mainMenu.Combo.useW:Value() then
							CastSpell(_W)
						end
-- E (Simple Logic)
						if CanUseSpell(myHero, _E) == READY and not GoS:IsInDistance(target, 150) and GoS:IsInDistance(target, 245) and mainMenu.Combo.useE:Value() then
							CastSpell(_E)
						end
-- R (Simple Logic)
						if CanUseSpell(myHero,_R) == READY and GotBuff(target,"dianamoonlight") >= 1 and GoS:ValidTarget(target, GetCastRange(myHero,_R)) and mainMenu.Combo.useR:Value() then
							CastTargetSpell(target,_R)
						end
		end

-- R KS
						if CanUseSpell(myHero,_R) == READY and GoS:ValidTarget(target, GetCastRange(myHero,_R)) and GetCurrentHP(target) < GoS:CalcDamage(myHero, target, 0, (60*GetCastLevel(myHero,_R)+40+(0.6*(GetBonusAP(myHero))))) and mainMenu.Killsteal.ksR:Value() then
							CastTargetSpell(target,_R)
						end
	
	end
	end)
