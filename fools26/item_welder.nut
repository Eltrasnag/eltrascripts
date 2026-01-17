IncludeScript("eltrasnag/zombieescape/zeitem.nut", this)

Weldables <- ["prop_physics", "prop_physics_multiplayer", "prop_physics_override", "func_physbox", "prop_ragdoll"]

ItemName <- "The Welder"



IdleScale <- 1
iOffsetForward <- 32 // yeah
iOffsetLeft <- 0
iOffsetUp <- 0
vNoAngle <- QAngle(0,180,0)
iCooldownAdd <- 0.5

hWeldEnt <- null;

aConstraints <- []
ActiveConstraints <- {}

function CustomSpawn() {
	if (!"MapWelds" in getroottable()) {
	getroottable().MapWelds <- {}
	printl("makemapwelds")
}
}
function CustomThink() {
	foreach (constraint, constraintpair in ActiveConstraints) {
		local ent1 = constraintpair[0]
		local ent2 = constraintpair[1]

		if (!ValidEntity(constraint)) {
			printl("cleaning dead constraint")
			if (ValidEntity(ent1))
				ent1.KeyValueFromString("targetname", "")
				// if (ent1 in MapWelds)
					// delete MapWelds[ent1]
			if (ValidEntity(ent2)) {
				ent2.KeyValueFromString("targetname", "")
				// if (ent2 in MapWelds)
					// delete MapWelds[ent2]

			}
			delete ActiveConstraints[constraint]
		}

	}
}
function FireWeapon() {
	flNextCooldownEnd = Time() + iCooldownAdd
	local vOrigin = hOwner.EyePosition()
	local vAngles = hOwner.EyeAngles()
	local vForward = vAngles.Forward()
	local trace = QuickTrace(vOrigin + vForward * 32, vOrigin + vForward * 5000, self, MASK_SHOT)
	printl("firing welder")
	DebugDrawLine_vCol(trace.startpos, trace.pos, Vector(255,255,0), true, 3)

	local bIsWeldable = Weldables.find(trace.enthit.GetClassname())



	if ((!trace.hit)  || (bIsWeldable == null) || (trace.enthit == self)) {
		printl("trace has hit: " + (trace.hit))
		printl("class is weldable: " + bIsWeldable)
		printl("ineligible weld entity "+trace.enthit.GetClassname())
		return
	}
	printl(NetProps.GetPropEntity(trace.enthit, "m_hConstraintEntity"))
	if (hOwner.ButtonPressed(IN_RELOAD)) {
		printl("trying to remove closest constraint")
		// NetProps.GetPropEntity(trace.enthit, "m_hConstraintEntity").Kill()


		local constraint;
		while (constraint = Entities.FindByClassname(constraint, "phys_constraint")) {
			if (GetDistance(constraint.GetOrigin(), trace.pos) < 64) {
				constraint.Kill()
			}
		}
		return
	}

	if (!hWeldEnt || trace.enthit == hWeldEnt) {
		printl("first weld ent selected")
		hWeldEnt = trace.enthit
		return
	}

	local hWeldEnt2 = trace.enthit

	local attachstr = "_physattach"
	local randomnames = UniqueString(attachstr)
	local randomnames2 = UniqueString(attachstr)
	hWeldEnt.KeyValueFromString("targetname", randomnames)
	hWeldEnt2.KeyValueFromString("targetname", randomnames2)

	local hConstraint = Spawn("phys_constraint", {
		targetname = "WelderConstraint",
		origin = trace.pos,
		attach1 = randomnames,
		attach2 = randomnames2,
		forcelimit = 9999999,
		torquelimit = 9999999,
	})

	// ActiveConstraints[hConstraint] <- [hWeldEnt, hWeldEnt2]
	aConstraints.push(hConstraint)

	ActiveConstraints[hConstraint] <- [hWeldEnt, hWeldEnt2]
	hConstraint.DispatchSpawn()
	NetProps.SetPropEntity(hWeldEnt, "m_hConstraintEntity", hConstraint)
	NetProps.SetPropEntity(hWeldEnt2, "m_hConstraintEntity", hConstraint)
	SetParentEX(hConstraint, hWeldEnt)

	// MapWelds[hWeldEnt] <- hConstraint
	// MapWelds[hWeldEnt2] <- hConstraint

	// ActiveConstraints.push(hConstraint)
	printl("welded entity "+hWeldEnt+" to "+hWeldEnt2)
	hWeldEnt = null;
	return




}