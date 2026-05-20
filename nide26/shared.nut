P_UTILS <- {}

vFakeGrav_Offset <- Vector(0,0,0.1)

P_UTILS.FakeGravity <- function() {

    if (!("fl_GravAccel" in this)) {
        this.fl_GravAccel <- 1
    }

    local vOrigin = self.GetOrigin()
    local ground_trace = QuickTrace(vOrigin + vFakeGrav_Offset, vOrigin+ Vector(0,0, -10000), self)

    if (ground_trace.hit == true && (ground_trace.pos.z < vOrigin.z)) {

        fl_GravAccel *= 1.1

        vOrigin.z = clamp(vOrigin.z - (fl_GravAccel), ground_trace.pos.z, vOrigin.z)

        self.KeyValueFromVector("origin", vOrigin)

    } else {
        vOrigin = ground_trace.pos
        fl_GravAccel = 1

    }

    fl_GravAccel = clamp(fl_GravAccel, 0, 512)


}

// bus stop metaphor super mario brother
// next time is the name of the variable to update, wait time is the desired waiting time
P_UTILS.BusStop <- function(next_time, wait_time) {

    local next_time_var = this[next_time]

    local flTime = Time()

    if (flTime >= next_time_var) {
        this[next_time] = wait_time + flTime
        return true
    }

    return false
}

vSnapTraceOffset <- Vector(0,0,64)

// snap the object to floor
P_UTILS.SnapToFloor <- function() {
    local vOrigin = self.GetOrigin()
    local trace = QuickTrace(vOrigin+vSnapTraceOffset, vOrigin + Vector(0,0,-10000), self)

    if ((trace.hit == true) && (trace.pos.z < vOrigin.z)) {
        self.SetAbsOrigin(trace.pos)
    }
}


// keep this at bottom or they will come to kill you
foreach (i, func in P_UTILS) {
    P_UTILS[i] = func.bindenv(this)
}
