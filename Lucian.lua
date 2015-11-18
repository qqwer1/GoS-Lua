if GetObjectName(GetMyHero()) ~= "Lucian" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua!") return end

PrintChat("ADC MAIN | Lucian loaded.")
PrintChat("by Noddy")

local mainMenu = Menu("ADC MAIN | Lucian", "Lucian")
mainMenu:Menu("Combo", "Combo")
mainMenu.Combo:Boolean("useQ", "Use Q", true)
mainMenu.Combo:Boolean("useQex", "Use extended Q", false)
mainMenu.Combo:Boolean("useW", "Use W", true)
mainMenu.Combo:Boolean("useE", "Use E", true)
mainMenu.Combo:Boolean("useR", "Use R", true)
mainMenu.Combo:Key("lockR", "Lock R on enemy(beta)", string.byte("T"))
mainMenu.Combo:Key("Combo1", "Combo", string.byte(" "))
------------------------------------------------------	
mainMenu:Menu("Harass", "Harass")
mainMenu.Harass:Boolean("useQ", "Use Q", true)
mainMenu.Harass:Slider("manaQ","Q: Mana-Manager", 60 , 0, 100, 1)
mainMenu.Harass:Boolean("useQex", "Use extended Q", true)
mainMenu.Harass:Slider("manaQex","Q (Extended): Mana-Manager", 50 , 0, 100, 1)
mainMenu.Harass:Boolean("useW", "Use W", false)
mainMenu.Harass:Slider("manaW","W: Mana-Manager", 80 , 0, 100, 1)
mainMenu.Harass:Boolean("useE", "Use E", false)
mainMenu.Harass:Slider("manaE","E: Mana-Manager", 40 , 0, 100, 1)
mainMenu.Harass:Key("Harass1", "Harass", string.byte("C"))
------------------------------------------------------	
mainMenu:Menu("Drawings", "Drawings")
mainMenu.Drawings:Boolean("DrawDMG","Draw damage", true)
mainMenu.Drawings:Boolean("DrawQex","Extended Q range", true)
mainMenu.Drawings:Slider("Quality","Circle Quality", 100 , 1, 255, 1)
------------------------------------------------------
mainMenu:Menu("Items", "Items")
mainMenu.Items:Boolean("useCut", "Bilgewater Cutlass", true)
mainMenu.Items:Boolean("useBork", "Blade of the Ruined King", true)
mainMenu.Items:Boolean("useGhost", "Youmuu's Ghostblade", true)
mainMenu.Items:Boolean("useRedPot", "Elixir of Wrath", true)

local Passive = 0	
local baseAS = GetBaseAttackSpeed(myHero)
local atk = true
local myHitBox = GetHitBox(myHero)
local global_ticks1 = 0

OnProcessSpell(function(unit, spell)
if unit == myHero then
    if spell.name:lower():find("lucianq") then
		DelayAction(function()
			CastEmote(EMOTE_DANCE)
		end, 150)
		Passive = 1
		DelayAction(function()
			Passive = 0
		end, 3000)
	elseif spell.name:lower():find("lucianw") then	
		Passive = 1
		DelayAction(function()
			Passive = 0
		end, 3000)
	elseif spell.name:lower():find("luciane") then	
		Passive = 1	
		DelayAction(function()
			Passive = 0
		end, 3000)
	elseif spell.name:lower():find("lucianr") then	
		Passive = 1
		DelayAction(function()
			Passive = 0
		end, 3000)
	end
end
end)

OnRemoveBuff(function(unit, buff)
	if unit == myHero and buff.Name == "lucianpassivebuff" then
		Passive = 0
	end
end)

OnProcessSpellComplete(function(unit, spell)
	if unit == myHero and spell.name:lower():find("attack") then
		-- PrintChat("AA")
		Passive = 0
		ASDelay = 1/(baseAS*GetAttackSpeed(myHero))
		atk = false
		if mainMenu.Combo.useQ:Value() and CanUseSpell(myHero,_Q) == READY and spell.target == GetCurrentTarget() and mainMenu.Combo.Combo1:Value() then
			CastTargetSpell(GetCurrentTarget(),_Q)
		end
		if mainMenu.Harass.useQ:Value() and CanUseSpell(myHero,_Q) == READY and spell.target == GetCurrentTarget() and mainMenu.Harass.Harass1:Value() and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= mainMenu.Harass.manaQ:Value() then
			CastTargetSpell(GetCurrentTarget(),_Q)
		end
		
		DelayAction(function()
		if CanUseSpell(myHero,_W) == READY and mainMenu.Combo.useW:Value() and spell.target == GetCurrentTarget() and mainMenu.Combo.Combo1:Value() then
		local WPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target),2000, 150, 1000, 50, true, true)
			if WPred.HitChance == 1 then
				CastSkillShot(_W, WPred.PredPos.x, WPred.PredPos.y, WPred.PredPos.z)
			elseif WPred.HitChance == 0 and IsInDistance(target, 500 + myHitBox) then
				CastSkillShot(_W, WPred.PredPos.x, WPred.PredPos.y, WPred.PredPos.z)
			end
		end
		end,3)
		
		DelayAction(function()
			atk = true
		end, ASDelay*1000- spell.windUpTime*1000)
	end
	if unit == myHero and not spell.name:lower():find("attack") and spell.name ~= "recall" and mainMenu.Combo.Combo1:Value() then
		DelayAction(function()
		if ValidTarget(GetCurrentTarget(), GetRange(myHero)+GetHitBox(myHero)) and mainMenu.Combo.Combo1:Value() and atk == true then
			AttackUnit(GetCurrentTarget())
		end
		end, 2)
	end
end)

OnTick (function (myHero)

local myHeroPos = GetOrigin(myHero)
target = GetCurrentTarget()

-- Items
local CutBlade = GetItemSlot(myHero,3144)
local bork = GetItemSlot(myHero,3153)
local ghost = GetItemSlot(myHero,3142)
local redpot = GetItemSlot(myHero,2140)

local passiveatk = 0

if CanUseSpell(myHero,_Q) == READY then
	passiveatk = passiveatk + 1
	qDMG = CalcDamage(myHero,target,(30*GetCastLevel(myHero,_Q)+50+((0.45+(0.15*GetCastLevel(myHero,_Q)))*GetBonusDmg(myHero))),0)
else qDMG = 0 end
if CanUseSpell(myHero,_W) == READY then
	passiveatk = passiveatk + 1
	wDMG = CalcDamage(myHero,target,0,40*GetCastLevel(myHero,_W)+20+(0.9*GetBonusAP(myHero)))
else wDMG = 0 end
if CanUseSpell(myHero,_E) == READY then
	passiveatk = passiveatk + 1
end

local pDMG = CalcDamage(myHero,target,(GetBaseDamage(myHero)+GetBonusDmg(myHero))+(GetBaseDamage(myHero)+GetBonusDmg(myHero))*(({[1]=0.3,[2]=0.3,[3]=0.3,[4]=0.3,[5]=0.3,[6]=0.3,[7]=0.4,[8]=0.4,[9]=0.4,[10]=0.4,[11]=0.4,[12]=0.4,[13]=0.5,[14]=0.5,[15]=0.5,[16]=0.5,[17]=0.5,[18]=0.5})[GetLevel(myHero)]),0)*passiveatk
local pDMGCrit = (2*pDMG) * GetCritChance(myHero)

DPS = qDMG + wDMG + pDMG + pDMGCrit

if mainMenu.Combo.lockR:Value() and CanUseSpell(myHero,_R) == READY and ValidTarget(target, 1300) and not IsInDistance(target, GetRange(myHero)+myHitBox) then
	if GetCastName(myHero,_R) == "LucianR" then
		local RPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),3500, 250, 1500, 75, true, false)
		if RPred.HitChance == 1 then
			CastSkillShot(_R, RPred.PredPos.x, RPred.PredPos.y, RPred.PredPos.z)
		end
	elseif GetCastName(myHero,_R) ~= "LucianR" and ValidTarget(target, 1300) then
		--------------
		local pos1 = GetOrigin(target)
		
		local Ticker1 = GetTickCount()
		if (global_ticks1 + 50) < Ticker1 then
			DelayAction(function ()
				local pos2 = GetOrigin(target)	
				local luciMoveRPos = myHeroPos + ((VectorWay(pos1,pos2))/GetDistance(pos1,pos2))*100
				-- DrawCircle(luciMoveRPos,50,0,mainMenu.Drawings.Quality:Value(),0xffffffff)
				MoveToXYZ(luciMoveRPos)
			end , 50) 
			global_ticks1 = Ticker1
		end	
		--------------
	end
end

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
--COMBO----------------------
-----------------------------
if GetDistance(myHero,GetMousePos()) > 425 then
	mouse = myHeroPos + (VectorWay(myHeroPos, GetMousePos())/GetDistance(myHero,GetMousePos()))*425
else
	mouse = GetMousePos()
end

if CanUseSpell(myHero,_E) == READY and ValidTarget(target, 750 + myHitBox) and GetDistance(mouse, target) < 500 + myHitBox and EnemiesAround(myHeroPos,500 + myHitBox) <= EnemiesAround(mouse,500 + myHitBox) and mainMenu.Combo.useE:Value() and Passive == 0 then
	CastSkillShot(_E, mouse)
elseif CanUseSpell(myHero,_E) == READY and ValidTarget(target, 750 + myHitBox) and IsInDistance(target, 550 + myHitBox) and GetDistance(mouse, target) < 550 + myHitBox and EnemiesAround(myHeroPos,500 + myHitBox) <= EnemiesAround(mouse,500 + myHitBox) and mainMenu.Combo.useE:Value() and Passive == 0 and atk == false then
	CastSkillShot(_E, mouse)
end

if CanUseSpell(myHero,_Q) == READY and ValidTarget(target, 1100) and GetDistance(myHero, target) > GetRange(myHero) + myHitBox + 100 and mainMenu.Combo.useQ:Value() and mainMenu.Combo.useQex:Value() then
		local QPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),math.huge,350,1100,50,false,false)
		if QPred.HitChance == 1 then
		
		local checkPos1 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*650
		local checkPos2 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*600
		local checkPos3 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*550
		local checkPos4 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*500
		local checkPos5 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*450
		local checkPos6 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*400
		local checkPos7 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*350
		local checkPos8 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*300
		local checkPos9 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*250
		local checkPos10 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*200
		local checkPos11 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*150
				
		for i,minion in pairs(minionManager.objects) do
			if MINION_ENEMY == GetTeam(minion) then
				if ValidTarget(minion, 650) and GetDistance(checkPos1, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
				if ValidTarget(minion, 650) and GetDistance(checkPos2, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
				if ValidTarget(minion, 650) and GetDistance(checkPos3, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
				if ValidTarget(minion, 650) and GetDistance(checkPos4, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
				if ValidTarget(minion, 650) and GetDistance(checkPos5, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
				if ValidTarget(minion, 650) and GetDistance(checkPos6, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
				if ValidTarget(minion, 650) and GetDistance(checkPos7, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
				if ValidTarget(minion, 650) and GetDistance(checkPos8, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
				if ValidTarget(minion, 650) and GetDistance(checkPos9, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
				if ValidTarget(minion, 650) and GetDistance(checkPos10, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
				if ValidTarget(minion, 650) and GetDistance(checkPos11, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
			end
		end
		
		
		end

end

if CanUseSpell(myHero,_R) == READY and GetCastName(myHero,_R) == "LucianR" and mainMenu.Combo.useR:Value() and ValidTarget(target, 1500) and not IsInDistance(target, 900) and GetCurrentHP(target)+GetDmgShield(target) < CalcDamage(myHero,target,(10*GetCastLevel(myHero,_Q)+30+(0.25*GetBonusDmg(myHero))+(0.15*GetBonusAP(myHero))),0)*(5*GetCastLevel(myHero,_R)+8) then --15 real
	local RPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),3500, 250, 1500, 75, true, false)
	if RPred.HitChance == 1 then
		CastSkillShot(_R, RPred.PredPos.x, RPred.PredPos.y, RPred.PredPos.z)
	end
elseif CanUseSpell(myHero,_R) == READY and GetCastName(myHero,_R) ~= "LucianR" and IsInDistance(target, GetRange(myHero)+myHitBox) and mainMenu.Combo.useR:Value() then
	CastSpell(_R)
end

end -- Combo

--HARASS----------
------------------
if mainMenu.Harass.Harass1:Value() then

if GetDistance(myHero,GetMousePos()) > 425 then
	mouse = myHeroPos + (VectorWay(myHeroPos, GetMousePos())/GetDistance(myHero,GetMousePos()))*425
else
	mouse = GetMousePos()
end

if CanUseSpell(myHero,_Q) == READY and ValidTarget(target, 1100) and GetDistance(myHero, target) > GetRange(myHero) + myHitBox + 100 and mainMenu.Harass.useQ:Value() and mainMenu.Harass.useQex:Value() and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= mainMenu.Harass.manaQex:Value() then
		local QPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),math.huge,350,1100,50,false,false)
		if QPred.HitChance == 1 then
		
		local checkPos1 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*650
		local checkPos2 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*600
		local checkPos3 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*550
		local checkPos4 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*500
		local checkPos5 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*450
		local checkPos6 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*400
		local checkPos7 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*350
		local checkPos8 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*300
		local checkPos9 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*250
		local checkPos10 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*200
		local checkPos11 = myHeroPos + ((VectorWay(myHeroPos, QPred.PredPos))/GetDistance(myHeroPos,QPred.PredPos))*150
				
		for i,minion in pairs(minionManager.objects) do
			if MINION_ENEMY == GetTeam(minion) then
				if ValidTarget(minion, 650) and GetDistance(checkPos1, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
				if ValidTarget(minion, 650) and GetDistance(checkPos2, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
				if ValidTarget(minion, 650) and GetDistance(checkPos3, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
				if ValidTarget(minion, 650) and GetDistance(checkPos4, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
				if ValidTarget(minion, 650) and GetDistance(checkPos5, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
				if ValidTarget(minion, 650) and GetDistance(checkPos6, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
				if ValidTarget(minion, 650) and GetDistance(checkPos7, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
				if ValidTarget(minion, 650) and GetDistance(checkPos8, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
				if ValidTarget(minion, 650) and GetDistance(checkPos9, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
				if ValidTarget(minion, 650) and GetDistance(checkPos10, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
				if ValidTarget(minion, 650) and GetDistance(checkPos11, minion) < 25 then
					CastTargetSpell(minion,_Q)
				end
			end
		end
		
		
		end
		
end

if mainMenu.Harass.useW:Value() and CanUseSpell(myHero,_W) == READY and Passive == 0 and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= mainMenu.Harass.manaW:Value() and ValidTarget(target, 1000) then
	local WPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target),2000, 150, 1000, 50, true, true)
	if WPred.HitChance == 1 then
		CastSkillShot(_W, WPred.PredPos.x, WPred.PredPos.y, WPred.PredPos.z)
	end
end

if CanUseSpell(myHero,_E) == READY and ValidTarget(target, 750 + myHitBox) and GetDistance(mouse, target) < 500 + myHitBox and mainMenu.Harass.useE:Value() and Passive == 0 and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= mainMenu.Harass.manaE:Value() then
	CastSkillShot(_E, mouse)
elseif CanUseSpell(myHero,_E) == READY and ValidTarget(target, 750 + myHitBox) and IsInDistance(target, 550 + myHitBox) and GetDistance(mouse, target) < 550 + myHitBox and mainMenu.Harass.useE:Value() and Passive == 0 and atk == false and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= mainMenu.Harass.manaE:Value() then
	CastSkillShot(_E, mouse)
end

end -- Harass


end)

OnDraw(function(myHero)

	if mainMenu.Drawings.DrawDMG:Value() then
	local target = GetCurrentTarget()
		if ValidTarget(target, 2000) and DPS ~= nil then
			DrawDmgOverHpBar(target,GetCurrentHP(target),DPS,0,0xffffffff)
		end
	end
	
	if mainMenu.Drawings.DrawQex:Value() then
		DrawCircle(GetOrigin(myHero),1100,0,mainMenu.Drawings.Quality:Value(),0xffffffff)
	end
end)

function VectorWay(A,B)
WayX = B.x - A.x
WayY = B.y - A.y
WayZ = B.z - A.z
return Vector(WayX, WayY, WayZ)
end
