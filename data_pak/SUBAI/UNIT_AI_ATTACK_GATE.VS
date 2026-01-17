// void, Obj u, Obj g
Unit this;
Gate gate;
Unit enemy;

//pr("unit_ai_attack_gate.vs started!");
this = u.AsUnit();
gate = g.AsGate();

if( ! .IsValidTarget( gate )) return;

// --- advance (copied)
while (1) 
{
/*
	u = .BestTargetInSquadSight();
	if(u.IsAlive())	
	{
		while (u.IsAlive() && .IsValidTarget(u)) 
		{
			while(!.GotoAttack(u, 1500, true, -1)) 
			{
				u = .BestTargetInSquadSight().AsUnit();
				if(!u.IsAlive() || !.IsValidTarget(u)) break;
			}
			if (u.IsAlive() && .IsValidTarget(u))
				while (.Attack(u)) if(!.IsVisible) .SetVisible(true);
			u = .BestTargetInSquadSight();
		}
	}
	else
*/
		if (.GotoAttack(gate, 2000, true, 2500)) break;
}
// --- stand ground and attack gate/enemies(if any)
while( 1 )
{
	enemy = .BestTargetInSquadSight().AsUnit();
	if( enemy.IsAlive && .IsValidTarget( enemy ))
	{
		if( !.Attack( enemy ))  // long live complete evaluation!
			{ if( ! .Attack( gate )) Sleep( 2000 ); }
		else
			 if(!.IsVisible) .SetVisible(true);
	}
	else
		{ if( ! .Attack( gate )) Sleep( 2000 ); else if(!.IsVisible) .SetVisible(true);}
}