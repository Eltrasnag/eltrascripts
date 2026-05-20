IncludeScript("eltrasnag/nide26/shared.nut", this)


trigger_zone <- Entities.FindByName(null, "s1_slender_trigger")

targets <- []

thud_sound <- "eltra/nide26/npc_slender_thud.mp3"
killing_sound <- "eltra/zobmie_die.mp3"

::SlenderMan <- self.GetScriptScope()

fl_MoveSpeedMult <- 1.0


function OnPostSpawn() {
    ListenHooks({
        OnScriptHook_OnTakeDamage = function(params) {
            if (params.const_entity == self) {
                self.SetModelScale(0.98, 0)
                QAcceptInput(self, "color", "255 0 0")
                self.SetModelScale(1, 0.1)
                QFireByHandle(self, "color", "255 255 255", 0.25)
                fl_MoveSpeedMult -= 0.005
            }
        }
    })
    // dprintl(trigger_zone)
    AddThinkToEnt(self, "SlenderThink")
    dprintl("Slenderman initialized")


    // trigger_zone.ConnectOutput("OnStartTouch", "AddTarget")
    // trigger_zone.ConnectOutput("OnEndTouch", "RemoveTarget")

    EntityOutputs.AddOutput(trigger_zone, "OnStartTouch", "slenderman", "RunScriptCode", "AddTarget(activator)", 0, -1)
    EntityOutputs.AddOutput(trigger_zone, "OnEndTouch", "slenderman", "RunScriptCode", "RemoveTarget(activator)", 0, -1)


}

function AddTarget(ply) {
    if (targets.find(ply) == null) {
        targets.append(ply)
        dprintl("Adding "+ply)

    }
}

function RemoveTarget(ply) {

    local idx;

    if (type(ply) == "instance") {
        idx = targets.find(ply)
        // dprintl("player is instance")
    } else {
        idx = ply
        // dprintl("player is index")
    }



    if (idx != null) {
        targets.remove(idx)
        dprintl("Removing "+ply)
    }
}

fl_TeleDelay <- 0.024
fl_AttackDelay <- 0.5

fl_CalmDelay <- 0.83
fl_NextCalmTime <- 0

fl_NextAttackTime <- 0
fl_NextTeleTime <- 0

fl_AttackRange <- 64.0

i_AttackDamage <- 30

strVariable <- "diarrhea"

i_MoveSpeed <- 90

b_Calm <- true

function SlenderThink() {

    // P_UTILS.FakeGravity()

    local vOrigin = self.GetOrigin()
    // local vAngles = self.GetAbsAngles()
    // local flTime = Time()


    if ( P_UTILS.BusStop("fl_NextCalmTime", fl_CalmDelay) ) {
        if (b_Calm) {
            b_Calm = false
        } else {
            b_Calm = true
        }
    }

    if ( P_UTILS.BusStop("fl_NextTeleTime", fl_TeleDelay) && (RandomInt(1,4) == 3) ) {
        // fl_NextTeleTime = flTime + fl_TeleDelay



        if (targets.len() > 0) {
            PlaySoundEX(thud_sound, vOrigin, 100, RandomInt(95,105), 10000)
            // dprintl("target is ", targets[0])
            local hTarget = targets[0]

            if (!ValidEntity(hTarget)) {
                RemoveTarget(0)
                return
            }

            if ((hTarget.GetTeam() != TEAMS.HUMANS) || (hTarget.IsAlive() == false)) {
                RemoveTarget(hTarget)
                return
            }

            local vTargOrigin = hTarget.GetOrigin()
            // local vTargAngles = hTarget.EyeAngles()

            local vMoveVec = GetMovementVector(vTargOrigin, vOrigin)

            local vAnglesToPlayer = GetLookAngle(vTargOrigin, vOrigin)

            vAnglesToPlayer.x = 0

            self.SetAbsAngles(vAnglesToPlayer)


            local vNextOrigin = vOrigin + vMoveVec * clamp( i_MoveSpeed * fl_MoveSpeedMult * (GetDistance2D(vTargOrigin, vOrigin) * 0.5), 8, 128 )

            self.SetAbsOrigin(vNextOrigin)
            P_UTILS.SnapToFloor()


        }




    }

    if ( P_UTILS.BusStop("fl_NextAttackTime", fl_AttackDelay) ) {
        fl_MoveSpeedMult = clamp(fl_MoveSpeedMult + 0.3, 0, 1)
        for ( local ply; ply = Entities.FindByClassnameWithin(ply, "player", vOrigin, fl_AttackRange); ) {
            ply.TakeDamage(i_AttackDamage, DMG_CRUSH, self)
            ply.SetScriptOverlayMaterial("eltra/shaders/eltra_crt_b.nut")
            QFireByHandle(ply, "RunScriptCode", "self.SetScriptOverlayMaterial(``)", RandomFloat(0.0, 0.2))
            PlaySoundNPC(killing_sound, ply)
        }

        // if (playsound) {
        // }
    }



    return -1

}