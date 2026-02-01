// void, Obj me

Unit this;
point ptOrigin;
point pt;
int own, ally, enemy;
int patrolState;

this = me.AsUnit();

if (.GetAnim == 17) Sleep(.TimeToAnimFinish);

while (!.Stop(1000));

// Save origin position
ptOrigin = .pos;
patrolState = 0; // 0=search enemies, 1=return to origin

//.pr("ghost::patrol: started at origin (" + ptOrigin.x + "," + ptOrigin.y + ")");
while(1)
{
  if (.AI) {
    // Evaluate forces around ghost
    Eval(.player, .pos, 3000, own, ally, enemy);

    if (patrolState == 0) {
      // STATE 0: Search for enemies and move towards them
      // Try to find position with enemies using very aggressive parameters
      pt = .BestMDPos(0, 0, 5000, 1, false);

      if (pt.x >= 0) {
        //.pr("ghost::patrol: moving to enemy position (" + pt.x + "," + pt.y + ")");
        .AddCommand(true, "move", pt);
        patrolState = 1; // Switch to return state
        return;
      }
    } else {
      // STATE 1: Return to origin
      if (.DistTo(ptOrigin) > 200) {
        //.pr("ghost::patrol: returning to origin");
        .AddCommand(true, "move", ptOrigin);
        return;
      } else {
        // At origin, start searching again
        patrolState = 0;
      }
    }
  }

  if (.Stop(2000)) {
	  //.pr("ghost::patrol: idling");
	  .Idle(2000);
  }
}
