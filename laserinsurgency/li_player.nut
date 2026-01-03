const MAX_WEAPON_COUNT = 20
const EDTWT_MAX_FLOAT_TIME = 3
const EDTWT_MAX_HEALTH = 50
const BISEXUAL_MAX_WAIT_TIME = 25
const BISEXUAL_MAX_HEALTH = 30
const DEFENSE_MAX_TURRETS = 3

// asset paths

const SND_HOTCHIP01 = "eltra/eat_hot_chip01.mp3"
const SND_HOTCHIP02 = "eltra/eat_hot_chip02.mp3"
const SPRITE_PATH_LORDE = "eltra/lorde_sprite.vmt"
const SPRITE_PATH_TAYLOR = "eltra/taylor_sprite.vmt"
const SPRITE_PATH_SABRINA = "eltra/sabrina_sprite.vmt"
const SND_WEAPONSELECT = "Player.WeaponSelected"
const SND_WEAPONDENY = "Player.DenyWeaponSelection"
const EDTWT_MODEL = "models/eltra/rp_judith.mdl"
const PHILLIPINO_MODEL = "models/eltra/li_garfield.mdl"
const BISEXUAL_MODEL = "models/eltra/bisexual_mossman.mdl"
const LAURAPALMER_MODEL = "models/eltra/li_laurapalmer.mdl"
const MEL_MODEL = "models/eltra/li_mel.mdl"
const MDL_TURRET = "models/combine_turrets/floor_turret.mdl"
// buttons


flBisexualSabrinaCharge <- 0
flBisexualTaylorCharge <- 0
flBisexualLordeCharge <- 0
flBisexualChipCharge <- 0

iDefenseTurretCount <- 0;

enum POPGIRLIES {
	SABRINACARPENTER,
	TAYLORSWIFT,
	HOTCHIP,
	LORDE,
}
iBisexualSelection <- POPGIRLIES.SABRINACARPENTER

iMoney <- 0
strPlayerUID <- ""
hPlayerTextMoney <- null
hPlayerTextInfo <- null

tPlayerHUDInfo <- {
	"class" : "Class: NONE",
	"classinfo" : "NONE"
}

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

enum ZCLASSES {
	LI_ZCLASS_NONE,
}

enum TEAMS {
	HUMANS = 3,
	ZOMBIES = 2,
	SPECTATORS = 1,
	UNASSIGNED = 0,
}

iPlayerHClass <- HCLASSES.LI_CLASS_STRAIGHT;
iPlayerZClass <- ZCLASSES.LI_ZCLASS_NONE;
flLauraTimeAlive <- 0.0

function Init() {
	// AddThinkToEnt(self,"")
	AddThinkToEnt(self, "PlayerClassThink")
}

function GetClassFromString(new_class_string = "class_straight") {

	if (DEV)
		printl("GetClassFromString( " + new_class_string + " )")


	switch (new_class_string.tolower()) {
		case "class_straight":
			return HCLASSES.LI_CLASS_STRAIGHT

		case "class_bisexual":
			return HCLASSES.LI_CLASS_BISEXUAL

		case "class_edtwt":
			return HCLASSES.LI_CLASS_EDTWT

		case "class_hugger":
			return HCLASSES.LI_CLASS_HUGGER

		case "class_phillipino":
			return HCLASSES.LI_CLASS_PHILLIPINO

		case "class_sneaker":
			return HCLASSES.LI_CLASS_SNEAKER

		case "class_defense":
			return HCLASSES.LI_CLASS_DEFENSE

		case "class_laurapalmer":
			return HCLASSES.LI_CLASS_LAURAPALMER

			case "class_mel":
			return HCLASSES.LI_CLASS_MEL

		default:
			return HCLASSES.LI_CLASS_STRAIGHT

	}
}

function GetClassName() {
	local strClassName = "None"


	switch (iPlayerHClass) {
		case HCLASSES.LI_CLASS_STRAIGHT:
			strClassName = "Straight"
			// printl("Player Class is: "+strClassName)
			break;
		case HCLASSES.LI_CLASS_EDTWT:
			strClassName = "EDTWT"
			// printl("Player Class is: "+strClassName)
			break;
		case HCLASSES.LI_CLASS_BISEXUAL:
			strClassName = "Bisexual"
			// printl("Player Class is: "+strClassName)
			break;
		case HCLASSES.LI_CLASS_HUGGER:
			strClassName = "Hugger"
			// printl("Player Class is: "+strClassName)
			break;
		case HCLASSES.LI_CLASS_PHILLIPINO:
			strClassName = "Phillipino"
			// printl("Player Class is: "+strClassName)
			break;
		case HCLASSES.LI_CLASS_SNEAKER:
			strClassName = "Sneaker"
			// printl("Player Class is: "+strClassName)
			break;
		case HCLASSES.LI_CLASS_DEFENSE:
			strClassName = "Defense"
			// printl("Player Class is: "+strClassName)
			break;
		case HCLASSES.LI_CLASS_LAURAPALMER:
			strClassName = "Laura Palmer"
			// printl("Player Class is: "+strClassName)
			break;
		case HCLASSES.LI_CLASS_MEL:
			strClassName = "Mel"
			// printl("Player Class is: "+strClassName)
			break;
		default:
			strClassName = "CLASS_ERR_NAME"
			break;
	}
	return strClassName
}

function SetClassTo(new_class_value = HCLASSES.LI_CLASS_STRAIGHT) {
	if (type(new_class_value) == "string") {
		new_class_value = GetClassFromString(new_class_value)
	}

	switch (activator.GetTeam()) {
		case TEAMS.HUMANS:

			iPlayerHClass = new_class_value;
			break;
		case TEAMS.ZOMBIES:
			// iPlayerZClass = new_class_value;
			return;
			// break;
		default:
			break;
	}

	switch (new_class_value) { // playermodels and stuff
		case HCLASSES.LI_CLASS_EDTWT:
			NetProps.SetPropInt(self, "m_iMaxHealth", EDTWT_MAX_HEALTH)
			if (NetProps.GetPropInt(self, "m_iHealth") > EDTWT_MAX_HEALTH) {
				NetProps.SetPropInt(self, "m_iHealth", EDTWT_MAX_HEALTH)
			}
			PrecacheModel(EDTWT_MODEL)
			self.SetModel(EDTWT_MODEL)
			break;

		case HCLASSES.LI_CLASS_BISEXUAL:
			NetProps.SetPropInt(self, "m_iMaxHealth", BISEXUAL_MAX_HEALTH)
			if (NetProps.GetPropInt(self, "m_iHealth") > BISEXUAL_MAX_HEALTH) {
				NetProps.SetPropInt(self, "m_iHealth", BISEXUAL_MAX_HEALTH)
			}


			PrecacheModel(BISEXUAL_MODEL)
			self.SetModel(BISEXUAL_MODEL)

			break;
		case HCLASSES.LI_CLASS_LAURAPALMER:
			PrecacheModel(LAURAPALMER_MODEL)
			self.SetModel(LAURAPALMER_MODEL)
			iMoney = 0
			::REMAININGLAURAS++
			break;

		case HCLASSES.LI_CLASS_PHILLIPINO:
			PrecacheModel(PHILLIPINO_MODEL)
			self.SetModel(PHILLIPINO_MODEL)
			break;

		case HCLASSES.LI_CLASS_MEL:
			PrecacheModel(MEL_MODEL)
			self.SetModel(MEL_MODEL)
			break;

		default:
			break;
	}
}

function CreateGirlSprite(modelpath) {
	local hSprite = SpawnEntityFromTable("env_sprite", {
		model = modelpath,
		rendermode = 4

	})
	return hSprite
}

function CreateBisexualProjectile(iProjectileType) { // BISEXUAL PROJECTILE FUNC


	local tProjectileTable = {
		classname = "hegrenade_projectile",
		origin = self.EyePosition(),
		model = "models/gibs/antlion_gib_small_2.mdl",
		rendermode = 10,
		disableshadows = true,
	}

	PrecacheEntityFromTable(tProjectileTable)

	local hProjectile = SpawnEntityFromTable("hegrenade_projectile", tProjectileTable)



	PrecacheModel(EDTWT_MODEL)
	hProjectile.SetModel(EDTWT_MODEL)




	hProjectile.SetAbsAngles(self.GetAbsAngles())
	hProjectile.ValidateScriptScope()
	NetProps.SetPropBool(hProjectile,"m_bIsLive",true)
	NetProps.SetPropInt(hProjectile,"m_CollisionGroup",1)
	local hProjectileScope = hProjectile.GetScriptScope()

	hProjectileScope.LordeThink <- LordeThink
	hProjectileScope.SabrinaThink <- SabrinaThink
	hProjectileScope.HotChipThink <- HotChipThink
	hProjectileScope.iTimer <- 0

	local hSprite = null
	switch (iBisexualSelection)	{
		case POPGIRLIES.SABRINACARPENTER:
			hSprite = CreateGirlSprite(SPRITE_PATH_SABRINA)
			hProjectile.SetAbsOrigin(self.GetOrigin() + self.EyeAngles().Forward() * 64)
			hProjectile.SetAbsVelocity(self.EyeAngles().Forward() * 50)
			// hProjectile.AcceptInput("SetParent","!activator",self,null)

			hProjectileScope.hPlayer <- self
			AddThinkToEnt(hProjectile, "SabrinaThink")

			// NetProps.SetPropBool(hProjectile,"m_bIsLive",false)
			// NetProps.SetPropInt(hProjectile,"m_CollisionGroup",1)
			// hProjectile.AcceptInput("SetParentAttachment","!activator",self,null)

			break;
		case POPGIRLIES.TAYLORSWIFT:
			hSprite = CreateGirlSprite(SPRITE_PATH_TAYLOR)
			hProjectile.SetAbsVelocity(self.EyeAngles().Forward() * 1000) // do the throw
			break;
		case POPGIRLIES.LORDE:
			hSprite = CreateGirlSprite(SPRITE_PATH_LORDE)
			hProjectile.SetAbsVelocity(self.EyeAngles().Forward() * 1000) // do the throw
			AddThinkToEnt(hProjectile, "LordeThink")
			break;
		case POPGIRLIES.HOTCHIP:
			AddThinkToEnt(hProjectile, "HotChipThink")
			break;

		}

	if (hSprite != null) {
		hSprite.SetAbsOrigin(hProjectile.GetOrigin())
		hSprite.AcceptInput("SetParent","!activator",hProjectile,null)

	}





}

function CreatePlayerHUDTexts() {
	local hTextInfo = SpawnEntityFromTable("game_text", {
		color = "51 112 255",
		fadein = 0,
		fadeout = 0,
		holdtime = 0.5,
		channel = 0,
		x = 0.02,
		y = 0.25,
		spawnflags = 0,
	})

	hPlayerTextInfo = hTextInfo

	local hTextMoney = SpawnEntityFromTable("game_text", {
		color = "255 223 43",
		fadein = 0,
		fadeout = 0,
		holdtime = 0.5,
		channel = 1,
		x = 0.94,
		y = 0.25,
		spawnflags = 0,
	})

	hPlayerTextMoney = hTextMoney

}

function AddMoney(iAmount = 1) {

	if (iPlayerHClass == HCLASSES.LI_CLASS_LAURAPALMER) {
		iMoney += pow(iAmount, 1 + (0.025 * flLauraTimeAlive))
		return
	}

	iMoney += 1

}

function GetBisexualSelectionName() {
	switch (iBisexualSelection)	{
		case POPGIRLIES.SABRINACARPENTER:
			return "Sabrina Thats tat me Esperesso"
			// break; // redundant?
		case POPGIRLIES.TAYLORSWIFT:
			return "Taylor Swift Clit Collapser"
			// break; // redundant?
		case POPGIRLIES.LORDE:
			return "Lorde Pussy Bruh Blast"
			// break; // redundant?
		case POPGIRLIES.HOTCHIP:
			return "Eat hot Chip and Lie"
			// break; // redundant?

	}

}

function PlayerClassThink() {
	// printl(NetProps.GetPropInt(self, "m_nButtons")) // to see buttons !!!

	NetProps.SetPropInt(self, "m_iAccount", (iMoney * 5))

	local vOrigin = self.GetOrigin()
	local vEyePos = self.EyePosition()
	local qAngles = self.GetAbsAngles()
	local hSelfScope = self.GetScriptScope()

	if (ValidEntity(hPlayerTextInfo)) {
		tPlayerHUDInfo["class"] = "CLASS: "+GetClassName()
		local strHUDText = tPlayerHUDInfo["class"] + "\n" + tPlayerHUDInfo["classinfo"]

		// for (local i = 0; i < tPlayerHUDInfo.len(); i++) {

		// 	strHUDText += tPlayerHUDInfo[tPlayerHUDInfo.keys()[i]] + "\n"

		// }
		NetProps.SetPropString(hPlayerTextInfo, "m_iszMessage", strHUDText)
		NetProps.SetPropString(hPlayerTextMoney, "m_iszMessage", "You have:\n "+iMoney+" SCHWINGBUX")


		hPlayerTextInfo.AcceptInput("Display","",self, self)
		hPlayerTextMoney.AcceptInput("Display","",self, self)
	}
	else {
		CreatePlayerHUDTexts()
	}

	if (self && self.IsValid() && self != null) {
		local iPlayerTeam = self.GetTeam()

		switch (iPlayerTeam) {
			case TEAMS.HUMANS:
				// printl("Player is human")
				// printl(GetClassName())

				switch (iPlayerHClass) { // CLASS ACTIONS!!!! THE WORLD'S LONGEST FUNCTION
					case HCLASSES.LI_CLASS_STRAIGHT:


						break;
					case HCLASSES.LI_CLASS_EDTWT: // Edtwt Actions

						local strTimerName = "EDFloatTimer"+strPlayerUID

						if (!(strTimerName in ::TIMERS)) {
							::TIMERS[strTimerName] <- 0.0
						}





						NetProps.SetPropFloat(self, "m_flMaxspeed", 2000)
						NetProps.SetPropFloat(self, "m_flFriction", 0.001)

						if (NetProps.GetPropInt(self, "m_nButtons") & IN_SPEED) {
							NetProps.SetPropVector(self, "m_vecBaseVelocity", NetProps.GetPropVector(self, "m_vecBaseVelocity") * 2.0)
							NetProps.SetPropInt(self, "m_MaxSpeed", 700)
							NetProps.SetPropFloat(self, "m_flVelocityModifier", 3.0)
							// NetProps.SetPropBool(self, "m_bSpeedModActive", true)
							// NetProps.SetPropInt(self, "m_iSpeedModRadius", 99999999);
							// NetProps.SetPropInt(self, "m_iSpeedModSpeed", 200)
						}
						if (!(NetProps.GetPropInt(self, "m_nButtons") & IN_SPEED)) {
							NetProps.SetPropBool(self, "m_bSpeedModActive", false)
						}


						local flFloatTime = ::TIMERS[strTimerName]
						local flWorldTrace = TraceLine(vOrigin - Vector(0,0,0), vOrigin - Vector(0,0,99999), self)

						NetProps.SetPropInt(self, "m_MoveType", 2)

						if (flWorldTrace != 0) { // in air

							if (NetProps.GetPropInt(self, "m_nButtons") & IN_JUMP && flFloatTime < EDTWT_MAX_FLOAT_TIME) {
								NetProps.SetPropInt(self, "m_MoveType", 4)

							}

							if (NetProps.GetPropInt(self, "m_MoveType") == 4) { // increase timer when floating
								::TIMERS[strTimerName] += 0.1
							}


						}

						if ((flWorldTrace == 0)) { // recharge when on ground
								::TIMERS[strTimerName] = 0
						}








						break;
					case HCLASSES.LI_CLASS_BISEXUAL: // Bisexual Eat hot chip and lie


						tPlayerHUDInfo["classinfo"] <- "" +
						"SABRINA CARPENTER: "+floor(flBisexualSabrinaCharge).tostring()+"%" +
						"\nTAYLOR SWIFT: "+floor(flBisexualTaylorCharge).tostring()+"%" +
						"%\nEAT HOT CHIP: "+floor(flBisexualChipCharge).tostring()+"%" +
						"\nLORDE: "+floor(flBisexualLordeCharge).tostring() + "%"+
						"\n\nCURRENT SELECTION: "+GetBisexualSelectionName() // hud stuff

						flBisexualSabrinaCharge += 0.3
						flBisexualTaylorCharge += 0.2
						flBisexualLordeCharge += 0.2
						flBisexualChipCharge += 0.025

						flBisexualSabrinaCharge = clamp(flBisexualSabrinaCharge, 0, 100)
						flBisexualTaylorCharge = clamp(flBisexualTaylorCharge, 0, 100)
						flBisexualLordeCharge = clamp(flBisexualLordeCharge, 0, 100)
						flBisexualChipCharge = clamp(flBisexualChipCharge, 0, 100)

						local iMyWeaponSize = NetProps.GetPropArraySize(self, "m_hMyWeapons"); // deletes all non melee weapons
						local hActiveWeapon = NetProps.GetPropEntity(self,"m_hActiveWeapon");

						for (local i = 0; i < MAX_WEAPON_COUNT; i++) {

							local hWeap = NetProps.GetPropEntityArray(self, "m_hMyWeapons", i);

							if (hWeap != null && hWeap.IsValid())
							{
								if (hWeap.GetClassname() != "weapon_hegrenade") {
									MarkForPurge(hWeap);
									hWeap.Kill();

								}

								// printl(hWeap);
							}

						}


						//  bisexual weapon selection START

						local strTimerName = "BisexualSelectTimer"+strPlayerUID

						if (!(strTimerName in ::TIMERS)) {
							::TIMERS[strTimerName] <- 0.0
						}

						local flWaitSelectTime = ::TIMERS[strTimerName]

						// sound
						if ((NetProps.GetPropInt(self, "m_nButtons") & IN_ATTACK || NetProps.GetPropInt(self, "m_nButtons") & IN_ATTACK2) && flWaitSelectTime >= BISEXUAL_MAX_WAIT_TIME) {
							::TIMERS[strTimerName] = 0
							PrecacheScriptSound(SND_WEAPONSELECT)
							EmitSoundOnClient(SND_WEAPONSELECT, self)
						}

						if (NetProps.GetPropInt(self, "m_nButtons") & IN_ATTACK && flWaitSelectTime >= BISEXUAL_MAX_WAIT_TIME)
						{

							switch (iBisexualSelection) {
								case POPGIRLIES.SABRINACARPENTER:
									iBisexualSelection = POPGIRLIES.LORDE
									break;
								default:
									iBisexualSelection -= 1

							}
						}
						if (NetProps.GetPropInt(self, "m_nButtons") & IN_ATTACK2 && flWaitSelectTime >= BISEXUAL_MAX_WAIT_TIME)
						{

							switch (iBisexualSelection) {
								case POPGIRLIES.LORDE:
									iBisexualSelection = POPGIRLIES.SABRINACARPENTER
									break;
								default:
									iBisexualSelection += 1

							}
						}

						// bisexual weapon selection END

						if ( NetProps.GetPropInt(self, "m_nButtons") & IN_USE) { // bisexual attack
							switch (iBisexualSelection)
							{
								case POPGIRLIES.SABRINACARPENTER:
									if (flBisexualSabrinaCharge >= 100) {
										flBisexualSabrinaCharge = 0
										CreateBisexualProjectile(POPGIRLIES.SABRINACARPENTER)
									}
									break;

								case POPGIRLIES.TAYLORSWIFT:
									if (flBisexualTaylorCharge >= 100) {
										flBisexualTaylorCharge = 0
										CreateBisexualProjectile(POPGIRLIES.TAYLORSWIFT)
									}
									break;
								case POPGIRLIES.LORDE:
									if (flBisexualLordeCharge >= 100) {
										flBisexualLordeCharge = 0
										CreateBisexualProjectile(POPGIRLIES.LORDE)
									}
									break;
								case POPGIRLIES.HOTCHIP:
									if (flBisexualChipCharge >= 100) {
										flBisexualChipCharge = 0

										CreateBisexualProjectile(POPGIRLIES.HOTCHIP)
									}
									break;
							}
						}
						::TIMERS[strTimerName] += 1

						break;
					case HCLASSES.LI_CLASS_HUGGER:
						break;
					case HCLASSES.LI_CLASS_PHILLIPINO:
						break;
					case HCLASSES.LI_CLASS_SNEAKER:
						break;
					case HCLASSES.LI_CLASS_DEFENSE: // the turret guy ..... I dont know his Name ...Nope

						local strTimerName = "DEFTurretCooldown"+strPlayerUID

						if (!(strTimerName in ::TIMERS)) {
							::TIMERS[strTimerName] <- 0.0
						}

						if (NetProps.GetPropInt(self, "m_nButtons") & IN_USE && (iDefenseTurretCount < DEFENSE_MAX_TURRETS) && ::TIMERS[strTimerName] > BISEXUAL_MAX_WAIT_TIME) {
							::TIMERS[strTimerName] = 0
							local hTurret = SpawnEntityFromTable("prop_physics_override", {
								origin = vOrigin + self.GetForwardVector() * 50,
								angles = qAngles,
								model = MDL_TURRET,
								vscripts = "eltrasnag/laserinsurgency/li_turret.nut"
							})

							hTurret.ValidateScriptScope()
							hTurret.GetScriptScope().hOwner <- self;
							iDefenseTurretCount++
						}
						::TIMERS[strTimerName]++
					break;
					case HCLASSES.LI_CLASS_LAURAPALMER:
					flLauraTimeAlive += 0.001
					tPlayerHUDInfo["classinfo"] <- "REMAINING LAURAS: "+::REMAININGLAURAS.tostring()


						break;
					default:
						break;
				}



				break;
			case TEAMS.ZOMBIES:
				flLauraTimeAlive = 0
				// printl("Player is zombie")


				break;
			default:
				// printl("Player is unassigned")
				break;
		}
		if (TraceLine(vEyePos, vEyePos, self) == 0 && !self.IsNoclipping())
		{
			// printl("PLAYER STUCK HEEEELP")
			self.SetAbsOrigin(vOrigin + (vOrigin - vEyePos))
		}

		return -1
	}

}


// EVENTS LISTENING WHATEVER

// This handles all the dirty work, just copy paste it into your code
function CollectEventsInScope(events)
{
	local events_id = UniqueString()
	getroottable()[events_id] <- events
	local events_table = getroottable()[events_id]
	local Instance = self
	foreach (name, callback in events)
	{
		local callback_binded = callback.bindenv(this)
		events_table[name] = @(params) Instance.IsValid() ? callback_binded(params) : delete getroottable()[events_id]
	}
	__CollectGameEventCallbacks(events_table)
}

CollectEventsInScope
({
	OnGameEvent_smokegrenade_detonate = function(params)
	{
		local vecSmokePosition = Vector(params.x, params.y, params.z)

		if (iPlayerHClass == HCLASSES.LI_CLASS_BISEXUAL) {
			if (GetPlayerFromUserID(params.userid) == self)

				// CreateBisexualProjectile()

				print("bisexuasls")

		}

	}

})

function HotChipThink() {

	local vecPosition = self.GetOrigin()
	if (iTimer == 0)
		PrecacheSound(SND_HOTCHIP01)
		PrecacheSound(SND_HOTCHIP02)
		PrecacheParticle("li_hotchip")

		EmitSoundEx({
			origin = vecPosition,
			sound_name = SND_HOTCHIP01
		})




		local hChipFX = SpawnEntityFromTable("info_particle_system", {
			effect_name = "li_hotchip"
			origin = self.GetOrigin()
		})
		hChipFX.AcceptInput("SetParent","!activator",self,null)
		hChipFX.AcceptInput("Start","",null,null)

	iTimer += 0.25
	for (local hPlayer = null; hPlayer = Entities.FindByClassnameWithin(hPlayer, "player", vecPosition, 128);) {
		if (hPlayer.GetTeam() == TEAMS.HUMANS) {
			NetProps.SetPropInt(hPlayer, "m_iHealth", clamp(NetProps.GetPropInt(hPlayer, "m_iHealth") + 1, -1, NetProps.GetPropInt(hPlayer, "m_iMaxHealth") * 1.25))
			// hPlayer.SetAbsVelocity(PushAngle * 1000)

		}
	}

	if (iTimer >= 5) {
		EmitSoundEx({
			origin = vecPosition,
			sound_name = SND_HOTCHIP02
		})
		self.Kill()
	}
	return 0.25
}
function LordeThink() {
	local vecPosition = self.GetOrigin()
	if (iTimer == 0) {
		PrecacheParticle("li_lorde_bush_01")
		local hBushFX = SpawnEntityFromTable("info_particle_system", {
			effect_name = "li_lorde_bush_01"
			origin = self.GetOrigin()
		})
		hBushFX.AcceptInput("SetParent","!activator",self,null)
		hBushFX.AcceptInput("Start","",null,null)
		// DispatchParticleEffect("li_lorde_bush_01", vecPosition, Vector(0,90,0))

		// local PushAngle = GetAngleFromEntity(vecSmokePosition, self).Forward() * -1

	}
	iTimer += 0.05
	if (iTimer >= 0.25) {
		// local PushAngle = self.GetAbsAngles().Forward()

		for (local hPlayer = null; hPlayer = Entities.FindByClassnameWithin(hPlayer, "player", vecPosition, 256);) {
			if (hPlayer.GetTeam() == TEAMS.ZOMBIES) {
				local PushAngle = GetAngleFromEntity(hPlayer.GetOrigin(), self).Forward()

				hPlayer.SetAbsVelocity(PushAngle * 350)

			}
		}
	}
	if (iTimer >= 5)
		self.Kill()
	return 0.05
}

function SabrinaThink() {
	local vecPosition = self.GetOrigin()
	if (iTimer == 0) {
		PrecacheParticle("li_espresso")
		local hBushFX = SpawnEntityFromTable("info_particle_system", {
			effect_name = "li_espresso"
			origin = self.GetOrigin()
			angles = self.GetAbsAngles() + QAngle(0,90,0)
		})
		hBushFX.AcceptInput("SetParent","!activator",self,null)
		hBushFX.AcceptInput("Start","",null,null)

		// if (hPlayer != null && hPlayer.IsValid()) {
			// 	self.SetAbsAngles(hPlayer.EyeAngles())
			// }
	}
	if (iTimer >= 0) {
		local PushAngle = self.GetAbsAngles().Forward()

		for (local hPlayer = null; hPlayer = Entities.FindByClassnameWithin(hPlayer, "player", vecPosition + PushAngle * 256, 128);) { // further
			hPlayer.SetAbsVelocity(PushAngle * 128)

		}
		for (local hPlayer = null; hPlayer = Entities.FindByClassnameWithin(hPlayer, "player", vecPosition + PushAngle * 128, 128);) { // closer
			hPlayer.SetAbsVelocity(PushAngle * 500)

		}
	}

	if (iTimer >= 1)
		self.Kill()

	iTimer += 0.1
	return 0.1
}


