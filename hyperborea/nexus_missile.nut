enum teams {
	ct = 3,
	t = 2,
}

stop_time <- Time() + 1.5
target <- null;
hit_spot <- null;
hit_spot_maker <- Entities.FindByName(null, "s5_death_circle_maker");
permadelta <- null;

function OnPostSpawn() {
	target = GetRandomCT()

	AddThinkToEnt(self, "MissileThink")
}

function MissileThink() {
	local origin = self.GetOrigin()
	local trace = TraceLinePlayersIncluded(origin, origin, self);

	if (trace == 0) {
		AddThinkToEnt(self, "")
		Explode()
	}
	if (target != null && target.IsValid()) {


		if (Time() < stop_time - 1) {
			hit_spot = target.GetOrigin()
			local look_angle = QAngle(0, atan2(hit_spot.y - origin.y, hit_spot.x - origin.x), 0) * (180 / PI) // atan2(hit_spot.z - origin.z, hit_spot.y - origin.y)
			self.SetAbsAngles(look_angle)
			hit_spot = target.GetOrigin()
			permadelta = GetMoveDelta(hit_spot, self.GetOrigin())
			hit_spot_maker.AcceptInput("ForceSpawnAtEntityOrigin", "!activator", target, null);
		}

		if (Time() >= stop_time) {
			self.KeyValueFromVector("origin", origin - permadelta * 150)



		}
	}
	else {
		target = GetRandomCT()

	}
	return 0.1
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
		players_to_hurt[i].TakeDamage(40, 1, null);
	}


	SpawnParticleAtPosition("rock_explosion_master", pos)
	ScreenShake(pos, RandomFloat(38, 85), RandomInt(30, 60), RandomFloat(2, 3), 1024, 0, true)
	PrecacheScriptSound("eltra/hb_quickexplode.mp3")
	EmitSoundEx({
		sound_name = "eltra/hb_quickexplode.mp3",
		origin = pos,
		sound_level = 0.27,
		pitch = RandomFloat(95, 105),
	})
	self.Kill()





}

function PrecacheParticle(name) // thank u fvdc :D
{
	PrecacheEntityFromTable({ classname = "info_particle_system", effect_name = name })
}