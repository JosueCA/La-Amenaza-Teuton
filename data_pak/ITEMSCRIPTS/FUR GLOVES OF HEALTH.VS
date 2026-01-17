//void, Obj owner

ObjList ol;
Unit u, this;
int i, nHealthToGive, nHealthToTake;

this = owner.AsUnit();

nHealthToGive = .health - .maxhealth/10; //10%

if (nHealthToGive<=0) return;

ol = ObjsInSight(this, "Unit").GetObjList();

if (ol.count > 0)
	for (i=0; i<20; i+=1) { //make 20 random attempts to heal a friendly unit
		u = ol[rand(ol.count)];
		if (u.IsDead()) continue;
		if (!.IsEnemy(u)) {
			nHealthToTake = u.maxhealth - u.health;
			if (nHealthToTake<nHealthToGive) {
				u.Heal(nHealthToTake);
				.Damage(nHealthToTake);
			} else {
				u.Heal(nHealthToGive);
				.Damage(nHealthToGive);
			}
			CreateFeedback("Heal", u);
			return;
		}
	}

//if after 20 random attempts a friend is not healed, try to find one to heal in order
for (i=0; i<ol.count; i+=1) {
	u = ol[i];
	if (u.IsDead()) continue;
	if (!.IsEnemy(u)) {
		nHealthToTake = u.maxhealth - u.health;
		if (nHealthToTake<nHealthToGive) {
			u.Heal(nHealthToTake);
			.Damage(nHealthToTake);
		} else {
			u.Heal(nHealthToGive);
			.Damage(nHealthToGive);
		}
		CreateFeedback("Heal", u);
		return;
	}
}

