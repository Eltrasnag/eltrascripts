IncludeScript("eltrasnag/zombieescape/zeitem.nut", this)
ItemName <- "Bucket of Oil"
ItemGrabString <- "|| Cover yourself in oil. Fly. ||"
IdleScale <- 0.9
FollowMode <- ZITEM_FOLLOWMODES.FLAG

oil_particle <- "cic_oilsplash"
oil_sound <- "eltra/splat.mp3"

function FireWeapon() {
	if (Disabled == true) {
		return
	}
	Disabled = true;
	QFireByHandle(hOwner, "RunScriptCode", "Say(self, `Step 1. Wait for it to rain.`, false)", 0.0)
	QFireByHandle(hOwner, "RunScriptCode", "Say(self, `Step 2. Cover yourself in Oil.`, false)", 1.5)
	QFireByHandle(hOwner, "RunScriptCode", "Say(self, `Step 3. Fly`, false)", 3)
	DropWeapon()
	QFireByHandle(self, "RunScriptCode", "Step3()", 3)


}

function Step3() {
	// DropWeapon()
	// Disabled = true
	local vOrigin = self.GetOrigin()

	// warning sound for players
	PlaySoundGlobal("eltra/cic/itemuse03.mp3")
	PlaySoundGlobal("eltra/cic/itemuse03.mp3")
	PlaySoundGlobal("eltra/cic/itemuse03.mp3")

	for (local ply; ply = Entities.FindByClassnameWithin(ply, "player", vOrigin, 300);) {
		DoEffect(oil_particle, ply.GetOrigin())
		QFireByHandle(ply, "color", "0 0 0");
		PlaySoundNPC(oil_sound, ply)
		// QFireByHandle(ply, "RunScriptCode", "self.SetGravity(0)", 0)
		ply.SetGravity(0.25)
		// PlaySoundEX("eltra/cic/itemuse03.mp3", ply.GetOrigin(), 100, 100, ply, 5000)

		// ply.SetMoveType(MOVETYPE_FLYGRAVITY, Constants.EMoveCollide.MOVECOLLIDE_FLY_BOUNCE)
		// QFireByHandle(ply, "RunScriptCode", "self.SetMoveType(Constants.EMoveType.MOVETYPE_FLYGRAVITY, Constants.EMoveCollide.MOVECOLLIDE_FLY_BOUNCE)", 10)
		QFireByHandle(ply, "RunScriptCode", "self.SetGravity(1)", 10)
		QFireByHandle(ply, "color", "255 255 255", 10);


	}
	self.Kill()
	// if (ValidEntity(hOwner)) {

	// }
}

// active mode positioning
iOffsetForward <- -7 // yeah
iOffsetLeft <- -0
iOffsetUp <- 2

