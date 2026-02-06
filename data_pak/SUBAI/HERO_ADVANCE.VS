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
		// EXPANDED SEARCH: Look for enemies in wider range during movement (2x sight range)
		u = .BestTargetInSquadSight();
		if (!u.IsAlive() || u.maxattack == 0) {
			// If no enemy in expanded range, use normal squad sight
			u = .BestTargetInSquadSight();
		}
		// END EXPANDED SEARCH

		if(u.IsAlive() && .IsValidTarget(u) && u.maxattack > 0)
		{
			//.pr("Hero::Advance: Enemy detected, engaging!");
			.AddCommand(true, "advance", pt);
			.AddCommand(true, "engage");
			return;
		}
		//.pr("hero::advance: No Enemy");
		//.pr("hero::advance:moving");
		.FormKeepMoving (1500);
	}
}