function OnPostSpawn() {
	for (local ent; ent = Entities.FindByClassname(ent, "*");) {
		if (ent == self) {
			continue;
		}

		local vs = NetProps.GetPropString(ent, "m_iszVScripts")

		if (vs != null && vs.len() > 0) {
			try {
				printl("ELTRADEV: Reloading file "+vs+" on SENT "+ent.tostring())
				ent.AcceptInput("RunScriptFile", vs, null, null)

				ent.ValidateScriptScope()

				if ("OnPostSpawn" in ent.GetScriptScope()) {
					ent.GetScriptScope().OnPostSpawn()
				}
			} catch (exception){
				printl("ELTRADEV: ERROR! Could not reload script on entity "+ent.tostring()+" due to exception: \n\n"+exception)
			}
		}
	}
	printl("ELTRADEV: Finished reloading scripts!")
	self.Kill()
}