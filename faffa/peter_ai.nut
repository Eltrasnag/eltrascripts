iDifficulty <- 0;
Location <- 0;
AttackMode <- false;
dTemp <- 0;

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
    CNPete = dTemp;
    QFire("CText1", "AddOutput", "message "+dTemp, 0.00, null);
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

function Think() {
	if (iDifficulty != 0) {
		CanMove();

	}
	return RandomInt(6,8)
}

function CanMove()
{
	print("meow")
    local compare = RandomInt(1, 20);
    //printl("PETER AT LOCATION "+Location)
    if (compare<=iDifficulty)
    {
		if (Location == 7 && RightOccupied || (Location == 7 && !retail && (RightOccupied || LeftOccupied))) {
			return
		}
		MoveCharacter();
        Aggressiveness++
        self.SetSequence(RandomInt(1, 5));
        EmitAmbientSoundOn("eltra/robo_walk.mp3", 10.00, 100, RandomInt(80, 110), self);
        QFire("pete_laugh_"+RandomInt(1, 3), "PlaySound", "", 0.00, null);
        if (AttackMode==true&&Location==8)
        {
            // self.SetSequence(6);
            if (RightClosed==false)
            {
                GlobalJumpscare(CHARACTERS.PETER);
                ItsOver = true;
            }
            if (RightClosed==true)
            {
                Location = 1;
                RightOccupied = false;
                AttackMode = false;
                MoveCharacter(); // NO IDEA WHY BUT THIS FIXES ANIMATRONICS BEING STUCK AT DOOR  this is a lie btw i do know why
				PlaySoundEX("eltra/fnaf_door_pound_violent.mp3", RightDoor.GetOrigin())

            }
        }
    }
}

function MoveCharacter()
{
    if (Location==0) // STAGE
    {
        self.SetOrigin(Vector(-112, 800, 32));
        Location++
    }
    else if (Location==1)
    {
        self.SetOrigin(Vector(512, -384, 0)) // BALL PIT ROOM
        self.SetAbsAngles(QAngle(0, 270, 0))
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
        self.SetOrigin(Vector(-192, -160, 0)); // DINING AREA 1
        self.SetAbsAngles(QAngle(0, 330, 0));
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
        self.SetOrigin(Vector(384, 0, 0)); // DINING 2
        self.SetAbsAngles(QAngle(0, 45, 0));
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
        self.SetOrigin(Vector(352, -928, 0)); // LEFT HALL FAR
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
    else if (Location==5)
    {
        self.SetOrigin(Vector(416, -1184, 0)); // RIGHT HALL NEAR
        self.SetAbsAngles(QAngle(0, 75, 0));
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
        self.SetOrigin(Vector(304, -2128, 0)); // RIGHT HALL CORNER
        self.SetAbsAngles(QAngle(0, 210, 0));
        if (RightOccupied==false)
        {
            Location++
        }

    }
    else if (Location==7)
    {
        self.SetOrigin(Vector(304, -1872, 0)); // RIGHT DOOR
        self.SetAbsAngles(QAngle(0, 270, 0));
        self.SetSequence(6)
        RightOccupied = true;
        Location++
        QFireByHandle(self, "SetAnimation", "door_right", 0.1, null, null);

    }
    else if (Location==8)
    {
        AttackMode = true;
        RightOccupied = true;
    }
}

// function Jumpscare()
// {
//     QFire("peter_jumpscare_trigger", "Enable", "", 0.1, null);
//     QFire("ambient_generic*", "StopSound", "", 0.00, null);
// }