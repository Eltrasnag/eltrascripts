iDifficulty <- 0;
Location <- 0;
AttackMode <- false;
dTemp <- 0;
::BacheloretteEnabled <- true

function Increase()
{
    // //printl("hello")
    if (dTemp<=19)
    {
        // //printl("INCREASING")
        dTemp++
        // //printl(dTemp)
    }
    CheckValid()
}

function Think() {
	if (iDifficulty != 0 && BacheloretteEnabled) {
		CanMove();

	}
	return RandomInt(4,7)
}

function Decrease()
{
    if (dTemp>=1)
    {
        // //printl("DECREASE")
        dTemp--
        // CheckValid()
        // //printl(dTemp)
    }
    CheckValid()
}

function CheckValid()
{
    CNBach = dTemp;
    QFire("CText4", "AddOutput", "message "+dTemp, 0.00, null);
}

function Reset()
{
    Location = 0;
    AttackMode = false;
    MoveCharacter();
}
function OnPostSpawn() {
	AddThinkToEnt(self, "Think")
}

function CanMove()
{
    local compare = RandomInt(1, 20);
    //printl("BACHELORETTE AT LOCATION "+Location)
    if (Location>=4)
    {
        self.SetModelScale(0.78, 0.1);
    }
    else if (Location<=5)
    {
        self.SetModelScale(1, 0.1)
    }
    if (compare<=iDifficulty)
    {
        MoveCharacter();
        Aggressiveness++
        self.SetSequence(RandomInt(1, 4));
        PrecacheScriptSound("fnaf.bachelorette_walk");
        // EmitAmbientSoundOn("eltra/bachelorette_steps.mp3", 10.00, 100, RandomInt(80, 110), self);
        EmitSoundOn("fnaf.bachelorette_walk", self)
        if ((RandomInt(1, 3)==RandomInt(1, 3))&&Location!=6) // bachelorette singing streamlined
        {
            PrecacheScriptSound("fnaf.bachelorette_talk");
            EmitSoundOn("fnaf.bachelorette_talk", self)
        }
        if (AttackMode==true&&Location==8)
        {
            // self.SetSequence(6);
            if (LeftClosed==false)
            {
                // QFire("bachelorette_events", "PickRandom", "", 0.00, null);
				Music *= 0.5
				PissPower *= 2
				mAnger*2
                // QFire("animatronic_move_timer_bachelorette","Disable","",0.00,null);
                iDifficulty++;
                Location = 1;
                LeftOccupied = false;
                AttackMode = false;
                MoveCharacter();
            }
            if (LeftClosed==true)
            {
                Location = 1;
                LeftOccupied = false;
                AttackMode = false;
                MoveCharacter(); // NO IDEA WHY BUT THIS FIXES ANIMATRONICS BEING STUCK AT DOOR
            }
        }
    }
}

function MoveCharacter()
{
    if (Location==0) // STAGE
    {
        self.SetOrigin(Vector(2312, 528, 372-38)); //hack cause idgafd to do math
        self.SetAbsAngles(QAngle(0, 270, 0))
        Location++
    }
    else if (Location==1)
    {
        self.SetOrigin(Vector(1168, 512, 0)) // BALLS PIT 1
        self.SetAbsAngles(QAngle(0, 285, 0))
        if (RandomInt(0, 8)==1)
        {
            Location--
        }
        else
        {
            Location++
        }
    }
    else if (Location==2)
    {
        self.SetOrigin(Vector(464, 560, 0)); // DINING AREA 1
        self.SetAbsAngles(QAngle(0, 315, 0));
        if (RandomInt(0, 8)==1)
        {
            Location--
        }
        else
        {
            Location++
        }
    }
    else if (Location==3)
    {
        self.SetOrigin(Vector(-576, 64, 0)); // DINING AREA 2
        self.SetAbsAngles(QAngle(0, 345, 0));

        if (RandomInt(0, 8)==1)
        {
            Location--
        }
        else
        {
            Location++
        }
    }
    else if (Location==4)
    {
        self.SetOrigin(Vector(-368, -608, 0)); // KITCHEN
        QFire("sf_bachelorette_door", "PlaySound", "", 0.00, null);
        QFire("kitchen_door", "Disable", "", 0.00, null);
        QFire("kitchen_door_open", "Enable", "", 0.00, null);
        self.SetAbsAngles(QAngle(0, 0, 0));
        if (PissPower<=8)
        {
            PissPower++;
        }
        Location++

    }
    else if (Location==5)
    {
        QFire("kitchen_door", "Enable", "", 0.00, null);
        QFire("kitchen_door_open", "Disable", "", 0.00, null);
        QFire("sf_bachelorette_door", "PlaySound", "", 0.00, null);
        self.SetOrigin(Vector(-1472, 60, 0)); // LEFT HALL ENTRANCE
        self.SetAbsAngles(QAngle(0, 150, 0));
        if (RandomInt(0, 8)==1)
        {
            Location--
        }
        else
        {
            Location++
        }
    }
    else if (Location==6)
    {
        self.SetOrigin(Vector(-960, -1408, 0)); // LEFT HALL CLOSET
        self.SetAbsAngles(QAngle(0, 30, 0));
        if (LeftOccupied!=true)
        {
            Location++
        }
    }
    else if (Location==7)
    {
        self.SetOrigin(Vector(-296, -1872, 0)); // LEFT DOOR
        self.SetAbsAngles(QAngle(0, 90, 0));
        LeftOccupied = true;
        EmitAmbientSoundOn("eltra/bachelorette_hall.mp3", 100.00, 100, 100, self);
        Location++
    }
    else if (Location==8)
    {
        AttackMode = true;
    }
}