// void, Obj This, Obj bld

Unit this;
Teleport tel;
point pt, ptGoto;
int len, angle;
int nMinDist, nFOV;


nMinDist = GetConst("TelMinDist");
nFOV = GetConst("TelFOV");

this = This.AsUnit();
tel = bld.AsTeleport();

if (!.IsValid() || !tel.IsValid()) return;

.SetEntering(true);
if (!tel.settlement.Units().Contains(this)) {
    pt = tel.GetEnterPoint(this);
    while(!.GotoEnter(pt, 0, 1000, false, 2500));
}
    //ptGoto = tel.destination.pos + Point(200,200);
    len = tel.destination.radius + tel.destination.exit_vector.Len() * (nMinDist + rand(100-nMinDist)) / 100;
    angle = rand(nFOV) - nFOV/2;
    ptGoto = tel.destination.exit_vector;
    ptGoto.SetLen(len);
    ptGoto.Rot(angle);
    ptGoto = ptGoto + tel.destination.pos;
	ptGoto = ptGoto.ClampToMap();
    pt = tel.destination.GetExitPoint(ptGoto, false);
    .SetPos(pt);
//////while (!.Goto(ptGoto, 0, 1000, false));
	//.JustExited();
	tel.destination.settlement.AddUnit(this);
	.AddCommand(true, "move", ptGoto);

