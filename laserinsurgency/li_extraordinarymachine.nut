hDriver <- null;
hPassenger <- null;
iDriverAttachID <- null;
iPassengerAttachID <- null;
iDrivingTime <- 0
iRed <- 1;

const CAR_MAX_HEALTH = 300
const CAR_SPEED_FORWARD = 600
const CAR_SPEED_SIDEWAYS = 250
const CAR_SPEED_BACKWARD = 300
const EXIT_COOLDOWN_TIME = 50
const SND_RAND01 = "eltra/em_mus_01.mp3"
const SND_EXIT01 = "eltra/em_lock.mp3"
const SND_BELL = "eltra/em_bell.mp3"
const SND_FUCKYOU = "vo/k_lab/eli_shutdown.wav"
iHealth <- CAR_MAX_HEALTH;

// enum HCLASSES {
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

// buttons


enum DIRECTIONS {
	FORWARD,
	BACKWARD,
	LEFT,
	RIGHT,
}

function OnPostSpawn() {
	self.ValidateScriptScope()
	local tempTname = UniqueString("_extraordinary")
	SpawnEntityFromTable("phys_keepupright", {
		attach1 = tempTname,
		angularlimit = 2,
		angles = "0 90 0",
		origin = self.GetOrigin(),
		parent = tempTname

	})

	self.AcceptInput("health","999999",null,null)
	iDriverAttachID = self.LookupAttachment("driver")
	iPassengerAttachID = self.LookupAttachment("passenger")
	self.SetCollisionGroup(4)
	self.ConnectOutput("OnPlayerUse","PlayerUsed")
	self.ConnectOutput("OnTakeDamage","OnTakeDamage")
}

function DoCarMotion(iDirection) {

	local qCarAngles = self.GetAbsAngles()
	local qCarOrigin = self.GetOrigin()
	local qCarVelocity = self.GetAbsVelocity()

	local vVelocityAdd = null;

	switch (iDirection) {
		case DIRECTIONS.FORWARD:
			vVelocityAdd = qCarVelocity + (qCarAngles.Forward() * CAR_SPEED_FORWARD)
			self.SetPhysVelocity(vVelocityAdd)
			break;
		case DIRECTIONS.BACKWARD:

			vVelocityAdd = qCarVelocity +(qCarAngles.Forward() * -CAR_SPEED_BACKWARD)
			self.SetPhysVelocity(vVelocityAdd)
			break;
		case DIRECTIONS.LEFT:
			// qCarAngles.y += CAR_SPEED_SIDEWAYS
			self.ApplyLocalAngularVelocityImpulse(qCarAngles.Up() * CAR_SPEED_SIDEWAYS)
			break;
		case DIRECTIONS.RIGHT:
			// qCarAngles.y -= CAR_SPEED_SIDEWAYS
			self.ApplyLocalAngularVelocityImpulse(qCarAngles.Up() * -CAR_SPEED_SIDEWAYS)
			break;
		default:
			break;
	}
	self.SetPhysVelocity(self.GetPhysVelocity() + Vector(0,0,-9.8))
}

function DriveThink() {
	local bCloseEnough = false
	local aNearPlayers = []
	for (local i= null; i = Entities.FindByClassnameWithin(i, "player", self.GetOrigin(), 64);) {
		aNearPlayers.append(i)
		if (i == hDriver) {
			bCloseEnough = true
		}
	}

	local iFuckYou = 14
	if (bCloseEnough && ValidEntity(hDriver) && (hDriver.GetScriptScope().iPlayerHClass != HCLASSES.LI_CLASS_EDTWT) && (RandomInt(-1000,1000) != iFuckYou)) {


		self.SetCollisionGroup(1)
		hDriver.SetMoveType(0,0)
		hDriver.SetAbsVelocity(Vector(0,0,0))
		hDriver.KeyValueFromVector("origin",self.GetAttachmentOrigin(iDriverAttachID) + Vector(0,0,6))
		// NetProps.SetPropInt(hDriver, "m_MoveType", 5)

		if (ButtonPressed(hDriver, IN_ATTACK)) {
			PlaySound(SND_BELL, self.GetOrigin())
		}
		if (ButtonPressed(hDriver, IN_FORWARD)) {
			DoCarMotion(DIRECTIONS.FORWARD)
		}
		if (ButtonPressed(hDriver, IN_MOVELEFT)) {
			DoCarMotion(DIRECTIONS.LEFT)
		}
		if (ButtonPressed(hDriver, IN_MOVERIGHT)) {
			DoCarMotion(DIRECTIONS.RIGHT)
		}
		if (ButtonPressed(hDriver, IN_BACK)) {
			DoCarMotion(DIRECTIONS.BACKWARD)
		}
		if (iDrivingTime >= EXIT_COOLDOWN_TIME) {
			if (ButtonPressed(hDriver, IN_USE)) {
				StopDriving()

			}
		}
		iDrivingTime++

	}
	else {
		PlaySound(SND_FUCKYOU, self.GetOrigin())
		StopDriving()

	}
	return -1
}

function WaitThink() {

}

function PlayerUsed() { // for some reason it provides itself as activator so we need to run a trace to find the real player
	local hPlayer = Entities.FindByClassnameNearest("player", self.GetOrigin(), 64)

	if (!ValidEntity(hDriver) && iDrivingTime == 0) {
		if (ButtonPressed(hPlayer, IN_USE)) {
			StartDriving(hPlayer)

		}
	}

}

function StartDriving(hPlayer) {

	if (ValidEntity(hPlayer)) {

		iDrivingTime = 0
		PlaySound(SND_RAND01, self.GetOrigin())
		hDriver = hPlayer
		hPlayer.SetMoveType(3,0)
		// hDriver.SetCollisionGroup(10)
		AddThinkToEnt(self, "DriveThink")
	}
}

function StopDriving() {
	self.SetCollisionGroup(3)
	QFireByHandle(self, "RunScriptCode","self.SetCollisionGroup(4)", 3, null, null)
	if (ValidEntity(hDriver)) {
		PlaySound(SND_EXIT01, self.GetOrigin())
		// hDriver.SetCollisionGroup(8)
		NetProps.SetPropInt(hDriver, "m_MoveType", 2)
		hDriver = null;
		AddThinkToEnt(self, "")
		QFireByHandle(self, "RunScriptCode", "iDrivingTime = 0", 0.2, null, null)

	}
}

function OnTakeDamage() {
	iRed += 1/255
	self.AcceptInput("rendercolor", iRed.tostring() + " 0 0", null,null)
	iHealth -= 1
	if (iHealth == 0) {
		self.Kill()
	}
}