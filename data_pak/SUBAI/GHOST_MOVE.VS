// void, Obj This, point pt

Unit this;
this = This.AsUnit();

//.pr("ghost::move: move to a point");

if (.GetAnim == 17) Sleep(.TimeToAnimFinish);

while (!.Goto(pt, 0, 2000, false, 0));
