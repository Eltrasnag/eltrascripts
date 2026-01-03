// !CompilePal::IncludeFile("materials/eltra/banban_jumpscare.vmt")
// !CompilePal::IncludeFile("sound/eltra/lois_text.mp3")
// !CompilePal::IncludeFile("sound/eltra/what_da_hell.mp3")
// !CompilePal::IncludeFile("sound/eltra/pussy.mp3")
// !CompilePal::IncludeFile("sound/music/eltra/banban_targetted.mp3")

self.ValidateScriptScope()
::MapMaxApples <- 0
::MapApples <- 0
::MapFatty <- false

ELTMAP.MapFog <- "fog_banban"

bShouldLive <- false

// capacity_text_2 <- Entities.FindByName(null,"capacity_text_2")
// capacity_text_1 <- Entities.FindByName(null,"capacity_text_1")

iBridge1Players <- 0
iBridge2Players <- 0

vCheeseDest <- null
vCheeseDestCheckpoint <- Vector(4966, 2151, -750)


::MapSys <- self.GetScriptScope()
function MapCreds()
{
	QFire("poop", "Kill", "", 0.00, null);
    if (MAPSTATE == 0)
    {
    QFire("scripts_common", "RunScriptCode", "ze_map_say(`- "+GetMapName().toupper()+" -`)", 1.00, null)
    QFire("scripts_common", "RunScriptCode", "ze_map_say(`***MAP MADE BY ELTRA***`)", 3.00, null)
	local victim = "MATO"

	switch (MapStage) {
		case 0:
			victim = "MATO"
			break;
		case 1:
			victim = "ELTRA"
			break;
	}

    QFire("scripts_common", "RunScriptCode", "ze_map_say(`***MAP PAID FOR (5.95$ CAD) BY "+victim+" (SPEAKING NOW)***`)", 5.00, null)
    QFire("scripts_common", "RunScriptCode", "ze_map_say(`***MAP PAID FOR (5.95$ CAD) BY "+victim+" (SPEAKING NOW)***`)", 5.10, null)
    QFire("scripts_common", "RunScriptCode", "ze_map_say(`***MAP PAID FOR (5.95$ CAvore stompD) BY "+victim+" (SPEAKING NOW)***`)", 5.20, null)
    QFire("scripts_common", "RunScriptCode", "ze_map_say(`***MAP PAID FOR (5.95$ CAD) BY "+victim+" (SPEAKING NOW)***`)", 5.30, null)
    QFire("scripts_common", "RunScriptCode", "ze_map_say(`***MAP PAID FOR (5.95$ CAD) BY "+victim+" (SPEAKING NOW)***`)", 5.40, null)
    }
    if (MAPSTATE == 1)
    {
        QFire("cmd", "Command", "ze_map_say ||Map made by Eltra||", 3.00, null)
    }
}

function ButtonChallenge() {
	if (!bShouldLive) {
		MapSay("Wh ydidnt you listen.","Lois")
		ze_map_say("Poo on you")
		for (local ply; ply = Entities.FindByClassname(ply, "player");) {
			Jumpscare(ply)
			if (ply.GetTeam() == (TEAMS.HUMANS)) {
				ply.TakeDamage(999999999, Constants.FDmgType.DMG_DISSOLVE, null)

			}
		}
	}
	else {
		MapSay("hi", "lois")
	}
}


::deathfunc <- function(activator) {
	QFire("mapsys", "RunScriptCode", "SetCart(activator, false)", 0.0, activator)

}

if (!("Events" in getroottable())) {
		getroottable().Events <- {
				OnGameEvent_recalculate_holidays = function(event) {
					PlayerGuard()
				}

				OnGameEvent_player_death = function(params) {
					if (!(params.death_flags & 32)){
						deathfunc(GetPlayerFromUserID(params.userid))
					}
				}

				OnGameEvent_scorestats_accumulated_update = function(event) {
					PlayerGuard()
				}

				OnGameEvent_scorestats_accumulated_reset = function(event) {
					PlayerGuard()
				}
		}
		RegisterScriptGameEventListener("recalculate_holidays")
		printl("\n\n\n\n\nmake events")
		__CollectGameEventCallbacks(Events)
}

function SetSandstorm(enabled) {
	switch (enabled) {
		case true:
			SetSkyboxTexture("sandstorm_")
			MAPFUNC.SetFog("fog_sandstorm")
			AddThinkToEnt(self, "SandstormThink");
			break;
		case false:
			SetSkyboxTexture("banban_surreal")
			MAPFUNC.SetFog("fog_banban")
			AddThinkToEnt(self, "");
			break;

	}
}

function MAPFUNC.SetFog(fog_name) {
	ELTMAP.MapFog = fog_name
	QFire("player","setfogcontroller",fog_name)
}

function OnPostSpawn()
{

	SetSkyboxTexture("banban_surreal")
	QFireByHandle(self,"RunScriptCode","MAPFUNC.SetFog(`fog_banban`)",1)
	QFire("cmd","Command","sv_airaccelerate 150")
	// QFire("player*", "RunScriptCode", "")
	switch (MapStage) {
		case 0:
			if (!DEV) { // hello my name is mato

				QFire("diarrhea", "Trigger");
			}
			break;

		case 1:
			MapCreds()
			local tpdelay = 0
			QFire("tem_stage2","ForceSpawn")
			QFire("s2_movers*", "open")
			QFireByHandle(self, "RunScriptCode", "vCheeseDest = Entities.FindByName(null, `s2_valleydest`).GetOrigin()", 0.1)
			if (bFirstStage2) {
				tpdelay = 36
				QFire("sf_eltra_terms","PlaySound")
				QFire("sf_eltra_terms","StopSound","",tpdelay)
				QFire("round_timer", "SetTime","45",0.1)
				bFirstStage2 = false
			}
			QFire("mapsys", "RunScriptCode", "ze_map_say(`BAN BAN STAGE.............. TWO`)", tpdelay);
			QFire("s2_tp", "Enable", "", tpdelay);
			QFire("mus_s2_wallpaper","PlaySound","",tpdelay);
			QFire("round_timer", "SetTime","1800",tpdelay + 16)


			break;
		case 2:
			QFire("diarrhea", "Trigger");
			MapSay("I am coming to kill you now", "leshawna ball oc")
			QFire("salmonella", "CallScriptFunction", "Triggered()")
			break;
	}

}



::Jumpscare <- function(activator) {
	if (!ValidEntity(activator) || !activator.IsPlayer()) {
		return
	}
	activator.SetScriptOverlayMaterial("eltra/banban_jumpscare")
	PlaySound("npc/stalker/go_alert2a.wav", activator.GetOrigin())
	QFireByHandle(activator, "RunScriptCode", "if (ValidEntity(self)) { self.SetScriptOverlayMaterial(``) }", 1)
}

function SetCart(activator, entering = false) {
	if (IsInWaitingForPlayers()) {
		return;
	}

	local vOrigin = activator.GetOrigin() + Vector(0,0,10) // hack because i dont want to recompile v3a again :3
	local vAng = activator.GetAbsAngles()

	if (entering) { // Okay "Freed Void"
			local plyscope = activator.GetScriptScope()

			if ("cart_vis" in plyscope && plyscope.cart_vis != null && plyscope.cart_vis.IsValid()) {
				return
			}

			activator.SetMoveType(MOVETYPE_NONE, MOVECOLLIDE_DEFAULT)

			local cart = SpawnEntityFromTable("func_brush",{
				origin = vOrigin,
				model = BRUSHMODELS["sabrina_cart_visual"],
				// angles = vAng
				Solidity = 1,
				disableshadows = 1,
				rendercolor = Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)).ToKVString()
			})


			local cart_physics = SpawnEntityFromTable("func_physbox", { // changed to physbox_multiplayer in v3a surely this will have no adverse effects involving players getting deleted! // reverted in v3b DO NOT DO THIS!!!!!!!!!!!
				// model = "models/weapons/w_models/w_baseball.mdl",
				model = BRUSHMODELS["sabrina_cart"],
				targetname = "minecart",
				rendermode = 10,
				spawnflags = 16384,
				massScale = 5,
				disableshadows = 1,
				// health = 0,
				material = 2,
				overridescript = "surfaceprop,Slipperymetal,rotdamping,3,damping,0.001,friction,0.001",
				origin = vOrigin,

			})
			NetProps.SetPropString(cart_physics, "m_strMaterialName", "Slipperymetal")

			// local cart_visparent = SpawnEntityFromTable("prop_dynamic_ornament",{ // so player view doesnt go to hell and back
				// origin = vOrigin,
			// })

			// SetParentEX(cart_visparent, cart_physics)

			SetParentEX(cart, cart_physics)
			SetParentEX(activator, cart)




			plyscope.bJumped <- false
			plyscope.flNextJump <- 0
			plyscope.iJumpWait <- 2
			plyscope.CartRot <- 0
			plyscope.CartThink <- CartThink
			cart_physics.ValidateScriptScope()
			local cartscope = cart_physics.GetScriptScope()
			cartscope.CartEject <- CartEject
			cartscope.Player <- activator
			plyscope.cart_physics <- cart_physics
			plyscope.cart_vis <- cart
			AddThinkToEnt(activator, "CartThink")
			cart_physics.ConnectOutput("OnBreak","CartEject")
	}
	else {
			local plyscope = activator.GetScriptScope()
			if ("cart_vis" in plyscope && plyscope.cart_vis != null && plyscope.cart_vis.IsValid()) {

				AddThinkToEnt(activator, "")

				SetParentEX(activator,null)

				local vNewAng = QAngle(0,0,0)
				vNewAng.z = activator.GetAbsAngles().z
				activator.SetMoveType(MOVETYPE_WALK, MOVECOLLIDE_DEFAULT)
				activator.SetAbsAngles(vNewAng)
				QFireByHandle(plyscope.cart_physics,"Kill","",0.1)
				QFireByHandle(plyscope.cart_vis,"Kill","",0.1)
			}
	}
}

function CartEject() {

	AddThinkToEnt(Player, "")
	Player.AcceptInput("ClearParent", "",null,null)
	SetParentEX(Player,null)

	local vNewAng = QAngle(0,0,0)
	vNewAng.z = Player.GetAbsAngles().z
	Player.SetMoveType(MOVETYPE_WALK, MOVECOLLIDE_DEFAULT)
	Player.SetAbsAngles(vNewAng)
}
function CartThink() {
	local vOrigin = self.GetOrigin()
	local vAng = self.GetAbsAngles()

	if (cart_vis != null && cart_vis.IsValid() && cart_physics != null && cart_physics.IsValid()) {
		local vCartAng = cart_vis.GetAbsAngles()
		local vEyeAng = self.EyeAngles()
		// local vCartAng = cart_physics.GetPhysVelocity()
		vCartAng.x = 0
		vCartAng.z = 0
		vCartAng.y = CartRot



		// vCartAng.y
		// cart_vis.SetAngles(0,0,vCartAng.z)
		cart_vis.SetAbsAngles(vCartAng)
		// printl("Cartang: " + vCartAng.tostring())
		// cart_vis.SetForwardVector(vCartAng * 180/PI)
		local cartvel = cart_physics.GetPhysVelocity()
		if (NetProps.GetPropInt(self, "m_nButtons") & IN_JUMP && Time() >= flNextJump) {
			flNextJump = Time() + iJumpWait
			print("boing")
			cartvel += Vector(0,0,1500)
		}

		local cart_increase = 3
		if (NetProps.GetPropInt(self, "m_nButtons") & IN_FORWARD) {
			cartvel -= (vCartAng.Left()*20)

		}
		else if (NetProps.GetPropInt(self, "m_nButtons") & IN_BACK) {
			cartvel -= (vCartAng.Left()*-10)

		}
		if (NetProps.GetPropInt(self, "m_nButtons") & IN_MOVELEFT) {
			CartRot += cart_increase

		}
		if (NetProps.GetPropInt(self, "m_nButtons") & IN_MOVERIGHT) {
			CartRot -= cart_increase

		}

		cart_physics.SetPhysVelocity(cartvel)
	}
	return -1
}

function LHPizza(activator) {
	PlaySoundEX("eltra/lois_text.mp3", activator.GetOrigin())
	activator.SetAbsVelocity(Vector(RandomInt(-3000,3000), RandomInt(-3000,3000), RandomInt(300,3000)))
	activator.TakeDamage(32, Constants.FDmgType.DMG_DISSOLVE, null);
}

::DEV_TP_ALL <- function(activator) {
	for (local ply; ply = Entities.FindByClassname(ply, "player");) {
		ply.SetAbsOrigin(activator.GetOrigin() + Vector(RandomFloat(-512, 512), RandomFloat(-512, 512), 0));
	}
}

// wipeout

function WOBall(activator) {

	local nvel = activator.GetAbsVelocity()
	local fvec = activator.GetForwardVector()

	nvel.z = 500
	nvel.x += fvec.x*500
	nvel.y += fvec.y*500
	activator.SetAbsVelocity(nvel + (activator.GetForwardVector()*30))
}

function WOFail(activator, checkpoint = false) {
	switch (checkpoint) {
		case false:
			activator.SetAbsOrigin(vCheeseDest)
			break;
		case true:
			activator.SetAbsOrigin(vCheeseDestCheckpoint)
			break;
	}
}

::StageWin <- function() {
	switch (MapStage) {
		case 0:
			ze_map_say("*** THE MAP IS OVER... ***")
			ze_map_say("*** YOU... YOU FINALLY DID IT. ***")
			MapStage = 1
			QFire("bluwin","roundwin")
			break;
		case 1:
			SetSandstorm(false)
			QFire("mus_s2_pslide","stopsound")
			ze_map_say("*** THE END ***")
			MapSayDelay("*** MAP MADE BY - ELTRA ***","map",1)
			QFire("bluwin","roundwin")
			// MapSayArray(["*** MAP MADE BY - ELTRA ***","*** FUCK YOU FOR PLAYING ***","*** THE END ***"])
			MapStage = 0
			break;
	}
}

function SandstormThink() {
	local shaker = SpawnEntityFromTable("env_shake", {
		spawnflags = 29,
		frequency = 2.5,
		duration = 1,
		amplitude = 5,
		targetname = "the shaker"
	})
	shaker.AcceptInput("StartShake","",null,null)
	shaker.Kill()
}

function CheeseSet(activator, enabled) {
	switch (enabled) {
		case true:
		activator.AddCond(Constants.ETFCond.TF_COND_INVULNERABLE_HIDE_UNLESS_DAMAGED)
		// activator.AddCond(75)
		activator.GetScriptScope().CheeseThink <- CheeseThink
		AddThinkToEnt(activator, "CheeseThink");

		break;

		case false:

			AddThinkToEnt(activator, "");
			if (activator.GetTeam() == (TEAMS.HUMANS)) {
				activator.SetHealth(200)

			}
			activator.RemoveCond(Constants.ETFCond.TF_COND_INVULNERABLE_HIDE_UNLESS_DAMAGED)
			// activator.RemoveCond(75)
		break;
	}
}

function CheeseThink() {
	self.AddCond(Constants.ETFCond.TF_COND_INVULNERABLE_HIDE_UNLESS_DAMAGED)
	if (self.GetTeam() == TEAMS.HUMANS) {
		self.SetHealth(80000)

	}
	return 0.1
}

function FakeTP(activator, dest_name) { // avoid player void bug caused by normal tps
	local dest = Entities.FindByName(null, dest_name)
	SetCart(activator, false)
	activator.SetAbsOrigin(dest.GetOrigin())
	activator.SetAbsAngles(dest.GetAbsAngles())
}
function CheeseWin(activator) {
	switch (activator.GetTeam()) {
		case TEAMS.HUMANS:

			ze_map_say("***Press this button to SUMMON A FARTSTORM!!!!!!!!!!!!!!!!!!!!!***")
			ze_map_say("GET TO THE FART SHELTER!!!!!!!!!!! RUN!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
			QFire("cmd","Command","ze_map_timer 40")
			ze_map_say("GET TO THE FART SHELTER!!!!!!!!!!! RUN!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
			ze_map_say("GET TO THE FART SHELTER!!!!!!!!!!! RUN!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
			ze_map_say("GET TO THE FART SHELTER!!!!!!!!!!! RUN!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
			MapSay("EMail: The fart shelter door will close in 40 seconds.", "lois")
			MapSay("EMail: The fart shelter door will close in 40 seconds.", "lois")
			MapSayDelay("EMail: The fart shelter door will close in 40 seconds.", "lois",1)
			SetSandstorm(true)
			QFire("s2_cheesefences", "Break")
			QFire("s2_cheeseaffector", "Kill")
			QFire("mus_s2_pslide","PlaySound")
			QFire("s2_cheese_shelter_annot","Show")
			QFire("s2_shelterdoor","Enable","",40)
			QFire("mus_s2_pslide","StopSound","",40)
			QFire("mapsys", "RunScriptCode", "bruhstorm();", 40)
			MapSayDelay("Thjat was freaking close. *Poos", "lois",40)
			MapSayDelay("Lets go to the final vboss now", "lois",43)

			QFire("s2_bosstp_h","Enable","",45)
			QFire("s2_bosstp","Enable","",46)

			ScreenFade(null,255,255,255,255,0.5,0.1,1)
			QFire("mus_s2_intestines","StopSound")
			ClientPrint(null, Constants.EHudNotify.HUD_PRINTCENTER, "GET TO THE FART SHELTER BEFORE IT CLOSES!")
			for (local ply; ply = Entities.FindByClassname(ply, "player");) {
				CheeseSet(ply, false)
			}

			break;

			case TEAMS.ZOMBIES:
				QFire("redwin","roundwin")
				ze_map_say("EPIC ZOMBIE WIN!!!!!!!!!!! BETTER LUCK NEXT TIME SLOWHEADS")
				for (local ply; ply = Entities.FindByClassname(ply, "player");) {
					if (ply.GetTeam() == TEAMS.HUMANS) {
						ply.TakeDamage(99999999, Constants.FDmgType.DMG_DISSOLVE, null);
						Jumpscare(ply)
					}
				}
			break;
	}
}

function bruhstorm() { // it was causing an error in runscriptcode and i dont have time nor do i care to find out why so have a fun hackD
	SetSandstorm(false)
}

function KillBerke(activator) {
	if (NetProps.GetPropString(activator, "m_szNetworkIDString") == "[U:1:190285622]") {
		activator.TakeDamage(999999999, Constants.FDmgType.DMG_BLAST, null)
	}
}

function LoadSay(activator, entered, bridge_num) {
	local capacity = 0

	local strnum = "" + bridge_num.tostring()+"\x07ffffff"
		switch (bridge_num) {
			case 1:
				capacity = iBridge1Players
			break;
			case 2:
				capacity = iBridge2Players

				break;
		}

	if (entered == true) {


		local basetext = "\x07ff0000" + GetPlayerName(activator).toupper() + "\x07ffffff IS NOW CROSSING BRIDGE " + strnum + ". "
		local loadadd = "BRIDGE " + strnum + "\x07ffffff'S CURRENT LOAD NOW STANDS AT: " + capacity.tostring() + "/10."

		if (capacity >= 6)  {
			loadadd = "\x07ff0000[UH OH!] \x07ffffffONLY \x07ff0000" + (10 - capacity).tostring() + "\x07ffffff MORE PLAYERS CAN FIT ON BRIDGE "+strnum+"\x07ffffff!!!"
		}

		MapSay(basetext + loadadd, "lois")
	} else {
		MapSay("\x07ff0000" + GetPlayerName(activator).toupper() + "\x07ffffff HAS JUST FINISHED CROSSING BRIDGE " + strnum + ". LOAD IS CURRENTLY: " + capacity.tostring() + "/10.", "lois")
	}

}
function BridgeThink() {
	// QFire("capacity_text_2", "addoutput", "message CURRENT LOAD: "+ iBridge1Players.tostring()+"")
	for (local i; i = Entities.FindByName(i, "capacity_text_1");) {
		i.KeyValueFromString("message", "CURRENT LOAD: "+ iBridge1Players.tostring())
	}

	for (local i; i = Entities.FindByName(i, "capacity_text_2");) {
		i.KeyValueFromString("message", "CURRENT LOAD: "+ iBridge2Players.tostring())
	}

	if (iBridge1Players > 10) {
		QFire("bridge_struct_1","Open")
	}
	if (iBridge2Players > 10) {
		QFire("bridge_struct_2","Open")
	}
	return 0.25
}

function MapperHax(activator) {
	local scope = activator.GetScriptScope()
	scope.MapperThink <- MapperThink
	AddThinkToEnt(activator, "MapperThink")
}

function MapperThink() { // bottle simulator
	if (ButtonPressed(self, IN_DUCK) && ButtonPressed(self, IN_JUMP)) {
		if (!self.IsNoclipping()) {
			self.SetMoveType(Constants.EMoveType.MOVETYPE_NOCLIP, Constants.EMoveCollide.MOVECOLLIDE_DEFAULT)
		}
		else
		{
			self.SetMoveType(Constants.EMoveType.MOVETYPE_WALK, Constants.EMoveCollide.MOVECOLLIDE_DEFAULT)
		}

	}
}

function EltraTP(activator) {
	if (NetProps.GetPropString(activator,"m_szNetworkIDString") == ELTRA_STEAMID) {
		FakeTP(activator, "e_dest")
	}
}