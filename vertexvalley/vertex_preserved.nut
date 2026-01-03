::Stage <- 0;
::Long_Intro = true;




function OnPostSpawn() {

    __CollectGameEventCallbacks(this)
    RegisterScriptGameEventListener("player_spawn")

}

function OnGameEvent_player_spawn(data) {
    local ply = GetPlayerFromUserID(uid["userid"]);
    if (ply.GetScriptScope() == null) {

        ply.ValidateScriptScope()
        ply.AcceptInput("RunScriptFile", "vscripts/vertexvalley/vertex_player.nut")

    }

	// player.ValidateScriptScope();
	// local scope = player.GetScriptScope();
	// scope.vehicle <- null;
	// scope.vehicle_scope <- null;


}