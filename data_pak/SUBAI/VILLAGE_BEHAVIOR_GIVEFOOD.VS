// void, Obj This

Settlement s;
ObjList ol;
Query q;
int i;

s = This.AsBuilding().settlement;
q = ObjsInSight(This, "Unit");

while (1) {
	if (WaitNonEmptyQuery(q, -1) && s.food!=0)
		{
			Unit u;
			int give;
			ol = q.GetObjList();
			for (i=0; i<ol.count; i+=1)
				{
					Sleep(5);
					if (ol[i].IsAlive())
						if (DiplGetShareSupport(This.player, ol[i].player))
						{
							u = ol[i].AsUnit();
							give = 20-u.food;
							if (give==0) continue;
							if (give>s.food) give=s.food;
							u.SetFood(u.food+give);
							s.SetFood(s.food-give);
						}
				}
		}
	Sleep(2000);
}
