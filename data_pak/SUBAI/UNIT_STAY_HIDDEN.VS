// void, Obj This, Obj target

Unit this;
Sacrifice s;
bool bThere;

this = This.AsUnit();

s = target.AsSacrifice();

if (!s.IsValid) s = target.AsUnit().GetSacrifice();
if (!s.IsValid()) return;
bThere = s.DistTo(this) <= s.range;
while (s.IsValid() && !bThere)
  bThere = .Goto(s, s.range, 5000, false, 0);
if (!s.IsValid()) return;
.SetVisible(false);

while(s.IsValid)
{
  if (.Stop(2000)) {
	  //.pr("unit::stay_hidden: idling");
	  .Idle(2000);
  }
}

