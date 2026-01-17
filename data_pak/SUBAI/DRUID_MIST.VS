// void, Obj This, point pt

Druid this;
Sacrifice s;
int mist_range;

this = This.AsDruid();
if (!.IsValid() || .health<=.maxhealth/10) return;

mist_range = GetConst("MistRange");
while (!.Goto(pt, mist_range, 2000, false, 2500));

s = Place("Mist", pt, .player).AsSacrifice();
.PlayAnim(18, pt);

if (!s.IsValid()) return;

.AddCommand(true, "help-sacrifice", s);

