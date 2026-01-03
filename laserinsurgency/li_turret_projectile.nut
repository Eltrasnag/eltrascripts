const TURRET_PROJECTILE_SPEED = 60;
const EXPLOSION_MAGNITUDE = 50;
const BLAST_RADIUS = 128;

vLastOrigin <- Vector(0,0,0);
strUniqueName <- "";

enum TEAMS {
	HUMANS = 3,
	ZOMBIES = 2,
	SPECTATORS = 1,
	UNASSIGNED = 0,
}

function OnPostSpawn() {
	AddThinkToEnt(self, "Think")
}

function Think() {

	local vOrigin = self.GetOrigin()
	local vNextOrigin = (vOrigin + (self.GetAbsAngles().Forward() * TURRET_PROJECTILE_SPEED))

	self.KeyValueFromVector("origin", vNextOrigin)

	local tTrace = {
	hit = null,
	start = vLastOrigin,
	end = vNextOrigin,
	mask = 16395,
	ignore = self,
	endpos = null,
	fraction = 1,
	}

	TraceLineEx(tTrace)

	if (tTrace.fraction != 1) {
		local vHit = tTrace.endpos

		local hExplosion = SpawnEntityFromTable("env_explosion", {
			origin = vHit,
			iMagnitude = EXPLOSION_MAGNITUDE,
			rendermode = 5,
			ignoredEntity = strUniqueName,
		})

		for (local hPlayer; hPlayer = Entities.FindByClassnameWithin(hPlayer, "player", vHit, BLAST_RADIUS);) {
			if (hPlayer.GetTeam() == TEAMS.ZOMBIES) {
				local vPos = hPlayer.GetOrigin()
				local vBlastAng = atan2(vPos.y - vHit.y, vPos.x - vHit.x)

				local vExplosionVelocity = Vector(vPos.x - vHit.x, vBlastAng, vPos.z - vHit.z)
				vExplosionVelocity.Norm()

				hPlayer.SetAbsVelocity(vExplosionVelocity * EXPLOSION_MAGNITUDE)


			}
		}
		hExplosion.AcceptInput("Explode","",null,null)
		hExplosion.Kill()
		self.Kill()

	}
	vLastOrigin = vOrigin
	return 0.1
}