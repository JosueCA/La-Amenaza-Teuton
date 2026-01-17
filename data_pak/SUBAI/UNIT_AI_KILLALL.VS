// void, Obj u

Unit this;
this = u.AsUnit;

while (1)
{
	Obj enemy;
	Settlement set;

	enemy = .BestTargetInSquadSight;
	if (!enemy.IsValid)
	if (.GetSquad.AIDest == .GetSquad.GAIKAIn)
		enemy = .BestTargetInGAIKA.AsUnit;
	if (enemy.IsAlive)
	{
		if (.GotoAttack(enemy, 1500, true, -1))
			while (.Attack(enemy))
				if (!.IsVisible)
					.SetVisible(true);
		continue;
	}

	set = .GetSquad.AIDest.settlement;
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

	Sleep(1000);
}

Sleep(500);	// else commands "ai_killall" / "advance" cycle
