
::ROOT <- getroottable()
if (!("SpawnEvents" in ::ROOT)) { // does spawnevents already exist?
	::SpawnEvents <- {};
}
::SpawnEvents.clear() // clear it so we don't duplicate
::SpawnEvents = // redefine spawnevents
{
	OnGameEvent_player_spawn = function(data) {

		local ply = GetPlayerFromUserID(data["userid"]);
		local hPlayerScope = ply.GetScriptScope()
		ply.SetScriptOverlayMaterial("")
		AddThinkToEnt(ply, "") // clear think

		if (hPlayerScope == null || DEV == true) { // reset or load the player scripts
			ply.ValidateScriptScope()


			ply.AcceptInput("RunScriptFile", "eltrasnag/laserinsurgency/li_player.nut",null,null)
			ply.GetScriptScope().strPlayerUID <- data.userid




		}
		AddThinkToEnt(ply, "PlayerClassThink")

		if (DELTA_ACTIVE) {
			DeltifyPlayer(ply)
		}
	}
}

__CollectGameEventCallbacks(SpawnEvents)


printl("SpawnFunctions initialized.")

// function OnPostSpawn() {

//     // RegisterScriptGameEventListener("player_spawn")
// 	// RegisterScriptGameEventListener("teamplay_round_start")

// 	printl("SpawnFunctions initialized.")
// }



// function OnGameEvent_teamplay_round_start(params) {
// 	self.AcceptInput("RunScriptFile", "vscripts/eltrasnag/laserinsurgency/spawnfunctions.nut",null,null)
// 	printl("SpawnFunctions reinitialized")
// }
