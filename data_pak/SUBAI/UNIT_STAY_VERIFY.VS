// bool, Obj This, Obj target

Unit this, tgt;
Sacrifice s;

this = This.AsUnit();
tgt = target.AsUnit();

if (!.IsValid()) return false;
if (!tgt.IsValid()) return false;
if (!tgt.IsAlive()) return false;
if (.IsEnemy(tgt)) return false;
if (!.CanSee(tgt)) return false;

s = tgt.GetSacrifice();

if (!s.IsValid()) return false;
return s.IsInvisibility;