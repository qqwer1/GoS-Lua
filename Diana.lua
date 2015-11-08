if GetObjectName(GetMyHero()) ~= "Diana" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua!") return end

local mainMenu = Menu("Diana", "Diana")
mainMenu:Menu("Combo", "Combo")
mainMenu.Combo:Boolean("useQ", "Use Q  in combo", true)
mainMenu.Combo:Boolean("useW", "Use W in combo", true)
mainMenu.Combo:Boolean("useE", "Use E in combo", true)
mainMenu.Combo:Boolean("useR", "Use R in combo", true)
-- mainMenu.Combo:Boolean("useRQ", "Use R-Q Combo", true)
mainMenu.Combo:Boolean("Burst", "Burst them down", true)
mainMenu.Combo:Boolean("minionJumper", "What a nice minion there", true)
mainMenu.Combo:Boolean("freeELO", "Free ELO ?", true)
mainMenu.Combo:Key("Combo1", "Combo key", string.byte(" "))
------------------------
mainMenu:Menu("Harass", "Harass")
mainMenu.Harass:Boolean("useQ", "Use Q", true)
mainMenu.Harass:Slider("qMana","Q: Mana-Manager", 60, 1, 100, 1)
mainMenu.Harass:Boolean("useW", "Use W", true)
mainMenu.Harass:Slider("wMana","W: Mana-Manager", 40, 1, 100, 1)
mainMenu.Harass:Key("Harass1", "Harass key", string.byte("C"))
------------------------
mainMenu:Menu("Flee", "Flee")
mainMenu.Flee:Boolean("useFlee", "You want to flee ?", true)
mainMenu.Flee:Boolean("drawChecker", "Draw the Check-Circle", true)
mainMenu.Flee:Slider("checkRange","Minion Check Range (mouse)", 300, 1, 600, 1)
mainMenu.Flee:Key("Flee1", "Flee key", string.byte("A"))
-----------------------
mainMenu:Menu("Jungle", "Jungle Clear")
mainMenu.Jungle:Boolean("useQ", "Use Q", true)
mainMenu.Jungle:Boolean("useW", "Use W", true)
mainMenu.Jungle:Key("Jungle1", "Jungle clear key", string.byte("V"))


OnProcessSpell(function(Object,spell)
if Object == myHero then
-- RQ # RIP
if spell.name == "DianaTeleport" and spell.target == GetCurrentTarget() then

if mainMenu.Combo.useW:Value() and CanUseSpell(myHero,_W) == READY then
	CastSpell(_W)
end

rCast = true
if rCast == true then
	DelayAction(function()
		rCast = false
	end, 1000)
end

end

if spell.name == "DianaArc" then
	qEnd = spell.endPos
	willHit = GetDistance(myHero,qEnd)/1500
	-- local target = GetCurrentTarget()
if mainMenu.Combo.freeELO:Value() then
	DelayAction(function()
		if ValidTarget(target, 1500) and target ~= nil and GetDistance(qEnd, target) < 160 and qEnd ~= nil and mainMenu.Combo.useR:Value() and mainMenu.Combo.Combo1:Value() and GetCurrentHP(target) > CalcDamage(myHero, target, 0, (35*GetCastLevel(myHero,_Q)+25+(0.7*(GetBonusAP(myHero))))) then
			CastTargetSpell(target,_R)
		end
	end, willHit*1000 - 50)
	
end
	DelayAction(function()
		qEnd = nil
	end, willHit*1000 + 500)

end


end
end)

OnProcessSpellComplete(function(Object,spell)
if Object == myHero and spell.name:lower():find("attack") then
ASDelay = 1/(baseAS*GetAttackSpeed(myHero))
atk = false
-- PrintChat(spell.windUpTime)
DelayAction(function()
	atk = true
end, ASDelay*1000- spell.windUpTime*1000)
end
end)

passive = false
ludenStacks = 0
lichDMG = 0
baseAS = GetBaseAttackSpeed(myHero)
atk = true

OnUpdateBuff(function(Object,buffProc)
if Object == myHero then
if buffProc.Name == "dianaarcready" then
passiveDMG = (({[1]=20,[2]=25,[3]=30,[4]=35,[5]=40,[6]=50,[7]=60,[8]=70,[9]=80,[10]=90,[11]=105,[12]=120,[13]=135,[14]=155,[15]=175,[16]=200,[17]=225,[18]=250})[GetLevel(myHero)])
passive = true
end
if buffProc.Name == "itemmagicshankcharge" then
	ludenStacks = buffProc.Count
end
end
end)

OnRemoveBuff(function(Object,buffProc)
if Object == myHero then
if buffProc.Name == "dianaarcready" then
passive = false
end
if buffProc.Name == "itemmagicshankcharge" then
	ludenStacks = 0
end
end
end)

local ts = TargetSelector(1200, 3, DAMAGE_MAGICAL)

OnTick(function(myHero)

target = ts:GetTarget()
local myHeroPos = GetOrigin(myHero)

local Sheen = GetItemSlot(myHero,3057)
local lichbane = GetItemSlot(myHero,3100)
local lila = GetItemSlot(myHero,3724)
local blau = GetItemSlot(myHero,3708)
local rot = GetItemSlot(myHero,3716)
local weiss = GetItemSlot(myHero,3720)

-- DMG Calcs
if ValidTarget(target, 1400) then

if lila > 0 and CanUseSpell(myHero,lila) == READY and atk == true then
	jiDMG = CalcDamage(myHero,target,0, GetBaseDamage(myHero) + 0.3*GetBonusAP(myHero))
else jiDMG = 0 end

if blau > 0 and CanUseSpell(myHero,blau) == READY and atk == true then
	jiDMG = CalcDamage(myHero,target,0, GetBaseDamage(myHero) + 0.3*GetBonusAP(myHero)) 
else jiDMG = 0 end

if rot > 0 and CanUseSpell(myHero,rot) == READY and atk == true then
	jiDMG = CalcDamage(myHero,target,0, GetBaseDamage(myHero) + 0.3*GetBonusAP(myHero)) 
else jiDMG = 0 end

if weiss > 0 and CanUseSpell(myHero,weiss) == READY and atk == true then
	jiDMG = CalcDamage(myHero,target,0, GetBaseDamage(myHero) + 0.3*GetBonusAP(myHero)) 
else jiDMG = 0 end

if Sheen > 0 and CanUseSpell(myHero,Sheen) == READY and atk == true then
	sheenDMG = CalcDamage(myHero,target,0, GetBaseDamage(myHero)) 
else sheenDMG = 0 end

if lichbane > 0 and CanUseSpell(myHero,lichbane) == 8 and atk == true then
	lichDMG = CalcDamage(myHero,target,0, (0.75*GetBaseDamage(myHero))+0.5*GetBonusAP(myHero) )
else lichDMG = 0 end

if passive == true and atk == true then
	pasDMG = CalcDamage(myHero,target, 0, passiveDMG + 0.8*GetBonusAP(myHero))
else pasDMG = 0 end

if ludenStacks ~= nil and ludenStacks > 90 then
	ludenDMG = CalcDamage(myHero,target,0,100+0.1*GetBonusAP(myHero))
else ludenDMG = 0 end

if CanUseSpell(myHero,_Q) == READY then
	qDMG = CalcDamage(myHero, target, 0, (35*GetCastLevel(myHero,_Q)+25+(0.7*(GetBonusAP(myHero)))))
else qDMG = 0 end
if CanUseSpell(myHero,_W) == READY then
	wDMG = CalcDamage(myHero, target, 0, (36*GetCastLevel(myHero,_W)+30+(0.6*(GetBonusAP(myHero)))))
else wDMG = 0 end
if CanUseSpell(myHero,_R) == READY then
	rDMG = CalcDamage(myHero, target, 0, (60*GetCastLevel(myHero,_R)+40+(0.6*(GetBonusAP(myHero)))))
else rDMG = 0 end

if atk == true then
	AA = CalcDamage(myHero,target,GetBaseDamage(myHero)+GetBonusDmg(myHero),0)
else AA = 0 end

fullDMG = pasDMG + ludenDMG + lichDMG + sheenDMG + jiDMG + qDMG + wDMG +rDMG + AA

end

-- Combo
if mainMenu.Combo.Combo1:Value() and ValidTarget(target,1500) then

if QMax ~= nil and mainMenu.Combo.useR:Value() and CanUseSpell(myHero,_R) == READY and mainMenu.Combo.freeELO:Value() then
	CastTargetSpell(target,_R)
end

	if CanUseSpell(myHero,_R) == READY and ValidTarget(target,825) and GotBuff(target,"dianamoonlight") >= 1 and mainMenu.Combo.useR:Value() then
		CastTargetSpell(target,_R)
	end

	
-- Q
	if CanUseSpell(myHero,_Q) == READY and ValidTarget(target,830) and mainMenu.Combo.useQ:Value() then
		local distance = GetDistance(myHeroPos,target)
		if distance <= 150 then
			QMax = myHeroPos + (VectorWay(myHeroPos,GetOrigin(target))/distance)*1000
			CastSkillShot(_Q,QMax)
				DelayAction(function()
					QMax = nil
				end, 300)
		else
			local QPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1670, 250, 830, 150, false, true)
			if QPred.HitChance == 1 then
				CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
			end
		end
	end

-- Burst	
	if mainMenu.Combo.Burst:Value() and CanUseSpell(myHero,_R) == READY then
	local QPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1670, 250, 830, 150, false, true)
		if CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_W) == READY and ValidTarget(target,900) and QPred.HitChance == 0 and GetCurrentHP(target) < fullDMG then
			CastTargetSpell(target,_R)
			DelayAction(function()
				if rCast == true then
					local QPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1670, 250, 830, 150, false, true)
					CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
				end
			end, 50)
		end
		if CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_W) ~= READY and ValidTarget(target,900) and QPred.HitChance == 0 and GetCurrentHP(target) < fullDMG then
			CastTargetSpell(target,_R)
			DelayAction(function()
				if rCast == true then
					local QPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1670, 250, 830, 150, false, true)
					CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
				end
			end, 50)
		end
		if CanUseSpell(myHero,_Q) ~= READY and CanUseSpell(myHero,_W) == READY and ValidTarget(target,900) and GetCurrentHP(target) < fullDMG then
			CastTargetSpell(target,_R)
		end
		if CanUseSpell(myHero,_Q) ~= READY and CanUseSpell(myHero,_W) ~= READY and ValidTarget(target,900) and GetCurrentHP(target) < fullDMG then
			CastTargetSpell(target,_R)
		end
		
		-- OP SHIT RIGHT HERE KappaRoss
-------------
		if mainMenu.Combo.minionJumper:Value() then
		if CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_R) == READY and CanUseSpell(myHero,_W) == READY and EnemiesAround(GetOrigin(target),700) < 3 and GetCurrentHP(target) < (rDMG+wDMG+pasDMG+lichDMG+sheenDMG+CalcDamage(myHero,target,GetBaseDamage(myHero)+GetBonusDmg(myHero),0)) then
			for i,minion in pairs(minionManager.objects) do
				if MINION_ENEMY == GetTeam(minion) then
					if IsInDistance(minion, 825) and not IsInDistance(minion, 500) and not IsInDistance(target, 825+GetHitBox(target)) and GetDistance(minion,target) < 800 - GetMoveSpeed(target)/2 and GetCurrentHP(minion) > (CalcDamage(myHero, minion, 0, (35*GetCastLevel(myHero,_Q)+25+(0.7*(GetBonusAP(myHero)))))+ludenDMG) then
						if CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_R) == READY then
						-- DrawCircle(GetOrigin(minion), 100,1,255,0xff0ffff0)
						CastSkillShot(_Q,GetOrigin(minion))
						if qEnd ~= nil then
						-- DrawCircle(qEnd, 160,1,255,0xff0ffff0)
							DelayAction(function()
								if GetDistance(qEnd,GetOrigin(minion)) < 160 then
								CastTargetSpell(minion,_R)
								-- PrintChat"CastR"
								end
							end,willHit*1000 - 350 )
						end
						end
					end
				end
			end	
		end -- RQRW
-------------
		if CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_R) == READY and CanUseSpell(myHero,_W) ~= READY and EnemiesAround(GetOrigin(target),700) < 3 and GetCurrentHP(target) < (rDMG+wDMG+pasDMG+lichDMG+sheenDMG+CalcDamage(myHero,target,GetBaseDamage(myHero)+GetBonusDmg(myHero),0)) then
			for i,minion in pairs(minionManager.objects) do
				if MINION_ENEMY == GetTeam(minion) then
					if IsInDistance(minion, 825) and not IsInDistance(minion, 500) and not IsInDistance(target, 825+GetHitBox(target)) and GetDistance(minion,target) < 800 - GetMoveSpeed(target)/2 and GetCurrentHP(minion) > (CalcDamage(myHero, minion, 0, (35*GetCastLevel(myHero,_Q)+25+(0.7*(GetBonusAP(myHero)))))+ludenDMG) then
						if CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_R) == READY then
						-- DrawCircle(GetOrigin(minion), 100,1,255,0xff0ffff0)
						CastSkillShot(_Q,GetOrigin(minion))
						if qEnd ~= nil then
						-- DrawCircle(qEnd, 160,1,255,0xff0ffff0)
							DelayAction(function()
								if GetDistance(qEnd,GetOrigin(minion)) < 160 then
								CastTargetSpell(minion,_R)
								-- PrintChat"CastRW"
								end
							end,willHit*1000 - 350 )
						end
						end
					end
				end
			end	
		end -- RQR
-------------		
		if CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_R) == READY and GetCurrentHP(target) < qDMG then
			for i,minion in pairs(minionManager.objects) do
				if MINION_ENEMY == GetTeam(minion) then
					if ValidTarget(minion, 825) and not IsInDistance(target, 825) and GetDistance(minion,target) < 750 then
						validMinion = GetOrigin(minion)
						local QPredMinion = GetPredictionForPlayer(validMinion, target, GetMoveSpeed(target),1670, 250 + (GetDistance(myHeroPos,validMinion)/1800)*1000 - 100 , 830, 150, false, true)
						if QPredMinion.HitChance == 1 then
						CastTargetSpell(minion,_R)
							DelayAction(function()
								if rCast == true then
									CastSkillShot(_Q,QPredMinion.PredPos.x,QPredMinion.PredPos.y,QPredMinion.PredPos.z)
									-- PrintChat("CastQ!")
								end
							end,(GetDistance(myHeroPos,validMinion)/1800)*1000 - 100 )
						end
					end
				end
			end	
		end -- RQ
		
		end
		
	end
	
	if mainMenu.Combo.useW:Value() and GetDistance(myHero,target) < 200+GetHitBox(target) then
		CastSpell(_W)
	end
	
	if CanUseSpell(myHero, _E) == READY and not IsInDistance(target, 150+GetHitBox(target)) and IsInDistance(target, 345+GetHitBox(target)/2) and mainMenu.Combo.useE:Value() then
		CastSpell(_E)
	end
	
end

if mainMenu.Harass.Harass1:Value() and ValidTarget(target, 900) then
	if mainMenu.Harass.useQ:Value()  and CanUseSpell(myHero,_Q) == READY and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= mainMenu.Harass.qMana:Value() then
	local QPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1670, 250, 830, 150, false, true)
		if QPred.HitChance == 1 then
			CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
		end
	end
	if mainMenu.Harass.useW:Value() and CanUseSpell(myHero,_W) == READY and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= mainMenu.Harass.wMana:Value() and GetDistance(myHero,target) < 200+GetHitBox(target) then
		CastSpell(_W)
	end
end

if mainMenu.Flee.Flee1:Value() and mainMenu.Flee.useFlee:Value() then
	if CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_R) == READY and GetCurrentMana(myHero) > GetCastMana(myHero,_Q,GetCastLevel(myHero,_Q)) + GetCastMana(myHero,_R,GetCastLevel(myHero,_R)) then
		for i,minion in pairs(minionManager.objects) do
			if MINION_ENEMY == GetTeam(minion) then
				if minion ~= nil and GetDistance(myHero, minion) > 500 and GetDistance(myHero,minion) < 825 and GetDistance(GetMousePos(), GetOrigin(minion)) < mainMenu.Flee.checkRange:Value() and GetCurrentHP(minion) > CalcDamage(myHero, minion, 0, (35*GetCastLevel(myHero,_Q)+25+(0.7*(GetBonusAP(myHero)))))+5 then
					CastSkillShot(_Q,GetOrigin(minion))
					if willHit ~= nil then
						DelayAction(function()
							if minion ~= nil and GetDistance(qEnd,GetOrigin(minion)) < 160 then
								CastTargetSpell(minion,_R)
							end
						end, willHit*1000-200)
					end
				end
			end
		end
	end
	if CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_R) == READY and GetCurrentMana(myHero) < GetCastMana(myHero,_Q,GetCastLevel(myHero,_Q)) + GetCastMana(myHero,_R,GetCastLevel(myHero,_R)) and GetCurrentMana(myHero) >= GetCastMana(myHero,_R,GetCastLevel(myHero,_R)) then
		for i,minion in pairs(minionManager.objects) do
			if MINION_ENEMY == GetTeam(minion) then
				if minion ~= nil and GetDistance(myHero, minion) > 500 and GetDistance(myHero,minion) < 825 and GetDistance(GetMousePos(), GetOrigin(minion)) <= mainMenu.Flee.checkRange:Value() then
					CastTargetSpell(minion,_R)
				end
			end
		end
	end
	if CanUseSpell(myHero,_Q) ~= READY and CanUseSpell(myHero,_R) == READY and GetCurrentMana(myHero) >= GetCastMana(myHero,_R,GetCastLevel(myHero,_R)) and qEnd == nil then
	DelayAction(function()
		for i,minion in pairs(minionManager.objects) do
			if MINION_ENEMY == GetTeam(minion) then
				if minion ~= nil and GetDistance(myHero, minion) > 500 and GetDistance(myHero,minion) < 825 and GetDistance(GetMousePos(), GetOrigin(minion)) <= mainMenu.Flee.checkRange:Value() then
					CastTargetSpell(minion,_R)
				end
			end
		end
	end, 200)
	end
	MoveToXYZ(GetMousePos())
end

if mainMenu.Jungle.Jungle1:Value() then
	for i,minion in pairs(minionManager.objects) do
		if MINION_JUNGLE == GetTeam(minion) then
			if ValidTarget(minion, 900) then
				if mainMenu.Jungle.useQ:Value() and CanUseSpell(myHero,_Q) == READY and ValidTarget(minion, 830) then
					CastSkillShot(_Q,GetOrigin(minion))
				end
				if mainMenu.Jungle.useW:Value() and CanUseSpell(myHero,_W) == READY and ValidTarget(minion, 220) then
					CastSpell(_W)
				end
				DrawCircle(GetOrigin(minion), 50,2,100,ARGB(55,5,255,255))
			end
		end
	end
end

end)

OnDraw(function(myHero)
local myHeroPos = GetOrigin(myHero)
-- local target = GetCurrentTarget()

if ValidTarget(target,1400) and fullDMG ~= nil then	
	DrawDmgOverHpBar(target,GetCurrentHP(target),fullDMG,0,0xff00ff00)
end

if mainMenu.Flee.drawChecker:Value() and mainMenu.Flee.Flee1:Value() then
	local mousePos = GetMousePos()
	DrawCircle(mousePos, mainMenu.Flee.checkRange:Value(),2,100,ARGB(55,5,255,255))
end

end)

function VectorWay(A,B)
WayX = B.x - A.x
WayY = B.y - A.y
WayZ = B.z - A.z
return Vector(WayX, WayY, WayZ)
end
