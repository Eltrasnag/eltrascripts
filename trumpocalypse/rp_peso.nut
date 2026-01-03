Coin_Pos <- self.GetOrigin() + Vector(0,0,20)




function OnPostSpawn() {
	self.SetAbsOrigin(Coin_Pos)
	AddThinkToEnt(self, "PesoThink")
}

function PesoThink() {
	local self_pos = self.GetOrigin()

	local time_val = Time()
	if (self.GetClassname() == "prop_dynamic") {

		self.SetAbsOrigin(Coin_Pos + Vector(0, 0, sin(time_val*2)))
		self.SetAbsAngles(self.GetAbsAngles()+QAngle(0,time_val*0.5,0))

	}
	for (local i = null; i = Entities.FindByClassnameWithin(i, "player", self_pos, 64);) {
		i.ValidateScriptScope()
		local p_scope = i.GetScriptScope()
		p_scope.Money += 1
		self.Kill()
	}

}