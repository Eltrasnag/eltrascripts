
final <- true;
::TimeLeft <- 0;

::CNKylie <- 0;
::CNLois <- 0;
::CNPiss <- 0;
::CNPete <- 0;
::CNBach <- 0;

GetSteamID <- function(ply){
	return NetProps.GetPropString(ply, "m_szNetworkIDString")
}

::GetSteamName <- function(ply){
	return NetProps.GetPropString(ply,"m_szNetname")
}



function OnPostSpawn() {
	if (PreGame) {
		QFireByHandle(self,"RunScriptCode","DrawRoundWin()", 30)
		QFireByHandle(self,"RunScriptCode","PreGame = false", 30)
		QFire("waiting_relay", "trigger")

	}
	printl("YAAAAAAY IT WORKS\n\n\n\n\n\n\n\n")


}


// function NightSet()
// {
//     QFire("o_nighttext", "AddOutput", "message Night "+Nights, 0.00, null);
//     QFire("office_manager", "RunScriptCode", "ze_map_say(` ***-=NIGHT "+Nights+"=-***", 0.00, null);
//     if (Nights==1)
//     {
//         if (firstnight==true)
//         {
//             QFire("tips", "Enable", "", 0.00, null);
//             QFire("tips", "Disable", "", 60.00, null);
//             QFire("sf_building_ambience_presence", "Kill", "", 0.00, null);
//             QFire("mus_night_1", "FireUser1", "", 0.00, null);
//             firstnight=false;
//         }
//         else if (firstnight==false)
//         {
//             QFire("mood_music_timer", "Enable", "", 0.00, null);
//             QFire("mood_music_picker", "PickRandomShuffle", "", 0.00, null);
//         }
//         LastNights = 1;
//         QFire("lois", "RunScriptCode", "iDifficulty = 3", 150.00, null);
//         QFire("peter", "RunScriptCode", "iDifficulty = 0", 130.00, null);
//         QFire("bachelorette", "RunScriptCode", "iDifficulty = 1", 130.00, null);
//         QFire("marilla", "RunScriptCode", "iDifficulty = 1", 130.00, null);
//         mAnger = 1;
//         QFire("animatronic_move_timers*", "Enable", "", 0.00, null)
//         QFire("event_timer", "Disable", "", 1.00, null);
//         QFire("event_timer", "Enable", "", 130.00, null);
//         if (final==true)
//         {
//             QFire("sf_phone_1b", "PlaySound", "", 5.00, null);
//         }
//         else if (final==false)
//         {
//             QFire("sf_phone_1", "PlaySound", "", 5.00, null);
//         }
//         // QFire("sf_phone_1", "PlaySound", "", 5.00, null);
//         // QFire("office_manager", "RunScriptCode", "ze_map_say(` ***-=NIGHT "+Nights"=-***", 0.00, null);
//     }
//     else if (Nights==2)
//     {
//         LastNights = 2;
//         mAnger = 2;
//         // QFire("music_box*", "Enable", "", 0.00, null);
//         // QFire("sf_music_box", "FireUser1", "", 0.00, null); too difficult for night 2....
//         QFire("mood_music_timer", "Enable", "", 0.00, null);
//         QFire("mood_music_picker", "PickRandomShuffle", "", 0.00, null);
//         QFire("lois", "RunScriptCode", "iDifficulty = 6", 0.00, null);
//         QFire("peter", "RunScriptCode", "iDifficulty = 1", 0.00, null);
//         QFire("marilla", "RunScriptCode", "iDifficulty = 2", 0.00, null);
//         QFire("maria", "RunScriptCode", "iDifficulty = 1", 0.00, null);
//         QFire("animatronic_move_timers*", "Enable", "", 0.00, null)
//         // QFire("sf_phone_2", "PlaySound", "", 5.00, null);
//         if (final==true)
//         {
//             QFire("sf_phone_2b", "PlaySound", "", 5.00, null);
//         }
//         else if (final==false)
//         {
//             QFire("sf_phone_2", "PlaySound", "", 5.00, null);
//         }
//     }
//     else if (Nights==3)
//     {
//         LastNights = 3;
//         MusicActive()
//         QFire("mood_music_timer", "Enable", "", 0.00, null);
//         QFire("mood_music_picker", "PickRandomShuffle", "", 0.00, null);
//         QFire("maria", "RunScriptCode", "iDifficulty = 2", 0.00, null);
//         mAnger = 3;
//         QFire("lois", "RunScriptCode", "iDifficulty = 5", 0.00, null);
//         QFire("peter", "RunScriptCode", "iDifficulty = 7", 0.00, null);
//         QFire("bachelorette", "RunScriptCode", "iDifficulty = 5", 0.00, null);
//         QFire("marilla", "RunScriptCode", "iDifficulty = 6", 0.00, null);
//         QFire("animatronic_move_timers*", "Enable", "", 0.00, null)
//         // QFire("sf_phone_3", "PlaySound", "", 5.00, null);
//         tip.SetOrigin(Vector(848, 156, 0.5))
//         QFireByHandle(tip, "AddOutput", "display_text ***THE MUSIC BOX IS NOW ACTIVE - STAND HERE TO WIND IT UP!***", 0.00, null, null);
//         QFireByHandle(tip, "Show", "", 0.1, null, null);
//     }
//     else if (Nights==4)
//     {
//         LastNights = 4;
//         mAnger = 4;
//         MusicActive()
//         QFire("marilla", "RunScriptCode", "iDifficulty = 7", 0.00, null);
//         QFire("maria", "RunScriptCode", "iDifficulty = 7", 0.00, null);
//         QFire("mood_music_timer", "Enable", "", 0.00, null);
//         QFire("mood_music_picker", "PickRandomShuffle", "", 0.00, null);
//         QFire("lois", "RunScriptCode", "iDifficulty = 5", 0.00, null);
//         QFire("peter", "RunScriptCode", "iDifficulty = 8", 0.00, null);
//         QFire("freddy", "RunScriptCode", "PissPower = "+RandomInt(1, 2), 0.00, null);
//         QFire("bachelorette", "RunScriptCode", "iDifficulty = 8", 0.00, null);
//         QFire("animatronic_move_timers*", "Enable", "", 0.00, null)
//         QFire("sf_phone_4", "PlaySound", "", 5.00, null);
//     }
//     else if (Nights==5)
//     {
//         LastNights = 5;
//         MusicActive()
//         mAnger = 5;
//         QFire("mus_night_5", "FireUser1", "", 0.00, null);
//         QFire("maria", "RunScriptCode", "iDifficulty = 8", 0.00, null);
//         QFire("lois", "RunScriptCode", "iDifficulty = 9", 0.00, null);
//         QFire("peter", "RunScriptCode", "iDifficulty = 11", 0.00, null);
//         QFire("bachelorette", "RunScriptCode", "iDifficulty = "+RandomInt(9,10), 0.00, null);
//         // QFire("freddy", "RunScriptCode", "iDifficulty = "+RandomInt(4, 5), 0.00, null);
//         QFire("animatronic_move_timers*", "Enable", "", 0.00, null)
//         QFire("sf_phone_5", "PlaySound", "", 5.00, null);
//         QFire("marilla", "RunScriptCode", "iDifficulty = 7", 0.00, null);
//     }
//     else if (Nights==6)
//     {
//         LastNights = 6;
//         mAnger = 5;
//         QFire("maria", "RunScriptCode", "iDifficulty = 5", 0.00, null);
//         QFire("marilla", "RunScriptCode", "iDifficulty = 10", 0.00, null);
//         QFire("lois", "RunScriptCode", "iDifficulty = 13", 0.00, null);
//         QFire("peter", "RunScriptCode", "iDifficulty = 10", 0.00, null);
//         QFire("bachelorette", "RunScriptCode", "iDifficulty = 10", 0.00, null);
//         QFire("freddy", "RunScriptCode", "PissPower = "+RandomInt(4, 5), 0.00, null);
//         QFire("meg", "RunScriptCode", "mAnger = 1", 120.00, null);
//         QFire("animatronic_move_timers*", "Enable", "", 0.00, null)
//         QFire("animatronic_move_timers*", "Disable", "", 120, null)
//         QFire("sf_phone_6", "PlaySound", "", 5.00, null);
//         QFire("mus_night_6", "PlaySound", "", 0.00, null);
// //grandma is here

//         QFire("sf_building_ambience_presence", "Kill", "", 0.00, null);
//         QFire("fog_math", "SetValue", "5", 126.00, null);
//         QFire("player", "SetFogController", "fog_night6", 126.00, null);
//         QFire("mus_night_6", "FadeOut", "5", 120.00, null);
//         QFire("mus_night_6", "StopSound", "", 125.00, null);
//         QFire("maria", "RunScriptCode", "Reset("+")", 120.00, null);
//         QFire("marilla", "RunScriptCode", "Reset("+")", 120.00, null);
//         QFire("office_manager", "RunScriptCode", "ze_map_say(` Grandma has logged in.", 126.00, null);
//         QFire("mus_grandma", "PlaySound", "", 120.00, null);
//         QFire("freddy", "RunScriptCode", "Reset("+");", 120.00, null);
//         QFire("lois", "RunScriptCode", "Reset("+");", 120.00, null);
//         QFire("office_manager", "RunScriptCode", "LeftOccupied=false;", 120.00, null);
//         QFire("fx_nan_2", "Start", "", 180.00, null);
//         QFire("tem_nanfx", "ForceSpawn", "", 119.00, null);
//         QFire("fx_nan", "Start", "", 120.00, null);
//         QFire("cc_night","Disable","",120.00,null);
//         QFire("cc_nana","Enable","",120.00,null);
//         QFire("office_manager", "RunScriptCode", "RightOccupied=false;", 120.00, null);
//         QFire("bachelorette", "RunScriptCode", "Reset("+");", 120.00, null);
//         // QFire("meg", "RunScriptCode", "Reset("+");", 120.00, null);
//         QFire("peter", "RunScriptCode", "Reset("+");", 120.00, null);

//         // activate grandma
//         QFire("grandma_move_timers", "Enable", "", 127.00, null)
//         QFire("grandma", "RunScriptCode", "iDifficulty = 15;", 0.00, null);

//     }
//     else if (Nights==7)
//     {
//         MusicActive()
//         QFire("mood_music_timer", "Enable", "", 0.00, null);
//         QFire("mood_music_picker", "PickRandomShuffle", "", 0.00, null);
//         LastNights = 7;
//         QFire("lois", "RunScriptCode", "iDifficulty = "+CNLois, 0.00, null);
//         QFire("peter", "RunScriptCode", "iDifficulty = "+CNPete, 0.00, null);
//         QFire("bachelorette", "RunScriptCode", "iDifficulty = "+CNBach, 0.00, null);
//         QFire("freddy", "RunScriptCode", "PissPower = "+CNPiss, 0.00, null);
//         mAnger = CNMeg
//         QFire("animatronic_move_timers*", "Enable", "", 0.00, null)
//         if(CNPete==1&&CNLois==9&&CNPiss==8&&CNBach==7)
//         {
//             QFire("gold_freddy_jumpscare", "Enable", "", 0.00, null);
//             QFire("lois", "RunScriptCode", "iDifficulty = 0", 0.00, null);
//             QFire("peter", "RunScriptCode", "iDifficulty = 0", 0.00, null);
//             QFire("bachelorette", "RunScriptCode", "iDifficulty = 0", 0.00, null);

//             QFire("freddy", "RunScriptCode", "PissPower = 0", 0.00, null);
//             QFire("meg", "RunScriptCode", "mAnger = 0", 0.00, null);
//             QFire("grandma_move_timers", "Enable", "", 0.00, null)
//             QFire("grandma", "RunScriptCode", "iDifficulty = 20;", 0.00, null);
//             QFire("fog_math", "SetValue", "5", 126.00, null);
//             QFire("player", "SetFogController", "fog_night6", 126.00, null);
//         }
//         if(CNPete==0&&CNLois==0&&CNPiss==0&&CNBach==0&&CNMeg==0)
//         {
//             QFire("lois", "RunScriptCode", "iDifficulty = "+RandomInt(10, 20), 0.00, null);
//             QFire("peter", "RunScriptCode", "iDifficulty = "+RandomInt(10, 20), 0.00, null);
//             QFire("bachelorette", "RunScriptCode", "iDifficulty = "+RandomInt(10, 20), 0.00, null);

//             QFire("freddy", "RunScriptCode", "PissPower = "+RandomInt(10, 20), 0.00, null);
//             QFire("meg", "RunScriptCode", "mAnger = "+RandomInt(10, 20), 0.00, null);

//         }
//     }
//     else if (Nights>=8)
//     {
//         Nights = LastNights;
//     }

// Previous is old system
// Next is copied from Singleplayer version


function NightSet()
{
	local nHourLength = gNightLength / 6.0

	QFire("nightwatch_events", "Start", "", 0.00, null);

    QFire("o_nighttext", "AddOutput", "message Night "+Nights, 0.00, null);

    MapSay( "*** -= NIGHT "+Nights+" =- ***" )

	ShouldEvent = true
	QFire("defense_timer", "Start", "", 0.00, null)
    // QFire("power_timer_global", "AddOutput", "refiretime 9.6", 0.01,  null)

    QFire("music_box_timer", "AddOutput", "refiretime 1", 1,  null)

    // QFire("event_timer", "Kill", "", 0.00, null); // get that ugly ze slap-on out of here // i need y ou back beautifull...

    switch (true) {

        case (Nights == 1):
        {
            printl("night1 smilies")
            if (firstnight==true)
            {
                QFire("tips", "Enable", "", 0.00, null);
                QFire("tips", "Disable", "", 60.00, null);
                QFire("sf_building_ambience_presence", "Kill", "", 0.00, null);
                QFire("mus_night_1", "FireUser1", "", 0.00, null);
                firstnight=false;
            }
            else if (firstnight==false)
            {
                QFire("mood_music_timer", "Enable", "", 0.00, null);
                QFire("mood_music_picker", "PickRandomShuffle", "", 0.00, null);
            }
            LastNights = 1;

			Kylie.GetScriptScope().iDifficulty = 0
            QFire("lois", "RunScriptCode", "iDifficulty = 5", nHourLength * 2, null);
            QFire("peter", "RunScriptCode", "iDifficulty = 1", nHourLength * 2, null);
            QFire("bachelorette", "RunScriptCode", "iDifficulty = 1", nHourLength * 3, null);
            QFire("marilla", "RunScriptCode", "iDifficulty = 2", nHourLength * 3, null);
            mAnger = 1;
            // QFire("animatronic_move_timers*", "Enable", "", nHourLength * 3, null)

            // QFire("event_timer", "Disable", "", 1.00, null);
            // QFire("event_timer", "Enable", "", nHourLength * 3, null);
			QFire("sf_phone_1", "PlaySound", "", 5.00, null);
            // QFire("sf_phone_1", "PlaySound", "", 5.00, null);
            // QFire("office_manager", "RunScriptCode", "ze_map_say(` ***-=NIGHT "+Nights"=-***", 0.00, null);
            break;
        }
        case (Nights == 2):
        {
            LastNights = 2;
            mAnger = 2;
			Kylie.GetScriptScope().iDifficulty = 3

            // QFire("music_box*", "Enable", "", 0.00, null);
            // QFire("sf_music_box", "FireUser1", "", 0.00, null); too difficult for night 2....
            QFire("mood_music_timer", "Enable", "", 0.00, null);
            QFire("mood_music_picker", "PickRandomShuffle", "", 0.00, null);
            QFire("lois", "RunScriptCode", "iDifficulty = 6", 0.00, null);
            QFire("peter", "RunScriptCode", "iDifficulty = 7", 0.00, null);
            QFire("marilla", "RunScriptCode", "iDifficulty = 0", 0.00, null);
            QFire("maria", "RunScriptCode", "iDifficulty = 0", 0.00, null);
            // QFire("animatronic_move_timers*", "Enable", "", 0.00, null)
            // QFire("sf_phone_2", "PlaySound", "", 5.00, null);
            if (final==true)
            {
                QFire("sf_phone_2b", "PlaySound", "", 5.00, null);
            }
            else if (final==false)
            {
                // QFire("sf_phone_2", "PlaySound", "", 5.00, null); // it is too late @ night and i am too lazy 2 record this
            }
            break;
        }
        case (Nights == 3):
        {
			Kylie.GetScriptScope().iDifficulty = 6

            LastNights = 3;
            MusicActive()
            QFire("mood_music_timer", "Enable", "", 0.00, null);
            QFire("mood_music_picker", "PickRandomShuffle", "", 0.00, null);
            QFire("maria", "RunScriptCode", "iDifficulty = 4", 0.00, null);
            mAnger = 5;
            QFire("lois", "RunScriptCode", "iDifficulty = 4", 0.00, null);
            QFire("peter", "RunScriptCode", "iDifficulty = 7", 0.00, null);
            QFire("bachelorette", "RunScriptCode", "iDifficulty = 5", 0.00, null);
            QFire("marilla", "RunScriptCode", "iDifficulty = 6", 0.00, null);
            // QFire("animatronic_move_timers*", "Enable", "", 0.00, null)
            // QFire("sf_phone_3", "PlaySound", "", 5.00, null);
            // tip.SetOrigin(Vector(848, 156, 0.5))
            // QFireByHandle(tip, "AddOutput", "display_text ***THE MUSIC BOX IS NOW ACTIVE - STAND HERE TO WIND IT UP!***", 0.00, null, null);
            // QFireByHandle(tip, "Show", "", 0.1, null, null);
            break;
        }
        case (Nights == 4):
        {
			Kylie.GetScriptScope().iDifficulty = 8

            LastNights = 4;
            mAnger = 4;
            MusicActive()
            QFire("marilla", "RunScriptCode", "iDifficulty = 9", 0.00, null);
            QFire("maria", "RunScriptCode", "iDifficulty = 9", 0.00, null);
            QFire("mood_music_timer", "Enable", "", 0.00, null);
            QFire("mood_music_picker", "PickRandomShuffle", "", 0.00, null);
            QFire("lois", "RunScriptCode", "iDifficulty = 2", 0.00, null);
            QFire("peter", "RunScriptCode", "iDifficulty = 2", 0.00, null);
            QFire("freddy", "RunScriptCode", "PissPower = "+RandomInt(1, 2), 0.00, null);
            QFire("bachelorette", "RunScriptCode", "iDifficulty = 5", 0.00, null);
            // QFire("animatronic_move_timers*", "Enable", "", 0.00, null)
            QFire("sf_phone_4", "PlaySound", "", 5.00, null);
            break;
        }
        case (Nights == 5):
        {
			Kylie.GetScriptScope().iDifficulty = 13

            LastNights = 5;
            MusicActive()
            mAnger = 7;
            // QFire("mus_night_5", "FireUser1", "", 0.00, null);
            QFire("maria", "RunScriptCode", "iDifficulty = 15", 0.00, null);
            QFire("lois", "RunScriptCode", "iDifficulty = 5", 0.00, null);
            QFire("peter", "RunScriptCode", "iDifficulty = 7", 0.00, null);
            QFire("bachelorette", "RunScriptCode", "iDifficulty = "+RandomInt(7,9), 0.00, null);
			QFire("freddy", "RunScriptCode", "PissPower = "+RandomInt(2, 6), 0.00, null);
            // QFire("freddy", "RunScriptCode", "iDifficulty = "+RandomInt(4, 5), 0.00, null);
            // QFire("animatronic_move_timers*", "Enable", "", 0.00, null)
            QFire("sf_phone_5", "PlaySound", "", 5.00, null);
            QFire("marilla", "RunScriptCode", "iDifficulty = 12", 0.00, null);
            break;
        }
        case (Nights == 6):
        {
			local nlen = (224 + gNightLength) // length of cities in dust + night len
			// local citiesstarttime = (gNightLength - 224)
			nHourLength = nlen / 6
			local nantime = nHourLength * 3 // do you THINK i would actually calculate this fuckass valu
			gNightLength = nlen
			// QFire("round_timer", "AddOutput", "timer_length " + nlen.tostring(), float delay = 0, handle activator = null)
			// MapSay("gnightlen = "+gNightLength)
			// MapSay("nhourlen = "+nHourLength)
            LastNights = 6;
            // night 6 is shorter because i dont still have the project file for the cities in dust remix
            // QFire("hour_timer", "AddOutput", "RefireTime 50", 0.1, null);
            mAnger = 5;
            QFire("maria", "RunScriptCode", "iDifficulty = 5", 0.00, null);
            QFire("maria", "RunScriptCode", "iDifficulty = 13", 0.0, null);
            QFire("marilla", "RunScriptCode", "iDifficulty = 14", 0.00, null);
            QFire("lois", "RunScriptCode", "iDifficulty = 16", 0.00, null);
            QFire("peter", "RunScriptCode", "iDifficulty = 12", 0.00, null);
            QFire("bachelorette", "RunScriptCode", "iDifficulty = 12", 0.00, null);
            QFire("freddy", "RunScriptCode", "PissPower = "+RandomInt(4, 5), 0.00, null);
            QFire("kylie", "RunScriptCode", "iDifficulty = 1", 180.00, null);

            QFire("maria", "RunScriptCode", "iDifficulty = 0", nantime, null);
            QFire("marilla", "RunScriptCode", "iDifficulty = 0", nantime, null);
            QFire("lois", "RunScriptCode", "iDifficulty = 0", nantime, null);
            QFire("peter", "RunScriptCode", "iDifficulty = 0", nantime, null);
            QFire("bachelorette", "RunScriptCode", "iDifficulty = 0", nantime, null);
            QFire("freddy", "RunScriptCode", "PissPower = 0", nantime, null);
            QFire("kylie", "RunScriptCode", "iDifficulty =0", nantime, null);

            QFire("sf_phone_6", "PlaySound", "", 5.00, null);
            // QFire("mus_night_6", "PlaySound", "", 0.00, null);

        //grandma is here

            QFire("sf_building_ambience_presence", "Kill", "", nantime, null);

            QFire("fog_math", "SetValue", "5", nantime, null);
            QFire("player", "SetFogController", "fog_night6", nantime, null);

            QFire("mus_night_6", "FadeOut", "5", nantime, null);
            QFire("mus_night_6", "StopSound", "", nantime, null);

            QFire("maria", "RunScriptCode", "Reset("+")", nantime, null);
            QFire("marilla", "RunScriptCode", "Reset("+")", nantime, null);
            QFire("lois", "RunScriptCode", "Reset("+");", nantime, null);
            QFire("freddy", "RunScriptCode", "Reset("+");", nantime, null);
            QFire("bachelorette", "RunScriptCode", "Reset("+");", nantime, null);
            QFire("peter", "RunScriptCode", "Reset("+");", nantime, null);

            QFire("self", "RunScriptCode", "MapSay('Grandma has logged in.')", nantime, null);
            QFire("mus_grandma", "PlaySound", "", nantime, null);
            QFire("sf_building_ambience*", "volume", "0", nantime, null);

            QFire("office_manager", "RunScriptCode", "LeftOccupied=false;", nantime, null);
            QFire("office_manager", "RunScriptCode", "RightOccupied=false;",nantime, null);
			Power += 42 // i believe in friends and laughter and the wonders love can do...
            // QFire("meg", "RunScriptCode", "Reset("+");", 180.00, null);

            // activate grandma
            QFire("grandma", "RunScriptCode", "iDifficulty = 15;", nantime, null);
            QFire("grandma", "RunScriptCode", "iDifficulty = 20;", nHourLength*5, null);
            break;
        }
        case (Nights == 7):
        {
            MusicActive()
            QFire("mood_music_timer", "Enable", "", 0.00, null);
            QFire("mood_music_picker", "PickRandomShuffle", "", 0.00, null);
            LastNights = 7;
            QFire("lois", "RunScriptCode", "iDifficulty = "+CNLois, 0.00, null);
            QFire("peter", "RunScriptCode", "iDifficulty = "+CNPete, 0.00, null);
            QFire("bachelorette", "RunScriptCode", "iDifficulty = "+CNBach, 0.00, null);
            QFire("freddy", "RunScriptCode", "PissPower = "+CNPiss, 0.00, null);
            mAnger = CNMeg
            QFire("animatronic_move_timers*", "Enable", "", 0.00, null)
            if(CNPete==1&&CNLois==9&&CNPiss==8&&CNBach==7)
            {
                QFire("gold_freddy_jumpscare", "Enable", "", 0.00, null);
                QFire("lois", "RunScriptCode", "iDifficulty = 0", 0.00, null);
                QFire("peter", "RunScriptCode", "iDifficulty = 0", 0.00, null);
                QFire("bachelorette", "RunScriptCode", "iDifficulty = 0", 0.00, null);

                QFire("freddy", "RunScriptCode", "PissPower = 0", 0.00, null);
                QFire("meg", "RunScriptCode", "mAnger = 0", 0.00, null);
                QFire("grandma_move_timers", "Enable", "", 0.00, null)
                QFire("grandma", "RunScriptCode", "iDifficulty = 20;", 0.00, null);
                QFire("fog_math", "SetValue", "5", 186.00, null);
                QFire("player", "SetFogController", "fog_night6", 186.00, null);
            }
            if(CNPete==0&&CNLois==0&&CNPiss==0&&CNBach==0&&CNMeg==0)
            {
                QFire("lois", "RunScriptCode", "iDifficulty = "+RandomInt(10, 20), 0.00, null);
                QFire("peter", "RunScriptCode", "iDifficulty = "+RandomInt(10, 20), 0.00, null);
                QFire("bachelorette", "RunScriptCode", "iDifficulty = "+RandomInt(10, 20), 0.00, null);

                QFire("freddy", "RunScriptCode", "PissPower = "+RandomInt(10, 20), 0.00, null);
                QFire("meg", "RunScriptCode", "mAnger = "+RandomInt(10, 20), 0.00, null);

            }
            break;

        }
    }

    if (Nights>=8)
    {
        Nights = LastNights;
    }

	QFire("round_timer", "settime", gNightLength.tostring(), 0.0, null);
	QFire("hour_timer", "refiretime", nHourLength, 0.0, null);
	printl("Night hour len = "+nHourLength)
	printl("Night len = "+gNightLength)
}

function NightDone()
{
    QFire("lois", "RunScriptCode", "Reset()", 0.00, null);
    //printl("night "+Nights+" is finished");

    Nights++
    NightSet()
}


function JumpscareCG(char)
{
    if(ItsOver==true)
    {
        activator.SetScriptOverlayMaterial("eltra/fnaf_"+char+"_jumpscare");
        QFire("sf_jumpscare", "PlaySound", "", 0.00, null);
        QFire("ccmd", "Command", "play eltra/jumpscare.mp3", 0.00, activator);
        QFire("ccmd", "Command", "r_screenoverlay eletra/tv_static", 1.00, activator);
        Night_Failed();
    }
}

function Static()
{
    QFireByHandle(activator, "AddOutput", "health -1", 0.00, null, null);
}

::Night_Failed <- function()
{
    // QFire("redwin", "RoundWin", "", 0.00, null);
	RedRoundWin()
}

function CompletedNight()
{
	Kylie.GetScriptScope().iDifficulty = 0
    QFire("lois", "RunScriptCode", "Reset()", 0.00, null);
    QFire("maria", "RunScriptCode", "Reset()", 0.00, null);
    QFire("peter", "RunScriptCode", "Reset()", 0.00, null);
    QFire("bachelorette", "RunScriptCode", "Reset()", 0.00, null);
    QFire("freddy", "RunScriptCode", "Reset()", 0.00, null);
    if (Nights==5)
    {
        WinnerWinnerChickenDinner=true;
    }
    if (Nights<=6)
    {
        Nights++
    }

    else if (Nights==7)
    {
// have not finished yet LOl..........
    }
    QFire("night_finished_confetti", "Start", "", 0.00, null);
    QFire("sf_6am", "PlaySound", "", 0.00, null);
    QFire("player", "SetFogController", "fog_daylight", 0.00, null);
    // QFire("bluwin", "RoundWin", "", 0.00, null);
	BluRoundWin()
    QFire("day_lights", "TurnOn", "", 0.00, null);
    QFire("o_rightdoor", "Close", "", 0.00, null);
    QFire("o_leftdoor", "Close", "", 0.00, null);
    QFire("o_leftbutton", "Lock", "", 0.00, null);
    QFire("o_rightbutton", "Lock", "", 0.00, null);
    Power=100;
}

function MusicActive()
{
	if (retail) {
		QFire("music_box*", "Enable", "", 0.00, null);
		QFire("sf_music_box", "FireUser1", "", 0.00, null);

	}
}