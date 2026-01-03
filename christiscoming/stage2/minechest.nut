// minecraft chest which is used to dispense minor items (money, subheals, etc)
Context <- null

IsOpened <- false
IsLocked <- false
chest_anim_speed <- 0.5
function OnPostSpawn() {
	Context = GetContext(self)
	// self.KeyValueFromInt("solid", 3)
	self.ConnectOutput("OnTakeDamage", "OnChestHit")
	NetProps.SetPropInt(self, "m_takedamage", 1)
	// NetProps.SetPropBool(self, "m_bDamaged", true)
	if ("locked" in Context && Context.Locked == 1) {
		IsLocked = true
	}
}

function OnChestHit() {
	if (IsOpened || IsLocked) { // don't do anything if we're already opened or locked
		return
	}

	SetAnimation(self, "open") // open up
	QFireByHandle(self, "SetAnimation", "opened", chest_anim_speed)
	QFireByHandle(self, "SetDefaultAnimation", "opened", chest_anim_speed)

	IsOpened = true

	QFireByHandle(self, "FireUser1", "", chest_anim_speed) // Put all chest actions in onuser1 so it can be a part of hammer map ent logic
	AddThinkToEnt(self, "")
}

function Close() {
	SetAnimation(self, "close")
	QFireByHandle(self, "SetAnimation", "closed", chest_anim_speed)
	QFireByHandle(self, "SetDefaultAnimation", "closed", chest_anim_speed)
	QFireByHandle(self, "RunScriptCode", "IsOpened = false", chest_anim_speed)
}
function ChestThink() {

}