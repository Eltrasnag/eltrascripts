DeathTime <- 1 + Time()
arrowspeed <- 20
alpha <- 0

function Precache() {

}

function OnPostSpawn() {
	DeathTime = Time() + 1
	AddThinkToEnt(self, "ArrowThink")
	// self.KeyValueFromString("message", "^")
}

function ArrowThink() {

	if (Time() >= DeathTime) {
		self.Kill()
		// printl("kill myself")
		return
	}

	if (alpha < 255) {
		local colstring = "199 255 219 "+alpha
		self.KeyValueFromString("color", colstring)
		alpha += 20
		CleanString(colstring)

	}
	self.SetLocalOrigin(self.GetLocalOrigin() + (self.GetLocalAngles().Up() * arrowspeed))
	return 0.05
}

