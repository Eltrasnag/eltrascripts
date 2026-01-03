

// IncludeScript("eltrasnag/common.nut", this)

ZE.BluWin <- Spawn("game_round_win", {targetname = "ZE_BluWin", TeamNum = 3})
ZE.RedWin <- Spawn("game_round_win", {targetname = "ZE_RedWin", TeamNum = 2})


iNextRefillTime <- 0
iNextRefillTimeWait <- 2
function OnPostSpawn() {

	MapSay("WELCOME TO EVIL SCARY RED ESCAPE.")
	MapSay("YOUR GOAL: ECAPE THE RED")
	MapSay("GET OUT OF THERE!!!!!! TO WIN")
	MapSay("GOOD LUCK")
	local RoundEvents = {
		function OnGameEvent_teamplay_setup_finished(params) {
			ZE.AutoInfection()
		}

		function OnGameEvent_player_spawn(params) {
			local ply = GetPlayerFromUserID(params.userid)
			if (!ValidEntity(ply)) {
				return
			}
			if (ply.GetTeam() == TEAMS.ZOMBIES) {
				ply.SetHealth(800 * ZE.GetServerPlayerCount())
				local wepsize = NetProps.GetPropArraySize(ply, "m_hMyWeapons")-1

				for (local i = 0; i < wepsize; i++) {
					local wep = NetProps.GetPropEntityArray(ply, "m_hMyWeapons", i)
					if (!ValidEntity(wep) || i == 2) {
						continue
					}
					wep.Kill()
				}


				local nwep = SpawnWeapon("tf_weapon_slap", 1181)
				// ply.Weapon_Equip(nwep)
				ply.Weapon_Switch(NetProps.GetPropEntityArray(ply, "m_hMyWeapons", 2))

			}

			if (ply.GetTeam() == TEAMS.HUMANS) { // human spawn stuff

				local wepsize = NetProps.GetPropArraySize(ply, "m_hMyWeapons")-1

				for (local i = 0; i < wepsize; i++) { /// apply balancing to each of the player weapons
					local wep = NetProps.GetPropEntityArray(ply, "m_hMyWeapons", i)
					if (!ValidEntity(wep)) {
						continue
					}
					local classname = wep.GetClassname()
					local trimmed_name = classname.slice(10, classname.len())

					wep.AddAttribute("move speed bonus", zWeapons.class_speeds[ply.GetPlayerClass()], 0)

					if (trimmed_name in zWeapons) {
						local config = zWeapons[trimmed_name]
						// printl("STEAM HAPPIEST!!!!!!!!")
						wep.AddAttribute("ragdolls become ash", 1, -1)
						// set dmg mult
						wep.AddAttribute("damage bonus", config[0], 0)
						// set fspeed mult
						wep.AddAttribute("fire rate bonus", config[1], 0)
						// set knockback add
						wep.AddAttribute("faster reload rate", (config[2]), 0)
						// set clip size
						wep.AddAttribute("clip size bonus", (config[3]), 0)

						if (config.len() == 5) // check if weapon has even more attributes
						{
							foreach (i, attribute in config[4]) {
								wep.AddAttribute(attribute[0], attribute[1], 0)
							}
						}
					}

				}
			}
		}


	}
	ListenEvents(RoundEvents)


	self.KeyValueFromString("targetname", "ze_round")
	AddThinkToEnt(self, "RoundThink")
}


ZE.IsBluAlive <- function() {
	local blu = 0
	for (local ply; ply = Entities.FindByClassname(ply, "player");) {
		if (ply != null && ply.GetTeam() == TEAMS.HUMANS) {


			blu++
		}
	}
	if (blu == 0) {
		return false
	} else {
		return true
	}
}


function RoundThink() {
	local flTime = Time()


	if (flTime >= iNextRefillTime) {
		for (local ply; ply = Entities.FindByClassname(ply, "player");) {

			if (ply != null && ply.GetTeam() == TEAMS.HUMANS) {
				// NetProps.SetPropBool(ply, "m_bSpeedModActive", true)
				// NetProps.SetPropInt(ply, "m_iSpeedModSpeed", 20)
				// NetProps.SetPropInt(ply, "m_iSpeedModRadius", 200)
				// NetProps.SetPropInt(ply, "m_SpeedMax", 200)

				if (iNextRefillTime <= Time()) {
					// also refill the player's ammo while we're at it
					local sz = NetProps.GetPropArraySize(ply, "m_hMyWeapons")
					for (local i = 0; i < sz - 1; i++) {

						local hWeapon = NetProps.GetPropEntityArray(ply, "m_hMyWeapons", i)
						// printl("hWeap: "+hWeapon)
						if (!ValidEntity(hWeapon)) {
							continue;
						}
						// local ammotype = NetProps.GetPropInt(hWeapon, "m_iPrimaryAmmoType")
						local ammotype = hWeapon.GetPrimaryAmmoType()
						// printl("hWeap Ammo Type: "+ammotype)
						NetProps.SetPropIntArray(hWeapon.GetOwner(), "m_iAmmo", 999, ammotype)
						NetProps.SetPropIntArray(hWeapon.GetOwner(), "m_iAmmo", 999, hWeapon.GetSecondaryAmmoType())
						// local ammotype = NetProps.GetPropInt(hWeapon, "m_iPrimaryAmmoType")
						// NetProps.SetPropInt(hWeapon, "m_iAmmo", 999)
						// printl("set amma")
					}
				}
			}
		}
		iNextRefillTime = flTime + iNextRefillTimeWait
	}

	if (ZE.IsBluAlive() == false) {
		AddThinkToEnt(self, "")
		QFireByHandle(ZE.RedWin, "RoundWin")
		return
	}
	return 1
}

ZE.GetRandomHumanPlayer <- function() {
	local players = []
	for (local ply; ply = Entities.FindByClassname(ply, "player"); ) {
		if (ply.GetTeam() == TEAMS.HUMANS) {
			players.append(ply)
		}
	}
	if (players.len() > 0 ) {
		local victim = players[RandomInt(0, players.len() - 1)]
		printl("victim "+victim)
		return victim
	}

	return null
}



ZE.AutoInfection <- function() {
	local players = []


	for (local ply = null; ply = Entities.FindByClassname(ply, "player");) { // are you serious
		players.append(ply)

	}

	local players = players.len()
	local players_to_kill = pow((log10(players + 1) * 2), 2)
	// printl("frac = "+frac)

	if (players == 1) {
		return
	}

	local infectqueue = []


	for (local i = 0; i < players_to_kill; ) {
		local ply = ZE.GetRandomHumanPlayer()
		if (!(ply in infectqueue)) {
			infectqueue.append(ply)
			printl("adding " + GetPlayerName(ply) + " to infect queue")
			i++
		}
		continue;

	}

	if (infectqueue.len() == 0) {
		return
	}
	foreach (i, ply in infectqueue) {
		if ((GetSteamID(ply) == ELTRA_STEAMID)) {
			continue
		}
		ZE.Infect(ply, false)

	}
}


