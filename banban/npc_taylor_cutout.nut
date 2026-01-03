//printl("taylor spawned")
target <- null
players <- []
bluplayers <- []
suffix <- self.GetName().slice(self.GetName().len()-5,self.GetName().len())
//printl(suffix)
thruster <- Entities.FindByName(null, "tay_thruster"+suffix)
// thruster_up <- Entities.FindByName(null, "tay_thruster_keep_up"+suffix)
maxheight <- (self.GetOrigin().z)+100
retargettime <- 0
thrusttime <- 0
mustime <- 0
tay_visual_model <- Entities.FindByName(null, "tay_visual_model"+suffix)
tay_fakeparent <- Entities.FindByName(null, "tay_fakeparent"+suffix)
tay_Physbox <- self
tay_hurtbox  <- Entities.FindByName(null, "tay_hurtbox"+suffix)
tay_hurter  <- Entities.FindByName(null, "tay_hurt"+suffix)
tay_sf_aggression <- Entities.FindByName(null, "tay_sf_aggression"+suffix)
tay_sf_hurt <- Entities.FindByName(null, "tay_sf_hurt"+suffix)
tay_warntext <- Entities.FindByName(null, "tay_warning_text"+suffix)

tay_flyspeed <- 1000;
tay_curspeed <- 200
// tay_keepupright <- Entities.FindByName(null, "tay_keepupright"+suffix)
function FindDist(v1,v2)
{
    if (v1 && v2 != null)
    {
        return (sqrt((pow(v1.x-v2.x,2))+(pow(v1.y-v2.y,2))+(pow(v1.z-v2.z,2))));
    }
}

function FindAng(v1,v2)
{
    if (v1 && v2 != null)
    {
    local vangz = (v1.z-v2.z)
    local vangy = (v1.y-v2.y)
    local vangx = (v1.x-v2.x)
    return (QAngle(vangx,vangy,vangz))
    }
}
function OnPostSpawn()
{
	self.SetHealth(150)
	taylors++
    // QFireByHandle(self, "RunScriptCode", "SetUp()", 0.1, null, null)
    QFireByHandle(tay_hurtbox, "Break", "", 60.00, null, null);
	QFireByHandle(self,"DisableMotion")
}




function SetUp()
{
    if (taylors < 10)
    {
        // tay_keepupright.Kill()
        // QFireByHandle(tay_visual_model, "SetAnimation", "fly", 0.0, null,null);
        QFireByHandle(tay_sf_aggression, "PlaySound", "", 0.00, null,null);
        QFireByHandle(self, "EnableMotion", "", 0.00, null, null);
        QFireByHandle(tay_visual_model, "ClearParent", "", 0.00, null, null);
        // local pindex = 0
        // local maxplayers = MaxClients().tointeger()
        local pindex = 0
        local maxplayers = MaxClients().tointeger()

        for (local p1 = 1;p1 < maxplayers;p1++)
        {

            players.push(EntIndexToHScript(p1))
            //printl(players[pindex])
            pindex++
        }

        foreach (player in players)
        {
            if (player != null && player.GetTeam() == 3)
            {
                bluplayers.push(player)
            }
        }

        QFireByHandle(tay_sf_aggression, "PlaySound", "", 0.00, null,null);
        // tay_hurtbox.SetHealth(bluplayers.len()*2500)
        self.SetGravity(1.0)
        AddThinkToEnt(self, "MoveTicker")
        SetTarget()
        // AddThinkToEnt(self, "PickTarget")
    }


}

function SetTarget()
{
    target = null
    players.clear()
    bluplayers.clear()
    local pindex = 0
    local maxplayers = MaxClients().tointeger()
    for (local p1 = 1;p1 < maxplayers;p1++)
    {

        players.push(EntIndexToHScript(p1))
        //printl(players[pindex])
        pindex++
    }

    foreach (player in players)
    {
        if (player != null && player.IsValid() && player.GetTeam() == 3)
        {
            bluplayers.push(player)
        }
    }
    // local rl = RandomInt(0, bluplayers.len())

    local RT = bluplayers[RandomInt(0, bluplayers.len()-1)]
    if (RT.IsValid()&& RT != null)
    {
        target = RT
    }
}

// function SetTarget_B(rando)
// {
// }

function PickTarget()
{
    SetTarget()
    return 10.0
}


function MoveTicker()
{

	if (tay_flyspeed >= tay_curspeed ) {
		tay_curspeed += tay_curspeed * 0.02
	}
    if (target == null || !target.IsValid())
    {
        SetTarget()
    }


    else
    {
        if (target != null && target.IsValid())
        {
            if (NetProps.GetPropInt(target, "m_lifeState") == 0 && target.GetTeam()==3)
            {
                QFireByHandle(tay_warntext, "Display", "", 0.00, target, null);
                // //printl(NetProps.GetPropString(target, "m_szNetname"))

                local ba = target.GetOrigin();
                local aa = self.GetOrigin();
                local ldir = (aa - ba);

                ldir.Norm();
                tay_visual_model.SetForwardVector(ldir);
                tay_visual_model.KeyValueFromVector("origin", aa)


                if (mustime == 660)
                {
                    mustime = 0
                    QFireByHandle(tay_sf_aggression, "PlaySound", "", 0.00, null,null);
                }

					local vOrigin = self.GetOrigin()

                    QFireByHandle(thruster, "Activate", "", 0.01, null, null);
                    if (target != null)
                    {
                    local meee_x3 = self
                    local rDist = FindDist(target.GetOrigin(),vOrigin)
                    local rAng = FindAng(target.GetOrigin(),vOrigin)
                    local ba = target.GetOrigin();
                    local aa = vOrigin;
                    local ldir = (aa - ba);
                    ldir.Norm();

                    // local mypos = self.GetOrigin()


                    if (rDist <= 384) // what does any of this mean who is the idiot who didnt comment their code
                    {
                        // QFireByHandle(thruster, "AddOutput", "force "+(rDist*550)*-1000, 0.00, null, null)

                        // if (mypos.z+rDist*0.02 < maxheight)
                        // {
                        // self.SetAbsOrigin(Vector(mypos.x,mypos.y,mypos.z+rDist*0.05))
							// self.Set

                        // }
						vOrigin += self.GetAbsAngles().Forward() * -1 * (tay_curspeed * 0.02)
                    }
                    if (rDist >= 384)
                    {
                    self.SetForwardVector(ldir);

						local hi =vOrigin.z+rDist*0.05
                        // QFireByHandle(thruster, "AddOutput", "force "+(rDist*350)*-1000, 0.00, null, null)
                        if (hi < maxheight && hi > maxheight - 50)
                        {
                        	vOrigin.z += 1
                        }
						vOrigin += ldir * -1 * (tay_curspeed * 0.02)
						if (tay_curspeed >= 50) {

							tay_curspeed -= 60 * 0.02
						}
                    }
                    // QFireByHandle(thruster, "Deactivate", "", 0.00, null, null);

                    // thrusttime = 0
					local vAng = self.GetAbsAngles()
					local vNew = vOrigin
					vNew += vAng.Left() * cos(Time() * 3)*rDist * 0.001
					vNew += vAng.Up() * sin(Time()*5)*rDist * 0.001
					self.SetOrigin(vNew)
                    }
                if (target.GetTeam() != 3 || NetProps.GetPropInt(target, "m_lifeState") != 0)
                {
                    SetTarget()
                }
            }
        // else
        // {
        //     SetTarget()
        // }
    }
    thrusttime++
    mustime++
    //print(retargettime)
    }
    return 0.02

}

function VisualImpact(activator)
{

    tay_visual_model.KeyValueFromString("color","255 0 0")
    tay_visual_model.SetModelScale(RandomFloat(1.05, 1.2), 0)
    tay_visual_model.SetModelScale(1, 0.2)
    // tay_visual_model.SetAbsAngles(tay_visual_model.GetAbsAngles()*0.5)
    tay_sf_hurt.KeyValueFromInt("pitch", RandomInt(110, 190))
    QFireByHandle(tay_sf_hurt, "PlaySound", "", 0.01, null, null);
    // QFireByHandle(tay_sf_hurt, "pitch", "100", 0.5, null, null);
    QFireByHandle(tay_visual_model, "color", "255 255 255", 0.1, null, null);
    QFireByHandle(tay_visual_model, "color", "255 0 0", 0, null, null);
	TayKnockback(activator)
}

function TayKnockback(activator) {
	if (activator == target) {
		tay_curspeed = 200;

	}
}

function Death()
{
    self.SetPhysVelocity(Vector(RandomInt(-100, 100),RandomInt(-100, 100),RandomInt(-100, 100)))
    self.SetGravity(1.0)
    QFireByHandle(tay_visual_model, "SetParent", "!activator", 0.00, self, self)
    AddThinkToEnt(self, "")
    tay_fakeparent.Kill()
    // tay_hurtbox.Kill()
    tay_hurter.Kill()
    taylors--
    QFireByHandle(tay_sf_aggression, "Volume", "0", 0.0, null,null)
    tay_sf_hurt.KeyValueFromInt("pitch", 60)
    QFireByHandle(tay_sf_hurt, "PlaySound", "", 0.1, null, null);
    thruster.Kill()
    // thruster_up.Kill()
    tay_warntext.Kill()
    QFireByHandle(self, "KillHierarchy", "", 3.0, null, null)
    QFire("tay_sf_hurt"+suffix, "Kill", "", 3.0, null)
    QFire("tay_sf_aggression"+suffix, "Kill", "", 3.0, null)
    QFireByHandle(tay_visual_model,"RunScriptCode","self.SetModelScale(1.1,0.1)",2,null,null)
    QFireByHandle(tay_visual_model,"RunScriptCode","self.SetModelScale(0,0.95)",2.05,null,null)
    QFire("tay_keepupright"+suffix, "Kill", "", 0.00, null);
    QFire("tay_activator"+suffix, "Kill", "", 0.00, null);
}

function DoRealDamage(activator) {
	activator.TakeDamage(RandomInt(3,7),64, null)
	ScreenFade(activator,255,255,255,255,0.2,0.01, 1)
}