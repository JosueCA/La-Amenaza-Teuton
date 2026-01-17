// void, Obj h

Hero this;
this = h.AsHero;

while (.IsAlive)
{
	Obj enemy;
	bool bSleep = true;
	bool bEnemy = false;

	enemy = .BestTargetInSquadSight;
	if (enemy.IsAlive)
	if (.IsValidTarget(enemy))
	{
		.AddCommand(true, "ai_killall");
		.AddCommand(true, "engage");
		return;
	}
	
	if (.GetSquad.AIDest == .GetSquad.GAIKAIn)
	{
		enemy = .BestTargetInGAIKA;
		if (enemy.IsAlive)
		{
			bEnemy = true;
			.FormSetupAndMoveTo(enemy, 0, 0, true);
			while (enemy.IsAlive)
			{
				if (.DistTo(enemy) <= .sight * 2 / 3)
					break;
				bSleep = !.HasPath;
				.FormKeepMoving(1500);
				if (.BestTargetInSquadSight != enemy)
					break;
			}
		}
	}
	if (!bEnemy)
	{
		Settlement set; set = .GetSquad.AIDest.settlement;
		if (set.IsValid) {
			.AddCommand(true, "ai_killall");
			.AddCommand(true, "advance", set.GetCentralBuilding.pos);
			break;
		}
		if (.GetSquad.AIDest != .GetSquad.GAIKAIn) {
			.AddCommand(true, "ai_killall");
			.AddCommand(true, "advance", .GetSquad.AIDest.Center);
			break;
		}
	}
	if (bSleep) Sleep(2000);
}

Sleep(500);	// else commands "ai_killall" / "advance" cycle
