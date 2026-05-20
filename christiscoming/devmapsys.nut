cic_regex <- regexp("christ_is_coming")
function Precache() {
	if (!(cic_regex.search(GetMapName()))) {
		printl("ELTRADEV: CIC script loaded on non-CIC map! Spawning dev entities...")
		// IncludeScript("eltrasnag/christiscoming/cic_main.nut", this)
		// self.KeyValueFromString("targetname", "mapsys")
		// printl(self)
		SpawnEntityFromTable("info_teleport_destination",{
			targetname = "mapsys",
			vscripts = "eltrasnag/christiscoming/cic_main.nut"
		})
		SpawnEntityFromTable("info_teleport_destination",{
			targetname = "mapfunc",
			vscripts = "eltrasnag/mapfunc.nut"
		})
		SpawnEntityFromTable("info_teleport_destination",{
			targetname = "ladderguy",
			vscripts = "eltrasnag/zombieescape/zeladder.nut"
		})
	}
	else {
		printl("ELTRADEV: Redundant CIC dev-script loaded on CIC! Please remove: "+self.GetName())

		self.Kill()
	}
}