// void, Obj This

	Hero this;
	Obj u;
	point pt;

	this = This.AsHero ();
	pt = .pos;
	while(1)
	{
		u = .BestTargetInSquadSight();
		if(u.IsValid())
		{
			.AddCommand(true, "advance");
			.AddCommand(true, "engage");
			return;
		}
	}
 
