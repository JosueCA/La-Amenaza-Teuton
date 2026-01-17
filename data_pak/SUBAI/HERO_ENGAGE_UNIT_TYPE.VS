// void, Obj me, Obj target

Hero this;
Obj u;
int a;
str class;
this = me.AsHero();
class = target.class;


//.pr("hero::engage: looking for enemies");
.army.SetCommand("engage_unit_type", target);

u = .BestTargetInSquadSight(class);
if(u.IsAlive() && .IsValidTarget(u))
{
	//.pr("hero::engage: enemy found, ATTACK!!!");
	//.pr("hero::engage: everybody attack now");
	while(u.IsAlive() && .IsValidTarget(u))
	{
		//.pr("hero::engage: chasing");
		while(!.GotoAttack(u, 1500, false, -1))
		{
			u = .BestTargetInSquadSight(class);
			if(!u.IsAlive() || !.IsValidTarget(u))
			break;
		}
		//.pr("hero::engage: fighting");
		if (u.IsAlive && .IsValidTarget(u)) 
		{
			while(.Attack(u)) if(!.IsVisible) .SetVisible(true);
		}
		u = .BestTargetInSquadSight(class);
	}
	while(!.Stop(1000));
	//.pr("hero::engage: enemies killed");
}
Sleep(500); // Else the sneak command cycles, because of the delayed update of enemies in 'BestTargetInSquadSight'
