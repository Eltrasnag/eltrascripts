iDifficulty <- 0;
Location <- 0;
AttackMode <- false;
dTemp <- 0;

function Increase()
{
    //printl("hello")
    if (dTemp<=19)
    {
        // //printl("INCREASING")
        dTemp++
        // //printl(dTemp)
    }
    CheckValid()
}
function OnPostSpawn() {
	AddThinkToEnt(self, "Think")
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
    CNLois = dTemp;
    QFire("CText2", "AddOutput", "message "+dTemp, 0.00, null);
}

function Reset()
{
    Location = 0;
    AttackMode = false;
    MoveCharacter();
}

function Think() {
	if (iDifficulty != 0) {
		CanMove();

	}
	return RandomInt(2,5)
}

function CanMove()
{
	if (!MAJOR_EVENT){
		local compare = RandomInt(1, 20);
		//printl("LOIS AT LOCATION "+Location)
		if (compare<=iDifficulty)
		{
				// mAnger = 60; hack during test 1
				MoveCharacter();
				Aggressiveness++
				self.SetSequence(RandomInt(1, 5));
				// EmitAmbientSoundOn("eltra/robo_walk.mp3", 10.00, 100, RandomInt(80, 110), self);
				PrecacheScriptSound("fnaf.walk");
				EmitSoundOn("fnaf.walk", self);
				if (Location == 7 && LeftOccupied || (Location == 7 && !retail && (RightOccupied || LeftOccupied))) {
					return
				}
				if (AttackMode==true&&Location==8)
				{
					// QFireByHandle(self, "SetAnimation", "door_left", 0.1, null, null);
					if (LeftClosed==false)
					{
						GlobalJumpscare(CHARACTERS.LOIS);
						ItsOver = true;
					}
					if (LeftClosed==true)
					{
						PlaySoundEX("eltra/fnaf_door_pound_violent.mp3", LeftDoor.GetOrigin())
						Location = 0;
						LeftOccupied = false;
						AttackMode = false;
						EmitAmbientSoundOn("eltra/fnaf_door_pound.mp3", 10.00, 100, RandomInt(80, 110), self);
						MoveCharacter(); // NO IDEA WHY BUT THIS FIXES ANIMATRONICS BEING STUCK AT DOOR
					}
				}
			}
	}
}

function MoveCharacter()
{
    if (Location==0) // STAGE
    {
        self.SetOrigin(Vector(0, 800, 32));
        Location++
    }
    else if (Location==1)
    {
        self.SetOrigin(Vector(-24, 208, 0)) // DINING AREA 1
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
        self.SetOrigin(Vector(-416, 0, 0)); // DINING AREA 2
        self.SetAbsAngles(QAngle(0, 330, 0));
        Location++
    }
    else if (Location==3)
    {
        self.SetOrigin(Vector(-1324, 580, 0)); // PARTS ROOM
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
    else if (Location==4)
    {
        self.SetOrigin(Vector(-368, -608, 0)); // LEFT HALL FAR
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
        self.SetOrigin(Vector(-1060, -1384, 0)); // LEFT HALL NEAR
        self.SetAbsAngles(QAngle(0, 240, 0));
        if (RandomInt(0, 20)==1)
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
        self.SetOrigin(Vector(-320, -2144, 0)); // LEFT HALL CORNER
        self.SetAbsAngles(QAngle(0, 165, 0));
        if (LeftOccupied==false)
        {
            Location++
        }
    }
    else if (Location==7)
    {
        self.SetOrigin(Vector(-288, -1632, 0)); // LEFT DOOR
        self.SetAbsAngles(QAngle(0, 60, 0));
        LeftOccupied = true;
        Location++
        QFireByHandle(self, "SetAnimation", "door_left", 0.1, null, null);
    }
    else if (Location==8)
    {
        AttackMode = true;
    }
}

// function Jumpscare()
// {
//     QFire("ambient_generic*", "StopSound", "", 0.00, null);
//     QFire("lois_jumpscare_trigger", "Enable", "", 0.1, null);
// }