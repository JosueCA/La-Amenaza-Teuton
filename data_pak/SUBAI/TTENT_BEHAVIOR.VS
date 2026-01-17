// void, Obj This


Building this;
Query qSight, qEnemies, qFriends;
ObjList olAll, olTeutonsOut;
int i;
point p;
rect rc;

//constants
int nArmy,			//how much units to spawn at max
	nActiveArmy,	//how much units to keep outside if an enemy comes
	nUnitSpawnRate;	//how often a new unit appears if nobody is around

int nTimeFromLastSpawn;
int nGroupSpawn;
int old_player;

this = This.AsBuilding();
nArmy = GetConst("TTentInitialArmy");
nActiveArmy = GetConst("TTentActiveArmy");
nUnitSpawnRate= GetConst("TTentUnitSpawnRate");

rc = GetMapRect();

.settlement.SetLoyalty(100); //will not be able to capture it the normal way

nGroupSpawn = 2;
nTimeFromLastSpawn = nUnitSpawnRate * nArmy / 2; // this will cause respawn of half the army in the beggining

qSight = ObjsInSight(this, "Unit");
qEnemies = Intersect(qSight, EnemyObjs(.player, "Unit"));
qFriends = Intersect(qSight, ClassPlayerObjs("Military", .player));
old_player = .player;

//---------------[ main loop ]------------------------------------

while (1) {
	// respawn
	olAll.ClearDead();
	while (nTimeFromLastSpawn > nUnitSpawnRate * nGroupSpawn) {
		nTimeFromLastSpawn -= nUnitSpawnRate * nGroupSpawn;
		for (i = 0; i < nGroupSpawn && olAll.count < nArmy; i += 1) {
			Unit uTeuton;
			if (rand(2) == 1) uTeuton = Place("TeutonArcher", .pos, .player);
			else uTeuton = Place("TeutonMetal", .pos, .player);
			.settlement.ForceAddUnit(uTeuton);
			olAll.Add(uTeuton);
		}
	}
	olTeutonsOut.ClearDead();
	// clear the teutons that were commanded from our list
	for (i = olTeutonsOut.count - 1; i >= 0; i -= 1)
		if (olTeutonsOut[i].AsUnit().GetCommanded())
			olTeutonsOut.Remove(olTeutonsOut[i]);
	if (qEnemies.IsEmpty()) { // no threat around
		// command all that are out to come back in
		for (i = 0; i < olTeutonsOut.count; i += 1)
			olTeutonsOut[i].SetCommand("enter_tent", this); //force add even though the tent does not allow units inside
		olTeutonsOut.Clear();
	} else {
		// do not allow our teutons to wander too far
		for (i = 0; i < olTeutonsOut.count; i += 1) {
			Unit u;
			u = olTeutonsOut[i].AsUnit();
			if (.DistTo(u) > .sight) { // move to closer random position
				point pos;
				pos = u.pos - .pos;
				pos.SetLen(.sight / 2);
				p = pos + .pos; p.IntoRect(rc);	u.SetCommand("move", p);
				pos.Rot(90);	p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "patrol", p);
				pos.Rot(90);	p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "patrol", p);
				pos.Rot(90);	p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "patrol", p);
				pos.Rot(90);	p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "patrol", p);
			}
		}
		// get out more teutons if needed
		while (olTeutonsOut.count < nActiveArmy && .settlement.UnitsCount() > 0) {
			point pos;
			Unit u;
			u = .settlement.Units()[0];
			olTeutonsOut.Add(u);
			pos.Set(0, .sight / 2);
			pos.Rot(rand(360));	p = pos + .pos; p.IntoRect(rc);	u.SetCommand("advance", p);
			pos.Rot(90);		p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "patrol", p);
			pos.Rot(90);		p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "patrol", p);
			pos.Rot(90);		p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "patrol", p);
			pos.Rot(90);		p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "patrol", p);
			nTimeFromLastSpawn += 200;
			Sleep(200);
		}
		// handle the capturing
		if (qFriends.IsEmpty() && olTeutonsOut.count == 0) {
			nArmy = GetConst("TTentCapturedArmy");
			.SetPlayer(qEnemies.GetObjList()[0].player);
			// redefine enemies and friends
			qEnemies = Intersect(qSight, EnemyObjs(.player, "Unit"));
			qFriends = Intersect(qSight, ClassPlayerObjs("Military", .player));
			old_player = .player;
		}
		if (old_player != .player) {
			// redefine enemies and friends
			qEnemies = Intersect(qSight, EnemyObjs(.player, "Unit"));
			qFriends = Intersect(qSight, ClassPlayerObjs("Military", .player));
			old_player = .player;
		}
	}
	nTimeFromLastSpawn += 1000;
	Sleep(1000);
}
