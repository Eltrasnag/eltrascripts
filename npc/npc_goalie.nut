IncludeScript("eltrasnag/npc/npc_base.nut", this)

NPC_TARGET_RADIUS <- 500
NPC_IS_CLIFF_SMART <- false
NPC_AUTODECAY <- false
// NPC_OVERRIDE_ANGLE <- QAngle(0,-90,0)
ANIM_FOLLOW <- "skating"
ANIM_IDLE <- "idle"
ANIM_DEATH <- "die"
AGGRESSION_COOLDOWN <- RandomInt(1,7)
DownAccel <- 1

IsBossSlave <- false

HockeySlapRange <- 128 // range to slap with stick
HockeySlapWait <- 0
HockeySlapCooldown <- 3 // wait time

// fm sounds

SF_AGGRESSION <- "eltra/fm_hit.mp3"
SF_DEATH <- "eltra/fm_death.mp3"



NPC_CHASE_SPEED <- 240

function CustomSpawn() {
	// hVisModel.SetModelScale(0.5, 0)
	if ("FURBOSS" in getroottable()) {
		IsBossSlave = true
		FURBOSS.iActiveNPCs++
	}
	hBossBase.SetResolvePlayerCollisions(true)
	hVisModel.SetSkin(RandomInt(0,3))

}

function CustomDeath() {
	if (IsBossSlave) {
		FURBOSS.iActiveNPCs--
		FURBOSS.iNPCsLeft--
	}
	hVisModel.SetLocalAngles(QAngle(0, RandomInt(0, 360), 0))

}

function CustomWake() {
	QAcceptInput(hVisModel, "SetPlaybackRate", "0.5")


}
function CustomIdle() {

}
function CustomSleep() {
	SetAnimation(hVisModel, "ready"+RandomInt(1,3))
}

function CustomActive() {
	local vOrigin = self.GetOrigin()
	if (GetDistance2D(vOrigin, hTarget.GetOrigin()) < HockeySlapRange) {
		StickSlap()
	}
	// local ent;
	// while (ent = Entities.FindByTarget(null, "furboss_crusher")) {
	// 	if (GetDistance(ent, vOrigin) < 512) {
	// 		printl("BRUH")
	// 		Death()
	// 		return

	// 	}
	// }
}

function StickSlap() {
	if (HockeySlapWait <= Time()) {
		printl("slap")

		HockeySlapWait = HockeySlapCooldown + Time()
		SetAnimation(hVisModel, "stickslap"+RandomInt(1,3))
		QFireByHandle(self, "RunScriptCode", "SkateReset()", 1)
		local tOrigin = hTarget.GetOrigin()
		local vOrigin = self.GetOrigin()

		local toAngle = LookAngles(vOrigin, tOrigin)
		hTarget.SetAbsVelocity(hTarget.GetAbsVelocity() + (toAngle * -1000) + Vector(0,0,500))
	}
}

function SkateReset() { // check if run anim should be re-started after attack
	if (hTarget && hTarget != null) {
		SetAnimation(hVisModel, "skating")
	}
}