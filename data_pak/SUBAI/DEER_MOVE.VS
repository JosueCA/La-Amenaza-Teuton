// void, Obj This, point pt

Unit this;
this = This.AsUnit();
.SetSpeedFactor(150);
.SetWalkAnim(1);

while (!.Goto(pt, 0, 2000, true, 0));
