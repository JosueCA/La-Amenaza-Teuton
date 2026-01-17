// bool, Obj This, point pt

Hero this;
this = This.AsHero();

return (.EnemiesInSight() && pt.Dist(.posRH) < .sight/2 && .command != "stand_position");
