IncludeScript("eltrasnag/mapfunc.nut")

::tCharacters <- {"grandma" : "255 0 0"}

function MapSpawn() {
	ze_map_say("== "+GetMapName()+" ==")
	QFireByHandle(self, "RunScriptCode", "ze_map_say(`== MADE BY ELTRA ==`)", 2)
	QFireByHandle(self, "RunScriptCode", "ze_map_say(`== PORTED BY ELTRA ==`)", 4)
	QFireByHandle(self, "RunScriptCode", "ze_map_say(`== BUILT BY ELTRA ==`)", 6)
	QFireByHandle(self, "RunScriptCode", "ze_map_say(`== HUMBLED BY ELTRA ==`)", 8)
	QFireByHandle(self, "RunScriptCode", "ze_map_say(`== ze_parkour_paradise - map by wo0 ==`)", 10)


}