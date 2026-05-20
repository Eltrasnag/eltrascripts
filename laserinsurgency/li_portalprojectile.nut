PORTAL_PROJECTILE_SPEED <- 80*2
const SND_PORTAL_FAIL = "eltra/portal_invalid_surface3.mp3"
const MAX_LIFE_TIME = 40
enum PORTALS {
	PORTAL1,
	PORTAL2,
}

BANNED_SURFACES <- ["TOOLS/TOOLSSKYBOX"]
// the horrible awful surface check
const RAYDISTANCE = 4
enum RAYDIRECTIONS {
	FORWARD,
	BACK,
	LEFT,
	RIGHT,
	UP,
	DOWN,
}
// these correspond to the above enum
aTraceOffsets <- [Vector(1,0,0),
Vector(-1,0,0),
Vector(0,1,0),
Vector(0,-1,0),
Vector(0,0,1),
Vector(0,0,-1)]


vecLastOrigin <- null;
qMoveAngles <- null;
strOwnerID <- null;
iPortalType <- null;
fl_DeathTime <- 0;
hOwner <- null;
hGun <- null;
vForward <- null;
t_ShootTrace <- {};

function OnPostSpawn() {
	fl_DeathTime = Time() + 4
	AddThinkToEnt(self, "Think")
}


function Think() {
	// local vOrigin = self.GetOrigin()
	local vOrigin = self.GetOrigin()
	if (Time() >= fl_DeathTime) {
		AddThinkToEnt(self, "")
		FailDeath()
		return -1
	}

	if (t_ShootTrace != null && iPortalType != null && ValidEntity(hOwner)) {

		// dprintl(t_ShootTrace.pos)
		// local vNextOrigin = vOrigin + (qMoveAngles * PORTAL_PROJECTILE_SPEED)
		local vNextOrigin = vOrigin + (GetMovementVector(t_ShootTrace.pos, vOrigin) * PORTAL_PROJECTILE_SPEED)

		// {
			// hit = null,
			// start = vecLastOrigin,
			// end = vNextOrigin,
			// mask = 16395,
			// ignore = self,
			// }


		// local tTrace = QuickTrace(vecLastOrigin, vNextOrigin, h_Player)
			// if (vecLastOrigin != null && ValidEntity(h_Player)) {

				// TraceLineEx(tTrace)
			// DebugDrawLine(tTrace.start, tTrace.endpos, 255,255,255,false,0.5)
		// }

		self.KeyValueFromVector("origin", vNextOrigin)

		// dprintl("Brup")
		if ((GetDistance(vOrigin, t_ShootTrace.pos) < PORTAL_PROJECTILE_SPEED) && t_ShootTrace.hit == true && t_ShootTrace.enthit == Entities.First() && ValidEntity(hGun) && ValidEntity(hOwner)) {
			if (BANNED_SURFACES.find(t_ShootTrace.surface_name) != null) {
				AddThinkToEnt(self, "")
				FailDeath()
				return -1
			}

			local vecNormal = t_ShootTrace.plane_normal
			self.LookAt(vOrigin + (t_ShootTrace.plane_normal))


			// if (ValidEntity(hGun) && ValidEntity(hOwner) && (QuickTrace(vOrigin, t_ShootTrace.pos).plane_dist) <= PORTAL_PROJECTILE_SPEED) {
				dprintl("ok the portal hit")
				hGun.ValidateScriptScope()
				local paramstable = {
					type = iPortalType,
					endpos = t_ShootTrace.pos,
				}
				paramstable.trace <- t_ShootTrace
				hGun.GetScriptScope().PortalHitSurface(paramstable)
				AddThinkToEnt(self, "")
				// FailDeath()
				self.Kill()
				return 0.1
			// }

		}
		// vecLastOrigin = vOrigin
	}
	else {
		dprintl("fail, ", ValidEntity(hOwner))
		AddThinkToEnt(self, "")
		FailDeath()
		return 0.1
	}

	// iTimer++
	return 0.1

}

function FailDeath() {
	PlaySound(SND_PORTAL_FAIL, self.GetOrigin())
	self.Kill()
	return
}