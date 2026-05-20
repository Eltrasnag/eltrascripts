DeathTime <- 0

function OnPostSpawn() {
	ScreenFade(null, 114, 255, 255, 75, 0.3, 0, FFADE_IN)
	DeathTime <- Time() + 10
	SetAnimation(self, "idle")
	AddThinkToEnt(self, "Think")
	// self.SetModelScale(clamp(self.GetModelScale() + 0.025, 0
	self.SetModelScale(0.75, 1)

}


function Think() {
	// QAcceptInput(self, "AlternativeSorting", "0")
	// QFireByHandle(self, "AlternativeSorting", "1", 0.1)

	local vOrigin = self.GetOrigin()
	local trace = QuickTrace(vOrigin, vOrigin)
	if (trace.hit == true) {

		local hBombBoom = Spawn("prop_dynamic", {
			model = "models/eltra/cic/endovus_laserbomb_boom.mdl",
			modelscale = 0,
			vscripts = "eltrasnag/christiscoming/endovus_laserbomb_boom.nut",
			origin = vOrigin + Vector(0,0,40),
			// thinkfunction = "Think"
		})
		PlaySoundEX("ambient/levels/labs/electric_explosion" + RandomInt(1, 5)+".wav", vOrigin, 4, RandomInt(70,105))
		local ply;
		while (ply = Entities.FindByClassnameWithin(ply, "player", vOrigin, 256)) {
			ply.TakeDamage(RandomInt(80,95), Constants.FDmgType.DMG_ACID, null)

		}
		AddThinkToEnt(self, "")
		self.Kill()
		return

	}

	self.KeyValueFromVector("origin", vOrigin + Vector(0,0, -10))
	return -1
}