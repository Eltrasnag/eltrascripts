hTarget <- null;
iHealth <- 1000;
vTextOffset <- Vector(0,0,32)

GOO_LOOP <- "eltra/npc_goo_loop.mp3";
GOO_HURT <- "music/stingers/industrial_suspense2.wav";
GOO_KILL <- "eltra/npc_goo_consume.mp3"
MODELNAME <- "models/eltra/gobbledy_goo.mdl";
PrecacheSound(GOO_HURT)
PrecacheModel(MODELNAME)

ALERT_RADIUS <- 512;
HURT_RADIUS <- 32;
FOLLOW_SPEED <- 5;


iLifeTime <- 0
iMaxLifeTime <- 600
hModel <- null
iLoopLength <- 287.1
iLoopTimer <- 0
        // hText.KeyValueFromVector("origin", )

hText <- SpawnEntityFromTable("point_worldtext", {
    color = "60 122 78 255",
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
    self.KeyValueFromString("targetname",strName)
	self.KeyValueFromInt("disableshadows",1)
	// ENABLE IF SELF IS TO BE USED AS THE HITBOX
    // self.DisableDraw()
    // hModel = SpawnEntityFromTable("prop_dynamic", {
    //     model = MODELNAME,
    //     // solid = 0,
    // })
    // hModel.SetForwardVector(self.GetForwardVector())
    // hModel.SetAbsOrigin(self.GetOrigin())
    // SetParentEX(hModel,self)

    SetParentEX(hText,self)

    hSound = SpawnEntityFromTable("ambient_generic", {
    message = GOO_LOOP,
    health = 10,
    radius = 1250,
    origin = self.GetOrigin()
    SourceEntityName = strName,

})

    self.ConnectOutput("OnTakeDamage","OnTakeDamage")
    NetProps.SetPropInt(self, "m_iMinHealthDmg", 1)
    AddThinkToEnt(self, "IdleThink")
    self.SetCollisionGroup(1)
}

function IdleThink() {

    if (iLifeTime >= iMaxLifeTime) {
        CleanUp()
        return
    }
    iLifeTime++

    local vOrigin = self.GetOrigin()
    for (local iPlayer; iPlayer = Entities.FindByClassnameWithin(iPlayer,"player",vOrigin,ALERT_RADIUS);) {
    	if (iPlayer.GetTeam() == TEAMS.HUMANS) {
            hTarget = iPlayer
            AddThinkToEnt(self, "Think")
			SetAnimation(self,"globby")
			return
    	}
    }
}

function ClearTarget() {
	hTarget = null;
	AddThinkToEnt(self, "IdleThink")
}

function Think() {
    if (iLifeTime >= iMaxLifeTime) {
        CleanUp()
        return
    }
    iLifeTime++
    switch (iLoopTimer) {
        case 0:

            hSound.AcceptInput("PlaySound","",null,null)
			iLoopTimer++
            break;
        case iLoopLength:
			hSound.AcceptInput("PlaySound","",null,null)
            iLoopTimer = 0
            break;
        default:
			iLoopTimer++
            break;

    }






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


    if (!ValidEntity(hTarget)) {
        hTarget = RandomCT()
        return
    }

    // player data
    local vTargetOrigin = hTarget.GetOrigin()
    local vTargetAngles = hTarget.GetAbsAngles()

    // actual npc stuff

    if (bNodeTick) {
        ScreenShake(vOrigin, 7, 5, 3, 2048, 2 | 3, true)
        for (local iPlayer; iPlayer = Entities.FindByClassnameWithin(iPlayer,"player",vOrigin,HURT_RADIUS);) {
			if (iPlayer.GetTeam() == TEAMS.HUMANS && IsAlive(iPlayer)) {
				// self.TakeDamage(5, 1, null)
				// QFireByHandle(iPlayer, "RunScriptCode", "self.TakeDamage(50, 1, null)", 0.5, null, null)
				ScreenFade(iPlayer, 255,0,0, 255, 0.3, 0.0, 1)
				iPlayer.ValidateScriptScope()
				local iPlayerScope = iPlayer.GetScriptScope()
				PlaySoundEX(GOO_KILL, vOrigin)
				iPlayerScope.Consumption <- Consumption
				iPlayerScope.GOO_HURT <- GOO_HURT
				// iPlayerScope. <-
				AddThinkToEnt(iPlayer, "Consumption")
				if (iPlayer == hTarget) {
					ClearTarget()
				}


			}
        }

    }


    local tPlayerTrace = {
        start = vOrigin + Vector(0,0,128),
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

    local vNextOrigin = vOrigin +  qAngleTo.Forward() * FOLLOW_SPEED

    self.KeyValueFromVector("origin", vNextOrigin)


    return 0.1
}

function OnTakeDamage() {
    iHealth--
    if (iHealth < 1) {
        CleanUp()
        return
    }
    self.SetAbsOrigin(self.GetOrigin() + (self.GetForwardVector() * -2))

	// IF USING A CHILD AS THE MODEL VISUAL:
    // hModel.SetModelScale(RandomFloat(1.03,1.1),0)
    // hModel.SetModelScale(1,0.1)
    // hModel.KeyValueFromString("rendercolor", "255 0 0")
    // QFireByHandle(hModel, "color", "255 255 255", 0.1, null, null)

	// IF USING OURSELF AS THE MODEL VISUAL:
    self.SetModelScale(RandomFloat(1.03,1.1),0)
    self.SetModelScale(1,0.1)
    self.KeyValueFromString("rendercolor", "255 0 0")
    QFireByHandle(self, "color", "255 255 255", 0.1, null, null)

}

function CleanUp() {
    hSound.Kill()
    // hModel.Kill() // COMMENT OUT THIS LINE IF USING SELF AS VISUAL MODEL
    hText.Kill()
    self.AcceptInput("KillHierarchy","", null, null)
}

function Consumption() {
	local vOrigin = self.GetOrigin()
	local vEyeOrigin = self.EyePosition()
	printl("VORE")
	if (TraceLine(vEyeOrigin, vEyeOrigin, self) == 0) {
		self.TakeDamage(9999,1,null)
		PlaySoundEX(GOO_HURT,vOrigin)

		ClientPrint(null,3,"\x07d90000THE GOBBLEDY GOO CONSUMES ANOTHER VICTIM... " + GetPlayerName(self).toupper())
		AddThinkToEnt(self, "")
		return
	}

	self.KeyValueFromVector("origin", (vOrigin - Vector(0, 0, 32)))
	return 0.1
}