IncludeScript(GUY_SCRIPT_BASE)

str_Name <- "Mrs. Betty \"Betsy\" Business"
i_Sex <- 0
function SpawnAction() {

}

i_Progress <- 0

bettytalk <- ["Hi guys. UIts really late out!! Do you want to go to sleep. I can give yo motel rooms!!", "Really its quite simple: go into the hotel room !!! !! And then press USE KEY (It is usually the 'E' button on your 'Key-Board') on THE BED!!!!!!", "OK Thats all gusy. Im unlocking the hotel doors now...", "I Heard there was Zombies apocalypse on the news,... So dont let them in if the y are here okay. Or you might get....... Eaten"]

function OnPlayerUse(activator) {
	switch (i_Progress) {
		case 0:
			SpeakLine(bettytalk[0])
			RunScriptCode(self, "SpeakLine(bettytalk[1])", 3)
			RunScriptCode(self, "SpeakLine(bettytalk[2])", 6)
			RunScriptCode(self, "SpeakLine(bettytalk[3])", 9)

			QFire("motel_doors", "Unlock", "", 6)
			i_Progress++
		break;
		case 1:
			i_Progress++
		break;
			SpeakLine("Really its quite simple: go into the hotel room !!! !!")
		default:
			break;
	}
}



