

function OnPostSpawn() {
	AddThinkToEnt(self, "TicketThink")

}

TicketPrice <- 7

function TicketThink() {
	local vOrigin = self.GetOrigin()
	local fscope = ffield.GetScriptScope()
	for (local ply; ply = Entities.FindByClassnameWithin(ply, "player", self.GetOrigin(), 128);) {

		if (ply.GetTeam() == TEAMS.HUMANS) {
			if (!(ply in fscope.AllowList)) {
				ClientPrint(ply, Constants.EHudNotify.HUD_PRINTCENTER, "HOLD [RIGHT CLICK] TO PAY UP BUDDY. 7$ UP TOP.")
			}
			// } else {

			// }

			if (ButtonPressed(ply, IN_ATTACK2)) {

				if (!(ply.GetEntityIndex() in Diary)) {
					Diary[ply.GetEntityIndex()] <- 0
				}
				ply.ValidateScriptScope()
				local scope = ply.GetScriptScope()
				if ("iMoney" in scope && (scope.iMoney > 0) && Diary[ply.GetEntityIndex()] < TicketPrice) {
					scope.iMoney--
					PrecacheSound("eltra/cash_register.mp3")
					EmitAmbientSoundOn("eltra/cash_register.mp3", 1.0, 100, 100, self)
					Diary[ply.GetEntityIndex()]++
				} else if ("iMoney" in scope && (scope.iMoney == 0)) {
					ClientPrint(ply, Constants.EHudNotify.HUD_PRINTCENTER, "POOR LITTLE FUGLY BITCH GO DIE WITH YOUR POOR LITTLE UGLY FRIENDS YOU FUCKING IDIOT")
				}

				if (Diary[ply.GetEntityIndex()] == TicketPrice) {

					if (!"TicketPaid" in scope) { // just incase darkon was telling the truth back  there
						scope.TicketPaid <- true
					}

					scope.TicketPaid = true

					if (!(ply.GetEntityIndex() in fscope.AllowList)) {
						fscope.AllowList.append(ply.GetEntityIndex())
					}
					ClientPrint(ply, Constants.EHudNotify.HUD_PRINTCENTER, "OK RIGHT ON THROUGH!!! HAVE A GOOD BEAUTIFUL LOVELY DAY! *GIVE YOU A LITTLE KISSY POO*")
				}

			}
		}
	}
	return 0.25
}