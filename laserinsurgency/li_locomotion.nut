flBeatTime <- 0.4347826086956522;
// flBarLength <- 7.144;
flBarLength <- 1.739130434782609;
flAudioOffset <- 0.162
// flAudioOffset <- 15.0 // just start at first verse
const MUS_LOCOMOTION_PATH = "music/eltra/li_locomotion.mp3"
hMusLocomotion <- null
flNextCycleTime <- 0
flLocoStartTime <- 0
iLocoBarCount <- 0
function StartBoss() {
	flLocoStartTime = Time()
	hMusLocomotion = MakeMusic(MUS_LOCOMOTION_PATH)
	QFireByHandle(hMusLocomotion, "PlaySound", "", 0.0, null, null);
	QFireByHandle(self, "RunScriptCode", "AddThinkToEnt(self,`LocoThink`)", flAudioOffset, null, null);

	print("locomotion begins.");

}

function JumpBack() {
	MapSay("JUMP BACK!")
	QFire("loco_jumpback_hurter", "FireUser1", "", BeatDelay(8), null)
}

function BeatDelay(x) {
	return flBeatTime * x
}

function ToLeft() {
	MapSay("TO THE LEFT!")
	QFire("loco_left_trigger", "FireUser1", "", BeatDelay(8), null)
}

function ToRight() {
	MapSay("TO THE RIGHT!")
	QFire("loco_right_trigger", "FireUser1", "", BeatDelay(8), null)
}

function Locomote() {
	printl("welcome to bar " + iLocoBarCount.tostring());

	switch (iLocoBarCount) {
		case 1:
			print("welcome to bar 1")
			break;
		case 10:
			MapSay("EVERYBODY'S DOING A BRAND NEW DANCE NOW...")
			break;
		case 23:
			MapSayDelayed("DO THE LOCOMOTION WITH ME!",BeatDelay(0))
			break;
		case 26: // swing ya hips now
			ToLeft()
			break;
		case 28: // jump up
			JumpUp()
			break;
		case 29: // jump back
			JumpBack()
			break;
		case 30: // well i think u got the nack
			MapSay("WOW!!!!")
			MapSayDelayed("I THINK YOU'VE GOT THE KNACK!!!", 0.1)
			break;

		default:
			break;
	}
}

function LetsMakeAChainNow() {
	MapSay("LET'S MAKE A CHAIN NOW!")

	QFire("loco_chain_mover", "FireUser1", "", BeatDelay(8), null);
}

function ChainCull() { // should berryboy live?
	for (local player = null; player = FindByClassname(player, "player"); ) {
		if (player.Locomotion_ChainNow != null && player.Locomotion_ChainNow == true) {
			print("player should LIVE")
				continue
			}
			print("player should DIE")
	}
}

function JumpUp() {
	MapSay("JUMP UP!")
	QFire("loco_jumpup_trigger", "FireUser1", "", BeatDelay(4), null)
}
function LocoThink() {
	local flCurTime = Time()
	if (flNextCycleTime != null && Time() >= flNextCycleTime) {
		flNextCycleTime = flCurTime + flBarLength
		print("dooo the locomotion")
		iLocoBarCount++
		Locomote()
	}


	// this is prrrobably very bad :3


	// do {
	// 	MapSay("LOCOMOTE TO THE LEFT");
	// }
	// while (flCurTime == (flLocoStartTime + 44.12));



	switch (flCurTime) {
		case 44.129:
			break;
		case 2:
			break;
		default:
			break;
	}
}

function LocoHopFX(activator) {
	PlaySound("eltra/small_hop01.mp3",activator.GetOrigin())
}