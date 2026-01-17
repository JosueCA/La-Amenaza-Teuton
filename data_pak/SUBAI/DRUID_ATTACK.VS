// void, Obj me, Obj u

Unit this;

this = me.AsUnit();

//.pr("druid::attack: approach a unit");

if (u.IsAlive())
  while(!.GotoAttack(u, 5000, false));
