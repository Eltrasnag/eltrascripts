
function OnPostSpawn() {
    self.ConnectOutput("OnStartTouch", "Enter")
    self.ConnectOutput("OnEndTouch", "Exit")
}

players <- []

function Enter() {
    SetHover(activator, true)

}

function Exit() {
    SetHover(activator, false)
}


function SetHover(activator, toggle = false) {
    if (toggle) {
        // NetProps.SetPropString(activator, "m_iszDamageFilterName", "filter_falldamage")
        // QFireByHandle(activator, "setdamagefilter", "filter_falldamage")
        activator.SetGravity(0.6)
        return
    }


    activator.SetGravity(1)
    // NetProps.SetPropString(activator, "m_iszDamageFilterName", "")
    // QFireByHandle(activator, "setdamagefilter", "")
    // if (!toggle && (players.find(activator) != null)) {

    // }

}

