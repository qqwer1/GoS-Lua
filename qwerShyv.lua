-- sick qwerShyv.lua
-- super slow combo
-- will boost you to bronze5
-- auto surrender
-- run it down mid
-- exclusive no jungle clear

local sickMenu = Menu("qwerShyv", "qwerShyv")
      sickMenu:Key("combo", "Just do it", string.byte(" "))
      
OnProcessSpellComplete(function(unit,spell)
	if sickMenu.combo:Value() == true and unit == myHero and spell.name:lower():find("attack") and GetObjectType(spell.target) == Obj_AI_Hero then
    if CanUseSpell(myHero,0) == READY then
      CastSpell(0)
      DelayAction(function()
        AttackUnit(spell.target)
     end, 0.05)
    end
	end
end)

--OnTick(function(myHero)
--  if sickMenu.combo:Value() then
  
  
--  end
--end)
