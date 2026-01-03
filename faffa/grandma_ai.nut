iDifficulty <- 0;
Location <- 0;
AttackMode <- false;
Route <- 0
function Reset()
{
    Location = 0;
    AttackMode = false;
}

function CanMove()
{
    local compare = RandomInt(1, 20);
    printl("GRANDMA AT LOCATION "+Location+" ROUTE "+Route)
    if (Location<=5)
    {
        Route = RandomInt(0, 2); // force grandma to continue her path if near enough to office
    }
    if (compare<=iDifficulty)
    {
        MoveCharacter();
        Aggressiveness++
        self.SetSequence(RandomInt(1, 5));
        EmitAmbientSoundOn("eltra/robo_walk.mp3", 10.00, 100, RandomInt(80, 110), self);
        QFire("sf_granline_"+RandomInt(1, 5), "PlaySound", "", 0.00, null);
        if (Location<<7)
        {
            QFireByHandle(self, "SetAnimation", "Lineidle0"+RandomInt(1, 3), 0.00, null, null);
        }
        if (AttackMode==true&&Location==8)
        {
            // QFireByHandle(self, "SetAnimation", "door_left", 0.1, null, null);
            if (LeftClosed==false&&Route==0)
            {
                GlobalJumpscare(CHARACTERS.GRANDMA);
                ItsOver = true;
            }
            if (LeftClosed==true&&Route==0)
            {
                Location = 1;
                RightOccupied = false;
                LeftOccupied = false;
                AttackMode = false;
                QFire("sf_pounding_violent", "PlaySound", "", 0.00, null);
                MoveCharacter(); // NO IDEA WHY BUT THIS FIXES ANIMATRONICS BEING STUCK AT DOOR
            }
            if (RightClosed==false&&Route>=1)
            {
                GlobalJumpscare(CHARACTERS.GRANDMA);
                ItsOver = true;
            }
            if (RightClosed==true&&Route>=1)
            {
                Location = 1;
                RightOccupied = false;
                LeftOccupied = false;
                AttackMode = false;
                QFire("sf_pounding_violent", "PlaySound", "", 0.00, null);
                MoveCharacter(); // NO IDEA WHY BUT THIS FIXES ANIMATRONICS BEING STUCK AT DOOR
            }
        }
    }
}

function OnPostSpawn() {
	AddThinkToEnt(self, "Think")
}

function Think() {
	if (iDifficulty != 0) {
		CanMove();

	}
	return 2
}

function MoveCharacter()
{
    if (Location==0) // STAGE
    {
        self.SetOrigin(Vector(0, 1152, 32)); // lois route
        Location++
    }
    else if (Location==1)
    {
        if (Route==0)
        {
            self.SetOrigin(Vector(-24, 208, 0)) // DINING AREA 1
            self.SetAbsAngles(QAngle(0, 180-90, 0)) // For lois
        }
        else if (Route==1)
        {
            self.SetOrigin(Vector(-192, -160, 0)); // DINING AREA 1
            self.SetAbsAngles(QAngle(0, 330-90, 0)); // peter
        }
        else if (Route==2)
        {
            self.SetOrigin(Vector(-368, 256, 0)); // DINING AREA 1
            self.SetAbsAngles(QAngle(0, 345-90, 0)); // pee bear
        }
        Location++
    }
    else if (Location==2)
    {
        if (Route==0)
        {
            self.SetOrigin(Vector(-416, 0, 0)); // DINING AREA 2
            self.SetAbsAngles(QAngle(0, 330-90, 0));
        }
        else if (Route==1)
        {
            self.SetOrigin(Vector(384, 0, 0)); // DINING 2
            self.SetAbsAngles(QAngle(0, 45-90, 0));
        }
        else if (Route==2)
        {
            self.SetOrigin(Vector(-448, -144, 0)); // DINING AREA 2
            self.SetAbsAngles(QAngle(0, 345-90, 0));
        }
        Location++
    }
    else if (Location==3)
    {
        if (Route==0)
        {
            self.SetOrigin(Vector(-416, 0, 0)); // DINING AREA 2
            self.SetAbsAngles(QAngle(0, 330-90, 0));
        }
        else if (Route==1)
        {
            self.SetOrigin(Vector(384, 0, 0)); // DINING 2
            self.SetAbsAngles(QAngle(0, 45-90, 0));
        }
        else if (Route==2)
        {
            self.SetOrigin(Vector(-448, -144, 0)); // DINING AREA 2
            self.SetAbsAngles(QAngle(0, 345-90, 0));
        }
        Location++
    }
    else if (Location==4)
    {
        if (Route==0)
        {
            self.SetOrigin(Vector(-368, -608, 0)); // LEFT HALL FAR
            self.SetAbsAngles(QAngle(0, 0-90, 0));
        }
        else if (Route==1)
        {
            self.SetOrigin(Vector(352, -928, 0)); // LEFT HALL FAR
            self.SetAbsAngles(QAngle(0, 345-90, 0));
        }
        else if (Route==2)
        {
            self.SetOrigin(Vector(320, -784, 0)); // RIGHT HALL FAR
            self.SetAbsAngles(QAngle(0, 0-90, 0));
        }
        Location++
    }
    else if (Location==5)
    {
        if (Route==0)
        {
            self.SetOrigin(Vector(-1060, -1384, 0)); // LEFT HALL NEAR
            self.SetAbsAngles(QAngle(0, 240-90, 0));
        }
        else if (Route==1)
        {
            self.SetOrigin(Vector(416, -1184, 0)); // RIGHT HALL NEAR
            self.SetAbsAngles(QAngle(0, 75-90, 0));
        }
        else if (Route==2)
        {
            self.SetOrigin(Vector(336, -1312, 0)); // RIGHT HALL NEAR
            self.SetAbsAngles(QAngle(0, 323.5-90, 0));
        }
        Location++
    }
    else if (Location==6)
    {
        if (Route==0)
        {
            self.SetOrigin(Vector(-320, -2144, 0)); // LEFT HALL CORNER
            self.SetAbsAngles(QAngle(0, 165-90, 0));
        }
        else if (Route==1)
        {
            self.SetOrigin(Vector(304, -2128, 0)); // RIGHT HALL CORNER
            self.SetAbsAngles(QAngle(0, 210-90, 0));
        }
        else if (Route==2)
        {
            self.SetOrigin(Vector(432, -2128, 0)); // RIGHT HALL CORNER
            self.SetAbsAngles(QAngle(0, 165-90, 0));
        }
        if (LeftOccupied==false&&RightOccupied==false)
        {
            Location++
        }
    }
    else if (Location==7)
    {
        if (Route==0)
        {
            self.SetOrigin(Vector(-288, -1632, 0)); // LEFT DOOR
            self.SetAbsAngles(QAngle(0, 60-90, 0));
        }
        else if (Route==1)
        {
            self.SetOrigin(Vector(304, -1872, 0)); // RIGHT DOOR
            self.SetAbsAngles(QAngle(0, 270-90, 0));
        }
        else if (Route==2)
        {
            self.SetOrigin(Vector(304, -1872, 0)); // RIGHT DOOR
            self.SetAbsAngles(QAngle(0, 270-90, 0));
        }
        LeftOccupied = true;
        RightOccupied = true;
        Location++
        QFireByHandle(self, "SetAnimation", "deathpose_left", 0.1, null, null);
    }
    else if (Location==8)
    {
        AttackMode = true;
    }
}

// function Jumpscare()
// {
//     QFire("ambient_generic*", "StopSound", "", 0.00, null);
//     QFire("grandma_jumpscare_trigger", "Enable", "", 0.1, null);
// }