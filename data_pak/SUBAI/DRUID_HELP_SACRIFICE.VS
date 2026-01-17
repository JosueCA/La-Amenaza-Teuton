// void, Obj This, Obj target

Druid this, other;
Sacrifice s;

this = This.AsDruid();

s = target.AsSacrifice();

if (!s.IsValid()) {
  other = target.AsDruid();
	if (!other.IsValid()) return;
	s = other.GetSacrifice();
//	if (!s.IsValid()) return;
  while (!s.IsValid) {
    if (!other.IsValid) return;
    if(.Goto(other, 100, 5000, false, 0)) {
      s = other.GetSacrifice;
      if (!s.IsValid)
    		Sleep(1000);
    } else
      s = other.GetSacrifice;
      if (!s.IsValid)
    		Sleep(1000);
  }

   // full expression evaluation fix
	while (!.Goto(s, 350, 5000, false, 0))
		if (!s.IsValid()) return;

	if (s.IsInvisibility()) 
		.SetVisible(false);
	else
		.SetVisible(true);
  .PlayAnim(18, s.pos);
} else {
	if (s.IsInvisibility()) 
		.SetVisible(false);
	else
		.SetVisible(true);
}

while (s.IsValid() && .health > 1) {
  //.pr("druid::help_sacrifice: sacrificing");
	if (!s.IsInvisibility() && !.IsVisible) 
		.SetVisible(true);
	s.AddDruid(this, .GetAnimTime(18));
	.PlayAnim(18, s.pos);
}

.SetVisible(true);
