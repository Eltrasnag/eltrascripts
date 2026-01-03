enum DOORSTATES { OPEN, CLOSED }

::RightDoorState <- DOORSTATES.CLOSED
::LeftDoorState <- DOORSTATES.CLOSED
::LastLeftState <- null
::LastRightState <- null
::LeftDoor <- Entities.FindByName(null, "o_leftdoor")
::RightDoor <- Entities.FindByName(null, "o_rightdoor")

::LeftClosed <- false; // the left door is closed
::RightClosed <- false; // the right door is closed
::LeftOccupied <- false; // animatronic is at the left door
::RightOccupied <- false; // animatronic is at the right door
::ItsOver <- false; //state when animatronic has successful movement opportunity into office
::PowerDown <- false; // state of power outage
::Power <- 100;
::Music <- 100;
::Hour <- 0;
::gNightLength <- 300
::HourColor <- 255;
::Aggressiveness <- 0;
::MAJOR_EVENT <- false
::THE_SPELL_COOLDOWN <- 0.5;
::lastleftoccupied <- false;
::lastrightoccupied <- false;
::ZThrowCD <- 0.1
::ButtonPressed <- function(hPlayer, iButton) {
	if (NetProps.GetPropInt(hPlayer, "m_nButtons") & iButton) {
		return true
	}
	return false
}


::PressedLeft <- 0
::PressedRight <- 0
PressedMax <- 2
enum CHARACTERS {
	PETER, LOIS, KYLIE, MEG, PISSBEAR, GFREDDY, GRANDMA, BACHELORETTE, MARIA, MARILLA
}
UglyBitchSluttyWhore <- true;
enum TEAMS {
	HUMANS = 3,
	ZOMBIES = 2,
	SPECTATORS = 1,
	UNASSIGNED = 0,
}

const IN_USE = 32
const IN_ATTACK = 1
const IN_ATTACK2 = 2048

DoAlert <- false;

// override these values using runscriptcode if needed
// these are refire times of timers
::gPowerTime_Global <- 9 // ambient power consumption
::gPowerTime_Door <- 6 // door power consumption
::gPowerTime_Light <- 8 // light power consumption

PrecacheScriptSound("Concrete.StepRight")
PrecacheScriptSound("Concrete.StepLeft")
PrecacheScriptSound("Tile.StepRight")
PrecacheScriptSound("Tile.StepLeft")
PrecacheScriptSound("Default.StepRight")
PrecacheScriptSound("Default.StepLeft")
PrecacheScriptSound("music.night_1")
PrecacheScriptSound("music.night_5")
PrecacheScriptSound("music.cities_dust")
PrecacheScriptSound("music.burger_title")

RegisterScriptHookListener("OnTakeDamage")

//I FUCKING HATE VSCRIPT I HATE IT SO MUCH 3 VERSIONS AND YOU WILL STILL NOT WORK I HATE YOU I HATE YOU WHY DOES PLAYER INITIAL SPAWN NOT HOOK BUT PLAYER ACTIVATE DOES? I DONT KNOW FUCK YOU
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⡀⠄⢀⠄⠄⡀⠄⡀⢀⠄⡀⢀⠄⡀⢀⠄⡀⢀⠄⢀⠄⢀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠐⠈⠄⢈⠄⠈⠄⠁⠈⡀⠁⠈⠄⠁⢀⠠⠄⠄⠂⠄⠄⠠⠄⠠⡠⢠⠠⠠⡀⠄⡠⠠⡐⠄⠠⠄⡀⠈⡀⠈⠄⠐⠄⠐⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠈⠄⠐⠈⠄⢀⠈⠄⢁⠠⠄⢀⠁⠄⠁⡀⠠⠄⠄⠂⠐⠄⡄⣌⢢⢳⢨⢌⢖⡈⡌⠌⠄⠄⠄⠄⠂⠄⠄⠄⠄⠁⠄⠂⠄⠐⠄⠄⡀⠈⠄⠄⠁⠄⠄⠂⠄⠐⠄⠄⠄
// ⠄⠈⠄⡁⠠⠈⢀⠄⢁⠄⠄⠐⠄⠠⠄⠂⠄⠄⠐⠄⢂⠐⠩⡘⠔⠕⡑⣑⠡⡢⡫⠪⠔⠕⢊⠄⡀⠠⠐⠄⠂⠄⠂⠁⠄⠁⢀⠐⠄⠄⠄⡀⠂⠄⠄⠄⠄⠄⢀⠄⠄⠄
// ⠄⠈⡀⠠⠄⠂⡀⠄⠠⠄⠐⠄⢁⠄⠂⠁⠐⠄⠂⢅⠢⠨⠐⠠⠨⡀⡊⣊⡳⡕⡖⡵⡨⢴⠱⡱⡢⠄⠄⠂⢈⠄⠐⠄⠁⠠⠄⢀⠠⠄⠁⠄⠄⢀⠄⠄⡀⠈⠄⠄⠄⠄
// ⠄⠐⢀⠄⠂⠠⠄⠐⠄⠂⠁⡈⢀⠐⠈⡀⢁⠨⡐⠐⡈⠄⠂⢅⠁⡂⠪⠚⢜⠔⡕⣕⢝⠆⢅⡑⣜⠌⠄⢁⠄⠄⠁⡀⠁⡀⠄⠄⢀⠄⠠⠄⠂⠄⠄⠄⠄⠄⢀⠄⠄⠂
// ⠄⢈⠄⠄⠁⠐⠈⡀⠁⠄⢁⠠⠄⠐⠄⠄⠄⡂⡨⠢⡀⠂⡁⡔⢅⢢⢢⣜⡼⣮⣣⣥⡵⡺⣗⣯⡷⠧⠄⠂⠠⠐⠄⠠⠄⡀⠠⠐⠄⠄⡀⠠⠄⢀⠈⠄⠈⠄⠄⠄⠄⠄
// ⠄⠄⠐⠄⡁⢈⠄⠄⠂⠐⠄⠄⢈⠄⡁⡀⢅⢂⠜⡐⢄⢥⢊⢮⢲⢢⣻⢾⣯⡷⣅⢠⢄⢧⣳⡟⢈⠈⠠⠈⢀⠐⠈⠄⠄⠄⠄⢀⠐⠄⢀⠄⠄⠄⠄⠄⠂⠄⠂⠄⠠⠄
// ⠄⠐⠈⡀⠄⠠⠄⠂⡈⢀⠁⠐⡀⠠⠄⠐⢐⠐⠅⡪⡱⡹⡵⣫⢪⢣⢫⣟⡾⣟⣿⣽⡾⣿⣻⣽⣖⠐⡠⠁⠠⠄⡈⠠⠐⠄⠂⢀⠄⠂⠄⡀⠄⠄⠁⠄⢀⠠⠄⠠⠄⠄
// ⠄⢁⠐⢀⠐⠄⠌⠄⠄⡀⠂⡁⠠⠄⠂⠁⢂⠡⡡⡑⡕⣝⣕⢇⢇⠣⣳⢵⣫⢗⣯⢾⣻⣝⢗⠯⡳⢀⠐⠄⠂⠠⠄⠄⠂⢀⠁⢀⠄⠂⠁⠄⡀⠄⠁⠠⠄⠄⢀⠄⠠⠄
// ⠄⠄⠂⡀⠂⡁⠄⠡⢀⠐⠠⠄⡂⢅⠅⡌⢄⢂⢂⠮⡞⣗⢧⡓⢧⠣⣓⢟⡮⣟⡾⡽⠯⠿⠝⢎⠂⠄⡀⢁⠈⡀⠐⠄⠂⡀⠐⠄⡀⠂⠈⠄⢀⠄⠄⠠⠐⠈⠄⠄⡀⠄
// ⠄⠂⡁⠄⠂⠄⢂⠁⡀⢈⠨⠨⠐⠄⠅⢃⢁⠢⢂⠣⢣⢥⣓⠎⡁⡣⠈⢇⢻⢪⢏⡯⣏⡃⢒⠄⢀⠱⠄⠢⠄⠄⡂⠁⠠⠄⠂⠁⡀⠄⠁⠐⠄⡀⠄⠠⠄⠠⠐⠄⠄⡀
// ⠄⡁⠄⠂⡁⢐⠄⡂⠄⠄⢀⠂⠠⠁⢈⠠⠄⠁⣇⠨⣒⢕⠗⢑⡸⣕⢕⢄⢂⠡⠉⠏⢯⠻⠅⡐⡀⠔⠡⠂⡁⢂⠂⡈⠠⠐⠈⢀⠠⠄⠂⠁⡀⠄⠄⠄⠐⠄⠠⠐⠄⠄
// ⠄⠄⠂⠄⢂⢐⢐⠠⠅⡐⠐⡀⠌⠰⡐⡸⡜⠄⡈⠪⡸⡪⡎⣔⢺⣜⢕⢅⠂⠐⠄⠄⡀⠄⠂⡀⠂⡁⠨⠄⠄⠂⠠⠄⡂⠐⠈⢀⠠⠐⠄⠁⡀⠠⠐⠄⠄⠂⠄⠄⠂⠄
// ⠄⢌⠄⡁⠄⠄⠄⠐⢀⠄⡂⢂⠣⠁⠜⠸⠸⠸⡈⡀⠂⡍⢝⢎⢏⡪⣫⣯⢿⣲⣶⣦⣄⡠⠄⢀⠂⠠⢈⠈⠨⠄⠅⡐⢀⠈⠠⠄⠄⠐⠈⢀⠄⠄⠄⠂⠁⡀⠁⡀⠐⠄
// ⠈⠠⠠⠐⢀⠁⡐⢈⠄⠄⠠⠄⠂⢨⠄⠨⣘⠈⣐⠼⢵⣳⢕⢽⢵⢽⣻⡾⣟⣿⢷⣷⢿⣽⣢⠐⢈⠐⠄⠄⢁⠈⠄⠠⠄⠂⠐⠄⠂⡀⢁⠄⠄⠐⠈⠄⠄⠠⠄⠠⠐⠄
// ⠄⠡⠄⠁⠂⠁⡀⠄⢐⠐⠄⠂⠌⠜⢪⡲⠌⡆⠠⠈⠨⠠⡣⣳⣻⣻⣯⣿⣻⣽⣿⣻⣟⣷⣻⡂⠢⠨⠐⡁⠄⢀⠂⠐⢈⠄⡁⢈⠄⠄⠠⠄⠐⢀⠈⠠⠐⠄⠐⠄⠄⠄
// ⠈⠠⠈⠠⠈⡀⠄⠐⡐⢈⠠⡁⢞⠐⠄⢁⠨⡐⡡⡠⡣⡩⣺⡺⢽⡽⣾⣳⡿⣽⣾⢿⣽⣟⣾⡃⠄⠁⠄⠂⠐⠄⠄⢁⠠⠄⠄⠠⠄⠂⠐⠈⠠⠄⠐⠄⠂⢈⠄⠂⠄⠂
// ⠄⠡⢈⠄⡁⠄⠂⠁⡀⢀⠐⡀⠐⡀⠱⡒⢐⢸⡰⢠⠱⡸⣕⡯⣳⢽⡯⣷⣟⡿⣾⢿⡷⣿⣞⣗⠄⡁⠄⠡⠈⡀⠂⡀⠄⠂⠄⠂⡀⢁⠈⡀⠂⠁⡈⠄⡁⠠⠐⠈⡀⠂
// ⠈⠄⢂⠐⡀⠂⠈⡀⠄⠨⢂⢐⢀⢂⠕⡀⠨⡢⢩⢣⢫⡪⡷⡽⣝⣗⣯⢷⢯⢿⡽⣟⣿⣽⣾⣳⡈⠠⠈⡀⠂⠄⠄⠄⠄⠂⠡⠐⡀⠄⠠⠄⠂⠁⡀⠄⠠⠄⠂⠁⡀⠄
// ⠠⠈⠄⢐⠄⠅⠂⢀⠄⡁⠐⢀⠐⠁⠈⠄⢂⢇⠅⡪⡪⣞⣯⢯⣗⡷⡯⡫⡫⡯⣟⣯⣿⢷⣟⡷⡅⠂⢁⠄⠄⡁⠄⠡⢈⠈⠄⠡⠐⡈⠄⡈⢀⠁⠠⠄⠂⠐⠈⡀⢀⠄
// ⠄⠅⡈⠄⠂⡈⠠⠄⠂⠄⠄⠐⠄⠐⠄⡁⢐⢅⠕⢮⢪⢷⢽⡽⡾⣽⣻⡢⠨⣫⢯⣿⡾⣿⢿⣽⣳⠈⠠⠐⡀⢐⠈⠄⠂⠄⠅⠌⡐⠄⡂⢐⠠⢈⠐⡈⠄⡁⠂⠄⠠⠄
// ⠄⠂⠠⠐⠄⠄⠐⠄⠄⠁⠄⡁⠄⢁⠡⠄⠐⠌⡎⡎⣕⢽⢵⣻⢯⡷⡯⡯⡂⠪⡻⡺⢿⢻⠿⡻⡚⠌⠄⠡⠠⡂⢔⢈⢄⠁⡂⠡⠈⠌⠢⡑⡐⢄⠂⡐⢀⠂⠡⠈⠄⠂
// ⠄⡈⠄⠂⢁⠐⠈⡀⠈⠄⠄⠄⠄⠄⢀⠈⡀⠅⡊⢎⢮⡺⡽⣞⣯⢿⠽⠝⠠⢁⠐⡈⠢⠑⢌⠢⡊⠌⠠⠁⡁⢂⢑⠐⠄⠕⠨⡂⢅⠨⠄⡂⠌⠂⠅⡂⠂⠌⡐⢀⠂⠠
// ⠄⠄⠂⡈⢀⠐⠄⠄⠄⢀⠠⠐⠄⠄⠄⠠⠄⠠⠈⠜⢴⡹⣝⢗⠫⠡⠡⠁⠅⡐⢈⠠⢁⠑⠄⡁⡂⠕⢌⠄⠄⠄⠠⠑⠨⡈⠄⠂⡂⠅⡑⠄⡊⠌⡐⠄⠅⠡⠐⡀⢈⠄
// ⠄⠂⡁⠄⠠⠄⡁⠄⠁⠄⠄⠄⠄⠄⠠⠄⠈⡀⠈⠈⡂⠑⡁⢂⠨⠄⠅⠨⠐⡀⠂⠌⡐⠈⠄⡐⠠⡑⠅⡕⢅⠕⡄⢅⢂⠐⡈⡐⡀⢂⠂⠅⡂⠅⡂⠅⡈⠄⢁⠠⠄⠄
// ⠄⡁⠄⠐⠄⡁⠠⠐⠈⡀⠄⠄⠄⢀⠄⠂⠠⠄⠂⢁⠄⢂⠄⠂⠐⠠⠈⠠⠁⠄⡁⢂⠠⠁⠂⠄⠅⡂⡑⢌⠢⠣⡪⠢⢅⢕⠠⢐⢈⢂⠢⠡⠠⢑⠐⢅⠂⠌⠠⠄⠂⡀
// ⠄⠠⠐⠈⡀⠄⠂⡈⠄⠄⠂⠁⡈⠄⠠⠈⠄⠂⢁⠠⠐⠄⠄⢁⠈⠄⠈⠄⢂⠡⠄⠄⠐⠈⡈⠄⡑⡐⠄⠅⠅⡑⠨⢊⠪⡂⡇⢕⠰⡐⠌⠄⠅⢑⢈⠢⠨⠨⠄⠅⠠⠄
// ⠄⠂⡀⢁⠠⠐⠄⠄⠂⡀⠁⠄⠄⠂⠐⠄⢁⠈⡀⠄⠂⠁⠄⠠⠐⢀⠁⠌⠠⠐⡈⠄⡁⠐⡀⠂⡐⠨⠈⡂⢂⠠⠁⠡⢑⠱⡘⢜⢌⠪⠨⠄⠅⠂⡐⢈⠈⠄⡁⠐⢀⠄
// ⠄⠂⠠⠄⠄⠂⢁⠄⠂⡀⠂⡀⠁⠄⠁⡈⠄⠄⢀⠐⢈⠄⢂⠐⢈⠠⠐⡈⠠⢁⠐⠠⠐⠄⠂⠁⠄⠨⢐⢀⠂⠔⡈⠄⠂⠌⠌⡐⢐⠨⡀⠅⠠⠁⠄⠂⠄⠁⠄⠈⠄⠄
// ⠄⡈⠠⠐⠄⠂⠄⠄⢁⠠⠄⠄⠂⢀⠁⠄⠈⠄⡀⠂⠄⠨⠄⡂⢐⠄⡂⠐⡈⠄⠨⠄⠂⡁⢈⠄⡁⢈⠠⠐⠈⡐⠠⢈⠄⢂⠐⠄⠂⠐⢀⠁⢂⠡⠈⠄⢈⠄⠂⠁
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠰⠶⢶⠶⠶⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⣿⠄⠄⠄⠄⠄⠄⣠⣴⢶⣤⠄⣶⣠⣶⣤⣴⣦⠄⠄⠄⠄⢠⡴⠶⣿⠄⢠⣴⢦⡄⠄⣤⣠⢴⡄⢠⣤⡤⣦⢰⡄⠄⠄⣴⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⣿⠄⠄⠄⠄⠄⢰⡏⠄⠐⡇⠄⣿⠋⢸⡏⠄⢹⡄⠄⠄⠄⠘⠳⠶⣄⠄⣿⠄⠄⣿⠄⣿⠁⠈⠃⢸⡏⠄⠙⠄⢻⣆⣸⠏⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠠⠶⠿⠶⠶⠄⠄⠄⠈⠻⠶⠶⠿⠄⠿⠄⠄⡷⠄⠸⠇⠄⠄⠄⠻⠶⠶⠟⠄⠹⠶⠾⠋⠄⠿⠄⠄⠄⠸⠇⠄⠄⠄⠄⣻⠏⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢰⡟⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⢀⡀⠄⠄⠄⠄⠄⠄⠄⢀⡀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⡀⠄⢀⡀⠄⠄⠄⠄⠄
// ⠄⠸⠇⠄⠄⡟⠛⠛⠛⠃⢸⡇⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢸⡟⠛⠳⣆⠄⠘⠃⠄⠄⠄⠄⠄⠄⠄⠄⢰⡇⠄⠸⠇⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⢀⣧⡴⠶⠶⠄⢸⡇⢀⣴⠞⢻⡆⠄⣿⠞⠻⣦⠄⣿⠶⠛⣶⠐⢷⡀⠄⣰⠇⠄⠄⠄⢸⣇⣀⣴⠏⠄⢸⠆⢸⡷⠚⣿⠄⣰⠾⠛⢾⡇⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⢸⡇⠄⠄⠄⠄⢸⡇⢸⣇⠄⢸⣇⠄⣿⠄⠄⣿⠄⣿⠄⠄⣸⠇⠈⢷⣰⠏⠄⠄⠄⠄⢸⡏⠉⠙⣷⠄⣿⠄⢸⡇⠄⠄⠄⣿⡀⠄⣸⡇⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠸⠇⠄⠄⠄⠄⠸⠃⠄⠙⠛⠋⠛⠄⣿⠷⠞⠋⠄⣿⠿⠾⠋⠄⠄⣸⡏⠄⠄⠄⠄⠄⠸⠷⠟⠛⠉⠄⠘⠄⠘⠃⠄⠄⠄⠈⠛⠛⠛⠃⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣿⠄⠄⠄⠄⢿⠄⠄⠄⠄⠠⠿⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢀⣀⣀⡀⠄⠄⢀⣀⣀⡀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⣀⠄⠄⡀⠄⢀⣀⣠⡄⠄⠄⣀⡀⠄⠄⡀⢀⣀⠄⠄⣀⣠⣤⠄⠄⠄⠄⠄⠄⠐⠟⠉⠉⣿⠄⠐⠟⠉⠉⣿⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⣿⠄⠄⡿⠄⣿⣍⣘⠃⢰⢟⣉⡽⠇⠄⡿⠋⠹⠇⢾⣯⣁⠛⠄⠄⠄⠄⠄⠄⠄⣀⣴⠞⠃⠄⠄⣀⣴⠞⠃⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⣿⣀⣠⣷⢠⣄⣀⣽⠆⠸⣯⣁⣠⡴⠄⡇⠄⠄⠄⣤⣀⣩⡷⠄⠄⡀⠄⠄⠄⢰⣟⣠⣤⣄⠄⢰⣟⣠⣤⣄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠈⠉⠁⠁⠄⠉⠉⠁⠄⠄⠈⠉⠉⠄⠄⠁⠄⠄⠄⠈⠉⠉⠄⠄⢰⠇⠄⠄⠄⠄⠉⠉⠁⠉⠄⠄⠉⠉⠁⠉⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⣷⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢠⡾⠛⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⣿⣀⣤⣄⠄⠄⣠⣤⣄⠄⢠⡄⠄⢠⡀⢠⣀⣤⣄⠄⣠⣤⢶⡆⠄⠄⠄⣠⣼⣧⣤⠄⢠⣀⣤⣄⠄⣀⣤⣄⡀⢀⡄⣠⣤⣀⣤⣄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⣿⠋⠄⣿⠄⣼⠋⠄⢻⠄⢺⡁⠄⣿⠄⢸⠋⠄⠛⠘⠿⠦⣬⠁⠄⠄⠄⠄⢸⡇⠄⠄⢸⠋⠄⠛⢰⡏⠄⢸⡇⢘⡿⠋⢸⡏⠄⣿⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⣿⠄⠄⢿⠄⠹⢧⣴⠟⠄⠸⣧⣤⢿⠄⢸⠄⠄⠄⠰⣦⣤⡾⠃⠄⠄⠄⠄⢸⡇⠄⠄⢸⠄⠄⠄⠘⠷⣤⡾⠃⠸⡇⠄⢸⡇⠄⢻⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠈⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢀⠄⠄⡀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠘⠛⢿⠟⠷⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠐⠖⠄⣿⠄⢸⣿⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⣶⣴⢶⡆⠄⣴⠶⢶⡄⢰⡆⠄⣶⡀⢰⡆⠄⠄⠄⠄⠄⠄⠄⣿⠄⠄⠄⠄⠄⠠⣦⠄⣴⡄⢠⡆⢰⡆⠄⣿⠄⢸⡇⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⣿⠁⠄⣇⢸⣏⠄⢈⡇⠈⣷⣸⠻⡇⣾⠄⠄⠄⠄⠄⠄⠄⠄⣿⠄⠄⠄⠄⠄⠄⣿⣸⠋⣇⣼⠁⢸⡇⠄⣿⠄⢸⡇⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠟⠄⠄⠿⠄⠛⠷⠟⠁⠄⠹⠃⠄⠻⠃⠄⠄⣴⠄⠄⠄⠐⠶⠿⠶⠶⠄⠄⠄⠄⠸⠏⠄⠻⠏⠄⠸⠇⠄⠿⠄⠸⠇⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠃⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢀⡀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢠⡄⠄⠄⣀⣀⣀⣀⠄⢠⡄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⣶⠄⠄⠄⠄⠄⠄⠄⢸⡇⠄⠄⡀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠘⠇⠄⠄⣿⠋⠉⠙⠃⢸⡇⠄⠄⠄⠄⠄⠄⡀⠄⠄⠄⠄⢀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠈⠛⣿⠛⠃⣰⠟⠛⣿⠄⢸⣇⣠⡾⠃⢀⡾⢛⣛⡧⠄⠄⠄⠄⠄⠄⠄⠄⣿⠶⠶⠶⠄⢸⡇⢀⣶⠛⢻⡗⠄⣿⠟⠛⣷⠄⣿⠞⠛⢷⡀⢷⡄⠄⣼⠇⠄⠄⠄⠄⠄⠄
// ⠄⠄⣿⠄⠄⣿⡀⢀⣿⡀⢸⡟⠙⢧⡀⠸⣟⡉⢁⣠⠄⠄⠄⠄⠄⠄⠄⢀⡿⠄⠄⠄⠄⢸⡇⠸⣇⡀⣘⣇⠄⣿⠄⢀⣿⠄⣿⡀⠄⣸⠇⠈⢿⣼⠏⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠙⠄⠄⠈⠙⠋⠉⠃⠘⠃⠄⠈⠓⠄⠉⠛⠋⠉⠄⠄⠄⠄⠄⠄⠄⠘⠇⠄⠄⠄⠄⠘⠃⠄⠉⠛⠉⠙⠄⣿⠛⠛⠁⠄⣿⠛⠛⠋⠄⠄⣸⠏⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠿⠄⠄⠄⠄⠿⠄⠄⠄⠄⠄⠟⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⢠⣤⣤⣀⠄⠄⣀⠄⠄⠄⠄⠄⠄⠄⠄⠄⢰⡆⠄⣶⠄⠄⠄⠄⠄⠄⠄⠄⢠⡆⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣠⣤⣤⣤⣄⠄⠄⠄⠄
// ⠄⢸⠇⠈⢹⡆⠄⣈⠄⢀⢀⣀⣀⠄⢀⣀⣀⣸⠇⠄⠙⠄⠄⠄⠄⠄⠄⣀⣀⣸⡇⠄⢀⣀⣀⠄⢀⡀⠄⣀⠄⢀⡀⣀⠄⣀⣀⠄⠄⠄⠄⠄⠄⠄⢀⡟⠄⠄⠄⠄⠄⠄
// ⠄⣿⠶⢶⣿⡀⠄⣿⠄⣿⠋⠁⠟⢠⡟⠉⠉⣿⠄⠄⠄⠄⠄⠄⠄⠄⡾⠉⠉⢹⡇⢰⡟⠉⠹⡇⢸⡇⢰⢿⡄⣼⠁⣽⡟⠉⣿⠄⠄⠄⠄⠄⠄⠄⠸⡇⠄⠄⠄⠄⠄⠄
// ⠄⣿⣀⣠⣴⠟⠄⣿⠄⣿⠄⠄⠄⠘⢷⣤⣤⣿⡀⠄⠄⠄⠄⠄⠄⠄⢿⣤⣤⣼⡇⠘⣧⣤⣼⠃⠄⢿⡏⠘⣧⡏⠄⣿⠄⠄⢻⡄⢀⠄⠄⠄⠄⢠⣤⣧⣤⡄⠄⠄⠄⠄
// ⠄⠈⠉⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠈⠄⠄⠄⠄⠄⠄⠄⠈⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢀⡄⠄⠄⠄⠄⠄⠄⣠⠄⠄⠄⠄⠄⠄⠄⠄⣷⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⢀⣤⣤⡄⠄⣠⣤⣤⡄⠄⣤⣠⣤⡄⠄⣤⣠⣤⡄⠄⣠⣤⣤⡀⠰⣶⣷⣶⠄⠄⠄⠠⣶⣿⣶⡆⢀⣤⣤⣤⡄⠄⣿⠄⣠⡦⠄⣠⣤⣤⣄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⡟⠁⠄⠁⢸⡏⠄⢸⡇⠄⣿⠁⠈⡇⢀⣿⠁⠨⡇⢸⡏⠄⢘⡇⠄⠄⣿⠄⠄⠄⠄⠄⠄⣿⠄⠄⣾⠁⠄⢺⠁⢀⣿⠾⣏⠄⢠⣯⠴⠖⠋⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠻⠶⠶⠗⠘⠷⠶⠾⠷⠄⠿⠄⠄⠿⠈⠧⠄⠄⠷⠈⠳⠶⠾⠁⠄⠄⠿⠄⠄⠄⠄⠄⠄⠿⠄⠄⠙⠷⠶⠾⠇⠸⡇⠄⠙⣷⠄⠻⠶⠶⠞⠃⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⢀⡀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⣦⠄⠄⢸⡇⠄⠄⠄⠄⠛⠄⠄⠄⢀⡀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠘⠛⣿⠛⠃⢸⣷⠾⢷⡄⠄⣷⠄⣴⡟⠛⠿⠄⠄⠄⢀⣴⠞⢳⡆⢰⣧⡶⢻⡆⢺⡄⠄⢠⡷⢰⣧⡶⢷⡶⠿⣦⠄⣠⡾⠻⣦⠄⣾⡶⠚⣷⢀⡴⠟⢳⡆⠄⠄⠄⠄⠄
// ⠄⠄⣿⠄⠄⢸⡇⠄⢸⡇⠄⣿⠄⡈⠙⢻⡆⠄⠄⠄⢸⡇⠄⢸⡇⢸⡟⠄⢸⡇⠄⢻⣤⡿⠁⢸⡏⠄⢸⡇⠄⣿⠄⣿⡀⠄⣽⠄⣿⠄⠄⠄⢸⣗⠚⠉⣀⠄⠄⠄⠄⠄
// ⠄⠄⠛⠄⠄⠘⠃⠄⠈⠃⠄⠛⠄⠛⠛⠛⠁⠄⠄⠄⠈⠛⠛⠋⠛⠘⠃⠄⠄⠛⠄⢀⡿⠁⠄⠘⠃⠄⠸⠇⠄⠘⠃⠈⠛⠛⠁⠄⠛⠄⠄⠄⠄⠙⠛⠛⠋⠄⠶⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠾⠃⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄

::GetLength <- function(vector) {
	vector.Length()
	return vector
}


GetDistance <- function(to, from) {
	return sqrt( pow(to.x - from.x, 2) + pow(to.y - from.y,2) + pow(to.z - from.z,2) )
}
::retail <- false; //preview stuff to make experience easier for tests
::RoundStarted <- false
// b1 <- null;
// b2 <- null;
// b3 <- null;
// b4 <- null;

::GetBrushStates <- function() {
	for (local i; i = Entities.FindByClassname(i, "func_brush");) {
		// printl("\n\n\n\nFound func brush: " + i.tostring() + "\n\n\n\n")

		local brushdict = {
			enabled = NetProps.GetPropInt(i, "m_iDisabled"), # starts disabled ?
			solidity = NetProps.GetPropInt(i, "m_iSolidity"), # starts disabled ?
			position = i.GetOrigin(),
			angles = i.GetAbsAngles(),
			color = NetProps.GetPropVector(i, "m_clrRender")
		}
		printl("color " + brushdict["color"].tostring())

		BrushStates[i.GetModelName()] <- clone brushdict
		// printl("brush dict created: " + brushdict.tostring())
	}
}

::BluRoundWin <- function() {

	QFireByHandle(MapParameters, "FireWinCondition", "5")

	// local AllPlayers = GetAllPlayers()

	// foreach (player in AllPlayers) {
		// if (player.GetTeam() == TEAMS.ZOMBIES) {
			// player.TakeDamage(99999, 0, null)
//
		// }
	// }

}

::QFire <- function(target, action = "", value = "", delay = 0.0, activador = null) {
	QFire(target, action, value, delay, activador)
}

::QFireByHandle <- function(entity, action = "", value = "", delay = 0.0, activador = null, cadder = null) {
	QFireByHandle(entity, action, value, delay, activador, cadder)
}

::RedRoundWin <- function() {

	QFireByHandle(MapParameters, "FireWinCondition", "12")

	// local AllPlayers = GetAllPlayers()

	// foreach (player in AllPlayers) {
	// 	if (player.GetTeam() == TEAMS.HUMANS) {
	// 		player.TakeDamage(99999, 0, null)

	// 	}
	// }

}

::DrawRoundWin <- function() {
	QFireByHandle(MapParameters, "FireWinCondition", "15")
}
::MapSay <- function(text)
{
    ClientPrint(null, 3, "\x07f70202"+text)
}

function OnPostSpawn() {
	foreach (player in GetAllPlayers()) {
		player.ValidateScriptScope()
		player.GetScriptScope().OnPlayerSpawn()
	}
	if (!retail) {
		PressedMax = 1
	}
	QFire("player", "RunScriptCode", "hButton = null")
	QFire("player", "RunScriptCode", "hProp = null")
	AddThinkToEnt(self, "Think")
	printl("a new day begins.......")
	QFire("player_affector","RunScriptFile","eltrasnag/faffa/player_handler.nut")
	QFire("cmd","Command","mp_roundtime 5.25")
	if (UglyBitchSluttyWhore) {
		GetBrushStates() // I Hate You.
		UglyBitchSluttyWhore = false
	}
	QFireByHandle(self,"FireUser1")
	BrushPersist()
}


SpellRow1 <- [49,66,91,94,26,55,73,84,80]
SpellRow2 <- [86,72,93,95]
// printl("THWIMBLE")
spellmaker <- Entities.FindByName(null, "dm_hallospell");

//todo list

// fix weird bug where lois jumpscares after resetting in grandma mode -- DONE

// fix Megan not ever moving -- DONE
//improve zm gameplay!!!! <--- HUGE IMPORTANCE BTW PLEASE DONT GLOSS AGAIN -- DONE (..?) (i think so!)
// fix zm tp reaching into office -- DONE
// fix zm back tp flat out not working -- DONE
// fix invisible table -- DONE (fangz bottle)
// add night counter above time -- DONE

// todo list post public test 1 -
//lower music box timer -- DONE
//fix door user thing -- DONE
//lower zm timers between attacks and increase time they are out to prevent borreeeddom -- DONE
//12 PM -- FIXED
//decrease power consumption slightly -- YEP | FORGOT | FIXED NOW
//fix hud disabling -- FIXED
//mayb bouncy physics for ballpit? taken from unused krusty -- YES -- DONE
//maybe call maria "dress"? cool name started by community -- THATS STUPID
//fixed waiting for players likeeee idgaf! -- DONE
// ADD BAD BITCH CLIP PLEASE! <------------ ALREADY FORGOTTEN LIKE 5 TIMES BTW | what does this mean?

// todo list post public test 2 -
//player_initial_spawn does NOT work. BAD use player_activate instead || DONE
//add m_nButtons think function for october release <--------------- please || DONE

//todo list pre public test 3 -

// UHGGGHHHH remove all overwritten assets UHGHHHHHHHHHHH
//grandma scare trigger doesnt actually round win but its ok because itll still cause ze plugin all players dead win still please fix this

PrecacheScriptSound("AmmoPack.Touch");
PrecacheScriptSound("music.cities_dust")
::tip <- Entities.FindByName(null, "info_bubble");
// self.ValidateScriptScope(self);

// function lalacherios()
// {
//     printl(activator)
//     local playa = activator
//     if (playa!=null)
//     {
//         playa.ValidateScriptScope()
//         if (playa.GetScriptScope().holding == false)
//         {
//             // playa.GetScriptScope().holding = true;
//             // TraceLine(playa.GetOrigin(),playa.getanbl)
//             printl("pick")
//             local targ = Entities.FindByClassnameNearest("prop_physics", playa.EyePosition(), 250.00);

//             PickupObject(targ, activator);
//             printl(targ+" <- prop  player -> "+playa)
//             // printl("ata = "+pickdest.tostring());
//             // local test = ()
//             // printl(forv)
//             // printl(orgga)
//             // printl(playa.GetForwardVector())
//             // printl(lookers)
//             // printl("test is "+test)
//             // printl(lookers.Scale(2))
//             // printl(lookers.Norm())
//             // DebugDrawLine_vCol(Vector(orgga), Vector(lookers), Vector(255 255 255), true, 3.00);
//         }
//     }
// } fail



function PauseBots(){

}

::GetAllPlayers <- function() {
	local ply = []
	for (local iPlayer = null; iPlayer = Entities.FindByClassname(iPlayer, "player");) {
		ply.append(iPlayer)
	}

	return ply
}


function SpawnAction()
{
	QFire("cmd", "Command", "ze_map_fall_damage 0", 0.0, null)
	if (DEV_TurboPhysics_Enabled == true) {

		QFire("cmd", "Command", "sv_turbophysics 0", 0.0, null);
	}
	QFire("tornado_debris_cloud", "SetParent", "Tornado_Funnel", 0.00, null);
	QFire("tornado_debris_cloud", "SetParentAttachment", "baseattach", 0.10, null);
	AddThinkToEnt(self, "Think")
    // QFire("ztp_back", "AddOutput", "target zdest_backentrance", 0.5, null); //CBA to recompile for this on test ver
    // printl("lalala");
    SendToServerConsole("sv_turbophysics 0")
    QFire("cc_night","Enable","",15.00,null);
    QFire("sf_ambience", "PlaySound", "", 0.00, null); // please put this in the auto relay. this is messy.


//
//   ALL OF THIS IS FOR TEST
// //
    // QFire("event_timer", "Kill", "", 0.00, null); // only for test
    // QFire("sf_radio_song*", "Volume", "0", 0.00, null); // only for test
    // QFire("music_box_timer", "RefireTime", 2, 0.00, null); // only for test

//
//
//

    if (PreGame)
    {
		QFire("zombie_teleporter", "Kill", "", 0, null) // surely nobody will have loaded in That fast. Surely !!!!!!!
		MapSay("Tranquility : Surely Eltra will come up with the fabled PGBE update this year!")
		// MapSay("He will not.")
        QFire("waiting_relay", "Trigger", "", 0.00, null);
    }
	else {
		QFire("zombie_teleporter", "Enable", "", 0, null)
		if (Nights != 7){
			QFire("wait_music", "PlaySound", null, 0.0, null);

		}

	}

	// QFire("zombie_teleporter", "Enable", "", 0.0, null)

    if (WinnerWinnerChickenDinner==true)
    {
        QFire("player", "RunScriptCode", "self.SetScriptOverlayMaterial("+"`eltra/fake_end`)",0.1, null);
        QFire("player", "RunScriptCode", "self.SetScriptOverlayMaterial("+"``)",15.00, null);
        // QFire("bluwin", "RoundWin", "", 15, null);
        // QFire("animatronic_move_timers*", "Kill", "", 0.1, null);
        QFire("sf_building*", "StopSound", "", 0.1, null);
        QFire("mus_night_5_win", "PlaySound", "", 0.0, null);

        QFire("cmd","Command","sm_extend_map_add_extension",0.00,null);
        WinnerWinnerChickenDinner=false;
    }
    if (Nights==7)
    {
        QFire("cn_goto", "Enable", "", 0.00, null);
        QFire("office_manager", "RunScriptCode", "ze_map_say(` ***CUSTOM NIGHT - CHOOSE YOUR CHALLENGE***", 5.00, null);
        CNKylie = 0;
        CNLois = 0;
        CNPiss = 0;
        CNPete = 0;
        CNBach = 0;
    }
    local rc1 = RandomInt(1, 500)
    local rc2 = RandomInt(1, 500)
    if (retail==false)
    {
		PressedMax = 1
        // QFire("office_manager", "RunScriptCode", "ze_map_say(` {ghostwhite}|| This is a special preview build of Peter's Burgeria to test balancing. The main release is scheduled for Halloween. Bugs can be reported to 'eltrasnag' on Discord. Have fun! ||", 1.00, null);
    }
    if (rc1==rc2)
    {
        QFire("laura", "Trigger", "", 0.00, null);
    }
    if (rc1==200)
    {
        QFire("mapscreen_1", "Trigger", "", 0.00, null);
    }
    if (rc1==300)
    {
        QFire("mapscreen_2", "Trigger", "", 0.00, null);
    }
}

function mTest()
{
    QFire("laura", "Trigger", "", 0.00, null);
}

function HOrigin()
{
    QFire("tp_h_posreset", "FireUser1", "", 0.00, null);
    //printl("humans sent to office");
}

function CheckAmbient() //check if it is time to play te funny fnaf ambient
{
    if (Aggressiveness>=RandomInt(10, 20))
    {
        QFire("sf_building_ambience_presence", "FireUser1", "", 0.00, null); //disabled for trailer 2
        Aggressiveness = -40;
    }
}

function Outage() //stage ONEof power out time
{
	QFire("ambient_generic*", "StopSound", "", 0, null)
    QFire("cc_outage","Enable","",0.00,null);

    QFire("cc_nana","Disable","",0.00,null);
    HOrigin(); //i worked hardon this so everyone gets to see it :)
    local EndTimes = RandomFloat(15.00, 30.00);
    local SongTime = RandomFloat(2.00, 6.00)
    QFire("office_lights", "TurnOff", "", 0.00, null);
    QFire("mus*", "Kill", "", 0.00, null);
    QFireByHandle(self, "RunScriptCode", "OutageStage2"+"()", EndTimes, null, null);
    QFire("outage_peter", "Enable", "", SongTime, null);
	QFire("peter_outage_light", "TurnOn", "", SongTime, null);
    QFire("outage_fx", "Trigger", "", 0.00, null);
    QFire("o_rightdoor", "Open", "", 0.00, null);
    QFire("o_leftdoor", "Open", "", 0.00, null);
    QFire("sf_building*", "StopSound", "", 0.00, null);
    QFire("light_peter_outage", "TurnOn", "", SongTime, null);
    QFire("sf_outage_song", "PlaySound", "", SongTime, null);
    QFire("sf_outage_peter", "PlaySound", "", SongTime, null);
    QFire("sf_outage_initial", "PlaySound", "", 0.00, null);
    QFire("sf_outage_song", "Volume", "0", EndTimes, null);
    QFire("sf_outage_peter", "Volume", "0", EndTimes, null);
    QFire("light_blocker_outage", "Enable", "", 0.00, null);
    QFire("animatronic_move_timers*", "Kill", "", 0.00, null);
    QFire("cams_buttons", "Kill", "", 0.00, null);
    QFire("cams_blackblocker", "Enable", "", 0.00, null);
    QFire("grandma_move_timers*", "Kill", "", 0.00, null);
    QFire("lois", "RunScriptCode", "Reset()", 0.00, null);
    QFire("maria", "RunScriptCode", "Reset()", 0.00, null);
    QFire("peter", "RunScriptCode", "Reset()", 0.00, null);
    QFire("bachelorette", "RunScriptCode", "Reset()", 0.00, null);
    QFire("freddy", "RunScriptCode", "Reset()", 0.00, null);
}

function Mischief(acti){
	if (acti.GetTeam() == 2) {
		MapSay("MISCHIEF ALERT! MISCHIEF ALERT!")
		MapSay("a zombie has opened the door...... G-G-GULP")
		PlaySoundAtCoords("items/halloween/witch0"+RandomInt(1, 3)+".wav")
	}
}
function Trusted()
{

    local Trusted = false;
    if (activator.IsValid())
    {
        activator.ValidateScriptScope()
        local at = activator.GetScriptScope().trust
        if (at>=300)
        {
            Trusted = true;
            return Trusted;
        }
        else if (at<=300)
        {
            Trusted = false;
            return Trusted;
        }
    }
}

::PlayerSetup <- function(player) {
	local SHITHEAD = player
	if(SHITHEAD!=null&&SHITHEAD.IsValid())
	{

		SHITHEAD.ValidateScriptScope()
		local shit = SHITHEAD.GetScriptScope()
		shit.spellbook <- null;
		shit.CanToss <- false;
		shit.blacklist <- false
		shit.holding <- false;
		shit.trust <- 0;
	}
}

function DoorAntiGriefLeft()
{
    if (LeftOccupied==true&&LeftClosed==true)
    {
        local t = Trusted();
        //printl(t)
        if (t==false && activator.GetTeam() == 3)
        {
            activator.ValidateScriptScope()
            activator.GetScriptScope().blacklist = true;
            activator.BleedPlayer(10.00)
        }

		if (activator.GetTeam() == 3) {
			Say(activator, "I'm a naughty, naughty little boy who likes to open doors and grief my team! #>~<#.. Now I need to rejoin the game to use doors! Aw, shucks!", false);
			QFire("office_manager", "RunScriptCode", "ze_map_say(` ***"+(NetProps.GetPropString(activator,"m_szNetname").toupper()+ " TRIED TO OPEN THE LEFT DOOR***`)"), 0.00, null);
			QFireByHandle(activator, "AddOutput", "targetname nodoor", 0.00, null, null);
			QFire("o_leftbutton","Unlock","",0.05,null);
			QFire("o_leftbutton", "pressin", "", 0.1, activator);
		}

		if (activator.GetTeam()) {
			Mischief(activator)
			QFire("o_leftbutton","Unlock","",0.05,null);
		}

    }
}

function DoorAntiGriefRight()
{
    if (RightOccupied==true&&RightClosed==true)
    {
        local t = Trusted();
        //printl(t)
        if (t == false && activator.GetTeam() == 3)
        {
            activator.ValidateScriptScope()
            activator.GetScriptScope().blacklist = true;
			activator.BleedPlayer(10.00)
        }

		if (activator.GetTeam() == 3) {
			QFire("office_manager", "RunScriptCode", "ze_map_say(` ***"+(NetProps.GetPropString(activator,"m_szNetname").toupper()+ " TRIED TO OPEN THE RIGHT DOOR***`)"), 0.00, null);
			Say(activator, "I'm a naughty, naughty little boy who likes to open doors and grief my team! I hope daddy Eltra doesn't punish me for this.... Awwaaa~!! #>~<#", false);
			QFireByHandle(activator, "AddOutput", "targetname nodoor", 0.00, null, null);
			QFire("o_rightbutton","Unlock","",0.05,null);
			QFire("o_rightbutton", "pressin", "", 0.1, activator);
		}

		if (activator.GetTeam()) {
			Mischief(activator)
			QFire("o_leftbutton","Unlock","",0.05,null);
		}
    }
}

function OutageStage2()
{
	QFire("peter_outage_light", "TurnOff", "", 0.00, null);
    QFire("cc_outage","Disable","",0.00,null);
    ItsOver = true;
    QFire("outage_peter", "Disable", "", 0.00, null);
    QFire("player", "SetFogController", "fog_outage_2", 0.00, null);
    QFire("light_peter_outage", "TurnOff", "", 0.00, null);
    QFire("peter_jumpscare_trigger", "Enable", "", RandomFloat(5.00, 13.00), null);
}

function DoorSound(door)
{
    PrecacheScriptSound("fnaf.door_slam")
	local doorpos = door.GetOrigin()
	doorpos.z = 128
	PlaySoundEX("fnaf.door_slam", doorpos)
}

function HourManager()
{
    Hour++
    QFire("o_hourtext", "AddOutput", "message |"+Hour+" AM|", 0.00, null);
    QFire("power_timer_door*", "RefireTime", (8.0-(Hour))+"", 0.00, null)

}

function AlertSound(){
	if (DoAlert){
		QFire("sf_DoorAlert", "PlaySound", "", 0.0, null);
		DoAlert = false
	}

}
function LeftLight()
{
    if (LeftOccupied==true)
    {
        // QFire("sf_door_alert", "PlaySound", "", 0.00, null); //legacy
		AlertSound()
        // LeftOccupied = false;
    }
    if (ItsOver==false&&PowerDown==false)
    {
		QFire("left_light_blocker", "Disable")

        QFire("o_leftlight", "TurnOn", "", 0.00, null);
        QFire("power_timer_light_left", "Enable", "", 0.00, null);
        QFire("o_leftlight_sound", "PlaySound", "", 0.00, null);
        QFire("o_leftlightbutton", "Unlock", "", 1.00, null);
    }
}

function RightLight()
{
    if (RightOccupied==true)
    {
        // QFire("sf_door_alert", "PlaySound", "", 0.00, null); //legacy
		AlertSound()
        // RightOccupied = false;
    }
    if (ItsOver==false&&PowerDown==false)
    {
		QFire("right_light_blocker", "Disable")

        QFire("o_rightlight", "TurnOn", "", 0.00, null);
        QFire("o_rightlight_sound", "PlaySound", "", 0.00, null);
        QFire("power_timer_light_right", "Enable", "", 0.00, null);
        QFire("o_rightlightbutton", "Unlock", "", 1.00, null);
    }
}

function RandomAmbience()
{
    QFire("sf_random_ambient_"+RandomInt(1, 23), "PlaySound", "", 0.00, null);
}

function CheckPower()
{

    QFire("power_text", "AddOutput", "message ||Remaining power - "+Power+"%||", 0.00, null);
    QFire("power_text", "AddOutput", "color 206 "+(Power+50)+" 1", 0.00, null);
    // HourColor--
    QFire("power_text", "display", "", 0.00, null);
    //printl(Power);
    if (Power<=0)
    {

        Outage();
        QFire("power_timer*", "Kill", "", 0.00, null);
        QFire("power_checker_timer", "Kill", "", 0.00, null);
        PowerDown = true;
        QFire("sf_ambience_*", "StopSound", "", 0.00, null);
        QFire("animatronic_move_timers*", "RefireTime", "0.5", 0.00, null);
        QFire("sf_ambience_*", "Kill", "", 1.00, null);

    }
}

function CheckMusic()
{
    QFire("music_text", "AddOutput", "message ||Music Box - "+Music+"%||", 0.00, null);
    QFire("music_text", "display", "", 0.00, null);
    QFire("sf_music_box", "pitch", ""+Music, 0.00, null);
    //printl(Power);
    if (Music<=0)
    {
        QFire("maria", "RunScriptCode", "RunOut("+")", 0.00, null);
        QFire("animatronic_move_timers_maria", "AddOutput", "LowerRandomBound 0.5", 0.00, null);
        QFire("animatronic_move_timers_maria", "AddOutput", "UpperRandomBound 2", 0.00, null);
        QFire("music_box_timer", "Kill", "", 0.00, null);
        // PowerDown = true;
        QFire("sf_ambience_*", "StopSound", "", 0.00, null);
        QFire("mus_maria_escape", "PlaySound", "", 0.00, null);
        QFire("sf_ambience_*", "Kill", "", 1.00, null);

    }
}

function WindBox()
{
    if (Music<=95)
    {
        Music += 4
    }
}

function UnwindBox()
{
    if (Music>=0)
    {
        Music--;
        // Music--; maybe too much? idk have to test
    }
}

function DoorsLeft()
{

    DoorAntiGriefLeft()


	activator.ValidateScriptScope()
    // activator.GetScriptScope().dooruses--

//     if (activator.GetScriptScope())
//     {
//         QFireByHandle(activator, "AddOutput", "targetname nodoor", 0.00, null, null);
//         EmitSoundOnClient("AmmoPack.Touch", activator);
//     }
}

function DoorsRight()
{
    activator.ValidateScriptScope()
    // activator.GetScriptScope().dooruses--
    DoorAntiGriefRight()
    // if (activator.GetScriptScope())
    // {
    //     QFireByHandle(activator, "AddOutput", "targetname nodoor", 0.00, null, null);
    //     EmitSoundOnClient("AmmoPack.Touch", activator);
    // }

}

function Configure_Power() // jist incase i fuck up the night stuff tee hee
{
	QFire("power_timer_global", "RefireTime", gPowerTime_Global, 0.1, null);

	QFire("power_timer_door_left", "RefireTime", gPowerTime_Door, 0.1, null);
	QFire("power_timer_door_right", "RefireTime", gPowerTime_Door, 0.1, null);

	QFire("power_timer_light_right", "RefireTime", gPowerTime_Light, 0.1, null);
	QFire("power_timer_light_right", "RefireTime", gPowerTime_Light, 0.1, null);
}

function RollSpell()
{

    local v1 = RandomInt(1, 5);
    local v2 = RandomInt(1, 5);
    if (v1==v2&&activator!=null&&activator.IsValid())
    {
        local as = activator.GetScriptScope()
        if (as.stripped==true)
        {
            DispatchParticleEffect("bombinomicon_flash_small_halloween", activator.GetOrigin(), Vector(activator.GetAbsAngles()));
            // activator.SetModelScale(0.85,0.00);
            QFire("ccmd", "Command", "playgamesound eltra/evil_wheel.mp3", 0.00, activator);
            QFireByHandle(activator, "RunScriptCode", "CanToss = true", 3.70, null, null);
            local v3 = RandomInt(1,9)
            if (v1==v3) // give rare chance of super strong spell
            {

                ClientPrint(activator, 4, "The Freddy Fazgods have gifted you a POWERFUL spell!");
                activator.RollRareSpell()

            }
            else if (v1!=v3)
            {

                ClientPrint(activator, 4, "The Freddy Fazgods have gifted you a spell!");
                spellmaker.SpawnEntityAtEntityOrigin(activator);

            }
        }
    }
}

function RollSpellBox()
{
        // activator.RollRareSpell(); too strongg :(
    if (activator!=null&&activator.IsValid())
    {
        local v1 = RandomInt(1, 4);
        local v2 = RandomInt(1, 4);
        local a = activator.GetScriptScope()
        PrecacheSound("debris/bustglass3.wav")
        EmitAmbientSoundOn("debris/bustglass3.wav", 70.00, 100, RandomInt(80, 130), activator);

        if (activator.GetTeam()==3)
        {
            // activator.SetModelScale(0.75,0.00);
            DispatchParticleEffect("bombinomicon_flash_small_halloween", activator.GetOrigin(), Vector(activator.GetAbsAngles()));
            QFire("ccmd", "Command", "playgamesound eltra/spell_get_fnaf.mp3", 0.00, activator);

            if (v1==v2) // give rare chance of super strong spell
            {
                activator.RollRareSpell()
                ClientPrint(activator, 4, "Picked up a RARE spell!");
            }
            else if (v1!=v2)
            {
                ClientPrint(activator, 4, "Picked up a spell!");
                spellmaker.SpawnEntityAtEntityOrigin(activator);
            }
        }

        if (activator.GetTeam()==2)
        {
            if (a.stripped==true)
            {
                // activator.SetModelScale(0.85,0.00);
                // QFireByHandle(activator, "RunScriptCode", "CanToss = true", 3.70, null, null);

                DispatchParticleEffect("bombinomicon_flash_small_halloween", activator.GetOrigin(), Vector(activator.GetAbsAngles()))

                QFire("ccmd", "Command", "playgamesound eltra/evil_wheel.mp3", 0.00, activator);

                // a.CanToss = true;

                local v3 = RandomInt(1, 16)
                if (v1==v3) // give rare chance of super strong spell
                {
                    ClientPrint(activator, 4, "The Blood Box has given you a RARE spell!");
                    activator.RollRareSpell()
                }
                else if (v1!=v3)
                {
                    ClientPrint(activator, 4, "The Blood Box has given you a spell!");
                    spellmaker.SpawnEntityAtEntityOrigin(activator);
                }
            }
            else if (a.stripped==false)
            {
                ClientPrint(activator, 4, "Respawning you so you can use spells! Remember to equip the spellbook!")
                activator.ForceRespawn()
            }

        }

        ScreenFade(activator,165, 48, 209,100,1.00,0.1,1);

    }
}


function ToAdminRoom()
{
    if (GetSteamID(activator)=="[U:1:172776231]")
    {
        activator.SetOrigin(Vector(-8904, -216, 2144))

    }
}

function DoorSaver()
{
    if (activator!=null&&activator.IsValid())
    {
        if (activator.GetTeam()==3)
        {

        }
    }
}
//DIRECT STREAM OF CONSCIOUSNESS AGONIZED LIMB TEARING BLEEDING CODE AHEAD WHICH HAD ZERO IMPACT ON THE OVERARCHING BATTLE TO ENABLE SPELLS .....] ||| UPDATE AS OF 23/06/21 WE HAVE TAKEN HOME A GLORIOUS VICTORY FOR SKIAL SPELLFAGS!
// ⠄⡀⠄⠄⠄⠠⠄⠠⠐⢀⢂⠢⢑⢌⠢⡑⢌⢢⢑⢅⢣⢱⢱⢱⢱⢕⢇⢗⢝⢼⡱⣣⡫⡮⡳⡝⡮⡳⡝⣎⢗⣝⢼⢱⢕⢇⢗⢕⢕⢕⢕⢕⢌⢢⢑⠄⡀⢀⠄⢀⠄⠄
// ⠄⡀⠄⠂⢈⠠⠈⢀⠈⠄⡂⠌⡂⡢⠱⡘⢌⢢⠱⡨⢢⠣⡱⡱⡱⡱⡱⡭⡳⡱⡹⣜⣜⡎⣗⢝⡎⣗⢝⣎⢧⡣⡳⡱⣣⢫⡪⡣⡣⡣⡣⡣⡣⡣⡑⡐⢀⠄⠄⠄⠄⠂
// ⠄⡀⠄⠂⠠⠄⠂⡀⠂⠡⠠⢑⢐⢜⢘⢌⢊⢢⢑⠜⡔⢕⢕⢕⢕⢕⢕⡕⣕⢝⢎⢮⢲⡹⣜⢵⡹⡪⣇⢗⢵⢕⡝⡮⡪⣎⢮⢪⢣⢣⢣⢱⢸⢌⢆⠪⠄⡀⠄⠂⠄⡀
// ⠄⠄⡀⠂⠁⠄⠂⠠⠨⠨⠨⡐⢔⠢⡑⡅⡣⡊⡢⡃⡇⡣⡣⡱⡱⡱⡱⡕⣕⢝⢼⡱⣣⢳⢕⢵⢕⢽⡸⣕⡳⣕⢝⡜⣎⢮⢪⡪⡣⡣⡣⡣⡣⡣⡣⠣⡁⢀⠄⠄⠂⠄
// ⠠⠡⢐⠈⠄⠁⡈⠄⠡⡈⡢⠨⠢⡑⢕⠸⡐⢕⢌⢆⢣⢱⢸⢸⢸⢸⢸⢸⢜⢎⢧⢳⢕⢗⡝⣎⢗⣕⢗⢵⡱⡕⡧⡳⡱⡱⡕⣕⢕⢕⢕⢕⢕⢕⢜⠕⡄⠠⠄⠠⠄⠄
// ⠨⠨⢐⢈⠄⠁⠠⢈⠐⡐⢌⠜⢌⠜⢌⠪⡘⡌⢎⠜⡌⢎⠢⡣⠣⠣⡃⠇⢇⢳⢱⢹⢪⢇⢯⢪⡺⡜⣎⢧⢳⢹⡸⡪⣪⢣⢳⢱⢱⢕⢕⢕⢕⢕⢕⢕⠢⠐⠈⠄⡀⠄
// ⠈⠨⠄⢂⠠⠁⠐⡀⠂⢌⠢⡑⡅⠪⡪⡈⡂⡊⡂⡑⡈⡂⡑⢈⠌⡀⡂⠅⢅⠕⡱⡱⡱⡕⡇⣇⢇⢧⢣⢳⢱⢱⢱⢹⢸⢸⢱⢕⢇⢗⢕⢕⢕⢕⢕⢕⠕⡈⠄⠂⠄⡀
// ⠄⠁⠈⠄⡀⠄⠁⠠⢈⠢⡑⢕⠜⢌⢂⠢⢐⠐⢌⢢⢣⢲⢸⢸⡸⡜⡜⡜⡰⡑⠕⡜⢜⢜⢜⢜⢜⢜⢜⢜⢌⢢⢑⢐⢁⢊⢂⢑⠌⡢⡑⢌⢂⢇⢇⢇⢣⠂⠈⡀⠂⠄
// ⠄⢀⠁⠠⠄⠄⠌⠄⡂⢅⢣⢑⢕⢑⢆⢊⢐⠨⢊⢂⠣⡑⢕⢕⢱⢑⢅⠣⡣⢪⠨⡈⡪⡪⣪⡪⣣⢳⢱⢑⠥⡱⡸⡸⡸⡸⡸⡜⡜⡜⡌⡒⢔⢜⢔⢕⢕⠄⠁⢀⠄⠂
// ⠄⠠⠐⠄⠂⠁⡀⢁⢐⢑⢌⢎⢪⢪⠪⡂⡂⡐⢄⠢⡑⡐⠄⡂⡢⢅⠢⡃⢎⢎⢎⢔⢐⢕⢵⢹⡸⡪⡪⡪⡘⠔⢌⠢⠡⠃⠕⠅⠣⠪⠨⡊⡆⡇⡇⣇⢇⠇⠄⠄⠄⠄
// ⠄⢂⠐⠄⠌⢀⠄⡐⡐⢌⢢⢱⢱⢸⢸⢸⢰⢈⠢⡱⡨⢢⠣⡪⡪⡪⡱⡱⢕⢕⢕⢔⢱⢱⢱⢣⡣⡣⣣⢣⢳⢱⢱⠨⡣⡑⡔⢅⢣⢱⢑⢜⢜⢎⢮⢪⢪⢊⠄⠄⠂⠄
// ⠐⠠⡈⠄⠡⠠⠄⠄⢂⠌⡎⢆⢣⢱⢑⢕⢱⢱⢑⢆⢕⢅⢇⢕⡜⣜⢜⢜⢜⢔⠕⡔⢕⢕⢕⢇⢗⢝⢜⢜⢜⢔⢕⢕⢕⢱⢱⠱⡱⡱⡱⡱⡕⣝⢜⢕⢕⠅⢀⠈⠄⠄
// ⠨⠐⠠⠁⠅⠂⡈⡐⠄⡣⠪⡊⡎⢜⢌⢎⢎⢎⢎⢇⢗⢕⡝⣎⢞⡜⣎⢎⢎⢆⢇⠣⡣⡳⡍⡧⡳⡱⡱⡱⡕⡇⡗⡕⣕⢵⢱⡹⡸⡸⡜⣜⢜⢜⢎⢇⢇⠇⠄⢀⠄⠁
// ⠄⠡⠈⡀⠂⠁⠄⠄⡑⢌⢪⢘⠌⡎⡪⡪⡪⡪⡣⡫⣎⢗⡝⣎⢧⡫⡪⡪⡪⠪⡊⢎⢪⢪⢪⢺⢸⢸⢪⢪⡪⡎⡞⣎⢞⣜⢵⡱⣝⢜⡎⡮⡪⡣⡳⡹⡸⡨⠄⠄⡀⠄
// ⠄⡁⠄⠐⢈⠠⢁⢂⠪⡨⠢⡡⢣⠱⡱⡱⡱⡱⡹⡜⡎⡇⣇⢇⢇⢇⢇⢣⠱⡑⢜⢸⢸⢸⡸⡱⡱⡕⡕⡕⡜⡜⢜⢜⢕⢕⢗⣝⢮⡣⣳⢹⡸⡱⡱⡱⡱⡑⡀⠄⠄⠄
// ⠄⠄⠂⡁⠄⢐⠐⢔⠡⡊⢌⢌⠆⡇⡣⡱⡱⡱⡱⡱⡱⡱⡱⡱⡑⡅⢐⠅⡇⡍⡪⡊⡎⡎⣎⢞⢜⢎⢎⢎⢎⢎⢆⠢⡑⢕⢕⢎⢮⢺⢸⢪⡪⡎⡇⡇⡇⡇⡂⠄⠁⠄
// ⠄⠂⡁⠠⠐⠠⠡⡑⢌⠢⡑⠔⡅⡣⡱⡱⡱⡱⡱⡱⠱⡑⢕⢜⢜⢔⢀⠁⠊⢂⠪⡘⡌⡎⡎⡮⡳⡱⡱⡱⢱⢑⢕⢝⠤⡡⠑⡕⢕⢕⢕⢇⢇⡇⡇⡇⡇⡇⠆⠄⠄⠄
// ⠄⡁⠄⠂⡈⠌⡘⢌⢢⠱⡘⢌⢢⠱⡸⡨⡪⡸⡰⡑⡕⡕⢕⢱⠸⡰⡡⡣⢅⢂⠄⠂⠊⢌⢊⠪⡘⡌⡲⡸⡸⡸⡸⡸⡸⡢⡅⢌⠪⡪⡪⡣⡣⡣⡣⡣⡣⡣⡃⠄⠈⠄
// ⠄⠠⠐⠄⠄⠑⢌⢊⢆⢣⢑⢅⠕⡅⢇⢎⢎⢎⢎⢪⡘⢌⠪⠢⠣⡣⡊⡎⡪⡢⡣⢥⢱⢰⢸⢸⢸⢸⢸⢜⢜⢎⢎⢎⢎⢎⢎⠆⢌⢆⢣⢣⢣⢣⢣⢣⢣⠣⡅⠄⠄⠄
// ⠄⠂⢀⠁⠄⠁⠕⢌⢢⢑⢅⢣⢱⢱⢱⢱⢱⢕⢵⢱⢪⠪⡢⡡⡁⠐⠨⡨⢘⠌⡪⡊⢎⢇⢇⢇⢇⢇⢇⢣⢃⢃⢑⡱⡱⡱⡱⠨⡊⡎⡎⡎⡎⡎⡎⡎⡎⡎⠆⠄⠄⠄
// ⠄⠐⠄⡀⠄⠈⠌⠢⡑⢅⢇⢣⢱⢱⢱⢱⢱⢱⢕⢕⡕⣕⢕⠕⡌⡪⡨⠪⡐⢕⠲⡬⡢⡆⡧⡪⡮⡪⢎⠪⡊⡢⡣⡪⡪⡎⡮⡱⡱⡱⡱⡕⣕⢵⢱⢹⢸⢸⠄⠠⠄⠄
// ⠄⡀⠁⢀⠄⠨⠠⢑⢘⠌⡆⡣⡣⡣⡱⡱⡱⡱⡕⡗⣝⢜⢜⢜⢌⡒⢜⢌⠪⡢⡱⡨⣊⢪⢊⠪⡌⡆⡕⡅⡇⡕⣕⢝⡜⡮⡪⡎⡮⡪⡺⡸⡜⡜⡎⡇⡇⡅⠄⠄⠄⠄
// ⢀⠠⠈⠄⠄⠂⠨⢐⢐⠱⡨⡊⡆⢇⢇⢇⢇⢇⢇⢏⢎⢮⢪⡪⣒⢕⠱⡨⢪⠪⡸⡸⡰⡱⡱⡱⡱⡱⡱⡱⡱⡱⡕⡵⡱⣣⢫⡪⡎⡮⡣⡳⡹⡸⡸⡸⡨⠄⡀⠐⠄⠄
// ⡐⡐⡨⠄⡁⠄⠡⠐⡠⡑⢔⠱⡘⡜⢜⢜⢜⢜⢜⢜⢜⢜⢜⢜⢆⢇⡣⡱⡑⡕⡱⡑⡕⡱⡱⡱⡱⡱⡱⡱⡱⡱⡕⣕⢝⡜⣎⢮⢺⢸⢪⢣⢳⢩⢪⢪⢢⠱⡠⡁⡂⠄
// ⢌⢪⢐⠅⢄⠈⢀⠡⠐⡈⡢⠣⡱⡑⡕⡕⡕⡕⡅⢇⠣⡣⡣⡣⡣⡳⡸⡸⡸⡸⡸⡸⡸⡸⡸⡸⡸⡸⡸⡸⡸⡪⡎⡮⡪⡎⡎⣎⢮⢪⡣⡳⡱⡱⡱⡱⡱⡱⡱⡸⡐⡅
// ⢱⢡⢣⢱⠡⡂⠠⠄⠅⠂⢌⠪⡂⡇⡕⡕⡕⡕⡜⡌⡪⢘⢌⢎⢎⢎⢎⢎⢎⢎⢎⢎⢎⢎⢮⡪⡺⡸⡪⡪⣣⢳⢹⢸⢸⢜⢎⢎⢮⢪⡪⡪⡪⡪⡪⡪⣪⢺⢸⢪⢪⠪
// ⢘⢜⢜⢔⢕⠬⡐⠄⠡⢁⠂⢅⠕⡜⢌⢎⢎⢎⢎⢎⢎⢔⠨⠢⡣⢱⢑⢕⢕⢕⢕⢵⢹⡪⡳⣝⢜⢮⢺⢸⢜⢜⢜⢜⡜⣜⢎⢇⢗⢕⢕⢕⢕⢕⢜⢜⢎⢮⢣⢳⡱⡍
// ⠰⠨⡪⡪⡪⡪⡢⡡⠈⢐⠨⠠⡑⠜⡌⢎⢎⢎⢎⢎⢎⢆⠣⠑⠌⡊⢎⢪⢢⢣⢣⢳⢱⢹⢸⢪⢣⢳⢱⢱⢱⢱⡱⡕⡵⡱⡕⡵⡱⡱⡱⡱⡑⡕⡕⡝⡎⡧⡫⡪⡎⠎
// ⢘⠨⡐⢕⢕⢕⢕⡪⡢⠐⠨⢐⢐⢑⢌⠪⡊⡎⢎⢎⢎⢎⢎⢇⢣⠨⡈⠢⠣⡱⢱⢱⢱⢱⢱⢕⢕⢕⢕⢕⢕⢵⢱⢕⢵⢱⢕⢕⢕⢕⢕⢕⢕⢕⡝⣜⢵⢱⢝⢎⢎⠕
// ⠨⠢⠨⡂⢣⢣⢣⢣⢣⢣⢈⢐⠐⢅⠢⡑⢌⠪⡪⢸⢨⢪⠪⡪⡪⡪⡪⡢⡅⣊⠢⡑⢅⠣⡣⣑⢕⢕⡕⡝⡎⡇⡗⡕⣕⢕⢕⢕⢕⢕⢕⢕⡕⣇⢯⢪⢎⢧⢳⢹⠐⢅
// ⠨⡊⢌⠢⠡⡃⡇⡇⡇⡇⡇⡆⠌⡂⡑⢌⠪⡨⢌⠪⡘⡔⡕⢕⢕⢜⢜⢜⢜⢜⢜⢎⢇⡏⡮⡪⡎⡧⡳⡹⡸⡪⡪⡪⡪⡪⡪⡪⡪⡣⡳⡱⡕⡧⡳⡕⡽⡸⡕⢕⠡⡑



::ZThink <- function()
{
	if (ThrowCooldown >= ZThrowCD) {
		ThrowCooldown = 0
		CanToss = true
	}
	ThrowCooldown++

    local b = (NetProps.GetPropInt(self, "m_nButtons"))
	// printl(b)
    // printl(NetProps.GetPropInt(self, "m_lifeState"))
    // printl(b)
    // if ((b / 2048)%2==1) // right click/attack2
    // {
    //     if (NetProps.GetPropInt(self, "m_lifeState")!=2)
    //     {
    //         spellbook.PrimaryAttack()
    //         return 0.5
    //     }
    // }
	// print(b | IN_USE)
    if (b & IN_USE) // use key
    {
		print("yea im use")
        if (CanToss==true&&NetProps.GetPropInt(self, "m_lifeState")!=2)
        {
            CanToss=false
            PrecacheScriptSound("fnaf.gnome_throw")
            EmitSoundOn("fnaf.gnome_throw", self);

			DoSpell(self)
            // QFireByHandle(playa, "RunScriptCode", "CanToss = true", THE_SPELL_COOLDOWN, null, null);
            return 0.1
        }
        else
        {
            // PrecacheScriptSound("Player.DenyWeaponSelection")
            // EmitSoundOnClient("Player.DenyWeaponSelection", self);
            return 0.1
        }
    }


    return 0.1
}


// spellstier1 <- ["bats","meteorshower","mirv","pumpkin"]
// spellstier2 <- ["spawnboss","horde","zombie"] acts of desperation
::RandModels <- ["models/props_junk/cinderblock01a.mdl","models/props_junk/garbage_milkcarton002a.mdl","models/props_junk/metal_paintcan001a.mdl","models/props_junk/garbage_takeoutcarton001a.mdl","models/props_junk/trafficcone001a.mdl","models/props_junk/shoe001a.mdl","models/props_junk/popcan01a.mdl"]

::DoSpell <- function(user)
{
    if (user!=null&&user.IsValid())
    {
        local o = user.GetOrigin()

        local phys = SpawnEntityFromTable("prop_physics", {model = RandModels[RandomInt(0, 6)] origin = (o.x+" "+o.y+" "+(o.z+48)).tostring() spawnflags = 0} )

		local attack_angles = user.EyeAngles().Forward()
		attack_angles.Norm()
        // spell.SetForwardVector(user.GetForwardVector())
        phys.SetPhysVelocity(attack_angles * 4500)
		phys.ValidateScriptScope()
		local pscope = phys.GetScriptScope()

		pscope.DateOfDeath <- 0
		// pscope.SpellObjectInit <- SpellObjectInit
		// SpellObjectInit(phys)
		// QFireByHandle(phys, "CallScriptFunction", "SpellObjectInit", 0.0, null, null)

		pscope.DateOfDeath <- Time() + 8.0;
		// pscope.SpellStuff <- SpellStuff
		pscope.Timer <- 0
		phys.SetCollisionGroup(1)
		AddThinkToEnt(phys, "SpellStuff");

    }
}

// ::SuSpell <- function() {
	// print("Hello.")
// }

// function SpellObjectInit(spellobject = null) {
	// spellobject.DateOfDeath <- Time() + 8.0;
	// spellobject.SpellStuff <- SpellStuff
	// AddThinkToEnt(spellobject, "SpellStuff");
// }

// avelocity = (av.x+" "+av.y+" "+av.z).tostring() velocity = (v.x+" "+v.y+" "+v.z).tostring() basevelocity = (bv.x+" "+bv.y+" "+bv.z).tostring() origin = (o.x+" "+o.y+" "+o.z+3000).tostring()

::SpellStuff <- function()
{

	if (Timer >= 0.1) {
		// printl("gdsgdsgsdg")
		self.SetCollisionGroup(6)
	}

	Timer++
    // if (self!=null&&self.IsValid())
	local v = self.GetPhysVelocity()
	// printl(v.y)
	// printl(v.x)
	if (v.Length() < 0.5 || self.GetScriptScope().DateOfDeath < Time())
	{
		// print("we DIED")


		self.Kill()
	}
    // {
    // }
    return 0.2
}

function EnableSpellsOnPlayer(playo)
{
    if (playo!=null&&playo.IsValid())
    {
        playo.ValidateScriptScope()

        local ps = playo.GetScriptScope()

        if (playo.GetTeam()==2&&ps.stripped==false)
        {
            DeletePlayerWeaponsAndEnableSpells(playo)

            local chicas = NetProps.GetPropArraySize(playo, "m_hMyWeapons");
            local fat = 0;

            while (fat<=chicas-1)
            {
                local spicegirls = NetProps.GetPropEntityArray(playo, "m_hMyWeapons", fat); //check for spellbook weapon slot being taken

                if (spicegirls!=null&&spicegirls.GetSlot()==5) // the killer itself
                {
                    spicegirls.Kill(); //bye
                }

                fat++

            }

            local playermodel = (playo.GetModelName().slice(14,(playo.GetModelName().len() - 4)))
            local sb = Entities.CreateByClassname("tf_weapon_spellbook")

            NetProps.SetPropInt(sb, "m_AttributeManager.m_Item.m_iItemDefinitionIndex",1132) // THE MISSING PUZZLE PIECE


            sb.SetCustomViewModel("models/weapons/c_models/c_"+playermodel+"_arms.mdl") // dopey but better than vm completely disappearing

            sb.DispatchSpawn()

            playo.Weapon_Equip(sb)

            ps.spellbook <- sb;

            ps.stripped=true

        }
    }
} // AGONY

function DeletePlayerWeaponsAndEnableSpells(playo) // r&m this man |||| thing to disable the melee only cond on skialwithout letting zms have guns (COULD BE AWESOME!!!!!!!!!)
{

    if (playo!=null&&playo.IsValid())
    {
        // playo.ValidateScriptScope()

        if (playo.GetTeam()==2)
        {
            // playo.RemoveCond(41)

            local chicas = NetProps.GetPropArraySize(playo, "m_hMyWeapons");
            local fat = 0;

            while (fat<=chicas-1)
            {
                local spicegirls = NetProps.GetPropEntityArray(playo, "m_hMyWeapons", fat);

                if (spicegirls!=null&&spicegirls.IsMeleeWeapon()!=true&&spicegirls.GetClassname()!="tf_weapon_spellbook")
                {
                    spicegirls.Kill(); //bye
                }

                fat++
            }
        }
    }
}


// the year was 2024...

__CollectGameEventCallbacks(this)

function OnScriptHook_OnTakeDamage(params) {
	local e = params.const_entity // victim
	local a = params.inflictor // victer
	if (e != null && e.IsValid() && a != null && a.IsValid() && e.IsPlayer() && a.IsPlayer()) {

		switch (true){
			case (e.GetTeam() == 3): // le blue team
			{

					if (a.IsPlayer() && a.GetTeam() == 2)
					{
						// printl("red hurtd the blu")
						WifeBeat(a, e)
						params.damage = 1
					}

				// printl("the blu")
				break;
			}
			case (e.GetTeam() == 2 && a.GetTeam() == 3):
			{
				// if (params.damage_type == 32){
				// 	damage = 0
				// 	damage_type = 0
				// }
				if (params.weapon != null && params.weapon.IsValid()) {
					if (params.weapon.IsMeleeWeapon()){
						params.damage = RandomInt(1, 3)
						params.damage_force = 540
						if (params.damage == 2) {

							params.crit_type = 2
							params.damage = 53287238
						}
						WifeBeat(a, e)
						if (params.crit_type == 0)
						{
							PrecacheScriptSound("fnaf.zdeath")
							EmitSoundEx({
							    soundname = "fnaf.zdeath",
								origin = a.GetOrigin()
							})
						}
						else
						{
							PrecacheScriptSound("fnaf.gnome_death")
							EmitSoundEx({
							    soundname = "fnaf.gnome_death",
								origin = a.GetOrigin()
							})
							// PlaySoundAtCoords("fnaf.gnome_death", a.GetOrigin(), 3, RandomInt(94, 106))
						}
						params.damage_type = 0
					}
					else
					{
						params.damage = 1
						params.max_damage = 1
						params.damage_force = 540

					}
				}
				// WifeBeat(attacker, victim)
				// printl("blu hurtd the RED")
				break;

			}
		}
	}
}

// function OnGameEvent_player_death(params) {
// 	local player = GetPlayerFromUserID(params.userid)
// 	if (player != null) {
// 		if (player.GetTeam() == 2) {
// 			printl("GNOME DOWN GNOME DOWN")
// 			PlaySoundAtCoords("fnaf.zdeath", player.GetOrigin(), 10)
// 		}
// 		if (player.GetTeam() == 3) {
// 			MapSay("Ghoulish")
// 			player.AddCond(77)
// 		}
// 	}
// }

function Think() {
	// printl("r_pressed: " + PressedRight.tostring())
	// printl("l_pressed: " + PressedLeft.tostring())


	// if ((LastRightState != RightDoorState)|| (LastLeftState != LeftDoorState)) {
	if (RoundStarted == true) {
		DoorPressActions()

	}
	// }
	LastRightState = RightDoorState
	LastLeftState = LeftDoorState

	// left door
	// printl("im thinkig")
	// printl("oldleftoc = "+lastleftoccupied)
	// printl("oldrightoc = "+lastrightoccupied)
	// printl("newleftoc = "+LeftOccupied)
	// printl("newrightoc = "+RightOccupied)
	if (lastleftoccupied == false && LeftOccupied == true){
		DoAlert = true
	}

	if (lastleftoccupied == true && LeftOccupied == false){
		DoAlert = false
	}

	if (lastrightoccupied == false && RightOccupied == true){
		DoAlert = true
	}

	if (lastrightoccupied == true &&RightOccupied == false){
		DoAlert = false
	}
	lastrightoccupied = RightOccupied
	lastleftoccupied = LeftOccupied
	// return 0.5
	return -1
}

function WifeBeat(attacker, victim){

	if (attacker != null && victim != null){
		local attack_angles = attacker.GetAbsAngles().Forward()
		attack_angles.Norm()

		// printl("victim = "+victim)
		// printl("attacker = "+attacker)
		// printl(attack_angles)


		local attack_speed = attacker.GetAbsVelocity().Length2D()

		// printl(stupid_attack_vel_comparer)

		if (attack_speed < 1) {
			attack_speed = 500.0
		}


		local vicvel = (attack_angles) * attack_speed
		// printl(vicvel)
		victim.SetAbsVelocity(vicvel * 10)
		PlaySoundAtCoords("eltra/my_bitch_wife.mp3", victim.GetOrigin(), 1, RandomFloat(95, 105))

	}
}

function Vector_Fucking_Multiplication(vec1, vec2) {

	local x =  vec1.x * vec2.x
	local y =  vec1.y * vec2.y
	local z =  vec1.z * vec2.z


	return Vector(x, y, z)
}

function Vector_Fucking_Division(vec1, vec2) {
	local x =  vec1.x / vec2.x
	local y =  vec1.y / vec2.y
	local z =  vec1.z / vec2.z

	if (x == 0 || y == 0 || z == 0) {

		printl(("dividing by zero? i dont think so."))
		return Vector(0, 0, 0);

	}
	return Vector(x, y, z)
}

::PlaySoundAtCoords <- function(sound, coords = Vector(0, 0, 0), vol = 1, pitch = 100) {
	PrecacheScriptSound(sound)
	EmitSoundEx({
		sound_name = sound,
		sound_level = 75,
		channel = 1,
		origin = coords,
		volume = vol,
		pitch = pitch,
		// fla
	})
}

::Send_Z_To_Spawn <- function() {
	// printl("prola")

	QFire("office_manager", "RunScriptCode", "Send_Z_Part_2()", 5.00, null);
}

function Send_Z_Part_2() {
	if (activator != null && activator.IsValid()) {
		if (activator.GetTeam() == 2 && activator.GetHealth() >= 1){

			ScreenFade(activator,133, 35, 35,255,2.00,0.1,1);
			local random = RandomInt(0, 5)
			// printl("send_z_to_spawwwwn")
			switch (random) {
				case 0:
					activator.SetOrigin(Vector(1079, 569, 323))
					break;
				case 1:
					activator.SetOrigin(Vector(251, 531, 76))
					break;
				case 2:
					activator.SetOrigin(Vector(-603, 371, 77))
					break;
				case 3:
					activator.SetOrigin(Vector(370, -1225, 53))
					break;
				case 4:
					activator.SetOrigin(Vector(-353, -2109, 32))
					break;
				case 5:
					activator.SetOrigin(Vector(-1144, 411, 80))
					break;
				default:
					break;
			}
		}
	}
}

clamp <- function(clamped, min, max) {
	if (clamped > max) {
		clamped = max
	}
	if (clamped < min) {
		clamped = min
	}
	return clamped
}

function QAngle2Vector(qangle) {
	return Vector(qangle.x, qangle.y, qangle.z)
}

function BrushPersist() { # recreate what we need from tf2's func_brush persistency
	for (local i; i = Entities.FindByClassname(i, "func_brush");) {
		local brushmodel = i.GetModelName()
		foreach (iter in BrushStates) {
		}
		// printl("g" + i.tostring())
		if (brushmodel in BrushStates) {
			// printl("brush in brushstates for " + i.tostring())
			local brushstate = BrushStates[brushmodel]

			switch (brushstate.enabled) {
				case 0:
					QFireByHandle(i, "Enable")
					break;
				case 1:
					QFireByHandle(i, "Disable")
					break;
			}
			// print()
			NetProps.SetPropInt(i, "m_iDisabled",brushstate.enabled)
			NetProps.SetPropInt(i, "m_iSolidity",brushstate.solidity)
			// i.KeyValueFromVector("position", brushstate.position)
			local colorstring = brushstate.color
			if (brushstate.color.Length() != 0) {
				QFireByHandle(i, "Color", colorstring.ToKVString())
			}
			else {
				QFireByHandle(i, "Color", "255 255 255")

			}
			i.SetAbsOrigin(brushstate.position)
			i.SetAbsAngles(brushstate.angles)
			i.KeyValueFromInt("Solidity", brushstate.solidity)
		}
	}
}

// chars: PETER, LOIS, KYLIE, MEG, PISSBEAR, GFREDDY, GRANDMA, BACHELORETTE, MARIA, MARILLA
::Jumpscare <- function(character, victim) { // JUMPSCARE FUNCTION! tags: jumpfunc jump func scarefunc
	QFireByHandle(victim,"SetHudVisibility", "1", 0.00)
	local strOverlay = "eltra/"
	local strOverlayName = ""
	local strSoundPath = "eltra/"
	local strSoundName = "eltra/"

	local vpos = victim.GetOrigin()
	vpos.z -= 40
	victim.SetAbsOrigin(vpos) # sent to hell forever

	QFireByHandle(self, "RunScriptCode", "TakeScaryDamage(activator)", 1.0, victim)
	switch (character) {
		case CHARACTERS.PETER:
			strOverlayName = "fnaf_peter_jumpscare"
			strSoundName = "jumpscare_lois_peter"
			break;
		case CHARACTERS.LOIS:
			strOverlayName = "fnaf_lois_jumpscare"
			strSoundName = "jumpscare_lois_peter"
			break;
		case CHARACTERS.KYLIE:
			strOverlayName = "fnaf_kylie_jumpscare"
			strSoundName = "kylie_jumpscare"
			break;
		case CHARACTERS.MEG:
			strOverlayName = "fnaf_meg_jumpscare"
			strSoundName = ""
			break;
		case CHARACTERS.PISSBEAR:
			strOverlayName = "fnaf_pissbear_jumpscare"
			strSoundName = "jumpscare_pissbear"
			break;
		case CHARACTERS.GFREDDY:
			strOverlayName = "golden_freddy"
			strSoundName = "grandma_jumpscare"
			break;
		case CHARACTERS.GRANDMA:
			strOverlayName = "fnaf_grandma_jumpscare"
			strSoundName = "jumpscare_grandma"
			break;
		case CHARACTERS.BACHELORETTE:
			strOverlayName = "fnaf_peter_jumpscare"
			strSoundName = "kylie_jumpscare"
			break;
		case CHARACTERS.MARIA:
			strOverlayName = "fnaf_maria_jumpscare"
			strSoundName = "jumpscare_maria_marilla"
			break;
		case CHARACTERS.MARILLA:
			strOverlayName = "fnaf_marilla_jumpscare"
			strSoundName = "jumpscare_maria_marilla"
			break;

		default:
			strOverlayName = "my_beautiful_wife"
			strSoundName = "meg_stinger"
			break;
	}


	strOverlay += strOverlayName
	strSoundPath += strSoundName + ".mp3"
	victim.SetScriptOverlayMaterial(strOverlay)

	MaterialSync(strOverlay)





	// EmitSoundEx({
	// 	sound_name = strSoundPath,
	// 	channel = 6,
	// 	sound_level = 0.2,
	// 	entity = victim,
	// })
	print("THE SOUND PATH: "+strSoundPath)
	PlaySoundEX(strSoundPath, victim.GetOrigin()+ Vector(0,30,20))

	QFireByHandle(victim,"RunScriptCode", "self.SetScriptOverlayMaterial(`eltra/fnaf_static`)", 1.00)
	QFireByHandle(victim,"RunScriptCode", "self.SetScriptOverlayMaterial(``)", 5.00)
	QFireByHandle(victim,"SetHudVisibility", "1", 5.00)

}

::MaterialSync <- function(materialname) {// I hate you.
	// QFire("burger_sync_template","ForceSpawn")
	// local hTexControl = SpawnEntityFromTable("env_texturetoggle", {
	// 	target = "my_fat_penis_child",
	// })

	// QFireByHandle(hTexControl, "SetTextureIndex", "0", 0.0)
	// hTexControl.Kill()
	// // QFireByHandle(hTexControl, "StartAnimSequence", "0 30 30 0")
	// QFire("my_fat_penis_child","Kill",0.1)
}
::TakeScaryDamage <- function(victim) {
	if (victim != null) {
		victim.TakeDamage(9999999, 0, null)
	}
}

::PlaySound <- function(strSoundName, vPos, flVol = 0.8, entity = null) {

	local soundtable = {
		sound_name = strSoundName,
		channel = 1, // CHAN_AUTO
		origin = vPos,
		volume = flVol,
		sound_level = 0.5
	}

	if (entity != null) {
		soundtable.entity <- entity
	}

	PrecacheSound(strSoundName)
	EmitSoundEx(strSoundName)
}

PlaySoundEX <- function(strSoundName, vPos = Vector(0,0,0), flVol = 10, flPitch = 100) {
	PrecacheSound(strSoundName)
	local hSound = SpawnEntityFromTable("ambient_generic", {
		message = strSoundName,
		origin = vPos,
		health = flVol,
		spawnflags = 48,
	})

	hSound.AcceptInput("PlaySound","",null,null)
	hSound.Kill()
}

ScareTime <- 0
ScareCharacter <- ""

function JumpscareThink() {
	if (Time() >= ScareTime) {
		AddThinkToEnt(self, "")
		GlobalJumpscarePart2(ScareCharacter)
		return
	}
	return ScareTime - Time()
}

::GlobalJumpscare <- function(character) {
	ScareTime = floor(Time() + 1)
	ScareCharacter = character

	AddThinkToEnt(self, "JumpscareThink")
}
::GlobalJumpscarePart2 <- function(character) {

	QFire("ambient_generic*", "StopSound", "", 0.00, null)
	local Players = GetAllPlayers()
	foreach (player in Players) {
		if (player.GetTeam() == TEAMS.HUMANS) {
			print(player)
			Jumpscare(character, player)

		}
	}
}

// ::DoorSubtract <- function(door) { // literally useless btw
// 	switch (door) {
// 		case DOOR.LEFT:
// 			PressedLeft--
// 			break;
// 		case DOOR.RIGHT:
// 			PressedRight--
// 			break;
// 		default:
// 			break;
// 	}
// 	DoorAction(door)
// }

function DoorPressActions() { // tags: dooraction door action dooractions
	PressedLeft = clamp(PressedLeft, 0, PressedMax)
	PressedRight = clamp(PressedRight, 0, PressedMax)

	if (PressedLeft == PressedMax && (LeftDoorState == DOORSTATES.OPEN) && (PressedLeft == PressedMax)) {
		printl("closeleft")
		QFireByHandle(LeftDoor, "close")
		LeftClosed = true
		DoorSound(LeftDoor)
	}

	if (LeftDoorState == DOORSTATES.CLOSED && PressedLeft < PressedMax) {
		printl("openleft")
		LeftClosed = false
		QFireByHandle(LeftDoor, "open")
		DoorSound(LeftDoor)
	}

	if ((PressedRight == PressedMax) && (RightDoorState == DOORSTATES.OPEN)) {
		printl("closeright")
		RightClosed = true
		QFireByHandle(RightDoor, "close")
		DoorSound(RightDoor)
	}
	if (RightDoorState == DOORSTATES.CLOSED && (PressedRight < PressedMax)) {
		printl("openright")
		RightClosed = false
		QFireByHandle(RightDoor, "open")
		DoorSound(RightDoor)
	}
}
