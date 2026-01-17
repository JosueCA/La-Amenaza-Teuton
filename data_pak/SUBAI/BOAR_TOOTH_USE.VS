//void, Obj This, Obj target
int nHealthToGive, nHealthToTake;
int radius;
Unit this;
this = This.AsUnit;
radius = GetConst("BoarToothUseRadius");

while(.DistTo(target) > radius)
{
    .Goto(target, 0, 2000, true, 0);
    if(!target.IsAlive())
       return;
}

nHealthToGive = .health - .maxhealth/5; //20%

if (nHealthToGive>0) {
	if (target.AsHero().IsValid()) {
		nHealthToTake = target.health - target.maxhealth/2; //50%
	} else {
		nHealthToTake = target.health; //may be killed if ordinary unit
	}
	if (nHealthToTake > nHealthToGive) {
		target.Damage(nHealthToGive);
		.Damage(nHealthToGive);
	} else {
		target.Damage(nHealthToTake);
		.Damage(nHealthToTake);
	}
	CreateFeedback("Lightning", target.AsUnit());
	CreateFeedback("Lightning", .AsUnit());
}
