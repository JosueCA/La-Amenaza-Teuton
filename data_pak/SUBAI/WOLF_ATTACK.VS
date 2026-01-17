// void, Obj me, Obj tgt

	Unit this;
	point ptCenter;
	Obj u;
	Query qEnemy, qWolves;
	int i;
	ObjList ol;
	this = me.AsUnit;
	u = tgt.AsUnit();
	pr("advance: searching for new enemy");
	if(u.IsAlive())	
	{
		pr("advance: target found!");
		while (u.IsAlive()) 
		{
			 if(!.IsValidTarget(u)) break;

			while(!.GotoAttack(u, 1500, true, -1)) 
			{
				pr("advance: approaching target!");
				if(!u.IsAlive() || !.IsValidTarget(u)) break;
				if(.health < .maxhealth/2) // I'm sooooo scared 
				{
					qEnemy = Intersect(Union(ObjsInSight(this, "Military"), ObjsInSight(this, "Tower")), EnemyObjs(.player, "Military"));
					ol = qEnemy.GetObjList();
					if(ol.count > 0)
					{
						ptCenter = ol[0].pos;
						for(i = 1; i < ol.count; i += 1)
						{
							ptCenter = ptCenter + ol[i].pos;
						}
						ptCenter = ptCenter / ol.count;
						ptCenter = .pos - ptCenter; 
						ptCenter.SetLen(.sight*3);
						qWolves = Intersect(ObjsInCircle(.pos, .sight*2, "Wolf"), FriendlyObjs(.player, "Wolf"));
						ol = qWolves.GetObjList;
						ol.Remove(this);
						ol.SetCommandOffset("move", ptCenter);
						.AddCommand(true, "move", ptCenter);
						return;
					}
				}
			}
			pr("advance: attacking target!");
			if (u.IsAlive() && .IsValidTarget(u))
			{
				while (.Attack(u)) if(!.IsVisible) .SetVisible(true);
			}
		}
	} 
