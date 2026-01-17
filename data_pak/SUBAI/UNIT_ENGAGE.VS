// void, Obj me

	Unit this;
	Obj u;

	this = me.AsUnit();
	//pr("engage: searching for new enemy");
	u = .BestTargetInSquadSight();
	if(u.IsAlive())	
	{
		//pr("engage: target found!");
		while (u.IsAlive() && .IsValidTarget(u)) 
		{
			Sleep(rand(100)); // Disperse the times
			while(!.GotoAttack(u, 1500, true, -1)) 
			{
				//pr("engage: approaching target!");
				u = .BestTargetInSquadSight();
				if(!u.IsAlive() || !.IsValidTarget(u)) break;
			}
			//pr("engage: attacking target!");
			if (u.IsAlive() && .IsValidTarget(u))
			{
				while (.Attack(u)) if(!.IsVisible) .SetVisible(true);
			}
			u = .BestTargetInSquadSight();
		}
	} 
