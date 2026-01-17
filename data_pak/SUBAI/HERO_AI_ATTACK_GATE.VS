// void, Obj h, Obj g
Hero  this;
Gate  gate;
Obj   obj;

this = h.AsHero();
gate = g.AsGate();

//pr("hero_ai_attack_gate.vs");
.FormSetupAndMoveTo( gate.pos, .sight, 0, true);
while( .HasPath() )
{
/*
	obj = .BestTargetInSquadSight();
	if( u.IsAlive && .IsValidTarget( u ))
	{
		.army.SetCommand( "idle" );
		while( u.IsAlive && .IsValidTarget( u ))
		{
			while( ! .GotoAttack( u, 1500, false ))
			{
				u = .BestTargetInSquadSight();
				if( ! u.IsAlive || ! .IsValidTarget( u )) break;
			}
			if( u.IsAlive && .IsValidTarget( u ))
				while( .Attack( u ));
			u = .BestTargetInSquadSight();
		}
		while(!.Stop(1000));
		.FormSetupAndMoveTo( gate.pos, .sight, 0);
	}
*/
	.FormKeepMoving (1500);
}
//pr("done moving in formation!");
.army.SetCommand("ai_attack_gate", g );
.AddCommand( false, "idle" );