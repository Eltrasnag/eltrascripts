IsLowered <- true
MoveSpeed <- 5
BasePosition <- self.GetOrigin()
MoveLength <- 0
NextReleaseTime <- 0
ReleaseWaitTime <- 1
Active <- true
Moving <- true
NextCheckPos <- null;
Accel <- 0

MoveVector <- null;

function Precache() {
	self.KeyValueFromInt("spawnflags", 0)
}

function OnPostSpawn() {
	local context = GetContext(self)
	MoveVector = NetProps.GetPropVector(self, "m_vecMoveDir")
	MoveVector.Norm()
	local hKillTrigger = Spawn("trigger_hurt", { targetname = "crusher_trigger", origin = self.GetOrigin() + (MoveVector * 2), damagetype = 1, damage = 99999999, spawnflags = 64, model = GetBrushModel(self)})
	local trigmin = self.GetBoundingMinsOriented()
	local right = self.GetRightVector()
	local forward = self.GetForwardVector()
	trigmin += right * -3
	trigmin -= forward * -3
	trigmin -= self.GetUpVector() * 1
	local trigmax = self.GetBoundingMaxsOriented()
	trigmax -= right * -3
	trigmax += forward * -3
	trigmax += self.GetUpVector() * 1


	// NetProps.SetPropInt(hKillTrigger,(GetBrushModel(self))
	// hKillTrigger.SetModelScale(0.98, 0)
	hKillTrigger.SetSize(trigmin, trigmax)
	hKillTrigger.SetSolid(2)
	SetParentEX(hKillTrigger, self)

	hKillTrigger.ValidateScriptScope()

	hKillTrigger.GetScriptScope().CrushedPlayer <- CrushedPlayer

	hKillTrigger.ConnectOutput("OnStartTouch", "CrushedPlayer")

	local m_flStartPosition = NetProps.GetPropFloat(self, "m_flStartPosition")


	MoveLength = NetProps.GetPropFloat(self, "m_flMoveDistance") - NetProps.GetPropFloat(self, "m_flLip")
	// MoveLength = NetProps.GetPropFloat(self, "m_flMoveDistance") - NetProps.GetPropFloat(self, "m_flLip")
	// ReleaseWaitTime = NetProps.GetPropFloat(self, "m_flWait")

	if ("lowered" in context && context.lowered == 0) {
		IsLowered = false

		NextCheckPos = BasePosition + MoveVector * MoveLength
	} else {
		NextCheckPos = BasePosition
		// NextCheckPos = self.GetOrigin() + (self.GetUpVector() * MoveLength)
	}

	MoveSpeed = NetProps.GetPropFloat(self, "m_flSpeed")
	self.SetAbsOrigin(BasePosition + (MoveVector * MoveLength * m_flStartPosition))
	// if ("movespeed" in context) {
		// MoveSpeed = context.movespeed
	// }

	if ("wait" in context) {
		ReleaseWaitTime = context.wait
	}

	NextReleaseTime = Time() + 0
	AddThinkToEnt(self, "Think")
}

function Think() {
	if (!Moving || !Active) {
		return -1
	}
	local vOrigin = self.GetOrigin()
	local nextorigin = GetMovementVector(NextCheckPos, vOrigin)

	DebugDrawLine_vCol(vOrigin, NextCheckPos, Vector(0, 255, 0), false, 1)
	// printl(GetDistance(vOrigin, NextCheckPos))
	// printl(GetDistance(vOrigin, NextCheckPos) < MoveSpeed)
	// printl("nextcheckpos = "+NextCheckPos)
	// printl("vOrigin = "+vOrigin)
	if (GetDistance(NextCheckPos, vOrigin + nextorigin) < Accel * MoveSpeed * 0.4) {
		// printl("STOP!!!!!!!!!!!")

		IsLowered == true
		nextorigin = NextCheckPos // hacky hack
		self.SetAbsOrigin(NextCheckPos)
		switch (IsLowered) {
			case true:
				NextCheckPos = (BasePosition)
				// printl("IsLowered is true. This means it is time to start lowering to the BasePosition.")
				IsLowered <- false
			break;

			case false:
				IsLowered <- true
				// NextCheckPos = (BasePosition + self.GetUpVector() * MoveLength)
				NextCheckPos = BasePosition + MoveVector * MoveLength // trying something new
				// printl("IsLowered is false. This means it is time to start rising to the top position.")
			break;
		}

		Moving = false
		ScreenShake(vOrigin, 2* Accel * 4 * MoveSpeed, 1, RandomInt(1,2), MoveLength*2.25, SHAKE_START, true)
		if (IsLowered == true) {
			IsLowered == false
		} else {
			ImpactSound()
			IsLowered == true
		}
		QFireByHandle(self, RunScriptCode, "Moving = true",  ReleaseWaitTime)
		QFireByHandle(self, RunScriptCode, "ReleaseSound()", ReleaseWaitTime)
		QFireByHandle(self, RunScriptCode, "Accel = 0",  ReleaseWaitTime)
		return -1
	}


	Accel += FrameTime() * MoveSpeed
	if (IsLowered == true) {
		self.KeyValueFromVector("origin", vLerp(vOrigin, vOrigin + nextorigin, Accel * MoveSpeed))
	} else if (IsLowered == false) {

		self.KeyValueFromVector("origin", vOrigin + nextorigin * Accel * 1)
	}
	// Accel += LerpFloat(0, 1, FrameTime() * MoveSpeed)
	return 0.05
}

function ReleaseSound() {
	PlaySoundEX("ambient/machines/wall_move"+RandomInt(1,4)+".wav", NextCheckPos, 100, RandomInt(95,110), self)
	PlaySoundEX("eltra/metal_tear_scrape.mp3", NextCheckPos, 100, RandomInt(50,60), null, 10000)
	PlaySoundEX("eltra/metal_tear_scrape.mp3", NextCheckPos, 100, RandomInt(60,50), null, 10000)
	PlaySoundEX("eltra/metal_tear_scrape.mp3", NextCheckPos, 100, RandomInt(40,60), null, 10000)
}

function ImpactSound() {
	// PlaySoundEX("ambient/machines/wall_move"+RandomInt(1,4)+".wav", NextCheckPos, 100, RandomInt(95,110), self)
	local vOrigin = self.GetOrigin() - MoveVector * MoveLength
	local str = "physics/concrete/boulder_impact_hard"+RandomInt(1,4)+".wav"
	PlaySoundEX("misc/doomsday_lift_stop.wav", vOrigin, 100, RandomInt(70,100), null, 10000 )
	PlaySoundEX("misc/doomsday_lift_stop.wav", vOrigin, 100, RandomInt(80,100), null, 10000 )
	PlaySoundEX("misc/doomsday_lift_stop.wav", vOrigin, 100, RandomInt(90,100), null, 10000 )
}

function CrushedPlayer() {
	activator.ValidateScriptScope()
	if (activator.IsPlayer()) {
		QFireByHandle(activator, RunScriptCode, "(ScreenFade(self, 255, 0, 0, 254, 3, 0.2, FFADE_IN))", 0)
	}
	PlaySoundNPC("eltra/crusher_playerkill.mp3", activator)
	PlaySoundNPC("eltra/crusher_playerkill.mp3", activator)
	PlaySoundNPC("eltra/crusher_playerkill.mp3", activator)
	PlaySoundNPC("eltra/crusher_playerkill.mp3", activator)
	if (activator.GetClassname() == "base_boss") { // we are crushing an npc
		local npc = activator.GetOwner()
		if (!npc) return;
		npc.ValidateScriptScope()
		local scope = npc.GetScriptScope()
		if ("Death" in scope)
			scope.Death()

	}




}

function InputFireUser1() { // marauder ON
	AddThinkToEnt(self, "Think")
	Active = true;
}

function InputFireUser2() { // marauder off
	AddThinkToEnt(self, "")
	Active = false;
}