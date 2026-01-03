hTarget <- null;

iHealth <- 250;

vTextOffset <- Vector(0,0,48) // height of health text

iHurtRadius <- 128

// STOP USING CONSTANTS WITH GENERIC NAMES !!!!!!!!!!!! THEY ARE GLOBAL AND BREAK EVERYTHING !!!!!!
NPC_SPEED <- 27

// OVERLAY_MEOWTRON <- "eltra/fatcat.vmt"

SF_NPC_HURT <- "music/stingers/industrial_suspense2.wav"
MODELNAME <- "models/asianbop/coolprops/u13/bmonster.mdl"
const NPC_RADIUS = 368
const NPC_DAMAGE = 25

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
    self.KeyValueFromString("targetname",strName)
    self.DisableDraw()

	self.SetModelSimple(BRUSHMODELS.wawa_hitbox)

	// create the visual model separate from the true hitbox
    hModel = SpawnEntityFromTable("prop_dynamic", {
		DefaultAnim = "idle",
        model = MODELNAME,
        // solid = 0,
    })

    SetParentEX(hText,self)

	// create npc music
    // hSound = SpawnEntityFromTable("ambient_generic", {
    // message = "eltra/fatcat.mp3",
    // health = 10,
    // radius = 1250,
    // origin = self.GetOrigin()
    // SourceEntityName = strName,

	// })

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
    local vOrigin = self.GetOrigin()
    for (local iPlayer; iPlayer = Entities.FindByClassnameWithin(iPlayer,"player",vOrigin,NPC_RADIUS);) {
    	if (iPlayer.GetTeam() == TEAMS.HUMANS) {
            hTarget = iPlayer
            AddThinkToEnt(self, "Think")

			return
    	}
    }
}

// activated
function Think() {


    if (iLifeTime >= iMaxLifeTime) {
        CleanUp()
        return
    }

    iLifeTime++

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



    if (ValidEntity(hText)) {
        hText.KeyValueFromString("message", "| HP: "+iHealth.tostring()+"|")
    }


    if (bNodeTick) {
        ScreenShake(vOrigin, 7, 5, 3, 2048, 2 | 3, true)
        for (local iPlayer; iPlayer = Entities.FindByClassnameWithin(iPlayer,"player",vOrigin,iHurtRadius);) {
            PlaySoundEX(SF_NPC_HURT,vOrigin)
			self.TakeDamage(NPC_DAMAGE, 1, null)
            ScreenFade(iPlayer, 255,0,0, 25, 0.5, 0.5, 1)
            // QFireByHandle(iPlayer, "RunScriptCode", "self.TakeDamage(NPC_DAMAGE, 1, null)", 0.5, null, null)
        }

    }

    return 0.1
}

function OnTakeDamage() { // npc takes damage
    printl("Ow")
    iHealth--
    if (iHealth < 1) {
        // do death stuff
        CleanUp()
        return
    }

	self.SetAbsOrigin(self.GetOrigin() + (self.GetForwardVector() * -2)) // npc takes 'knockback'

    hModel.SetModelScale(RandomFloat(1.03,1.1),0) // visual feedback
    hModel.SetModelScale(1,0.1)

    hModel.KeyValueFromString("rendercolor", "255 0 0")
    QFireByHandle(hModel, "color", "255 255 255", 0.1, null, null)
}

function CleanUp() {
    // hSound.Kill()
    hModel.Kill()
    hText.Kill()
    self.AcceptInput("KillHierarchy","", null, null)
}