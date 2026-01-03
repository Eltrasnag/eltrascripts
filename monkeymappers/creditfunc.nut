
//!CompilePal::IncludeFile("sound/eltra/the_monkey.mp3")
//!CompilePal::IncludeFile("materials/eltra/the_monkey.vmt")
//!CompilePal::IncludeFile("materials/eltra/the_monkey.vtf")
// you must keep this or awesome compilepal will miss half of the stuff
// also you must compile with compilepal version 28.6X!!!!!!!!!! or higher

CreditsCamera <- Entities.FindByName(null, "credits_viewcontrol")
CreditsMusic <- Entities.FindByName(null, "credits_mus_ending")
MonkeySound <- "eltra/the_monkey.mp3"
WaitingTime <- 3

function OnPostSpawn() {
	QFire("player", "RunScriptCode", "self.SetScriptOverlayMaterial(``)", 0.0, null) // clear jumpscare in the super rare impossibly-low chance that somehow round restarts while it is on-screen
}
function DoCredits() { // function which handles the credits sequence

	girl_who_is_low_key_bits <- (8 | 16 | 1 | 2 | 64) // hud hiding bits

	QFireByHandle(CreditsMusic, "PlaySound", "", 0.0 + WaitingTime, null, null) // queue music

	PrecacheSound(MonkeySound) // precache jumpscare sound

	for (local i = null; i = Entities.FindByClassname(i, "player");) {

		NetProps.SetPropInt(i, "m_Local.m_iHideHUD", girl_who_is_low_key_bits) // hide the hud (as best as we can)

		i.SetScriptOverlayMaterial("eltra/the_monkey") # jumpscare
		EmitSoundEx({
			sound_name = MonkeySound,
			channel = 6,
			filter_type = 4,
			entity = i
		})

		QFireByHandle(CreditsCamera, "Enable", "", 0.0, i, null) // enable credits camera while jumpscare is displayed

	}

	QFire("player", "RunScriptCode", "self.SetScriptOverlayMaterial(``)", 0.3, null) // clear jumpscare

	QFireByHandle(self, "Open", "", WaitingTime, null, null) // roll credits

}

function DoRoundEnd() { // cleanup & round end after the credits finish
	for (local i = null; i = Entities.FindByClassname(i, "player");) {
		girl_who_is_low_key_bits <- (0)
		NetProps.SetPropInt(i, "m_Local.m_iHideHUD", girl_who_is_low_key_bits) // show hud again

		ScreenFade(i, 255, 255, 255, 255, 2, 0.02, 1) // bombass fade aaaaahhhhh
		switch (i.GetTeam()) {
			case 3:

				break;
			case 2:
				QFireByHandle(i, "SetHealth", "-1", 0.0, null, null ) // kill zombies and end round without relying on a nuke bc i have no idea what the map setup is
				break;
			default:
				break;
		}
	}
}