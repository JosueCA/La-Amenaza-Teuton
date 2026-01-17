// void, Obj me, Obj u

Unit this;

this = me.AsUnit();

//.pr("ghost::attack: approach a unit");

if (.GetAnim == 17) Sleep(.TimeToAnimFinish);

if (u.IsAlive())
  while(!.GotoAttack(u, 5000, false, 0));
