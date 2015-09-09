require('Inspired')

PrintChat("ADC MAIN | Graves loaded.")
PrintChat("by Noddy")


mainMenu = Menu("ADC MAIN | Graves", "Graves")
mainMenu:SubMenu("Combo", "Combo")
mainMenu.Combo:Boolean("useQ", "Use Q in combo", true)
mainMenu.Combo:Boolean("useW", "Use W in combo", true)
mainMenu.Combo:Boolean("useE", "Use E in combo", true)
mainMenu.Combo:Boolean("useR", "Use R in combo", true)
mainMenu.Combo:Boolean("Burst", "Burst-Combo", true)
mainMenu.Combo:Key("Combo1", "Combo", string.byte(" "))
---------------------------------------------------------------------------------
mainMenu:SubMenu("Harass", "Harass")
mainMenu.Harass:Boolean("hQ", "Use Q", true)
mainMenu.Harass:Key("Harass1", "Harass", string.byte("C"))
---------------------------------------------------------------------------------
mainMenu:SubMenu("Killsteal", "Killsteal")
mainMenu.Killsteal:Boolean("ksQ", "Use Q - KS", true)
mainMenu.Killsteal:Boolean("ksR", "Use R - KS", true)
---------------------------------------------------------------------------------
mainMenu:SubMenu("Items", "Items")
mainMenu.Items:Boolean("useCut", "Bilgewater Cutlass", true)
mainMenu.Items:Boolean("useBork", "Blade of the Ruined King", true)
mainMenu.Items:Boolean("useGhost", "Youmuu's Ghostblade", true)
mainMenu.Items:Boolean("useRedPot", "Elixir of Wrath", true)
---------------------------------------------------------------------------------
mainMenu:SubMenu("Drawings", "Drawings")
mainMenu.Drawings:Boolean("drawR", "Draw R-Damage", true)




--TODO: Graves
-- Simple Combo Q/W/E/R(ifkillable) [DONE]
-- Burst Combo [DONE]

-- KS Q, R, W
-- KS E Helper

-- Harass aa-Q [UN]

DPS = 0

OnLoop(function(myHero)

local target = GetCurrentTarget()
local mouse = GetMousePos()
local myHeroPos = GetOrigin(myHero)

-- Items
local CutBlade = GetItemSlot(myHero,3144)
local bork = GetItemSlot(myHero,3153)
local ghost = GetItemSlot(myHero,3142)
local redpot = GetItemSlot(myHero,2140)

-- Use Items
if mainMenu.Combo.Combo1:Value() then
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
end

-- Killsteal
if mainMenu.Killsteal.ksQ:Value() then
for i,enemy in pairs(GoS:GetEnemyHeroes()) do
		if CanUseSpell(myHero,_Q) == READY and GoS:ValidTarget(enemy, 950) and mainMenu.Killsteal.ksQ:Value() and GetCurrentHP(enemy) < GoS:CalcDamage(myHero,enemy,(30*GetCastLevel(myHero,_Q)+30+(0.75*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))),0) then
			local QPred = GetPredictionForPlayer(myHeroPos,enemy,GetMoveSpeed(enemy),2000,250,925,50,false,false)
			if QPred.HitChance == 1 then
				CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
			end	
		end	
	end
end	

if mainMenu.Killsteal.ksR:Value() then
	for i,enemy in pairs(GoS:GetEnemyHeroes()) do
		if CanUseSpell(myHero,_R) == READY and GoS:ValidTarget(enemy, 2000) and mainMenu.Killsteal.ksR:Value() and GetCurrentHP(enemy) < GoS:CalcDamage(myHero,enemy,(120*GetCastLevel(myHero,_R)+80+(1.2*GetBonusDmg(myHero))),0) then
			local RPred2 = GetPredictionForPlayer(myHeroPos,enemy,GetMoveSpeed(enemy),2100,250,1800,100,false,false)
			if RPred2.HitChance == 1 then
				CastSkillShot(_R,RPred2.PredPos.x,RPred2.PredPos.y,RPred2.PredPos.z)
			end
		end
	end
end

-- Combo
if mainMenu.Combo.Combo1:Value() then

	if CanUseSpell(myHero,_E) == READY and GoS:ValidTarget(target, 950) and mainMenu.Combo.useE:Value() then
		CastSkillShot(_E, mouse.x, mouse.y, mouse.z)
	end

	if CanUseSpell(myHero,_Q) == READY and GoS:ValidTarget(target, 950) and mainMenu.Combo.useQ:Value() then
		local QPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),2000,250,925,50,false,false)
		if QPred.HitChance == 1 then
			CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
		end
	end

	if CanUseSpell(myHero,_W) == READY and GoS:ValidTarget(target, 950) and GetCurrentMana(myHero) > 170 and mainMenu.Combo.useW:Value() then
		local WPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),1500,250,950,50,false,false)
		if WPred.HitChance == 1 then
			CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
		end
	end
	
	--R 1
	if CanUseSpell(myHero,_R) == READY and mainMenu.Combo.useR:Value() and GoS:ValidTarget(target,1000) and GetCurrentHP(target) < GoS:CalcDamage(myHero,target,(150*GetCastLevel(myHero,_R)+100+(1.5*GetBonusDmg(myHero))),0) then
		-- PrintChat("R1")
		local RPred1 = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),2100,250,1800,100,false,false)
		if RPred1.HitChance == 1 then
			CastSkillShot(_R,RPred1.PredPos.x,RPred1.PredPos.y,RPred1.PredPos.z)
		end
	end
	--R 2
	if CanUseSpell(myHero,_R) == READY and mainMenu.Combo.useR:Value() and not GoS:IsInDistance(target, 1000) and GoS:IsInDistance(target,1800) and GetCurrentHP(target) < GoS:CalcDamage(myHero,target,(120*GetCastLevel(myHero,_R)+80+(1.2*GetBonusDmg(myHero))),0) then
		local RPred2 = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),2100,250,1800,100,false,false)
		if RPred2.HitChance == 1 then
			CastSkillShot(_R,RPred2.PredPos.x,RPred2.PredPos.y,RPred2.PredPos.z)
		end
	end

-- Burstcombo
if GoS:ValidTarget(target,950) and mainMenu.Combo.Burst:Value() and GetCurrentHP(target) < DPS then
	if GoS:IsInDistance(target, 550) then
		local RPredBurst = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),2100,250,1800,100,false,false)
		local QPredBurst = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),2000,250,925,50,false,false)
			if CanUseSpell(myHero,_R) == READY and RPredBurst.HitChance == 1 and CanUseSpell(myHero,_Q) == READY and QPredBurst.HitChance == 1 then
				CastSkillShot(_R,RPredBurst.PredPos.x,RPredBurst.PredPos.y,RPredBurst.PredPos.z)
					GoS:DelayAction(function ()
						CastSkillShot(_Q,QPredBurst.PredPos.x,QPredBurst.PredPos.y,QPredBurst.PredPos.z)
					end, 0)
			end
	end
	if not GoS:IsInDistance(target,550) and CanUseSpell(myHero,_E) then
		local targetPos = GetOrigin(target)
		CastSkillShot(_E, targetPos.x, targetPos.y, targetPos.z)
	end	
end
end

-- Harass Q
if mainMenu.Harass.Harass1:Value() then
	MoveToXYZ(mouse)
if CanUseSpell(myHero,_Q) == READY and GoS:ValidTarget(target, 700) and mainMenu.Harass.hQ:Value() and (GetMaxMana(myHero) / GetCurrentMana(myHero)) <= 1.5 then
-- if CanUseSpell(myHero,_Q) == READY and GoS:ValidTarget(target, 700) and mainMenu.Harass.hQ:Value() then
	local QPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),2000,250,950,50,false,false)
	if QPred.HitChance == 1 then
		CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
		
	end
end
end

-- R-Damage
if CanUseSpell(myHero,_R) == READY and GoS:ValidTarget(target, 1800) and mainMenu.Drawings.drawR:Value() then
for _,enemy in pairs(GoS:GetEnemyHeroes()) do
	rDMG = GoS:CalcDamage(myHero,enemy,(150*GetCastLevel(myHero,_R)+100+(1.5*GetBonusDmg(myHero))),0)
	DrawDmgOverHpBar(enemy,GetCurrentHP(enemy),rDMG,0,0xff00ff00)
end
end
-- Burst-Combo Damage
if CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_R) == READY and GoS:ValidTarget(target,950) and mainMenu.Combo.Burst:Value() then
	SKILLDPS = GoS:CalcDamage(myHero,target,(30*GetCastLevel(myHero,_Q)+30+(0.75*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))),0) + GoS:CalcDamage(myHero,target,(120*GetCastLevel(myHero,_R)+80+(1.2*GetBonusDmg(myHero))),0) + GoS:CalcDamage(myHero,target,(GetBaseDamage(myHero)+GetBonusDmg(myHero)),0)
	-- ADD statik
	if GotBuff(myHero,"itemstatikshankcharge") == 100 then
		extraDMG = GoS:CalcDamage(myHero,target,0,100)
	else
		extraDMG = 0
	end
	
	DPS = SKILLDPS + extraDMG
		DrawDmgOverHpBar(target,GetCurrentHP(target),DPS,0,0xff00ff00)
end
end)
