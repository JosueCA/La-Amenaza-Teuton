// void, Obj This

Hero this;
Obj u;
point ptStart;

this = This.AsHero;
ptStart = .pos;

//.pr("hero::engage: looking for enemies");

u = .BestTargetInSquadSight;
if (u.IsAlive)
if (.IsValidTarget(u))
{
	//.pr("hero::engage: enemy found, ATTACK!!!");
	//.pr("hero::engage: everybody attack now");
	.army.SetCommand("engage");
	while (1)
	{
		//.pr("hero::engage: chasing");
		while (!.GotoAttack(u, 1500, false, -1))
		{
			u = .BestTargetInSquadSight;
			if (!u.IsAlive) break;
			if (!.IsValidTarget(u)) break;
			if (.DistTo(ptStart) > 1000)
				break;
		}

		//.pr("hero::engage: fighting");
		if (u.IsAlive)
		if (.IsValidTarget(u))
			while (.Attack(u))
				if (!.IsVisible)
					.SetVisible(true);

		//if (GetTime - nStartTime > 1000) break;

		u = .BestTargetInSquadSight;
		if (!u.IsAlive)	break;
		if (!.IsValidTarget(u))	break;
		if (.DistTo(ptStart) > 1000)
			break;
	}
	
	while (!.Stop(1000));
	//.pr("hero::engage: enemies killed");
}

Sleep(500); // Else the sneak command cycles, because of the delayed update of enemies in 'BestTargetInSquadSight'
