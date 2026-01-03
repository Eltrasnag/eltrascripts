

LadderClasses <- ["func_breakable", "func_brush", "func_ladder"]

LadderRegex <- regexp("(ladder)")

climbers <- {}


const IN_JUMP = 2
const IN_FORWARD	= 8
const IN_BACK	= 16
const IN_MOVELEFT	= 512
const IN_MOVERIGHT	= 1024

function OnPostSpawn() {
	local mClass = self.GetClassname()

	if (self.GetClassname() == "info_teleport_destination") {
		LadderScan()
	// } else if (mClass in LadderClasses) { // why the fuck was this info teleport tdestination 😭😭😭😭HOW
	} else if (mClass == "trigger_multiple") {
		AddThinkToEnt(self, "LadderThink")
	}

}

// LadderSpeed <- 228 // LADDER SPEED UPON RELEASE OF MARIAH CAREY CHRISTMAS MASSACRE
LadderSpeed <- 128

DismountSpeed <- 370

// LadderEnts <- {}

function LadderScan() {

	foreach (i, classname in LadderClasses) {
		for (local ent; ent = Entities.FindByClassname(ent, classname);) {

			local mTargetname = ent.GetName()
			// printl(mTargetname)
			if (LadderRegex.search(mTargetname) != null) { // look for the ladder string in the ent's targetname, turn it into a zladder if found
				// printl("found zeladder " + mTargetname)
				local bmins = ent.GetBoundingMins()
				local bmaxs = ent.GetBoundingMaxs()
				local expand_distance = 8
				bmins.x -= expand_distance
				bmins.y -= expand_distance
				bmaxs.x += expand_distance
				bmaxs.y += expand_distance
				bmaxs.z -= 8
				bmins.z += 8

				local trig = Spawn("trigger_multiple", { // the ladder ""hitbox""
					// model = NetProps.GetPropString(ent, "m_ModelName"),
					vscripts = "eltrasnag/zombieescape/zeladder.nut",
					origin = ent.GetOrigin(),
					parent = ent,
					spawnflags = 1,
				})
				trig.SetSolid(2)
				trig.SetSize(bmins, bmaxs)

				// old method
				// EntityOutputs.AddOutput(trig, "OnStartTouch", "!self", "RunScriptCode", "LadderSet(activator, true)", 0.0, -1)
				// EntityOutputs.AddOutput(trig, "OnEndTouch", "!self", "RunScriptCode", "LadderSet(activator, false)", 0.0, -1)

				// new method
				trig.ValidateScriptScope()
				local tscope = trig.GetScriptScope()
				AddThinkToEnt(trig, "LadderThink")

				trig.ConnectOutput("OnStartTouch", "Enter")
				trig.ConnectOutput("OnEndTouch", "Exit")
				printl("Passed")
				trig.AcceptInput("SetParent", "!activator", ent, null)
				// NetProps.SetPropBool(trig, "m_bForcePurgeFixedupStrings", true)

				// trig.DispatchSpawn()
				// trig.SetSolidFlags(128)
			}
		}
	}

}


function Enter() {
	// LadderSet(activator, true)
	if (ValidEntity(activator)) {

		local snd = "player/footsteps/ladder"+RandomInt(1,4).tostring()+".wav"
		PlaySoundEX(snd, activator.GetOrigin())
		CleanString(snd)

		climbers[activator] <- activator
		activator.SetMoveType(Constants.EMoveType.MOVETYPE_CUSTOM, Constants.EMoveCollide.MOVECOLLIDE_DEFAULT)
	}

}

function Exit() {
	// LadderSet(activator, false)
	local snd = "player/footsteps/ladder"+RandomInt(1,4).tostring()+".wav"
	PlaySoundEX(snd, activator.GetOrigin())
	CleanString(snd)
	activator.SetMoveType(Constants.EMoveType.MOVETYPE_WALK, Constants.EMoveCollide.MOVECOLLIDE_DEFAULT)

	if (ValidEntity(activator) && activator in climbers) {


		delete climbers[activator]
	}

}

function LadderThink() {

}

// function LadderSet(activator, enabled) { // obsolete
	// // printl("ladder set")
	// activator.ValidateScriptScope()
	// local scope = activator.GetScriptScope()

	// if (enabled) {
	// 	activator.AddCond(107)
	// 	AddThinkToEnt(activator, "LadderThink")
	// }
	// else {
	// 	activator.RemoveCond(107)

	// 	activator.SetMoveType(Constants.EMoveType.MOVETYPE_WALK, Constants.EMoveCollide.MOVECOLLIDE_DEFAULT)

	// }
// }

QTrace <- function(vstart, vend, ignorething = null, mask = 81931) {
	local traceparams = {
		start = vstart,
		end = vend,
		pos = vstart, // just incase
		ignore = ignorething
	}
		TraceLineEx(traceparams)
		return traceparams
}

function LadderThink() {

	foreach (i, ply in climbers) {

		if ((ply == null) || !ValidEntity(ply) ||ply.GetMoveType() == Constants.EMoveType.MOVETYPE_WALK, Constants.EMoveCollide.MOVECOLLIDE_DEFAULT) {
			delete climbers[ply]
			continue;
		}

		local vWant = Vector(0,0,0)
		// ply.SetAbsVelocity(Vector(0,0,0))
		local buttons = NetProps.GetPropInt(ply, "m_nButtons")
		local vAngles = ply.EyeAngles()
		local vOrigin = ply.GetOrigin()
		// printl(NetProps.GetPropInt(ply, "m_afButtonPressed"))
		// CleanString("m_afButtonPressed")
		if ((NetProps.GetPropInt(ply, "m_afButtonPressed") & IN_JUMP)) {
			delete climbers[ply]

			// printl("released")
			ply.RemoveCond(107)

			ply.SetMoveType(Constants.EMoveType.MOVETYPE_WALK, Constants.EMoveCollide.MOVECOLLIDE_DEFAULT)

			local endvel = vAngles.Forward() * DismountSpeed
			endvel.z = 200

			// ply.SetAbsVelocity(endvel) // old
			NetProps.SetPropVector(ply, "m_vecBaseVelocity", endvel) // hope this fixes scout issue ?

			// if ("LastThinkFunc" in this) {
			// 	AddThinkToEnt(ply, LastThinkFunc)
			// } else {
			// 	AddThinkToEnt(ply, "")
			// }

			// delete AttachLadder
			// delete QTrace
			// delete LadderSpeed
			// delete LadderThink

			continue;

		}

		local iButtons = 0


		if (buttons & IN_FORWARD) {
			vWant += vAngles.Forward() * LadderSpeed;
			iButtons += 1
		}

		if (buttons & IN_BACK) {
			vWant += vAngles.Forward() * -LadderSpeed;
			iButtons += 1
		}

		if (buttons & IN_MOVELEFT) {
			vWant += vAngles.Left() * -LadderSpeed;
			iButtons += 1
		}

		if (buttons & IN_MOVERIGHT) {
			vWant += vAngles.Left() * LadderSpeed;
			iButtons += 1
		}

		local vNextOrigin = vOrigin + (vWant*LadderSpeed)


		local EyePos = ply.EyePosition()


			if (iButtons == 0) {
				ply.SetMoveType(Constants.EMoveType.MOVETYPE_CUSTOM, Constants.EMoveCollide.MOVECOLLIDE_FLY_SLIDE)
				// ply.SetAbsVelocity(Vector(0,0,0) * -1)
				ply.SetAbsVelocity(Vector(0,0,0))

			} else {
				ply.SetMoveType(Constants.EMoveType.MOVETYPE_WALK, Constants.EMoveCollide.MOVECOLLIDE_FLY_SLIDE)
				local pitch = vAngles.Pitch()
				// ply.KeyValueFromVector("basevelocity", (vWant * LadderSpeed))
				vWant.Norm()
				// if (pitch > 15) {
					// vWant.z = -2
				// }
				if (buttons & IN_FORWARD) {
					if (pitch < 0) {
						vWant.z = 2
					} else {
						vWant.z = -2
					}

				}
				// vWant.z = LadderClamp(vWant.z * 20, -1, 1)
				ply.SetAbsVelocity(vWant * LadderSpeed)

			}

	}

	return -1

}

LadderClamp <- function(value, min, max) {
	if (value < min) {
		return min
	}
	if (value > max) {
		return max
	}
	return value
}