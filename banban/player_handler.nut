PeterHeads <- ["[U:1:172776231]","[U:1:253374491]","[U:1:474516621]","[U:1:190285622]"]; // i forgot who i put on my list LOL
selene_nuts <- ["[U:1:253374491]","[U:1:172776231]"]; // dippy and eltra
banbanards <- ["[U:1:474516621]","[U:1:1020976181]"] // cool dude and mato
opilaheads <- ["[U:1:190285622]","[U:1:1119087201]"] // berke & venturedev
::MAPSTATE <- 0
Cutscene <- 1

function StageUp()
{
    if (MAPSTATE == 0)
    {
        MAPSTATE++
    }
    if (MAPSTATE == 1)
    {
        MAPSTATE--
    }
}

function StageSet()
{
    printl("HONEYMOON IS ALIVE AND BREATHING")
    if (MAPSTATE == 0)
    {
        QFire("fog_silent", "TurnOff", "", 0.0, null);
        QFire("relay_stage1", "Trigger", "", 0.00, null);
    }
    if (MAPSTATE == 1)
    {
        QFire("fog_silent", "SetColor", "193 193 193", 0.0, null);
        QFire("fog_silent", "SetStartDist", "-100", 0.0, null); // general preparations for fog transition into Deep sleep
        QFire("fog_silent", "SetEndDist", "1200", 0.0, null);
        QFire("fog_silent", "TurnOn", "", 0.00, null)
        QFire("sf_mato_terms", "Kill", "", 0.00, null);
        QFire("sf_mato_terms", "Volume", "0", 0.00, null);
        QFire("mus*", "Kill", "", 0.0, null);
        if (Cutscene == 0)
        {
            QFire("s_mus_s_intro", "FireUser1", "", 0.00, null);
            QFire("relay_stage2", "Trigger", "", 0.00, null);
            QFire("globals", "RunScriptCode", "SleepState()", 90.00, null)
        }
        if (Cutscene == 1)
        {
            QFire("relay_stage2", "Trigger", "", 0.00, null);
            QFire("s_mus_s_intro", "FireUser1", "", 60.00, null);
            QFire("sf_s_cutscene", "PlaySound", "", 0.00, null);
            QFire("globals", "RunScriptCode", "SleepState()", 60+90.00, null)
            // local uggtimer = Entities.FindByName(null, "round_timer")
            // QFireByHandle(uggtimer, "addtime", "44", 1, self, self);
            Cutscene = 0;
        }

    }
}

function OnPostSpawn()
{
    self.ValidateScriptScope()
    __CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);
}


function OnGameEvent_teamplay_round_win(params)
{
    printl("lalalallalala")
    QFire("mus_monkeys", "StopSound", "", 0.00, null);
}

function OnGameEvent_player_spawn(EventData)
{
    // printl("shitty")

    local a = GetPlayerFromUserID(EventData.userid)

	QFireByHandle(a, "setfogcontroller", ELTMAP.MapFog, 0.1, null, null);
    if(a!=null&&a.IsValid())
    {
        // if (MAPSTATE == 0) // not yet
        // {
        //     QFireByHandle(a, "SetFogController", "fog_banban", 0.00, null, null);
        // }
        // else if (MAPSTATE == 1)
        // {
        //     QFireByHandle(a, "SetFogController", "fog_silent", 0.00, null, null);
        // }

        // a.ValidateScriptScope()
        // DoEntFire("fog_math","GetValue","",0.00,a,null);
        QFireByHandle(a, "SetHudVisibility", "1", 0.00, null, null);
        SpawnFunc(a)
        // DoEntFire("ccmd","Command","r_screenoverlay off",0.00,a,null);
        a.SetScriptOverlayMaterial("")

        //blue team

        if(a.GetTeam()==3)
        {
            // QFireByHandle(a, "setfogcontroller", "fog_banban", 0.0, null, null); // REMOVE WITH SH UPDATE
            ScreenFade(a,35, 81, 133,255,2.00,0.1,1);
            // a.SetModelScale(0.75,0.00);

        }

        //red team

        if(a.GetTeam()==2)
        {
            // QFireByHandle(a, "setfogcontroller", "fog_banban", 1.0, null, null); // REMOVE WITH SH UPDATE
          // DoEntFire("fog_math","GetValue","",0.00,a,null);
            ScreenFade(a,133, 35, 35,255,2.00,0.1,1);
        }

        a.ViewPunch(QAngle(300, 300, 300));

        local eltrasnum = 0;


        foreach (PeterHead in PeterHeads)
        {
            if (a.GetPlayerClass() == 7)
                {
                local sel_index = 0
                foreach (selene_nut in selene_nuts)
                {
                    if (NetProps.GetPropString(a, "m_szNetworkIDString") == selene_nuts[sel_index])
                    {
                        PrecacheModel("models/eltra/selene_pyro.mdl")
                        a.SetCustomModelWithClassAnimations("models/eltra/selene_pyro.mdl")
                    }
                    sel_index++
                }
                local ban_index = 0
                foreach (banbanard in banbanards)
                {
                    if (NetProps.GetPropString(a, "m_szNetworkIDString") == banbanards[ban_index])
                    {
                        PrecacheModel("models/eltra/banban_pyro.mdl")
                        a.SetCustomModelWithClassAnimations("models/eltra/banban_pyro.mdl")
                    }
                    ban_index++
                }
                local op_index = 0
                foreach (opilahead in opilaheads)
                {
                    if (NetProps.GetPropString(a, "m_szNetworkIDString") == opilaheads[op_index])
                    {
                        PrecacheModel("models/eltra/opila_pyro.mdl")
                        a.SetCustomModelWithClassAnimations("models/eltra/opila_pyro.mdl")
                    }
                    op_index++
                }
                ClientPrint(a, 4, "|DEV| You are on the special list so you get a special skin :)")

				if (NetProps.GetPropString(a, "m_szNetworkIDString") == ELTRA_STEAMID) {
					a.KeyValueFromString("targetname","Eltra")
				}
            }
            eltrasnum++;
        }
    }
}

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
