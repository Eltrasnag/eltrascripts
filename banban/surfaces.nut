self.ValidateScriptScope()
function Quicksand()
{
    // PrecacheSoundScript("sf.mario_yahoo")
    // activator.EmitSoundOn("sf.mario_yahoo")

    // local sandsound = SpawnEntityFromTable("ambient_generic", {
    //     // classname = "ambient_generic"
    //     health = "10"
    //     message = "eltra/mario_death.mp3"
    //     radius = "1472"
    //     origin = activator.GetOrigin()

    // })
    local sandsong = SpawnEntityFromTable("ambient_generic", {
        // classname = "ambient_generic"
        health = "10"
        message = "eltra/curse_of_ra.mp3"
        radius = "1472"
        spawnflags = "16"
        origin = activator.GetOrigin()

    })
    local thethreshold = self.GetOrigin().z-activator.GetClassEyeHeight().z
    // printl(sandsound)
    // activator.SetForcedTauntCam(1)
    // sandsound.KeyValueFromVector("origin", activator.GetOrigin())
    sandsong.KeyValueFromVector("origin", activator.GetOrigin())

    // printl(sandsound.GetOrigin())
    // QFireByHandle(sandsound, "PlaySound", "", 0.10, null, null)
    QFireByHandle(sandsong, "PlaySound", "", 0.10, null, null)
    // QFireByHandle(sandsound, "Kill", "", 3.00, null, null)
    PrecacheScriptSound("sf.mario_death")
    EmitSoundOn("sf.mario_death", activator)
    activator.ValidateScriptScope()
    local ascope = activator.GetScriptScope()
    ascope.thethreshold <- thethreshold
    ascope.QuicksandLoop <- QuicksandLoop
    ascope.sandsong <- sandsong
    AddThinkToEnt(activator, "QuicksandLoop")

}

function QuicksandLoop()
{
    // printl("lallala")
    if (self != null && self.IsValid())
    {
        self.SetMoveType(0,0)
        local timedragged = 1
        if (NetProps.GetPropInt(self, "m_lifeState") == 0)
        {
            if (NetProps.GetPropInt(self, "m_lifeState") != 2)
            {

                timedragged++
                if (self.GetOrigin().z > thethreshold-20) // push self under da ground
                {

                    local curorigin = self.GetOrigin()

                    self.SetAbsOrigin(Vector(curorigin.x,curorigin.y,curorigin.z+(-4*timedragged)))
                }

                if (self.GetOrigin().z <= thethreshold)
                {
                    self.TakeDamage(4*timedragged, 16384, null)
                    self.SetScriptOverlayMaterial("eltra/banban/quicksand_overlay") // scary quicksand overlay to stop them from looking around at the beautiful void
                }

            }

        }
        if (NetProps.GetPropInt(self, "m_LifeState") != 0)
        {
            NetProps.SetPropString(self, "m_iszScriptThinkFunction", "");
            sandsong.Kill()
            // sandsong
        }
    }
    return 0.2
}

function QuicksandEscaped()
{
    if (activator != null)
    {
    NetProps.SetPropString(activator, "m_iszScriptThinkFunction", "");
    activator.SetScriptOverlayMaterial("")
    activator.TakeDamage(99999, 1, null);
    }
}





// SPRINGS



function SpringBounce()
{
    local act = activator
    local actvelocity = act.GetAbsVelocity()
        local springsound = SpawnEntityFromTable("ambient_generic", {
        // classname = "ambient_generic"
        health = "10"
        message = "player/taunt_springrider_squeak2.wav"
        radius = "1472"
        origin = activator.GetOrigin()

    })

    QFireByHandle(springsound, "PlaySound", "", 0.10, null, null)
    QFireByHandle(springsound, "Kill", "", 3.00, null, null)




    act.SetAbsOrigin(Vector(self.GetOrigin().x,self.GetOrigin().y,self.GetOrigin().z+10))
    act.SetAbsVelocity(Vector(actvelocity.x*2,actvelocity.y*2,(actvelocity.z*-1)+500))
}