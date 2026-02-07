// bool, Obj This, point pt

Hero this;
this = This.AsHero();

return (.EnemiesInSight() && pt.Dist(.pos) < .sight/2 && .command != "stand_position");
