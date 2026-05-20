IncludeScript("eltrasnag/nide26/npc/people/base.nut", this)

function SpawnAction() {
	str_Name <- "TestGuy"

}
function OnPlayerUse(ply) {
	if (ply.GetTeam() == TEAMS.HUMANS) {
		// STORY.DoStoryScene("testguy_1")
		SpeakLine("HELLO MY FRIEND !!!!!!!!!!!!!!!!!")
	}
}