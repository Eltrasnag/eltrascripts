function MoveCheck()
{
    local vel = activator.GetAbsVelocity()
    if (vel.x > 0 || vel.y > 0 || vel.z > 0) //im lviing in the state of despeeration
    {
        activator.TakeDamage(999999, 3, null);
    }
}