hProp <- null; // the prop player is holding...
iScore <- 0;

// PLAYER CONSTANTS
const USE_REACH = 80
const COLLISION_GROUP_DEBRIS = 1
const COLLISION_GROUP_INTERACTIVE = 4
const IN_USE = 32
const IN_ATTACK = 1

// PLAYER VARIABLES
bUsing <- false;
iUseIncrement <- 0;
bLastUsing <- false;
hButton <- null;
vecPropPos <- Vector(0,0,0)

bPoisoned <- false
iToxic <- 0.0;
hToxicText <- null;
vToxicTextColor <- Vector(252, 3, 3)

const PLAYER_TOXICITY_ADD = 0.5

function OnPostSpawn() {
	print("executing player script...")
}
function CreateHUDText(text_x = 0.5,text_y = 0.5,text_color = Vector(255,255,255), channel = 0) {

	local text_ent = SpawnEntityFromTable("game_text", {
		color = text_color.ToKVString(),
		fadein = 0,
		fadeout = 0,
		message = "",
		holdtime = 0.5,
		channel = channel,
		x = text_y,
		y = text_x,
		spawnflags = 0,
	})
	return text_ent
}

function OnPlayerSpawn() {
	bPoisoned = false
	hToxicText = null
	iToxic = 0


}

function HumanThink() {

	if (iToxic > 0) {

		if (hToxicText == null) {
			hToxicText = CreateHUDText(0.2,0.2, vToxicTextColor, 3)
		}

		hToxicText.KeyValueFromString("message", "|| TOXICITY : " + floor(iToxic).tostring() + " ||")
		QFireByHandle(hToxicText, "Display", "", 0.0 ,self)
	}

	switch (iToxic) {
		case 0:
			if (hToxicText != null) {
				hToxicText.KeyValueFromString("message", "|| TOXICITY : 0 ||")
				hToxicText.Kill()
				hToxicText = null

			}
			break;
		case 100:
			self.TakeDamage(1, 3, self);
			break;
	}



	SharedThink()

	switch (bPoisoned) {
		case true:
			iToxic += PLAYER_TOXICITY_ADD
			break;
		case false:
			iToxic --

			break;
	}

	iToxic = clamp(iToxic,0,100)

	return -1
}

function ZombieThink() {
	SharedThink()
	return -1
}

function SharedThink() { # things 2 share between both thinkies
	// bUsing = false
	local player_buttons = NetProps.GetPropInt(self, "m_nButtons")
	bUsing = false

	local EyeAng = self.EyeAngles()
	local EyePos = self.EyePosition()

	local EyeTrace = {
		start = EyePos,
		end = EyePos + EyeAng.Forward() * USE_REACH,
		ignore = self,

	}

	TraceLineEx(EyeTrace)



	if (player_buttons & IN_USE) {
		bUsing = true
 	}

	if (player_buttons & IN_ATTACK) {
		if (hProp != null) {
			hProp.ApplyAbsVelocityImpulse(EyeAng.Forward()*2000)
			PropDrop()
		}
 	}
	if (bUsing != bLastUsing) {

		if (bLastUsing == false) { // pressed
			UseFunc(EyeTrace)

			printl("use has been pressed")
		}

		if (bLastUsing == true) { // unpressed

			printl("use has been let go of")
			if (hButton != null) {
				hButton.GetScriptScope().ReleaseButton(self)
				hButton = null
				return -1
			}
		}
	}


	if (hButton != null && GetDistance(EyeTrace.pos, hButton.GetOrigin()) >= 32) {
		hButton.GetScriptScope().ReleaseButton(self)
	}


	if (hProp != null && hProp.IsValid()) {

		local EyeForward = EyeAng.Forward()
		local HoldVec = EyePos + EyeForward * USE_REACH
		local PropTrace = {
			start = EyePos,
			end = HoldVec,
			ignore = self,
			mask = 131083
		}

		TraceLineEx(PropTrace)
		DebugDrawLine(EyePos, PropTrace.pos * USE_REACH, 0, 255, 0, false, 0.5)

		local HoldDistance = GetDistance(HoldVec, PropTrace.pos)

		HoldVec = PropTrace.pos - (EyeForward*2)
		// if (PropTrace.pos.Length() > HoldVec.Length()) {
		// }
		vecPropPos = HoldVec
		hProp.KeyValueFromVector("origin", HoldVec)
		if ("enthit" in EyeTrace && EyeTrace.enthit != hProp) {
			PropDrop()
		}
	}
	else {
		hProp = null
	}


	bLastUsing = bUsing

	if (hButton != null && "enthit" in EyeTrace && EyeTrace.enthit == hButton) {
		return -1
	}
	else if (hButton != null){
		hButton.GetScriptScope().ReleaseButton(self)
		hButton = null
	}

	return -1
}

function UseFunc(EyeTrace) {
	local EyePos = self.EyePosition()
	local EyeAng = self.EyeAngles()

	DebugDrawLine(EyePos, EyePos + EyeAng.Forward() * USE_REACH, 0, 255, 0, false, 0.5)
	TraceLineEx(EyeTrace)
	if (!("enthit" in EyeTrace)) {
		if (hProp != null) {
			PropDrop()
			return
		}
		return
	}
	// PUT AAAAALL USE STUFF AFTER HERE!!!!!!



	local EntityName = EyeTrace.enthit.GetName()


	if (startswith(EyeTrace.enthit.GetClassname(), "prop_physics")) {
		if (hProp == null || EyeTrace.enthit != hProp) { // prop is picked up
			hProp = EyeTrace.enthit
			// QFireByHandle(hProp,"DisableMotion")
			hProp.SetCollisionGroup(COLLISION_GROUP_DEBRIS)

		}
		return
	}





	if ( ("door_button_left" == EntityName || "door_button_right" == EntityName)) {
		local door_button = EyeTrace.enthit
		local ButtonScope = door_button.GetScriptScope()
		printl("Pressign a button now")
		if (ButtonScope.hButtonPresser == null && ButtonScope.iButtonState == BUTTON_STATES.RELEASED) {
			ButtonScope.PressButton(self)
		}
		else {
			if (ButtonScope.hButtonPresser == self) {
				ButtonScope.ReleaseButton(self)
				hButton = null
			}
		}
		return
	}


}


function PropDrop() {
	print("leave prop")
	// hProp = EyeTrace.enthit
	hProp.SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
	// hProp.SetAbsOrigin(hProp.GetOrigin())
	hProp.SetOrigin(vecPropPos)

	QFireByHandle(hProp,"EnableMotion")
	hProp.ApplyAbsVelocityImpulse(self.GetAbsVelocity())
	hProp = null


}