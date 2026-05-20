vAngles <- self.GetAbsAngles()

RotBase <- 20 // the "base" speed

RotMult <- 1

function OnPostSpawn() {
	AddThinkToEnt(self, "Think")
	local mult = GetContextKey(self, "mult")
	QFireByHandle(self, "AlternativeSorting", "1", 0.1)

	// mult is percentage as int
	if (mult != null) {
		RotMult = (mult)

	}
	else {
		mult = 100
	}

}


function Think() {
	vAngles.y = Time() * RotMult
	self.SetAbsAngles(vAngles)
	return 0.04
}