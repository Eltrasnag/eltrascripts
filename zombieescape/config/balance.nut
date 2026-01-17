class_speeds <- {}


base_class_speeds <- {}
base_class_speeds[Constants.ETFClass.TF_CLASS_SCOUT] <- 400
base_class_speeds[Constants.ETFClass.TF_CLASS_SOLDIER] <- 240
base_class_speeds[Constants.ETFClass.TF_CLASS_PYRO] <- 300
base_class_speeds[Constants.ETFClass.TF_CLASS_DEMOMAN] <- 280
base_class_speeds[Constants.ETFClass.TF_CLASS_HEAVYWEAPONS] <- 230
base_class_speeds[Constants.ETFClass.TF_CLASS_ENGINEER] <- 300
base_class_speeds[Constants.ETFClass.TF_CLASS_MEDIC] <- 320
base_class_speeds[Constants.ETFClass.TF_CLASS_SNIPER] <- 300
base_class_speeds[Constants.ETFClass.TF_CLASS_SPY] <- 320

class_speeds[Constants.ETFClass.TF_CLASS_SCOUT] <- 292.50
class_speeds[Constants.ETFClass.TF_CLASS_SOLDIER] <- 256.50
class_speeds[Constants.ETFClass.TF_CLASS_PYRO] <- 270.00
class_speeds[Constants.ETFClass.TF_CLASS_DEMOMAN] <- 252.00
class_speeds[Constants.ETFClass.TF_CLASS_HEAVYWEAPONS] <- 256.50
class_speeds[Constants.ETFClass.TF_CLASS_ENGINEER] <-270.00
class_speeds[Constants.ETFClass.TF_CLASS_MEDIC] <- 282.50
class_speeds[Constants.ETFClass.TF_CLASS_SNIPER] <- 270.00
class_speeds[Constants.ETFClass.TF_CLASS_SPY] <- 288.00

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