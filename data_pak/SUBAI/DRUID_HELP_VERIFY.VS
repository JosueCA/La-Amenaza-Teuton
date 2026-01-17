// bool, Obj This, Obj target

Druid this, tgt;
Sacrifice s;

this = This.AsDruid();
tgt = target.AsDruid();


if (!.IsValid()) return false;
if (!tgt.IsValid()) return false;
if (!tgt.IsAlive()) return false;
if (.IsEnemy(tgt)) return false;
if (!.CanSee(tgt)) return false;

s = tgt.GetSacrifice();

return (s.IsValid());
