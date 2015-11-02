if GetObjectName(GetMyHero()) ~= "Diana" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua!") return end

PrintChat("Diana - The moonwalker loaded.")
PrintChat("by Noddy")

local mainMenu = Menu("Diana", "Diana")
mainMenu:Menu("Combo", "Combo")
mainMenu.Combo:Boolean("useQ", "Use Q in combo", true)
mainMenu.Combo:Boolean("useW", "Use W in combo", true)
mainMenu.Combo:Boolean("useE", "Use E in combo", true)
mainMenu.Combo:Boolean("useR", "Use R in combo", true)
mainMenu.Combo:Key("Combo1", "Combo", string.byte(" "))
-----------------------------------------------------
mainMenu:Menu("Killsteal", "Killsteal")
mainMenu.Killsteal:Boolean("ksR", "Use R - KS", true)
-----------------------------------------------------
mainMenu:Menu("Harass", "Harass")
mainMenu.Harass:Boolean("useQh", "Use Q in harass", true)
mainMenu.Harass:Boolean("useWh", "Use W in harass", true)
mainMenu.Harass:Key("Harass1", "Harass", string.byte("C"))
-----------------------------------------------------
mainMenu:Menu("Drawings", "Drawings")
mainMenu.Drawings:Boolean("DrawDMG", "Draw Damage", true)


OnDraw(function(myHero)
-- DMG Drawings
local target = GetCurrentTarget()
if ValidTarget(target,3000) and mainMenu.Drawings.DrawDMG:Value() then	
-- QWR
if CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_W) == READY and CanUseSpell(myHero,_R) == READY then 
local trueDMG = CalcDamage(myHero, target, 0, (60*GetCastLevel(myHero,_R)+40+(0.6*(GetBonusAP(myHero))))) + CalcDamage(myHero, target, 0, (35*GetCastLevel(myHero,_Q)+25+(0.7*(GetBonusAP(myHero))))) + CalcDamage(myHero, target, 0, (36*GetCastLevel(myHero,_W)+30+(0.6*(GetBonusAP(myHero)))))
		DrawDmgOverHpBar(target,GetCurrentHP(target),trueDMG,0,0xff00ff00)
		end
-- QW		
if CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_W) == READY then 
local trueDMG = CalcDamage(myHero, target, 0, (35*GetCastLevel(myHero,_Q)+25+(0.7*(GetBonusAP(myHero))))) + CalcDamage(myHero, target, 0, (36*GetCastLevel(myHero,_W)+30+(0.6*(GetBonusAP(myHero)))))
		DrawDmgOverHpBar(target,GetCurrentHP(target),trueDMG,0,0xff00ff00)
		end		
-- Q		
if CanUseSpell(myHero,_Q) == READY then 
local trueDMG = CalcDamage(myHero, target, 0, (35*GetCastLevel(myHero,_Q)+25+(0.7*(GetBonusAP(myHero)))))
		DrawDmgOverHpBar(target,GetCurrentHP(target),trueDMG,0,0xff00ff00)
		end
-- W
if CanUseSpell(myHero,_W) == READY then 
local trueDMG = CalcDamage(myHero, target, 0, (36*GetCastLevel(myHero,_W)+30+(0.6*(GetBonusAP(myHero)))))
		DrawDmgOverHpBar(target,GetCurrentHP(target),trueDMG,0,0xff00ff00)
		end	
-- R
if CanUseSpell(myHero,_R) == READY then 
local trueDMG = CalcDamage(myHero, target, 0, (60*GetCastLevel(myHero,_R)+40+(0.6*(GetBonusAP(myHero)))))
		DrawDmgOverHpBar(target,GetCurrentHP(target),trueDMG,0,0xff00ff00)
		end	
-- RQ
if CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_R) == READY then 
local trueDMG = CalcDamage(myHero, target, 0, (60*GetCastLevel(myHero,_R)+40+(0.6*(GetBonusAP(myHero))))) + CalcDamage(myHero, target, 0, (35*GetCastLevel(myHero,_Q)+25+(0.7*(GetBonusAP(myHero)))))
		DrawDmgOverHpBar(target,GetCurrentHP(target),trueDMG,0,0xff00ff00)
		end	
-- RW	
if CanUseSpell(myHero,_W) == READY and CanUseSpell(myHero,_R) == READY then 
local trueDMG = CalcDamage(myHero, target, 0, (60*GetCastLevel(myHero,_R)+40+(0.6*(GetBonusAP(myHero))))) + CalcDamage(myHero, target, 0, (36*GetCastLevel(myHero,_W)+30+(0.6*(GetBonusAP(myHero)))))
		DrawDmgOverHpBar(target,GetCurrentHP(target),trueDMG,0,0xff00ff00)
		end		
	end
end)

OnTick(function(myHero)


local myHeroPos = GetOrigin(myHero)
local target = GetCurrentTarget()
	
for i,enemy in pairs(GetEnemyHeroes()) do	
	-- R KS
	if CanUseSpell(myHero,_R) == READY and ValidTarget(enemy, GetCastRange(myHero,_R)) and GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, (60*GetCastLevel(myHero,_R)+40+(0.6*(GetBonusAP(myHero))))) and mainMenu.Killsteal.ksR:Value() then
		CastTargetSpell(enemy,_R)
	end
end
	
-- Harass
if mainMenu.Harass.Harass1:Value() then
	local mymouse = GetMousePos()
	-- MoveToXYZ(mymouse)
	if ValidTarget(target, 1200) then
	-- Q
						if CanUseSpell(myHero, _Q) == READY and mainMenu.Harass.useQh:Value() then

							local QPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1670, 250, 830, 150, false, true)

							if QPred.HitChance == 1 then
								CastSkillShot(_Q, QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
							end
						end
-- W
						if ValidTarget(target, 200) and mainMenu.Harass.useWh:Value() then
							CastSpell(_W)
						end
	end					
	end

if ValidTarget(target, 1250) then


		if mainMenu.Combo.Combo1:Value() then
-- RQ-Combo 2.0
	    	if CanUseSpell(myHero, _R) == READY and CanUseSpell(myHero, _Q) == READY and mainMenu.Combo.useQ:Value() and mainMenu.Combo.useR:Value() then

					QPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1670, 250, 830+GetHitBox(target)/2, 150, false, true)

						if QPred.HitChance == 1 and CanUseSpell(myHero, _Q) == READY and mainMenu.Combo.useQ:Value() then
							CastSkillShot(_Q, QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
								if ValidTarget(target, GetCastRange(myHero, _R)) then
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
						if ValidTarget(target, 200+GetHitBox(target)/2) and mainMenu.Combo.useW:Value() then
							CastSpell(_W)
						end
-- E (Simple Logic)
						if CanUseSpell(myHero, _E) == READY and not IsInDistance(target, 150+GetHitBox(target)) and IsInDistance(target, 245+GetHitBox(target)/2) and mainMenu.Combo.useE:Value() then
							CastSpell(_E)
						end
-- R (Simple Logic)
						if CanUseSpell(myHero,_R) == READY and GotBuff(target,"dianamoonlight") >= 1 and ValidTarget(target, GetCastRange(myHero,_R)) and mainMenu.Combo.useR:Value() then
							CastTargetSpell(target,_R)
						end
		end
	
end

end)
