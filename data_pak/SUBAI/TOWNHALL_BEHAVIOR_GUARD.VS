//void, Obj This

Building this;
ObjList l, p;
point pt;
int i, nOldPlayer, max;
Query ProtectiveArea;
Query Alert;

this = This.AsBuilding();


nOldPlayer = .player;
ProtectiveArea = ObjsInSight(this,"Unit");
Alert = Substract(Intersect(ProtectiveArea,EnemyObjs(.player(),"Unit")), Substract(EnemyObjs(.player(),"Peaceful"), EnemyObjs(.player(),"BaseMage")));

if(.IsValid()) {
	while(true)	{
		if (.player != nOldPlayer) { //if was captured between sleeps
			//recalc the query, .player has changed!
			Alert = Substract(Intersect(ProtectiveArea,EnemyObjs(.player(),"Unit")), Substract(EnemyObjs(.player(),"Peaceful"), EnemyObjs(.player(),"BaseMage")));

			nOldPlayer = .player; //to avoid multiple .player calls update this now
			//select a point to go to
			pt.Set(1,0);
			pt.SetLen(.radius);
			pt.Rot(rand(360));
			pt = pt + .pos;
			//get all non-mine units out!
			l = .settlement().Units();
			l.ClearDead();
			for (i=0; i< .settlement.UnitsCount(); i+=1) {
				Unit u;
				u = l[i].AsUnit();
				if (u.IsValid()) if (u.player != nOldPlayer) {
					if (!u.hero.IsValid())
						u.SetCommand("advance", pt);
				}
			}
		}
		WaitQueryCountBetween(Alert,1,-1,-1); // Ivko: Little tricky here when captured!
		l = Alert.GetObjList();
		if((l.count()!=0) && (.settlement.loyalty < GetConst("LoyaltyUnitsOutTreshold")))	{
			Unit u;
      EnvWriteInt(.settlement, "EnemiesAlert", 1);

			pt = l[rand(l.count)].pos();
			l = .settlement().Units();
			max = l.count(); if (max>50) max = 50;
			p.Clear();
			for(i = 0; i < max; i+=1){
				u = l[i].AsUnit();
				if(!u.hero.IsValid())
					p.Add(u);
			}
			//Command Stack
			p.AddCommand(true,"enter",this);
			p.AddCommand(true,"advance",pt);
			p.KillCommand();
			Sleep(500);
			continue;
		} else EnvWriteInt(.settlement, "EnemiesAlert", 0);
		Sleep(1000);
	}
} else {
	Sleep(10000);//will restart after 10 seconds
}

