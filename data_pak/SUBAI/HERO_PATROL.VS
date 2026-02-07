// void, Obj This, point pt
{
  Hero this;
  Obj u;
  int lastHealthEffectTime;

  this = This.AsHero ();
  lastHealthEffectTime = 0;
  //.pr("Hero::Patrol");
  .AddCommand(false, "patrol", .pos);

  //.pr("Hero::patroling");
  {
    .FormSetupAndMoveTo (pt, 0, 0, true);
	//.pr("Hero::Patrol::move setup");
    while(.HasPath())
    {
	  //.pr("Hero::moving");
      .FormKeepMoving (1500);

	  // Monitoreo de salud
	  if (.health > 0 && .health < (.maxhealth / 2))
	  {
		  if (GetTime() - lastHealthEffectTime > 250)
		  {
			  CreateFeedback("Damage2", .AsUnit());
			  lastHealthEffectTime = GetTime();
		  }
	  }

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
					while (.Attack(u))
					{
						if(!.IsVisible)
							.SetVisible(true);

						// Monitoreo de salud durante combate
						if (.health > 0 && .health < (.maxhealth / 2))
						{
							if (GetTime() - lastHealthEffectTime > 250)
							{
								CreateFeedback("Damage2", .AsUnit());
								lastHealthEffectTime = GetTime();
							}
						}
					}
				}
				u = .BestTargetInSquadSight();
			}
		    .FormSetupAndMoveTo (pt, 0, 0, true);
		}
		//.pr("Hero::Patrol::No Enemy");
	  }
    }
}
