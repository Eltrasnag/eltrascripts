PeterHeads <- ["[U:1:190285622]","[U:1:172776231]","[U:1:247075705]"];
// function OnPostSpawn()
// {
//     self.ValidateScriptScope()
//     __CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);
// }

function ZombieSpawnFunction(player) {
	if (player !=  null){
		AddThinkToEnt(player, "ZombieThink")

		// self.SetForceLocalDraw(true)
		DeleteZWearablesAndGiveCrowbar(player)
		// self.SetForcedTauntCam(1)
		player.SetHealth(50)

		player.SetMaxHealth(50)



		CanToss <- true

		EListen(player)

		// self.AddCustomAttribute("applies snare effect", 20, -1)

		ClientPrint(player, 4, "left CLICK to throw MISCELLANEOUS ITEMS like the FERAL ANIMAL that you are")
		PrecacheModel("models/eltra/trollface.mdl")
		player.SetModel("models/eltra/trollface.mdl")
		PrecacheScriptSound("fnaf.DramaStinger")
		player.QEmitSound("fnaf.DramaStinger")
		DoEntFire("fog_math","GetValue","",0.00,player,player);
		// self.SetModelScale(0.5,0.00);
		ScreenFade(player,133, 35, 35,255,2.00,0.1,1);
		// self.AddCond(41)
	}
}

function OnGameEvent_player_spawn(EventData)
{
	local a = GetPlayerFromUserID(EventData.userid)
	a.AcceptInput("RunScriptFile", "eltrasnag/faffa/player.nut", null, null)

    if(a!=null&&a.IsValid())
		{

		// a.SetForcedTauntCam(0)
		// a.SetCustomModel("")
		// a.SetForceLocalDraw(false)
        // a.SetModelScale(0.75,0.00);
        a.ValidateScriptScope()
        local ascope = a.GetScriptScope()
		if (ascope.len() <= 10 || !retail) {

			printl("player " + a.tostring()+" has no script attached!")
			a.AcceptInput("RunScriptFile", "eltrasnag/faffa/player.nut", null, null)
			a.ValidateScriptScope()
			ascope = a.GetScriptScope()
			ascope.OnPostSpawn()
		}


		if (!("blacklist" in ascope)) {
			PlayerSetup(a)
		}
        // ascope.spellbook <- null;
        DoEntFire("fog_math","GetValue","",0.00,a,null);
        QFireByHandle(a, "SetHudVisibility", "1", 0.00, null, null);

        DoEntFire("ccmd","Command","r_screenoverlay off",0.00,a,null);
        a.SetScriptOverlayMaterial("")

        if (retail==false)
        {
            // a.SetScriptOverlayMaterial("eltra/prerelease_demo_overlay");
        }


        //blue team

        if(a.GetTeam()==3)
        {
			AddThinkToEnt(a, "HumanThink")
			// a.AddCond(76)
            // EIgnore(a) // this will say null but it doesnt mean anything
            ascope.CanToss==false;

            ScreenFade(a,35, 81, 133,255,2.00,0.1,1);
            // a.SetModelScale(0.75,0.00);

            if (ascope.blacklist==false)
            {
                // ascope.dooruses <- 999999999; // the door uses maechanic was stupid and literlaly irrelevant because of the blacklist thing

                QFireByHandle(a, "AddOutput", "targetname bajonk", 0.00, null, null);
            }

        }

        //red team

        if(a.GetTeam()==2)
        {
			// QFireByHandle(a, "CallScriptFunction", "ZombieSpawnFunction", 0, a, null)
			ZombieSpawnFunction(a)
        }

        // a.ViewPunch(QAngle(300, 300, 300));

        local eltrasnum = 0;


        foreach (PeterHead in PeterHeads)
        {

            if(GetSteamID(a)==PeterHeads[eltrasnum])
            {
                    if (a.GetTeam()==3)
                    {
                        a.ValidateScriptScope()
                        // ascope.dooruses = 999999999;
                        QFireByHandle(a, "AddOutput", "targetname bajonk", 0.00, null, null);

                    }
                    ClientPrint(a, 4, "|DEV| Playerhandler executed all the way to end")
                break;
            }
            eltrasnum++;
        }
    }
}


// function OnGameEvent_player_connect(EventData)
// {
// e at10 11 pm i just forgt to put validatescript scope...........
// }

function OnGameEvent_player_death(data) {


	local player = GetPlayerFromUserID(data.userid)

	if (player != null) {
		if (player.GetTeam() == 2){
			PlaySoundAtCoords("fnaf.zdeath", player.GetOrigin(), 10)
			// QFireByHandle(player, "RunScriptCode", "self.ForceRegenerateAndRespawn()", 0.01, null, null) // obsolete in burgercss?

		}

		// if (DEV_Enable_BLU_To_Red_Death_Failsafe == true) {
			// if (player.GetTeam() == 3) {
				// player.SetTeam(TEAMS.ZOMBIES)
				// player.ForceChangeTeam(2, true);
			// }

		// }

	}
}


//erm.......................

//I SWEAR TO CHRIST IF THIS SPAWN FUNCTIONS STILL DOES NOT FUCKING SCALE THE PLAYER AFTER 3 VERSIONS |||| UPDATE 23/06/21 WE HAVE HAD A JOYOUS VICTORY!
// ⢠⠠⢀⠄⠄⡂⢀⠄⠄⢀⢪⠪⡰⣝⠔⠠⠄⠄⠄⠄⠄⠄⠄⢔⢕⢕⢗⡕⡐⣕⢝⢵⠭⢍⡓⢦⡀⣔⢤⣂⠄⠄⠄⠄⠄⠄⠈⠐⠔⡌⠆⢕⠔⢌⠂⢅⠣⡃⡇⡕⢕⢱⢑⠕⡕⡹⡸⢳⢹⡪⡳⢙⢀⢂⢂⢂⢂⢂
// ⠸⠪⢎⢮⠡⢢⢇⢮⡰⡡⢈⣢⣻⣪⠨⠄⠄⠄⢀⢀⢢⢁⢐⠵⢝⠭⡳⢑⢐⠱⢙⠡⢩⣨⣬⣤⡵⣥⣥⣥⡀⠄⠄⠄⠄⠄⠐⠄⠄⠑⢍⢆⡣⢑⠨⠢⡋⢎⢪⢪⢪⠪⡪⡪⡪⡸⡨⡪⢢⠣⡨⢐⠠⢂⠂⡂⡂⡂
// ⡪⣎⢦⡢⠡⢢⡡⣣⢩⢐⢐⢑⢓⢁⠄⠄⠄⠄⠠⠄⠄⢂⢐⢨⢐⢌⡂⢅⢂⢆⢆⡵⣓⡻⣞⣗⣛⣛⣾⣽⢿⣆⠁⡀⠁⠄⠠⠐⠄⠄⠄⠁⠪⠢⡈⠌⡜⢌⢪⢘⢔⠕⡕⢜⢌⢎⢪⠸⠨⢊⢐⠐⡨⢐⢐⠔⡰⢐
// ⢞⣎⢧⣫⠨⣪⡻⡮⡯⡂⡯⡯⣗⡇⠌⠄⠐⠨⡸⣸⢩⢐⠸⡜⡎⡧⣝⢐⢱⢕⢗⡏⣬⣭⢫⣗⣡⣤⡁⢿⣿⣽⡐⡀⢈⠄⠄⠄⠂⠄⠄⠄⠄⠐⠈⢌⠜⡨⠢⡑⢌⠪⡈⡢⢑⠌⠪⡈⠎⡐⠠⢂⢂⢂⠢⡑⢌⠄
// ⠑⠕⠣⡃⡂⠷⠽⡝⡇⡂⠏⠉⠃⠃⡁⠈⠄⢅⢳⢕⡓⠄⣝⢮⡳⣕⢕⠔⢱⠱⣓⣯⣏⡘⣜⢮⢆⣹⣣⣽⣾⡿⡇⠠⢀⠠⠐⠄⠌⠄⠐⡀⠄⠄⡀⠄⠐⢐⢁⠂⢅⢂⢂⠂⠅⢌⢂⢂⠅⢌⢌⠢⢊⠢⡑⠅⠕⠌
// ⠄⠁⠄⠄⡀⠈⢀⠈⠐⠄⡁⢈⠄⡁⡐⢈⢸⢐⢵⡹⡊⠌⣮⡳⣕⠇⠅⠨⠄⠅⠂⠄⡱⢝⢵⢳⢧⠓⠁⢐⢱⡿⡃⠅⠄⠠⠄⠨⠐⠈⠠⠄⠄⠂⢀⠄⠄⠄⢀⢑⢐⠐⠄⢅⢑⢐⠨⢐⢈⢂⢐⠌⡢⡑⢌⢌⢘⠨
// ⢀⠂⠄⡁⠄⠨⢀⢐⠈⡀⠄⠄⠄⠄⠄⡐⢜⢜⢔⢽⠅⠅⣗⣝⢮⢫⠐⠠⠡⡈⣂⣢⡺⣲⣪⢮⢪⢂⢕⣲⢽⣾⣨⢪⠐⡈⠄⠨⢈⠠⠡⢈⠠⢈⠄⡀⠂⡐⡐⡐⠄⠅⠕⡐⡐⡐⢌⢐⠔⢌⠆⡕⢌⠌⢆⠆⢕⠡
// ⣕⣕⢕⢔⢕⣕⣕⣔⢕⡔⠄⠐⢀⠄⠄⡂⡕⣇⢃⢗⢅⢣⢗⣗⣽⣪⣴⣼⣲⢯⣳⢵⢝⠼⡝⡗⣵⣿⣯⢿⣻⣽⡞⢟⢧⣔⣅⣌⣆⣐⣅⡢⢐⠠⠂⠠⠄⢐⠐⠄⡅⢅⠅⠆⠔⠌⠂⠕⠸⡐⡑⡌⡢⡑⡑⢌⠢⠨
// ⡗⣞⢮⣳⢽⣺⣞⡾⣽⢾⢈⢐⡐⢠⡒⣆⢯⢪⢦⡫⣦⣞⣿⣽⣯⣿⣽⠞⠁⡑⠘⢌⠏⡎⠝⣸⣺⢿⡽⣟⣯⣷⢬⣠⡴⣾⣽⣯⢿⣻⣟⣿⣟⣷⣧⣥⣌⠐⢌⢊⠢⡃⠎⢎⠪⢨⢐⢌⠪⡨⡂⠆⡊⡢⠑⢌⢘⠌
// ⡯⣺⢽⣺⢽⢾⣺⣽⢯⣟⠄⡗⡜⣜⢮⢺⡸⣕⡷⣟⣿⢾⣻⡾⣷⢿⣾⡀⢀⠂⠡⠄⠃⠊⠜⢼⢺⢝⡟⡿⡽⣞⣟⣷⣟⣿⣞⣯⣿⢿⣽⣷⢿⣯⣿⣽⢿⣿⢶⣆⡑⠌⡊⠢⢑⠐⠔⠜⢌⢢⠨⡢⢑⠨⠨⡂⠅⡂
// ⣏⢯⣻⣺⢽⢯⣟⣾⣻⡇⢕⢑⠕⡵⡹⡪⡪⣾⣻⢿⣽⣟⣯⣿⣻⢟⡯⡳⠐⠐⠄⠡⠨⡢⡢⡤⡠⣀⢀⡁⢅⢾⡽⣾⣻⡾⣯⣿⣟⣿⣿⣾⣿⣿⣾⢿⣻⣽⣿⣻⣿⣬⡊⢌⢐⠨⢈⢊⢆⠕⡑⢌⠆⡣⠣⡑⢅⢂
// ⡳⣽⣺⣺⢽⡽⣞⢷⢯⢇⠪⢠⡱⣕⢵⡱⡵⣿⢽⣟⣷⣻⣗⢯⠮⡓⠕⠌⡂⡂⡂⡢⠑⢌⠊⢎⠪⡊⡞⡎⡇⡗⡝⣯⣷⣿⡿⣟⣿⣿⣻⣽⣿⣯⣿⣿⣟⣯⣿⣽⣾⣯⣷⡄⠂⠠⡑⠅⠄⠠⡨⠄⡁⡂⠅⡂⡂⠄
// ⡫⡺⢺⢺⠽⠽⢝⠯⠋⡂⠅⡇⡗⣕⢵⢝⣽⣯⢿⣯⡯⡗⡕⡇⠣⠡⠡⢑⢐⠨⢐⠠⠑⡀⢊⠐⡐⠌⡂⢅⠣⡳⡑⡽⡾⣷⡿⣿⣟⣯⣿⢿⣽⣯⡿⣾⣻⣯⣿⡷⣟⣷⡿⣷⡁⣌⢎⡪⢌⠂⠔⡰⠰⡑⠕⡐⠄⠅
// ⢀⢄⡂⣀⣈⢰⡰⣰⢔⢦⣕⡮⣞⣖⡶⣳⣳⣟⣯⣷⢏⢜⠜⡈⠌⡐⢁⢂⠐⡈⠄⢂⠡⠐⡀⠂⢂⠁⡐⠠⠡⢑⠕⣝⣿⣯⣿⣿⣽⢿⡾⣟⣷⢯⡿⣯⣿⣯⣷⣿⣿⢿⣽⣯⣷⣻⡽⡯⠃⡑⡐⡐⠔⡐⡡⢈⠌⠌
// ⡗⣗⡯⣗⣯⡯⣿⣚⣯⣿⢾⣽⣳⣗⣿⡽⣞⡞⡊⡚⢔⠡⠂⡂⠡⠐⡀⢂⢐⠠⠨⣀⢂⠡⠄⠡⠄⠄⠐⢀⠁⢂⠄⢇⡷⣟⣷⣟⣾⣟⡿⣯⣟⣯⢿⣻⣾⣻⣿⣻⣟⣿⣳⡿⣾⡺⡍⡐⡑⠌⡊⢌⠪⠰⡐⡐⠈⠄
// ⡯⣗⡯⣟⣾⢽⣯⢿⣽⣾⢿⣻⣽⡿⣷⡿⣟⣷⣔⠐⠄⢌⠐⠠⢈⠐⢐⠐⡔⣮⡿⡾⢑⠄⠅⠂⠁⡀⠁⠠⠐⠄⠄⡱⡽⣽⣺⣳⣟⣞⣯⢷⣻⣞⣿⢽⡾⣿⣽⢿⡽⣯⡷⣿⢽⡪⠐⠄⠄⠁⠒⠠⢅⢑⢐⠨⠨⠠
// ⣟⢾⢽⡽⣞⡿⣞⣿⣳⣿⣻⡿⣯⣿⣟⣿⣻⢷⣻⣻⠄⠄⠄⢁⠠⠈⢀⠐⠈⡀⢁⠐⠄⡁⠈⠄⠄⠄⠄⠂⠄⠄⢂⢎⡯⣗⣟⣞⢾⣺⣺⣝⢗⣟⣞⡯⣟⣷⣻⢽⢯⢷⣻⢽⡱⡅⡀⠂⠐⠈⠄⠂⠄⠂⠂⠌⠠⠁
// ⣗⢯⣗⢿⢽⡽⣯⢷⢿⣞⣯⡿⣯⣷⣟⣯⢿⣻⡽⣞⡀⠄⠄⠄⠄⢀⠄⢀⠄⠄⠄⠄⠄⠄⠄⠄⠈⠄⠄⠄⠄⡀⠈⠑⠙⡚⠦⡣⠫⠚⢎⢞⢵⠱⠱⡫⡳⡳⣝⠽⡝⡝⢜⢜⢜⠕⡐⢀⠈⢀⠁⢈⠠⠈⢀⠈⢐⠑
// ⣗⢽⣺⢽⣫⢯⡯⡿⣽⣽⣳⣟⣿⣺⣽⢾⡯⣗⣯⣗⢧⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠂⠈⠂⠢⠄⠄⠄⡀⠁⠁⠄⢀⠂⡁⠡⠠⠡⠑⠡⠡⢡⢬⢎⢮⢪⢌⢂⢂⠐⠠⠄⠄⠄⠂⠄⡀⠄⠄
// ⡳⣝⢮⡻⣺⢽⢽⢽⡳⣗⣟⣞⣗⣟⢾⣝⢯⢟⢞⢞⢽⢹⡢⡤⡀⡀⠄⠄⠄⠄⠄⠄⠂⠄⠄⠠⠄⢀⠈⠄⢀⠠⠄⢀⠠⡖⣕⠤⣀⢁⠐⠄⠄⡀⢂⢐⡠⡅⡮⡺⣝⢮⢏⢯⡺⡜⣎⢦⢱⢨⠠⡁⡐⠄⠁⠄⠠⠄
// ⡝⡮⡳⠽⡕⡏⡏⢇⠯⢺⠸⢪⠪⡪⢣⢓⢍⢇⢇⢇⢣⠣⡣⡓⡇⢇⢕⠔⡔⡠⡀⠄⠄⠄⢔⠡⠄⠄⠄⠈⠄⠄⢀⢄⢣⠱⡘⡜⢌⢎⢪⢱⢱⢸⢸⢰⢡⠣⡃⡇⡕⡱⡱⢱⢱⢱⢡⢣⢑⢅⢣⠢⡊⠌⠌⡂⡁⡂

// function DeletePlayerWeaponsAndEnableSpells(playo) // r&m this man
// {

//     if (playo!=null&&playo.IsValid())
//     {
//         playo.ValidateScriptScope()

//         if (playo.GetTeam()==2)
//         {
//             playo.RemoveCond(41)
//             local chicas = NetProps.GetPropArraySize(playo, "m_hMyWeapons");
//             local fat = 0;
//             while (fat<=chicas-1)
//             {
//                 local spicegirls = NetProps.GetPropEntityArray(playo, "m_hMyWeapons", fat);
//                 // printl(spicegirls+" IS ONE THE WEAPONS.")
//                 if (spicegirls!=null&&spicegirls.IsMeleeWeapon()!=true&&spicegirls.GetClassname()!="tf_weapon_spellbook")
//                 {
//                     spicegirls.Kill(); //bye
//                 }
//                 fat++
//             }
//         }
//     }
// }

// function EnableSpellsOnPlayer(playo)
// {

//     if (playo!=null&&playo.IsValid())
//     {
//         playo.ValidateScriptScope()
//         local ps = playo.GetScriptScope()
//         if (playo.GetTeam()==2&&ps.stripped==false)
//         {
//             DeletePlayerWeaponsAndEnableSpells(playo)
//             local chicas = NetProps.GetPropArraySize(playo, "m_hMyWeapons");
//             local fat = 0;
//             while (fat<=chicas-1)
//             {
//                 local spicegirls = NetProps.GetPropEntityArray(playo, "m_hMyWeapons", fat);

//                 // if (spicegirls!=null)
//                 {
//                     printl(spicegirls.GetSlot()+" is the slot of the weapon: "+spicegirls+". < ------ WAVE 1")

//                 }
//                 if (spicegirls!=null&&spicegirls.GetSlot()==5)
//                 {

//                     printl(spicegirls.GetSubType())
//                     printl(spicegirls+" has been assassinated in Slot "+spicegirls.GetSlot())
//                     spicegirls.Kill(); //bye
//                 }
//                 fat++
//             }

//             local playermodel = (playo.GetModelName().slice(14,(playo.GetModelName().len() - 4)))
//             local sb = (SpawnEntityFromTable("tf_weapon_spellbook", {Model = "models/weapons/c_models/c_"+playermodel+".mdl"}))

//             NetProps.SetPropInt(sb, "m_iItemDefinitionIndex",1132) // THE MISSING PUZZLE PIECE
//             sb.DispatchSpawn()
//             playo.Weapon_Equip(sb)
//             ps.spellbook <- sb;
//             ps.stripped=true
//         }
//     }
// } // AGONY



function EListen(a)
{
	a.ValidateScriptScope()
	local ascope = a.GetScriptScope()
	// ascope.EvilFakeZThink <- EvilFakeZThink
	ascope.PlayerClock <- 0
	ascope.ThrowCooldown <- 0

    AddThinkToEnt(a, "ZThink")
    // printl("added")
    // printl(a.GetScriptThinkFunc())
}



function EIgnore(a)
{
    AddThinkToEnt(a, "")
    // printl("removed")
    // printl(a.GetScriptThinkFunc())
}

__CollectGameEventCallbacks(this)


function DeleteZWearablesAndGiveCrowbar(hPlayer)
{
	// obsolete in burgercss
	// PrecacheModel("empty.mdl")
    // local hWearable;

    // while (hWearable = Entities.FindByClassname(hWearable, "tf_wearable*"))
	// {
    //     if (hWearable.GetOwner() == hPlayer)
	// 	{
    //         hWearable.Kill();
	// 	}
	// }
	// local hWeapon;
    // while (hWeapon = Entities.FindByClassname(hWeapon, "tf_weapon*"))
	// {
    //     if (hWeapon.GetOwner() == hPlayer)
	// 	{
	// 		// printl(hWeapon)
	// 		// NetProps.SetPropInt(hWeapon, "m_nRenderMode", Constants.ERenderMode.kRenderNone)
	// 		hWeapon.Kill()
	// 		// QFireByHandle(hWeapon, "AddOutput", "rendermode 10", 0.1, null, null);
	// 	}
	// }
	// local zwep = SpawnEntityFromTable("tf_weapon_bat", {
	//     model = "empty.mdl"
	// })
	// // zwep.SetModelSimple("models/eltra/w_crowbar.mdl") // funnier if tghey just slap tbh
	// zwep.DispatchSpawn()
	// // zwep.SetCustomViewModel("models/empty.mdl")

	// hPlayer.Weapon_Equip(zwep)
	// hPlayer.Weapon_Switch(zwep)

}

