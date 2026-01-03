::mAnger <- 0;
State <- 0;
AttackMode <- false;
dTemp <- 0;
meg <- Entities.FindByName(null, "meg_model_cams");
meg_mover <- Entities.FindByName(null, "meg_mover");
curtain <- Entities.FindByName(null, "curtains_model");

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
    CNMeg = dTemp;
    QFire("CText5", "AddOutput", "message "+dTemp, 0.00, null);
}

function Reset()
{
    State = 0;
    MAnger = 0;
    AttackMode = false;
    MoveCharacter();
}

function CanMove()
{
	if (!MAJOR_EVENT){


		local compare = (RandomInt(1, 80));
		//printl("MEG STATE "+State)
		if (compare<=mAnger)
		{

			if (State<=3)
			{
				State++
			}
			if (State==4&&LeftOccupied==false&&Power>=15&&AttackMode==true)
			{
				// QFire("meg_attackrelay", "Trigger", "", RandomFloat(5.00, 10.00), null);
				local come = RandomFloat(5.00, 10.00);
				QFire("meg_mover", "Open", "", come, null);
				QFire("o_megdoor_a", "Open", "", come+3, null);
				QFire("sf_meg_run", "PlaySound", "", come, null);
				QFireByHandle(self, "SetAnimation", "run", come, null, null);
				State = 0;
				// State=0;
				AttackMode=false;
				// QFire(string target, string action, string value = null, float delay = 0, handle activator = null)

				// QFire(string target, string action, string value = null, float delay = 0, handle activator = null)
			}
			MoveCharacter();
		}
}
}

function MoveCharacter()
{
    if (State==0)
    {
        meg.SetSequence(0)
        curtain.SetSequence(0)
    }
    if (State==1)
    {
        meg.SetSequence(0)
        curtain.SetSequence(1)
    }
    if (State==2)
    {
        meg.SetSequence(1)
        curtain.SetSequence(1)
    }
    if (State==3)
    {
        meg.SetSequence(2)
        curtain.SetSequence(2)
    }
    if (State==4)
    {
        meg.SetSequence(2)
        curtain.SetSequence(2)
        AttackMode=true;
    }
}

function CanKill()
{
    if (LeftClosed==false)
    {
        ItsOver=true;
		GlobalJumpscare(CHARACTERS.MEG)
        // QFire("meg_jumpscare_trigger", "Enable", "", 0.10, null);
        // QFire("ambient_generic*", "StopSound", "", 0.00, null);
    }
    if (LeftClosed==true)
    {
        // QFire("", string action, string value = null, float delay = 0, handle activator = null)
        State=0;
        MoveCharacter();
        QFire("sf_pounding_violent", "PlaySound", "", 0.00, null);
        QFire("fade_quickblack", "PlaySound", "", 0.00, null);
        QFire("o_megdoor_a","Close","",0.00,null);
        LeftOccupied=false;

    }
}