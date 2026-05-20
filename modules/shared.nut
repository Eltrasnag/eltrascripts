// Shared functions required by all modern Eltra scripts !!!!!

::regex_runscriptcode <- regexp("runscriptcode")

::CleanString <- function(action) { // make entity
		local h1 = Spawn("info_target", {}) // is there a reason this is info target
		h1.KeyValueFromString("targetname", action)
		h1.Destroy()
}


// Wrappers for EntFire & related functions with QOL tweaks (mostly that they DONT require all parameters to be filled!!)

::QAcceptInput <- function(ent, p1 = "", p2 = "", acti = null, calli = null) {
	ent.AcceptInput(p1, p2, acti, calli)

	// is this necessary?
	if (regex_runscriptcode.search(p1.tolower())) {
		// CleanString(p1)
		CleanString(p2)
	}
}

::QFireByHandle <- function(entity, action = "", value = "", delay = 0.0, activador = null, cadder = null) {
	// try {
	EntFireByHandle(entity, action, value, delay, activador, cadder)

	if (regex_runscriptcode.search(action.tolower())) { // i think we only need to do this for runscriptcode ?
		// CleanString(action)
		CleanString(value)
	}

	// local h1 = Spawn("info_target", {})

	// local h2 = Spawn("info_target", {})

	// h1.KeyValueFromString("targetname", action)
	// h1.Kill()
	// h2.KeyValueFromString("targetname", value)
	// h2.Kill()

}

::QFire <- function(target, action = "", value = "", delay = 0.0, activador = null) {
	EntFire(target, action, value, delay, activador)
	// is this necessary // it is!
	if (regex_runscriptcode.search(action.tolower())) {
		CleanString(value)
	}


    // but is THIS unnecessary ?
	// local h1 = Spawn("info_target", {})

	// local h2 = Spawn("info_target", {})

	// local h3 = Spawn("info_target", {})

	// h1.KeyValueFromString("targetname", action)
	// h1.Kill()
	// h2.KeyValueFromString("targetname", value)
	// h2.Kill()
	// h3.KeyValueFromString("targetname", target)
	// h3.Kill()
}





// Functions related to safe-spawning entities.

::SafePurge <- function(ent) { // hopefully make entity clean itself up to minimize stringtable usage
	NetProps.SetPropBool(ent, "m_bForcePurgeFixedupStrings", true)
}

::sPurge <- function(ent) { // shorter wrapper fofr safepurge
	SafePurge(ent)
}

::MakeEnt <- function(classname, kv) { // safe wrapper for SpawnEntityFromTable which automatically enables stringtable cleanup
	local e = SpawnEntityFromTable(classname, kv)
	sPurge(e)
	return e
}

// Shorthand for SpawnEntityFromTable
::Spawn <- function(classname, kv) {
	return MakeEnt(classname, kv) // wrapper for wrapper
}

// Allow for usage of QAcceptInput directly on certain entities
getroottable().CBaseAnimating.QAcceptInput <- function(p1 = "", p2 = "", acti = null, calli = null) {
	getroottable().QAcceptInput(this, p1, p2, acti, calli)
}

getroottable().CBaseEntity.QAcceptInput <- getroottable().CBaseAnimating.QAcceptInput
