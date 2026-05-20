IncludeScript("eltrasnag/modules/shared.nut")

// All the functions related to playing sounds from script in a map!!!
// PlaySoundEX can probably do most of the things we need, but there are other specific-use-case functions below as well.


const PLAYSOUND_FLAGS_LOCAL = 48
const PLAYSOUND_FLAGS_EVERYWHERE = 49



// PLAYSOUNDEX

// Functionality:
// - Plays a sound with all the adjustable properties of an ambient generic.
// - First parameter is your sound path, relative to sound/ folder
// - Second parameter is either A) The location to play the sound at, B) The handle of the entity to play the sound on, or C) Nothing; which *should* just play sound globally.
// Notes:
// - "sourceentity" parameter is obsolete, only kept for legacy compatibility with ze_banban's scripts. If you pass a number as it, it will be applied as the sound radius.


::PlaySoundEX <- function(strSoundName, vPos = Vector(), flVol = 10, flPitch = 100, sourceentity = null, iradius = 2048) {
	PrecacheSound(strSoundName)
	if (typeof(vPos) == "instance" && ValidEntity(vPos)) {
		sourceentity = vPos
		vPos = Vector(sourceentity.GetOrigin())
	}

    local iSpawnflags = PLAYSOUND_FLAGS_LOCAL

    if (vPos == Vector()) {
        iSpawnflags = PLAYSOUND_FLAGS_EVERYWHERE
    }


	local paramstable = {
		message = strSoundName,
		origin = vPos,
		health = flVol,
		radius = iradius,
		pitch = flPitch,
		spawnflags = iSpawnflags,
	}

	if (type(sourceentity) == "integer") {
		paramstable.radius = sourceentity
		// dprintl("Yep thats number", sourceentity)
	} else if (type(sourceentity) == "instance") {
		paramstable.SourceEntityName <- sourceentity.GetName()
	}


	local hSound = Spawn("ambient_generic", paramstable)

	hSound.AcceptInput("PlaySound","",null,null)
	if (!sourceentity || sourceentity == null) {
		hSound.Kill()
	} else {
		QFireByHandle(hSound, "Kill", "", 10)
	}
	CleanString(strSoundName)
}

// need to import:
// CleanString()
// QFireByHandle
//