iDifficulty <- 0;
Location <- 0;
AttackMode <- false;
dTemp <- 0;

function RunOut()
{
    if (iDifficulty<=20)
    {
        iDifficulty=20
    }
}
function OnPostSpawn() {
	AddThinkToEnt(self, "Think")
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
	return RandomInt(4,7)
}

function CanMove()
{
	if (!MAJOR_EVENT){
		local compare = RandomInt(1, 20);
		//printl("Maria AT LOCATION "+Location)
		if (compare<=iDifficulty)
		{
			// mAnger = 60; hack during test 1
			MoveCharacter();
			Aggressiveness++
			self.SetSequence(RandomInt(1, 5));
			if (Location == 7 && LeftOccupied || (Location == !retail && (RightOccupied || LeftOccupied))) {
				return
			}
			// EmitAmbientSoundOn("eltra/robo_walk.mp3", 10.00, 100, RandomInt(80, 110), self);
			PrecacheScriptSound("fnaf.walk");
			EmitSoundOn("fnaf.walk", self);
			if (AttackMode==true&&Location==8)
			{
				// QFireByHandle(self, "SetAnimation", "door_Left", 0.1, null, null);
				if (LeftClosed==false)
				{
					GlobalJumpscare(CHARACTERS.MARIA);
					ItsOver = true;
				}
				if (LeftClosed==true)
				{
					Location = 0;
					LeftOccupied = false;
					AttackMode = false;
					PlaySoundEX("eltra/fnaf_door_pound_violent.mp3", LeftDoor.GetOrigin())

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
        self.SetOrigin(Vector(944, 48, 0));
        self.SetAbsAngles(QAngle(0, 0, 0))
        Location++
    }
    else if (Location==1)
    {
        self.SetOrigin(Vector(816, 160, 0)) // BOX CORNER
        self.SetAbsAngles(QAngle(0, 315, 0))
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
        self.SetOrigin(Vector(608, 368, 0)); // DOOR
        self.SetAbsAngles(QAngle(0, 120, 0));
        Location++
    }
    else if (Location==3)
    {
        self.SetOrigin(Vector(80, -16, 0)); // DINING
        self.SetAbsAngles(QAngle(0, 64.5, 0));
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
        self.SetOrigin(Vector(-400, -912, 0)); // Left HALL FAR
        self.SetAbsAngles(QAngle(0, 184.5, 0));
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
        self.SetOrigin(Vector(-336, -1344, 0)); // Left HALL NEAR
        self.SetAbsAngles(QAngle(0, 184.5, 0));
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
        self.SetOrigin(Vector(-416, -2160, 0)); // Left HALL CORNER
        self.SetAbsAngles(QAngle(0, 289.5, 0));
        if (LeftOccupied==false)
        {
            Location++
        }
    }
    else if (Location==7)
    {
        self.SetOrigin(Vector(-304, -1872, 0)); // Left DOOR
        self.SetAbsAngles(QAngle(0, 270, 0));
        LeftOccupied = true;
        Location++
        QFireByHandle(self, "SetAnimation", "door", 0.1, null, null);
    }
    else if (Location==8)
    {
        AttackMode = true;
    }
}

// function Jumpscare()
// {
//     QFire("ambient_generic*", "StopSound", "", 0.00, null);
//     QFire("maria_jumpscare_trigger", "Enable", "", 0.1, null);
// }