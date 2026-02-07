// void, Obj This, Obj other

Hero this;
Unit u;
this = This.AsHero();

//.pr("The script should be modified to check if the unit is still visible");

if (other.IsAlive())
  {
    .FormSetupAndMoveTo (other, 20, 0, true);
    while (.HasPath ())
    {
      .FormKeepMoving (1500);
    }
  }

