// void, Obj This

Query qMages;
ObjList olMages;
int i, nSpell, nSecs, nDuration, nObjects;
Building this;
Unit u;

this = This.AsBuilding();
if (!.IsValid()) return;
if (!.IsSpellCasted()) return;

qMages = ObjsInSight(this, "BaseMage");

olMages.Clear();
for (i=0; i<qMages.count; i+=1) {
	u = qMages.GetObjList()[i];
	if (u.command=="globalspell")
		olMages.Add(u);
}

nSpell = .GetGlobalSpell();
nDuration = 0;
nSecs = 0;
if (nSpell == 2) nDuration = 2000; //starvation
if (nSpell == 3) 
	{ nDuration = 2000; nObjects = .GetGoldenRainObjects(); } //golden rain
if (nSpell == 4) nDuration = 2000; //death wish


while (.IsSpellCasted()) {
	olMages.ClearDead();
	if (olMages.count == 0) {
		.GlobalSpellStop();
		return;
	}
	nSecs -= 1000;
	if (nSecs <=0) {
		nSecs = nDuration;
		if (nSpell == 2) .Starvation();
		if (nSpell == 3) .GoldenRain(nObjects);
		if (nSpell == 4) .FinalSacrifice();
	}
	Sleep(1000); //this should be the GCD of possible nDuration-s
}

//when the time is over
if (nSpell == 6) { //teuton disaster
	.TeutonDisaster();
}

//kill the mages
olMages.ClearDead();
for (i=0; i<olMages.count; i+=1) {
	olMages[i].Damage(100000);
}
