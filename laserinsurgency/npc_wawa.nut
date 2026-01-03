hTarget <- null;

iHealth <- 60;

vTextOffset <- Vector(0,0,48) // height of health text

iHurtRadius <- 64

iAttackingTime <- 0
iRetargetTime <- 70


// STOP USING CONSTANTS WITH GENERIC NAMES !!!!!!!!!!!! THEY ARE GLOBAL AND BREAK EVERYTHING !!!!!!
NPC_SPEED <- 300

// OVERLAY_MEOWTRON <- "eltra/fatcat.vmt"

SF_NPC_HURT <- "eltra/pussurveyor_damage.mp3";
SF_NPC_ALERT <- "eltra/pussurveyor_float.mp3";
SF_NPC_TAKEDAMAGE <- "eltra/pussurveyor_ouch.mp3";
MODELNAME <- "models/kawasaniac/wawa_cat_cube.mdl";
NPC_RADIUS <- 368;
NPC_DAMAGE <- 6;


PrecacheModel(MODELNAME)

iLifeTime <- 0
iMaxLifeTime <- 600
hModel <- null
iLoopLength <- 30
iLoopTimer <- 0

hText <- SpawnEntityFromTable("point_worldtext", {
    color = "242 226 225 255",
    font = 5,
    message = "",
    orientation = 1,
    origin = self.GetOrigin() + vTextOffset,
    parent = self,
})

strName <- UniqueString("_wawa")

hSound <- null

iPositionTimer <- 0

iTargetNodeIndex <- 0
vTargetNodes <- []
bNodeTick <- false

function OnPostSpawn() {
	self.KeyValueFromString("targetname",strName)
    self.DisableDraw()

	self.SetModelSimple(BRUSHMODELS.wawa_hitbox)
	self.KeyValueFromString("overridescript","damping,10,rotdamping,10,friction,0")

	local hKeepUpright = SpawnEntityFromTable("phys_keepupright", {
		attach1 = strName,
		angularlimit = 45,
		angles = "0 0 0"
	})

	SetParentEX(hKeepUpright, self)

	// create the visual model separate from the true hitbox
    hModel = SpawnEntityFromTable("prop_dynamic", {
		DefaultAnim = "idle",
        model = MODELNAME,
        // solid = 0,
    })

    SetParentEX(hText,self)

	// create npc music
    hSound = SpawnEntityFromTable("ambient_generic", {
    message = SF_NPC_ALERT,
    health = 10,
    radius = 1250,
    origin = self.GetOrigin(),
	spawnflags = 48,
    SourceEntityName = strName,

	})
	hSound.AcceptInput("PlaySound","",null,null)

    hModel.SetForwardVector(self.GetForwardVector())
    hModel.SetAbsOrigin(self.GetOrigin())
    SetParentEX(hModel,self)
    self.ConnectOutput("OnTakeDamage","OnTakeDamage")
    NetProps.SetPropInt(self, "m_iMinHealthDmg", 1)
    AddThinkToEnt(self, "IdleThink")
    self.SetCollisionGroup(1)
}

// waiting for activation
function IdleThink() {

	if (iLoopTimer >= iLoopLength) {
		iLoopTimer = 0
		hSound.AcceptInput("PlaySound","",null,null)
	}
	iLoopTimer++

    if (iLifeTime >= iMaxLifeTime) {
        CleanUp()
        return
    }

	iLifeTime++

    local vOrigin = self.GetOrigin()

	PickTarget()
	return
}

function PickTarget() {
	iAttackingTime = 0

    for (local iPlayer; iPlayer = Entities.FindByClassnameWithin(iPlayer, "player", self.GetOrigin(), NPC_RADIUS);) {
    	if (iPlayer.GetTeam() == TEAMS.HUMANS) {
    		hTarget = iPlayer
			AddThinkToEnt(self, "Think")


    	}
    }
}

function PickTargetRandom() {
	iAttackingTime = 0
	local aPlyArray = []

    for (local iPlayer; iPlayer = Entities.FindByClassname(iPlayer,"player");) {
    	if (iPlayer.GetTeam() == TEAMS.HUMANS) {
			aPlyArray.append(iPlayer)

    	}
    }

	hTarget = aPlyArray[RandomInt(0, aPlyArray.len() - 1)]
	AddThinkToEnt(self, "Think")
}

// activated
function Think() {

	if (iLoopTimer >= iLoopLength) {
		iLoopTimer = 0
		hSound.AcceptInput("PlaySound","",null,null)
	}
	iLoopTimer++

    if (iLifeTime >= iMaxLifeTime) {
        CleanUp()
        return
    }

    iLifeTime++

    switch (bNodeTick) {
        case true:
            bNodeTick = false
            break;
        case false:
            bNodeTick = true
            break;
    }

    local vOrigin = self.GetOrigin()
    local vAngle = self.GetAbsAngles()



    if (ValidEntity(hText)) {
        hText.KeyValueFromString("message", "| HP: "+iHealth.tostring()+"|")
    }


    if (bNodeTick) {
        // ScreenShake(vOrigin, 7, 5, 3, 2048, 2 | 3, true)
        for (local iPlayer; iPlayer = Entities.FindByClassnameWithin(iPlayer,"player",vOrigin,iHurtRadius);) {
            PlaySound(SF_NPC_HURT, vOrigin)
			printl("Wrath")
            ScreenFade(iPlayer, 255,0,0, 60, 0.01, 0.1, 1)
			iPlayer.TakeDamage(NPC_DAMAGE, 1, null)
            // QFireByHandle(iPlayer, "RunScriptCode", "self.TakeDamage(NPC_DAMAGE, 1, null)", 0.5, null, null)
        }

    }

	if (ValidEntity(hTarget) && hTarget != null) {
		local vTOrigin = hTarget.GetOrigin()
		local qFaceAngles = GetLookAngle(vOrigin, vTOrigin)
		local qFaceAnglesForward = qFaceAngles.Forward()

		local qSelfForward = self.GetAbsAngles().Forward()

		local vHeightAdd = Vector(0,0,100)


		if (vOrigin.z - vTOrigin.z >= 50) { // too high!
			vHeightAdd.z = 0
		}

		local TraceEnd = vOrigin + self.GetAbsAngles().Forward() * 16 // trace which goes out from npc's face to detect any obstructions


		// DebugDrawLine(vOrigin, TraceEnd,255,0,0,false,0.1) // debug

		if (TraceLine(vOrigin, TraceEnd, self) < 1) { // apply the npc physics movement
			self.ApplyAbsVelocityImpulse(qSelfForward * NPC_SPEED)
			self.SetForwardVector(qFaceAnglesForward)
		}
		else {
			self.SetForwardVector(qFaceAnglesForward)
			// self.ApplyLocalAngularVelocityImpulse(Vector(qFaceAngles) * 100)
			self.ApplyAbsVelocityImpulse(qSelfForward * NPC_SPEED + vHeightAdd)
		}


		qFaceAngles.z = 0
		self.SetLocalAngles(qFaceAngles)
		self.SetAbsAngles(qFaceAngles)

	}

	if (iAttackingTime >= iRetargetTime) {
		PickTargetRandom()
	}

	iAttackingTime++
    return 0.1
}

function OnTakeDamage() { // npc takes damage
    // printl("Ow")
    iHealth--
    if (iHealth < 1) {
        // do death stuff
        CleanUp()
        return
    }
	PlaySound(SF_NPC_TAKEDAMAGE, self.GetOrigin())
	self.ApplyAbsVelocityImpulse((self.GetForwardVector() * -2000)) // npc takes 'knockback'

    hModel.SetModelScale(RandomFloat(1.03,1.1),0) // visual feedback
    hModel.SetModelScale(1,0.1)

    hModel.KeyValueFromString("rendercolor", "255 0 0")
    QFireByHandle(hModel, "color", "255 255 255", 0.1, null, null)
}

function CleanUp() {
	AddThinkToEnt(self, "")
	try {
		hSound.Kill()
		hText.Kill()
		self.AcceptInput("KillHierarchy","", null, null)

	} catch (exception){
		printl("wawa killed by extraneous method - what ever")
	}
}