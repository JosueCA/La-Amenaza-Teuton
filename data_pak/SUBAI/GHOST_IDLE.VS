// void, Obj me
// Ghost applies damage passively when near enemies, just needs to move toward them

Unit this;
Unit u;
point pt;
int own, ally, enemy;

this = me.AsUnit();

if (.GetAnim == 17) Sleep(.TimeToAnimFinish);

while (!.Stop(1000));

//.pr("ghost::idle: started");
while(1)
{
  // Find nearest enemy to follow
  u = .BestTargetInSquadSight();

  if(u.IsAlive() && u.maxattack > 0)
  {
    //.pr("ghost::idle: found enemy, moving to it");
    // Just move toward the enemy (ghost damages passively when near)
    if (!.Goto(u.pos, 100, 3000, true, 5000)) {
      Sleep(500);
    }
    continue;
  }

  // No enemy in sight, search for enemies in area
  Eval(.player, .pos, 3000, own, ally, enemy);

  if (enemy > 0) {
    //.pr("ghost::idle: enemies nearby (" + enemy + "), finding best position");
    pt = .BestMDPos(0, 0, 5000, 1, true);

    if (pt.x >= 0) {
      //.pr("ghost::idle: moving to enemy position");
      if (!.Goto(pt, 0, 5000, true, 5000)) {
        Sleep(500);
      }
      continue;
    }
  }

  // No enemies found, idle
  //.pr("ghost::idle: no enemies, idling");
  if (.Stop(1000)) {
    .Idle(1000);
  }

  Sleep(200);
}
