function OnPostSpawn() {
	self.ConnectOutput("OnStartTouch", "Enter")
	self.ConnectOutput("OnEndTouch", "Exit")
}

function Enter() {
	NetProps.SetPropFloat(activator, "m_flFriction", 0)
}

function Exit() {
	NetProps.SetPropFloat(activator, "m_flFriction", 4)
}