players <- []
function OnPostSpawn() {
	self.ConnectOutput("OnStartTouch", "Enter")


}

function Enter() {
	local vOrigin = activator.GetOrigin()
	DoEffect("cic_lavasplash", activator.GetOrigin())
	PlaySoundEX("eltra/minecraft_watersplash.mp3", vOrigin, 10, 0.5)
	ScreenFade(activator, 255, 128, 0, 100, 1, 0.1, 1)
	if (activator.GetTeam() == Constants.ETFTeam.TF_TEAM_BLUE) {
		activator.TakeDamage(9999999, Constants.FDmgType.DMG_DROWN, null)
	} else {
		QFireByHandle(activator, "SpeakResponseConcept", "ConceptHalloweenPlayerPitFall")
		activator.TakeDamage(1000, Constants.FDmgType.DMG_DROWN, null)

	}

}

function Exit() {

}