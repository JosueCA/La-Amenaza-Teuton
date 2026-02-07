// void, Obj h

Hero this;
Obj  enemy;
Obj  enemy2;

this = h.AsHero;
while( 1 )
{
  bool bSleep = true;
	enemy = .BestTargetInSquadSight;
	if( enemy.IsAlive && .IsValidTarget( enemy ))
	{
		.AddCommand( true, "ai_killall");
		.AddCommand( true, "engage");
		return;
	}
	enemy = .BestTargetInGAIKA;
	if( enemy.IsAlive )
	{
		.FormSetupAndMoveTo( enemy, 0, 0, true );
		while( (.DistTo( enemy ) > .sight * 2 / 3 ) && enemy.IsAlive )
		{    
      bSleep = !.HasPath();
			.FormKeepMoving( 1500 );
			enemy2 = .BestTargetInSquadSight;
			if( enemy != enemy2 ) break;
		}
	}
	if (bSleep) Sleep(2000);
}