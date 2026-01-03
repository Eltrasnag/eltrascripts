iHealth <- 0
iHealthPerPlayer <- 300
iHealthPerSegment <- 0
iHealthBarSegments <- 60
orbitpoint <- (TOUHOU_ORIGIN + TOUHOU_VEC_UP * 100)

bAttacking <- false // are we doing attacks in genera;
bAttackingOverride <- false

iNextHudTime <- 0
// spawning_descend_speed <- 1
spawning_descend_speed <- 6 // dev

bShooting <- false // are we shooting bullets
iNextShootTime <- 0
iShootWaitTime <- 0.3
iNextBurstTime <- 0
DEV_AttackOverride <- false
iInterludeTime <- 4

iBurstLength <- 0
iMaxBursts <- 0
iBursts <- 0
bOddBurst <- false
SantaColors <- ["255 255 255","150 255 255", "0 255 76", "0 3 255"]

iCurrentAttack <- 2

SantaExpressions <- [
	[
		function(x){ return sin(Time() + pow(x, 2)) * 10 * x}, // x expression
		function(y){ return clamp(sin(Time()) * y * 10, -0.1, -3) },  // y expression
		"SANTA GRONGA BUST", // attack name
		0.1, // bullet speed
		4, // bullet type
		SantaColors[2], // bullet color
		3, // bullet lifetime
		10, // max bursts before next attack
		0.4, // burst length
		0.01, // shoot interval
	],
	[
		function(x){ return 0 }, // x expression
		function(y){ return pow(y, 6) * -0.5 + sin(Time()) + sin(y) },  // y expression
		"SANTA DOOPEY LUM", // attack name
		0.4, // bullet speed
		2, // bullet type
		SantaColors[0], // bullet color
		7, // bullet lifetime
		10, // max bursts before next attack
		0.4, // burst length
		0.05, // shoot interval
	],
	[
		function(x){ return sin(pow(x, 2)*2)*1 }, // x expression
		function(y){ return clamp(sin(Time())*3 * y * 0.5, -1, -3) },  // y expression
		"SANTA BEARD BLAST", // attack name
		1, // bullet speed
		1, // bullet type
		SantaColors[0], // bullet color
		3, // bullet lifetime
		2, // max bursts before next attack
		3, // burst length
		0.015, // shoot interval
	],
	[
		function(x){ return sin(pow(x, 2) * x + Time() * 4) }, // x expression
		function(y){ return abs(sin(y*2)*15)*-1 },  // y expression
		"THIS WIBBLE WOBBLE BIG PEAK", // attack name
		0.1, // bullet speed
		1, // bullet type
		SantaColors[0], // bullet color
		8, // bullet lifetime
		3, // max bursts before next attack
		6, // burst length
		0.3, // shoot interval
	],

]

function OnPostSpawn() {
	QFire("TOUHOU_BOSS", "Kill") // ease of testing :P
	QFireByHandle(self, "addoutput","targetname TOUHOU_BOSS", 0.1)
	for (local ply; ply = Entities.FindByClassname(ply, "player");) {
		if (ply.GetTeam() == TEAMS.HUMANS && ply.IsAlive()) {
			iHealth += iHealthPerPlayer
		}
	}

	iHealthPerSegment = iHealth/iHealthBarSegments
	SetBrushModel(self, "touhou_santa")
	// self.SetAbsAngles(QAngle(0,180,0))
	self.SetOrigin(TOUHOU_ORIGIN + TOUHOU_VEC_UP * 512)
	AddThinkToEnt(self, "SpawningThink")
}

function LifeCheck() {
	if (iHealth <= 0) {
		AddThinkToEnt(self, "")
		CleanUp()
	}
}


function CleanUp() {
	self.Destroy()
}

iOddTick <- false

iNextAttackTime <- 0
iAttackWait <- 3


function SpawningThink() {
	local vOrigin = self.GetOrigin()
	local fTime = Time()

	if (GetDistance2D(vOrigin, orbitpoint) < 10) {
		AddThinkToEnt(self, "Think")
		return
	}
	local npos = vLerp(vOrigin, orbitpoint, spawning_descend_speed * FrameTime())
	// npos.y = vOrigin.y
	npos.x += sin(fTime * 3 * 0.3)* 10 * 0.5
	npos.y -= cos(fTime * 10 * 0.3)*10 * 0.1

	self.KeyValueFromVector(CUBT_ORIGIN, npos)

	return 0.02
}

iNextMoveTime <- 0
iMovePattern <- 0
function Think() {

	local vOrigin = self.GetOrigin()
	local fTime = Time()

	local vWant = vOrigin


	// if (bAttacking && !bAttackingOverride && Time <= iNextAttackTime) { // if we can attack
		if (fTime >= iNextBurstTime) { // then check if we can do a burst
			iNextBurstTime = fTime + iBurstLength


			if (bOddBurst) { // we are turning off a burst
				bShooting = false
				iMovePattern = RandomInt(0,3)
				iNextBurstTime = fTime + iBurstLength*0.2 // set the next burst time


					iBursts++
					bShooting = true
					iNextBurstTime = fTime + iBurstLength

				printl("Next burst at "+iNextBurstTime.tostring())

			} else { // we are turning on a burst
			}
			if (bOddBurst == true) {
				printl("burst odd" )
				bOddBurst = false
			}
			else if (bOddBurst == false) {
				printl("burst true" )
				bShooting = false
				bOddBurst = true
			}
		}



		if (iBursts >= iMaxBursts) { // if our attack is finished...
			SantaProgressCheck()
			AttackShuffle()
		}
	// }
	if (iNextShootTime <= fTime) {
		iNextShootTime = fTime + iShootWaitTime
		MakeBullet()
		bShooting = true
	}
	if (bShooting && bAttacking) {
		MakeBullet()
	}
	local nextvec = vOrigin
		// iMovePattern = 1
	switch (iMovePattern) {
		case 0:
			nextvec.x = orbitpoint.x + sin(fTime * 0.01 * cos(fTime * 0.24)) * 256
			nextvec.y = orbitpoint.y + cos(fTime * 4) * 64
		break;
		case 1:
			nextvec.x = orbitpoint.x + sin(fTime * 3.3) * 400
			nextvec.y = orbitpoint.y + cos(fTime * 7) * 62
		break;
		case 2:
			nextvec.x = orbitpoint.x + cos(fTime * 1.2) * 260
			nextvec.y = orbitpoint.y + cos(fTime*2) * 16
		break;
		case 3:
			nextvec.x = TOUHOU_ORIGIN.x + cos(fTime * 2) * 100
			nextvec.y = TOUHOU_ORIGIN.y + abs(cos(fTime*1) * 256 + 140)
		break;
	}

	self.KeyValueFromVector(CUBT_ORIGIN, vLerp(nextvec, vOrigin, FrameTime() * 23))
	if (iOddTick) { // shoot on odd ticks


		iOddTick = false
	} else {
		iOddTick = true
	}

	if (iNextHudTime <= fTime)
	{
		iNextHudTime = fTime + 0.025
		SantaHudDisplay()
	}

  	return 0.025
}


function ynone(y) {
	return 0
}



enum TOUHOU_ATTACK_ARRAY{EXPRESSION_X, EXPRESSION_Y, NAME, BULLETSPEED, BULLETTYPE, BULLETCOLOR, BULLETLIFE, MAXBURSTS, BURSTLENGTH, INTERVAL}

function AttackShuffle() { // set up and pick next attack
	iBursts = 0

	iNextShootTime = 0
	if (!DEV_AttackOverride) {
		iCurrentAttack = RandomInt(0,SantaExpressions.len()-1)

	}

	iMaxBursts = SantaExpressions[iCurrentAttack][TOUHOU_ATTACK_ARRAY.MAXBURSTS]
	iBurstLength = SantaExpressions[iCurrentAttack][TOUHOU_ATTACK_ARRAY.BURSTLENGTH]
	iShootWaitTime = SantaExpressions[iCurrentAttack][TOUHOU_ATTACK_ARRAY.INTERVAL]
	bAttacking = false
	iNextBurstTime = Time() + iInterludeTime
	MapSay(SantaExpressions[iCurrentAttack][TOUHOU_ATTACK_ARRAY.NAME])
	bShooting = true
}

function SantaProgressCheck() // do things when we drop below certain health values
{
	MapSay("Ho ho ho!", "SANTA CLAUS")
}

function MakeBullet() {
	bShooting = false

	local b = Spawn("func_door", {
		model = BRUSHMODELS[TOUHOU_BULLET_PREFIX+SantaExpressions[iCurrentAttack][TOUHOU_ATTACK_ARRAY.BULLETTYPE].tostring()],
		disableshadows = true,
		spawnflags = 2052,
		vscripts = TOUHOU_BULLET_SCRIPT,
		rendermode = 2,
		color = SantaExpressions[iCurrentAttack][TOUHOU_ATTACK_ARRAY.BULLETCOLOR],
		targetname = TOUHOU_BULLET_NAME_P,
		origin = self.GetOrigin(),
	})

	b.AcceptInput(CUBT_RUNSCRIPTFILE, TOUHOU_BULLET_SCRIPT, null, null)
	b.AcceptInput(CUBT_COLOR, SantaExpressions[iCurrentAttack][TOUHOU_ATTACK_ARRAY.BULLETCOLOR], null, null)

	b.ValidateScriptScope()
	local scope = b.GetScriptScope()



	scope.Friendly <- false
	scope.vTargPos <- null


	scope.iSpeed <- SantaExpressions[iCurrentAttack][TOUHOU_ATTACK_ARRAY.BULLETSPEED]
	scope.LifeTime <- SantaExpressions[iCurrentAttack][TOUHOU_ATTACK_ARRAY.BULLETLIFE]

	local xp = SantaExpressions[iCurrentAttack][TOUHOU_ATTACK_ARRAY.EXPRESSION_X]
	local yp = SantaExpressions[iCurrentAttack][TOUHOU_ATTACK_ARRAY.EXPRESSION_Y]



	scope.ExpressionX <- SantaExpressions[iCurrentAttack][TOUHOU_ATTACK_ARRAY.EXPRESSION_X]
	scope.ExpressionY <- SantaExpressions[iCurrentAttack][TOUHOU_ATTACK_ARRAY.EXPRESSION_Y]

	// if (targent != null) {
		// scope.hTarget <- targent
	// }

	AddThinkToEnt(b, "Think")

	return b
}

function TakeTouhouDamage() {
	try {
		PlaySoundEX("eltra/tan01.mp3",self.GetOrigin(), 2)
		self.KeyValueFromString(CUBT_COLOR, COLOR_RED)
		iHealth--
		// MapSay("health: "+iHealth.tostring())
		QFireByHandle(self, "color", "255 255 255", 0.5)
		if (iHealth <= 0) {
			AddThinkToEnt(self, "")
			CleanUp()
			QFire("tsys", "FireUser1")
			printl("well i died")
			TouhouBossKilled()
		}
	} catch (exception){
		printl(exception)
	}
}

function SantaHudDisplay() {
	EBossBar(iHealth, iHealthPerSegment, iHealthBarSegments)
	// if (iHealth == 0) {
	// 	return
	// 	printl("no health")
	// }

	// // local hpstring = "</\\ SANTA : ";
	// printl(iHealth)
	// local hpstring = ""
	// local iter = 0
	// // add blox
	// local bars = iHealth/iHealthPerSegment
	// for (local i = 0; i < bars; i++) {
	// 	hpstring += "█"
	// 	iter = i
	// }
	// // add blanx
	// for (local i = 0; i < (iHealthBarSegments-iter); i++) {
	// 	hpstring += "░"
	// 	printl(i)
	// }

	// printl(hpstring)

	// // hpstring += " /\\>"

	// local hTextInfo =	Spawn(CUBT_GAMETEXT, {
	// 		color = TOUHOU_COLOR_HEALTH,
	// 		fadein = 0.1,
	// 		fadeout = 0.1,
	// 		holdtime = 0.25,
	// 		message = hpstring,

	// 		x = -1,
	// 		y = 0.2,
	// 		spawnflags = 1,
	// })

	// sPurge(hTextInfo)
	// hTextInfo.AcceptInput(CUBT_DISPLAY, CUBT_NOSTRING, null, null)
	// QFireByHandle(hTextInfo, CUBT_KILL)
	// CleanString(hpstring)

}