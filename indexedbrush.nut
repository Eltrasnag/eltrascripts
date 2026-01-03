// ::BRUSHMODELS <- {};
// ::BRUSHMODELS <- {}
// ::BRUSHMODELINDEXES <- {}






if (!("BRUSHMODELS" in getroottable())) {
	::BRUSHMODELS <- {};
	printl("Make brush table")
}
// BRUSHMODELS.clear()







if (!("BRUSHMODELINDEXES" in getroottable())) {
	getroottable().BRUSHMODELINDEXES <- {};
}
// BRUSHMODELSINDEXES.clear()

function Precache() {
	local strModelname = NetProps.GetPropString(self, "m_ModelName")
	local strTargetname = NetProps.GetPropString(self, "m_ModelName")
	BRUSHMODELS[self.GetName()] <- strModelname
	BRUSHMODELINDEXES[self.GetName()] <- NetProps.GetPropInt(self, "m_nModelIndex")
	printl("BRUSHMODELS: Storing indexed brush model \""+strModelname+"\"")
	// self.AcceptInput("Kill","",null,null)
	self.Kill()
}