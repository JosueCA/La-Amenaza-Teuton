// void, Obj This, point pt
{
  Hero this;
  Obj u;
  this = This.AsHero ();
  //.pr("Hero::Patrol");
  .AddCommand(false, "patrol", .posRH);

  //.pr("Hero::patroling");
  {
    .FormSetupAndMoveTo (pt, 0, 0, true);
	//.pr("Hero::Patrol::move setup");
    while(.HasPath())
    {
	  //.pr("Hero::moving");
      .FormKeepMoving (1500);
  	  //.pr("Hero::Patrol::Looking for enemys");
	  u = .BestTargetInSquadSight();
		if(u.IsValid)
		{
			//.pr("Hero::Patrol::Enemy Found, ATTACK!!!");
			while(u.IsValid)
			{
				//.pr("Hero::patrol: Everybody attack now");
				.army.SetCommand("idle");
				while(!.GotoAttack(u, 1500, false, -1))
				{
					u = .BestTargetInSquadSight();
					if(!u.IsAlive())
						break;
				}
				//.pr("Hero::patrol: fighting");
				
				if (u.IsAlive && .IsValidTarget(u))
				{
					while (.Attack(u)) if(!.IsVisible)	.SetVisible(true);

				}
				u = .BestTargetInSquadSight();
			}											
		    .FormSetupAndMoveTo (pt, 0, 0, true);
		}
		//.pr("Hero::Patrol::No Enemy");
	  }
    }
}
