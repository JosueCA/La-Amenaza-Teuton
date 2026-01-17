// void, Obj THIS

Druid this;
Unit u;
ObjList ol;
int HealthDistrubute, Give, i;

this = THIS.AsDruid;

if (.InHolder())
	return;

if(EnvReadString(.player, "Mass Heal") != "researched")
	return;

ol = ObjsInCircle(.pos, .sight, "Unit").GetObjList();
HealthDistrubute = 500;
for(i = 0; i < ol.count; i += 1) {
	u = ol[i].AsUnit();
	if (.IsEnemy(u)) continue;
	
	if (u.health < u.maxhealth) {
		CreateFeedback("Heal", u);
		Give = u.maxhealth - u.health;
		if (Give > HealthDistrubute) Give = HealthDistrubute;
		HealthDistrubute -= Give;
		u.Heal(Give);
		if (HealthDistrubute == 0) break;
	}
}

