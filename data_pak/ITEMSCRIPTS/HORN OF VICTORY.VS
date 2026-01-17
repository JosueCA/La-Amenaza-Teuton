//void, Obj owner

ObjList ol;
Unit u, this;
int i, nCount;

this = owner.AsUnit();

ol = ObjsInSight(this, "Unit").GetObjList();
nCount=0;

if (ol.count>0)
	for (i=0; ol.count!=0 && i<100 && nCount<12; i+=1) { //make 100 attempts to damage 
		u = ol[rand(ol.count)];
		if (u.IsDead()) continue;
		if (.IsEnemy(u)) {
			nCount+=1;
			CreateFeedback("Damage2", u);
			u.Damage(60);
			ol.Remove(u); //avoid damaging it twice
		}
	}

//if after 100 random attempts 12 enemies are not damaged, damage them in order
for (i=0; i<ol.count && nCount<12; i+=1) {
	u = ol[i];
	if (u.IsDead()) continue;
	if (.IsEnemy(u)) {
		nCount+=1;
		CreateFeedback("Damage2", u);
		u.Damage(60);
	}
}


ItemUsed(1);
return;