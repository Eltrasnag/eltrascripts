self.ValidateScriptScope()
const DUMMY_HEALTH = 99999
iHealth <- 100


b_HealthReady <- false




function iHealthSetup() {
	self.ValidateScriptScope()
	self.ConnectOutput("OnTakeDamage", "TakeDamage")
	NetProps.SetPropInt(self, "m_takedamage", 2)
	self.SetMaxHealth(DUMMY_HEALTH)
	self.SetHealth(DUMMY_HEALTH)

	dprintl("Setting health to dummy health, ", DUMMY_HEALTH, ". Entity's health is now : ", self.GetHealth())

}

// whenever we take damage. this can be overridden in the inheriting script.
TakeDamage <- function() {
	local cur_health = 	NetProps.GetPropInt(self, "m_iHealth")

	self.SetModelScale(0.98, 0)
	QAcceptInput(self, "color", "255 0 0")
	self.SetModelScale(1, 0.1)
	QFireByHandle(self, "color", "255 255 255", 0.25)

	local health_diff = DUMMY_HEALTH - cur_health

	iHealth -= health_diff

	dprintl(self, " : I just took ", health_diff, " damage! My health is now: ", iHealth)

	self.SetHealth(DUMMY_HEALTH)

	meta_TakeDamage()

}.bindenv(this)

// returns if our health is above 0.
iHealthAlive <- function() {
	if (iHealth <= 0) {
		dprintl("iHealthAlive: we are dead!")
		return false
	}
	return true
}


if (b_HealthReady == false) {
	b_HealthReady = true
	RunScriptCode(self, "iHealthSetup()", 0.0) // delay is required or it doesn't set the health properly!! next tick (0.0) is enough in this case though.
}

// override this function in the inheriting script to do stuff when we take damage!
function meta_TakeDamage() {}