// void, Obj This

Unit this, u;
int i;
point pt, ptDir;
Query qNewDestTowers, qWolves;
Obj attacker, target;
ObjList ol;
bool bFleeing;
rect rcMap;
this = This.AsUnit();
bFleeing = false;
this = This.AsUnit();

//pr("hero::move: defensive move - attack if attacked");
rcMap = GetMapRect;
//pr("leading -=-=-=-=-=-=-=-=-=-=-=-=-=-=-");   // i lead the pack bastards
while(!.Stop(1000));
.Idle(500);
ptDir = .GetDir;
while(1)
{
	if(rand(60) != 0)
	{
		//pr("Changing direction");
		ptDir.SetLen(.sight + rand(.sight/2));
		ptDir.Rot(rand(15)+15);
		pt = ptDir +.pos; 
		if(!pt.InRect(rcMap) || !IsPassable3x3(pt))
		{
			//pr("reached map edge !!!!!!!!!!!!!!!");
			Sleep(100); // Miho: instruction limit gets exceeded here, probably not the best solution
			continue;
		}
		qNewDestTowers = Intersect(ObjsInCircle(pt, .sight, "TTent,Tower,Military"), EnemyObjs(.player, "Object"));
												
		if(qNewDestTowers.count > 0)
		{
			//pr("ooops! think, think, think what shall we do now? just saw a " + qNewDestTowers.GetObjList[0].class);
			.Idle(500); 
			continue;
		}
		if(rand(3) == 0)
		{
			ol = ObjsInCircle(pt, .sight, "Building").GetObjList;
			if(ol.count != 0)
			{
				//pr("I don't like it here");
				ptDir = .pos - ol[0].pos;
				continue;
			}
		}
		if(IsPointInWater(pt))
		{
			//pr("water!!! disgusting!!!");
			ptDir = .pos - pt;
			continue;
		}
	} else
	{
		//pr("I'm too old for this job");
		return;
	}
	if(Intersect(ObjsInSight(this, "BaseVillage,Unit,Tower"), EnemyObjs(.player, "Object")).count == 0 && rand(3) == 0)
	{
		//pr("ok guys time to rest a little");
		for(i = 0; i < 16; i+=1)
		{
			attacker = .BestTargetInSquadSight();
			if(attacker.IsAlive())
			{
				if(attacker.maxattack > 1)
				{
					//pr("this " + attacker.class + " doesn't look quite friendly. Let's run for our lives");
					ptDir = .pos - attacker.pos;
					bFleeing = true;
					break; 
				} else
				if(.health < .maxhealth) // i'm really angry grrrr!!!
				{
					//pr("found some food");
					.AddCommand(true, "engage");
					return;
				}
			}
			while(!.Stop(1000));
			.Idle(1500);	
		}
		if(attacker.IsAlive())
			continue;
	}
	ol = Intersect(ObjsInCircle(.pos, .sight * 2, "Wolf"), FriendlyObjs(.player, "Wolf")).GetObjList();
	if(ol.count > 4)		// should we split
	{
		//pr("we should split up");
		if(this != ol[0])
			u = ol[0];
		else
			u = ol[1];
		u.SetCommand("lead");	  
		ol.Remove(u);
		ol.Remove(this);
		ol.SetCommand("idle");
	}
	while(!.Goto(pt, 0, 1000, true, 0) && .HasPath)
	{
		attacker = .BestTargetInSquadSight();
		if(attacker.IsAlive() && !bFleeing)
		{
			if(attacker.DistTo(this) < .sight/4 || .health < .maxhealth)
			{
				//pr("enough is enogh!!! kill those bastards");
				.AddCommand(true, "engage");
				return;
			} else
			{
				//pr("this " + attacker.class + " doesn't look quite friendly. Let's run for our lives");
				ptDir = .pos - attacker.pos;
				bFleeing = true;
				break; 
			}
		}
	}
	bFleeing = false;
}