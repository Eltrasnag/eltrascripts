::nexus_health <- 14;
::nexus_active <- false;
::nexus_hope_active <- false;
::nexus_damageable <- false;
::nexus_max_health <- 0;
::nexus_active_rocks <- 0;
nexus_injured_health <- 0;
nexus_panic_health <- 0;

nexus_health_per_player <- 216; // this felt way too low during first playtest but it might actually be okay with a lot of players; also unconstant-ing this so we can QFire to change it!!!


nexus_animations <- ["wake_idle", "damaged_idle", "panic_idle"]


enum nexus_states {
	healthy = 0,
		injured = 1,
		panic = 2,
}
nexus_state <- nexus_states.healthy
last_nexus_state <- 0


const chamber_radius = 1700

nexus_rock_paths <- null;
nexus_breakable <- null;
nexus_penguin_timer <- null;
nexus_crumble_timer <- null;
nexus_chamber_center <- null;






// function OnPostSpawn() {


// 	// NetProps.SetPropInt(nexus_breakable, "m_takedamage", 1)

// }

function Start() {
	nexus_rock_paths = ["models/eltra/atlas_rocks_0_0.mdl", "models/eltra/atlas_rocks_0_1.mdl", "models/eltra/atlas_rocks_0_2.mdl", "models/eltra/atlas_rocks_0_3.mdl"]
	nexus_breakable = Entities.FindByName(null, "s5_nexusalpha_breakable");
	nexus_penguin_timer = Entities.FindByName(null, "s5_nexusalpha_missile_timer");
	nexus_crumble_timer = Entities.FindByName(null, "s5_nexusalpha_crumble_timer");
	nexus_chamber_center = Entities.FindByName(null, "s5_nexusalpha_chamber_center").GetOrigin();
	QFire("s5_nexusalpha_breakable", "SetParent", "s5_nexusalpha", 0.0, null);
	QFire("s5_nexusalpha_breakable", "SetParentAttachment", "head", 0.5, null);
	AddThinkToEnt(self, "NexusThink")
}

function NexusStateMachine() {
	printl("Nexus state has changed")
	switch (nexus_state) {
		case nexus_states.healthy:


			break;
		case nexus_states.injured:
			QFire("tem_nexus_spinner", "ForceSpawn", "", 0.0, null);

			break;
		case nexus_states.panic:
			break;
		default:
			break;
	}
}

function NexusThink() {
	// printl("NEXUS THINK PLEASS ITS 10 PM")
	try {
		if (nexus_active == true) {
			if (nexus_state != last_nexus_state) {
				NexusStateMachine()
			}
			last_nexus_state = nexus_state
		}
	} catch (exception) {
		printl("NEXUSTHINK EXCEPTION: " + exception)
	}
	return 0.35
}

// function GetNexusStage() {

// if (nexus_health < nexus_max_health * 0.3)
// {

// }
// }

function NexusRandomAction() { // Randomly pick an attack for the Nexus to perform
	// NOTE: All attacks should be designed to last for LESS THAN 8 SECONDS!!
	// This makes it so it never feels like you are "waiting" for the boss

	try {
		if (nexus_active == true && nexus_damageable == false) {
			local random_number = RandomInt(1, 3)

			switch (random_number) {
				case 1:
					PenguinMissiles()
					break;
				case 2:
					CeilingCrumble()
					break;
				case 3:
					SpinTornado()
					break;
				case 4:
					SlopDrop()
					break;
				default:

					break;
			}
		}
	} catch (exception){
		printl("\n\n\n\n\n\nNEXUS ALPHA EXCEPTION I NRANDOM ACTION CODE:"+exception)
	}


}

function PenguinMissiles() { // attack 1
	nexus_penguin_timer.AcceptInput("FireUser1", "", null, null);
	printl("Attack 1: Penguin Missile")
}

function CeilingCrumble() { // attack 2

	printl("Attack 2: Ceiling Crumble")
	nexus_crumble_timer.AcceptInput("FireUser1", "", null, null);

}

function SpinTornado() { // attack 3
	printl("Attack 3: Spin Tornado")
	SpawnSpinner()
}

function SlopDrop() { // attack 4
	printl("Attack 4: Slop Drop")
}


// Attack-specific functions

// Ceiling Crumble

function SpawnCrumbleProp() { // nexus alpha spawns rocks which fall from th ceiling
	if (nexus_active_rocks < 60) {

		try {
			local random_coordinate = Vector(RandomInt(nexus_chamber_center.x - chamber_radius, nexus_chamber_center.x + chamber_radius), RandomInt(nexus_chamber_center.y - chamber_radius, nexus_chamber_center.y + chamber_radius), nexus_chamber_center.z)
			local random_speed = RandomInt(110, 260)
			local crumble_prop_model = nexus_rock_paths[RandomInt(0, nexus_rock_paths.len() - 1)]

			local crumble_rock_ent = SpawnEntityFromTable("prop_dynamic", {
				origin = random_coordinate,
				model = crumble_prop_model,
				angles = Vector(RandomInt(-360, 360), RandomInt(-360, 360), RandomInt(-360, 360)),

			})
			// printl("1")
			crumble_rock_ent.ValidateScriptScope()

			crumble_rock_ent.GetScriptScope().rock_speed <- random_speed;
			crumble_rock_ent.GetScriptScope().rotspeed <- random_speed * 0.5;
			crumble_rock_ent.GetScriptScope().CrumbleThink <- CrumbleThink;
			crumble_rock_ent.GetScriptScope().Explode <- Explode;
			// printl("2")
			nexus_active_rocks += 1

			AddThinkToEnt(crumble_rock_ent, "CrumbleThink")
			// printl("3")


		} catch (exception) {
			printl("DEV: rock crumbler had an error, this is not good but i have NO idea what it could be & it is may 8th so OH WELL")
			printl(exception)
		}
	} else {
		printl("too many rocks! not spawning any more")
	}
}

function CrumbleThink() { // think func for the falling rocks
	try {
		local pos = self.GetOrigin()
		local angles = self.GetAbsAngles()
		local trace = TraceLine(pos, pos, self);

		if (trace == 0) {
			nexus_active_rocks -= 1
			AddThinkToEnt(self, "")
			Explode()

		// 	AddThinkToEnt(self, "")
		// 	SpawnParticleAtPosition("rock_explosion_master", pos + Vector(0, 0, rock_speed * 0.5))
		// 	ScreenShake(pos, RandomFloat(10, 15), RandomInt(30, 60), RandomFloat(2, 3), 1024, 0, true)
		// 	PrecacheScriptSound("eltra/hb_quickexplode.mp3")
		// 	EmitSoundEx({
		// 		sound_name = "eltra/hb_quickexplode.mp3",
		// 		origin = pos,
		// 		sound_level = 0.27,
		// 		pitch = RandomFloat(95, 105),
		// 	})
		// 	self.Kill()
		}

		self.KeyValueFromVector("angles", Vector(angles.x + rotspeed, angles.y - rotspeed, angles.z - rotspeed))
		self.KeyValueFromVector("origin", pos - Vector(0, 0, rock_speed))

		local players_to_hurt = [];

		local i_player = null;
		while (i_player = Entities.FindByClassnameWithin(i_player, "player", pos, 64)) {
			players_to_hurt.append(i_player) // oml this was brokey for like 10 minutes because i kept doing Append() and not append() i HATE you squirre >:(
		}
		local player_iterator_num = 0;
		for (local i = 0; i < players_to_hurt.len(); i += 1) {
			players_to_hurt[i].TakeDamage(40, 1, null); // is it bad if attacker is null ?
		}





	} catch (exception) {
		printl("\n\n\n\nROCK LOGIC ERROR: " + exception)
	}


	return 0.1
}

// Spin Tornado

function SpawnSpinner() { // the tractor bea meffect
	QFire("s5_nexusalpha_sf_tractorbeam", "PlaySound", "", 0.0, null)
	local spinner_ent = SpawnEntityFromTable("logic_relay", {
		origin = Vector(nexus_chamber_center.x, nexus_chamber_center.y, base_floor_position)
	})
	spinner_ent.ValidateScriptScope()
	local spinner_scope = spinner_ent.GetScriptScope()
	spinner_scope.wave_speed <- RandomFloat(0.1, 0.4)
	spinner_scope.amp <- 100
	spinner_scope.wave_progress <- 0
	spinner_scope.SpinThink <- SpinThink;
	spinner_scope.base_floor_position <- base_floor_position
	spinner_scope.pos <- Vector(nexus_chamber_center.x, nexus_chamber_center.y, base_floor_position)
	local EndTime = 7.0

	AddThinkToEnt(spinner_ent, "SpinThink")
	// QFire("s5_nexusalpha_pushtriggers", "Enable", "", 0.0, null)
	QFire("s5_nexusalpha_fx_rise", "Start", "", 0, null)
	QFire("s5_nexusalpha_fx_rise", "Stop", "", 4, null)
	QFire("s5_nexusalpha_fx_fall", "Start", "", 5, null)
	QFire("s5_nexusalpha_fx_fall", "Stop", "", EndTime, null)

	QFireByHandle(spinner_ent, "Kill", "", 6, null, null);
	// QFire("s5_nexusalpha_pushtriggers", "Disable", "", EndTime, null)

}

function SpinThink() { // the tractor beam think
	local wave_height = sin(wave_progress) * 100
	wave_progress += 0.0523
	try {

		local players_to_suck = [];
		local i_player = null;
		while (i_player = Entities.FindByClassnameWithin(i_player, "player", pos, chamber_radius * 5)) {
			if (i_player.GetTeam() == 3) {
				// printl("i suck u")
				players_to_suck.append(i_player)

			}
		}
		// printl("spin think")
		local player_iterator_num = 0;
		for (local i = 0; i < players_to_suck.len(); i += 1) {
			local playa = players_to_suck[i]
			if (playa.GetOrigin().z - base_floor_position < 1.0) {
				playa.SetAbsOrigin(playa.GetOrigin() + Vector(0, 0, 1))
			}
			local ppos = Vector(0, 0, wave_height*500) //+ players_to_suck[i].GetOrigin()
			ppos.x += RandomFloat(-1, 1)*wave_height*0.05
			ppos.y += RandomFloat(-1, 1)*wave_height*0.05

			local fvel = playa.GetAbsVelocity() + ppos
			fvel.z = clamp(fvel.z, 0, wave_height*1.5)
			playa.SetAbsVelocity(fvel)

			return 0.1
		}
	} catch (exception) {
		printl("SPINNER LOGIC ERROR: " + exception)
	}

}

function TakeNexusDamage(activator) { // when u shoot the nexus breakable this happens
	try {

		if (nexus_damageable == true && nexus_health >= 0) {
			nexus_health -= 1
			if (nexus_health == 0) {
				End()
				return
			}
			if (nexus_health < nexus_injured_health && nexus_state == nexus_states.healthy) {
				nexus_state = nexus_states.injured
			}
			if (nexus_health < nexus_panic_health && nexus_state == nexus_states.injured) {
				nexus_state = nexus_states.panic
			}
		} else {
			if (nexus_active == true && nexus_damageable == false) {
				ClientPrint(activator, 4, "*** THE NEXUS REDIRECTED YOUR BULLETS! YOU NEED TO FIND SOME WAY TO DISTRACT IT ***")
			// activator.TakeDamage(1, 2, null)
			}
		}

	} catch (exception) {
		printl("\n\n\n\n\n\nEXCEPTION IN NEXUS ALPHA DAMAGE CODE: " + exception)
	}

}

function Bombed() { // when dorothy hits the nexus
	nexus_damageable = true;
	QFire("s5_nexusalpha_sf_damaged", "PlaySound", "", 0.0, null);
	// QFire("s5_nexusalpha_t", string action, string value = null, float delay = 0, handle activator = null)
	MapSay("*** THE NEXUS' SHIELD IS DOWN! SHOOT! ***")
	QFire("s5_nexusalpha", "SetAnimation", "injure", 0.0, null)
	QFire("s5_nexusalpha", "SetAnimation", "injuring_idle", 5.0, null)

	QFireByHandle(self, "RunScriptCode", "nexus_damageable = false", 8.0, null, null);
	QFire("s5_nexusalpha", "SetAnimation", nexus_animations[nexus_state], 8.0, null)
	QFire("s5_nexusalpha", "SetDefaultAnimation", nexus_animations[nexus_state], 8.0, null)
}

function ScaleBossHealth() { // boss scale
	local i_player = null;
	while (i_player = Entities.FindByClassname(i_player, "player")) {
		if (i_player.GetTeam() == 3) {

			nexus_health += nexus_health_per_player
		}
	}
	nexus_max_health = nexus_health
	nexus_injured_health = nexus_max_health * 0.5
	nexus_panic_health = nexus_max_health * 0.25
	printl("Scaled nexus health is " + nexus_health)
}

function SpawnHopeDroplet() { // trump spawns dorothy in pipe
	QFire("s5_nexus_sf_hope_droplet", "PlaySound", "", 0.0, null)
	QFire("tem_hopeful_spirit", "ForceSpawn", "", RandomFloat(8, 16), null)
}

function End() {
	try {
		QFire("s5_mus_nexusalpha_b", "Kill", "", 0.1, null);
		QFire("nexus_injured_spinner_master", "KillHierarchy", "", 0.0, null)
		nexus_damageable = false
		QFire("s5_mus_nexusalpha_b", "Volume", "0", 0.0, null)
		printl("end events stuff triggered")
		MapSayWithDelay("*** YOU DID IT - THE NEXUS IS DEFEATED!!! ***",  1.0)
		MapSayWithDelay("*** THE WHOLE BUILDING IS COMING DOWN - JUST HANG ON A LITTLE BIT LONGER!! ***",  2.0)
		MapSayWithDelay("*** SURVIVE ***",  4.0)
		QFireByHandle(self, "RunScriptCode", "CeilingCrumble()", 4.0, null, null);
		QFireByHandle(self, "RunScriptCode", "CeilingCrumble()", 7.0, null, null);


		QFire("s5_nexusalpha_actions_timer", "Disable", "", 0.00, null)
		QFire("s5_nexusalpha_random_hope_timer", "Disable", "", 0.00, null)
		QFire("s5_nexusalpha_shaketimer", "Enable", "", 0.00, null)
		QFire("s5_nexusalpha_dyingfog", "Enable", "", 0.0, null);
		QFire("s5_nexusalpha_death_fade", "Fade", "", 12.0, null);
		QFire("s5_credits_relay", "Trigger", "", 28.0, null);
		QFire("scripts_nexusalpha", "RunScriptCode", "AllWatchCamera()", 28.0, null);
		QFire("s5_nexusalpha_dyingfog", "Disable", "", 21.0, null);
		QFire("scripts_main", "RunScriptCode", "SetMapFog(`fog_hyper`)", 28.0, null);

		// nexus final attacks!






		nexus_active = false;
		AddThinkToEnt(self, "")

		QFire("s5_nexusalpha_deathsound", "PlaySound", "", 0, null);
		// QFire("s5_nexusalpha_deathsound", "PlaySound", "", 0, null);
		QFire("s5_nexusalpha_shaketimer", "FireTimer", "", 0, null);
		QFire("s5_nexusalpha_shaketimer", "Enable", "", 0, null);
	} catch (exception){
		printl(exception)
	}

}

function AllWatchCamera() {
	local i_player = null

	while (i_player = Entities.FindByClassname(i_player, "Player"))
	{
		QFire("credits_viewcontrol", "Enable", "", 0.0, i_player)

	}

}

function Explode() {

	local pos = self.GetOrigin() + Vector(0, 0, 100)
	local angles = self.GetAbsAngles()


	local players_to_hurt = [];

	local i_player = null;
	while (i_player = Entities.FindByClassnameWithin(i_player, "player", pos, 128)) {
		players_to_hurt.append(i_player)
	}
	local player_iterator_num = 0;
	for (local i = 0; i < players_to_hurt.len(); i += 1) {
		players_to_hurt[i].TakeDamage(RandomInt(50, 75), 1, null);
	}


	SpawnParticleAtPosition("rock_explosion_master", pos)
	// ScreenShake(Vector vecCenter, float flAmplitude, float flFrequency, float flDuration, float flRadius, int eCommand, bool bAirShake)
	ScreenShake(pos, RandomFloat(1500, 850), RandomInt(1100, 5000), RandomFloat(4, 6), 1024, 0, true)
	PrecacheScriptSound("eltra/hb_quickexplode.mp3")
	EmitSoundEx({
		sound_name = "eltra/hb_quickexplode.mp3",
		origin = pos,
		sound_level = 0.27,
		pitch = RandomFloat(95, 105),
	})
	self.Kill()





}