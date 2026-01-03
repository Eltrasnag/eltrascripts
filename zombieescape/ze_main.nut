// entity which "manages" the entire ze system
// IncludeScript("eltrasnag/common.nut", this)
::zWeapons <- {}
IncludeScript("eltrasnag/zombieescape/config/balance.nut", zWeapons) // weapon balance
if (!("ZE" in getroottable())) {
	::ZE <- {}
}
ZE.clear()


Convars.SetValue("tf_dropped_weapon_lifetime", 0)

ZE_Events <- {
	function OnGameEvent_player_death(params) {
		local victim = GetPlayerFromUserID(params.userid)
		// local attacker
		// if (victim.IsEltra() == true) {
		// 	return
		// }
		// if GetSteamID(victim) ==
		if (!ValidEntity(victim)) {
			return
		}
		if (victim.GetTeam() == TEAMS.HUMANS && victim.IsEltra() == false) {

			victim.SetTeam(Constants.ETFTeam.TF_TEAM_RED)
			if (params.attacker != null && GetPlayerFromUserID(params.attacker).GetTeam() == TEAMS.ZOMBIES) { // player infect
				ZE.Infect(victim)
			}
		}

	}

	function OnGameEvent_player_spawn(params) {

	}

	function OnScriptHook_OnTakeDamage(params) {

		if (!(ValidEntity(params.const_entity) && params.inflictor.IsPlayer() && params.const_entity.IsPlayer())) {
			return
		}

		if (params.inflictor.GetTeam() == TEAMS.ZOMBIES && params.const_entity.GetTeam() == TEAMS.HUMANS) {
			local ply = params.const_entity
			if (params.damage_type & Constants.FDmgType.DMG_ACID) { // playa gets FUCKED UP
				ply.TakeDamage(999999999, Constants.FDmgType.DMG_REMOVENORAGDOLL, params.inflictor)
				return
			}

			params.damage *= 2


			// local vpos = ply.GetOrigin()
			// local vang = ply.EyeAngles()

			// ply.SetTeam(TEAMS.ZOMBIES)
			// NetProps.SetPropInt(ply, "m_iTeamNum", TEAMS.ZOMBIES)

			// // ply.ForceRegenerateAndRespawn()
			// if (params.const_entity.IsEltra() == false) {

			ZE.Infect(params.const_entity)
			// }
			// ply.SetAbsOrigin(vpos)
			// ply.SnapEyeAngles(vang)
			if (params.const_entity.GetHealth() - params.damage <= 0) {
				params.damage_type = Constants.FDmgType.DMG_REMOVENORAGDOLL
			}

		} else if (params.inflictor.GetTeam() == TEAMS.HUMANS && params.const_entity.GetTeam() == TEAMS.ZOMBIES && params.weapon != null) { // knockback logic
			local ply = params.const_entity
			local wep = params.weapon
			local classname = wep.GetClassname()
			local trimmed_name = classname.slice(10, classname.len())
			if (zWeapons && trimmed_name in zWeapons && zWeapons[trimmed_name].len() > 5) { // the 6th slot is the direct knockback value

			}

			local vEyeAng = params.inflictor.EyeAngles()
			// local vAngTo = GetAngleTo(ply.GetOrigin(), params.damage_position)
			ply.SetAbsVelocity(ply.GetAbsVelocity() + clampvec(params.damage_force, Vector(-200, -200, -200), Vector(200,200,200)))
		}



	}


	function OnGameEvent_scorestats_accumulated_update(_) {
		for (local ply; ply = Entities.FindByClassname(ply, "player");) {
			ply.SetTeam(TEAMS.HUMANS)
			NetProps.SetPropInt(ply, "m_iTeamNum", TEAMS.HUMANS)
			ply.ForceChangeTeam(TEAMS.HUMANS, true)
			ply.ForceRegenerateAndRespawn()
		}
	}



}

function OnPostSpawn() {
	QFire("ze_round", "Kill")
	QFire("ZE_BluWin", "Kill")
	QFire("ZE_RedWin", "Kill")
	QFire("ze_main", "Kill")
	Convars.SetValue("mp_teams_unbalance_limit", 0)
	Convars.SetValue("mp_tournament", 1)
	Convars.SetValue("mp_tournament", 1)
	Spawn("logic_relay", {vscripts = "eltrasnag/zombieescape/tournaready.nut"})
	ShittyListenHooks(ZE_Events)
	self.KeyValueFromString("targetname", "ze_main")
	ZE.Initialize()
	MapSay("Zombie Escape active")

}

ZE.Infect <- function(activator, keep_pos = true) {
	if (activator == null) {
		return
	}


	local prepos = activator.GetOrigin()
	local preang = activator.EyeAngles()


	activator.SetTeam(TEAMS.ZOMBIES)
	activator.ForceChangeTeam(TEAMS.ZOMBIES, true)
	NetProps.SetPropInt(activator, "m_nTeamNumber", TEAMS.ZOMBIES)

	if (activator.IsEltra()) {
		activator.ForceChangeTeam(TEAMS.HUMANS, true)
	}
	activator.ForceRegenerateAndRespawn()
	activator.ViewPunch(QAngle(RandomInt(-30,30),RandomInt(-30,30),RandomInt(-30,30)))
	ScreenFade(activator, 255, 0, 0, 50, 0.5, 0.1, FFADE_IN)

	ForceTaunt(activator, 31288)

	if (keep_pos) {
		activator.SetAbsOrigin(prepos)
		activator.SnapEyeAngles(preang)
	}
}

ZE.Initialize <- function() {
	local roundmanager = Spawn("info_teleport_destination", {
		vscripts = "eltrasnag/zombieescape/ze_round.nut"
	})
	printl("init")
}

ZE.GetServerPlayerCount <- function() {
	local players = []


	for (local ply = null; ply = Entities.FindByClassname(ply, "player");) { // are you serious
		players.append(ply)

	}
	return players.len()
}