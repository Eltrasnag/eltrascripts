::taylors <- 0
::SLEEPSTATE <- 0


function QuizCheer()
{
    PrecacheScriptSound("sf.cheer")
    EmitSoundOn("sf.cheer", activator)
    DispatchParticleEffect("bday_confetti", activator.GetOrigin(), Vector(activator.GetAbsAngles()))
}



//guys. ignore everything below because it isnt ready. wait for halloween.

function SetREM()
{
    printl("Switching to REM State")

    printl(SLEEPSTATE)
}


function SetDeepSleep()
{
    printl("Switching to Deep Sleep")

    printl(SLEEPSTATE)
}


function SleepState()
{

    local statelength = RandomInt(60, 200)
    printl(statelength)

    if (statelength <= 100)
    {
        printl("trying playing short track")
        SleepMusic(0,SLEEPSTATE)
    }
    if (statelength >= 101)
    {
        printl("trying playing long track")
        SleepMusic(1,SLEEPSTATE)
    }




    if (SLEEPSTATE == 0) // DAY / DAY STATE
    {
        SetDeepSleep()
        QFire("deep_music*", "FadeOut", "1", statelength-30.0, null); // Clean up stray music from REM state
        QFire("deep_music*", "Kill", "", statelength-29.0, null);
        QFire("fog_silent", "StartFogTransition", "", statelength-10.00, null); // Transitions fog when siren sound climax reached
        QFire("fog_silent", "SetColorLerpTo", "0 0 0", 10.0, null);
        QFire("fog_silent", "SetStartDistLerpTo", "-10000", 10.0, null); // general preparations for fog transition into REM state
        QFire("fog_silent", "SetEndDistLerpTo", "500", 10.0, null);
        // QFireByHandle(self, "RunScriptCode", "SLEEPSTATE = 1", statelength-1.0, null, null)
        QFire("deep_visual", "Disable", "", statelength-8.00, null);
        QFire("rem_visual", "Enable", "", statelength-8.00, null);

        SLEEPSTATE = 1
        printl(SLEEPSTATE+" FROM DEEP")
    }




    else if (SLEEPSTATE == 1) // REM / NIGHT STATE
    {
        QFire("rem_music*", "FadeOut", "1", statelength-30.0, null); // Clean up stray music from REM state
        QFire("rem_music*", "Kill", "", statelength-29.0, null);
        SetREM()
        printl(SLEEPSTATE+" FROM REM")
        // SLEEPSTATE == 0
        QFire("deep_music*", "FadeOut", "4", 0.00, null); // Clean up stray music from Day state
        QFire("deep_music*", "Kill", "", 4.00, null);
        QFire("fog_silent", "StartFogTransition", "", statelength-10.00, null); // Transitions fog when siren sound climax reached
        QFire("deep_visual", "Enable", "", statelength-8.00, null);
        QFire("rem_visual", "Disable", "", statelength-8.00, null);
        QFire("fog_silent", "SetColorLerpTo", "193 193 193", 10.0, null);
        QFire("fog_silent", "SetStartDistLerpTo", "-100", 10.0, null); // general preparations for fog transition into Day state
        QFire("fog_silent", "SetEndDistLerpTo", "1200", 10.0, null);
        // SLEEPSTATE--
        // if (statelength <= 100)
        // {
        //     SleepMusic(0)
        // }
        // if (statelength >= 101)
        // {
        //     SleepMusic(1)
        // }
        SLEEPSTATE = 0
        // QFireByHandle(self, "RunScriptCode", "SLEEPSTATE = 0", statelength-1.0, null, null)


    }

    QFireByHandle(self, "RunScriptCode", "SleepState()", statelength, null, null) // Set state again
    QFireByHandle(self, "RunScriptCode", "SleepSiren()", statelength-39.00, null, null) // Plays siren sound


}

function SleepMusic(muslength,mus_state)
{
    printl(mus_state)
    if (mus_state == 0) // DAY TRACKS
    {
        printl("playing from deep sleep tracks")
        if (muslength == 0) // Shortened tracks
        {
            local song = RandomInt(0, 2)

            if (song == 0)
            {
                local m = CreateSleepMusic("deep.music_1_short")
                QFireByHandle(m, "Kill", "", 120.00, null, null)
            }

            if (song == 1)
            {
                local m = CreateSleepMusic("deep.music_2_short")
                QFireByHandle(m, "Kill", "", 110.00, null, null)
            }


            if (song == 2)
            {
                local m = CreateSleepMusic("deep.music_3_short")
                QFireByHandle(m, "Kill", "", 165.00, null, null)
            }

        }

        else if (muslength == 1) // Longer tracks
        {
            local song = RandomInt(0, 2)

            if (song == 0)
            {
                local m = CreateSleepMusic("deep.music_1")
                QFireByHandle(m, "Kill", "", 196.00, null, null)
            }

            if (song == 1)
            {
                local m = CreateSleepMusic("deep.music_2")
                QFireByHandle(m, "Kill", "", 235.00, null, null)
            }


            if (song == 2)
            {
                local m = CreateSleepMusic("deep.music_3")
                QFireByHandle(m, "Kill", "", 197.00, null, null)
            }

        }
    }

    if (mus_state == 1) // REM TRACKS
    {
        printl("playing from REM tracks")
        if (muslength == 0) // Shortened tracks
        {
            local song = RandomInt(0, 2)

            if (song == 0)
            {
                local m = CreateSleepMusic("rem.music_1_short")
                QFireByHandle(m, "Kill", "", 120.00, null, null)
            }

            if (song == 1)
            {
                local m = CreateSleepMusic("rem.music_2_short")
                QFireByHandle(m, "Kill", "", 71.00, null, null)
            }


            if (song == 2)
            {
                local m = CreateSleepMusic("rem.music_3_short")
                QFireByHandle(m, "Kill", "", 151.00, null, null)
            }

        }

        else if (muslength == 1) // Longer tracks
        {
            local song = RandomInt(0, 2)

            if (song == 0)
            {
                local m = CreateSleepMusic("rem.music_1")
                QFireByHandle(m, "Kill", "", 224.00, null, null)
            }

            if (song == 1)
            {
                local m = CreateSleepMusic("rem.music_2")
                QFireByHandle(m, "Kill", "", 197.00, null, null)
            }


            if (song == 2)
            {
                local m = CreateSleepMusic("rem.music_3")
                QFireByHandle(m, "Kill", "", 214.00, null, null)
            }

        }
    }

}

function CreateSleepMusic(path)
{
    PrecacheScriptSound(path.tostring())
    printl(path.tostring())
    printl("CraeteSleepMusic reacehd")
    local ent = SpawnEntityFromTable("ambient_generic", {
        targetname = " "
        health = "10"
        spawnflags = "17"
        message = path.tostring()
    })
    if (SLEEPSTATE == 1)
    {
        ent.KeyValueFromString("targetname", "rem_music")



        printl("we should be playing music now")
    }
    if (SLEEPSTATE == 0)
    {
        ent.KeyValueFromString("targetname", "deep_music")

        // QFireByHandle(ent, "PlaySound", "", 0.01, null, null);

        printl("we should be playing music now")
    }
    QFireByHandle(ent, "PlaySound", "", 0.00, null, null);
    printl(ent)
    // return EntIndexToHScript(ent)ent
}

function SleepSiren()
{
    local ent = SpawnEntityFromTable("ambient_generic", {
        targetname = "sirensound"
        health = "10"
        spawnflags = "49"
        message = "rem.siren"
})
    QFireByHandle(ent, "PlaySound", "", 0.01, null, null);
    QFireByHandle(ent, "Kill", "", 1, null, null);
}