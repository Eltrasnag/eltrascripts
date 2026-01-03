//REGULAR RANDOM EVENTS
gas <- Entities.FindByName(null, "gas_maker")
::ShouldEvent <- false
EventSlot <- 0; // 0 = no event, 1 = human event, 2 = zombie event
EventScenarioQueued <- false;
cellar_has_door <- true;
//BACHELORETTE EVENTS
function GetPos() // i truly dgaf to format each one of these manually from the tf2 getpos command
{
    local a = activator.GetOrigin().tostring()
    local b = a.slice(10,a.len())
    printl("Vector"+b)
}

gs <- [Vector(287.899597, -909.360107, 35.136597),Vector(715.180786, -1479.028442, 0.031250),Vector(-798.401733, -260.100098, 34.982269),Vector(-3.296390, 938.994873, 32.031250),Vector(1181.635498, 27.067766, 112.736572),Vector(-1005.841187, 917.998474, 0.031250),Vector(-1017.413574, -433.614777, 0.031250),Vector(405.976440, -2176.673096, 89.016205),Vector(485.742401, -1293.589111, 60.031250),Vector(-1118.247192, -1400.216309, 0.031250)]

function GeneratorDamage()
{
	MapSay("***THE GENERATOR HAS BEEN SABOTAGED - FIND 5 GAS CANS TO REFUEL IT***")
    // QFireByHandle(tip, "AddOutput", "display_text ***THE GENERATOR HAS BEEN SABOTAGED - FIND 5 GAS CANS TO REFUEL IT***", 0.00, null, null);
    // QFireByHandle(tip, "Show", "", 0.1, null, null);
    // tip.SetOrigin(Vector(-1024, -448, 224))
    // QFire("gen_room_door", "Disable", "", 0.00, null); ?
    QFire("gen_light", "TurnOn", "", 0.00, null);


    // QFire("animatronic_move_timer_bachelorette", "Disable", "", 0.00, null);
	BacheloretteEnabled = false
    QFire("fade_quickblack", "Fade", "", 0.00, null);
    // QFire("tp_h_posreset", "FireUser1", "", 0.00, null);
    gas.SpawnEntityAtLocation(gs[RandomInt(0, 1)], Vector(0, RandomInt(0, 360), 0))
    gas.SpawnEntityAtLocation(gs[RandomInt(2, 3)], Vector(0, RandomInt(0, 360), 0))
    gas.SpawnEntityAtLocation(gs[RandomInt(4, 5)], Vector(0, RandomInt(0, 360), 0))
    gas.SpawnEntityAtLocation(gs[RandomInt(6, 7)], Vector(0, RandomInt(0, 360), 0))
    gas.SpawnEntityAtLocation(gs[RandomInt(8, 9)], Vector(0, RandomInt(0, 360), 0))
    QFire("event_generator_relay", "Trigger", "", 0.00, null);
}

function VentDamage()
{
    // tip.SetOrigin(Vector(-1184, 900, 0.5))
	MapSay("***THE VENTILATION IS MALFUNCTIONING - FIX IT QUICKLY***")

    // QFireByHandle(tip, "AddOutput", "display_text ***THE VENTILATION IS MALFUNCTIONING - FIX IT QUICKLY***", 0.00, null, null);
    // QFireByHandle(tip, "Show", "", 0.1, null, null);

    QFire("fade_quickblack", "Fade", "", 0.00, null);
    // QFire("tp_h_posreset", "FireUser1", "", 0.00, null);
	BacheloretteEnabled = false
    // QFire("animatronic_move_timer_bachelorette", "Disable", "", 0.00, null);

    QFire("event_vent_relay", "Trigger", "", 0.00, null);

}

function Megan()
{
    QFire("fade_quickblack", "Fade", "", 0.00, null);
    QFire("tp_h_posreset", "FireUser1", "", 0.00, null);
    // QFire("animatronic_move_timer_bachelorette", "Disable", "", 0.00, null); meg handles this already
    // tip.SetOrigin(Vector(-6,-1214,86))

    QFire("event_meg", "Trigger", "", 0.00, null);

}

function Zombie_Defense_Maker() {

	if (ShouldEvent)
	{
			QFire("sf_security_alert", "PlaySound", "", 0.00, null)
			QFire("sf_sec_global", "PlaySound", "", 0.00, null)
			local picker = RandomInt(0, 2)

			switch (picker) {
				case 0:
					QFire("tp_outside_inside", "Disable", "", 0.00, null);
					// QFire("tp_h_posreset", "FireUser1", "", 0.00, null); added to the timer so this happens by default
					local deftime = RandomFloat(20, 30)
					QFire("sf_sec_front", "PlaySound", "", 4.00, null);
					QFire("ztp_origin", "Disable", "", 10.00, null);
					QFire("ztp_outside", "Enable", "", 10.00, null)
					QFire("office_manager", "RunScriptCode", "ze_map_say(` ***{fullred}SECURITY ALERT - FRONT PARKING LOT{default}***`)", 0.00, null);
					QFire("office_manager", "RunScriptCode", "ze_map_say(` ***{fullred}SECURITY - SITUATION RESOLVING IN "+deftime.tointeger()+" SECONDS{default}***`)", 10.00, null);
					QFire("ztp_outside", "Disable", "", deftime+9.00, null);
					QFire("ztp_origin", "Enable", "", deftime+10.00, null);
					QFire("office_manager", "RunScriptCode", "ze_map_say(` ***{fullred}SECURITY - SITUATION HAS BEEN RESOLVED{default}***", deftime+10.00, null);
					QFire("front_door_closed", "Disable", "", 0.00, null);
					QFire("front_door_opened", "Enable", "", 0.00, null);
					QFire("front_door_closed", "Enable", "", deftime+20.00, null);
					QFire("front_door_opened", "Disable", "", deftime+20.00, null);
					QFire("event_timer", "Enable", "", deftime+10.00, null);
					// QFire("tp_anticheat", "FireUser1", "", deftime+20.00, null);
					QFire("tp_outside_inside", "Enable", "", deftime+20.00, null);
					break;
				case 1:
					local deftime = RandomFloat(20, 30)

					QFire("tp_outside_inside", "Disable", "", 0.00, null);
					QFire("sf_sec_parts", "PlaySound", "", 4.00, null);
					QFire("laundry_door", "Disable", "", 0.00, null);
					QFire("ztp_origin", "Disable", "", 10.00, null);
					QFire("laundry_z_barrier", "FireUser1", "", 10.00, null);
					QFire("tem_laundry_barrier", "ForceSpawn", "", deftime+10, null);
					// QFire("tp_h_posreset", "FireUser1", "", 0.00, null);
					QFire("ztp_laund", "Enable", "", 10.00, null)
					QFire("office_manager", "RunScriptCode", "ze_map_say(` ***{fullred}SECURITY ALERT - PARTS AND SERVICE{default}***`)", 0.00, null);
					QFire("office_manager", "RunScriptCode", "ze_map_say(` ***{fullred}SECURITY - SITUATION RESOLVING IN "+deftime.tointeger()+" SECONDS{default}***`)", 10.00, null);
					QFire("ztp_laund", "Disable", "", deftime+9.00, null);
					QFire("ztp_origin", "Enable", "", deftime+10.00, null);
					QFire("office_manager", "RunScriptCode", "ze_map_say(` ***{fullred}SECURITY - SITUATION HAS BEEN RESOLVED{default}***`)", deftime+10.00, null);
					QFire("door_laundry", "Enable", "", deftime+20.00, null);
					QFire("tp_outside_inside", "Enable", "", deftime+20.00, null);
					QFire("event_timer", "Enable", "", deftime+20.00, null);
					break;
				case 2:
					QFire("tp_outside_inside", "Disable", "", 0.00, null);
					QFire("sf_sec_back", "PlaySound", "", 4.00, null);
					QFire("door_back", "Disable", "", 0.00, null);
					QFire("ztp_origin", "Disable", "", 10.00, null);
					// QFire("tp_h_posreset", "FireUser1", "", 0.00, null);
					local deftime = RandomFloat(20, 30)
					QFire("ztp_back", "Enable", "", 10.00, null)
					QFire("office_manager", "RunScriptCode", "ze_map_say(` ***{fullred}SECURITY ALERT - BACK ALLEY ENTRANCE{default}`)***", 0.00, null);
					QFire("office_manager", "RunScriptCode", "ze_map_say(` ***{fullred}SECURITY - SITUATION RESOLVING IN "+deftime.tointeger()+" SECONDS{default}***`)", 10.00, null);
					QFire("ztp_back", "Disable", "", deftime+9.00, null);
					QFire("ztp_origin", "Enable", "", deftime+10.00, null);
					QFire("office_manager", "RunScriptCode", "ze_map_say(` ***{fullred}SECURITY - SITUATION HAS BEEN RESOLVED{default}***`)", deftime+10.00, null);
					QFire("door_back", "Enable", "", deftime+20.00, null);
					QFire("event_timer", "Enable", "", deftime+20.00, null);
					QFire("tp_outside_inside", "Enable", "", deftime+20.00, null);

					break;
				default:
					break;
		}


	}
}

function ShowTornado(T){
	QFireByHandle(T, "Enable", "", 0.00, null, null);
	QFireByHandle(T, "AddOutput", "rendermode 2", 0.00, null ,null  )
	QFireByHandle(T, "Alpha", "0", 0.00, null,  null)
	local alph = 0
	while (alph < 255) {
		QFireByHandle(T, "Alpha", alph.tostring(), 0.0, null, null)
		alph += 0.5
	}
	QFireByHandle(T, "AddOutput", "rendermode 0", 4.25, null ,  null)
}

function HideTornado(){
	local T = Entities.FindByName(null, "Tornado_Funnel")
	QFireByHandle(T, "AddOutput", "rendermode 2", 0.00, null ,null  )
	QFireByHandle(T, "Alpha", "255", 0.00,null  , null )
	local alph = 255
	while (alph > 0) {
		QFireByHandle(T, "Alpha", alph.tostring(), 0.0, null, null)
		alph -= 0.5
	}
	QFireByHandle(T, "AddOutput", "rendermode 0", 4.25, null , null )
	QFireByHandle(T, "SetAnimation", "ref", 4.25, null, null);
	QFireByHandle(T, "Disable", "", 4.25, null, null);
}

function Tornado_Cellar_Pull(activator) {
	local d = Entities.FindByName(null, "tornado_pull_target");
	local pcfpos = Entities.FindByName(null, "tornado_debris_pcf").GetOrigin();
	local dpos =  d.GetOrigin()
	local ppos = activator.GetOrigin()
	local fvec = Vector(dpos.x - ppos.x, 0.0, dpos.z - ppos.z)
	fvec.Norm()
	activator.SetAbsVelocity((activator.GetAbsVelocity()) + (fvec * 200 * (1 / (pcfpos.x - dpos.x))));
}

function PauseMap() {
	QFire("music_box_timer", "Stop", "", 0.00, null);
	QFire("power_timer_global", "Stop", "", 0.00, null);
	QFire("round_timer", "Pause", "", 0.00, null);
	printl("Pausing map")

}

function UnPauseMap() {
	Music = 100;

	QFire("music_box_timer", "Start", "", 10.00, null);
	QFire("power_timer_global", "Start", "", 10.00, null);
	QFire("round_timer", "Resume", "", 10.00, null);
	printl("Unpausing map")

}

function Nightwatch_Event_Maker(cheat = false, pick = 0) {

	if (ShouldEvent) {
		EventScenarioQueued = false

		local picker = RandomInt(1, 4)
		if (cheat == true) {
			picker = pick
		}

		switch (picker) {

			// case 0: // twister // disabling this event because i dont have enough time atm
			// 	printl("twister event here")
			// 	MAJOR_EVENT = true;
			// 	local door_fly = false

			// 	local Funnel = Entities.FindByName(null, "Tornado_Funnel")
			// 	MapSay("TORNADO EVENT TORNADO EVENT DEV DEV DEBUG DELETE THIS")
			// 	ShowTornado(Funnel)
			// 	QFireByHandle(Funnel, "SetAnimation", "idle", 0.00, null, null);

			// 	if (cellar_has_door) {
			// 		local r = RandomInt(0, 1)
			// 		if (r == 2){
			// 			door_fly = true
			// 			cellar_has_door = false
			// 		}
			// 	}

			// 	// 26.9 is when the tornado is too close to cellar
			// 	QFire("tornado_cellar_door", "Close", "", 20.0)

			// 	QFire("tornado_death_triggers", "Enable", "", 26.9)

			// 	if (door_fly) { // logic for cellar door flying off
			// 		QFire("tornado_cellar_door", "Open", "", 28.0)
			// 		QFire("tornado_cellar_door_mover", "Open", "", 28.0)
			// 		QFire("tornado_door_suck_trigger", "Enable", "", 28.0, null)
			// 		QFire("tornado_door_suck_trigger", "Disable", "", 34.0, null)
			// 	}

			// 	QFire("tornado_death_triggers", "Disable", "", 34.0, null);
			// 	QFire("tornado_cellar_door", "Open", "", 34.0, null);

			// 	QFire("tornado_cellar_door", "Enable", "", 120.0, null) // re enable cellar door after enough time has passed

			// 	QFireByHandle(self, "RunScriptCode", "HideTornado()", 40.5, null, null);
			// 	QFireByHandle(self, "RunScriptCode", "MAJOR_EVENT = false", 40.5, null, null);
			// 	// QFire("round_timer", "Pause", "", 0.00, null); // pause round timer
			// 	break;
			case 1: // flood
				printl("flood would happen here")
				break;
			case 2: // meg
				Megan();
				break;
			case 3:
				VentDamage();
				break;
			case 4:
				GeneratorDamage();
			default:
				break;

		}
	}
}

function Eventer(Event_Type)
{
	if (Nights != 6)
	{ // if we arent night 6

		if (Eventer == "Scenario")
		{ // check if the human event timer called us
			if (EventSlot == 2 && !ShouldEvent)
			{ // if there is a zombie event going on and we cannot event then queue the human event
				EventScenarioQueued = true
			}
			if (EventSlot == 0)
			{ // if the event slot is free then do the human event

				Nightwatch_Event_Maker() // call the event function, will not do anything if shouldevent is false
			}
		}

		if (Eventer == "Zombie") // NO LONGER NEEDED AS NEW "FIRE" GAMEPLAY SOLUTION IS ADDED
		{ // check if zombie defense timer called us

			// if (EventSlot == 0) { // if the event slot is free then do a zombie defense
			// 	Zombie_Defense_Maker()
			// }
		}

		ShouldEvent = false
	}

}

function CheckQueuedEvent() {
	if (EventScenarioQueued = true) {
		printl("event would be queued here but we arent doing anything until the function is set up BUSTER")
	}
}