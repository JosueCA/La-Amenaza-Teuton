// void, Obj this, point pt

Obj WatchEye;
WatchEye = Place("WatchEye", pt, .player);
WatchEye.SetCommand("spy");
WatchEye.SetSight(1000);
