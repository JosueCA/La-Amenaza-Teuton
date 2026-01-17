// void, Obj me, point pt

point where;
Unit this;
this = me.AsUnit();
while (1) {
  where.Set(0, rand(.sight));
  where.Rot(rand(360));
  if (.Goto(pt + where, 0, 20000, false, 0))
  Sleep(rand(5000) + 5000);
}
//.AddCommand(false, "attack", pt + where);
//Sleep(rand(5000) + 5000);
//.AddCommand(false, "wander", pt);