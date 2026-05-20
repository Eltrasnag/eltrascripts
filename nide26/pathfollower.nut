
// these two are passed by the spawner function
h_Player <- null;
fl_TravelSpeed <- null;


fl_SuctionSpeed <- 0.7
fl_MaxDistance <- 256

fl_ReturnTime <- 0.025
fl_DeltaTime <- 1.0 / fl_ReturnTime

function Init() {
    // EntitityOutputs.AddOutput(self, )
    QFireByHandle(self, "StartForward")
    AddThinkToEnt(self, "Think")

    if (ValidEntity(h_Player) && h_Player.GetMoveType() == MOVETYPE_WALK) {
        // h_Player.SetAbsVelocity(Vector())
        h_Player.SetAbsOrigin(h_Player.GetOrigin() + Vector(0,0,10))
        h_Player.SetMoveType(MOVETYPE_NOCLIP, MOVECOLLIDE_DEFAULT)
    }
}

function Think() {
    if (!(ValidEntity(h_Player) && h_Player.IsAlive()) || !(self != null && ValidEntity(self))) {

        // AddThinkToEnt(self, "")
        Kill()

        return
    }


    local m_flSpeed = NetProps.GetPropFloat(self, "m_flSpeed")

    local vOrigin = self.GetOrigin()
    local vPlayerOrigin = h_Player.GetOrigin()



    // local vPlayerVelocity = h_Player.GetBaseVelocity()

    local vPlayerEyeOrigin = h_Player.EyePosition()

    // // h_Player.GetBaseVelocity

    local fl_PlayerDistance = GetDistance(vOrigin, vPlayerOrigin)


    local vMoveVec = GetMovementVector(vOrigin, vPlayerOrigin)

    // vMoveVec *= m_flSpeed*0.9


    vMoveVec *= fl_DeltaTime





    vMoveVec *= (fl_PlayerDistance*0.9)/(fl_TravelSpeed)
    vMoveVec *= fl_SuctionSpeed
    vMoveVec *= fl_PlayerDistance
    h_Player.KeyValueFromVector("origin", vPlayerOrigin + vMoveVec)

    // vMoveVec *= fl_TravelSpeed

    // vMoveVec *= self.GetRightVector()

    printl(vMoveVec)

    // local vForward = self.GetForwardVector()/

    // local vEyeAngles = QAngle(vForward.x, vForward.y, vForward.z)

    // h_Player.SnapEyeAngles(self.GetAbsAngles())

    // vMoveVec -= vPlayerVelocity


    DebugDrawLine_vCol(vOrigin, vPlayerOrigin, Vector(0,255,0), false, 0.1)
    DebugDrawText(vOrigin, "THE TRAIN FOLLOWER", false, 0.1)

    local t_WallTrace = QuickTrace(vPlayerEyeOrigin, vPlayerEyeOrigin, h_Player)

    if (t_WallTrace.startsolid) {
        ScreenFade(h_Player, 0,0,0,255, 0.1, fl_ReturnTime, FFADE_IN)
    }


    if (m_flSpeed > 0) {


        if (GetDistance(vOrigin, vPlayerOrigin) > fl_TravelSpeed) {
            // failsafe incase the player gets trapped on something.
            // vMoveVec = Vector()
            // h_Player.SetAbsVelocity(Vector())
            h_Player.SetOrigin(vOrigin)
        }

        // h_Player.SetGravity(0.0)

        // NetProps.SetPropVector(h_Player, "m_vecBaseVelocity", vMoveVec )



    }  else  {
        // we have stoppped (reached the end?)

        // h_Player.SetOrigin(vOrigin)
        h_Player.SetAbsVelocity(Vector())

        NetProps.SetPropVector(h_Player, "m_vecBaseVelocity", vMoveVec)
        Kill()
        return
    }



    return fl_ReturnTime
}

function Kill() {

    if (h_Player in PATHFOLLOWERS) { // i think this is safe to do without a null check ?????
        delete PATHFOLLOWERS[h_Player]
    }

    if (ValidEntity(h_Player) && h_Player.IsAlive()) {
        h_Player.SetMoveType(MOVETYPE_WALK, MOVECOLLIDE_DEFAULT)
        // h_Player.SetGravity(1.0)
    }
    AddThinkToEnt(self, "")
    self.Kill()
}