const PORTAL_PROJECTILE_SPEED = 80
const SND_PORTAL_FAIL = "eltra/portal_invalid_surface3.mp3"
const MAX_LIFE_TIME = 40
enum PORTALS {
	PORTAL1,
	PORTAL2,
}

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


vecLastOrigin <- self.GetOrigin();
iTimer <- 0;
qMoveAngles <- null;
strOwnerID <- null;
iPortalType <- null;
hOwner <- null;
hGun <- null;
vForward <- null;

function OnPostSpawn() {
	AddThinkToEnt(self, "Think")
}

function Think() {
	local vOrigin = self.GetOrigin()

	if (qMoveAngles != null && iPortalType != null && ValidEntity(hOwner) && iTimer < MAX_LIFE_TIME) {


		local vNextOrigin = vOrigin + (qMoveAngles * PORTAL_PROJECTILE_SPEED)


		// local tTrace = {
		// hit = null,
		// start = vecLastOrigin,
		// end = vNextOrigin,
		// mask = 16395,
		// ignore = self,
		// }
		local tTrace = QuickTrace(vecLastOrigin, vNextOrigin, hOwner, MASK_PORTAL)



		self.KeyValueFromVector("origin", vNextOrigin)

		if (tTrace.hit && "fraction" in tTrace && tTrace.fraction != 1) {

			// getting the normal for portal placement
			// this sucks and is bad
			local vecNormal = null

			local vHitPos = tTrace.endpos

			// get the """""surface normal""""" by doing 4 checks around the collision point
			local aTraces = [];

			for (local i = 0; i < 6; i++) {
				aTraces.append(TraceLine(vHitPos, vHitPos + (aTraceOffsets[i] * 1), self))
			}

			for (local i = 0; i < 6; i++) {

				local flTraceFrac = aTraces[i]

				if (aTraces[i] != 1) {
					vecNormal = aTraceOffsets[i]
					break;
				}

				if (vecNormal == null && i == 5) {
					PlaySound(SND_PORTAL_FAIL,vOrigin)
					self.Kill()
					return
				}

			}

			if (ValidEntity(hGun) && ValidEntity(hOwner) && vecNormal != null) {
				hGun.GetScriptScope().PortalHitSurface({
					"type" : iPortalType,
					"forv" : vecNormal,
					"endpos" : tTrace.endpos,
				})
			}

			self.Kill()
			return
		}
		vecLastOrigin = vOrigin
	}
	else {
		PlaySound(SND_PORTAL_FAIL,vOrigin)
		self.Kill()
		return
	}

	iTimer++
	return 0.1

}