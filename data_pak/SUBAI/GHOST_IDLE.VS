// void, Obj me

Unit this;
  
this = me.AsUnit();

if (.GetAnim == 17) Sleep(.TimeToAnimFinish);

while (!.Stop(1000));

//.pr("ghost::idle: started");
while(1)
{
  if (.AI) {
    int own, ally, enemy; Eval(.player, .pos, .range, own, ally, enemy);
    if (enemy < 500) {
      point pt; pt = .BestMDPos(.range, 0, 1000, 500, false);
      if (pt.x >= 0) {
        .AddCommand(true, "move", pt);
        return;
      }
    }
  }

  if (.Stop(2000)) {
	  .pr("ghost::idle: idling");
	  .Idle(2000);
  }
}
