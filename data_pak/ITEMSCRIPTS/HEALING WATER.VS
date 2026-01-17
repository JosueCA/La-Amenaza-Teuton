//void, Obj owner

ObjList ol;
Unit u;
int i, nHealth, nGive;


nHealth = GetUseCount();
if (owner.health < owner.maxhealth) {
	CreateFeedback("Heal", owner.AsUnit());
	nGive = owner.maxhealth - owner.health;
	if (nGive > nHealth) nGive = nHealth;
	nHealth -= nGive;
	owner.Heal(nGive);
	if (nHealth == 0) {
		ItemUsed(GetUseCount());
		return;
	}
}

ol = ObjsInSight(owner, "Unit").GetObjList();
for(i = 0; i < ol.count; i += 1) {
	u = ol[i].AsUnit();
	if (u.IsDead()) continue;
	if (owner.IsEnemy(u)) continue;
	if (u.health < u.maxhealth) {
		CreateFeedback("Heal", u);
		nGive = u.maxhealth - u.health;
		if (nGive > nHealth) nGive = nHealth;
		nHealth -= nGive;
		u.Heal(nGive);
		if (nHealth == 0) break;
	}
}
ItemUsed(GetUseCount()-nHealth);
return;