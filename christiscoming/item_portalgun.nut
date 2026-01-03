////// PORTAL GUN ITEM \\\\\\
//// PORTED FROM W.I.P. LASERINSURGENCY \\\\\
//// UPDATED TO THE C.I.C. ITEM SYSTEM! \\\\\
IncludeScript("eltrasnag/zombieescape/zeitem.nut")
FullFocus <- true
ItemName <- "Portal Gun"
AttackKey <- ZITEM_ATTACKKEYS.DUAL



const MDL_PROJECTILE = "models/eltra/li_portal_glob.mdl"
const MDL_PORTAL = "models/eltra/li_portal.mdl"
const MDL_PORTAL1 = "models/portals/portal1.mdl";
const MDL_PORTAL2 = "models/portals/portal2.mdl";
const MDL_PORTALGUN_W = "models/eltra/li_w_pgun.mdl";

aPortalColors <- [Vector(44, 173, 255),Vector(255, 138, 53)]


const SND_PORTAL1_OPEN = "eltra/portal_open1.mp3"
const SND_PORTAL2_OPEN = "eltra/portal_open2.mp3"
const SND_PORTAL1_SHOOT = "eltra/portalgun_shoot_blue1.mp3"
const SND_PORTAL2_SHOOT = "eltra/portalgun_shoot_red1.mp3"


const MAX_DROPPED_TIME = 10
const MAX_FIRE_WAIT_TIME = 50
const GUN_SEARCH_RADIUS = 16

// some input consts
const IN_ATTACK	= 1
const IN_ATTACK2 = 2048
const IN_RELOAD = 8192
const IN_WALK = 262144

aPortals <- [].resize(2);


enum TEAMS {
	HUMANS = 3,
	ZOMBIES = 2,
	SPECTATORS = 1,
	UNASSIGNED = 0,
}

// iModelIndex <- PrecacheModel(MDL_PORTALGUN_W)
// hGunModel <- null;
hPortal2 <- null;
hPortal1 <- null;
// hGunVisualModel <- null;
// hGunVisual <- null; // who is this ?
// hGunVisualWorld <- null;
// hGunProjectile <- null;
// strGunOwnerID <- null;
// iGunState <- GUNSTATES.UNASSIGNED;
// iDroppedTimer <- 0;
// iFireTimer <- MAX_FIRE_WAIT_TIME;

enum PORTALS {
	PORTAL1,
	PORTAL2,
}


function Init() {

}



function FireWeapon() {
		local vOrigin = self.GetOrigin()
		if (Time() >= flNextCooldownEnd && ((NetProps.GetPropInt(hOwner, "m_nButtons") & IN_ATTACK) || (NetProps.GetPropInt(hOwner, "m_nButtons") & IN_ATTACK2))) {
			if (NetProps.GetPropInt(hOwner, "m_nButtons") & IN_ATTACK) { // fire blue portal
				PrecacheSound(SND_PORTAL1_SHOOT)
				PlaySoundEX(SND_PORTAL1_SHOOT, vOrigin)

				PlaySoundEX(SND_PORTAL1_SHOOT, vOrigin)
				ShootPortalProjectile(PORTALS.PORTAL1)
			}

			if (NetProps.GetPropInt(hOwner, "m_nButtons") & IN_ATTACK2) { // fire red portals
				PrecacheSound(SND_PORTAL2_SHOOT)
				PlaySoundEX(SND_PORTAL2_SHOOT, vOrigin)
				PlaySound(SND_PORTAL2_SHOOT, vOrigin)
				ShootPortalProjectile(PORTALS.PORTAL2)
			}
		}
	return -1
}

function ShootPortalProjectile(iPortalType) { // Portal gun projectile logic


	PrecacheModel(MDL_PROJECTILE)

	local hSprite = Spawn("prop_dynamic", {
		model = MDL_PROJECTILE,
		// rendermode = 8,
		origin = hOwner.EyePosition() + hOwner.GetForwardVector() * 8
		vscripts = "eltrasnag/laserinsurgency/li_portalprojectile.nut",
		rendercolor = aPortalColors[iPortalType],
		angles = self.GetAbsAngles()


	})
	// hSprite.ValidateScriptScope()
	// hSpriteScope <- hSprite.GetScriptScope()

	// new eltra code
	SetContext(hSprite, "ownerindex", hOwner.entindex())
	SetContext(hSprite, "portaltype", iPortalType)

	// old eltra code
	// local qForward = hOwner.EyeAngles().Forward()
	// hSprite.SetAbsOrigin(hOwner.EyePosition() + qForward * 64)
	// hSpriteScope.iPortalType <- iPortalType
	// hSpriteScope.qMoveAngles <- qForward
	// hSpriteScope.hOwner <- hOwner
	// hSpriteScope.hGun <- self
	// hSpriteScope.vecLastOrigin <- hOwner.EyePosition()
	// hSpriteScope.vForward <- hOwner.EyeAngles().Forward()
}



// PORTAL PROJECTILE HITS SURFACE -> PORTAL PLACEMENT OCCURS
function PortalHitSurface(params) {
	if (ValidEntity(aPortals[params.type])) {
		aPortals[params.type].Kill()

	}

	try { // i know you is having issues bitch
		if (!ValidHandle(params.forv)) {
			return
		}


		PrecacheModel(MDL_PORTAL)
		PrecacheModel(MDL_PORTAL)

		// printl("Normal: " + params.normal.tostring())
		local tPortalTable = {
			classname = "prop_dynamic",
			model = MDL_PORTAL,

			origin = params.endpos,
			disableshadows = true,
			rendermode = 1,
			vscripts = "eltrasnag/laserinsurgency/li_portal.nut"
			modelscale = 0
		}
		PrecacheEntityFromTable(tPortalTable)

		// Setting up and spawning portal ent
		self.ValidateScriptScope()
		local hPortal = Spawn("prop_dynamic", tPortalTable)
		hPortal.ValidateScriptScope()

		// hPortal.SetAbsOrigin(params.endpos)
		hPortal.SetForwardVector(params.forv * -1.0)

		local hPortalScope = hPortal.GetScriptScope()

		hPortalScope.iType <- params.type
		hPortalScope.vForV <- params.forv


		hPortalScope.hGunScope = self.GetScriptScope()


		// Setting portal behaviour

		switch (params.type) { // portal setup based on what one it is
			case PORTALS.PORTAL1: // blu
			PlaySound(SND_PORTAL1_OPEN, params.endpos)
					hPortalScope.iPaired <- PORTALS.PORTAL2
					break;

				case PORTALS.PORTAL2: // orange
					PlaySound(SND_PORTAL2_OPEN, params.endpos)
					hPortalScope.iPaired <- PORTALS.PORTAL1
					break;

				default:
				break;
			}

		// if (ValidEntity(aPortals[params.type])) {
		// 	aPortals[params.type].Kill()

		// }
		// aPortals[params.type] = hPortal
		local vPortalColor = aPortalColors[params.type]
		hPortalScope.vPortalColor = vPortalColor
		hPortal.KeyValueFromVector("rendercolor", vPortalColor)
	} catch (exception){
		printl("PORTAL GUN ERROR: "+exception)
	}

}

// __CollectGameEventCallbacks(this)