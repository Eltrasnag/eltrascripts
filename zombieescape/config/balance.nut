class_speeds <- {}
class_speeds[Constants.ETFClass.TF_CLASS_SCOUT] <- 0.985
class_speeds[Constants.ETFClass.TF_CLASS_SOLDIER] <- 1.05
class_speeds[Constants.ETFClass.TF_CLASS_PYRO] <- 1.05
class_speeds[Constants.ETFClass.TF_CLASS_DEMOMAN] <- 1.045
class_speeds[Constants.ETFClass.TF_CLASS_HEAVYWEAPONS] <- 1.05
class_speeds[Constants.ETFClass.TF_CLASS_ENGINEER] <- 1.05
class_speeds[Constants.ETFClass.TF_CLASS_MEDIC] <- 1.048
class_speeds[Constants.ETFClass.TF_CLASS_SNIPER] <- 1.045
class_speeds[Constants.ETFClass.TF_CLASS_SPY] <- 1.05

noconds <- []
// Below are the weapon balancing entries.

// Format is as follows:
// weaponname <- { damage_mult %, firing_speed_mult -%, reload_mult -%, clip_mult %, [ [a,b], [c,d] ] }

// extra attribute array format:
// [attribute name string, attribute value]

flamethrower <- [1, 2, 300, 2, [["mark for death", 10]]]
shotgun <- [1.2, 0.4, 0.4, 3]
shotgun_soldier <- shotgun
shotgun_pyro <- shotgun
shotgun_hwg <- shotgun
smg <- [0.5, 1, 1, 2]
powerjack <- [1,1,1,1, [["move speed bonus", 1.1], ["health on radius damage", 25], ["energy buff dmg taken multiplier", 40]]]
flaregun <- [1, 1, 1, 1, noconds, ]