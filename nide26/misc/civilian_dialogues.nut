enum CIVILIAN_DIALOGUES {
	GENERIC,
	ANGRY,
	HURT,
	HAPPY
}

enum CDICT {
	SUBJECT,
	VERB,
	OBJECT,
	ADJECTIVE,
	ADVERB,
	PREPOSITION,
	CONJUNCTION,
	INTERJECTION,
	SLUR
}



::CIVILIAN_DICTIONARY  <- {
}

CIVILIAN_DICTIONARY[CDICT.SUBJECT] <- ["Taylor Swift", "Berke", "sneed", "Sephiroth", "rtv", "schwing", "cloud", "bahamut"]
CIVILIAN_DICTIONARY[CDICT.VERB] <- ["farted", "pooped", "ran to", "visited", "killed", "took", "fucked", "has sex", "speak", "healed", "did",
    "accept", "achieve", "act", "add", "admire", "admit", "advise", "affect", "agree", "aim",
    "allow", "answer", "appear", "apply", "argue", "arrive", "ask", "attack", "avoid", "awake",
    "be", "bake", "bear", "beat", "become", "begin", "believe", "belong", "bite", "blame",
    "bleed", "blink", "blow", "boil", "borrow", "bother", "bounce", "break", "breathe", "bring",
    "build", "burn", "burst", "bury", "buy", "calculate", "call", "care", "carry", "catch",
    "change", "charge", "chase", "cheat", "check", "cheer", "choose", "claim", "clean", "clear",
    "climb", "close", "clothe", "coach", "collect", "color", "come", "command", "compare", "compete",
    "complain", "complete", "concern", "confirm", "connect", "consider", "consist", "contain", "continue", "copy",
    "correct", "cost", "count", "cover", "create", "cross", "cry", "cut", "damage", "dance",
    "dare", "deal", "decide", "declare", "decorate", "decrease", "defeat", "defend", "define", "delay",
    "deliver", "depend", "describe", "desert", "deserve", "desire", "destroy", "determine", "develop", "die",
    "dig", "disappear", "discover", "discuss", "dislike", "display", "dive", "divide", "do", "draw",
    "dream", "dress", "drink", "drive", "drop", "dry", "earn", "eat", "educate", "employ",
    "encourage", "end", "enjoy", "enter", "establish", "estimate", "examine", "exist", "expect", "explain",
    "explore", "express", "face", "fail", "fall", "fear", "feed", "feel", "fight", "fill",
    "find", "finish", "fire", "fish", "fit", "fix", "fly", "follow", "forget", "forgive",
    "form", "freeze", "fry", "gather", "get", "give", "glow", "go", "grab", "graduate",
    "greet", "grow", "guard", "guess", "guide", "hammer", "hand", "happen", "hate", "have",
    "hear", "help", "hide", "hit", "hold", "hop", "hope", "hug", "hunt", "hurry",
    "hurt", "identify", "ignore", "imagine", "improve", "include", "increase", "influence", "inform", "injure",
    "insist", "install", "intend", "introduce", "invent", "invite", "jump", "keep", "kick", "kill",
    "kiss", "knit", "knock", "know", "laugh", "lay", "lead", "learn", "leave", "lend",
    "let", "lie", "light", "like", "listen", "live", "look", "lose", "love", "maintain",
    "make", "manage", "march", "mark", "marry", "match", "matter", "measure", "meet", "melt",
    "mention", "miss", "mix", "move", "name", "need", "notice", "obey", "obtain", "occur",
    "open", "order", "organize", "overcome", "own", "pack", "paint", "pass", "paste", "pause",
    "pay", "perform", "permit", "persuade", "pick", "play", "please", "point", "possess", "post",
    "pour", "practice", "pray", "prefer", "prepare", "present", "press", "pretend", "prevent", "produce",
    "promise", "protect", "prove", "provide", "pull", "pump", "push", "put", "question", "rain",
    "reach", "read", "realize", "receive", "recognize", "record", "reduce", "refer", "reflect", "refuse",
    "regret", "reject", "relax", "release", "rely", "remain", "remember", "remind", "remove", "repair",
    "repeat", "replace", "reply", "report", "request", "require", "rescue", "research", "rest", "return",
    "review", "ride", "ring", "rise", "risk", "rob", "rock", "roll", "run", "save",
    "say", "scare", "search", "see", "seek", "seem", "sell", "send", "separate", "serve",
    "set", "shake", "share", "shoot", "shop", "shout", "show", "shut", "sing", "sit",
    "sleep", "smell", "smile", "solve", "sound", "speak", "specify", "spend", "spoil", "spray",
    "stand", "start", "state", "stay", "stop", "store", "study", "succeed", "suffer", "suggest",
    "supply", "support", "suppose", "surprise", "survive", "take", "talk", "teach", "tell", "tend",
    "test", "thank", "think", "throw", "tie", "touch", "train", "transfer", "travel", "treat",
    "try", "turn", "understand", "unite", "use", "value", "visit", "wait", "wake", "walk",
    "want", "warn", "wash", "watch", "wear", "weigh", "welcome", "win", "wish", "wonder",
    "work", "worry", "write", "yawn", "yield", "mogging", "hopemaxx", "TND", "HTN", "MTN", "LTN"
]
CIVILIAN_DICTIONARY[CDICT.OBJECT] <- ["paranoid", "mako", "lms", "table of lies", "wonder house", "apple", "banana", "car", "dog", "elephant", "fork", "guitar", "house", "ice", "jacket", "kite", "lamp", "moon", "notebook", "orange", "piano", "quilt", "rainbow", "sun", "tree", "umbrella", "violin", "water", "xylophone", "yarn", "zebra", "airplane", "balloon", "candle", "dragon", "elevator", "feather", "giraffe", "hammock", "igloo", "jellyfish", "koala", "ladder", "mountain", "nail", "octopus", "penguin", "quasar", "river", "snowflake", "tiger", "unicorn", "volcano", "whale", "xylograph", "yacht", "zeppelin", "ant", "book", "cloud", "dolphin", "earthworm", "fire", "grass", "hammer", "island", "jigsaw", "kangaroo", "lemon", "mirror", "nest", "ocean", "pillow", "quill", "rock", "sandwich", "telescope", "umbrella", "violin", "waterfall", "xylophone", "yogurt", "zeppelin", "avocado", "bicycle", "cactus", "drum", "eagle", "feather", "garden", "honey", "igloo", "jelly", "kite", "lamp", "moon", "nest", "orange", "piano", "quilt", "rain", "sun", "tree", "umbrella", "violin", "water", "xylophone", "yarn", "zebra", "airplane", "balloon", "candle", "dragon", "elevator", "feather", "giraffe", "hammock", "igloo", "jellyfish", "koala", "ladder", "mountain", "nail", "octopus", "penguin", "quasar", "river", "snowflake", "tiger", "unicorn", "volcano", "whale", "xylograph", "yacht", "zeppelin", "ant", "book", "cloud", "dolphin", "earthworm", "fire", "grass", "hammer", "island", "jigsaw", "kangaroo", "lemon", "mirror", "nest", "ocean", "pillow", "quill", "rock", "sandwich", "telescope", "umbrella", "violin", "waterfall", "xylophone", "yogurt", "zeppelin", "avocado", "bicycle", "cactus", "drum", "eagle", "feather", "garden", "honey", "igloo", "jelly", "kite", "lamp", "moon", "nest", "orange", "piano", "quilt", "rain", "sun", "tree", "umbrella", "violin", "water"]
CIVILIAN_DICTIONARY[CDICT.ADJECTIVE] <- ["groyperous","wonderful", "smiley", "beautiful", "healing", "extremely", "almost", "quite", "just", "too", "enough", "very", "well", "virtually", "utterly", "totally", "thoroughly", "terribly", "strongly", "somewhat", "so", "simply", "scarcely", "really", "rather", "purely", "pretty", "practically", "positively", "perfectly", "nearly", "much", "most", "lots", "little", "less", "least", "intensely", "indeed", "incredibly", "how", "highly", "hardly", "greatly", "fully", "far", "fairly", "entirely", "enormously", "deeply", "decidedly", "completely", "barely", "badly", "awfully", "absolutely"]
CIVILIAN_DICTIONARY[CDICT.ADVERB] <- ["red", "raped", "black", "voregeous","could","could not", "gladly", "gently", "quietly", "safely", "truthfully", "warmly", "wildly", "carefully", "wisely", "hard", "fast", "straight", "well", "angrily", "boldly", "daringly", "accidentally", "anxiously", "awkwardly", "badly", "beautifully", "blindly", "bravely", "brightly", "busily", "calmly", "carelessly", "cautiously", "cheerfully", "clearly", "closely", "correctly", "courageously", "cruelly", "deliberately", "doubtfully", "eagerly", "easily", "elegantly", "enormously", "enthusiastically", "equally", "eventually", "exactly", "faithfully", "fatally", "fiercely", "fondly", "foolishly", "fortunately", "frankly", "frantically", "generously", "gracefully", "greedily", "happily", "hastily", "healthily", "honestly", "hungrily", "hurriedly", "inadequately", "ingeniously", "innocently", "inquisitively", "irritably", "joyously", "justly", "kindly", "lazily", "loosely", "loudly", "madly", "mortally", "mysteriously", "neatly", "nervously", "noisily", "obediently", "openly", "painfully", "patiently", "perfectly", "politely", "poorly", "powerfully", "promptly", "punctually", "quickly", "rapidly", "rarely", "really", "recklessly", "regularly", "reluctantly", "repeatedly", "rightfully", "roughly", "rudely", "sadly", "selfishly", "sensibly", "seriously", "sharply", "shyly", "silently", "sleepily", "slowly", "smoothly", "so", "softly", "solemnly", "speedily", "stealthily", "sternly", "stupidly", "successfully", "suddenly", "suspiciously", "swiftly", "tenderly", "tensely", "thoughtfully", "tightly", "unexpectedly", "victoriously", "violently", "vivaciously", "weakly", "wearily", ]
CIVILIAN_DICTIONARY[CDICT.PREPOSITION] <- ["poo"]
CIVILIAN_DICTIONARY[CDICT.CONJUNCTION] <- ["the", "of", "did", "they", "must","have","it","is","how", "does"]
CIVILIAN_DICTIONARY[CDICT.INTERJECTION] <- ["poo"]
CIVILIAN_DICTIONARY[CDICT.SLUR] <- [
    "fuck", "shit", "bitch", "asshole", "dick", "cunt", "piss", "bastard",
    "motherfucker", "cock", "twat", "whore", "slut", "douchebag", "arsehole",
    "wanker", "prick", "bollocks", "crap", "damn", "hell", "bloody", "sod",
    "tosspot", "nigga", "nigger", "chink", "kike", "fag", "dyke", "retard",
    "spastic", "tranny", "whore", "slut", "cum", "jizz", "pussy", "penis",
    "vagina", "boob", "tits", "dickhead", "arse", "bugger", "git", "knob",
    "bellend", "minge", "twatwaffle", "cockwomble", "fuckwit", "donkey",
    "muppet", "plonker", "slag", "tosser", "wank", "jerk", "dipshit", "shithead"
]
// ::CIVILIAN_DIALOGUE <- {
// 	GENERIC : []
// }




