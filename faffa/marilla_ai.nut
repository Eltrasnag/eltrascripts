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
    QFire("vent_hurt", "Disable", "", 0.00, null);
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
		//printl("marilla AT LOCATION "+Location)
		if (compare<=iDifficulty)
		{
			// mAnger = 60; hack during test 1
			MoveCharacter();
			Aggressiveness++
			self.SetSequence(RandomInt(1, 5));
			if (Location == 7 && RightOccupied || (Location == !retail && (RightOccupied || LeftOccupied))) {
				return
			}
			// EmitAmbientSoundOn("eltra/robo_walk.mp3", 10.00, 100, RandomInt(80, 110), self);
			PrecacheScriptSound("fnaf.walk");
			EmitSoundOn("fnaf.walk", self);

			if (AttackMode==true&&Location==8)
			{
				// QFireByHandle(self, "SetAnimation", "door_Right", 0.1, null, null);
				if (RightClosed==false)
				{
					GlobalJumpscare(CHARACTERS.MARILLA);
					ItsOver = true;
				}
				if (RightClosed==true)
				{
					Location = 0;
					RightOccupied = false;
					AttackMode = false;
					PlaySoundEX("eltra/fnaf_door_pound_violent.mp3", RightDoor.GetOrigin())

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
        self.SetOrigin(Vector(-1836, -592, 0));
        self.SetAbsAngles(QAngle(0, 0, 0))
        Location++
    }
    else if (Location==1)
    {
        self.SetOrigin(Vector(-1244, 160, 0)) // PARTS SERVICE
        self.SetAbsAngles(QAngle(0, 330, 0))
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
        self.SetOrigin(Vector(768, -352, 0)); // DOOR TO PARTY ROOM
        self.SetAbsAngles(QAngle(0, 195, 0));
        Location++
    }
    else if (Location==3)
    {
        self.SetOrigin(Vector(1132, -740, 0)); // PARTY  ROOM
        self.SetAbsAngles(QAngle(0, 120, 0));
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
        self.SetOrigin(Vector(1532, -1524, 0)); // FRONT DESK
        self.SetAbsAngles(QAngle(0, 270, 0));
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
        self.SetOrigin(Vector(724, -1736, 0)); // Pre vent
        self.SetAbsAngles(QAngle(0, 120, 0));
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
        QFireByHandle(self, "SetAnimation", "vent", 0.1, null, null);
        QFire("sf_vent_"+RandomInt(1, 3), "PlaySound", "", 0.00, null);
        QFire("vent_gates", "Break", "", 0.00, null);
        QFire("vent_hurt", "Enable", "", 0.00, null);
        self.SetOrigin(Vector(580, -1776, 0)); // inside vent
        self.SetAbsAngles(QAngle(0, 90, 0));
        if (RightOccupied==false)
        {
            Location++
        }
    }
    else if (Location==7)
    {
        QFire("vent_hurt", "Disable", "", 0.00, null);
        self.SetOrigin(Vector(304, -1664, 0)); // Right DOOR
        self.SetAbsAngles(QAngle(0, 90, 0));
        RightOccupied = true;
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
//     QFire("marilla_jumpscare_trigger", "Enable", "", 0.1, null);
// }