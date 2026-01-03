
function OnPostSpawn() {
	local events = {

	function OnGameEvent_player_calledformedic(params) { // he think he skial dot com...........
		local ply = GetPlayerFromUserID(params.userid)
		printl("Gotcha")
		local vEyeOrigin = ply.EyePosition()
		local vEyeAng = ply.EyeAngles()
		// QEmitSound( "HL2Player.Use" );


	}
}

	ListenHooks(events)
	printl("Yea")
}