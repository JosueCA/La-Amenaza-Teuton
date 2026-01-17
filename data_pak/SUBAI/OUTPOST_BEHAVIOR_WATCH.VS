// void, Obj This

point pt, ptRotated;
Obj WatchEye;
Building this;
int angle;
int dir, RndPeriod, counter;
Query q;
int LastCPEnemyCount, CurCPEnemyCount;
int times = 0;
dir = -1;
angle = rand(360);
RndPeriod = rand(10) + 140;
pt.Set(0, 1000);
this = This.AsBuilding();
LastCPEnemyCount = 0;

while(.player>8)
	Sleep(1124);

WatchEye = Place("WatchEye", Point(-1, -1), .player);
q = Intersect(ObjsInSight(WatchEye, "Unit"), EnemyObjs(.player, "Unit"));
counter = 360;
WatchEye.SetBlind(false);
while(1)
{
	ptRotated = pt;
	ptRotated.Rot(angle);
	angle = (angle + dir) % 360;
	if (counter!=0)
		{
			counter -= 1;
			if (counter==0)
				WatchEye.SetBlind(true);
		}
	
	WatchEye.SetPosSimple(.pos + ptRotated);
	if(WatchEye.player != .player)
	{
		WatchEye.SetPlayer(.player);
		q = Intersect(ObjsInSight(WatchEye, "Unit"), EnemyObjs(.player, "Unit"));
		counter = 360;
		WatchEye.SetBlind(false);
	}
	
	Sleep(RndPeriod);
	times += 1;
	if(times % 12 == 0)
	{
		CurCPEnemyCount = q.GetObjList().count();	
		if(CurCPEnemyCount < LastCPEnemyCount)
		{
			dir = -dir;
			times = 0;
		}
		LastCPEnemyCount = CurCPEnemyCount;
		if (counter!=0)
			counter=360;
	}
}