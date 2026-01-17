// void, Obj This, Obj bld

Hero this;
Teleport tel;
point pt, ptGoto;
int len, angle, i;
int nMinDist, nFOV;
bool bReady;

bReady = false;

nMinDist = GetConst("TelMinDist");
nFOV = GetConst("TelFOV");

this = This.AsHero();
tel = bld.AsTeleport();

if (!.IsValid() || !tel.IsValid()) return;

.SetEntering(true);
if (.HasArmy()) {
	pt = tel.GetEnterPoint(this);
    len = tel.destination.radius + tel.destination.exit_vector.Len() * (nMinDist + rand(100-nMinDist)) / 100;
    angle = rand(nFOV) - nFOV/2;
    ptGoto = tel.destination.exit_vector;
    ptGoto.SetLen(len);
    ptGoto = ptGoto + tel.destination.pos;
	ptGoto = ptGoto.ClampToMap();

	//pr("Approaching tleport");
	.FormSetupAndMoveTo(pt, 100, 0, false);
    while (.HasPath()) {
		if (.FormPathLeft () < .FormRadius () + 150) break;
      	if (.DistTo(tel) < .FormRadius()) break;
      	.FormKeepMoving (500);
    }
    //pr("army enters the teleport");
    .army.SetCommand("enter", tel); //the army enters
    while(!.GotoEnter(pt, 0, 1000, false, 2500));
    tel.settlement.AddUnit(this);
	bReady = false;
	while (!bReady) {
		bReady = true;
		for (i=0; i<.army.count; i+=1) {
			//if (.army[i].command == "enter") {
			if (!.army[i].AsUnit.InHolder()) {
				bReady = false;
				break;
			}
		}
		Sleep(500);
	}

    //pr("teleport!");
	tel.destination.settlement.AddUnit(this);
	for (i=0; i<.army.count; i+=1) {
		tel.destination.settlement.AddUnit(.army[i].AsUnit);
	}

	//pr("exitting");
	.AddCommand(true, "advance", ptGoto);
    return;

} else {
//pr("entering alone");
	pt = tel.GetEnterPoint(this);
   	while(!.GotoEnter(pt, 0, 1000, false, 2500));
    len = tel.destination.radius + tel.destination.exit_vector.Len() * (nMinDist + rand(100-nMinDist)) / 100;
    angle = rand(nFOV) - nFOV/2;
    ptGoto = tel.destination.exit_vector;
	ptGoto.SetLen(len);
    ptGoto.Rot(angle);
    ptGoto = ptGoto + tel.destination.pos;
	ptGoto = ptGoto.ClampToMap();
    pt = tel.destination.GetExitPoint(ptGoto, false);
    .SetPos(pt);
    while (!.Goto(ptGoto, 0, 1000, false, 2500));
    return;
}
