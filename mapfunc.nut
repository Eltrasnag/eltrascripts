IncludeScript("eltrasnag/common.nut", this) // IS THIS A BAD IDEA>? WHO KNOWS.
if (!("MAPFUNC" in getroottable())) {
	::MAPFUNC <- {"eltramapfunc version": "1.0"}
	// local stageholder = Spawn("info_target", {targetname = "MapStage"})
	// stageholder.ValidateScriptScope()
	// scope = stageholder.GetScriptScope()

	// ::MapStage <- 0

}

MAPFUNC.DoSourceScaling <- true // should we scale players better fit source dimensions? (0.7)
MAPFUNC.MapFog <- ""

// should we enable the fake ZE plugin?
MAPFUNC.DoZombieEscape <- false

::GAME_IS_TF2 <- false
// the map's "accent color"
MAPFUNC.MAP_COLOR <- "255 255 255"
MAPFUNC.MAP_COLOR_HEX <- "ffffff"

MAPFUNC.TF_ROUNDTIMER <- null;


MAPFUNC.SetFog <- function(fog_name) {
	MAPFUNC.MapFog <- fog_name
	QFire("env_fog_controller", "turnoff")
	QFire(fog_name, "turnon","",0.0)
	for (local ply; ply = Entities.FindByClassname(ply, "player");) {
		QFireByHandle(ply, "SetFogController", fog_name, 0.1)
	}
	QFire("player*","setfogcontroller",MAPFUNC.MapFog)
}

funcevents <- {

	function OnGameEvent_scorestats_accumulated_update(_) {
		MAPFUNC.PlayerGuard()
		for (local ent = 0; ent = Entities.FindByClassname(ent, "ambient_generic");) { // hacky way of imitating cs's ambient generic behaviour in tf2
			// ent.KeyValueFromInt("radius", 0)
			// ent.KeyValueFromInt("", 0)
			// NetProps.SetPropFloat(ent, "m_flMaxRadius", 0.0)
			// if (!NetProps.GetPropBool(ent, "m_fLooping")) {
				NetProps.SetPropBool(ent, "m_fLooping", false)
				ent.AcceptInput("StopSound", "", null, null)

				NetProps.SetPropBool(ent, "m_fLooping", false)
				NetProps.SetPropBool(ent, "m_fActive", true)
				NetProps.SetPropFloat(ent, "m_radius", 0.0)


			// }
			// NetProps.SetPropBool(ent, "m_fActive", true)
			// ent.AcceptInput("StopSound", "0", null, null)

			// ent.Kill()

		}
		local sprite;
		while (sprite = Entities.FindByClassname(sprite, "env_sprite")) { // clean up stray env sprites (e.g. those created by env_laser (!!) )
			sprite.Kill()
		}
	}

	function OnGameEvent_teamplay_round_start(t) {
		MAPFUNC.TF_ROUNDTIMER <- Entities.FindByClassname(null, "team_round_timer")
		if (MAPFUNC.TF_ROUNDTIMER != null) {
			GAME_IS_TF2 = true
			printl("ELTRACOMMONS: Detected game as Team Fortress 2! TF2-specific logic will be ENABLED on this map.")
		}
	}

	function OnGameEvent_player_spawn(data) {
		local ply = GetPlayerFromUserID(data.userid)
		MAPFUNC.PlayerSpawn(ply)
	}
}

MAPFUNC.PlayerSpawn <- function(ply) {
	AddThinkToEnt(ply, "") // surely this will not cause problems in laserinsurgency!

	ply.ValidateScriptScope()
	local scope = ply.GetScriptScope()
	ply.SetGravity(1)
	if ("CurrentViewControl" in scope && scope.CurrentViewControl != "") {
		SetViewControl(ply, scope.CurrentViewControl, false)
	}

	if ("LastThinkFunc" in scope) {
		delete scope.LastThinkFunc
	}

	scope.CurrentViewControl <- ""

	ply.SetScriptOverlayMaterial("")
	SetItemUser(ply, false)
	if (MAPFUNC.DoSourceScaling == true) {
		ply.SetModelScale(css_scale_value,0)
	}

}

MAPFUNC.PlayerGuard <- function() {
	printl("DEV: PLAYERGUARD ACTIVATED!")
	QFire("player*", "ClearParent") // prevent mass player annihilation

	for (local ply = null; ply = Entities.FindByClassname(ply, "player");) {

		ply.AcceptInput("ClearParent", "", null, null);
		// ply.SetAbsAngles();
		QFireByHandle(ply, "ClearParent");
	}
}

function Precache() { // Do not crash or i will kill myself NOW
	ListenHooks(funcevents)
}
function OnPostSpawn() {
	if (DEVELOPER_MODE == true && MAPFUNC.DoZombieEscape == true) {
		DoZombieEscape()
	}
	NetProps.SetPropInt(Entities.First(), "m_takedamage", 1)
	MapSpawn()
}

function DoZombieEscape() { // activate the fake ZE testing ""plugin""
	// local zman = Entities.CreateByClassname("info_teleport_destination")
	if (!Entities.FindByName(null, "zman")) { // may this fix the edict crash 🙏
		local zman = Spawn("info_teleport_destination", {
			vscripts = "eltrasnag/zombieescape/ze_main.nut"
		})
	}

	// QFireByHandle(zman, "RunScriptFile", "eltrasnag/zombieescape/ze_main.nut")
}

function MapSpawn() {
 // dummy function for mapsys children
}