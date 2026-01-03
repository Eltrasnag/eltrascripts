// track_name <- self.GetName() // this is stupid
track_name <- NetProps.GetPropString(self, "m_iszSound")

hBooster <- null

TrackNames <- {"li_locomotion" : "KYLIE MINOGUE - The Locomotion",
"li_toxicair" : "Eltra - Toxic Air",
"s2_earlyforecast" : "Eltra - Local Forecast",
"Endovus_2": "Eltra - ENDOVUS",
"scarystories": "ELTRASNAG - Scary Stories (pt. 1)",
"savestate": "ELTRASNAG - Save State",
"stardust_speedway": "SONIC CD - Stardust Speedway (Bad Future) [US]",
"sitstay": "Poppy - Sit / Stay",
"nothing_natural": "Lush - Nothing Natural",
"nightmusic": "Grimes - Nightmusic",
"tidal_tempest_02": "SONIC CD - Tidal Tempest (Bad Future) [US]",
"metallic_madness_rmx_2019": "SONIC CD - Metallic Madness [JP-RMX] ",
"un_owen_was_her": "ZUN - U.N.オーエンは彼女なのか？",
"halo_part1": "Poppy - Halo",
"halo_part2": "Poppy - Halo",
"hwc": "Liz Phair - Hot White Cum",
"little_planet": "SONIC CD - Little Planet [JP]",
"collision_chaos_good": "SONIC CD - Collision Chaos (Good Future) [US]",
"slus": "G-DARIUS - SLUS-00690_BGM1",
"wacky_workbench_bad": "SONIC CD - Wacky Workbench (Bad Future) [JP]",
"the_pink_room" : "Twin Peaks: Fire Walk With Me - The Pink Room",
"i_touch_myself" : "DIVINYLS - I Touch Myself",
"burning_rangers" : "BURNING RANGERS - BGM005",
"mus_stage1_santadead" : "SONIC 3D BLAST - GENE GADGET ZONE, ACT II (SATURN)",
"cic_mariah" : "Eltra - All Rise",
"cic_heat_rising" : "Eltra - Heat Rising",
"the_christmas_mountain" : "Eltra - Christmas Mountain Pass",
"familiar_factory": "Eltra - Re(port)ing for Duty",
"viscosity" : "Eltra - Viscosity (The Hydroplant)",
"anne_t_claus_was_him!!!" : "Eltra - N.T CLAWS WAS HIM?!!!",
"cic_act2start" : "Eltra - Premonition",
"li_boss01" : "Eltra - A Million Dogs + 1",
"cic_scannerwave" : "Eltra - Scannerwaves",
"cic_fb_dangerous" : "Eltra - Dangerous",
"cic_fb_coldletter" : "Eltra - Cold Letter",
"cic_fb_tidalbed" : "Eltra - Tidal Bed",
"cic_fb_staywithme" : "Eltra - Stay With Me (Part II.)",
}
XMODE_MUSIC_PITCH <- 80
XTrackReplacements <- {
	// stage 1
	"the_christmas_mountain" : "cic_fb_dangerous",
	"viscosity" : "cic_fb_coldletter",

	//stage 2
	"cic_act2start" : "cic_fb_tidalbed",
	"cic_heat_rising" : "",
} // subbing-list with details for xmode music replacements

const music_folder_path = "music/eltra/"

function Precache() {
	self.KeyValueFromInt("spawnflags", 17)
}
function GetPlayFile() { // what did he mean by this\

	if (XMODE) {
		local foundtrack = false
		foreach (track, replacement in XTrackReplacements) {
			local reg = regexp(track)
			printl("Searching for XMode track "+track)
			if (reg.search(track_name)) {
				if (replacement.len() == 0) { // allows for music deletions in xmode to let the longer tracks play fully
					print("MUSICPLAYER: Deleting track "+track_name)
					self.Kill()
					return
				}
				printl("Found XMode replacement! Subbing track "+track+" for "+replacement)
				NetProps.SetPropString(self, "m_iszSound", music_folder_path + replacement + ".mp3")
				track_name = replacement
				foundtrack  = true
			}

		}

		self.KeyValueFromInt("pitch", XMODE_MUSIC_PITCH)
		self.KeyValueFromInt("pitchstart", XMODE_MUSIC_PITCH)
		if (foundtrack == false) {
				self.KeyValueFromInt("preset", 15)
		}
	}

	foreach (title, details in TrackNames) {
		local reg = regexp(title)
		if (reg.search(track_name)) {

			track_name = title
		}
	}
	// local mp3regex = regexp(".mp3")
	// local pathregex = regexp("music/eltra/")
	// local p1 = pathregex.search(track_name)
	// track_name = track_name.slice(p1.end, track_name.len())[1]


	// local p2 = mp3regex.search(track_name)
	// track_name = track_name.slice(p2.end, track_name.len())[0]

	// track_name = track_name.slice
	// printl("Track name: "+track_name)


	if (track_name in TrackNames) {
		local snd_name = "#" + music_folder_path + track_name + ".mp3"
		PrecacheSound(snd_name)
		self.KeyValueFromString("message", "#" + music_folder_path + track_name + ".mp3")
		if (XMODE) {
			hBooster = Spawn("ambient_generic", {
				targetname = self.GetName(),
				message = snd_name,
				spawnflags = 17,
				health = 10,
			})
			hBooster.KeyValueFromInt("pitch", XMODE_MUSIC_PITCH)
			hBooster.KeyValueFromInt("pitchstart", XMODE_MUSIC_PITCH)
		}
	}

}

// roundend <- {
// 		function OnGameEvent_scorestats_accumulated_update(_) {

// 			MapSay("THE EVENT")

// 			self.AcceptInput("Volume","0",null,null)
// 			// NetProps.SetPropBool(self, "m_fLooping", true )
// 			// QFire("ambient_generic*", "Volume", "0")
// 		}
// }

function OnPostSpawn() {
	// ShittyListenHooks(roundend)
	QFireByHandle(self, RunScriptCode, "GetPlayFile()", 0.1) // add a tiny delay so that we can execute after xmode if applicable



		// NetProps.SetPropBool(self, "m_fLooping", false )

}

function CreateMusicText(pretty_info) {
	local hTextInfo = SpawnEntityFromTable("game_text", {
		color = "51 112 255",
		fadein = 0.5,
		fadeout = 1,
		holdtime = 2.25,
		message = "| Now playing: "+pretty_info+" |"
		channel = 0,
		x = 0.02,
		y = 0.25,
		spawnflags = 1,
	})

	hTextInfo.AcceptInput("Display", "", null, null)
	QFireByHandle(hTextInfo, "Kill")
}

function InputPlaySound()
{

	if (track_name in TrackNames) {

		CreateMusicText(TrackNames[track_name])
	}
	if (XMODE && hBooster)
		QAcceptInput(hBooster, "Playsound")
	NetProps.SetPropBool(self, "m_fLooping", false )
	return true
}

function InputFireUser1() {
	QFireByHandle(self, "PlaySound")
	if (XMODE && hBooster)
		QAcceptInput(hBooster, "Playsound")
}

// Inputfireuser1 <- InputFireUser1


