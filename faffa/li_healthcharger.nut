iHealthToGive <- 240

aPlayers <- []

iActive <- false
iLastActive <- iActive
iDenyTimer <- 0

hChargeLoop <- SpawnEntityFromTable("ambient_generic", {
		message = "items/medcharge4.wav",
		origin = self.GetOrigin(),
		spawnflags = 16,
		health = 10,
	})


function Precache() {
	PrecacheSound("items/medcharge4.wav")
	PrecacheScriptSound("WallHealth.LoopingContinueCharge")
	PrecacheScriptSound("WallHealth.Start")
}
function OnPostSpawn() {
	self.KeyValueFromInt("spawnflags", 1025)
	self.ConnectOutput("OnUse", "OnUse")

	printl("Healthcharger spawned at: "+self.GetOrigin().tostring())
	AddThinkToEnt(self, "Think")

}

function OnUse() {
	printl("Activator: "+activator.tostring())
}


function Think() {
	local vOrigin = self.GetOrigin()

	if (iHealthToGive > 0) {
		for (local hPly; hPly = Entities.FindByClassnameWithin(hPly, "player", vOrigin, 100);) {
			if (ButtonPressed(hPly, IN_USE) && GetDistance(hPly.GetOrigin(),vOrigin) < 150) {
				local iPlyHealth = hPly.GetHealth()
				local iPlyMaxHealth = NetProps.GetPropInt(hPly,"m_iMaxHealth")
				if (iPlyHealth < iPlyMaxHealth) {
					hPly.SetHealth(iPlyHealth += 1)
					iActive = true
					iDenyTimer = 0
					iHealthToGive--
				}
				else {
					if (iDenyTimer == 0) {

						PrecacheSound("items/medshotno1.wav")
						EmitSoundOn("items/medshotno1.wav",self)

					}
					iActive = false
					iDenyTimer++
				}
				continue
			}
			iActive = false
			iDenyTimer = 0
		}


	}
	else {
		iActive = false
	}

	if (iActive != iLastActive) {
		switch (iActive) {
			case true: // charger turned on
				PrecacheScriptSound("WallHealth.Start")
				EmitSoundOn("WallHealth.Start", self)
				hChargeLoop.AcceptInput("PlaySound","",null,null)
				QFireByHandle(hChargeLoop, "PlaySound", "", 0.0, null, null)
				break;
			case false: // charger turned off
				QFireByHandle(hChargeLoop, "StopSound", "", 0.0, null, null)
				hChargeLoop.AcceptInput("StopSound","",null,null)
				if (iHealthToGive <= 0) {
					AddThinkToEnt(self, "")

					PrecacheSound("items/medshotno1.wav")
					EmitSoundOn("items/medshotno1.wav",self)
					self.KeyValueFromVector("rendercolor", Vector(60,0,0))
				}
				break;
		}
	}

	// if (iDenyTimer > 4) {
		// iDenyTimer = 0
	// }

	// iDenyTimer++
	iLastActive = iActive

	return 0.1
}

