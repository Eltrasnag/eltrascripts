__CollectGameEventCallbacks(this)
RegisterScriptGameEventListener("OnGameEvent_scorestats_accumulated_update")

function OnGameEvent_scorestats_accumulated_update(data) {
	QFire("ambient_generic*","Volume","0")
}