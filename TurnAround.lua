if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua!") return end

local turnMenu = Menu("TurnAround", "Turn")
turnMenu:Boolean("trynW", "Tryndamere W", true)
turnMenu:Boolean("cassR", "Cassiopea R", true)

TURN = {
["CassiopeiaPetrifyingGaze"]	= 	{ champName = "Cassiopeia" , spellDelay = 500	, spellRange = 825	, spellRadius = 150	},
["MockingShout"]				= 	{ champName = "Tryndamere" , spellDelay = 250	, spellRange = 450 },
}

OnProcessSpell(function(unit,spell)

local TurnSpell = TURN[spell.name]

if TurnSpell then
	if TurnSpell.champName == GetObjectName(unit) and GetTeam(unit) ~= GetTeam(myHero) and GetObjectType(unit) == Obj_AI_Hero and IsInDistance(unit, TurnSpell.spellRange) then
		if spell.name == "MockingShout" and turnMenu.trynW:Value() then
			-- PrintChat("Tryn")
			DelayAction(function()
				MoveToXYZ(GetOrigin(unit))
			end,TurnSpell.spellDelay -1)
		end
		if spell.name == "CassiopeiaPetrifyingGaze" and turnMenu.cassR:Value() then
			-- PrintChat("Cass")
			local myPos = GetOrigin(myHero)
			local cassPos = GetOrigin(unit)
			local vx = cassPos.x - myPos.x
			local vy = cassPos.y - myPos.y
			local vz = cassPos.z - myPos.z
			local AB = Vector(vx,vy,vz)
			local movePos = myPos - AB*1.2
			DelayAction(function()
				MoveToXYZ(movePos)
			end, TurnSpell.spellDelay -1)
		end
	end
end
end)
