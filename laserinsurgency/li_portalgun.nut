self.ValidateScriptScope()

const MDL_PROJECTILE = "models/eltra/li_portal_glob.mdl"
const MDL_PORTAL = "models/eltra/li_portal.mdl"
const MDL_PORTAL1 = "models/portals/portal1.mdl";
const MDL_PORTAL2 = "models/portals/portal2.mdl";
const MDL_PORTALGUN_W = "models/eltra/li_w_pgun.mdl";
const MDL_PORTALGUN_V = "models/weapons/v_portalgun.mdl";

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

// enum HCLASSES {
// 	LI_CLASS_STRAIGHT,
// 	LI_CLASS_EDTWT,
// 	LI_CLASS_BISEXUAL,
// 	LI_CLASS_HUGGER,
// 	LI_CLASS_PHILLIPINO,
// 	LI_CLASS_SNEAKER,
// 	LI_CLASS_DEFENSE,
// 	LI_CLASS_LAURAPALER,
// 	LI_CLASS_MEL,
// }

enum TEAMS {
	HUMANS = 3,
	ZOMBIES = 2,
	SPECTATORS = 1,
	UNASSIGNED = 0,
}

enum GUNSTATES {
	DROPPED,
	HELD,
	UNASSIGNED,
}

iModelIndex <- PrecacheModel(MDL_PORTALGUN_W)
hGunModel <- null;
hPortal2 <- null;
hPortal1 <- null;
hGunVisualModel <- null;
hGunVisual <- null; // who is this ?
hGunVisualWorld <- null;
hGunProjectile <- null;
hGunOwner <- null;
strGunOwnerID <- null;
iGunState <- GUNSTATES.UNASSIGNED;
iDroppedTimer <- 0;
iFireTimer <- MAX_FIRE_WAIT_TIME;

enum PORTALS {
	PORTAL1,
	PORTAL2,
}


function CreateGunVisualModel() {
	hGunVisualModel <- SpawnEntityFromTable("prop_dynamic", {
		model = MDL_PORTALGUN_W,
		origin = self.GetOrigin(),
		angles = self.GetAbsAngles() + Vector(0,180,-90)
		})

}
// function CreateGunVisualModel() {
	// hGunVisual <- SpawnEntityFromTable("prop_dynamic", {
		// model = MDL_PORTALGUN_W,
		// origin = self.GetOrigin(),
		// angles = self.GetAbsAngles() + Vector(0,180,-90)
		// })
// }

function OnPostSpawn() {

	// hGunVisualWorld = SpawnEntityFromTable("prop_dynamic", { // create visual model since i guesws we cant override weapon mdls ?
	// 	classname = "prop_dynamic",
	// 	model = MDL_PORTALGUN_W,
	// 	origin = self.GetOrigin(),
	// 	angles = self.GetAbsAngles() + Vector(0,180,-90)
	// })

	// hGunVisualWorld.AcceptInput("SetParent", "!activator", self, null);


	PrecacheModel(MDL_PORTALGUN_V)
	// self.SetModelSimple(MDL_PORTALGUN_W)
	self.SetCustomViewModel(MDL_PORTALGUN_V)
	self.SetClip1(1000)



	// Setting up custom weap properties

	NetProps.SetPropInt(self, "m_iDefaultAmmo", 0)
	NetProps.SetPropInt(self, "m_iPrimaryAmmoCount", 0)
	// NetProps.SetPropBool(self, "m_bFiresUnderwater", true)

	NetProps.SetPropInt(self, "m_iSecondaryAmmoCount", 0)

	AddThinkToEnt(self,"Think")

}

function SWEPUpdate() { // runs every think to preserve weapon customization
	NetProps.SetPropInt(self, "m_iWorldModelIndex", iModelIndex)
	NetProps.SetPropInt(self, "m_iClip1", 0)
	NetProps.SetPropInt(self, "m_iClip2", 0)
	NetProps.SetPropBool(self, "m_bFlipViewModel", false)
	NetProps.SetPropBool(self, "m_bSilencerOn", false)
	self.StudioFrameAdvance()
}

function DoPickup(hPlayer) {

	// hGunVisualWorld.AcceptInput("Disable", "", null, null); // hide penis gun

	// i dont know how i could make this NOT display to the player while displaying to the outer world

	// if (!ValidEntity(hGunVisualModel)) {
		// CreateGunVisualModel()
	// }
	// hGunVisualModel.KeyValueFromVector("origin",self.GetOrigin())
	// hGunVisualModel.AcceptInput("SetParent", "!activator", hPlayer, null);
	// hGunVisualModel.AcceptInput("SetParentAttachment", "muzzle_flash", hPlayer, null);
	// hGunVisualModel.KeyValueFromVector("angles",Vector(self.GetAbsAngles() + QAngle(0, -90, 90)))


	iGunState = GUNSTATES.HELD
	hGunOwner = hPlayer;
	ClientPrint(hPlayer, 3, "YOU ARE PORTAL HOLDER")
	strGunOwnerID = NetProps.GetPropString(hPlayer, "m_szNetworkIDString");

}


function Think() {
	if (ValidEntity(self)) {
		SWEPUpdate()

		// self.DisableDraw() // base weapon RLLY wants to be drawn... we CANNOT allow this

		local vecOrigin = self.GetOrigin()

		switch (iGunState) {
			case GUNSTATES.UNASSIGNED: // gun is not held, waiting for pickup
				NetProps.SetPropInt(self, "m_pConstraint", 0)
				for (local hPlayer; hPlayer = Entities.FindByClassnameWithin(hPlayer, "player", vecOrigin, GUN_SEARCH_RADIUS);) {
					if (hPlayer.GetTeam() == TEAMS.HUMANS && (hPlayer.GetScriptScope().iPlayerHClass == HCLASSES.LI_CLASS_MEL)) {
						DoPickup(hPlayer)
					}
					else {
						ClientPrint(hPlayer, 4, "|| NOTICE: YOU ARE NOT YET READY TO MEL WITH THIS DEVICE ||")
						NetProps.SetPropEntity(hPlayer, "m_hActiveWeapon", self)
					}
				}
				break;
			case GUNSTATES.HELD: // gun is held
				if (ValidEntity(hGunOwner) && hGunOwner == self.GetOwner())

						// printl("HGunOwner m_nButtons :" + NetProps.GetPropInt(hGunOwner, "m_nButtons").tostring())
						if (NetProps.GetPropEntity(hGunOwner, "m_hActiveWeapon") == self) {
							if (iFireTimer >= MAX_FIRE_WAIT_TIME && ((NetProps.GetPropInt(hGunOwner, "m_nButtons") & IN_ATTACK) || (NetProps.GetPropInt(hGunOwner, "m_nButtons") & IN_ATTACK2))) {
								iFireTimer = 0

								if (NetProps.GetPropInt(hGunOwner, "m_nButtons") & IN_ATTACK) { // fire blue portal
									// PrecacheSound(SND_PORTAL1_SHOOT)
									// self.QEmitSound(SND_PORTAL1_SHOOT)

									PlaySound(SND_PORTAL1_SHOOT, vecOrigin)
									ShootPortalProjectile(PORTALS.PORTAL1)
									break;
								}

								if (NetProps.GetPropInt(hGunOwner, "m_nButtons") & IN_ATTACK2) { // fire red portals
									// PrecacheSound(SND_PORTAL2_SHOOT)
									// self.QEmitSound(SND_PORTAL2_SHOOT)
									PlaySound(SND_PORTAL2_SHOOT, vecOrigin)
									ShootPortalProjectile(PORTALS.PORTAL2)
									break;
								}

								// if (NetProps.GetPropInt(hGunOwner, "m_nButtons") & IN_WALK) { // remove all portals
								// 	printl("DESTROY ALL PORTALS................")

								// 	for (local i = 0; i < 2; i++) {
								// 		local hSlot = aPortals[i]

								// 		if (ValidEntity(hSlot)) {
								// 			hSlot.GetScriptScope().iTimer = 9999
								// 		}
								// 	}

								// 	break;
								// }

								ClientPrint(hGunOwner, 3, "mel portal shoot")

								break;
							}

							iFireTimer++
				}

				if (!ValidEntity(hGunOwner) || hGunOwner != self.GetOwner()) {
					iDroppedTimer = 0
					iGunState = GUNSTATES.DROPPED
					NetProps.SetPropInt(self, "m_pConstraint", 1)
				}

				break;

			case GUNSTATES.DROPPED: // gun is dropped, buffer between unassigned
				// if (ValidEntity(hGunVisualWorld) && ValidEntity(hGunVisualModel)) {
				// 	hGunVisualWorld.AcceptInput("Enable", "", null, null); // hide penis gun
				// 	hGunVisualModel.Kill()

				// }
				if (iDroppedTimer >= MAX_DROPPED_TIME) {
					iDroppedTimer = 0
					iGunState = GUNSTATES.UNASSIGNED
					break;
				}
				iDroppedTimer++


				break;
			default:
				break;
		}

		return -1
	}
}

function ShootPortalProjectile(iPortalType) { // Portal gun projectile logic


	PrecacheModel(MDL_PROJECTILE)

	local hSprite = SpawnEntityFromTable("prop_dynamic", {
		model = MDL_PROJECTILE,
		// rendermode = 8,
		vscripts = "eltrasnag/laserinsurgency/li_portalprojectile.nut",
		rendercolor = aPortalColors[iPortalType]

	})

	hSprite.ValidateScriptScope()
	hSpriteScope <- hSprite.GetScriptScope()

	local qForward = hGunOwner.EyeAngles().Forward()
	if (ValidEntity(hGunOwner)) {

		// hGunOwner.ViewPunch(QAngle(653,RandomFloat(20,401), 643))
		hSprite.SetAbsOrigin(hGunOwner.EyePosition() + qForward * 8)
		hSpriteScope.iPortalType = iPortalType
		hSpriteScope.qMoveAngles = qForward
		hSpriteScope.hGunOwner = hGunOwner
		hSpriteScope.hGun <- self
		hSpriteScope.vecLastOrigin <- hGunOwner.EyePosition()
		hSpriteScope.vForward = hGunOwner.EyeAngles().Forward()
	}
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
		local hPortal = SpawnEntityFromTable("prop_dynamic", tPortalTable)
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