vTargPos <- null
LifeTime <- 0.2
ExpireTime <- 0
hTarget <- null
iSpeed <- 1.0
iLerpStrength <- 0.8
hTarget <- null
Friendly <- false

PlayerOwner <- null;

_x <- 1
_y <- 1

// ExpressionX = "0"
// ExpressionY = "-1"
// movement math expressions
// ExpX <- compilestring("return "+ExpressionX)
// ExpY <- compilestring("return "+ExpressionY)
TrueOrigin <- self.GetOrigin()

function OnPostSpawn() {
	TOUHOU_ENTITIES_LIMIT++
	sPurge(self)
	// self.KeyValueFromInt("modelscale", 1)
	ExpireTime = Time() + LifeTime
	if (TouhouOverflow()) {
		CleanUp()
		printl("ELTRACOMMONS: Not spawning entity due to TOUHOU_MAXENTITIES overflow!")
		return
	}

// self.SetAbsAngles(QAngle(90, 90, 0))
// self.KeyValueFromString("targetname", "TOUHOU_PLAYER_BULLET")

// TrackPosition(self, vTargPos, 20) // unneeded if expression system works
AddThinkToEnt(self, "Think")

}

function Think() {




	// if (Gets2D(vOrigin, vTargPos) < 64) {
	// 	// self.Destroy()

	// }
	if (Time() >= ExpireTime) {
		// printl("bullet expired")
		CleanUp()
		return
	}

	local vOrigin = self.GetOrigin()

	local bHit = false

	for (local hit; hit = Entities.FindInSphere(hit, vOrigin, 128);) {
		if (((hit.GetName() == ( TOUHOU_PLAYERNAME )) && Friendly) || hit == self) {
			continue;
			
		} else {
			local hitname  = hit.GetName()
			
			local hclass = hit.GetClassname()
			
			local dist = GetDistance2D(vOrigin, hit.GetOrigin())
			
			if (hit.IsPlayer() && (hit.GetTeam() == TEAMS.ZOMBIES && dist < 32)) {//hit zombieself.KeyValueFromString(`basevelocity`, "+(TOUHOU_VEC_UP * TOUHOU_BULLET_PUSH).ToKVString()+")
				hit.TakeDamage(10, Constants.FDmgType.DMG_CRUSH, null)
				// hit.KeyValueFromVector("basevelocity", (TOUHOU_VEC_UP * TOUHOU_BULLET_PUSH))
				// QFireByHandle(self, "color", "255 255 0")
				// printl((TOUHOU_VEC_UP*2000).ToKVString())
				local bruh = (TOUHOU_VEC_UP*2000).ToKVString()
				QFireByHandle(hit, "RunScriptCode", "self.KeyValueFromString(`basevelocity`, `"+bruh+"`)", 0.1)
				CleanString(bruh)
				
				CleanUp()
				return;
			}
			
			hit.ValidateScriptScope()
			local hscope = hit.GetScriptScope()
			
			if ((!hclass in VALID_BREAKABLES)) {
				continue;
			}
			
			if (hitname == "TOUHOU_BOSS" && Friendly && dist < 64 && "TakeTouhouDamage" in hscope)
			{
				if (PlayerOwner != null && ValidEntity(PlayerOwner)) {
					PlayerOwner.GetScriptScope().iScore++
				}
				hscope.TakeTouhouDamage()
				CleanUp()
				return;
			}
			
			if ((hitname == TOUHOU_PLAYERNAME) && !Friendly && dist < 8) { // we have hit a player				
				hscope.TakeTouhouDamage()
				CleanUp()
				return;
			}

			if (dist < 6 && hitname == TOUHOU_BULLET_NAME_P && !Friendly) { // interaction with player bullet
				if ("PlayerOwner" in hscope && ValidEntity(hscope.PlayerOwner)) {
					hscope.PlayerOwner.GetScriptScope().iScore++
				}
				CleanUp()
				return;
			}



		}

	}

	// self.KeyValueFromInt("renderamt", RandomInt(120,170))

	local vNextOrigin = vOrigin;


	if (ValidEntity(hTarget)) {
		vNextOrigin = vLerp(vOrigin, hTarget.GetOrigin())
	}


	// local n_y = ExpressionY(vNextOrigin.y - TrueOrigin.y)
	if (vTargPos == null) {
		
		local want = Vector(0,0,0)

		local tDist = GetDistance2D(vOrigin, TrueOrigin)
		// local n_x = ExpressionX(vNextOrigin.x - TrueOrigin.x)
		local n_x = ExpressionX(_x * iSpeed)

		local n_y = ExpressionY(_y * iSpeed)
		DebugDrawLine(vOrigin, vNextOrigin + TOUHOU_VEC_Z_UP*10, 255,0,0,false,0.1)
		// printl("x: "+n_x.tostring())
		// printl("y: "+n_y.tostring())
		want.x = n_x

		want.y = n_y


		vNextOrigin = vOrigin + want

	} else {

		vNextOrigin += (self.GetAbsAngles().Left() * (TOUHOU_SPEED_PBULLET * iSpeed * FrameTime() * -50))

	}

	// vNextOrigin.y -= 1
	self.KeyValueFromVector(CUBT_ORIGIN, vNextOrigin)


	_x += FrameTime()
	_y += FrameTime()

	return -1

}

function CleanUp() {
	AddThinkToEnt(self, "")
	TOUHOU_ENTITIES_LIMIT--
	self.Destroy()
}


// function ExpressionX(x) {
// 	return 0
// }

// function ExpressionY(y) {
// 	return
// }