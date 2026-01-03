// main_script =


::PortalFade <- function(activator) {


	ScreenFade(activator, 208, 59, 245, 80, 0.75, 0.1, 1)
	if (active_portal_sounds < max_portal_sounds) {
		active_portal_sounds += 1
		PrecacheScriptSound("eltra/nether_portal.mp3")
		EmitSoundOn("eltra/nether_portal.mp3", activator)

		active_portal_sounds -= 1
	}
}
