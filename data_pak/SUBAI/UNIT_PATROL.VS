// void, Obj This, point pt
Unit this;
Unit u;
this = This.AsUnit();

if(!.InHolder)
	.AddCommand(false, "patrol", .pos);
while(1) {
	//.pr("Unit::patrol::going");
	u = .BestTargetInSquadSight();
	if(u.IsAlive() && .IsValidTarget(u))
	{
		.AddCommand(true, "patrol", pt);
		.AddCommand(true, "engage");
		return;
	}
	else
	{
		if(.Goto (pt, 0, 2000, true, -1)) {
			Sleep(500);  // Else when Goto returns immediately there's an infinite loop of patrol commands (the software dies)
			break;
		}
		if(.TimeWithoutWalking() > 0) {
			Sleep(500);
			break;
		}
	}
}
//.pr("Unit::patrol: reached");
