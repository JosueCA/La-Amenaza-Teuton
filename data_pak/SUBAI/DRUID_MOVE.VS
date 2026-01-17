// void, Obj This, point pt

Unit this;
this = This.AsUnit();

//.pr("druid::move: move to a point");

while (!.Goto(pt, 0, 2000, false));
