::GameRules <- Entities.FindByClassname(null, "tf_gamerules")
::MAX_CLIENTS <- MaxClients().tointeger()
const TF_TEAM_RED = 2
const TF_TEAM_BLUE = 3

local ready = true

local red_check = false
local blue_check = false

for (local i = 1; i <= MAX_CLIENTS; i++)
{
	local player = PlayerInstanceFromIndex(i)
	if (!player)
		continue

	local team = player.GetTeam()
	if (!(team & 2))
		continue

	if (team == TF_TEAM_RED)
	{
		if (red_check)
			continue
		red_check = true
	}
	else if (team == TF_TEAM_BLUE)
	{
		if (blue_check)
			continue
		blue_check = true
	}

	if (NetProps.GetPropBoolArray(GameRules, "m_bTeamReady", team))
		continue

	NetProps.SetPropBoolArray(GameRules, "m_bTeamReady", ready, team)

	SendGlobalGameEvent("tournament_stateupdate",
	{
		userid = player.entindex(),
		readystate = ready.tointeger(),
		namechange = 0,
		oldname = " ",
		newname = " ",

	})

	if (!ready)
	{
		NetProps.SetPropFloat(GameRules, "m_flRestartRoundTime", -1.0)
		NetProps.SetPropBool(GameRules, "m_bAwaitingReadyRestart", true)
	}
}