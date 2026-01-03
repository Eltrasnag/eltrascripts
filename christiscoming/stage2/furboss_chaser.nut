IncludeScript("eltrasnag/npc/npc_base.nut", this)

NPC_TARGET_RADIUS <- 3000
NPC_IS_CLIFF_SMART <- false
NPC_AUTODECAY <- false
NPC_OVERRIDE_ANGLE <- QAngle(0,-90,0)
ANIM_FOLLOW <- "run"
ANIM_IDLE <- "idle"
ANIM_DEATH <- "die"
AGGRESSION_COOLDOWN <- RandomInt(1,7)
DownAccel <- 1

// fm sounds

SF_AGGRESSION <- "eltra/fm_hit.mp3"
SF_DEATH <- "eltra/fm_death.mp3"



NPC_CHASE_SPEED <- 240
function CustomSpawn() {
	hVisModel.SetModelScale(0.5, 0)
	FURBOSS.iActiveNPCs++

}

function CustomDeath() {
	FURBOSS.iActiveNPCs--
	FURBOSS.iNPCsLeft--
	hVisModel.SetLocalAngles(QAngle(0, RandomInt(0, 360), 0))
}

function CustomWake() {
	QAcceptInput(hVisModel, "SetPlaybackRate", "0.5")


}
function CustomIdle() {

}
function CustomSleep() {

}

function CustomActive() {
	// local ent;
	// while (ent = Entities.FindByTarget(null, "furboss_crusher")) {
	// 	if (GetDistance(ent, vOrigin) < 512) {
	// 		printl("BRUH")
	// 		Death()
	// 		return

	// 	}
	// }
}