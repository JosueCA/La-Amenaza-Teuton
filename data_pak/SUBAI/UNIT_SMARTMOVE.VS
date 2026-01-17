// void, Obj This, point pt

Unit this;
this = This.AsUnit();

if (!.BestTargetInSquadSight().IsAlive()) {
  //.pr("unit::move: advancing to position");
  .AddCommand(true, "advance", pt);
  return;
}

while (!.Goto(pt, 0, 2000, true, 0));
