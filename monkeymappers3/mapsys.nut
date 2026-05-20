IncludeScript("eltrasnag/mapfunc.nut", this)
IncludeScript("eltrasnag/fmv.nut", this)

::BrianCount <- 0
// ::CorrectBrianColor <- RandomInt(0,5)
::CorrectBrianColor <- 0 // red
::CorrectBrians <- [];


::DEV <- true;

::MapSys <- self.GetScriptScope()

hSkyCam <- Entities.FindByClassname(null, "sky_camera");
mSkyModelPath <- "models/eltra/mm3_fakesky.mdl"
hSkyDome <- null;
hFog <- null;

FinaleDests <- {};

vStageOrigin <- Vector(0,0,0)
vRedRoomOrigin <- Vector(0,0,0)

ClientCommand <- null

//

PinkRoomSkyColors <- [Vector(102, 45, 90), Vector(105, 39, 68), Vector(66, 49, 84), Vector(138, 25, 53)]
PinkRoomSkyColorsMax <- PinkRoomSkyColors.len() - 1
NextSkySwapTime <- 0

MAP_COLOR <- "193 255 214"


function RapeBoss() {
    printl("Dummy function for berke item")
}

function SetFinale(toggle) {
    if (toggle) {
        hFog = Entities.FindByName(null, "fi_fog")

		ClientCommand = Entities.CreateByClassname("point_clientcommand")




        QFire("fi_fog", "TurnOn")
        QFire("player", "SetFogController", "fi_fog")
        QFire("fi_mus_darkmoodwoods", "PlaySound")
        QFire("fi_fog", "SetColor", "48 55 52")
        QFire("fi_fog", "SetEndDist", "5000")


        vStageOrigin <- Entities.FindByName(null, "fi_maporigin").GetOrigin()

        hSkyDome = Spawn("prop_dynamic", {
            origin = hSkyCam.GetOrigin() + (vStageOrigin * 0.0625),
            model = mSkyModelPath,
            modelscale = 2
        })


        for (local ent = null; ent = Entities.FindByName(ent, "fi_dest*");) {
            FinaleDests[ent.GetName()] <- {
                origin = ent.GetOrigin(),
                angles = ent.GetAbsAngles(),
                }
        }


        local hSpawnPoint = Entities.FindByName(null, "fi_startpos")
        local hSpawnOrigin = hSpawnPoint.GetOrigin()
        local hSpawnAng = hSpawnPoint.GetAbsAngles()
        for (local ply = null; ply = Entities.FindByClassname(ply, "player");) {
            if (ply.GetTeam() == TEAMS.HUMANS) {
                ply.SetAbsOrigin(hSpawnOrigin)
                ply.SnapEyeAngles(hSpawnAng)
            }
        }
        // printl(hSkyCam);

        SetSkyColor(92, 53, 67)
        QFire("fi_ccwoods", "Enable", "", 1)

    }
}


function GoToRedRoom(activator) {
    activator.SetAbsOrigin(FinaleDests["fi_dest_rrstart"].origin)
    activator.SnapEyeAngles(FinaleDests["fi_dest_rrstart"].angles)
    ScreenFade(null,255,0,0,255,2,0.1,1)
}

function SetSkyColor(r,g,b) {
    local cvec = Vector(r,g,b)
    if (ValidEntity(hSkyDome)) {
        hSkyDome.KeyValueFromVector("rendercolor", cvec)
    }
    if (ValidEntity(hFog)) {
        // hFog.KeyValueFromVector("fogcolor", cvec)
        QFireByHandle(hFog, "SetColor", cvec.ToKVString())

    }
}

function OpenRedRoomPortal() {
    foreach (i, brian in CorrectBrians) {
        brian.GetScriptScope().Active = false
        AddThinkToEnt(brian, "")
        QFireByHandle(brian, "Kill", "", 60)
        // printl("brian DEACTIVATED")
    }

    SetSkyColor(54,0,0)
    QFire("fi_triggers_ascend", "Enable")
    ScreenFade(null,255,0,0,200,3,0.1,1)
    PlaySoundGlobal("ambient/energy/whiteflash.wav", 60)
    PlaySoundGlobal("ambient/levels/citadel/portal_beam_shoot6.wav", 60)

    QFire("fi_mus_darkmoodwoods", "FadeOut", "5")


}

function BruhPassthrough() {
    printl("Bruh allows !!!!")
    QFire("fi_block3", "Kill")
}

function SetAntiStuck(activator, toggle) {
    activator.ValidateScriptScope()
    local ascope = activator.GetScriptScope()

    if (toggle) {
        // ascope.AntiStuck
    }
}

// function


NextPinkRoomShakeTime <- 0;
PinkRoomShakeTime <- 5;
PinkRoomSkyBrightness <- 0.0;
PinkRoomSkyColor <- Vector();
PinkRoomNoiseSweep <- "eltra/rr_noises01.mp3"

function EnterPinkRoom() {
    AddThinkToEnt(self, "PinkRoomThink")
    QFire("fi_mus_theredroom", "FadeOut", "2")
    QFire("fi_mus_redroomdrone2", "PlaySound")
}

function EnterFanRoom() {
    QFire("fi_mus_redroomdrone2", "FadeOut", "2")
    QFire("fi_mus_thepinkroom", "PlaySound")
}

function PinkRoomThink() {
    local flTime = Time()
    if (flTime >= NextPinkRoomShakeTime) {
        NextPinkRoomShakeTime = Time() + PinkRoomShakeTime
        ScreenShake(vStageOrigin ,5, RandomFloat(0.1, 1), PinkRoomShakeTime*2, 9999999, SHAKE_START, true)
    }

    if (flTime >= NextSkySwapTime) {
        NextSkySwapTime = flTime + RandomFloat(0.01, 1.25)
        PinkRoomSkyColor = PinkRoomSkyColors[RandomInt(0,PinkRoomSkyColorsMax)] * PinkRoomSkyBrightness

    }


    PinkRoomSkyBrightness += fabs(sin(flTime * fabs(cos(flTime * 0.5))))
    if (PinkRoomSkyBrightness >= 1) {
        PinkRoomSkyBrightness = 0
    }

    local skycolor = PinkRoomSkyColor * PinkRoomSkyBrightness *2
    SetSkyColor(skycolor.x, skycolor.y, skycolor.z)

    if (PinkRoomSkyBrightness > 0.5) {
        PlaySoundGlobal(PinkRoomNoiseSweep, PinkRoomSkyBrightness * 100 + 0)
    }

    if (ValidEntity(hFog)) {
        QFireByHandle(hFog, "SetEndDist", clamp(fabs(sin(flTime)) * 3400, 1024, 3400).tostring())
    }
    return 0.05
}


// player fell into the Nothing
function NothingKill(activator) {
	QFireByHandle(ClientCommand, "Command", "soundfade 100 3 2", 0, activator)

	activator.SetScriptOverlayMaterial("eltra/diana.vmt")
	activator.TakeDamage(999999999, 0, activator)


	QFireByHandle(activator, "RunScriptCode", "self.SetScriptOverlayMaterial(``)", 3)
}

FMV_DIRECTORY <- "eltra/mm3/fmv/"


MAT_LONGHEAD <- "eltra/mm3/longhead.vmt"
LONGHEAD_DELAY <- 156.8 # in time with the alarm jumpscare in the hammerhead drone :3

function LongHead() {

    ScreenShake(vStageOrigin, 100, 30, 3, 9999999, SHAKE_START, true)
    ScreenFade(null, 255, 0, 0, 90, 2, 0, FFADE_IN)

    for (local ply; ply = Entities.FindByClassname(ply, "player");) {
        ply.SetScriptOverlayMaterial(MAT_LONGHEAD)
        RunScriptCode(ply, "self.SetScriptOverlayMaterial(``)", 1)
    }

}