// void, Obj This

Hero this;
int i;

this = This.AsHero;

//.army.SetCommand("idle");
for (i = 0; i<.army.count; i+=1)
	if (.army[i].command == "form_move")
		.army[i].SetCommand("idle");

while(!.Stop(1000));
//.pr("Hero::Idle");
while(1)
{
	if (.IsVisible)
	{
		Obj u; u = .BestTargetInSquadSight;
		if (u.IsValid)
		if (u.maxattack > 0)
		{
			while(u.IsValid && .IsVisible)
			{
				while(!.GotoAttack(u, 1500, false, -1))
				{
					u = .BestTargetInSquadSight;
					if (!u.IsAlive || !.IsVisible)
						break;
				}
				if (u.IsAlive)
				if(.IsVisible)
					while (.Attack(u))
						if (!.IsVisible)
							break;
				u = .BestTargetInSquadSight;
			}
			.FormSetupAndMoveTo(.pos, 0, 0, true);
			.FormKeepMoving(1000);
			continue;
		}
	}

	if (.AI)
	if (!.GetHolderSett.IsValid)
	if (IsWaterLsa(GetGAIKA(this).LSA))
	{	/// leave the coast
		point pt;
		pt.Set(.pos.x + (150 - rand(300)), .pos.y + (150 - rand(300)));
		if (pt.InRect(GetMapRect))
		if (IsPassable3x3(pt))
		if (!IsWaterLsa(pt.GetGAIKA.LSA))
		{
			.AddCommand(true, "move", pt);
			return;
		}
	}

	if(.Stop(2000))
		.Idle(2000);
}