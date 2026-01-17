// void, Obj me

Unit this, u;

this = me.AsUnit();
while (!.Stop(1000));

u = .BestTargetForPos();
while( 1 )
{
	while(u.IsAlive())
	{
		while(.Attack(u)) if(!.IsVisible) .SetVisible(true);
		u = .BestTargetForPos();
	}
	.Idle(2000);
	u = .BestTargetForPos();
}
