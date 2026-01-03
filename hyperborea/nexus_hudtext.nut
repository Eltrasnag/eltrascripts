// nexus_text <- Entities.FindByName(null, "s5_nexusalpha_bosstext");
// printl("NEXUS ACTIVE: "+nexus_active)
AddThinkToEnt(self, "NexusHudThink")
function NexusHudThink() {
	try {
		if (nexus_active == true) {
			// nexus_text.KeyValueFromString("message", "-=* \"NEXUS-ALPHA\": " + nexus_health + " HP *=-")
			self.KeyValueFromString("message", "-=* NEXUS-ALPHA *=-\n| " + nexus_health * 16 + " HP |") // *16 so it doesnt look like boss is very weak
			self.AcceptInput("Display", "", null, null);
		}
		// printl("hudthink")
		return 0.1

	} catch (exception){
		printl("\n\n\n\nNEXUS HUD THINK ERROR: " + exception)
	}
	return 0.1
}