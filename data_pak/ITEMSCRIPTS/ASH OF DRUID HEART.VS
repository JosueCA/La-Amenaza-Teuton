//void, Obj owner

ObjList ol;
Unit u, this;
int i, nCount;

this = owner.AsUnit();

ol = ObjsInSight(this, "Unit").GetObjList();
nCount=0;

if (.health<.maxhealth) {
	nCount = 1;
	.Heal(.maxhealth);
}

if (ol.count()>0)
	for (i=0; i<100 && nCount<8; i+=1) { //make 100 random attempts to heal
		if( ol.count == 0 ) break;
		u = ol[rand(ol.count)];
		if (u.IsDead()) continue;
		if (!.IsEnemy(u)) {
			nCount+=1;
			u.Heal(u.maxhealth);
			CreateFeedback("Heal", u);
			ol.Remove(u); //avoid healing it twice
		}
	}

//if after 100 random attempts 8 friends are not healed, heal them in order
for (i=0; i<ol.count && nCount<8; i+=1) {
	u = ol[i];
	if (u.IsDead()) continue;
	if (!.IsEnemy(u)) {
		nCount+=1;
		u.Heal(u.maxhealth);
		CreateFeedback("Heal", u);
	}
}


ItemUsed(1);
return;