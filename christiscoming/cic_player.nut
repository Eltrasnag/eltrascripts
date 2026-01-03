// IncludeScript("eltrasnag/common.nut", this)
// buttons
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

// cic variables
InWallkick <- false


function OnPostSpawn() {
	// self.KeyValueFromString("")
	// NetProps.SetPropString(self, "m_iszResponseContext", "") // wipe context
	self.KeyValueFromString("ResponseContext", "itemholder:0")

	printl("Player "+self.tostring()+" has initialized")
}
