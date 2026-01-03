function SpeedTrap()
{
    // printl(activator.GetAbsVelocity().z)
    if (activator.GetAbsVelocity().z < -1000)
    {
        PrecacheScriptSound("sf.falldeath")
        EmitSoundOn("sf.falldeath", activator)
        // printl("you will die")
        activator.TakeDamage(999999, 3, activator)
    }
}
