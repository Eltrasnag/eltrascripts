function OnPostSpawn() {
    AddThinkToEnt(self, "Think")
}

function Think() {
    local fan_string = "FAN STRENGTH: \n        " + (iFanSpeed * 1000)
    self.KeyValueFromString("message", fan_string)
    CleanString(fan_string)
    return 0.25
}