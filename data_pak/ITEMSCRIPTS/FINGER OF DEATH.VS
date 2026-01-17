//void, Obj owner

ObjList ol, olToDie;
Unit u, this;
int i, nCount;

ItemUsed(1);
this = owner.AsUnit();

ol = ObjsInSight(this, "Unit").GetObjList();
nCount=0;

if (ol.count > 0)
	for (i=0; i<30 && nCount<3; i+=1) { //make 30 attempts to kill 
		u = ol[rand(ol.count)];
		if (u.IsDead()) continue;
		if (.IsEnemy(u) && !u.AsHero().IsValid() && !olToDie.Contains(u)) {
			nCount+=1;
			olToDie.Add(u);
		}
	}

//if after 30 random attempts 3 enemies are not kill, damage them in order
for (i=0; i<ol.count && nCount<3; i+=1) {
	u = ol[i];
	if (u.IsDead()) continue;
	if (.IsEnemy(u) && !u.AsHero().IsValid() && !olToDie.Contains(u)) {
		nCount+=1;
		olToDie.Add(u);
	}
}

for (i=0; i<olToDie.count && i<3; i+=1) { //just in case check if less than 3
	CreateFeedback("Lightning2", olToDie[i].AsUnit());
}
Sleep(5000);
for (i=0; i<olToDie.count && i<3; i+=1) { //just in case check if less than 3
	olToDie[i].Damage(100000);
}

return;