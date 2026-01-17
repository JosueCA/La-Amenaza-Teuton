// void, Obj This, point pt

Druid this;
Sacrifice s;

this = This.AsDruid();
if (!.IsValid() || .health<=.maxhealth/10) return;

while (!.Goto(pt, 350, 2000, false, 2500));

.PlayAnim(18, pt);
s = Place("Ghost_sacrifice", pt, .player).AsSacrifice();

if (!s.IsValid()) return;

.AddCommand(true, "help-sacrifice", s);

