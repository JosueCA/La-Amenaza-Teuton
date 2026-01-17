// void, Obj me

// This scripts guards a location
// The unit is very aggressive and fights any enemies in sight
// When there are no enemies it goes back to its original location

Unit this, u;
point pt;
bool bWasInHolder;  
  
this = me.AsUnit();
//.pr("unit::guard: stoping");
while (!.Stop(1000));
pt = .posRH;
//.pr("unit::guard: stoped");
{
	//.pr("unit: guard: guarding location");
	while(1)
	{
	  u = .BestTargetInSquadSight();
  	  if(u.IsValid())
	  {
		//.pr("unit::guard : Enemy! ATTACK!");
		while(u.IsValid())
		{
			//.pr("unit::guard: Going...");
			while(!.GotoAttack(u, 1500, true, -1))
			{
				u = .BestTargetInSquadSight();
				if(!u.IsAlive() || !.IsValidTarget(u))
					break;
			}
			//.pr("unit::guard: Fighting...");
			if (u.IsAlive() && .IsValidTarget(u))
			{
				while (.Attack(u)) if(!.IsVisible) .SetVisible(true);
			}
			u = .BestTargetInSquadSight();
		}
	  }	else
	  {
		if(.Goto(pt, .range, 2000, true, 0))
			.Idle(2000);
	  }
    }
}