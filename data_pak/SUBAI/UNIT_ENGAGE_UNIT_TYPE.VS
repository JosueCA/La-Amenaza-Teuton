// void, Obj me, Obj tgt

Unit this;
Obj u;
str class;
class = tgt.class;

this = me.AsUnit();
//pr("engage: searching for new enemy");
u = .BestTargetInSquadSight(class);

	//pr("engage: searching for new enemy");

	u = .BestTargetInSquadSight(class);
	if(u.IsAlive())	
	{
		//pr("engage: target found!");
		while (u.IsAlive() && .IsValidTarget(u)) 
		{
			while(!.GotoAttack(u, 1500, true, -1)) 
			{
				//pr("engage: approaching target!");
				u = .BestTargetInSquadSight(class);
				if(!u.IsAlive() || !.IsValidTarget(u)) break;
			}
			//pr("engage: attacking target!");
			if (u.IsAlive() && .IsValidTarget(u))
			{
				while (.Attack(u)) if(!.IsVisible) .SetVisible(true);
			}
			u = .BestTargetInSquadSight(class);
		}
	} 
