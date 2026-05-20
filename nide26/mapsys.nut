IncludeScript("eltrasnag/mapfunc.nut", this)
IncludeScript("eltrasnag/fmv.nut", this)
IncludeScript("eltrasnag/nide26/shared.nut", this)
IncludeScript("eltrasnag/nide26/pathfollowing.nut", this)
IncludeScript("eltrasnag/nide26/story.nut", this)

// feature ideas :
// - the common cold

h_SkyProp <- null;
// h_SkyCamera <- Entities.FindByClassname(null, "sky_camera");
vec_SkyCameraOrigin <- Entities.FindByClassname(null, "sky_camera").GetOrigin();


const PIXEL_OVERLAY_DANGER = "eltra/nide26/shaders/eltra_psx_bleedingout.vmt"
::CIVILIANS_ALIVE <- 0
const SOUND_DIR = "eltra/nide26/"
const PLAYERMODEL_DIR = "models/eltra/nide26/player/"
::CTModels <- ["ct_guest_female.mdl", "ct_guest_male.mdl"]

STAGE_TEMPLATES <- [ Entities.FindByName(null, "tem_stage1"), Entities.FindByName(null, "tem_stage2") ]

enum PREG_SKY { DAY, DESERT, NIGHT, WEB }

// StageOrigins <- {
//     "web": Entities.FindByName(null, "sky_web_origin").GetOrigin(),
//     "desert1": Entities.FindByName(null, "s1_sky_origin_desert1").GetOrigin(),
//     "desert2": Entities.FindByName(null, "s2_sky_origin_desert1").GetOrigin(),
// }

function SetSkyboxModel(modelname = "", origin_name = "") {
    if (vec_SkyCameraOrigin) {
        if (ValidEntity(h_SkyProp)) {
            h_SkyProp.Kill()
        }
        local origin_pos = Entities.FindByName(null, origin_name)

        if (modelname.len() == 0 || origin_name == "" || !ValidEntity(origin_pos)) {
            return
        }

        origin_pos = origin_pos.GetOrigin()

        h_SkyProp = Spawn("prop_dynamic", {
            targetname = "skymodel"
            model = modelname,
            origin = vec_SkyCameraOrigin + (origin_pos*0.0625),
            disableshadows = true,
            disablereceiveshadows = true,
            // disablereceiveshadows = true,

        })
        QAcceptInput(h_SkyProp, "TurnOff")
        QFireByHandle(h_SkyProp, "TurnOn")
    }
}

function SetSky(next_int) {

    for (local light; light = Entities.FindByName(light, "elight_*");) {
        QAcceptInput(light, "TurnOff")
        // QFireByHandle(light, "TurnOn")
        // QFireByHandle(light, "TurnOff", "", 0.03)
    }
    local switch_delay = 1
    switch (next_int) {
        case PREG_SKY.DAY:
            QFire("elight_day", "TurnOn", "", switch_delay)
            SetSkyboxTexture("sky_pregnant")

        break;
        case PREG_SKY.NIGHT:
            SetSkyboxTexture("sky_pregnant_night")
            QFire("elight_night", "TurnOn", "", switch_delay)
        break;
        case PREG_SKY.DESERT:
            SetSkyboxTexture("sky_pregnant_desert")
            QFire("elight_desert", "turnon", "", switch_delay)
        break;
        case PREG_SKY.WEB:
            SetSkyboxTexture("sky_pregnant_network")
            SetSkyboxModel("models/eltra/nide26/skybox/sky_web.mdl", "sky_web_origin")
            QFire("elight_day", "turnon", "", switch_delay)

        break;
    }
}



function MapSpawn() {
    // STORY.DoStoryScene("hantavirus")
    // SetSky(PREG_SKY.DAY)

    ListenHooks({
        OnGameEvent_player_spawn = function(params) {

            local ply = GetPlayerFromUserID(params.userid)
            ply.ValidateScriptScope()

            ply.TerminateScriptScope()
            QFireByHandle(ply, "setdamagefilter", "filter_falldamage", 0.5)
            if (ply.GetTeam() == TEAMS.HUMANS) {
                ply.SetModelSimple(PLAYERMODEL_DIR + CTModels[RandomInt(0, CTModels.len() - 1)])
            }
           // why doesnt it run these?
        	QAcceptInput(ply, "RunScriptFile", "eltrasnag/nide26/player.nut")

            MAPFUNC.PlayerSpawn(ply)

        	// QFireByHandle(ply, "RunScriptCode", "Rape", 0.3)

            QFireByHandle(ply, "RunScriptCode", "OnPostSpawn()", 1)


        }.bindenv(this)


    })


    AddThinkToEnt(self, "MapThink")
    local intro_delay = 0

    if ( "PermaVars" in getroottable()) { // Entities.FindByName(null, "permavars") != null &&
        // printl("PERMAVARS EXISTS!!!")
        PermaVars.iRoundCount++
    } else {
        // printl("PERMAVARS DOES NOT EXIST YET!!!!")

        // local pv = Spawn("info_target", {
        //     vscripts = "eltrasnag/nide26/permavars.nut",
        //     targetname = "permavars"
        // })

        getroottable().PermaVars <- {}

        PermaVars.iRoundCount <- 0
        PermaVars.i_MapStage <- 0

    }

    if (developer()) {
        PermaVars.i_MapStage = 2
    }

    RunScriptCode(self, "ze_map_say(` -` + GetMapName().toupper() + ` -`)" 2 + intro_delay)
    RunScriptCode(self, "ze_map_say(`MAP MADE BY ELTRA`)", 5 + intro_delay)

    StageAction(PermaVars.i_MapStage)


    if (PermaVars.iRoundCount == 1 && developer() == 0) {
        intro_delay += DoFMVSequence("logladyintro_frames/logladyintro_frame_", 601, 15, "logladyintro.mp3")

    }

    if (developer() < 1 && PermaVars.i_MapStage == 1) {
        RunScriptCode(self, "STORY.DoStoryScene(`hantavirus`)", intro_delay + 6)
        QFire("s1_leshawna", "RunScriptCode", "SetFollow(true)", intro_delay + 16)

        QFire("mus_springinmystep", "PlaySound", "", intro_delay)
    }

}

function StageAction(mapstage) {
    switch (PermaVars.i_MapStage) {
        case 0: // waiting for players
            ze_map_say("Does this look like Santassination to you")
            // RunScriptCode(self, "RoundWin(TEAMS.ZOMBIES)", 5)
            AddThinkToEnt(self, "WaitingThink")
            PermaVars.i_MapStage = 1

        break;
        case 1: // stage 1
            SetSky(PREG_SKY.DAY)
            QAcceptInput(STAGE_TEMPLATES[0], "ForceSpawn")
        break;
        case 2:
            DesertAction()
            QAcceptInput(STAGE_TEMPLATES[1], "ForceSpawn")

        break;

    }
}



// twin peaks as fruits

FRUIT_INTERVAL <- 13
FRUIT_PROGRESS <- 0
FRUIT_TALKS <- ["Laura Palmer would be apple", "Jamesf would BE: kumquat", "Dale cooper: pomegerate", "BOB!!!!!!!!!!!!!!!: pineapple", "Twinpeaks fruits: Audrey Horne wuold be ...CHERRIES", "Eland palmer date", "Ummm Lucys wife would be e,.. i Tink thats one", "Nadine \"THE\"\" BITCH hurly wouldw be Strawbery", "Okay guys......./ thats all I thnk"]

function FruitsPart1() {
    ze_map_say("Twin peaks as fruits")
    QFire("mus_funkytown", "Volume", "0")
    QFire("mus_twinpeaks", "PlaySound")
    local delay = FRUIT_INTERVAL
    FruitTalk()
    for (local i = 1; i <= 4; i++) {
        QFire("s1_fruit"+i, "Open", "", delay)
        if (i < 4)
            RunScriptCode(self, "FruitTalk()", delay + 2)
        delay += FRUIT_INTERVAL
    }
}

function FruitTalk() {
    ze_map_say(FRUIT_TALKS[FRUIT_PROGRESS])
    FRUIT_PROGRESS++

}

if (!("FRUITS_COMPLETED" in getroottable())) {
    getroottable().FRUITS_COMPLETED <- false
}

function FruitsPart2() {
    FruitTalk()
    local delay = FRUIT_INTERVAL
    for (local i = 5; i <= 8; i++) {
        QFire("s1_fruit"+i, "Open", "", delay)
        RunScriptCode(self, "FruitTalk()", delay + 2)
        delay += FRUIT_INTERVAL
    }
}





// stage 1 & 2 desert stuff

a_CarSpawners <- []
::b_InDesert <- false

function DesertAction() {
    b_InDesert = true
    SetSky(PREG_SKY.DESERT)

    local car_string = "s"+PermaVars.i_MapStage+"_desert_car_spawners"
    local car_spawner;
    while (car_spawner = Entities.FindByName(car_spawner, car_string)) {
        car_spawner.QAcceptInput("RunScriptFile","eltrasnag/nide26/desert_car_spawner.nut")
        car_spawner.ValidateScriptScope()
        local s = car_spawner.GetScriptScope()
        s.Setup()
    }
}
function EnterDesert() {
    RunScriptCode(self, "ze_map_say(`I thnk the biome just changed.`)", 1)
    QFire("mus_funnysong", "FadeOut", "5")
    QFire("mus_funkytown", "PlaySound", "", 3)
    DesertAction()
}

a_Drowners <- []

function OpilaWater(activator, toggle) {
    if (toggle) {
        activator.SetGravity(0.7)
        // activator.SetMoveType(MOVE/, MOVECOLLIDE_FLY_BOUNCE)
        a_Drowners.append(activator)
        activator.SetScriptOverlayMaterial(PIXEL_OVERLAY_DANGER)
    } else {

        // activator.SetMoveType(MOVETYPE_LAST, MOVECOLLIDE_DEFAULT)
        activator.SetGravity(1)
        activator.SetScriptOverlayMaterial("")
        if (a_Drowners.find(activator) != null) {
            a_Drowners.remove(a_Drowners.find(activator))
        }
    }
}


function MapThink() {
    foreach (i, ply in a_Drowners) {
        ScreenFade(ply, 0, 0, 255, 255, 0.25, 0, FFADE_IN)
        if (ply.GetTeam() == TEAMS.HUMANS) {
            ply.TakeDamage(45, DMG_DROWN, ply)
            continue;
        }
        ply.TakeDamage(10000, DMG_DROWN, ply)
    }
    return 0.5
}

::Rape <- function(activator) {
	if (!ValidEntity(activator) || !activator.IsPlayer()) {
		return
	}
    activator.TakeDamage(99999999, DMG_ALWAYSGIB, activator)
	activator.SetScriptOverlayMaterial("eltra/banban_jumpscare")
	PlaySound("npc/stalker/go_alert2a.wav", activator.GetOrigin())
	QFireByHandle(activator, "RunScriptCode", "if (ValidEntity(self)) { self.SetScriptOverlayMaterial(``) }", 1) // ?
}

const OVERLAY_MARIA = "eltra/face.vmt"
const SOUND_MARIA = "eltra/dinosaur.mp3"

::Maria <- function() {
	PlaySoundGlobal(SOUND_MARIA)
	QFire("player", "RunScriptCode", "self.SetScriptOverlayMaterial(OVERLAY_MARIA)")
    QFire("player", "RunScriptCode", "self.SetMoveType(MOVETYPE_NONE, MOVECOLLIDE_DEFAULT)")
	QFire("player", "sethudvisibility", "0")
	QFire("player", "RunScriptCode", "self.SetScriptOverlayMaterial(``)", 10)
	QFire("player", "sethudvisibility", "1", 10)
    QFire("player", "RunScriptCode", "self.SetMoveType(MOVETYPE_WALK, MOVECOLLIDE_DEFAULT)", 10)

}

function DesertNight() {
    SetSky(PREG_SKY.NIGHT)
}

function EndFruits() {
    ze_map_say("Wow its dark now......", 1)
    ze_map_say("You gusys must be kind of tired and ,,, lowkey .... DEAD AS FUCK ......", 4)
    ze_map_say("Lets go takae a little rest at the  motel :D okay", 9)
    QFire("mus_twinpeaks", "FadeOut", "30")
}

// stage 1 motel ending
STAGE1_SLEEP_DELAY <- 25

function EndStage1() {

    ze_map_say("*You take a melatonin.*")
    for (local p; p = Entities.FindByClassname(p, "player");) {
        ScreenFade(p, 0,0,0,0, STAGE1_SLEEP_DELAY + 5, 99, FFADE_OUT)
    }

    ze_map_say("*Wow im tired...Im thinking of fallking asleep in........", 2)
    ze_map_say(STAGE1_SLEEP_DELAY + " Seconds zzzzz",5)
    ze_map_say("**Yawn in kawaii way*", (STAGE1_SLEEP_DELAY*0.5) + 5)


    QFire("motel_doors", "Close", "", STAGE1_SLEEP_DELAY + 5)
    QFire("motel_doors", "Lock", "", STAGE1_SLEEP_DELAY + 5.1)

    RunScriptCode(self, "EndStage1_b()", STAGE1_SLEEP_DELAY + 5)


}

function EndStage1_b() {
    s1_motel_ztrigger.AcceptInput("Enable", "", null, null)
    ze_map_say("Good night ")
    RoundWin(TEAMS.HUMANS)
}


b_FailZombieDetection <- false

function RoundWin(winning_team) {
    local roundparam = Spawn("info_map_parameters", {})

    if (winning_team == (TEAMS.HUMANS)) {
        if (b_FailZombieDetection == true) {
            ze_map_say("RIUH ROH.... LOOKS LIKE A ZOMBIE GOT In.......> YOU LOSE!!!!!!!!!!!!")
            RoundWin(TEAMS.ZOMBIES)
            return
        }

        QFireByHandle(roundparam, "FireWinCondition", ROUND_END_REASON.CTs_PreventEscape.tostring())



        for (local p; p = Entities.FindByClassname(p, "player");) {
            if (p.GetTeam() == TEAMS.ZOMBIES) {
                // p.TakeDamage(9999999, DMG_DISSOLVE, p)
                ClientPrint(p, HUD_PRINTCENTER, "THE ZOMBIES WERE UNABLE TO KILL THE SURVIVORS!")
            }
        }

    }
    else {
        for (local p; p = Entities.FindByClassname(p, "player");) {
            if (p.GetTeam() == TEAMS.HUMANS) {
                p.TakeDamage(9999999, DMG_DISSOLVE, p)
                ClientPrint(p, HUD_PRINTCENTER, "THE SURVIVORS FAILED TO REACH THE GOAL!")
            }
        }
        QFireByHandle(roundparam, "FireWinCondition", ROUND_END_REASON.Terrorists_Escaped.tostring())
     }
}

// waiting for players
function WaitingThink() {
	printl("Hi")
	local p;
	while (p = Entities.FindByClassname(p, "player")) {
        if ((p != null)) {
            local t = p.GetTeam()
            if (t != null && (t != TEAMS.SPECTATORS) && (t != TEAMS.UNASSIGNED)) {
                p.TakeDamage(9999999, 0, self)
            }

        }

    }
    return 1
}

IncludeScript("eltrasnag/nide26/stage2.nut", this)

const WATER_SPLASH_PATH = "eltra/nide26/watersplash/drown_splash"

function Drown(activator) {
    activator.KeyValueFromVector("basevelocity", Vector(0,0,9999))
    PlaySoundEX(WATER_SPLASH_PATH + RandomInt(1,5) + ".mp3", activator.GetOrigin())

    if (activator.GetTeam() == TEAMS.HUMANS) {
        activator.TakeDamage(99999, DMG_DROWN, activator)
        dprintl(activator, " drowned")
    }
    else {
        // zombie drowned do something here probably!!!
    }
}

