//void, Obj owner

ObjList ol;
Unit u, this;
int i, nFood, nGive, MAX_FOOD;

this = owner.AsUnit();
if (!.IsValid()) return;

MAX_FOOD = 20;

nFood = GetUseCount();
if (.food < MAX_FOOD) {
	nGive = MAX_FOOD - .food;
	if (nGive > nFood) nGive = nFood;
	nFood -= nGive;
	.SetFood(.food + nGive);
	if (nFood == 0) {
		ItemUsed(GetUseCount());
		return;
	}
}

//first try the militaries
ol = ObjsInSight(owner, "Military").GetObjList();
for(i = 0; i < ol.count; i += 1) {
	u = ol[i].AsUnit();
	if (u.IsDead()) continue;
	if (.IsEnemy(u)) continue;
	if (u.food < MAX_FOOD) {
		nGive = MAX_FOOD - u.food;
		if (nGive > nFood) nGive = nFood;
		nFood -= nGive;
		u.SetFood(u.food + nGive);
		if (nFood == 0) {
			ItemUsed(GetUseCount());
			return;
		}
	}
}

//if some food is left - give it to the poor, I mean the civilians :)
ol = ObjsInSight(owner, "Peaceful").GetObjList();
for(i = 0; i < ol.count; i += 1) {
	u = ol[i].AsUnit();
	if (u.IsDead()) continue;
	if (owner.IsEnemy(u)) continue;
	if (u.food < MAX_FOOD) {
		nGive = MAX_FOOD - u.food;
		if (nGive > nFood) nGive = nFood;
		nFood -= nGive;
		u.SetFood(u.food + nGive);
		if (nFood == 0) {
			ItemUsed(GetUseCount());
			return;
		}
	}
}


ItemUsed(GetUseCount()-nFood);
return;
