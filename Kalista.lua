require('Inspired')

PrintChat("ADC MAIN | Kalista loaded.")
PrintChat("by Noddy")

mainMenu = Menu("ADC MAIN | Kalista", "Kalista")
mainMenu:SubMenu("Combo", "Combo")
mainMenu.Combo:Boolean("useQ", "Use Q in combo", true)
mainMenu.Combo:Boolean("useE", "Use E if killable", true)
mainMenu.Combo:Boolean("useEx", "Use E with reset", true)
mainMenu.Combo:Slider("useExS","E reset on X spears", 5 , 1, 20, 1)
-- mainMenu.Combo:Boolean("useR", "Use R in combo", false)
mainMenu.Combo:Key("Combo1", "Combo", string.byte(" "))
---------------------------------------------------------------------------------
-- mainMenu:SubMenu("Harass", "Harass")
-- mainMenu.Harass:Boolean("hQ", "Use Q", true)
-- mainMenu.Harass:Boolean("hE", "Use E", true)
-- mainMenu.Harass:Key("Harass1", "Harass", string.byte("C"))
---------------------------------------------------------------------------------
mainMenu:SubMenu("Killsteal", "Killsteal")
mainMenu.Killsteal:Boolean("ksQ", "Use Q - KS", true)
mainMenu.Killsteal:Boolean("ksE", "Use E - KS", true)
---------------------------------------------------------------------------------
mainMenu:SubMenu("Items", "Items")
mainMenu.Items:Boolean("useCut", "Bilgewater Cutlass", true)
mainMenu.Items:Boolean("useBork", "Blade of the Ruined King", true)
mainMenu.Items:Boolean("useGhost", "Youmuu's Ghostblade", true)
mainMenu.Items:Boolean("useRedPot", "Elixir of Wrath", true)
---------------------------------------------------------------------------------
mainMenu:SubMenu("Farm", "Farm")
mainMenu.Farm:Boolean("farmE", "Use E", true)
mainMenu.Farm:Slider("farmEx","Use on X minions", 2 , 1, 10, 1)
mainMenu.Farm:Key("Farm1", "Farm", string.byte("V"))
---------------------------------------------------------------------------------
mainMenu:SubMenu("Drawings", "Drawings")
mainMenu.Drawings:Boolean("drawE", "Draw E-Damage", true)


--DOTO:
-- Q, E ,  R(semi auto) on T
-- E if minion killable + E on enemy (x stacks) done
-- E if auto of range of Q range + Q cooldown

OnLoop(function (myHero)

local target = GetCurrentTarget()
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

-- Combo
if mainMenu.Combo.Combo1:Value() then
-- Q
if mainMenu.Combo.useQ:Value() then
useQ()
end
-- E if killable
if mainMenu.Combo.useE:Value() then
ksE()
end
-- Ex
if mainMenu.Combo.useEx:Value() then
useEx()
end






end



-- Draw E Damage
if mainMenu.Drawings.drawE:Value() then
for i,enemy in pairs(GoS:GetEnemyHeroes()) do
	if GotBuff(enemy,"kalistaexpungemarker") >= 1 and GoS:ValidTarget(enemy,2500) then
		eDMG = GoS:CalcDamage(myHero, enemy, 10*GetCastLevel(myHero,_E)+10+(0.6*(GetBaseDamage(myHero)+GetBonusDmg(myHero))) + (((({[1]=10,[2]=14,[3]=19,[4]=25,[5]=32})[GetCastLevel(myHero,_E)])+((0.025*GetCastLevel(myHero,_E)+0.175)*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))*(GotBuff(enemy,"kalistaexpungemarker")-1)),0)
		DrawDmgOverHpBar(enemy,GetCurrentHP(enemy)+GetDmgShield(enemy),eDMG,0,ARGB(255,33,139,6))
	end
end
end
-- Q KillSteal
if mainMenu.Killsteal.ksQ:Value() then
ksQ()
end
-- E KillSteal
if mainMenu.Killsteal.ksE:Value() then
ksE()
end
-- E Farm
if mainMenu.Farm.Farm1:Value() and mainMenu.Farm.farmE.Value() then
farmE()
end

end)

-- Use Q
function useQ()
for i,enemy in pairs(GoS:GetEnemyHeroes()) do
if CanUseSpell(myHero,_Q) == READY and IsTargetable(enemy) and GoS:ValidTarget(enemy,GetCastRange(myHero,_Q)) and GetCurrentMana(myHero) > GetCastMana(myHero,_Q,GetCastLevel(myHero,_Q)) + 40 then
	local QPred = GetPredictionForPlayer(GoS:myHeroPos(),enemy,GetMoveSpeed(enemy),1500,250,1150,50,true,false)
		if QPred.HitChance == 1 then
			CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
		end	
end
end
end

-- KillSteal E
function ksE()
for i,enemy in pairs(GoS:GetEnemyHeroes()) do
	if CanUseSpell(myHero,_E) == READY and GotBuff(enemy,"kalistaexpungemarker") >= 1 and IsTargetable(enemy) and GoS:ValidTarget(enemy,GetCastRange(myHero,_E)) and GetCurrentHP(enemy)+GetDmgShield(enemy) < GoS:CalcDamage(myHero, enemy, 10*GetCastLevel(myHero,_E)+10+(0.6*(GetBaseDamage(myHero)+GetBonusDmg(myHero))) + (((({[1]=10,[2]=14,[3]=19,[4]=25,[5]=32})[GetCastLevel(myHero,_E)])+((0.025*GetCastLevel(myHero,_E)+0.175)*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))*(GotBuff(enemy,"kalistaexpungemarker")-1)),0) then
		CastSpell(_E)
	end
end
end
-- KillSteal Q
function ksQ()
for i,enemy in pairs(GoS:GetEnemyHeroes()) do
	if CanUseSpell(myHero,_Q) == READY and IsTargetable(enemy) and GoS:ValidTarget(enemy,GetCastRange(myHero,_Q)) and GetCurrentHP(enemy)+GetDmgShield(enemy) < GoS:CalcDamage(myHero, enemy, 60*GetCastLevel(myHero,_Q)-50+(GetBaseDamage(myHero)+GetBonusDmg(myHero)),0) then
		local QPred = GetPredictionForPlayer(GoS:myHeroPos(),enemy,GetMoveSpeed(enemy),1500,250,1150,50,true,false)
			if QPred.HitChance == 1 then
			CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
			end	
	end
end
end

-- Thanks to Deftsu CopyPasta all day long Kappa
function farmE()
    for _,minion in pairs(GoS:GetAllMinions(MINION_ENEMY)) do
	local minionX = 0
		if CanUseSpell(myHero,_E) == READY and GotBuff(minion,"kalistaexpungemarker") >= 1 and GoS:ValidTarget(minion,GetCastRange(myHero,_E)) and GetCurrentHP(minion) + GetDmgShield(minion) < GoS:CalcDamage(myHero, minion, 10*GetCastLevel(myHero,_E)+10+(0.6*(GetBaseDamage(myHero)+GetBonusDmg(myHero))) + (((({[1]=10,[2]=14,[3]=19,[4]=25,[5]=32})[GetCastLevel(myHero,_E)])+((0.025*GetCastLevel(myHero,_E)+0.175)*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))*(GotBuff(minion,"kalistaexpungemarker")-1)),0) then
			minionX = minionX + 1
			-- PrintChat(minionX)
		end
				if CanUseSpell(myHero,_E) == READY and minionX >= mainMenu.Farm.farmEx:Value() then
					CastSpell(_E)
					minionX = 0
				end		
	end
end

-- E if Minion killable + Target
function useEx()
local minionXe = 0
    for _,minion in pairs(GoS:GetAllMinions(MINION_ENEMY)) do
		if CanUseSpell(myHero,_E) == READY and GotBuff(minion,"kalistaexpungemarker") >= 1 and GoS:ValidTarget(minion,GetCastRange(myHero,_E)) and GetCurrentHP(minion) + GetDmgShield(minion) < GoS:CalcDamage(myHero, minion, 10*GetCastLevel(myHero,_E)+10+(0.6*(GetBaseDamage(myHero)+GetBonusDmg(myHero))) + (((({[1]=10,[2]=14,[3]=19,[4]=25,[5]=32})[GetCastLevel(myHero,_E)])+((0.025*GetCastLevel(myHero,_E)+0.175)*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))*(GotBuff(minion,"kalistaexpungemarker")-1)),0) then
			minionXe = minionXe + 1
		end
			for i,enemy in pairs(GoS:GetEnemyHeroes()) do
				if CanUseSpell(myHero,_E) == READY and minionXe >= 1 and IsTargetable(enemy) and GoS:ValidTarget(enemy,GetRange(myHero)) and GotBuff(enemy,"kalistaexpungemarker") >= mainMenu.Combo.useExS:Value() then
					CastSpell(_E)
					minionXe = 0
				end
				if CanUseSpell(myHero,_E) == READY and minionXe >= 1 and IsTargetable(enemy) and not GoS:IsInDistance(enemy,GetRange(myHero)) and GoS:ValidTarget(enemy,GetCastRange(myHero,_E)) and GotBuff(enemy,"kalistaexpungemarker") >= 1 then
					CastSpell(_E)
					minionXe = 0
				end			
			end		
	end
end
