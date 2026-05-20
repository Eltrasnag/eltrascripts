// hModel <- null;

str_Overlay <- "";
const PIXEL_OVERLAY_HUMAN = "eltra/nide26/shaders/eltra_psx_h.vmt"
const PIXEL_OVERLAY_ZOMBIE = "eltra/nide26/shaders/eltra_psx_z.vmt"

function OnPostSpawn() {
	// self.ValidateScriptScope()

	// RunScriptCode(self, "self.SetScriptOverlayMaterial(PIXEL_OVERLAY)", 0.1)
	AddThinkToEnt(self, "Think")
	// RunScriptCode(self, "self.SetScriptOverlayMaterial(PIXEL_OVERLAY)", 0.25)

    // if (self.GetTeam() == TEAMS.HUMANS) {
        // if (!hModel) {
            // hModel = Spawn("prop_dynamic", {
                // model = PLAYERMODEL_DIR + CTModels[RandomInt(0, CTModels.len() - 1)],
                // vscripts = "eltrasnag/nide26/playermodel.nut"
            // })
        // }
        // self.SetModelSimple(PLAYERMODEL_DIR + CTModels[RandomInt(0, CTModels.len() - 1)])
    // }
	QFireByHandle(self, "setdamagefilter", "filter_falldamage", 0.1)
}

function Think() {
	QAcceptInput(self, "setdamagefilter", "filter_falldamage", 0)
	if (!ValidEntity(self)) {
		AddThinkToEnt(self, "")
		return -1
	}

	if (self.GetScriptOverlayMaterial() == "") {
		switch (self.GetTeam()) {
			case TEAMS.HUMANS:
				self.SetScriptOverlayMaterial(PIXEL_OVERLAY_HUMAN)

			break;
			case TEAMS.ZOMBIES:
				self.SetScriptOverlayMaterial(PIXEL_OVERLAY_ZOMBIE)
			break;
			default:
				self.SetScriptOverlayMaterial("")

			break;
		}
	}
	return 0.1
}



