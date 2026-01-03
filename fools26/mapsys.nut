IncludeScript("eltrasnag/mapfunc.nut")

const PLAYER_BANKCOLOR = "5 123 98"
::tCharacters <- {"grandma" : "238 116 252"}
Convars.SetValue("sv_turbophysics", 0)
function OnPostSpawn() {
	ze_map_say("== "+GetMapName().toupper()+" ==")
	QFireByHandle(self, "RunScriptCode", "ze_map_say(`== MADE BY ELTRA ==`)", 2)
	QFireByHandle(self, "RunScriptCode", "ze_map_say(`== PORTED BY ELTRA ==`)", 4)
	QFireByHandle(self, "RunScriptCode", "ze_map_say(`== BUILT BY ELTRA ==`)", 6)
	QFireByHandle(self, "RunScriptCode", "ze_map_say(`== HUMBLED BY ELTRA ==`)", 8)
	QFireByHandle(self, "RunScriptCode", "ze_map_say(`== ze_parkour_paradise - map by wo0 ==`)", 10)

	ShittyListenHooks({
		function OnGameEvent_player_spawn(params) {
			local ply = GetPlayerFromUserID(params.userid)
			NetProps.SetPropString(ply, "m_iszResponseContext", "")

			ply.ValidateScriptScope()
			local pscope = ply.GetScriptScope()
			ply.ValidateScriptScope()
			pscope = ply.GetScriptScope()
			IncludeScript("eltrasnag/fools26/player.nut", pscope)
			// if ("OnPostSpawn" in pscope) {
			pscope.OnPostSpawn()
				ply.ConnectOutput("OnPlayerSpawn", "OnPostSpawn")
			// }

		}
	})
}

::CTFPlayer.GetMoney <- function() {
	local context = this.GetContext()

	if (!("money" in context))  {
		context.money <- 0
	}

	return context.money
}