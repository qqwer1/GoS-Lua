require('Inspired')

PrintChat("ADC MAIN | Lucian loaded.")
PrintChat("by Noddy")

mainMenu = Menu("ADC MAIN | Lucian", "Lucian")
mainMenu:SubMenu("Combo", "Combo")
mainMenu.Combo:Boolean("useQ", "Use Q in combo", true)
mainMenu.Combo:Boolean("useW", "Use W in combo", true)
mainMenu.Combo:Boolean("useE", "Use E in combo", true)
mainMenu.Combo:Boolean("useR", "Use R in combo", true)
mainMenu.Combo:Key("Combo1", "Combo", string.byte(" "))
------------------------------------------------------	
mainMenu:SubMenu("Drawings", "Drawings")
mainMenu.Drawings:Boolean("DrawDMG","Draw R damage", true)
mainMenu.Drawings:Boolean("DrawQex","Extended Q range", true)
mainMenu.Drawings:Slider("Quality","Circle Quality", 100 , 1, 255, 1)
------------------------------------------------------
mainMenu:SubMenu("Items", "Items")
mainMenu.Items:Boolean("useCut", "Bilgewater Cutlass", true)
mainMenu.Items:Boolean("useBork", "Blade of the Ruined King", true)
mainMenu.Items:Boolean("useGhost", "Youmuu's Ghostblade", true)
mainMenu.Items:Boolean("useRedPot", "Elixir of Wrath", true)

Passive = 0	

OnProcessSpell(function(unit, spell)
if unit and unit == myHero and spell then
    if spell.name:lower():find("lucianq") then
		Passive = 1
	elseif spell.name:lower():find("lucianw") then	
		Passive = 1
	elseif spell.name:lower():find("luciane") then	
		Passive = 1	
	elseif spell.name:lower():find("lucianr") then	
		Passive = 1		
	elseif 	spell.name:lower():find("lucianpassiveattack") then
		Passive = 0
	elseif 	spell.name:lower():find("attack") then
		Passive = 0	
	end
end
end)

OnLoop (function (myHero)

local myHeroPos = GetOrigin(myHero)
local target = GetCurrentTarget()
local mouse = GetMousePos()

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


if mainMenu.Drawings.DrawDMG:Value() and CanUseSpell(myHero,_R) == READY and GoS:ValidTarget(target, 1500) then
	DPS = GoS:CalcDamage(myHero,target,(10*GetCastLevel(myHero,_R)+30+(0.25*(GetBaseDamage(myHero) + GetBonusDmg(myHero))) * (7 + (((150*GetCastLevel(myHero,_R)+500) + GetAttackSpeed(myHero)) / (22.4 - 2.49*(GetCastLevel(myHero,_R)))) * ((22.4 - 2.49*(GetCastLevel(myHero,_R))) / 100))),0)
	-- DPS = GoS:CalcDamage(myHero,target,(10*GetCastLevel(myHero,_R)+30+(0.25*(GetBaseDamage(myHero) + GetBonusDmg(myHero))))* (7 + (((150*GetCastLevel(myHero,_R)+500) + GetAttackSpeed(myHero)) / (22.4 - 2.49*(GetCastLevel(myHero,_R)))) * ((22.4 - 2.49*(GetCastLevel(myHero,_R))) / 100)),0) 
	DrawDmgOverHpBar(target,GetCurrentHP(target),DPS,0,0xff00ff00)
end

if mainMenu.Drawings.DrawQex:Value() then
	DrawCircle(GetOrigin(myHero),1100,0,mainMenu.Drawings.Quality:Value(),0xffffffff)
end


if mainMenu.Combo.Combo1:Value() then
---------------------------

----------------------------
if GotBuff(myHero,"lucianpassivebuff") == 1 or Passive == 1 and GoS:ValidTarget(target, 500) then
	AttackUnit(target)
elseif GotBuff(myHero,"lucianpassivebuff") == 0 and Passive == 0 then

if CanUseSpell(myHero,_Q) == READY and mainMenu.Combo.useQ:Value() and GotBuff(myHero,"lucianpassivebuff") == 0 then
		if GoS:ValidTarget(target, 700) then
			CastTargetSpell(target,_Q)
		end
end	

if CanUseSpell(myHero,_W) == READY and CanUseSpell(myHero,_Q) == ONCOOLDOWN and mainMenu.Combo.useW:Value() and GotBuff(myHero,"lucianpassivebuff") == 0 and Passive == 0 then
	WPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),2000, 150, 650, 50, true, true)
		if GoS:ValidTarget(target, GetCastRange(myHero,_W)) and WPred.HitChance == 1 then
			CastSkillShot(_W, WPred.PredPos.x, WPred.PredPos.y, WPred.PredPos.z)
		elseif GoS:ValidTarget(target, 500) and WPred.HitChance == 0 then
			CastSkillShot(_W, WPred.PredPos.x, WPred.PredPos.y, WPred.PredPos.z)
		end
end

if CanUseSpell(myHero,_E) == READY and CanUseSpell(myHero,_Q) == ONCOOLDOWN and CanUseSpell(myHero,_W) == ONCOOLDOWN and mainMenu.Combo.useE:Value() and GotBuff(myHero,"lucianpassivebuff") == 0 then
		if GoS:ValidTarget(target, 700) then
			CastSkillShot(_E, mouse.x, mouse.y, mouse.z)
		end
end	
end

-- R
if CanUseSpell(myHero,_R) == READY and GoS:ValidTarget(target,1400) and mainMenu.Combo.useR:Value() and GetCurrentHP(target) < GoS:CalcDamage(myHero,target,(10*GetCastLevel(myHero,_R)+30+(0.25*(GetBaseDamage(myHero) + GetBonusDmg(myHero))) * (7 + (((150*GetCastLevel(myHero,_R)+500) + GetAttackSpeed(myHero)) / (22.4 - 2.49*(GetCastLevel(myHero,_R)))) * ((22.4 - 2.49*(GetCastLevel(myHero,_R))) / 100))),0) then
	local RPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),3500, 250, 1500, 75, true, false)
		if CanUseSpell (myHero,_R) == READY and RPred.HitChance == 1 and not GoS:IsInDistance(target, 650) and GoS:IsInDistance(target, 1400) and CanUseSpell(myHero,_Q) == ONCOOLDOWN then
			CastSkillShot(_R, RPred.PredPos.x, RPred.PredPos.y, RPred.PredPos.z)
		end
end

end
end)
