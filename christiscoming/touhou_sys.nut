::iTBossHealth <- 2000

::TOUHOU_BOSS <- null;

iTBossEnt <- Entities.FindByName(null,"touhou_boss")
const TOUHOU_COLOR_HEALTH = "255 0 0"
const TOUHOU_HUD_HEALTH_STR = "| YOUR HP: "
const TOUHOU_HUD_BORDER_STR = " |"
const TOUHOU_BULLET_SCRIPT = "eltrasnag/christiscoming/touhou_bullet.nut"
const TOUHOU_BULLET_NAME_P = "TOUHOU_PLAYER_BULLET"
const TOUHOU_PLAYERNAME = "TOUHOU_PLAYER_CHARACTER"
const TOUHOU_PUPPET_STR = "touhou_puppet"
const TOUHOU_PLAYER_SCRIPT = "eltrasnag/christiscoming/touhou_player.nut"
// pre-calculate all vectors so we dont have to do them each frame
::TOUHOU_VEC_LEFT <- Vector(-1, 0, 0); // globalling these is bad but i literally dont care
::TOUHOU_VEC_RIGHT <- Vector(1, 0, 0);
::TOUHOU_VEC_UP <- Vector(0, 1, 0);
::TOUHOU_VEC_DOWN <- Vector(0, -1, 0);

::TOUHOU_VEC_Z_UP <- Vector(0, 0, 1);
::TOUHOU_VEC_Z_DOWN <- Vector(0,  0, -1);

TOUHOU_ALLOW_SAFELEAVE <- true; // allow players to safely leave the touhou zone? (set to no during bossfights or else cheesing can happen)

::TOUHOU_VEC_UPLEFT <- TOUHOU_VEC_LEFT.Dot(TOUHOU_VEC_UP);
::TOUHOU_VEC_DOWNLEFT <- TOUHOU_VEC_LEFT.Dot(TOUHOU_VEC_DOWN);
::TOUHOU_VEC_UPRIGHT <- TOUHOU_VEC_RIGHT.Dot(TOUHOU_VEC_UP);
::TOUHOU_VEC_DOWNRIGHT <- TOUHOU_VEC_RIGHT.Dot(TOUHOU_VEC_DOWN);


::TOUHOU_BOSS_SCRIPT <- "eltrasnag/christiscoming/touhou_boss_santa"

const TOUHOU_MAXENTITIES = 512
::TOUHOU_ENTITIES_LIMIT <- 0
const TOUHOU_PLAYER_TARGETNAME = "TOUHOU_PLAYER"

::TOUHOU_ORIGIN <- self.GetOrigin()
// ::TOUHOU_ORIGIN <- Vector(924, 10424, -10596) // hack SPECIFICALLY for christ is coming DO NOT use this on any other map!




::TOUHOU_BULLET_PUSH <- 30 // strength of human knockback against zombies

::TOUHOU_CAMERALOCK <- true; // disable to make cameras track the player

::TOUHOU_BOUND_UPPER <- TOUHOU_ORIGIN + Vector(0, 512)
// gameplay:
// boss at top of screen. does attacks.
// gameplay mimic eosd
// all bullets are made up of/controlled by players on red team + various cpu ones if red is too low

const TOUHOU_SPAWNPOINT_OFFSET = -200

::TOUHOU_SPAWNPOINT <- TOUHOU_ORIGIN + Vector(0,TOUHOU_SPAWNPOINT_OFFSET,0)


const TOUHOU_SPEED_PBULLET = 20

::TOUHOU_CAMERA_ANGLE <- QAngle(90,90,0)

// ::TOUHOU_CAMERA <- SpawnEntityFromTable("point_viewcontrol", {
	// targetname = "TOUHOU_CAMERA",
	// origin = TOUHOU_ORIGIN + Vector(0, 0, TOUHOU_CAMERA_HEIGHT),
	// angles = TOUHOU_CAMERA_ANGLE,
	// vscripts = "eltrasnag/camera_fix_tf.nut",
	// spawnflags = 24,
// })


const TOUHOU_BASESPEED = 2

const TOUHOU_DMULT_BASE = 1
const TOUHOU_DMULT_GUARDING = 0.25





// const TOUHOU_ORB_OFFSET = 64
const TOUHOU_ORB_ROTATEANGLE = 1

const TOUHOU_DOTCONST = 0.707106781187

const TOUHOU_VIS_LEFT = "_player_vis_left"
const TOUHOU_VIS_RIGHT = "_player_vis_right"
const TOUHOU_VIS_NORMAL = "_player_vis_normal"

const TOUHOU_VIS_PBULLET = "touhou_player_bullet"
const TOUHOU_BULLET_PREFIX = "touhou_bullet_"

const TOUHOU_ORB_MODELNAME = "touhou_player_vis_orb"

// BULLET COLORS

const TOUHOU_SHOOTCOL_BASIC = "180 250 180"

enum TOUHOU_SHOOTLVL{BASIC,fSPRAY}
// const TOUHOU_SHOOT_LEVEL_

::Touhou_MakeCam <- function(ply, tply) {
	local cname = "TOUHOU_CAM"+UniqueString("")
	TOUHOU_ENTITIES_LIMIT++
	local localcam = SpawnEntityFromTable("point_viewcontrol", {
	targetname = cname,
	origin = TOUHOU_ORIGIN,
	angles = TOUHOU_CAMERA_ANGLE,
	vscripts = "eltrasnag/camera_fix_tf.nut",
	spawnflags = 24,
	})

	// tply.ValidateScriptScope()
	// local tscope = tply.GetScriptScope()
	// tscope.CameraName <- cname
	// tscope.CameraENT <- localcam

	return localcam
	// SetViewControl(ply, cname)

}

const TOUHOU_TARGETNAME = "TOUHOU_ENT"

// GENERAL FUNCTIONS

::SetTouhou <- function(activator, mode) {



	activator.ValidateScriptScope()
	local ascope = activator.GetScriptScope()

	// if (DEV == false) {

	// switch (mdl) {
	// 	case 0:

	// 	break;
	// 	case 1:
	// 	break;
	// }
	// }

	if (mode == true) { // touhou mode on
		if (activator.GetTeam() != TEAMS.HUMANS) {
			return
		}

		activator.SetMoveType(Constants.EMoveType.MOVETYPE_CUSTOM, Constants.EMoveCollide.MOVECOLLIDE_DEFAULT)
		activator.SetAbsOrigin(TOUHOU_ORIGIN)
		local tply = Spawn("func_door", {
			origin = TOUHOU_ORIGIN + TOUHOU_SPAWNPOINT,
			disableshadows = true
			model = BRUSHMODELS["reimu_player_vis_normal"],
			// Solidity = 1,

			vscripts = TOUHOU_PLAYER_SCRIPT,
			spawnflags = 2052,
			health = 99999999999,
		})

		tply.SetCollisionGroup(Constants.ECollisionGroup.COLLISION_GROUP_NONE)

		NetProps.SetPropBool(tply, "m_takedamage", true)
		ascope.touhou_puppet <- tply
		tply.ValidateScriptScope()
		local tscope = tply.GetScriptScope()
		tscope.hOwner <- activator
		tscope.bReady <- true

		// local cam = tscope.CameraName
		// if (ValidEntity(tscope.CameraENT)) {
			// SetViewControl(activator, CameraName, true)
		// }



	} else { // touhou mode off
		if ("touhou_puppet" in ascope && ValidEntity(ascope.touhou_puppet)) {
			local p = ascope.touhou_puppet
			if (!TOUHOU_ALLOW_SAFELEAVE) {
				activator.TakeDamage(99999999, Constants.FDmgType.DMG_RADIATION, null)
				ClientPrint(activator, Constands.EHudNotify.HUD_PRINTCENTER, "Abandonning your team?! Mutiny!")
			}
			p.ValidateScriptScope()
			p.GetScriptScope().CleanUp()

		}

	}
}

function SysThink() {

	// DEV_ShowTouhouEnts()
	return 0.25
}

::TouhouOverflow <- function() { // check if we have passed the safe limit for touhou ents
	if (TOUHOU_ENTITIES_LIMIT > TOUHOU_MAXENTITIES) {
		return true
	}
	else {
		return false
	}
}


function MakeTouhouBoss(boss_script) {
	TOUHOU_BOSS = Spawn(CUBT_FUNCBRUSH, {
		origin = TOUHOU_ORIGIN, // bruh
		disableshadows = true,
		targetname = "boss",
		model = BRUSHMODELS["reimu_player_vis_normal"],
		// Solidity = 1,
		vscripts = boss_script,
		spawnflags = 49153
	})
	MapSay("A boss in the distance... Fighting?")
	return TOUHOU_BOSS
}

function DEV_ShowTouhouEnts() {
	local hTextInfo = Spawn("game_text", {
			color = "51 255 255",
			fadein = 0.1,
			fadeout = 0.1,
			holdtime = 0.25,
			message = "TOUHOU_ENTITIES_LIMIT: "+TOUHOU_ENTITIES_LIMIT.tostring()+"/"+TOUHOU_MAXENTITIES.tostring()
			channel = 4,
			x = 0.02,
			y = 0.25,
			spawnflags = 1,
		})

		hTextInfo.AcceptInput("Display", "", null, null)
		QFireByHandle(hTextInfo, "Kill")
}

function OnPostSpawn() {

	if (GetMapName().find("christ_is_coming") != null) { // stupid hack SPECIFICALLY for bug on christ is coming
	}
	TOUHOU_SPAWNPOINT = TOUHOU_ORIGIN + Vector(0,TOUHOU_SPAWNPOINT_OFFSET,0)
	// Spawn("tf_logic_arena", {})
	// GameModeUsesCurrency() // test
	// local tf = Entities.FindByClassname(null, "tf_gamerules_data")
	// NetProps.SetPropInt(tf, "m_nGameType","4")

	// NetProps.SetPropBool(tf, "m_bShowMatchSummary",true)
	AddThinkToEnt(self, "SysThink")
}

::MakeTouhouLaser <- function(pos, ang = QAngle(0,90,0), size = 1) {
	size *= 0.5 // big ass laser model

	Spawn("prop_dynamic", "")
}

function TLaserThink() {
	local vOrigin = self.GetOrigin()

	if (iLifetime <= Time()) {
		self.Destroy()
	}



}

::TouhouBossKilled <- function() {
	QFireByHandle(self, "FireUser1") // customizable function for the bossfight

}