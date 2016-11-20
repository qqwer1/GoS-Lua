-- qwerKatarina
local mainMenu = Menu("qwerKata", "qwerKatarina")
mainMenu:Key("Combo1", "Start QWER", string.byte(" "))

local dagger = {}
local resetAble = {}
local animationCancel = {}
local kataCounter = 0
local kataR = false

OnProcessSpell(function(unit,spell)
	if unit == myHero and spell.name == "KatarinaR" then
		kataR = true
	end
end)

OnUpdateBuff(function(unit,buff)
	if unit == myHero and buff.Name == "katarinarsound" then
		kataR = true
	end
end)

OnRemoveBuff(function(unit,buff)
	if unit == myHero and buff.Name == "katarinarsound" then
		kataR = false
	end
end)

OnIssueOrder(function(orderProc)
	if (orderProc.flag == 2 or orderProc.flag == 3) and kataR == true and ValidTarget(GetCurrentTarget(),550) and mainMenu.Combo1:Value() then
		BlockOrder()
	end
end)

OnSpellCast(function(castProc)
	if kataR == true and castProc.spellID == 1 then
		BlockCast()
	end
end)

OnCreateObj(function(o)
	if GetDistance(o) < 2000 then
		if GetObjectBaseName(o) == "Katarina_Base_W_Indicator_Ally.troy" then
			table.insert(dagger, o)
			DelayAction(function()
				table.insert(resetAble, o)
				DelayAction(function()
					table.insert(animationCancel, o)
					DelayAction(function()
						for i,v in pairs(animationCancel) do
							if GetNetworkID(v) == GetNetworkID(o) then
								table.remove(animationCancel,i)
							end
						end
					end,0.03)
				end,03771)
			end,1)
		end
	end
end)

OnDeleteObj(function(o)
	if GetObjectBaseName(o) == "Katarina_Base_W_Indicator_Ally.troy" then
		for i,v in pairs(dagger) do
			if GetNetworkID(v) == GetNetworkID(o) then
				table.remove(dagger,i)
			end
		end
		for i,v in pairs(resetAble) do
			if GetNetworkID(v) == GetNetworkID(o) then
				table.remove(resetAble,i)
			end
		end
	end
end)

OnTick(function()
	if mainMenu.Combo1:Value() then
		local target = GetCurrentTarget()
		if ValidTarget(target,1600) then
			if GetDistance(target) < 750 and CanUseSpell(myHero,0) == READY then
				CastTargetSpell(target,0)
			end
			if GetDistance(target) < 200 and CanUseSpell(myHero,1) == READY then
				CastSpell(1)
			end
			if CanUseSpell(myHero,2) == READY then
				for i,v in pairs(animationCancel) do
					if GetDistance(v) < 170 and GetDistance(target) < 1000 then
						CastSkillShot(2,GetOrigin(target))
					end
				end
				for i,v in pairs(resetAble) do
					if GetDistance(target,v) < 350 and GetDistance(v) < 1200 then
						CastSkillShot(2,GetOrigin(target) + (VectorWay(GetOrigin(target),GetOrigin(v))):normalized()*math.random(100,150))
					elseif GetDistance(target,v) < 200 and GetDistance(target) < 1000 then
						CastSkillShot(2,GetOrigin(target))
					end
				end
				if GetCurrentHP(target) < CalcDamage(myHero,target,(GetBaseDamage(myHero)+GetBonusDmg(myHero)),15+15*GetCastLevel(myHero,2) + (GetBaseDamage(myHero)+GetBonusDmg(myHero))*0.65 + GetBonusAP(myHero)*0.25) then
					CastSkillShot(2,GetOrigin(target))
				end
				local heheTicker = GetTickCount()
				if (kataCounter + 150) < heheTicker then
					local qdmg = 0
					local edmg = CalcDamage(myHero,target,0,15+15*GetCastLevel(myHero,2) + (GetBaseDamage(myHero)+GetBonusDmg(myHero))*0.65 + GetBonusAP(myHero)*0.25)
					local rdmg = 0
					local passivedmg = 0
					if CanUseSpell(myHero,3) == READY then
						qdmg = CalcDamage(myHero,target,0,45+30*GetCastLevel(myHero,0) + GetBonusAP(myHero)*0.30)
					end
					if CanUseSpell(myHero,3) == READY then
						rdmg = CalcDamage(myHero,target,0,12.5+12.5*GetCastLevel(myHero,3) + GetBonusDmg(myHero)*0.22 + GetBonusAP(myHero)*0.20) * (150/GetMoveSpeed(target))/0.166
					end
					local dps = qdmg + edmg + rdmg
					if GetCurrentHP(target) < dps then
						if GetDistance(target) > 1200 then
							for i,v in pairs(resetAble) do
								if GetDistance(v) < 1000 and GetDistance(v) > 300 and GetDistance(v,target) < 800 then
									CastSkillShot(2,GetOrigin(v))
								end
							end
						elseif GetDistance(target) < 1000 then
							CastSkillShot(2,GetOrigin(target))
						end
					end
					kataCounter = heheTicker
				end
			end
			if CanUseSpell(myHero,3) == READY and ValidTarget(target,550) and CanUseSpell(myHero,0) == ONCOOLDOWN and CanUseSpell(myHero,2) == ONCOOLDOWN and CanUseSpell(myHero,1) == ONCOOLDOWN then
				local rdmg = CalcDamage(myHero,target,0,12.5+12.5*GetCastLevel(myHero,3) + GetBonusDmg(myHero)*0.22 + GetBonusAP(myHero)*0.20) * ((550-GetDistance(target))/GetMoveSpeed(target))/0.166
				-- print(rdmg)
				if GetCurrentHP(target) < rdmg then
					local cast = true
					for i,v in pairs(resetAble) do
						if GetDistance(v,target) < 250 and GetDistance(v) < 250 then
							cast = false
						end
					end
					if cast == true then
						CastSpell(3)
					end
				end
			end
		end
	end
end)

function VectorWay(A,B)
WayX = B.x - A.x
WayY = B.y - A.y
WayZ = B.z - A.z
return Vector(WayX, WayY, WayZ)
end
