::PissPower <- 0;
Location <- 0;
AttackMode <- false;
dTemp <- 0;

function OnPostSpawn() {
	AddThinkToEnt(self, "Think")
}

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
	if (PissPower != 0) {
		CanMove();

	}
	return RandomInt(2,5)
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
    CNPiss = dTemp;
    QFire("CText3", "AddOutput", "message "+dTemp, 0.00, null);
}

function Reset()
{
    Location = 0;
    AttackMode = false;
    MoveCharacter();
}

function CanMove()
{
    local compare = RandomInt(1, 20);
    //printl("PISSBEAR AT LOCATION "+Location)
    if (compare<=PissPower)
    {
        MoveCharacter();
        Aggressiveness++
        self.SetSequence(RandomInt(1, 4));
        EmitAmbientSoundOn("eltra/robo_walk.mp3", 10.00, 100, RandomInt(80, 110), self);
        QFire("bear_laugh_"+RandomInt(1, 3), "PlaySound", "", 0.00, null);
        if (AttackMode==true&&Location==8)
        {

            if (RightClosed==false)
            {
                GlobalJumpscare(CHARACTERS.PISSBEAR);
                ItsOver = true;
            }
            if (RightClosed==true)
            {
                Location = 1;
                RightOccupied = false;
                AttackMode = false;
                EmitAmbientSoundOn("eltra/fnaf_door_pound.mp3", 10.00, 100, RandomInt(80, 110), self);
                MoveCharacter();// NO IDEA WHY BUT THIS FIXES ANIMATRONICS BEING STUCK AT DOOR
            }
        }
    }
}

function MoveCharacter()
{
    if (Location==0) // KITCHEN
    {
        self.SetOrigin(Vector(0, 1152, 32));
        Location++
    }
    else if (Location==1)
    {
        self.SetOrigin(Vector(-1520, 800, 0)) // PARTS 1
        self.SetAbsAngles(QAngle(0, 90, 0))
        Location++ // Doesnt make sense to go back to kitchen after enabled by bachelorette
        // if (RandomInt(0, 8)==1)
        // {
        //     Location--
        // }
        // else
        // {
        //     Location++
        // }
    }
    else if (Location==2)
    {
        self.SetOrigin(Vector(-368, 256, 0)); // DINING AREA 1
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
    else if (Location==3)
    {
        self.SetOrigin(Vector(-448, -144, 0)); // DINING AREA 2
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
        self.SetOrigin(Vector(320, -784, 0)); // RIGHT HALL FAR
        self.SetAbsAngles(QAngle(0, 0, 0));
        if (RandomInt(0, 8)==1)
        {
            Location--
        }
        else
        {
            Location++
        }
    }
    else if (Location==5)
    {
        self.SetOrigin(Vector(336, -1312, 0)); // RIGHT HALL NEAR
        self.SetAbsAngles(QAngle(0, 323.5, 0));
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
        self.SetOrigin(Vector(432, -2128, 0)); // RIGHT HALL CORNER
        self.SetAbsAngles(QAngle(0, 165, 0));
        if (RightOccupied==false)
        {
            Location++
        }
    }
    else if (Location==7)
    {
        self.SetOrigin(Vector(304, -1872, 0)); // RIGHT DOOR
        self.SetAbsAngles(QAngle(0, 270, 0));
        RightOccupied = true;
        QFireByHandle(self, "SetAnimation", "pos_5", 0.1, null, null);
        Location++
    }
    else if (Location==8)
    {
        AttackMode = true;
        RightOccupied = true;
    }
}

// function Jumpscare()
// {
//     QFire("ambient_generic*", "StopSound", "", 0.0, null);
//     QFire("freddy_jumpscare_trigger", "Enable", "", 0.1, null);
// }