// void, Obj This, point pt
{
	Hero this;
	Obj u;

	this = This.AsHero();
	//.pr("hero::advance : move setup");
	.FormSetupAndMoveTo (pt, 0, 0, true);
	// Wait for army to exit
	while(!.IsArmyOutside())
		.FormKeepMoving(500);
	while(.HasPath())
	{
		//.pr("Hero::Advance:Looking for enemys");
		u = .BestTargetInSquadSight();
		if(u.IsAlive() && .IsValidTarget(u))
		if(u.maxattack > 0)
		{
			.AddCommand(true, "advance", pt);
			.AddCommand(true, "engage");
			return;
		}
		//.pr("hero::advance: No Enemy");
		//.pr("hero::advance:moving");
		.FormKeepMoving (1500);
	}	

}
