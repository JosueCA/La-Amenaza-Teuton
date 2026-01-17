// void, Obj me
Ship  this;
Unit  u;
point pt;

this = me.AsShip();
if (.IsBuilding())
{
	while( .IsBuilding()) Sleep(100);
	while(!.Goto(.FindPointToStay(), 0, 2000, false, -1))
		if (.TimeWithoutWalking>0)
			break;
}
else
{
	while (!.Stop(1000));
	Sleep( rand(700));
}

while(1)
{
	if (.HasAiTransport)
    if (.UnitsCount <= 0)
      .ClearAiTransport;
    else {
		  .AddCommand( true, "aitransport" );
		  return;
	  }
	u = .BestTargetInSquadSight();
	if( u.IsAlive() )
	{
		.AddCommand( true, "advance", .pos );
		return;
	}
	else
	{
		if (.Stop(2000))
		{
			.Idle();
		}
	}
}