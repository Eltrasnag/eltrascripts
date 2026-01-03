Origin <- self.GetOrigin()
rand <- RandomInt(1,100)


function OnPostSpawn() {
	local groundtrace = QuickTrace(self.GetOrigin(), self.GetOrigin() - Vector(0,0,1000))
	Origin = groundtrace.pos + Vector(0,0,32)
	AddThinkToEnt(self, "Think")
	self.SetModelScale(0.75, 0)
}


function Think() {
	local vOrigin = Origin + Vector(0,0, (sin(Time() * 2 + rand)*4))
	local vAngles = QAngle(0, Time()*360 + rand, 0)
	for (local ply; ply = Entities.FindByClassnameWithin(ply, "player", Origin, 64);) {
		if (ply.GetTeam() == TEAMS.HUMANS) {
			ply.ValidateScriptScope()
			local scope = ply.GetScriptScope()
			if (!"iMoney" in scope) {
				scope.iMoney <- 0
			}

			if (scope.iMoney >= 10) {
				ClientPrint(ply, Constants.EHudNotify.HUD_PRINTCENTER, "Your pockets are full, you can't pick up any more coins!")
				continue
			}
			scope.iMoney++
			DoEffect("mvm_cash_embers", vOrigin)
			PrecacheSound("eltra/tp_money_get.mp3")
			PlaySoundNPC("eltra/tp_money_get.mp3", self)
			self.Destroy()
			return
		}
	}

	self.SetAbsAngles(vAngles)
	self.KeyValueFromVector("origin", vOrigin)
	return 0.03
}