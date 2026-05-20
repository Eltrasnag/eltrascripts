DeathTime <- 0

SizeTime <- 0.75

function OnPostSpawn() {
	ScreenFade(null, 255, 255, 255, 15, 0.3, 0, FFADE_IN)
	DeathTime <- Time() + SizeTime
	SetAnimation(self, "idle")
	AddThinkToEnt(self, "Think")
	self.SetModelScale(0.0, 0)
	QFireByHandle(self, "RunScriptCode", "self.SetModelScale(2, SizeTime)", 0.05)


}


function Think() {
	local vOrigin = self.GetOrigin()
	if (Time() >= DeathTime) {
		AddThinkToEnt(self, "")
		self.Kill()
		return

	}
	return -1
}