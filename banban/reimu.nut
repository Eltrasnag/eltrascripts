// //printl("THIS IS THE NEW VERSION")
// //printl("THIS IS THE NEW VERSION")
// //printl("THIS IS THE NEW VERSION")
// //printl("THIS IS THE NEW VERSION")
// //printl("THIS IS THE NEW VERSION")
// //printl("THIS IS THE NEW VERSION")
// //printl("THIS IS THE NEW VERSION")
target <- null
players <- []
bluplayers <- []
thruster <- Entities.FindByName(null, "reimu_thruster")
thruster_up <- Entities.FindByName(null, "reimu_thruster_keep_up")
maxheight <- (self.GetOrigin().z)+300
retargettime <- 0
thrusttime <- 0
lasertime <- 0
reimu_visual_model <- Entities.FindByName(null, "reimu_visual_model")
reimu_fakeparent <- Entities.FindByName(null, "reimu_fakeparent")
Reimu_Physbox <- self
reimu_hurtbox  <- Entities.FindByName(null, "reimu_hurtbox")
laser_template <- Entities.FindByName(null, "em_reimu_skylaser")
bomb_template <- Entities.FindByName(null, "em_reimu_skybomb")
laserattack <- false;
bombattack <- false;
taylor_notify <- SpawnEntityFromTable("training_annotation", {
	display_text = "taylor swft alert",

	lifetime = 2
})

iHealthAdd <- 119
hits_since_last_tp <- 0
max_hits_before_tp <- 100
hptext <- Entities.FindByName(null,"boss_text");
ttext <- Entities.FindByName(null,"boss_text_target");
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

function SetUp()
{
    QFire("reimu_visual_model", "SetAnimation", "fly", 0.0, null);
    QFire("mus_reimu", "PlaySound", "", 0.00, null);
    QFireByHandle(self, "EnableMotion", "", 0.00, null, null);
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

    reimu_hurtbox.SetHealth(bluplayers.len()*iHealthAdd)
    self.SetGravity(0.0)
    AddThinkToEnt(self, "MoveTicker")

    // AddThinkToEnt(self, "PickTarget")
    SetTarget()
    // AddThinkToEnt(reimu_visual_model, "VisualSync(Reimu_Physbox,target)")
}

function SetTarget()
{
	target = RandomCT()
    // target = null
    // players.clear()
    // bluplayers.clear()
    // local pindex = 0
    // local maxplayers = MaxClients().tointeger()
    // for (local p1 = 1;p1 < maxplayers;p1++)
    // {

    //     players.push(EntIndexToHScript(p1))
    //     //printl(players[pindex])
    //     pindex++
    // }

    // foreach (player in players)
    // {
    //     if (player != null && player.IsValid() && player.GetTeam() == 3)
    //     {
    //         bluplayers.push(player)
    //     }
    // }
    // // local rl = RandomInt(0, bluplayers.len())

    // local RT = bluplayers[RandomInt(0, bluplayers.len()-1)]
    // if (RT.IsValid()&& RT != null)
    // {
    //     target = RT
    // }
}

function OnPostSpawn() {
	taylor_notify.SetAbsOrigin(self.GetOrigin())
	SetParentEX(taylor_notify, self)
}
function MoveTicker()
{
	VisualSync()
    if (target == null || !target.IsValid())
    {
        SetTarget()
        retargettime = 0
    }
    else
    {
        if (target != null && target.IsValid())
        {
			local vOrigin = self.GetOrigin()
			local vAngle = self.GetAbsAngles()
			local time = Time()
			self.KeyValueFromVector("origin", vOrigin + (vAngle.Forward() * (-350 * 0.02)) + Vector(sin(time * 2) * 10, cos(time * 4) * 10,0))

			if (NetProps.GetPropInt(target, "m_lifeState") == 0 || target.GetTeam()==3)
            {
				// modern eltra movement backport
				local vTargetAngle = GetLookVector(self, target)
				self.SetForwardVector(vTargetAngle)
				if(target!=null&&target.IsPlayer())
				{
					local tname = NetProps.GetPropString(target, "m_szNetname");
					ttext.KeyValueFromString("message", "-= TARGETTING - "+tname+" = -")
					ttext.AcceptInput("Display","",null,null)

				}
				if(hptext != null && hptext.IsValid())
				{
					try {

						hptext.KeyValueFromString("message", "-=TAYLOR SWIFT - "+reimu_hurtbox.GetHealth()+" HP=-")
						hptext.AcceptInput("Display","",null,null)
					} catch (exception){
						printl("whatever this bitch taylor dont work anyway")
					}
				}
                // //printl(NetProps.GetPropString(target, "m_szNetname"))
                // local ba = target.GetOrigin(); // the year was 1998 ass code
                // local aa = self.GetOrigin();
                // local ldir = (aa - ba);
                // ldir.Norm();
                // reimu_visual_model.SetForwardVector(ldir);
                // reimu_visual_model.KeyValueFromVector("origin", aa)
                ////printl (lalala)



                if (lasertime >= 10)
                {
                    if (laserattack == true)
                    {
                        laser_template.SpawnEntityAtEntityOrigin(target)
                    }
                    if (bombattack == true)
                    {
                        bomb_template.SpawnEntityAtEntityOrigin(reimu_fakeparent)
                    }
                    // if
                    lasertime = 0
                }
                if (retargettime >= 500)
                {
                    SetTarget()
                    retargettime = 0
                }
                if (retargettime == 300)
                {
                    AttackChooser()

                }


                // if (thrusttime == 1)
                // {
                //     QFireByHandle(thruster, "Activate", "", 0.01, null, null);
                //     if (target != null)
                //     {
                //     local meee_x3 = self

                //     local rDist = FindDist(target.GetOrigin(),self.GetOrigin())
                //     local rAng = FindAng(target.GetOrigin(),self.GetOrigin())

                //     local ba = target.GetOrigin();
                //     local aa = self.GetOrigin();

                //     local ldir = (aa - ba);
                //     ldir.Norm();
                //     self.SetForwardVector(ldir);
                //     // reimu_visual_model.SetForwardVector(ldir);
                //     // reimu_visual_model.SetOrigin(ldir);
                //     QFireByHandle(thruster_up, "AddOutput", "force "+50000, 0.00, null, null)
                //     // //printl(rAng)
                //     local mypos = self.GetOrigin()

                //     if (rDist <= 384)
                //     {
                //         QFireByHandle(thruster, "AddOutput", "force "+(rDist*500)*-1000, 0.00, null, null)
                //         if (mypos.z+rDist*0.02 < maxheight)
                //         {
                //         //self.SetOrigin(Vector(mypos.x,mypos.y,mypos.z+rDist*0.05))
                //         }
                //     }
                //     else if (rDist >= 384)
                //     {
                //         QFireByHandle(thruster, "AddOutput", "force "+(rDist*100)*-3000, 0.00, null, null)
                //         if (mypos.z+rDist*0.05 < maxheight)
                //         {
                //         self.SetOrigin(Vector(mypos.x,mypos.y,mypos.z+rDist*0.02))
                //         }

                //     }


                //     QFireByHandle(thruster, "Deactivate", "", 0.00, null, null);
                //     QFireByHandle(thruster_up, "Activate", "", 0.00, null, null);
                //     QFireByHandle(thruster_up, "Deactivate", "", 0.0, null, null);
                //     //QFireByHandle(thruster, "Deactivate", "", 0.01, null, null);
                //     }
                //     thrusttime = 0
                // }

            }
            if (target.GetTeam() != 3 || NetProps.GetPropInt(target, "m_lifeState") != 0)
            {
                SetTarget()
            }

        }
        else
        {
            SetTarget()
        }
    }
    lasertime++
    retargettime++
    thrusttime++
    //print(retargettime)

    return 0.02

}

function AttackChooser()
{
    local attack = RandomInt(1, 3)
    switch (attack) {
        case 1:
            QFireByHandle(self, "RunScriptCode", "laserattack = true", 0.00, null, null)
            QFireByHandle(self, "RunScriptCode", "laserattack = false", 7.00, null, null)
            print("attack 1")
            break;
        case 2:
            print("attack 2")
            QFireByHandle(self, "RunScriptCode", "bombattack = true", 0.00, null, null)
            QFireByHandle(self, "RunScriptCode", "bombattack = false", 7.00, null, null)
            break;
        case 3:
            print("attack 3")
            break;
        case 4:
            print("attack 4")
            break;
        case 5:
            print("attack 5")
            break;
    }
}

function VisualSync()
{
    if (target != null)
    {
    local ldir = GetLookVector(self,target)
    reimu_visual_model.SetForwardVector(ldir);
    reimu_visual_model.KeyValueFromVector("origin", self.GetOrigin() - Vector(0,0,128));
    //printl (lalala)
    return 0.01
    }
}



function VisualImpact(activator)
{

	hits_since_last_tp++
    reimu_visual_model.KeyValueFromString("color","255 0 0")
    reimu_visual_model.SetModelScale(RandomFloat(1.05, 1.2), 0)
    reimu_visual_model.SetModelScale(1, 0.2)
    // tay_visual_model.SetAbsAngles(tay_visual_model.GetAbsAngles()*0.5)
    // tay_sf_hurt.KeyValueFromInt("pitch", RandomInt(110, 190))
    // QFireByHandle(tay_sf_hurt, "PlaySound", "", 0.01, null, null);
    // QFireByHandle(tay_sf_hurt, "pitch", "100", 0.5, null, null);
    QFireByHandle(reimu_visual_model, "color", "255 255 255", 0.1, null, null);
    QFireByHandle(reimu_visual_model, "color", "255 0 0", 0, null, null);

	if (hits_since_last_tp >= max_hits_before_tp) {
		if (activator == target) {
			self.SetAbsOrigin(self.GetOrigin()+Vector(RandomInt(-1024,1024),RandomInt(-1024,1024),RandomInt(512,1024)))
			taylor_notify.AcceptInput("Show","",null,null)
		}
		hits_since_last_tp = 0
	}

}

function BossBar()
{
    // local bosshpint = self.GetHealth();

}