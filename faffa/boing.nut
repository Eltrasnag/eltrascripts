function boing() //boing
{
    if (activator!=null&&activator.IsValid())
    {
        local av = activator.GetAbsVelocity()
        // local ac = av.Norm()*0.1
        local ea = activator.EyeAngles()

		activator.SetAbsVelocity(Vector(av.x * 1.2, av.y * 1.2, clamp(av.z*-1.5, 100, 1000)))
		// else
		// {
			// activator.SetAbsVelocity(av * -0.9)
		// }
        EmitAmbientSoundOn("eltra/boing.mp3", 100.00, 100, RandomInt(90, 110), activator);
        activator.ViewPunch(QAngle(av.z*0.05, 0, 0));
        ClientPrint(activator, 4, "I LOVE TO PLAY WITH BALLS IN THE BALL PIT! HOORAY!")
        DispatchParticleEffect("doublejump_puff", activator.GetOrigin()+Vector(0,0,10), Vector(0,0,0))
    }
}