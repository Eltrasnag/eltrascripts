iType <- null;
iPaired <- null;
hGunScope <- null;

iTimer <- 0;
vForV <- null;
vPortalColor <- null;


// enum HCLASSES { // YEP
// 	LI_CLASS_STRAIGHT,
// 	LI_CLASS_EDTWT,
// 	LI_CLASS_BISEXUAL,
// 	LI_CLASS_HUGGER,
// 	LI_CLASS_PHILLIPINO,
// 	LI_CLASS_SNEAKER,
// 	LI_CLASS_DEFENSE,
// 	LI_CLASS_LAURAPALMER,
// 	LI_CLASS_MEL,
// }

enum TEAMS {
	HUMANS = 3,
	ZOMBIES = 2,
	SPECTATORS = 1,
	UNASSIGNED = 0,
}

const SND_PORTAL_CLOSE = "eltra/portal_fizzle2.mp3"
const SND_PORTAL_PASS = "eltra/portal_enter1.mp3"

const PORTAL_COOLDOWN_LENGTH = 2
const MODEL_SCALE_ITERATOR = 0.01
const PORTAL_MAX_LIFETIME = 120
const PORTAL_TELEPORT_RADIUS = 32
const PORTAL_SPAWN_TIME = 0.25


iTeleportCooldown <- PORTAL_COOLDOWN_LENGTH;

function OnPostSpawn() { // YEP

	hGunScope.aPortals[iType] = self
	self.SetModelScale(1, PORTAL_SPAWN_TIME)

	// if (ValidHandle(hGunScope)) {
	// 	hGunScope.aPortals[iType] = self
	// }
	AddThinkToEnt(self, "Think")
}



function Think() {
	try {

		local vecOrigin = self.GetOrigin()




		if (iTimer == (PORTAL_MAX_LIFETIME - 25)) { // portal is 1 spawn length away from closing
			self.SetModelScale(0, PORTAL_SPAWN_TIME)
		}


		if (ValidHandle(hGunScope)) {





			local qAngles = self.GetAbsAngles()

			local hPaired = hGunScope.aPortals[iPaired]




			// PORTAL COOLDOWN ENDS:
			if (iTeleportCooldown > PORTAL_COOLDOWN_LENGTH) {


					local tRayOffset = qAngles.Forward() * 16
					local qDiag = (qAngles.Up() + qAngles.Left())

					local tPortalTrace = {
						enthit = null,
						start = vecOrigin + (qDiag * PORTAL_TELEPORT_RADIUS) + tRayOffset,
						end = vecOrigin + (qDiag * -PORTAL_TELEPORT_RADIUS) + tRayOffset,
						ignore = self,
					}

					TraceLineEx(tPortalTrace)

					// DebugDrawLine(tPortalTrace.start, tPortalTrace.end, 0, 255, 0, false, 0.1)


					// NEW: TRACE FOR PLAYER IN PORTAL
					if (ValidEntity(tPortalTrace.enthit) && (tPortalTrace.enthit.GetClassname() == "player" || tPortalTrace.enthit.GetClassname() == "prop_physics")) {

						local hPlayer = tPortalTrace.enthit
						local hClass = hPlayer.GetClassname()

						if (ValidEntity(hPaired) && ValidHandle(hGunScope)) {


							if (hClass == "player") {
								if (!(hPlayer.GetScriptScope().iPlayerHClass == HCLASSES.LI_CLASS_MEL || hPlayer.GetTeam() == TEAMS.ZOMBIES)) {
									return -1
								}
							}


							local hPairedScope = hPaired.GetScriptScope()

							hPairedScope.iTeleportCooldown = 0
							iTeleportCooldown = 0

							local vBeforeOrigin = hPlayer.GetOrigin()
							local vAfterOrigin = hPaired.GetOrigin() + (hPaired.GetForwardVector() * PORTAL_TELEPORT_RADIUS * 2.0)
							hPlayer.SetAbsOrigin(vAfterOrigin)
							// hPlayer.KeyValueFromVector("origin", vAfterOrigin)
							if (TraceLine(vAfterOrigin, vAfterOrigin + Vector(0, 0, 1), hPlayer) != 1) {
								hPlayer.SetAbsOrigin(vBeforeOrigin)
								// printl("PORTAL SYSTEM : Avoiding teleport due to bad dest")
								return
							}

							PlaySound(SND_PORTAL_PASS, vAfterOrigin)

							local qPairedAngles = hPaired.GetAbsAngles()
							local qPairedForward = hPaired.GetForwardVector()
							local vPlayerSpeed = clamp(hPlayer.GetAbsVelocity().Length(), 0, 1000)
							local vNewVelocity = Vector(qPairedForward.x, qPairedForward.y, qPairedForward.z) * vPlayerSpeed.tointeger();

							if (hClass == "player") {

								ScreenFade(hPlayer, hPairedScope.vPortalColor.x, hPairedScope.vPortalColor.y, hPairedScope.vPortalColor.z, 255, 0.2, 0.0, 1)
								hPlayer.SnapEyeAngles(qPairedAngles)

								hPlayer.SetAbsVelocity(vNewVelocity)
							}
							else {
								hPlayer.SetOrigin(vAfterOrigin)
								hPlayer.SetPhysVelocity(vNewVelocity)
							}






							// printl("PAIRED COOLDOWN: "+hPairedScope.iTeleportCooldown.tostring())


						}
					}
				}
			}
		iTeleportCooldown++
		iTimer++
		if (iTimer >= PORTAL_MAX_LIFETIME) {
			PlaySound(SND_PORTAL_CLOSE, vecOrigin)
			self.Kill()
			// if (ValidHandle(hGunScope) && ValidEntity(hGunScope.aPortals[iType])) {
				// hGunScope.aPortals[iType].Kill() // kill my self
			// }

		}
	} catch (exception){
		printl("Inshallah the portal system has errored but nobody needs to know that:D")
		// printl("\n\nPORTAL ERROR: DUMPING...\n\n\n")
		// printl("iTimer : "+iTimer.tostring())
		// printl("vForV : "+vForV.tostring())
		// printl("vPortalColor : "+vPortalColor.tostring())
		// printl("iPaired : "+iPaired.tostring())
		// printl("\n\nEXCEPTION: \n"+exception)
	}
	return 0.05
}