

// RegisterScriptGameEventListener("player_spawn")
// Some global entities

// ::devbool<- "DEVELOPER";
// berke_map_manager <- null;

::active_fog_controller <- ""
const creaksnd = "ambient/materials/wood_creak_"

main_text <- Entities.FindByName(null, "s5_maintext");
const tp_prefix = "s5_tp_";

FloorCheck <- false;

enum teams {
	ct = 3,
	t = 2,
}

::ROLEPLAY_ENGAGE <- true; // Judith

DEV <- false; // pretty much ONLY for the floor stage so we dont just die when testing


// Tracking of some script values

::hyper_tp <- "s5_dest_startportal" // map zm tp dest
map_teleports <- {};


::max_portal_sounds <- 16
::active_portal_sounds <- 16

::current_slender_pages <- 0
last_current_slender_pages <- 0

enum areas {
	hypertown = 0,
	erastour = 1,
	twitter = 2,
	hydro = 3,
	finalboss = 4,
}

::levelprogress <- areas.hypertown;


clamp <- function(x, min, max) {
	if (min > x) {
		x = min
		return min
	}
	if (max < x) {
		x = max
		return max
	}
	return x
}

::MapSay <- function (msg)
{
	QFire("map1manager1", "runscriptcode", "MapPrintToChatAll(`" + msg + "`)", 0.0, null)
	// ClientPrint(null, 3, "DEBUG: " + msg);
}

function ShowScreenText(input) {
	main_text.KeyValueFromString("message", input);
	main_text.AcceptInput("Display", "", null, null);
}

function OnPostSpawn() {

	// if !
	ClearGameEventCallbacks()
	__CollectGameEventCallbacks(this)

	QFire("precache*", "Kill", "", 0.1, null)
	// QFire("credits_viewcontrol", "Disable", "", 0.1, null)
	SetMapFog("x_fog_main")


	// to make mapping faster & to avoid possible wrongwarps in the stage, instead of managing a
	// bunch of tp triggers we just put them into a dict
	//  & have all triggers pointing to one main tp

	for (local i_relay = null; i_relay = Entities.FindByName(i_relay, tp_prefix + "*");) {
		local tp_table = [i_relay.GetOrigin(), i_relay.GetAbsAngles()]
		local tp_name = i_relay.GetName()
		map_teleports[tp_name] <- clone tp_table;
		// i_relay.Kill()
		printl("dev: Added teleport named '"+tp_name+"' to map teleports dict")
	}

}

function FloorStage_EnableKiller() {
	FloorCheck = true
	printl("ELTRASCRIPTS: Enabling CT checker...")
}


function FloorStage_DisableKiller() {
	FloorCheck = false
	printl("ELTRASCRIPTS: Disabling CT checker...")
}

function FloorStage_KillChecker() {
	try {

		local i_player = null
		local total_cts = 0
		local cts_array = []

		while (i_player = Entities.FindByClassname(i_player, "player")) {
			if (i_player.GetTeam() == teams.ct) {
				total_cts += 1
				cts_array.append(i_player)
			}
		}

		local cts_length = cts_array.len()

		if (total_cts < 5) {

			if (DEV) {
				printl("FLOORSTAGE_KILLCHECKER: not enough cts alive! this WOULD kill them, but script is in DEV mode so we wont do anything")
				return
			}

			for (local cts = 0; cts < cts_array; cts++) {
				cts_array[cts].TakeDamage(999999, 0, null);
				MapSay("*** NOT ENOUGH CTS LEFT ALIVE - KILLING TO SAVE TIME... ***")
				AddThinkToEnt(self, "")
			}
		}
	} catch (exception){
		printl("\n\n\n\n\n\nERROR IN KILLCHECKER CODE: "+exception)
	}

}


function MainLoop() { // main gameplay think for hyperborea stage

	if (FloorCheck == true) { // this is JUST for floor stage so he can stop delahying i think? this is NOT for hyperborea // guys idint think we were Actually racist i thout it was a Bit D:
		FloorStage_KillChecker()
	}



	// switch (levelprogress) { // this is obsolete now that all the hportal stages had to be removed :(
	// 	case areas.hypertown:

	// 		break;
	// 	case areas.erastour:
	// 		break;
	// 	case areas.twitter:
	// 		if (last_current_slender_pages != current_slender_pages) {
	// 			SlenderPageUpdate()
	// 		}
	// 		last_current_slender_pages = current_slender_pages

	// 		break;
	// 	case areas.hydro:
	// 		break;
	// 	case areas.finalboss:

	// 		break;
	// 	default:
	// 		break;
	// }
	return 1
}

function SlenderPageUpdate() {
	if (current_slender_pages <= 8) {
		ShowScreenText("-=COLLECTED PAGE " + current_slender_pages + " OF 8=-")

	}

	switch (current_slender_pages) {
		case 1:
			break;
		case 8:
			current_slender_pages = 9
			QFire("tornado_master", "RunScriptCode", "EndSequence()", 0.00, null)
			// EndTornadoSequence()
			MapSay("*** ALL PAGES COLLECTED! - GATE NEAR THE CABIN IS OPENING, GO AND CHASE TRUMP! ***")
			// QFire("map1manager1", "RunScriptCode", "MapPrintToChatAll(`*** ALL PAGES COLLECTED! - GATE NEAR THE CABIN IS OPENING, GO AND CHASE TRUMP! ***`)", 0.00, null)
			break;
		default:
			break;
	}
}

function SlenderMakePages() {
	local i_pagemaker = null
	local active_slender_pages = 0
	local pages_template = Entities.FindByName(null, "s5_pagemaker")
	local random_bound_high = 4
	local desired_value = random_bound_high / 2

	while (i_pagemaker = Entities.FindByName(i_pagemaker, "slender_page_position"))
	{
		if (active_slender_pages < 8) {
			if (i_pagemaker != null && i_pagemaker.IsValid())
			{
				if (RandomInt(0, random_bound_high) == desired_value) {
					active_slender_pages += 1
					pages_template.SetAbsOrigin(i_pagemaker.GetOrigin())
					pages_template.SetAbsAngles(i_pagemaker.GetAbsAngles())
					pages_template.AcceptInput("ForceSpawn", "", null, null);
					// printl("dev: page "+active_slender_pages+" spawned at coord: "+i_pagemaker.GetOrigin())
					printl("dev: spawned page "+active_slender_pages+" of 8")
					i_pagemaker.Kill()
				}
			}

		}
		else {
			break;
		}
	}
	if (active_slender_pages < 8) {

		i_pagemaker = null
		while (i_pagemaker = Entities.FindByName(i_pagemaker, "slender_page_position"))
		{
			if (active_slender_pages < 8) {
				if (i_pagemaker != null && i_pagemaker.IsValid())
				{
					active_slender_pages += 1
					pages_template.SetAbsOrigin(i_pagemaker.GetOrigin())
					pages_template.SetAbsAngles(i_pagemaker.GetAbsAngles())
					pages_template.AcceptInput("ForceSpawn", "", null, null);
					// printl("dev: page "+active_slender_pages+" spawned at coord: "+i_pagemaker.GetOrigin())
					// printl("fat ho")
					i_pagemaker.Kill()
				}

			}
			else {
				// printl("Today I will End the Why Loop")
				break;
			}
		}
	}

}

function OnGameEvent_player_spawn(uid) { // player spawn function
	// data["userid"]
	// data.userid

	// try {
		local ply = GetPlayerFromUserID(uid["userid"]);
		// printl("USER ID TEST:"+uid["userid"])
		// ply.AcceptInput("RunScriptCode", "shelter <- false", null, null);
		ply.AcceptInput("SetFogController", active_fog_controller, null, null)
		ply.ValidateScriptScope()
		local ply_scope =  ply.GetScriptScope()

		ply_scope.shelter <- false;

		local player_team = ply.GetTeam()



		// PREPARE PLAYER FOR IMMERSIVE ROLEPLAY EXPERIENCE
		if (ROLEPLAY_ENGAGE && ((player_team == teams.ct)||(player_team == teams.t))) {



			local player_pos = ply.GetOrigin()
			local player_angles = ply.GetAbsAngles()
			local modelpath = null;

			switch (player_team) {
				case teams.ct:
					PrecacheModel("models/eltra/rp_judith.mdl")
					ply.SetModel("models/eltra/rp_judith.mdl")
					break;
				case teams.t:
					PrecacheModel("models/eltra/rp_kleiner.mdl")
					ply.SetModel("models/eltra/rp_kleiner.mdl")
					break;
				default:
					break;
			}




			// old method where it would spawn a prop dynamic on the player (it looked really funny)
			// ply.AcceptInput("AddOutput","rendermode 10",null,null)
			// local FakeModel = MakeRoleplayModel(ply)
			// ply_scope.FakeModel <- FakeModel
			// ply_scope.MakeRoleplayModel <- MakeRoleplayModel
			// FakeModel.AcceptInput("SetParent","!activator",ply,null);


			ply_scope.Last_Buttons <- null;
			ply_scope.Money <- 0
			ply_scope.Visual_Money <- 0
			ply_scope.Next_Visual_Money_Update <- 0
			ply_scope.Next_Voice_Time <- 0
			ply_scope.Money_Text <- MakeMoneyTextEnt(ply)

			ply_scope.RoleplayThink <- RoleplayThink
			ply_scope.MakeMoneyTextEnt <- MakeMoneyTextEnt
			ply_scope.GiveMoney <- GiveMoney
			ply_scope.TakeMoney <- TakeMoney
			ply_scope.Purchase_Array <- []
			// ply_scope.MakeRoleplayHUD <- MakeRoleplayHUD
			AddThinkToEnt(ply, "RoleplayThink")


			printl("Judith Engage")



		}
		else {
			printl("this is no roleplay world...........")
			AddThinkToEnt(ply, "")
			ply_scope.FakeModel <- null
			ply.AcceptInput("AddOutput","rendermode 0",null,null)
			RoleplayThink <- null;
			ply_scope.MakeRoleplayModel <- null
		}

	// } catch (exception){
	// 	printl("\n\n\n"+exception+"\n\n\n")
	// }
}

::SetMapFog <- function(new_fog) {
	active_fog_controller = new_fog
	QFire("player*", "SetFogController", new_fog, 0.1, null);
}

GetDistance <- function(vec2, vec1)
{

	local result = sqrt(pow(vec2.x - vec1.x, 2) + pow(vec2.y - vec1.y, 2));

	// MapSay("GetDistance result: "+result)
	return result
}

::LookAtFromPos <- function(to, from_ent)
{
	local from = from_ent.GetOrigin();
	return QAngle(0, atan2(from.y - to.y, from.x - to.x) * 180 / PI, 0)
}
::GetMoveDelta <- function(pos_i,pos_f) {

	local vec_length = Vector(pos_f.x - pos_i.x, pos_f.y - pos_i.y, pos_f.z - pos_i.z);

	vec_length.Norm();
	local new_pos = vec_length;

	return new_pos
}

::GetPlayerTeam <- function(player) {
	return NetProps.GetPropInt(player, "m_iTeamNum")
	// if (player != null && player.IsValid()) { // do we even need to do null checks for things like this ?

	// }
}

function DeathPit(player) {
	if (player != null && player.IsValid()) {
		switch (GetPlayerTeam(player)) {
			case teams.ct:
				// player.AcceptInput("health", "-1", null, null)
				player.TakeDamage(99999, 0, null);
				break;
			case teams.t:
				player.SetAbsOrigin(map_teleports[hyper_tp][0])
				player.SetAbsAngles(map_teleports[hyper_tp][1])
				player.SetAbsVelocity(Vector(0, 0, 0))
				break;
			default:
				break;
		}

	}
}

function MapTeleport(player) {
	if (player != null && player.IsValid()) {
		switch (GetPlayerTeam(player)) {
			case teams.ct:
				player.TakeDamage(20,1,null)
				break;
			case teams.t:
				break;
			default:
				break;
				}

			}
		player.SetAbsVelocity(Vector(0, 0, 0))
		// player.SetAbsOrigin(map_teleports[hyper_tp][0])
		// player.SetAbsAngles(map_teleports[hyper_tp][1])
}

::GetRandomCT <- function() {
	local cts = []
	local i_player = null

	while (i_player = Entities.FindByClassname(i_player, "Player"))
	{
		if (GetPlayerTeam(i_player) == teams.ct) {
			cts.append(i_player)
		}

	}

	local returning = cts[RandomInt(0, cts.len() - 1)]
	printl("picked random ct: "+GetPlayerName(returning))
	return returning
}

GetPlayerName <- function(handle){
	if (handle != null) {
		return NetProps.GetPropString(handle, "m_szNetname")
	}
}

::SpawnParticleAtPosition <- function(particle_name, pos) {
	local pcf_ent = PrecacheEntityFromTable({
		classname = "info_particle_system"
		start_active = true,
		effect_name = particle_name,
		origin = pos,
	})
	// pcf_ent.AcceptInput("start", "", null, null)
	// QFireByHandle(pcf_ent, "Stop", "", 0.1, null, null);
	DispatchParticleEffect(particle_name, pos, Vector(0, 0, 0))
	// self.AcceptInput("Kill", "", 0.00, handle caller)
}
//  = "MapSayWithDelay called without input; check code!!!"
::MapSayWithDelay <- function(input, time = 0.0) {
	printl("mapsay called with delay "+time)
	QFire("scripts_main", "RunScriptCode", "MapSay(\"" + input + "\");", time, null);
}

function EndRoundCTWin() {
	try {
		local i_player = null

		while (i_player = Entities.FindByClassname(i_player, "Player"))
		{
			if (i_player.GetTeam() == teams.t) {
				i_player.TakeDamage(99999999, 0, null)
			}

		}
	} catch (exception){
		printl("EXCEPTION IN ENDROUNDCTWIN: "+exception)
		printl("Note this likely is just because there is no t on the other team, scenario likely impossible in real gameplay")
	}

}

function PlayCoveredBridgeCreak(activator) { // play random sounds on the covered bridge to make it more obvious that it will break

	local activator_origin = activator.GetOrigin() // get activator origin for sound
	local sound_path = creaksnd+RandomInt(1, 6)+".wav" // generate soundpath

	PrecacheScriptSound(sound_path); // precache the soundpath

	EmitSoundEx({ // play the sound !!!
		sound_name = sound_path,
		origin = activator_origin,
		pitch = RandomFloat(95, 105),
		channel = 1,

	})
}




::MakePeso <- function(input) {

	local spawn_pos = null

	local type_of = typeof input
	printl("TYPE OF : "+type_of)
	switch (type_of) {
		case "String":
			spawn_pos = Entities.FindByName(null, spawn_pos_targetname).GetOrigin()
			break;
		case "Instance":
			spawn_pos = input.GetOrigin()
			break;
		case "Vector":
			spawn_pos = input;
			break;
		default:
			return null
			break;
	}

	local peso = SpawnEntityFromTable("prop_dynamic", {
		model = "models/eltra/mexican_peso.mdl",
		vscripts = "eltrasnag/trumpocalypse/rp_peso.nut"
		origin = spawn_pos
	})
}


function RoleplayThink() {

	local game_time = Time();
	local IN_USE = 32;
	local IN_ATTACK = 1;

	local buttons = NetProps.GetPropInt(self, "m_nButtons")

	if ((Next_Voice_Time <= game_time) && (buttons & IN_ATTACK)) // voicelines
	{
		switch (self.GetTeam()) {
			case 3: // ct (judith)

				local sound_path = "vo/eli_lab/mo_thiswaydoc.wav"
				PrecacheSound(sound_path)
				EmitSoundEx({ // play the sound !!!
				sound_name = sound_path,
				entity = self,
				speaker_entity = self,
				channel = 2,
				sound_level = 0.5,
				pitch = RandomFloat(98, 102),
				// channel = ,
				})

				break;
				case 2: // t (kleiner)

				local sound_path = "vo/k_lab/kl_fiddlesticks.wav"
				PrecacheSound(sound_path)
				EmitSoundEx({ // play the sound !!!
				sound_name = sound_path,
				entity = self,
				speaker_entity = self,
				channel = 2,
				sound_level = 0.5,
				pitch = RandomFloat(98, 102),
				// channel = ,
				})
				break;
			default:
				break;
		}
		Next_Voice_Time = game_time + 1
	}

	if ((Money_Text != null) && (Money_Text.IsValid())) {
		Money_Text.AcceptInput("Display","",self,self)
		Money_Text.KeyValueFromString("message", "YOU HAVE : "+ Visual_Money +" MEXICAN PESOS")
	}
	else {
		Money_Text = MakeMoneyTextEnt(self)
	}

	if ((Next_Visual_Money_Update <= game_time) && ((Money != Visual_Money) && (Visual_Money < Money))) {

		Visual_Money += 1
		local money_path = "eltra/tp_money_get.mp3"
		PrecacheSound(money_path)

		EmitSoundEx({ // play the sound !!!
			sound_name = money_path,
			origin = self.GetOrigin(),
			pitch = RandomFloat(95, 105),
			channel = 1,

		})


		Next_Visual_Money_Update = game_time + 0.05
	}

	if ((Money != Visual_Money) && (Visual_Money > Money)) {
		Visual_Money -= 1

		local money_path = "eltra/tp_money_get.mp3"
		PrecacheSound(money_path)

		EmitSoundEx({ // play the sound !!!
			sound_name = money_path,
			origin = self.GetOrigin(),
			pitch = RandomFloat(70, 70),
			channel = 1,

		})

		Next_Visual_Money_Update = game_time + 0.1
	}

	return -1



	// if ((FakeModel != null && FakeModel.IsValid())) {
	// 	// return
	// 	// noooo dontmake me assign each of these to the scope i WILL kill myself
	// 	if (Last_Buttons != buttons) {

	// 		local IN_MOVEFORWARD = 8;
	// 		local IN_BACK = 16;
	// 		local IN_MOVELEFT = 512;
	// 		local IN_MOVERIGHT = 1024;
	// 		local IN_JUMP = 2;


	// 		// Judith Animations


	// 		if ((buttons & (IN_MOVEFORWARD|IN_MOVELEFT|IN_MOVERIGHT|IN_BACK)) && !(buttons & IN_JUMP)) {
	// 			FakeModel.AcceptInput("SetAnimation","run_all",null,null)
	// 		}

	// 		if (buttons & IN_JUMP) {
	// 			FakeModel.AcceptInput("SetAnimation","jump_holding_glide",null,null)
	// 		}

	// 		if (!(buttons & (IN_MOVEFORWARD|IN_MOVELEFT|IN_MOVERIGHT|IN_BACK|IN_JUMP))) {
	// 			FakeModel.AcceptInput("SetAnimation","idle_subtle",null,null)
	// 		}
	// 	}
	// 	Last_Buttons = buttons

	// }
	// else {
	// 	FakeModel = MakeRoleplayModel(self)
	// }
}

function MakeRoleplayModel(entity) {

	local ent_pos = entity.GetOrigin()
	local ent_angles = entity.GetAbsAngles()

	local ent_team = entity.GetTeam()

	local modelpath = null;

	switch (ent_team) {
		case 3:

			PrecacheModel("models/eltra/rp_judith.mdl")
			modelpath = "models/eltra/rp_judith.mdl"

			break;
		case 2:

			PrecacheModel("models/kleiner.mdl")
			modelpath = "models/kleiner.mdl"
			break;
		default:
			break;
	}


	local prop = SpawnEntityFromTable("prop_dynamic_ornament", {
		targetname = "bitchmodel",
		model = modelpath,
		solid = 0,
		origin = ent_pos,
		angles = ent_angles,
		// spawnflags = 256,
	})
	prop.AcceptInput("SetAttached","!activator",entity,entity)
	return prop
}

function MakeMoneyTextEnt(entity) {
	local ent = SpawnEntityFromTable("game_text", {
		color = "255 223 43",
		fadein = 0,
		fadeout = 0.5,
		holdtime = 1,
		x = 0.02,
		y = 0.25,
	})
	return ent
}

function GiveMoney(money = 1) {

	Money += money

}

function TakeMoney(money = 1) {

	Money -= money

}