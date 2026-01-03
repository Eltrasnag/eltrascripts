
function OnPostSpawn() {
	AddThinkToEnt(self, "FXThink")
}

next_lava_time <- 0

function FXThink() {

	local time = Time()
	if (time >= next_lava_time && FX_SCENE == "s2_fx_lavaroom") {
		next_lava_time = time + RandomInt(3, 6)
		self.AcceptInput("Start", "", null, null)
		PlaySoundEX("ambient/explosions/exp" + RandomInt(1, 4).tostring() + ".wav", self.GetOrigin())
		// self.AcceptInput("Stop", "", null, null)
		QFireByHandle(self,"Stop","",0.5)
		ScreenShake(self.GetOrigin(), RandomInt(4,12),RandomInt(4,12),RandomInt(2,5),2048, 0, true)
	}
}

