::ROOT <- getroottable()

const SND_LAURA_DEATH = "eltra/li_laura_die.mp3"

if (!("TIMERS" in ROOT)) { // does spawnevents already exist?
	::TIMERS <- {};
}
::TIMERS.clear()
::TIMERS <- {}
::CURRENT_STAGE <- 0
DEV <- true
::ROUNDS <- 0
::tCharacters <- {
	"grandma" : Vector(255, 112, 219),
}

// if (!("BRUSHMODELS" in getroottable())) {
// 	::BRUSHMODELS <- {};
// }

const IN_ATTACK	= 1
const IN_JUMP	= 2
const IN_DUCK	= 4
const IN_FORWARD	= 8
const IN_BACK	= 16
const IN_USE	= 32
const IN_CANCEL	= 64
const IN_LEFT	= 128
const IN_RIGHT	= 256
const IN_MOVELEFT	= 512
const IN_MOVERIGHT	= 1024
const IN_ATTACK2	= 2048
const IN_RUN	= 4096
const IN_RELOAD	= 8192
const IN_ALT1	= 16384
const IN_ALT2	= 32768
const IN_SCORE	= 65536
const IN_SPEED	= 131072
const IN_WALK	= 262144
const IN_ZOOM	= 524288
const IN_WEAPON1	= 1048576
const IN_WEAPON2	= 2097152
const IN_BULLRUSH = 4194304
const IN_GRENADE1 = 8388608
const IN_GRENADE2 = 16777216
const IN_ATTACK3	= 33554432

enum HCLASSES {
	LI_CLASS_STRAIGHT,
	LI_CLASS_EDTWT,
	LI_CLASS_BISEXUAL,
	LI_CLASS_HUGGER,
	LI_CLASS_PHILLIPINO,
	LI_CLASS_SNEAKER,
	LI_CLASS_DEFENSE,
	LI_CLASS_LAURAPALMER,
	LI_CLASS_MEL,
}

enum TEAMS {
	HUMANS = 3,
	ZOMBIES = 2,
	SPECTATORS = 1,
	UNASSIGNED = 0,
}


function OnPostSpawn() {

}
function OnGameEvent_round_end(params) {

}



// function OnPostSpawn() {
	// __Coll
// }

