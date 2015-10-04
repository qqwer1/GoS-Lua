OnProcessSpell(function(unit, spellProc)
	if mainMenu.AutoE.CC:Value() then

local CCSpell = CC[GetObjectName(unit)]
----------------------------------------
-- TEST CODE:
if CCSpell ~= nil then
	for t,CCSpells in pairs(CCSpell) do
		if CanUseSpell(myHero,_E) == READY and GetTeam(unit) ~= GetTeam(myHero) and GetObjectType(unit) == Obj_AI_Hero and not spellProc.name:lower():find("attack") then
-- Target
			if spellProc.target == myHero and spellProc.name == CCSpell.spellName and CCSpell.spellType == "target" then
				CastSpell(_E)
				PrintChat"solo"
			elseif spellProc.target == myHero and spellProc.name == CCSpells.spellName and CCSpells.spellType == "target" then
				CastSpell(_E)
				PrintChat"multi"
			end
-- Line			
			if CCSpell.spellType == "line" and spellProc.name == CCSpell.spellName and GoS:IsInDistance(unit, CCSpell.spellRange + 300) then
			local SkillPred = GetPredictionForPlayer(GetOrigin(unit),GetMyHero(),GetMoveSpeed(GetMyHero()),CCSpell.projectileSpeed,CCSpell.spellDelay,CCSpell.spellRange,CCSpell.spellRadius,CCSpell.collision,false)
				if SkillPred.HitChance == 1 then
					CastSpell(_E)
					PrintChat"Solo"
				end
			elseif CCSpells.spellType == "line" and spellProc.name == CCSpells.spellName and GoS:IsInDistance(unit, CCSpells.spellRange + 300) then
			local SkillPred = GetPredictionForPlayer(GetOrigin(unit),GetMyHero(),GetMoveSpeed(GetMyHero()),CCSpells.projectileSpeed,CCSpells.spellDelay,CCSpells.spellRange,CCSpells.spellRadius,CCSpells.collision,false)
				if SkillPred.HitChance == 1 then
					CastSpell(_E)
					PrintChat"milti"
				end
			end
-- Circular
			if CCSpell.spellType == "circular" and spellProc.name == CCSpell.spellName and GoS:IsInDistance(unit, CCSpell.spellRange + 300) then
			local SkillPred = GetPredictionForPlayer(GetOrigin(unit),GetMyHero(),GetMoveSpeed(GetMyHero()),CCSpell.projectileSpeed,CCSpell.spellDelay,CCSpell.spellRange,CCSpell.spellRadius,CCSpell.collision,false)
				if SkillPred.HitChance == 1 then
					CastSpell(_E)
					PrintChat"Solo"
				end
			elseif CCSpells.spellType == "circular" and spellProc.name == CCSpells.spellName and GoS:IsInDistance(unit, CCSpells.spellRange + 300) then
			local SkillPred = GetPredictionForPlayer(GetOrigin(unit),GetMyHero(),GetMoveSpeed(GetMyHero()),CCSpells.projectileSpeed,CCSpells.spellDelay,CCSpells.spellRange,CCSpells.spellRadius,CCSpells.collision,false)
				if SkillPred.HitChance == 1 then
					CastSpell(_E)
					PrintChat"multi"
				end
			end			
-- AOE
			if CCSpell.spellType == "aoe" and spellProc.name == CCSpell.spellName and GoS:IsInDistance(unit, CCSpell.spellRange) then
				CastSpell(_E)
				PrintChat"solo"
			elseif CCSpells.spellType == "aoe" and spellProc.name == CCSpells.spellName and GoS:IsInDistance(unit, CCSpells.spellRange) then
				CastSpell(_E)
				PrintChat"multi"
			end				
		end
	end
end
---------------------------------------	

			-- if CCSpell then

				-- if CanUseSpell(myHero,_E) == READY and GetTeam(unit) ~= GetTeam(myHero) and GetObjectType(unit) == Obj_AI_Hero then
					-- if spellProc.target == myHero and spellProc.name == CC[GetObjectName(unit)].spellName and CC[GetObjectName(unit)].spellType == "target" then
						-- CastSpell(_E)
					-- end
					-- if CC[GetObjectName(unit)].spellType == "line" and spellProc.name == CC[GetObjectName(unit)].spellName and GoS:IsInDistance(unit, CC[GetObjectName(unit)].spellRange) then
						-- PrintChat"!"
						-- PrintChat("x: "..CC[GetObjectName(unit)].spellName)
						-- local SkillPred = GetPredictionForPlayer(GetOrigin(unit),GetMyHero(),GetMoveSpeed(GetMyHero()),CC[GetObjectName(unit)].projectileSpeed,CC[GetObjectName(unit)].spellDelay,CC[GetObjectName(unit)].spellRange,CC[GetObjectName(unit)].spellRadius,CC[GetObjectName(unit)].collision,false)
							-- if SkillPred.HitChance == 1 then
								-- CastSpell(_E)
								-- PrintChat"Its working!"
							-- end
					-- end
					-- if CC[GetObjectName(unit)].spellType == "circular" and spellProc.name == CC[GetObjectName(unit)].spellName and GoS:IsInDistance(unit, CC[GetObjectName(unit)].spellRange) then
						-- PrintChat"!"
						-- PrintChat("x: "..CC[GetObjectName(unit)].spellName)
						-- local SkillPred = GetPredictionForPlayer(GetOrigin(unit),GetMyHero(),GetMoveSpeed(GetMyHero()),CC[GetObjectName(unit)].projectileSpeed,CC[GetObjectName(unit)].spellDelay,CC[GetObjectName(unit)].spellRange,CC[GetObjectName(unit)].spellRadius,CC[GetObjectName(unit)].collision,false)
							-- if SkillPred.HitChance == 1 then
								-- CastSpell(_E)
								-- PrintChat"Its working! Circular"
							-- end
					-- end					
					-- if CC[GetObjectName(unit)].spellType == "aoe" and spellProc.name == CC[GetObjectName(unit)].spellName and GoS:IsInDistance(unit, CC[GetObjectName(unit)].spellRange) then
						-- CastSpell(_E)
					-- end
				-- end
			-- end
	
	end
end)
