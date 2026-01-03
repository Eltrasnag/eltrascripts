hOwner <- null;
iTimer <- 0;
iShootTimer <- 0;
iEyeAttachID <- null;
iDeathTimer <- 0;

const TURRET_MAX_TIP = 45
const MDL_TURRET_PROJECTILE = "models/weapons/w_missile.mdl"
const TURRET_COOLDOWN = 3
const TURRET_MAX_LIFETIME = 600;
const TURRET_SIGHT_RANGE = 4096;
const TURRET_MAX_SHOOTTIME = 40;
const TURRET_DEATH_TIME = 20;

iShootWait <- TURRET_COOLDOWN;
hActiveTarget <- null;
strUniqueName <- UniqueString("_turret");

enum TEAMS {
	HUMANS = 3,
	ZOMBIES = 2,
	SPECTATORS = 1,
	UNASSIGNED = 0,
}

function OnPostSpawn() {
	iEyeAttachID = self.LookupAttachment("eyes")
	AddThinkToEnt(self,"Think")
	self.KeyValueFromString("targetname",strUniqueName)
}

function Think() {

	local flTipAmount = abs(self.GetLocalAngles().z)

	if (iDeathTimer >= TURRET_DEATH_TIME || iTimer >= TURRET_MAX_LIFETIME) {

		if (ValidEntity(hOwner)) {
			hOwner.GetScriptScope().iDefenseTurretCount--
		}

		self.Kill()
	}

	if (flTipAmount >= TURRET_MAX_TIP) {

		iDeathTimer++
		return 0.1
	}

	local vOrigin = self.GetOrigin()
	local qAngles = self.GetAbsAngles()
	local vForv = qAngles.Forward()
	local vEyeOrigin = self.GetAttachmentOrigin(iEyeAttachID)
	local flTimeSine = sin(Time()*5)
	if (iTimer <= TURRET_MAX_LIFETIME) {

		local tTrace = {
			start = vEyeOrigin,
			end = vOrigin + (vForv * TURRET_SIGHT_RANGE) + (qAngles.Left() * flTimeSine * 600),
			ignore = self,
			enthit = null
		}

		DebugDrawLine(tTrace.start,tTrace.end,255,0,0,false,0.1)
		TraceLineEx(tTrace)

		local hTarget = tTrace.enthit

		if (ValidEntity(hTarget) && hTarget.GetClassname() == "player" && hTarget.GetTeam() == TEAMS.ZOMBIES && hTarget != hActiveTarget) {
			hActiveTarget = hTarget

			iShootTimer = 0
		}


	}

	if (ValidEntity(hActiveTarget) && iShootWait >= TURRET_COOLDOWN && iShootTimer <= TURRET_MAX_SHOOTTIME) {
		local vSpawnOrigin = vEyeOrigin + vForv * 16

		local tProjectile = {
			classname = "prop_dynamic",
			model = MDL_TURRET_PROJECTILE,
			origin = vSpawnOrigin,
			vscripts = "eltrasnag/laserinsurgency/li_turret_projectile.nut",

		}

		PrecacheEntityFromTable(tProjectile)

		local hProjectile = SpawnEntityFromTable("prop_dynamic", tProjectile)

		hProjectile.SetForwardVector(self.GetForwardVector() + (Vector(cos(Time()*3),sin(Time()*2),sin(Time()*3))) * 0.1)
		hProjectile.ValidateScriptScope()
		local hProjectileScope = hProjectile.GetScriptScope()
		hProjectileScope.vLastOrigin <- vSpawnOrigin
		hProjectileScope.strUniqueName <- strUniqueName

		iShootWait = 0
	}

	if (iShootTimer > TURRET_MAX_SHOOTTIME) {
		hActiveTarget = null
	}







	printl("TURRET LOCAL ANGLES: " + self.GetLocalAngles())
	iShootWait++
	iShootTimer++
	iTimer++
	return 0.1
}