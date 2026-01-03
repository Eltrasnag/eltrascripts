hTarget <- null;
iHealth <- 250;
vTextOffset <- Vector(0,0,48)

// STOP USING CONSTANTS WITH GENERIC NAMES !!!!!!!!!!!! THEY ARE GLOBAL AND THEY BREAK EVERYTHING !!!!!!
GARF_SPEED <- 27
OVERLAY_GARFIELD <- "eltra/fatcat.vmt"
GARF_HURT <- "music/stingers/industrial_suspense2.wav"
MODELNAME <- "models/eltra/garfus.mdl"
GARF_RADIUS <- 368;
ouches <- 25;
PrecacheModel(MODELNAME)

iLifeTime <- 0
iMaxLifeTime <- 600
hModel <- null
iLoopLength <- 240
iLoopTimer <- 0

hText <- SpawnEntityFromTable("point_worldtext", {
    color = "255 147 7 255",
    font = 5,
    message = "",
    orientation = 1,
    origin = self.GetOrigin() + vTextOffset,
    parent = self,
})

strName <- UniqueString("_fatcat")

hSound <- null

iPositionTimer <- 0

iTargetNodeIndex <- 0
vTargetNodes <- []
bNodeTick <- false

function OnPostSpawn() {
    self.SetModelScale(0.5,0)
    self.KeyValueFromString("targetname",strName)
    self.DisableDraw()
	self.SetModelSimple(BRUSHMODELS.garf_collidebox)

    hModel = SpawnEntityFromTable("prop_dynamic", {
		DefaultAnim = "idle",
        model = MODELNAME,
        // solid = 0,
    })
    SetParentEX(hText,self)

    hSound = SpawnEntityFromTable("ambient_generic", {
    message = "eltra/fatcat.mp3",
    health = 10,
    radius = 1250,
    origin = self.GetOrigin()
    SourceEntityName = strName,
	spawnflags = 48,
	})

    hModel.SetForwardVector(self.GetForwardVector())
    hModel.SetAbsOrigin(self.GetOrigin())
    SetParentEX(hModel,self)
    self.ConnectOutput("OnTakeDamage","OnTakeDamage")
    NetProps.SetPropInt(self, "m_iMinHealthDmg", 1)
    AddThinkToEnt(self, "IdleThink")
    self.SetCollisionGroup(1)
}

function IdleThink() {
    local vOrigin = self.GetOrigin()
    for (local iPlayer; iPlayer = Entities.FindByClassnameWithin(iPlayer,"player",vOrigin,GARF_RADIUS);) {
    	if (iPlayer.GetTeam() == TEAMS.HUMANS) {
            hTarget = iPlayer
            AddThinkToEnt(self, "Think")

			return
    	}
    }
}

function Think() {
	PrecacheScriptSound("Dirt.StepLeft")
	PrecacheScriptSound("Dirt.StepRight")


    if (iLifeTime >= iMaxLifeTime) {
        CleanUp()
        return
    }
    iLifeTime++
    switch (iLoopTimer) {
        case 0:
			SetAnimation(hModel, "run", true)
			// SetAnimation(hModel, "chase", true)
            hSound.AcceptInput("PlaySound","",null,null)
			iLoopTimer++
            break;
        case iLoopLength:
            iLoopTimer = 0
            break;
        default:
    		iLoopTimer++

            break;

    }





    switch (bNodeTick) {
        case true:
			EmitSoundOn("Dirt.StepLeft", self)
            bNodeTick = false
            break;
        case false:
			EmitSoundOn("Dirt.StepRight", self)
            bNodeTick = true
            break;
    }

    local vOrigin = self.GetOrigin()
    local vAngle = self.GetAbsAngles()

    local tGroundTrace = {
        start = vOrigin + Vector(0,0,32),
        end = vOrigin - Vector(0,0,64),
        ignore = self,
        mask = 16449,
        endpos = null,
        plane_dist = null
    }

    TraceLineEx(tGroundTrace)

    if (ValidHandle(tGroundTrace.endpos)) {
        vOrigin = tGroundTrace.endpos
    }



    if (ValidEntity(hText)) {
        hText.KeyValueFromString("message", "| HP: "+iHealth.tostring()+"|")
    }


    if (!ValidEntity(hTarget) || !IsAlive(hTarget)) {
        hTarget = RandomCT()
        return
    }

    // player data
    local vTargetOrigin = hTarget.GetOrigin()
    local vTargetAngles = hTarget.GetAbsAngles()

    // actual npc stuff

	ClientPrint(hTarget, 4, "RUN")
    if (bNodeTick) {
        ScreenShake(vOrigin, 7, 5, 3, 2048, 2 | 3, true)
        for (local iPlayer; iPlayer = Entities.FindByClassnameWithin(iPlayer,"player",vOrigin,32);) {
            PlaySoundEX(GARF_HURT,vOrigin)
            iPlayer.SetScriptOverlayMaterial(OVERLAY_GARFIELD)
            QFireByHandle(iPlayer,"RunScriptCode","self.SetScriptOverlayMaterial(``)",0.5,null,null)
            QFireByHandle(iPlayer, "RunScriptCode", "self.TakeDamage(25, 1, null)", 0.5, null, null)
            ScreenFade(iPlayer, 255,255,255, 255, 0.5, 0.5, 1)
        }

    }


    local tPlayerTrace = {
        start = vOrigin + Vector(0,0,64),
        end = vTargetOrigin,
        ignore = self,
        endpos = null
        plane_dist = null
        hit = false,
        mask = 16449,
    }

    TraceLineEx(tPlayerTrace)




    vTargetNodes.append(vTargetOrigin) //  + Vector(RandomInt(-32,32), RandomInt(-32,32), 0)

    if (!tPlayerTrace.hit) {

        if (iTargetNodeIndex != 0) {
            iTargetNodeIndex = 0
            vTargetNodes.clear()
        }

        if (vTargetNodes.len() >= 10) {
            vTargetNodes.remove(0)
        }



    }
    else {

        if (iTargetNodeIndex < vTargetNodes.len()) {
            vTargetOrigin = vTargetNodes[iTargetNodeIndex]
            if (GetDistanceTo(vTargetOrigin, vOrigin) < 64) {
                iTargetNodeIndex++
            }

        }
        if (iTargetNodeIndex >= 200) {
            vTargetNodes.clear()
            hTarget = RandomCT()
        }

        // DebugDrawLine(vOrigin, vTargetOrigin, 255,0,0,false,0.1)
    }



    local qAngleTo = GetAngleTo(vTargetOrigin, vOrigin)

    self.SetAbsAngles(qAngleTo)

    local vNextOrigin = vOrigin +  qAngleTo.Forward() * GARF_SPEED

    self.KeyValueFromVector("origin", vNextOrigin)

    // if (TraceLine(vNextOrigin,vNextOrigin,self)) {

    // }
    // if (TraceLine(vNextOrigin, vNextOrigin,self) == 0) {
    //     CleanUp()
    //     return
    // }
    return 0.1
}

function OnTakeDamage() { // grandma takes dmg ouch
    printl("Ow")
    iHealth--
    if (iHealth < 1) {
        // do death stuff
        CleanUp()
        return
    }
    self.SetAbsOrigin(self.GetOrigin() + (self.GetForwardVector() * -2))
    hModel.SetModelScale(RandomFloat(1.03,1.1),0) // visual feedback
    hModel.SetModelScale(1,0.1)
    hModel.KeyValueFromString("rendercolor", "255 0 0")
    QFireByHandle(hModel, "color", "255 255 255", 0.1, null, null)
}

function CleanUp() {
    hSound.Kill()
    hModel.Kill()
    hText.Kill()
    self.AcceptInput("KillHierarchy","", null, null)
}