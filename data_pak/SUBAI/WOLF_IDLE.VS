// void, Obj me

Unit this, u, packleader;
point pt, v, vSum, ptMyOffset, ptOldLeaderPos;
Query qWolves;

ObjList olWolves;
int i, safetyCounter;

this = me.AsUnit();
qWolves = ObjsInCircle(.pos, .sight*2,"Wolf");

.Idle(2000);
while (!.Stop(1000));


olWolves = qWolves.GetObjList();
for (i=0; i<olWolves.count; i+=1) 
{
	u=olWolves[i];
	if(u.command == "lead")
	{
		if(!packleader.IsAlive || rand(2) == 0)
			packleader = u;
	} else
	if(u.command == "engage")
	{
		.AddCommand(true, "engage");
		return;
	}
}

// Follow the pack or become leader
if(packleader.IsValid)
{
	// Follow the pack leader
	safetyCounter = 0;
	while(packleader.command == "lead")
	{
		safetyCounter += 1;
		if(safetyCounter > 50) break; // Safety timeout

		ptOldLeaderPos = packleader.pos;
		if(.Goto(packleader, 15, 750, false, 0))
		{
			while(!.Stop(1000));
			.Idle(500);
		}
		if(!packleader.IsValid || !.IsValid)
			break;

		// Heal if leader is stationary
		if(ptOldLeaderPos == packleader.pos)
			.Heal(.maxhealth/3);

		// Wait near the leader or patrol around
		while(ptOldLeaderPos == packleader.pos && .DistTo(packleader) < 50)
		{
			if(rand(12) == 0)
			{
				// Patrol around the leader
				pt = .pos - packleader.pos;
				pt.SetLen(pt.Len + 50);
				for(i = 0; i < 6; i+=1)
				{
					pt.Rot(45);
					pt.SetLen(pt.Len + 10);

					while(!.Goto(pt + packleader.pos, 0, 1500, false, 0))
						if(!packleader.IsAlive)
							return;
					if(ptOldLeaderPos != packleader.pos)
					{
						while(!.Stop(1000));
						break;
					}
				}
			} else
			{
				// Just wait
				while(!.Stop(1000));
				.Idle(1500);
			}
			// Safety check
			safetyCounter += 1;
			if(safetyCounter > 50) break;
		}

		if(!packleader.IsValid)
			break;
	}

	// If leader is engaging, join the fight
	if(packleader.IsValid && packleader.command == "engage")
	{
		.AddCommand(true, "advance", packleader.pos);
		.AddCommand(true, "engage");
	}
} else
{
	// No valid leader, become the leader
	.AddCommand(true, "lead");
}
