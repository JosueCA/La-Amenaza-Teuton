// void, Obj This, Obj target
Hero this;
point pt;
Sacrifice s;

this = This.AsHero();

s = target.AsSacrifice();

if (!s.IsValid) s = target.AsUnit().GetSacrifice();
if (!s.IsValid()) return;

pt = s.pos;           
//.pr("Hero::stay_hidden: Going...");

.FormSetupAndMoveTo (pt, 0, 0, true);
while (s.IsValid && .HasPath ())
{
  .FormKeepMoving (500);
  if (.FormPathLeft () < .FormRadius () + s.radius) break;
}

if (!s.IsValid()) return;


.army.SetCommand("stay_hidden", s);

.AddCommand(true, "unit_stay_hidden", s);
