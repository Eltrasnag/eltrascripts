
hYesButton <- null
hNoButton <- null
hTimerText <- null
hText <- null
hPanel <- null

const BJORK_PUNISHMENT_SOUND = "eltra/bjork_pulverization.mp3"

enum BSEL {
	YES = 0,
	NO = 1
}

flWaitTime <- 0
flKillTime <- 10.0

iQuestions <- 0

hQuizPlayer <- null

bAnswered <- false

strRiddle <- null
iAnswer <- null
iCorrectAnswer <- null

function OnPostSpawn() {
	hYesButton = Entities.FindByName(null, "bjorkbutton_yes")
	hNoButton = Entities.FindByName(null, "bjorkbutton_no")
	hTimerText = Entities.FindByName(null, "bjorktimer")
	hText = Entities.FindByName(null, "bjorktext")
	hPanel = Entities.FindByName(null, "bjorkpanel")

	// self.AcceptInput("Open", "", null, null)
	hNoButton.ConnectOutput("OnPressed", "PressNo")
	hYesButton.ConnectOutput("OnPressed", "PressYes")
	hYesButton.DisableDraw()
	hNoButton.DisableDraw()

}

function StartQuiz(activator) {

	if (ValidEntity(activator)) {
		// self.Ac
		hPanel.DisableDraw()
		hPanel.AcceptInput("Lock","",null,null)
		self.AcceptInput("Open", "", null, null)
		hQuizPlayer = activator
		QFireByHandle(self, "RunScriptCode", "DoQuizQuestion()",3,null,null)
		return
	}


}

function DoQuizQuestion() {
	bAnswered = false
	flWaitTime = 0
	hYesButton.EnableDraw()
	hNoButton.EnableDraw()
	switch (RandomInt(0, 12)) {
		case 1:
			strRiddle = "Does bird fly with wounded wing"
			iCorrectAnswer = BSEL.YES
			break;
		case 2:
			strRiddle = "Can chocolate flower be grown within  Iceland"
			iCorrectAnswer = BSEL.NO
			break;
		case 3:
			strRiddle = "Does taylor swift have 20 ex boy friend"
			iCorrectAnswer = BSEL.NO
			break;
		case 4:
			strRiddle = "Is peter grififng bi sexual"
			iCorrectAnswer = BSEL.YES
			break;
		case 5:
			strRiddle = "Are you enjoying"
			iCorrectAnswer = BSEL.YES
			break;
		case 6:
			strRiddle = "Does the white wing dove siung the song sounds like she singing baby"
			iCorrectAnswer = BSEL.YES
			break;
		case 7:
			strRiddle = "Was i born November 22, 1965"
			iCorrectAnswer = BSEL.NO
			break;
		case 8:
			strRiddle = "Yes"
			iCorrectAnswer = BSEL.YES
			break;
		case 9:
			local number1 = RandomInt(1,10)
			local number2 = RandomInt(1,10)
			local sum = number1 + number2
			strRiddle = "Is it true that " + number1.tostring() + " and " + number2.tostring() + " make " + sum.tostring()
			iCorrectAnswer = BSEL.YES
			break;
		case 10:
			local number1 = RandomInt(1,10)
			local number2 = RandomInt(1,10)
			local sum = number1 + number2 + RandomInt(-2,2)
			strRiddle = "Is it true that " + number1.tostring() + " and " + number2.tostring() + " make " + sum.tostring()
			iCorrectAnswer = BSEL.NO
		case 11:
			local number1 = RandomInt(0,10)
			local number2 = RandomInt(0,10)
			local product = number1 * number2
			strRiddle = "Is it true that " + number1.tostring() + " multiply with " + number2.tostring() + " make product " + product.tostring()
			iCorrectAnswer = BSEL.YES
			break;
		case 12:
			local number1 = RandomInt(0,10)
			local number2 = RandomInt(0,10)
			local product = number1 * number2 + RandomInt(-2,2)
			strRiddle = "Is it true that " + number1.tostring() + " multiply with " + number2.tostring() + " make product " + product.tostring()
			iCorrectAnswer = BSEL.YES
			break;
		case 13:
			strRiddle = "Can chocolate flower be grown within  Iceland ?"
			iCorrectAnswer = BSEL.NO
			break;
		case 14:
			strRiddle = "Can chocolate flower be grown within  Iceland ?"
			iCorrectAnswer = BSEL.NO
			break;
		case 15:
			strRiddle = "Can chocolate flower be grown within  Iceland ?"
			iCorrectAnswer = BSEL.NO
			break;
		case 16:
			strRiddle = "Can chocolate flower be grown within  Iceland ?"
			iCorrectAnswer = BSEL.NO
			break;
		case 17:
			strRiddle = "Can chocolate flower be grown within  Iceland ?"
			iCorrectAnswer = BSEL.NO
			break;
		case 18:
			strRiddle = "Can chocolate flower be grown within  Iceland ?"
			iCorrectAnswer = BSEL.NO
			break;
		case 19:
			strRiddle = "Can chocolate flower be grown within  Iceland ?"
			iCorrectAnswer = BSEL.NO
			break;
		case 20:
			strRiddle = "Can chocolate flower be grown within  Iceland ?"
			iCorrectAnswer = BSEL.NO
			break;
		default:
			break;
	}
	MapSay(strRiddle, "BjÖrk")
	hYesButton.AcceptInput("Unlock","",null,null)
	hNoButton.AcceptInput("Unlock","",null,null)

	AddThinkToEnt(self, "QuestionThink")
}

function PressYes(activator) {

	if (activator == hQuizPlayer) {
		hYesButton.AcceptInput("Lock","",null,null)
		hNoButton.AcceptInput("Lock","",null,null)
		printl("Pressed yes")
		iAnswer = BSEL.YES
		bAnswered = true
		hNoButton.DisableDraw()

	}
	else {
		Punishment(activator)
	}


}

function PressNo(activator) {
	if (activator == hQuizPlayer) {
		hYesButton.AcceptInput("Lock","",null,null)
		hNoButton.AcceptInput("Lock","",null,null)
		printl("pressed no")
		iAnswer = BSEL.NO
		bAnswered = true
		hYesButton.DisableDraw()
	}
	else {
		Punishment(activator)
	}
}

function Reset() {
	self.AcceptInput("Close", "", null, null)
	AddThinkToEnt(self, "");
	hQuizPlayer = null;
	iQuestions = 0
	hPanel.EnableDraw()
	hPanel.AcceptInput("Unlock","",null,null)
	self.AcceptInput("Open", "", null, null)
	hYesButton.DisableDraw()
	hNoButton.DisableDraw()
}

function QuestionThink() {

	if (flWaitTime == flKillTime) {
		Punishment(hQuizPlayer)
		Reset()
		return
	}

	if (bAnswered) {
		AddThinkToEnt(self, "")
		if (iAnswer == iCorrectAnswer) {
			Success()

			return
		}
		Punishment(hQuizPlayer)
		Reset()
		return
	}

	flWaitTime++
	hTimerText.KeyValueFromString("message", floor(flKillTime - flWaitTime).tostring())
	hText.KeyValueFromString("message", strRiddle)
	PlaySoundEX("weapons/grenade/tick1.wav", hTimerText.GetOrigin())
	return 1
}

function Punishment(hPlayer) {
	if (ValidEntity(hPlayer)) {

		PrecacheSound(BJORK_PUNISHMENT_SOUND)
		PlaySoundEX(BJORK_PUNISHMENT_SOUND, hPlayer.GetOrigin())
		PrecacheSound("weapons/physcannon/energy_sing_explosion2.wav")
		PlaySoundEX("weapons/physcannon/energy_sing_explosion2.wav", hPlayer.GetOrigin())
		hPlayer.TakeDamage(99999999, 256, null)
	}
}

function Success() {
	flWaitTime = 0
	iQuestions++
	switch (RandomInt(0,9)) {
		case 0:
			MapSay("Fantastic", "BjÖrk")
			break;
		case 1:
			MapSay("Incredible", "BjÖrk")
			break;
		case 2:
			MapSay("Wonderful", "BjÖrk")
			break;
		case 3:
			MapSay("Frabjous", "BjÖrk")
			break;
		case 4:
			MapSay("Marvellous", "BjÖrk")
			break;
		case 5:
			MapSay("Supernatural", "BjÖrk")
			break;
		case 6:
			MapSay("Miraculous", "BjÖrk")
			break;
		case 7:
			MapSay("Unprecedented", "BjÖrk")
			break;
		case 8:
			MapSay("Prodigious", "BjÖrk")
			break;
		case 9:
			MapSay("Greatful grape fruit", "BjÖrk")
			break;
		default:
			break;
	}

	if (iQuestions < 3) {
		MapSay("I have " + (3 - iQuestions).tostring() + " riddle left to tell you .", "BjÖrk")
		QFireByHandle(self, "RunScriptCode", "DoQuizQuestion()",2,null,null)

	}
	else {
		MapSay("Wow ! uou have passed my riddle . I will disable the genertor now. Good bye", "BÖjrk")
		self.AcceptInput("Close","",null,null)
		hYesButton.Kill()
		hNoButton.Kill()
		hText.Kill()
		hTimerText.Kill()
		QFire("s2_laserwall","Kill","",4.0,null)
		QFire("s2_laserwall_sfx","StopSound","",4.0,null)
		QFire("s2_laserwall_sfx","Kill","",5.0,null)
	}
	SpawnMoney(hQuizPlayer.GetOrigin())
	SpawnMoney(hQuizPlayer.GetOrigin())
	SpawnMoney(hQuizPlayer.GetOrigin())
	SpawnMoney(hQuizPlayer.GetOrigin())
	SpawnMoney(hQuizPlayer.GetOrigin())
}