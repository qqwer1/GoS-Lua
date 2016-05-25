-- sick qwerShyv.lua
-- super slow combo
-- will boost you to bronze5
-- auto surrender
-- run it down mid
-- exclusive no jungle clear
require("OpenPredict")

local shyvE = {delay = .250, speed = 1800, width = 70, range = 950}
local shyvR = {delay = .250, speed = 1800, width = 150, range = 950}

local sickMenu = Menu("qwerShyv", "qwerShyv")
      sickMenu:Key("combo", "Just do it", string.byte(" "))
      
OnProcessSpellComplete(function(unit,spell)
  if sickMenu.combo:Value() == true and unit == myHero and spell.name:lower():find("attack") and GetObjectType(spell.target) == Obj_AI_Hero then
    if CanUseSpell(myHero,0) == READY then
      CastSpell(0)
      DelayAction(function()
        AttackUnit(spell.target)
      end, 0.05)
    else
      local titan = GetItemSlot(myHero,3748)
      local looksLikeHydraToMe
      if GetItemSlot(myHero,3077) > 0 then
        looksLikeHydraToMe = GetItemSlot(myHero,3077)
      elseif GetItemSlot(myHero,3074) > 0 then
        looksLikeHydraToMe = GetItemSlot(myHero,3074)
      end
      if titan > 0 then
        if CanUseSpell(myHero,titan) == READY then
          CastSpell(titan)
          DelayAction(function()
            AttackUnit(spell.target)
          end, 0.05)
        end
      end
      if looksLikeHydraToMe > 0 then
        if CanUseSpell(myHero,looksLikeHydraToMe) == READY then
          CastSpell(looksLikeHydraToMe)
        end
      end
    end
  end
end)

OnTick(function(myHero)
  if sickMenu.combo:Value() then
    local target = GetCurrentTarget()
    local myHitBox = GetHitBox(myHero)
    if GetDistance(target) < 1000+myHitBox and not IsDead(target) then
      if CanUseSpell(myHero,3) == READY and GetDistance(target,GetMousePos()) < GetDistance(target) then
        local rPred = GetLinearAOEPrediction(target,shyvR)
        if rPred and rPred.hitChance >= 0.4 then
          if #rPred:hCollision() >= 2 then
            CastSkillShot(3,rPred.castPos)
          end
        end
      end
      if CanUseSpell(myHero,1) == READY then
        if (ValidTarget(target,400+myHitBox) and GetMoveSpeed(target) < GetMoveSpeed(myHero)*(0.25+0.05*GetCastLevel(myHero,0))) or (ValidTarget(target,162.5+myHitBox)) then
      	  CastSpell(1)
        end
      end
      if CanUseSpell(myHero,2) == READY and ValidTarget(target,600) then
        local ePred = GetPrediction(target,shyvE)
        if ePred and ePred.hitChance >= 0.4 then
        -- im the witch doctor
          if (GetDistance(ePred.castPos) < GetDistance(target)) or (GetMoveSpeed(target) < GetMoveSpeed(myHero)) or (IsInDistance(target,myHitBox+185)) then
            CastSkillShot(2,ePred.castPos)
          end
        end
      end
    end
  end
end)
