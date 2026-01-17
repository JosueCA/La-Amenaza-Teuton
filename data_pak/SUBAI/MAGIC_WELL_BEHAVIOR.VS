// void, Obj This

Query qUnitsAroundMe;

qUnitsAroundMe = ObjsInRange(This, "Unit", 300);
while(1)
{
	if (qUnitsAroundMe.count != 0)  {
		ObjList l;
		int i, j, count;
		Unit unit;

		l = qUnitsAroundMe.GetObjList();
		l.ClearDead();
		count = l.count;
		j = rand(count);
		for (i = 0; i < count; i += 1) {
			unit = l[(i + j) % count];
			if (unit.health == unit.maxhealth) continue;
			unit.Heal(200);
			CreateFeedback("Heal", unit);
			Sleep(1000);
			break;
		}
	}
	Sleep(1000);
}
