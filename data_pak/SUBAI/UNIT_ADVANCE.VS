// void, Obj me, point pt

Unit this;
Obj u;

this = me.AsUnit();

while (1) 
{
	//pr("advance: searching for new enemy");
	u = .BestTargetInSquadSight();
	if(u.IsAlive())
	{
		if(u.maxattack > 0)	
		{
			.AddCommand(true, "advance", pt);
			.AddCommand(true, "engage");
			return;
		}
	} 
	
	//pr("advance: no target in sight - returning to source point!");
	if (.Goto(pt, 0, 2000, true, 0)) return;
	
}
